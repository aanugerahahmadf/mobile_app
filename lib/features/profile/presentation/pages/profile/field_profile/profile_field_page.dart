import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/reference/dropdown_option/dropdown_option.dart';
import '../../../../../../core/reference/dropdown_options_provider/dropdown_options_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
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
import '../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';

/// Halaman khusus untuk melengkapi SATU field/data profil.
/// [fieldKey] menentukan field apa yang ditampilkan.
class ProfileFieldPage extends ConsumerStatefulWidget {
  final String fieldKey;
  const ProfileFieldPage({super.key, required this.fieldKey});

  @override
  ConsumerState<ProfileFieldPage> createState() => _ProfileFieldPageState();
}

class _ProfileFieldPageState extends ConsumerState<ProfileFieldPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _midNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _ktpNumberController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _countryController = TextEditingController();
  final _emailController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _motherNameController = TextEditingController();

  String _countryCode = '+62';
  String _gender = '';
  String _religion = '';
  String _maritalStatus = '';
  String _occupation = '';
  String _incomeRange = '';
  String _sourceOfFunds = '';
  Map<String, List<DropdownOption>> _dropdownOptions = {};
  bool _optionsLoaded = false;
  String _identityType = 'ktp';
  bool _namesLocked = false;
  bool _whatsappVerified = false;
  String _initialWhatsapp = '';
  bool _dataLoaded = false;
  bool _saving = false;
  File? _avatarFile;
  File? _ktpFile;
  File? _selfieFile;
  File? _faceScanFile;
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

  String get _fullName => [
    _firstNameController.text.trim(),
    _midNameController.text.trim(),
    _lastNameController.text.trim(),
  ].where((s) => s.isNotEmpty).join(' ');

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

  String _pageTitle(AppLocalizations l) {
    switch (widget.fieldKey) {
      case 'full_name':
        return l.fieldFullName;
      case 'username':
        return l.fieldUsername;
      case 'avatar':
        return l.fieldAvatar;
      case 'whatsapp':
        return l.fieldWhatsapp;
      case 'ktp_number':
        return l.fieldKtpNumber;
      case 'birth':
        return l.fieldBirth;
      case 'country':
        return l.fieldCountry;
      case 'email':
        return l.fieldEmail;
      case 'region':
        return l.fieldRegion;
      case 'address':
        return l.fieldAddress;
      case 'postal_code':
        return l.fieldPostalCode;
      case 'gender':
        return l.fieldGender;
      case 'religion':
        return l.fieldReligion;
      case 'marital_status':
        return l.fieldMaritalStatus;
      case 'mother_name':
        return l.fieldMotherName;
      case 'occupation':
        return l.fieldOccupation;
      case 'income_range':
        return l.fieldIncomeRange;
      case 'source_of_funds':
        return l.fieldSourceOfFunds;
      case 'ktp_photo':
        return l.fieldKtpPhoto;
      case 'selfie':
        return l.fieldSelfie;
      case 'face_scan':
        return l.faceVerification;
      default:
        return l.fieldCompleteData;
    }
  }

  String _pageSubtitle(AppLocalizations l) {
    switch (widget.fieldKey) {
      case 'full_name':
        return l.subtitleFullName;
      case 'username':
        return l.subtitleUsername;
      case 'avatar':
        return l.subtitleAvatar;
      case 'whatsapp':
        return l.subtitleWhatsapp;
      case 'ktp_number':
        return l.subtitleKtpNumber;
      case 'birth':
        return l.subtitleBirth;
      case 'country':
        return l.subtitleCountry;
      case 'email':
        return l.subtitleEmail;
      case 'region':
        return l.subtitleRegion;
      case 'address':
        return l.subtitleAddress;
      case 'postal_code':
        return l.subtitlePostalCode;
      case 'gender':
        return l.subtitleGender;
      case 'religion':
        return l.subtitleReligion;
      case 'marital_status':
        return l.subtitleMaritalStatus;
      case 'mother_name':
        return l.subtitleMotherName;
      case 'occupation':
        return l.subtitleOccupation;
      case 'income_range':
        return l.subtitleIncomeRange;
      case 'source_of_funds':
        return l.subtitleSourceOfFunds;
      case 'ktp_photo':
        return l.subtitleKtpPhoto;
      case 'selfie':
        return l.subtitleSelfie;
      case 'face_scan':
        return l.faceScanInstruction;
      default:
        return l.subtitleCompleteData;
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
      _loadFromProfile();
      // Verifikasi wajah profil: otomatis buka scanner begitu halaman terbuka.
      if (widget.fieldKey == 'face_scan' && mounted) {
        _openFaceScanner();
      }
    });
  }

  Future<void> _openFaceScanner() async {
    final result = await context.push<String>('/face-scanner');
    if (result != null && mounted) {
      setState(() {
        _faceScanFile = File(result);
        _faceAiResult = null;
      });
    }
  }

  void _loadFromProfile() {
    final userData = ref.read(profileProvider).userData;
    if (userData == null) return;

    _firstNameController.text = userData['first_name'] as String? ?? '';
    _midNameController.text = userData['mid_name'] as String? ?? '';
    _lastNameController.text = userData['last_name'] as String? ?? '';
    _usernameController.text = userData['username'] as String? ?? '';
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
    _emailController.text = userData['email'] as String? ?? '';
    _postalCodeController.text = userData['postal_code'] as String? ?? '';
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

    // WhatsApp
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
        _ktpNumberController.text = userData['npwp_number'] as String? ?? '';
      } else {
        _ktpNumberController.text = userData['ktp_number'] as String? ?? '';
      }
      _namesLocked = true;
    } else {
      _ktpNumberController.text = userData['ktp_number'] as String? ?? '';
      if (_ktpNumberController.text.isNotEmpty) _namesLocked = true;
    }
    _dataLoaded = true;
    setState(() {});
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _midNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _whatsappController.dispose();
    _ktpNumberController.dispose();
    _birthPlaceController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _postalCodeController.dispose();
    _addressController.dispose();
    _motherNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    if (widget.fieldKey == 'whatsapp' && !_whatsappVerified) {
      AppSnackBar.show(
        context,
        l.whatsappVerifyRequired,
        type: SnackBarType.warning,
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final notifier = ref.read(profileProvider.notifier);

      switch (widget.fieldKey) {
        case 'full_name':
          await notifier.updateProfile({
            'first_name': _firstNameController.text.trim(),
            'mid_name': _midNameController.text.trim(),
            'last_name': _lastNameController.text.trim(),
            'full_name': _fullName,
          });
          break;

        case 'username':
          await notifier.updateProfile({
            'username': _usernameController.text.trim(),
          });
          break;

        case 'avatar':
          if (_avatarFile != null) {
            final newAvatarUrl = await notifier.uploadAvatar(_avatarFile!.path);
            if (newAvatarUrl != null) {
              ref.read(authProvider.notifier).updateAvatarDirect(newAvatarUrl);
            }
          }
          break;

        case 'whatsapp':
          await notifier.updateProfile({
            'whatsapp': '$_countryCode ${_whatsappController.text.trim()}',
          });
          break;

        case 'ktp_number':
          final data = <String, dynamic>{'identity_type': _identityType};
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
          await notifier.updateProfile(data);
          break;

        case 'birth':
          await notifier.updateProfile({
            'birth_place': _extractBirthPlace(_birthPlaceController.text),
            'birth_date': _extractBirthDate(_birthPlaceController.text),
          });
          break;

        case 'email':
          await notifier.updateProfile({'email': _emailController.text.trim()});
          break;

        case 'country':
          await notifier.updateProfile({
            'country': _countryController.text.trim(),
          });
          break;

        case 'region':
          final data = <String, dynamic>{};
          if (_provinceId != null) data['province_id'] = _provinceId;
          if (_cityId != null) data['city_id'] = _cityId;
          if (_districtId != null) data['district_id'] = _districtId;
          if (_villageId != null) data['village_id'] = _villageId;
          if (_provinceName.isNotEmpty) data['province_name'] = _provinceName;
          if (_cityName.isNotEmpty) data['city_name'] = _cityName;
          if (_districtName.isNotEmpty) data['district_name'] = _districtName;
          if (_villageName.isNotEmpty) data['village_name'] = _villageName;
          if (_postalCode.isNotEmpty) data['postal_code'] = _postalCode;
          await notifier.updateProfile(data);
          break;

        case 'postal_code':
          await notifier.updateProfile({
            'postal_code': _postalCodeController.text.trim(),
          });
          break;

        case 'address':
          await notifier.updateProfile({
            'address': _addressController.text.trim(),
          });
          break;

        case 'gender':
          await notifier.updateProfile({'gender': _gender});
          break;

        case 'religion':
          await notifier.updateProfile({'religion': _religion});
          break;

        case 'marital_status':
          await notifier.updateProfile({'marital_status': _maritalStatus});
          break;

        case 'mother_name':
          await notifier.updateProfile({
            'mother_name': _motherNameController.text.trim(),
          });
          break;

        case 'occupation':
          await notifier.updateProfile({'occupation': _occupation});
          break;

        case 'income_range':
          await notifier.updateProfile({'income_range': _incomeRange});
          break;

        case 'source_of_funds':
          await notifier.updateProfile({'source_of_funds': _sourceOfFunds});
          break;

        case 'ktp_photo':
          if (_ktpFile != null) {
            final result = await notifier.uploadKtp(_ktpFile!.path);
            if (result != null && mounted) {
              setState(() => _ktpAiResult = result);
            }
          }
          break;

        case 'selfie':
          if (_selfieFile != null) {
            final result = await notifier.uploadSelfie(_selfieFile!.path);
            if (result != null && mounted) {
              setState(() => _selfieAiResult = result);
            }
          }
          break;

        case 'face_scan':
          if (_faceScanFile != null) {
            final result = await notifier.uploadFaceScan(
              _faceScanFile!.path,
              livenessCompleted: true,
            );
            if (result != null && mounted) {
              setState(() => _faceAiResult = result);
            }
          }
          break;
      }

      // Jika file dipilih tetapi upload gagal, jangan lanjut.
      final uploadFailed =
          (widget.fieldKey == 'ktp_photo' &&
              _ktpFile != null &&
              _ktpAiResult == null) ||
          (widget.fieldKey == 'selfie' &&
              _selfieFile != null &&
              _selfieAiResult == null) ||
          (widget.fieldKey == 'face_scan' &&
              _faceScanFile != null &&
              _faceAiResult == null);
      if (uploadFailed) {
        if (mounted) {
          AppSnackBar.show(context, l.failedSaveData, type: SnackBarType.error);
        }
        return;
      }

      // Gate verifikasi AI: wajah yang tidak cocok memblokir penyimpanan.
      final faceResult = _faceAiResult ?? _selfieAiResult;
      final faceVerified = (faceResult?['face_verified'] as bool?) ?? true;
      if (faceResult != null && !faceVerified) {
        if (mounted) {
          await _showFaceMismatchDialog(
            similarity: (faceResult['similarity'] as num?)?.toDouble(),
            reason: faceResult['face_reason'] as String?,
          );
        }
        return;
      }

      if (mounted) {
        AppSnackBar.show(
          context,
          l.dataSavedSuccess,
          type: SnackBarType.success,
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final msg = _extractError(e) ?? l.failedSaveData;
        AppSnackBar.show(context, msg, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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

  Future<void> _showFaceMismatchDialog({
    double? similarity,
    String? reason,
  }) async {
    final l = AppLocalizations.of(context)!;
    final similarityText = similarity != null
        ? l.faceMatchPercent.replaceFirst('%s', similarity.toStringAsFixed(1))
        : null;

    await showDialog<void>(
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
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.retake),
          ),
        ],
      ),
    );
  }

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

  // ── Pick KTP/Selfie ───────────────────────────────────────────────────────

  Future<void> _pickKtp() async {
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
      if (ktpData.number.isNotEmpty) {
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

  Future<void> _pickAvatar() async {
    final file = await pickProfileMedia(context);
    if (file != null) setState(() => _avatarFile = file);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (ref.watch(authProvider) is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_pageTitle(l)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const GuestAuthPrompt(icon: Icons.person_outline),
      );
    }
    final pState = ref.watch(profileProvider);
    final userData = pState.userData;
    final avatarUrl = Formatters.avatarUrl(userData);
    final ktpUrl = pState.ktpUrl ?? userData?['ktp_photo_url'] as String?;
    final selfieUrl =
        pState.selfieUrl ?? userData?['selfie_photo_url'] as String?;

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

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(_pageTitle(l)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor.withAlpha(40),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _pageSubtitle(l),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // ── CONTENT berdasarkan fieldKey ────────────────────────────
              ..._buildFields(avatarUrl, ktpUrl, selfieUrl, pState),

              const SizedBox(height: AppSizes.xl),
              AppButton(
                label: l.save,
                loading: _saving,
                onPressed: _save,
                type: ButtonType.primary,
              ),
              const SizedBox(height: AppSizes.md),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFields(
    String? avatarUrl,
    String? ktpUrl,
    String? selfieUrl,
    ProfileState pState,
  ) {
    final l = AppLocalizations.of(context)!;
    switch (widget.fieldKey) {
      // ── Nama Lengkap ──────────────────────────────────────────────────────
      case 'full_name':
        return [
          Text(
            '${l.firstName}${l.required}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          AppTextField(
            label: l.firstName,
            controller: _firstNameController,
            readOnly: _namesLocked,
            validator: Validators.required,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSizes.sm),
          AppTextField(
            label: l.midNameOptional,
            controller: _midNameController,
            readOnly: _namesLocked,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSizes.sm),
          AppTextField(
            label: '${l.lastName}${l.required}',
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
                border: Border.all(color: AppColors.successColor.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.successColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.fullNameValue(_fullName),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_namesLocked) ...[
            const SizedBox(height: AppSizes.sm),
            TextButton.icon(
              onPressed: () => setState(() => _namesLocked = false),
              icon: const Icon(Icons.edit, size: 14),
              label: Text(l.editNameUnlocked),
            ),
          ],
        ];

      // ── Username ──────────────────────────────────────────────────────────
      case 'username':
        return [
          AppTextField(
            label: l.username,
            controller: _usernameController,
            validator: Validators.required,
          ),
          const SizedBox(height: 6),
          Text(
            l.usernameHint,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ];

      // ── Foto Profil ───────────────────────────────────────────────────────
      case 'avatar':
        return [
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundColor: AppColors.secondaryColor.withAlpha(60),
                    backgroundImage:
                        (!(_avatarFile != null &&
                                isVideoPath(_avatarFile!.path)) &&
                            _avatarFile != null)
                        ? FileImage(_avatarFile!) as ImageProvider
                        : (avatarUrl != null
                              ? CachedNetworkImageProvider(avatarUrl)
                              : null),
                    child:
                        (_avatarFile != null && isVideoPath(_avatarFile!.path))
                        ? Icon(
                            Icons.videocam,
                            size: 56,
                            color: AppColors.textTertiary,
                          )
                        : (_avatarFile == null && avatarUrl == null)
                        ? Icon(
                            Icons.person,
                            size: 56,
                            color: AppColors.textTertiary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _avatarFile != null ? l.photoSelected : l.tapPhotoToSelect,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (_avatarFile == null && avatarUrl == null) ...[
            const SizedBox(height: AppSizes.md),
            OutlinedButton.icon(
              onPressed: _pickAvatar,
              icon: const Icon(Icons.upload_rounded),
              label: Text(l.selectProfilePhoto),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ];

      // ── WhatsApp ──────────────────────────────────────────────────────────
      case 'whatsapp':
        return [
          Builder(
            builder: (fieldCtx) => Row(
              children: [
                GestureDetector(
                  onTap: () => _showDropdown(
                    fieldCtx,
                    l.selectCountryCode,
                    _countryCodeOptions(),
                    _countryCodeLabel(),
                    (v) {
                      final code = _dialCodeFromOption(v);
                      if (code != null) setState(() => _countryCode = code);
                    },
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Text(
                          flagFromDialCode(_countryCode) ?? '',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 4),
                        Text(_countryCode, style: AppTextStyles.bodyMedium),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _whatsappController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: Validators.phone,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.whatsappExample,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          if (_dataLoaded) ...[
            const SizedBox(height: AppSizes.sm),
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
          ],
        ];

      // ── Nomor Identitas ───────────────────────────────────────────────────
      case 'ktp_number':
        final idLabel = _identityNumberLabel(l);
        return [
          Text(
            l.selectIdentityType,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _buildIdentityTypePicker(),
          const SizedBox(height: AppSizes.md),
          AppTextField(
            label: idLabel,
            controller: _ktpNumberController,
            keyboardType: _identityType == 'ktp'
                ? TextInputType.number
                : TextInputType.text,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return l.identityNumberRequired(idLabel);
              }
              if (_identityType == 'ktp' && v.trim().length != 16) {
                return l.ktpNumberMustBe16Digits;
              }
              return null;
            },
          ),
        ];

      // ── Data Kelahiran ────────────────────────────────────────────────────
      case 'birth':
        return [
          Builder(
            builder: (fieldCtx) => AppTextField(
              label: l.placeAndDateOfBirth,
              controller: _birthPlaceController,
              validator: Validators.required,
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
                      TextPosition(offset: _birthPlaceController.text.length),
                    );
                  }
                },
              ),
            ),
          ),
        ];

      // ── Email ──────────────────────────────────────────────────────────────
      case 'email':
        return [
          AppTextField(
            label: l.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: 6),
          Text(
            l.emailForVerification,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ];

      // ── Negara ────────────────────────────────────────────────────────────
      case 'country':
        return [
          AppCountryPickerField(
            label: l.countryOfResidence,
            controller: _countryController,
          ),
        ];

      // ── Wilayah ───────────────────────────────────────────────────────────
      case 'region':
        return [
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
        ];

      // ── Alamat ────────────────────────────────────────────────────────────
      case 'address':
        return [
          AppTextField(
            label: l.fullAddress,
            controller: _addressController,
            maxLines: 4,
            validator: Validators.required,
          ),
          const SizedBox(height: 6),
          Text(
            l.addressHint,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ];

      // ── Kode Pos ──────────────────────────────────────────────────────────
      case 'postal_code':
        return [
          TextFormField(
            controller: _postalCodeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l.postalCodeRequired;
              if (v.trim().length < 5) return l.postalCodeMin5;
              return null;
            },
            decoration: InputDecoration(labelText: l.postalCode),
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: 6),
          Text(
            l.postalCodeHint,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ];

      // ── Foto KTP / Identitas ──────────────────────────────────────────────
      case 'ktp_photo':
        return [
          Text(
            l.selectIdentityType,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _buildIdentityTypePicker(),
          const SizedBox(height: AppSizes.md),
          _buildUploadBox(
            icon: Icons.credit_card_outlined,
            title: _idPhotoLabel(l),
            subtitle: _ktpFile != null
                ? l.photoSelected
                : ktpUrl != null
                ? l.photoAlreadyExists
                : l.autoScanHint,
            hasFile: _ktpFile != null || ktpUrl != null,
            onTap: _pickKtp,
            onRemove: _ktpFile != null
                ? () => setState(() => _ktpFile = null)
                : null,
          ),
          _buildAiStatusChip(
            l: l,
            uploading: pState.ktpUploading,
            result: _ktpAiResult,
          ),
          if (ktpUrl != null && _ktpFile == null) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                l.existingPhotoHint,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ];

      // ── Foto Selfie ───────────────────────────────────────────────────────
      case 'selfie':
        return [
          _buildUploadBox(
            icon: Icons.face_outlined,
            title: _idSelfieLabel(l),
            subtitle: _selfieFile != null
                ? l.photoSelected
                : selfieUrl != null
                ? l.photoAlreadyExists
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warningColor.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warningColor.withAlpha(50)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.tips_and_updates_outlined,
                  color: AppColors.warningColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.selfieTips,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warningColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ];

      case 'face_scan':
        return [
          const SizedBox(height: AppSizes.sm),
          Center(
            child: Icon(
              Icons.face_outlined,
              size: 80,
              color: AppColors.primaryColor.withAlpha(150),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            l.faceScanInstruction,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: l.scanFace,
              onPressed: _openFaceScanner,
              type: ButtonType.primary,
            ),
          ),
          if (_faceScanFile != null) ...[
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _faceAiFailed
                    ? AppColors.errorColor.withAlpha(15)
                    : AppColors.successColor.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _faceAiFailed
                      ? AppColors.errorColor.withAlpha(60)
                      : AppColors.successColor.withAlpha(60),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _faceAiFailed ? Icons.error_outline : Icons.check_circle,
                    color: _faceAiFailed
                        ? AppColors.errorColor
                        : AppColors.successColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _faceAiFailed ? l.faceMismatch : l.faceScanSuccess,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _faceAiFailed
                            ? AppColors.errorColor
                            : AppColors.successColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          _buildAiStatusChip(l: l, uploading: false, result: _faceAiResult),
        ];

      case 'gender':
        return [
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
                    Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ];

      case 'religion':
        return [
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
                    Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ];

      case 'marital_status':
        return [
          Builder(
            builder: (fieldCtx) => GestureDetector(
              onTap: () => _showDropdown(
                fieldCtx,
                l.selectMaritalStatus,
                _optLabels('marital_status', [l.single, l.married, l.divorced]),
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
                    Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ];

      case 'mother_name':
        return [
          AppTextField(label: l.motherName, controller: _motherNameController),
        ];

      case 'occupation':
        return [
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
                        _occupation.isEmpty ? l.selectOccupation : _occupation,
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
          ),
        ];

      case 'income_range':
        return [
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
                    Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ];

      case 'source_of_funds':
        return [
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
                    Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ];

      default:
        return [Text(l.fieldCompleteData)];
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
        return l.selfiePhoto;
    }
  }

  Widget _buildIdentityTypePicker() {
    final l = AppLocalizations.of(context)!;
    final options = [l.idCardKtp, l.passport, l.idCardSim, l.idCardNpwp];
    final currentLabel = switch (_identityType) {
      'ktp' => l.idCardKtp,
      'passport' => l.passport,
      'sim' => l.idCardSim,
      'npwp' => l.idCardNpwp,
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
              } else if (v == l.idCardSim) {
                _identityType = 'sim';
              } else if (v == l.idCardNpwp) {
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
    required IconData icon,
    required String title,
    required String subtitle,
    required bool hasFile,
    required VoidCallback onTap,
    VoidCallback? onRemove,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: hasFile
              ? AppColors.successColor.withAlpha(18)
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
              color: hasFile ? AppColors.successColor : AppColors.textSecondary,
              size: 32,
            ),
            const SizedBox(width: 14),
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
                  const SizedBox(height: 3),
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
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              )
            else
              Icon(
                Icons.upload_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
