import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/reference/dropdown_option/dropdown_option.dart';
import '../../../../../../core/reference/dropdown_options_provider/dropdown_options_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../../core/utils/formatters/formatters.dart';
import '../../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../../core/widgets/app_text_field/app_text_field.dart';
import '../../../../../../core/widgets/app_country_picker_field/app_country_picker_field.dart';
import '../../../../../../core/widgets/app_region_picker_field/app_region_picker_field.dart';
import '../../../../../../core/widgets/app_snackbar/app_snackbar.dart';
import '../../../../../../core/widgets/app_options_picker_sheet/app_options_picker_sheet.dart';
import '../../../../../../core/widgets/app_date_time_picker/app_date_time_picker.dart';
import '../../../../../../core/widgets/whatsapp_otp_verifier/whatsapp_otp_verifier.dart';
import '../../../../../../core/utils/validators/validators.dart';
import '../../../../../../core/utils/identity_document_utils/identity_document_utils.dart';
import '../../../../../../core/utils/profile_media_picker/profile_media_picker.dart';
import '../../../../../../core/utils/camera_scan_utils/camera_scan_utils.dart';
import '../../../../../../core/widgets/media_viewer/media_viewer.dart';
import '../../../../../../core/utils/country_codes/country_codes.dart';
import '../../../providers/profile_provider/profile_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../auth/presentation/widgets/auth_modals/auth_modals.dart';
import '../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';

class CompleteProfilePage extends ConsumerStatefulWidget {
  final String? scrollToSection;
  const CompleteProfilePage({super.key, this.scrollToSection});

  @override
  ConsumerState<CompleteProfilePage> createState() =>
      _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Section keys for scroll-to-section
  final _keyAvatar = GlobalKey();
  final _keyName = GlobalKey();
  final _keyUsername = GlobalKey();
  final _keyWhatsapp = GlobalKey();
  final _keyIdentity = GlobalKey();
  final _keyKtpPhoto = GlobalKey();
  final _keySelfie = GlobalKey();

  final _firstNameController = TextEditingController();
  final _midNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _ktpNumberController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _countryController = TextEditingController();
  final _addressController = TextEditingController();

  String _countryCode = '+62';
  String _identityType = 'ktp';
  bool _namesLocked = false;
  bool _whatsappVerified = false;
  String _initialWhatsapp = '';
  bool _dataLoaded = false;
  bool _saving = false;
  File? _ktpFile;
  File? _selfieFile;
  String? _faceScanPath;
  File? _avatarFile;
  Map<String, dynamic>? _ktpAiResult;
  Map<String, dynamic>? _selfieAiResult;
  Map<String, dynamic>? _faceAiResult;

  int? _provinceId;
  int? _cityId;
  int? _districtId;
  int? _villageId;
  String _provinceName = '';
  String _cityName = '';
  String _districtName = '';
  String _villageName = '';
  String _postalCode = '';
  String _gender = '';
  String _religion = '';
  String _maritalStatus = '';
  final _motherNameController = TextEditingController();
  String _occupation = '';
  String _incomeRange = '';
  String _sourceOfFunds = '';
  Map<String, List<DropdownOption>> _dropdownOptions = {};
  bool _optionsLoaded = false;

  String get _fullName => [
    _firstNameController.text.trim(),
    _midNameController.text.trim(),
    _lastNameController.text.trim(),
  ].where((s) => s.isNotEmpty).join(' ');

  /// True bila verifikasi wajah AI terakhir pada halaman ini ditolak.
  bool get _faceAiFailed => (_faceAiResult?['face_verified'] as bool?) == false;

  String _identityNumberLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp':
        return l.ktpNumberLabel;
      case 'passport':
        return l.passportLabel;
      case 'sim':
        return l.simLabel;
      case 'npwp':
        return l.npwpLabel;
      default:
        return l.identityNumber;
    }
  }

  String _idPhotoLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp':
        return l.ktpPhoto;
      case 'passport':
        return l.passportPhoto;
      case 'sim':
        return l.simPhoto;
      case 'npwp':
        return l.npwpPhoto;
      default:
        return l.identityPhoto;
    }
  }

  String _idSelfieLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp':
        return l.selfieKtp;
      case 'passport':
        return l.selfiePassport;
      case 'sim':
        return l.selfieSim;
      case 'npwp':
        return l.selfieNpwp;
      default:
        return l.selfieIdentity;
    }
  }

  String _formatBirthDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  DateTime? _parseBackendBirthDate(String? s) {
    if (s == null || s.isEmpty) return null;
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(s.trim());
    if (m == null) return null;
    return DateTime(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
    );
  }

  String _extractBirthPlace(String combined) {
    final t = combined.trim();
    final m = RegExp(r'[,\s]*\d{2}/\d{2}/\d{4}\s*$').firstMatch(t);
    if (m != null) return t.substring(0, m.start).trim();
    return t;
  }

  String? _extractBirthDate(String combined) {
    final m = RegExp(
      r'(\d{2})/(\d{2})/(\d{4})\s*$',
    ).firstMatch(combined.trim());
    if (m == null) return null;
    return '${m.group(3)}-${m.group(2)}-${m.group(1)}';
  }

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider) is! AuthAuthenticated) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = ref.read(profileProvider).userData;
      if (userData != null) {
        _firstNameController.text = userData['first_name'] as String? ?? '';
        _midNameController.text = userData['mid_name'] as String? ?? '';
        _lastNameController.text = userData['last_name'] as String? ?? '';
        _usernameController.text = userData['username'] as String? ?? '';
        _emailController.text = userData['email'] as String? ?? '';
        _birthPlaceController.text = userData['birth_place'] as String? ?? '';
        final parsedBirthDate = _parseBackendBirthDate(
          userData['birth_date'] as String?,
        );
        if (parsedBirthDate != null) {
          final bp = _birthPlaceController.text.trim();
          _birthPlaceController.text = bp.isNotEmpty
              ? '$bp, ${_formatBirthDate(parsedBirthDate)}'
              : _formatBirthDate(parsedBirthDate);
        }
        _countryController.text = userData['country'] as String? ?? '';
        _addressController.text = userData['address'] as String? ?? '';
        _provinceId = userData['province_id'] as int?;
        _cityId = userData['city_id'] as int?;
        _districtId = userData['district_id'] as int?;
        _villageId = userData['village_id'] as int?;
        _provinceName = userData['province_name'] as String? ?? '';
        _cityName = userData['city_name'] as String? ?? '';
        _districtName = userData['district_name'] as String? ?? '';
        _villageName = userData['village_name'] as String? ?? '';
        _postalCode = userData['postal_code'] as String? ?? '';
        _gender = userData['gender'] as String? ?? '';
        _religion = userData['religion'] as String? ?? '';
        _maritalStatus = userData['marital_status'] as String? ?? '';
        _motherNameController.text = userData['mother_name'] as String? ?? '';
        _occupation = userData['occupation'] as String? ?? '';
        _incomeRange = userData['income_range'] as String? ?? '';
        _sourceOfFunds = userData['source_of_funds'] as String? ?? '';

        // Parse WhatsApp
        String rawWa = (userData['whatsapp'] as String? ?? '').trim();
        _initialWhatsapp = rawWa;
        _whatsappVerified = rawWa.isNotEmpty;
        rawWa = rawWa.replaceAll(RegExp(r'[\s\-()]'), '');

        if (rawWa.startsWith('+')) {
          bool found = false;
          for (final c in countryCodes) {
            if (rawWa.startsWith(c.dialCode)) {
              _countryCode = c.dialCode;
              _whatsappController.text = rawWa.substring(c.dialCode.length);
              found = true;
              break;
            }
          }
          if (!found) {
            _whatsappController.text = rawWa;
          }
        } else if (rawWa.startsWith('62')) {
          _countryCode = '+62';
          _whatsappController.text = rawWa.substring(2);
        } else if (rawWa.startsWith('0')) {
          _countryCode = '+62';
          _whatsappController.text = rawWa.substring(1);
        } else {
          _countryCode = '+62';
          _whatsappController.text = rawWa;
        }

        // Identity type
        final identityType = userData['identity_type'] as String?;
        if (identityType != null &&
            ['ktp', 'passport', 'sim', 'npwp'].contains(identityType)) {
          _identityType = identityType;
          if (identityType == 'passport') {
            _ktpNumberController.text =
                userData['passport_number'] as String? ?? '';
          } else if (identityType == 'sim') {
            _ktpNumberController.text = userData['sim_number'] as String? ?? '';
          } else if (identityType == 'npwp') {
            _ktpNumberController.text =
                userData['npwp_number'] as String? ?? '';
          } else {
            _ktpNumberController.text = userData['ktp_number'] as String? ?? '';
          }
          _namesLocked = true;
        } else {
          _ktpNumberController.text = userData['ktp_number'] as String? ?? '';
          if (_ktpNumberController.text.isNotEmpty) _namesLocked = true;
        }
      }

      // Auto-scroll to section
      final section = widget.scrollToSection;
      if (section != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 400), () {
            final key = _sectionKey(section);
            if (key?.currentContext != null) {
              Scrollable.ensureVisible(
                key!.currentContext!,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                alignment: 0.0,
              );
            }
          });
        });
      }
      _dataLoaded = true;
      if (mounted) setState(() {});
    });
    // Fallback: jika profil belum dimuat (mis. baru selesai registrasi), isi
    // email dari akun terautentikasi agar tidak terkirim kosong ke backend.
    if (_emailController.text.trim().isEmpty) {
      final auth = ref.read(authProvider);
      if (auth is AuthAuthenticated && auth.user.email.isNotEmpty) {
        _emailController.text = auth.user.email;
        if (mounted) setState(() {});
      }
    }
  }

  GlobalKey? _sectionKey(String section) {
    switch (section) {
      case 'avatar':
        return _keyAvatar;
      case 'name':
        return _keyName;
      case 'username':
        return _keyUsername;
      case 'whatsapp':
        return _keyWhatsapp;
      case 'identity':
        return _keyIdentity;
      case 'ktp_photo':
        return _keyKtpPhoto;
      case 'selfie':
        return _keySelfie;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _midNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _ktpNumberController.dispose();
    _birthPlaceController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _motherNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final file = await pickProfileMedia(context);
    if (file != null) {
      setState(() => _avatarFile = file);
    }
  }

  Future<void> _pickKtpImage() async {
    // Langsung buka kamera dengan panduan bingkai kartu (persegi panjang)
    // untuk dokumen identitas KTP/SIM/NPWP/Paspor.
    final l = AppLocalizations.of(context)!;
    final file = await scanWithCamera(
      context,
      type: scanContentTypeForIdentity(_identityType),
    );
    if (file == null) return;
    setState(() {
      _ktpFile = file;
      _ktpAiResult = null;
    });
    if (isVideoPath(file.path)) return;
    final ktpData = await extractIdentityData(file, _identityType);
    setState(() {
      // Nomor identitas
      if (ktpData.number.isNotEmpty) {
        _ktpNumberController.text = ktpData.number;
      }
      // Nama (hanya jika belum dikunci dari OCR/backend)
      if (ktpData.name.isNotEmpty && !_namesLocked) {
        final parts = ktpData.name.trim().split(RegExp(r'\s+'));
        _firstNameController.text = parts.isNotEmpty ? parts[0] : '';
        _midNameController.text = parts.length > 2
            ? parts.sublist(1, parts.length - 1).join(' ')
            : '';
        _lastNameController.text = parts.length > 1 ? parts.last : '';
        _namesLocked = true;
      }
      // Tempat & tanggal lahir (format: "Tempat, dd/mm/yyyy")
      if (ktpData.birthPlaceCombo.isNotEmpty &&
          _birthPlaceController.text.trim().isEmpty) {
        _birthPlaceController.text = ktpData.birthPlaceCombo;
      }
      // Dropdown KYC: hanya diisi bila belum terpilih
      if (_gender.isEmpty) {
        _gender = matchOcrToDropdownLabel(
          'gender',
          ktpData.gender,
          _optLabels('gender', [l.male, l.female]),
        );
      }
      if (_religion.isEmpty) {
        _religion = matchOcrToDropdownLabel(
          'religion',
          ktpData.religion,
          _optLabels('religion', [
            l.islam,
            l.christian,
            l.catholic,
            l.hindu,
            l.buddha,
            l.confucian,
          ]),
        );
      }
      if (_maritalStatus.isEmpty) {
        _maritalStatus = matchOcrToDropdownLabel(
          'marital_status',
          ktpData.maritalStatus,
          _optLabels('marital_status', [l.single, l.married, l.divorced]),
        );
      }
      if (_occupation.isEmpty) {
        _occupation = matchOcrToDropdownLabel(
          'occupation',
          ktpData.occupation,
          _optLabels('occupation', [
            l.employee,
            l.entrepreneur,
            l.student,
            l.housewife,
            l.professional,
            l.other,
          ]),
        );
      }
      // Alamat
      if (ktpData.address.isNotEmpty &&
          _addressController.text.trim().isEmpty) {
        _addressController.text = ktpData.address;
      }
    });
  }

  Future<void> _pickSelfie() async {
    // Langsung buka kamera depan dengan panduan oval wajah + bingkai kartu
    // identitas (KTP/SIM/NPWP/Paspor) yang dipegang bersama wajah.
    final l = AppLocalizations.of(context)!;
    final file = await scanSelfieWithDocument(context, docType: _identityType);
    if (file == null) return;
    setState(() {
      _selfieFile = file;
      _selfieAiResult = null;
    });
    if (isVideoPath(file.path)) return;
    final ktpData = await extractIdentityData(file, _identityType);
    setState(() {
      if (ktpData.number.isNotEmpty &&
          _ktpNumberController.text.trim().isEmpty) {
        _ktpNumberController.text = ktpData.number;
      }
      if (ktpData.name.isNotEmpty && !_namesLocked) {
        final parts = ktpData.name.trim().split(RegExp(r'\s+'));
        _firstNameController.text = parts.isNotEmpty ? parts[0] : '';
        _midNameController.text = parts.length > 2
            ? parts.sublist(1, parts.length - 1).join(' ')
            : '';
        _lastNameController.text = parts.length > 1 ? parts.last : '';
        _namesLocked = true;
      }
      if (ktpData.birthPlaceCombo.isNotEmpty &&
          _birthPlaceController.text.trim().isEmpty) {
        _birthPlaceController.text = ktpData.birthPlaceCombo;
      }
      if (_gender.isEmpty) {
        _gender = matchOcrToDropdownLabel(
          'gender',
          ktpData.gender,
          _optLabels('gender', [l.male, l.female]),
        );
      }
      if (_religion.isEmpty) {
        _religion = matchOcrToDropdownLabel(
          'religion',
          ktpData.religion,
          _optLabels('religion', [
            l.islam,
            l.christian,
            l.catholic,
            l.hindu,
            l.buddha,
            l.confucian,
          ]),
        );
      }
      if (_maritalStatus.isEmpty) {
        _maritalStatus = matchOcrToDropdownLabel(
          'marital_status',
          ktpData.maritalStatus,
          _optLabels('marital_status', [l.single, l.married, l.divorced]),
        );
      }
      if (_occupation.isEmpty) {
        _occupation = matchOcrToDropdownLabel(
          'occupation',
          ktpData.occupation,
          _optLabels('occupation', [
            l.employee,
            l.entrepreneur,
            l.student,
            l.housewife,
            l.professional,
            l.other,
          ]),
        );
      }
      if (ktpData.address.isNotEmpty &&
          _addressController.text.trim().isEmpty) {
        _addressController.text = ktpData.address;
      }
    });
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final whatsappValue = _whatsappController.text.trim();
    if (whatsappValue.isNotEmpty && !_whatsappVerified) {
      AppSnackBar.show(
        context,
        l.whatsappVerifyRequired,
        type: SnackBarType.warning,
      );
      return;
    }

    final pState = ref.read(profileProvider);
    final userData = pState.userData;
    final profileNotifier = ref.read(profileProvider.notifier);

    final data = <String, dynamic>{
      'first_name': _firstNameController.text.trim(),
      'mid_name': _midNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'full_name': _fullName,
      'username': _usernameController.text.trim(),
      'whatsapp': '$_countryCode ${_whatsappController.text.trim()}',
      'identity_type': _identityType,
      'birth_place': _extractBirthPlace(_birthPlaceController.text),
      'birth_date': _extractBirthDate(_birthPlaceController.text),
      'country': _countryController.text.trim(),
      'address': _addressController.text.trim(),
    };
    final emailValue = _emailController.text.trim();
    if (emailValue.isNotEmpty) data['email'] = emailValue;
    if (_identityType == 'ktp') {
      data['ktp_number'] = _ktpNumberController.text.trim();
    }
    if (_identityType == 'passport') {
      data['passport_number'] = _ktpNumberController.text.trim();
    }
    if (_identityType == 'sim') {
      data['sim_number'] = _ktpNumberController.text.trim();
    }
    if (_identityType == 'npwp') {
      data['npwp_number'] = _ktpNumberController.text.trim();
    }
    if (_provinceId != null) data['province_id'] = _provinceId;
    if (_cityId != null) data['city_id'] = _cityId;
    if (_districtId != null) data['district_id'] = _districtId;
    if (_villageId != null) data['village_id'] = _villageId;
    if (_provinceName.isNotEmpty) data['province_name'] = _provinceName;
    if (_cityName.isNotEmpty) data['city_name'] = _cityName;
    if (_districtName.isNotEmpty) data['district_name'] = _districtName;
    if (_villageName.isNotEmpty) data['village_name'] = _villageName;
    if (_postalCode.isNotEmpty) data['postal_code'] = _postalCode;
    if (_gender.isNotEmpty) data['gender'] = _gender;
    if (_religion.isNotEmpty) data['religion'] = _religion;
    if (_maritalStatus.isNotEmpty) data['marital_status'] = _maritalStatus;
    if (_motherNameController.text.trim().isNotEmpty) {
      data['mother_name'] = _motherNameController.text.trim();
    }
    if (_occupation.isNotEmpty) data['occupation'] = _occupation;
    if (_incomeRange.isNotEmpty) data['income_range'] = _incomeRange;
    if (_sourceOfFunds.isNotEmpty) data['source_of_funds'] = _sourceOfFunds;

    setState(() => _saving = true);

    try {
      await profileNotifier.updateProfile(data);

      if (_avatarFile != null) {
        final newAvatarUrl = await profileNotifier.uploadAvatar(
          _avatarFile!.path,
        );
        if (newAvatarUrl != null) {
          ref.read(authProvider.notifier).updateAvatarDirect(newAvatarUrl);
        }
      }
      if (_ktpFile != null) {
        final ktpResult = await profileNotifier.uploadKtp(_ktpFile!.path);
        if (ktpResult != null && mounted) {
          setState(() => _ktpAiResult = ktpResult);
          final ktpOk = (ktpResult['ktp_ai_verified'] as bool?) ?? false;
          final reason = (ktpResult['ktp_ai_reason'] as String?) ?? '';
          if (!ktpOk && reason.isNotEmpty && reason != 'AI_UNAVAILABLE') {
            AppSnackBar.show(
              context,
              l.aiVerificationFailed,
              type: SnackBarType.warning,
            );
          } else if (!ktpOk) {
            AppSnackBar.show(
              context,
              l.aiUnavailable,
              type: SnackBarType.warning,
            );
          }
        }
      }
      if (_selfieFile != null) {
        final selfieResult = await profileNotifier.uploadSelfie(
          _selfieFile!.path,
        );
        if (selfieResult != null && mounted) {
          setState(() => _selfieAiResult = selfieResult);
        }
      }
      if (_faceScanPath != null) {
        final faceResult = await profileNotifier.uploadFaceScan(
          _faceScanPath!,
          livenessCompleted: true,
        );
        if (faceResult != null && mounted) {
          setState(() => _faceAiResult = faceResult);
        }
      }

      // Jika ada file yang dipilih tetapi upload gagal, jangan lanjut.
      final uploadFailed =
          (_ktpFile != null && _ktpAiResult == null) ||
          (_selfieFile != null && _selfieAiResult == null) ||
          (_faceScanPath != null && _faceAiResult == null);
      if (uploadFailed) {
        if (mounted) {
          AppSnackBar.show(
            context,
            l.profileUpdateFailed,
            type: SnackBarType.error,
          );
        }
        return;
      }

      // Gate verifikasi AI: wajah yang tidak cocok memblokir keluar dari halaman.
      final faceResult = _faceAiResult ?? _selfieAiResult;
      final faceVerified = (faceResult?['face_verified'] as bool?) ?? true;
      if (faceResult != null && !faceVerified) {
        final similarity = (faceResult['similarity'] as num?)?.toDouble();
        if (mounted) {
          await _showFaceMismatchDialog(
            similarity: similarity,
            reason: faceResult['face_reason'] as String?,
          );
        }
        return;
      }

      // Cek apakah email berubah → kirim OTP verifikasi
      final oldEmail = userData?['email'] as String? ?? '';
      final newEmail = _emailController.text.trim();
      final emailChanged =
          newEmail.isNotEmpty &&
          newEmail.toLowerCase() != oldEmail.toLowerCase();
      if (emailChanged) {
        try {
          await DioClient.instance.post(
            '/auth/send-otp',
            data: {'email': newEmail, 'purpose': 'verify_email'},
          );
          if (mounted) {
            AppSnackBar.show(
              context,
              l.profileSavedVerifyEmail,
              type: SnackBarType.success,
            );
            showOtpVerificationSheet(
              context,
              email: newEmail,
              purpose: 'verify_email',
            );
          }
        } catch (_) {
          if (mounted) {
            AppSnackBar.show(
              context,
              l.profileSavedFailedSendOtp,
              type: SnackBarType.warning,
            );
            context.go('/home');
          }
        }
      } else {
        if (mounted) {
          AppSnackBar.show(
            context,
            l.profileUpdated,
            type: SnackBarType.success,
          );
          context.go('/home');
        }
      }
    } catch (e) {
      if (mounted) {
        final msg = _extractError(e) ?? l.profileUpdateFailed;
        AppSnackBar.show(context, msg, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showFaceMismatchDialog({
    double? similarity,
    String? reason,
  }) async {
    final l = AppLocalizations.of(context)!;
    final similarityText = similarity != null
        ? l.faceMatchPercent.replaceFirst('%s', similarity.toStringAsFixed(1))
        : null;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(
          Icons.error_outline,
          color: AppColors.errorColor,
          size: 40,
        ),
        title: Text(l.faceMismatch, textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (similarityText != null) ...[
              Text(
                l.aiComputerVision,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                similarityText,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(l.faceMismatchMessage, style: AppTextStyles.bodySmall),
            if (reason != null && reason.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                reason,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.retake),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _faceScanPath = null;
        _faceAiResult = null;
      });
      final path = await context.push<String>('/face-scanner');
      if (path != null && mounted) {
        setState(() => _faceScanPath = path);
      }
    }
  }

  void _showDropdown(
    BuildContext fieldContext,
    String title,
    List<String> options,
    String currentValue,
    Function(String) onSelected,
  ) {
    showAppOptionsPicker(
      fieldContext,
      title: title,
      options: options,
      currentValue: currentValue,
      onSelected: onSelected,
    );
  }

  List<String> _countryCodeOptions() =>
      countryCodes.map((c) => '${c.flag} ${c.name} (${c.dialCode})').toList();

  String _countryCodeLabel() {
    for (final c in countryCodes) {
      if (c.dialCode == _countryCode) {
        return '${c.flag} ${c.name} (${c.dialCode})';
      }
    }
    return _countryCode;
  }

  String? _dialCodeFromOption(String option) {
    for (final c in countryCodes) {
      if ('${c.flag} ${c.name} (${c.dialCode})' == option) return c.dialCode;
    }
    return null;
  }

  List<String> _optLabels(String type, List<String> fallback) {
    return _dropdownOptions[type]?.map((o) => o.label).toList() ?? fallback;
  }

  Widget _buildSectionHeader(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: AppColors.primaryColor),
            ),
            const SizedBox(width: 8),
          ],
          Text(title, style: AppTextStyles.titleSmall),
        ],
      ),
    );
  }

  Widget _buildIdentityTypePicker() {
    final l = AppLocalizations.of(context)!;
    final options = [l.ktpNumberShort, l.passport, l.simShort, l.npwpShort];
    final currentLabel = switch (_identityType) {
      'ktp' => l.ktpNumberShort,
      'passport' => l.passport,
      'sim' => l.simShort,
      'npwp' => l.npwpShort,
      _ => l.selectIdentityType,
    };
    final icon = switch (_identityType) {
      'ktp' => Icons.badge_outlined,
      'passport' => Icons.book_outlined,
      'sim' => Icons.drive_eta_outlined,
      'npwp' => Icons.receipt_long_outlined,
      _ => Icons.badge_outlined,
    };
    return Builder(
      builder: (fieldCtx) => GestureDetector(
        onTap: () => _showDropdown(
          fieldCtx,
          l.selectIdentityType,
          options,
          currentLabel,
          (v) {
            setState(() {
              if (v == l.passport) {
                _identityType = 'passport';
              } else if (v == l.simShort) {
                _identityType = 'sim';
              } else if (v == l.npwpShort) {
                _identityType = 'npwp';
              } else {
                _identityType = 'ktp';
              }
              _ktpFile = null;
            });
          },
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 22),
              SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  currentLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required GlobalKey boxKey,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool hasFile,
    required VoidCallback onTap,
    VoidCallback? onRemove,
  }) {
    return KeyedSubtree(
      key: boxKey,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: hasFile
                ? AppColors.successColor.withAlpha(20)
                : AppColors.secondaryColor.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasFile ? AppColors.successColor : AppColors.dividerColor,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                hasFile ? Icons.check_circle : icon,
                color: hasFile
                    ? AppColors.successColor
                    : AppColors.textSecondary,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: hasFile
                            ? AppColors.successColor
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasFile && onRemove != null)
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menampilkan hasil verifikasi AI (Computer Vision) setelah upload dokumen/selfie/face-scan.
  Widget _buildAiStatusChip({
    required AppLocalizations l,
    required bool uploading,
    Map<String, dynamic>? result,
  }) {
    if (uploading) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text(
              l.verifying,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    if (result == null) return const SizedBox.shrink();

    final isFace = result.containsKey('face_verified');
    final verified =
        (result['face_verified'] as bool?) ??
        (result['ktp_ai_verified'] as bool?) ??
        false;
    final similarity = (result['similarity'] as num?)?.toDouble();
    final reason =
        (result['face_reason'] as String?) ??
        (result['ktp_ai_reason'] as String?);
    final isUnavailable = reason == 'AI_UNAVAILABLE';

    final color = verified
        ? AppColors.successColor
        : (isUnavailable ? AppColors.warningColor : AppColors.errorColor);
    final icon = verified
        ? Icons.verified_outlined
        : (isUnavailable ? Icons.cloud_off_outlined : Icons.error_outline);

    String text;
    if (isFace) {
      text = verified
          ? (similarity != null
                ? l.faceMatchPercent.replaceFirst(
                    '%s',
                    similarity.toStringAsFixed(1),
                  )
                : l.aiVerified)
          : (isUnavailable ? l.aiUnavailable : l.faceMismatch);
    } else {
      text = verified
          ? l.aiVerifiedDocument
          : (isUnavailable ? l.aiUnavailable : l.aiVerificationFailed);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (ref.watch(authProvider) is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.completeProfile),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const GuestAuthPrompt(icon: Icons.person_outline),
      );
    }
    final pState = ref.watch(profileProvider);
    final userData = pState.userData;
    final ktpUrl = pState.ktpUrl ?? userData?['ktp_photo_url'] as String?;
    final selfieUrl =
        pState.selfieUrl ?? userData?['selfie_photo_url'] as String?;
    final avatarUrl = Formatters.avatarUrl(pState.userData);
    final completionPercent = pState.completionPercent;

    if (!_optionsLoaded) {
      ref.read(dropdownOptionsProvider.future).then((opts) {
        if (mounted) {
          setState(() {
            _dropdownOptions = opts;
            _optionsLoaded = true;
          });
        }
      });
    }

    // Flags untuk menentukan field apa yang perlu diisi
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final needsName = firstName.isEmpty && lastName.isEmpty;
    final needsAvatar = avatarUrl == null && _avatarFile == null;
    final needsWhatsapp = _initialWhatsapp.trim().isEmpty;
    final needsKtpNumber = _ktpNumberController.text.trim().isEmpty;
    final needsBirthPlace = _birthPlaceController.text.trim().isEmpty;
    final needsCountry = _countryController.text.trim().isEmpty;
    final needsProvince = _provinceName.isEmpty;
    final needsCity = _cityName.isEmpty;
    final needsDistrict = _districtName.isEmpty;
    final needsVillage = _villageName.isEmpty;
    final needsPostalCode = _postalCode.isEmpty;
    final needsAddress = _addressController.text.trim().isEmpty;
    final needsKtp = ktpUrl == null && _ktpFile == null;
    final needsSelfie = selfieUrl == null && _selfieFile == null;
    final needsGender = _gender.isEmpty;
    final needsReligion = _religion.isEmpty;
    final needsMaritalStatus = _maritalStatus.isEmpty;
    final needsMotherName = _motherNameController.text.trim().isEmpty;
    final needsOccupation = _occupation.isEmpty;
    final needsIncomeRange = _incomeRange.isEmpty;
    final needsSourceOfFunds = _sourceOfFunds.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(l.completeProfile),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (completionPercent > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '$completionPercent%',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: completionPercent >= 80
                        ? Colors.green
                        : (completionPercent >= 50
                              ? Colors.orange
                              : AppColors.primaryColor),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: completionPercent / 100,
                  minHeight: 8,
                  backgroundColor: AppColors.secondaryColor.withAlpha(50),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    completionPercent >= 80
                        ? Colors.green
                        : (completionPercent >= 50
                              ? Colors.orange
                              : AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l.completeAllDataForVerification,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // ── Foto Profil ──────────────────────────────────────────────
              KeyedSubtree(
                key: _keyAvatar,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      l.profilePhoto,
                      icon: Icons.account_circle_outlined,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: _pickAvatar,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: AppColors.secondaryColor
                                  .withAlpha(60),
                              backgroundImage:
                                  (!(_avatarFile != null &&
                                          isVideoPath(_avatarFile!.path)) &&
                                      _avatarFile != null)
                                  ? FileImage(_avatarFile!)
                                  : (avatarUrl != null
                                            ? CachedNetworkImageProvider(
                                                avatarUrl,
                                              )
                                            : null)
                                        as ImageProvider?,
                              child:
                                  (_avatarFile != null &&
                                      isVideoPath(_avatarFile!.path))
                                  ? Icon(
                                      Icons.videocam,
                                      size: 48,
                                      color: AppColors.textTertiary,
                                    )
                                  : (_avatarFile == null && avatarUrl == null)
                                  ? Icon(
                                      Icons.person,
                                      size: 48,
                                      color: AppColors.textTertiary,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (needsAvatar) ...[
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          l.tapToUploadProfilePhoto,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.md),

              // ── Nama ─────────────────────────────────────────────────────
              if (needsName) ...[
                KeyedSubtree(
                  key: _keyName,
                  child: _buildSectionHeader(
                    l.fullName,
                    icon: Icons.person_outline_rounded,
                  ),
                ),
                AppTextField(
                  label: l.firstName,
                  controller: _firstNameController,
                  readOnly: _namesLocked,
                  validator: Validators.required,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSizes.sm),
                AppTextField(
                  label: l.middleName,
                  controller: _midNameController,
                  readOnly: _namesLocked,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSizes.sm),
                AppTextField(
                  label: l.lastName,
                  controller: _lastNameController,
                  readOnly: _namesLocked,
                  validator: Validators.required,
                  onChanged: (_) => setState(() {}),
                ),
                if (_fullName.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.successColor.withAlpha(15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.successColor.withAlpha(60),
                      ),
                    ),
                    child: Text(
                      '${l.fullName}: $_fullName',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.md),
              ] else
                SizedBox(key: _keyName),

              // ── Username ──────────────────────────────────────────────────
              KeyedSubtree(
                key: _keyUsername,
                child: _buildSectionHeader(
                  l.username,
                  icon: Icons.alternate_email_rounded,
                ),
              ),
              AppTextField(
                label: l.username,
                controller: _usernameController,
                validator: Validators.required,
              ),
              const SizedBox(height: AppSizes.md),

              // ── WhatsApp ──────────────────────────────────────────────────
              if (needsWhatsapp && _dataLoaded) ...[
                KeyedSubtree(
                  key: _keyWhatsapp,
                  child: _buildSectionHeader(
                    l.whatsappNumber,
                    icon: Icons.phone_outlined,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Builder(
                    builder: (fieldCtx) => TextFormField(
                      controller: _whatsappController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: Validators.phone,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        labelText: l.whatsappNumber,
                        labelStyle: AppTextStyles.titleSmall,
                        prefix: GestureDetector(
                          onTap: () => _showDropdown(
                            fieldCtx,
                            l.selectCountryCode,
                            _countryCodeOptions(),
                            _countryCodeLabel(),
                            (v) {
                              final code = _dialCodeFromOption(v);
                              if (code != null) {
                                setState(() => _countryCode = code);
                              }
                            },
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  flagFromDialCode(_countryCode) ?? '',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _countryCode,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                WhatsappOtpVerifier(
                  numberController: _whatsappController,
                  countryCode: _countryCode,
                  initialFullNumber: _initialWhatsapp,
                  minDigits: 10,
                  onVerifiedChanged: (v) {
                    if (_whatsappVerified != v) {
                      setState(() => _whatsappVerified = v);
                    }
                  },
                ),
                const SizedBox(height: AppSizes.md),
              ] else
                SizedBox(key: _keyWhatsapp),

              // ── Identitas & Alamat ────────────────────────────────────────
              KeyedSubtree(
                key: _keyIdentity,
                child: _buildSectionHeader(
                  l.identityAndAddress,
                  icon: Icons.badge_outlined,
                ),
              ),

              _buildSectionHeader(l.selectIdentityType),
              _buildIdentityTypePicker(),
              const SizedBox(height: AppSizes.sm),

              // ── Dokumen Identitas ─────────────────────────────────────────
              if (needsKtp) ...[
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(
                  l.identityDocuments,
                  icon: Icons.credit_card_outlined,
                ),
                _buildUploadBox(
                  boxKey: _keyKtpPhoto,
                  icon: Icons.credit_card_outlined,
                  title: _idPhotoLabel(l),
                  subtitle: _ktpFile != null
                      ? l.labelSelected(_idPhotoLabel(l))
                      : l.autoScanHint,
                  hasFile: _ktpFile != null || ktpUrl != null,
                  onTap: _pickKtpImage,
                  onRemove: _ktpFile != null
                      ? () => setState(() => _ktpFile = null)
                      : null,
                ),
                _buildAiStatusChip(
                  l: l,
                  uploading: pState.ktpUploading,
                  result: _ktpAiResult,
                ),
                const SizedBox(height: AppSizes.sm),
              ] else
                SizedBox(key: _keyKtpPhoto),

              if (needsSelfie) ...[
                _buildUploadBox(
                  boxKey: _keySelfie,
                  icon: Icons.face_outlined,
                  title: _idSelfieLabel(l),
                  subtitle: _selfieFile != null
                      ? l.labelSelected(_idSelfieLabel(l))
                      : l.autoScanHint,
                  hasFile: _selfieFile != null || selfieUrl != null,
                  onTap: _pickSelfie,
                  onRemove: _selfieFile != null
                      ? () => setState(() => _selfieFile = null)
                      : null,
                ),
                _buildAiStatusChip(
                  l: l,
                  uploading: pState.selfieUploading,
                  result: _selfieAiResult,
                ),
                const SizedBox(height: AppSizes.sm),
              ] else
                SizedBox(key: _keySelfie),

              if (needsKtpNumber) ...[
                const SizedBox(height: AppSizes.md),
                AppTextField(
                  label: _identityNumberLabel(l),
                  controller: _ktpNumberController,
                  keyboardType: _identityType == 'ktp'
                      ? TextInputType.number
                      : TextInputType.text,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l.identityNumberRequired(_identityNumberLabel(l));
                    }
                    if (_identityType == 'ktp' && v.trim().length != 16) {
                      return l.ktpNumberMustBe16Digits;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              if (needsBirthPlace) ...[
                Builder(
                  builder: (fieldCtx) => AppTextField(
                    label: l.placeAndDateOfBirth,
                    controller: _birthPlaceController,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today, size: 20),
                      onPressed: () async {
                        final picked = await showAppDatePicker(
                          context: fieldCtx,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          final formatted = _formatBirthDate(picked);
                          _birthPlaceController.text =
                              '${_birthPlaceController.text.trim()}, $formatted';
                          _birthPlaceController.selection =
                              TextSelection.fromPosition(
                                TextPosition(
                                  offset:
                                      _birthPlaceController.text.length,
                                ),
                              );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              if (needsCountry) ...[
                AppCountryPickerField(
                  label: l.country,
                  controller: _countryController,
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              if (needsProvince ||
                  needsCity ||
                  needsDistrict ||
                  needsVillage ||
                  needsPostalCode) ...[
                AppRegionPickerField(
                  country: _countryController.text.isEmpty
                      ? null
                      : _countryController.text,
                  initialProvinceId: _provinceId,
                  initialCityId: _cityId,
                  initialDistrictId: _districtId,
                  initialVillageId: _villageId,
                  initialProvinceName: _provinceName,
                  initialCityName: _cityName,
                  initialDistrictName: _districtName,
                  initialVillageName: _villageName,
                  initialPostalCode: _postalCode,
                  onProvinceIdChanged: (v) {
                    _provinceId = v;
                  },
                  onCityIdChanged: (v) {
                    _cityId = v;
                  },
                  onDistrictIdChanged: (v) {
                    _districtId = v;
                  },
                  onVillageIdChanged: (v) {
                    _villageId = v;
                  },
                  onProvinceNameChanged: (v) {
                    _provinceName = v;
                  },
                  onCityNameChanged: (v) {
                    _cityName = v;
                  },
                  onDistrictNameChanged: (v) {
                    _districtName = v;
                  },
                  onVillageNameChanged: (v) {
                    _villageName = v;
                  },
                  onPostalCodeChanged: (v) {
                    _postalCode = v;
                  },
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              if (needsAddress) ...[
                AppTextField(
                  label: l.fullAddress,
                  controller: _addressController,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              const SizedBox(height: AppSizes.md),

              // ── Data KYC ────────────────────────────────────────────────
              if (needsGender) ...[
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.gender, icon: Icons.people_outlined),
                Builder(
                  builder: (fieldCtx) => GestureDetector(
                    onTap: () => _showDropdown(
                      fieldCtx,
                      l.selectGender,
                      _optLabels('gender', [l.male, l.female]),
                      _gender,
                      (v) => setState(() => _gender = v),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people_outlined,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                          SizedBox(width: AppSizes.md),
                          Expanded(
                            child: Text(
                              _gender.isEmpty ? l.selectGender : _gender,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsReligion) ...[
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.religion, icon: Icons.church_outlined),
                Builder(
                  builder: (fieldCtx) => GestureDetector(
                    onTap: () => _showDropdown(
                      fieldCtx,
                      l.selectReligion,
                      _optLabels('religion', [
                        l.islam,
                        l.christian,
                        l.catholic,
                        l.hindu,
                        l.buddha,
                        l.confucian,
                      ]),
                      _religion,
                      (v) => setState(() => _religion = v),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.church_outlined,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                          SizedBox(width: AppSizes.md),
                          Expanded(
                            child: Text(
                              _religion.isEmpty ? l.selectReligion : _religion,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsMaritalStatus) ...[
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(
                  l.maritalStatus,
                  icon: Icons.favorite_border,
                ),
                Builder(
                  builder: (fieldCtx) => GestureDetector(
                    onTap: () => _showDropdown(
                      fieldCtx,
                      l.selectMaritalStatus,
                      _optLabels('marital_status', [
                        l.single,
                        l.married,
                        l.divorced,
                      ]),
                      _maritalStatus,
                      (v) => setState(() => _maritalStatus = v),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                          SizedBox(width: AppSizes.md),
                          Expanded(
                            child: Text(
                              _maritalStatus.isEmpty
                                  ? l.selectMaritalStatus
                                  : _maritalStatus,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsMotherName) ...[
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.motherName, icon: Icons.woman_outlined),
                AppTextField(
                  label: l.motherName,
                  controller: _motherNameController,
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsOccupation) ...[
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.occupation, icon: Icons.work_outline),
                Builder(
                  builder: (fieldCtx) => GestureDetector(
                    onTap: () => _showDropdown(
                      fieldCtx,
                      l.selectOccupation,
                      _optLabels('occupation', [
                        l.employee,
                        l.entrepreneur,
                        l.student,
                        l.housewife,
                        l.professional,
                        l.other,
                      ]),
                      _occupation,
                      (v) => setState(() => _occupation = v),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.work_outline,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                          SizedBox(width: AppSizes.md),
                          Expanded(
                            child: Text(
                              _occupation.isEmpty
                                  ? l.selectOccupation
                                  : _occupation,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsIncomeRange) ...[
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(
                  l.incomeRange,
                  icon: Icons.trending_up_outlined,
                ),
                Builder(
                  builder: (fieldCtx) => GestureDetector(
                    onTap: () => _showDropdown(
                      fieldCtx,
                      l.selectIncomeRange,
                      _optLabels('income_range', [
                        l.lessThan1M,
                        l.range1to5M,
                        l.range5to10M,
                        l.range10to50M,
                        l.moreThan50M,
                      ]),
                      _incomeRange,
                      (v) => setState(() => _incomeRange = v),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.trending_up_outlined,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                          SizedBox(width: AppSizes.md),
                          Expanded(
                            child: Text(
                              _incomeRange.isEmpty
                                  ? l.selectIncomeRange
                                  : _incomeRange,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsSourceOfFunds) ...[
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(
                  l.sourceOfFunds,
                  icon: Icons.account_balance_wallet_outlined,
                ),
                Builder(
                  builder: (fieldCtx) => GestureDetector(
                    onTap: () => _showDropdown(
                      fieldCtx,
                      l.selectSourceOfFunds,
                      _optLabels('source_of_funds', [
                        l.salary,
                        l.business,
                        l.investment,
                        l.gift,
                        l.other,
                      ]),
                      _sourceOfFunds,
                      (v) => setState(() => _sourceOfFunds = v),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                          SizedBox(width: AppSizes.md),
                          Expanded(
                            child: Text(
                              _sourceOfFunds.isEmpty
                                  ? l.selectSourceOfFunds
                                  : _sourceOfFunds,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              // ── Verifikasi Wajah (paling bawah) ──────────────────────────
              const SizedBox(height: AppSizes.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final path = await context.push<String>('/face-scanner');
                      if (path != null) setState(() => _faceScanPath = path);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: _faceAiFailed
                            ? AppColors.errorColor.withAlpha(20)
                            : (_faceScanPath != null
                                  ? AppColors.successColor.withAlpha(20)
                                  : AppColors.secondaryColor.withAlpha(30)),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _faceAiFailed
                              ? AppColors.errorColor
                              : (_faceScanPath != null
                                    ? AppColors.successColor
                                    : AppColors.dividerColor),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _faceAiFailed
                                ? Icons.error_outline
                                : (_faceScanPath != null
                                      ? Icons.check_circle
                                      : Icons.face_retouching_natural),
                            color: _faceAiFailed
                                ? AppColors.errorColor
                                : (_faceScanPath != null
                                      ? AppColors.successColor
                                      : AppColors.textSecondary),
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.faceVerification,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _faceAiFailed
                                      ? l.faceMismatch
                                      : (_faceScanPath != null
                                            ? l.faceVerified
                                            : l.uploadFacePhotoAction),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: _faceAiFailed
                                        ? AppColors.errorColor
                                        : (_faceScanPath != null
                                              ? AppColors.successColor
                                              : AppColors.textTertiary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_faceScanPath != null)
                            GestureDetector(
                              onTap: () => setState(() {
                                _faceScanPath = null;
                                _faceAiResult = null;
                              }),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  _buildAiStatusChip(
                    l: l,
                    uploading: false,
                    result: _faceAiResult,
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.xl),

              AppButton(
                label: l.saveAndContinue,
                loading: _saving,
                onPressed: _save,
                type: ButtonType.primary,
              ),
              const SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }

  /// Extracts a user-friendly error message from an exception (e.g. DioException).
  static String? _extractError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final errors = data['errors'] as Map<String, dynamic>?;
        if (errors != null && errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final fieldErrors = errors[firstKey];
          if (fieldErrors is List && fieldErrors.isNotEmpty) {
            return fieldErrors.first.toString();
          }
        }
        final msg = data['message'] as String?;
        if (msg != null && msg.isNotEmpty) return msg;
      }
    }
    return null;
  }
}
