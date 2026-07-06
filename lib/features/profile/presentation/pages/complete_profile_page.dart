import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_date_picker_field.dart';
import '../../../../core/widgets/app_country_picker_field.dart';
import '../../../../core/widgets/app_region_picker_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/ktp_utils.dart';
import '../../../../core/utils/passport_utils.dart';
import '../../../../core/utils/sim_utils.dart';
import '../../../../core/utils/npwp_utils.dart';
import '../../../../core/utils/country_codes.dart';
import '../providers/profile_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_modals.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CompleteProfilePage extends ConsumerStatefulWidget {
  final String? scrollToSection;
  const CompleteProfilePage({super.key, this.scrollToSection});

  @override
  ConsumerState<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Section keys for scroll-to-section
  final _keyAvatar    = GlobalKey();
  final _keyName      = GlobalKey();
  final _keyUsername  = GlobalKey();
  final _keyWhatsapp  = GlobalKey();
  final _keyIdentity  = GlobalKey();
  final _keyKtpPhoto  = GlobalKey();
  final _keySelfie    = GlobalKey();

  final _firstNameController  = TextEditingController();
  final _midNameController    = TextEditingController();
  final _lastNameController   = TextEditingController();
  final _usernameController   = TextEditingController();
  final _emailController      = TextEditingController();
  final _whatsappController   = TextEditingController();
  final _nikController        = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController  = TextEditingController();
  final _countryController    = TextEditingController();
  final _addressController    = TextEditingController();

  String _countryCode = '+62';
  String _identityType = 'ktp';
  bool _namesLocked = false;
  bool _saving = false;
  File? _ktpFile;
  File? _selfieFile;
  String? _faceScanPath;
  File? _avatarFile;

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

  String get _fullName => [
    _firstNameController.text.trim(),
    _midNameController.text.trim(),
    _lastNameController.text.trim(),
  ].where((s) => s.isNotEmpty).join(' ');

  String _identityNumberLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp':      return l.nikLabel;
      case 'passport': return l.passportLabel;
      case 'sim':      return l.simLabel;
      case 'npwp':     return l.npwpLabel;
      default:         return l.identityNumber;
    }
  }

  String _idPhotoLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp':      return l.ktpPhoto;
      case 'passport': return l.passportPhoto;
      case 'sim':      return l.simPhoto;
      case 'npwp':     return l.npwpPhoto;
      default:         return l.identityPhoto;
    }
  }

  String _idSelfieLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp':      return l.selfieKtp;
      case 'passport': return l.selfiePassport;
      case 'sim':      return l.selfieSim;
      case 'npwp':     return l.selfieNpwp;
      default:         return l.selfieIdentity;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = ref.read(profileProvider).userData;
      if (userData != null) {
        _firstNameController.text  = userData['first_name'] as String? ?? '';
        _midNameController.text    = userData['mid_name']   as String? ?? '';
        _lastNameController.text   = userData['last_name']  as String? ?? '';
        _usernameController.text   = userData['username']   as String? ?? '';
        _emailController.text      = userData['email']      as String? ?? '';
        _birthPlaceController.text = userData['birth_place'] as String? ?? '';
        _birthDateController.text  = userData['birth_date']  as String? ?? '';
        _countryController.text    = userData['country']     as String? ?? '';
        _addressController.text    = userData['address']     as String? ?? '';
        _provinceId   = userData['province_id']   as int?;
        _cityId       = userData['city_id']       as int?;
        _districtId   = userData['district_id']   as int?;
        _villageId    = userData['village_id']    as int?;
        _provinceName = userData['province_name'] as String? ?? '';
        _cityName     = userData['city_name']     as String? ?? '';
        _districtName = userData['district_name'] as String? ?? '';
        _villageName  = userData['village_name']  as String? ?? '';
        _postalCode   = userData['postal_code']   as String? ?? '';
        _gender = userData['gender'] as String? ?? '';
        _religion = userData['religion'] as String? ?? '';
        _maritalStatus = userData['marital_status'] as String? ?? '';
        _motherNameController.text = userData['mother_name'] as String? ?? '';
        _occupation = userData['occupation'] as String? ?? '';
        _incomeRange = userData['income_range'] as String? ?? '';
        _sourceOfFunds = userData['source_of_funds'] as String? ?? '';

        // Parse WhatsApp
        String rawWa = (userData['whatsapp'] as String? ?? '').trim();
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
        if (identityType != null && ['ktp', 'passport', 'sim', 'npwp'].contains(identityType)) {
          _identityType = identityType;
          if (identityType == 'passport') {
            _nikController.text = userData['passport_number'] as String? ?? '';
          } else if (identityType == 'sim') {
            _nikController.text = userData['sim_number'] as String? ?? '';
          } else if (identityType == 'npwp') {
            _nikController.text = userData['npwp_number'] as String? ?? '';
          } else {
            _nikController.text = userData['nik'] as String? ?? '';
          }
          _namesLocked = true;
        } else {
          _nikController.text = userData['nik'] as String? ?? '';
          if (_nikController.text.isNotEmpty) _namesLocked = true;
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
    });
  }

  GlobalKey? _sectionKey(String section) {
    switch (section) {
      case 'avatar':    return _keyAvatar;
      case 'name':      return _keyName;
      case 'username':  return _keyUsername;
      case 'whatsapp':  return _keyWhatsapp;
      case 'identity':  return _keyIdentity;
      case 'ktp_photo': return _keyKtpPhoto;
      case 'selfie':    return _keySelfie;
      default:          return null;
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
    _nikController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _motherNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    // Use image picker for avatar
    final pickedFile = await pickKtpPhoto(context);
    if (pickedFile != null) {
      setState(() => _avatarFile = pickedFile);
    }
  }

  Future<void> _pickKtpImage() async {
    final file = await pickKtpPhoto(context);
    if (file != null) {
      setState(() => _ktpFile = file);
      String nikVal = '';
      String nameVal = '';
      if (_identityType == 'ktp') {
        nikVal  = await extractNikFromKtp(file);
        nameVal = await extractNameFromKtp(file);
      } else if (_identityType == 'passport') {
        nikVal  = await extractPassportNumber(file);
        nameVal = await extractNameFromPassport(file);
      } else if (_identityType == 'sim') {
        nikVal  = await extractSimNumber(file);
        nameVal = await extractNameFromSim(file);
      } else if (_identityType == 'npwp') {
        nikVal  = await extractNpwpNumber(file);
        nameVal = await extractNameFromNpwp(file);
      }
      if (nikVal.isNotEmpty) {
        setState(() => _nikController.text = nikVal);
      }
      if (nameVal.isNotEmpty) {
        final parts = nameVal.trim().split(RegExp(r'\s+'));
        if (!_namesLocked) {
          setState(() {
            _firstNameController.text = parts.isNotEmpty ? parts[0] : '';
            _midNameController.text   = parts.length > 2 ? parts.sublist(1, parts.length - 1).join(' ') : '';
            _lastNameController.text  = parts.length > 1 ? parts.last : '';
            _namesLocked = true;
          });
        }
      }
    }
  }

  Future<void> _pickSelfie() async {
    final file = await pickKtpPhoto(context);
    if (file != null) setState(() => _selfieFile = file);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final pState = ref.read(profileProvider);
    final userData = pState.userData;
    final profileNotifier = ref.read(profileProvider.notifier);

    final data = <String, dynamic>{
      'first_name': _firstNameController.text.trim(),
      'mid_name':   _midNameController.text.trim(),
      'last_name':  _lastNameController.text.trim(),
      'full_name':  _fullName,
      'username':   _usernameController.text.trim(),
      'email':      _emailController.text.trim(),
      'whatsapp':   '$_countryCode ${_whatsappController.text.trim()}',
      'identity_type': _identityType,
      'birth_place': _birthPlaceController.text.trim(),
      'birth_date':  _birthDateController.text.trim(),
      'country':     _countryController.text.trim(),
      'address':     _addressController.text.trim(),
    };
    if (_identityType == 'ktp')      data['nik']             = _nikController.text.trim();
    if (_identityType == 'passport') data['passport_number'] = _nikController.text.trim();
    if (_identityType == 'sim')      data['sim_number']      = _nikController.text.trim();
    if (_identityType == 'npwp')     data['npwp_number']     = _nikController.text.trim();
    if (_provinceId != null)  data['province_id']   = _provinceId;
    if (_cityId != null)      data['city_id']       = _cityId;
    if (_districtId != null)  data['district_id']   = _districtId;
    if (_villageId != null)   data['village_id']    = _villageId;
    if (_provinceName.isNotEmpty) data['province_name'] = _provinceName;
    if (_cityName.isNotEmpty)     data['city_name']     = _cityName;
    if (_districtName.isNotEmpty) data['district_name'] = _districtName;
    if (_villageName.isNotEmpty)  data['village_name']  = _villageName;
    if (_postalCode.isNotEmpty)   data['postal_code']   = _postalCode;
    if (_gender.isNotEmpty) data['gender'] = _gender;
    if (_religion.isNotEmpty) data['religion'] = _religion;
    if (_maritalStatus.isNotEmpty) data['marital_status'] = _maritalStatus;
    if (_motherNameController.text.trim().isNotEmpty) data['mother_name'] = _motherNameController.text.trim();
    if (_occupation.isNotEmpty) data['occupation'] = _occupation;
    if (_incomeRange.isNotEmpty) data['income_range'] = _incomeRange;
    if (_sourceOfFunds.isNotEmpty) data['source_of_funds'] = _sourceOfFunds;

    setState(() => _saving = true);

    try {
      await profileNotifier.updateProfile(data);

      if (_avatarFile != null) {
        final newAvatarUrl = await profileNotifier.uploadAvatar(_avatarFile!.path);
        if (newAvatarUrl != null) {
          ref.read(authProvider.notifier).updateAvatarDirect(newAvatarUrl);
        }
      }
      if (_ktpFile != null) {
        await profileNotifier.uploadKtp(_ktpFile!.path);
      }
      if (_selfieFile != null) {
        await profileNotifier.uploadSelfie(_selfieFile!.path);
      }
      if (_faceScanPath != null) {
        await profileNotifier.uploadFaceScan(_faceScanPath!);
      }

      // Cek apakah email berubah → kirim OTP verifikasi
      final oldEmail = userData?['email'] as String? ?? '';
      final newEmail = _emailController.text.trim();
      if (newEmail.toLowerCase() != oldEmail.toLowerCase()) {
        try {
          await DioClient.instance.post(
            '/auth/send-otp',
            data: {'email': newEmail, 'purpose': 'verify_email'},
          );
          if (mounted) {
            AppSnackBar.show(context, l.profileSavedVerifyEmail, type: SnackBarType.success);
            showOtpVerificationSheet(context, email: newEmail, purpose: 'verify_email');
          }
        } catch (_) {
          if (mounted) {
            AppSnackBar.show(context, l.profileSavedFailedSendOtp, type: SnackBarType.warning);
            context.go('/home');
          }
        }
      } else {
        if (mounted) {
            AppSnackBar.show(context, l.profileUpdated, type: SnackBarType.success);
          context.go('/home');
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, l.profileUpdateFailed, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showPickerSheet(String title, List<String> options, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 8),
              Text(title, style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((option) => ListTile(
                      title: Text(option, style: AppTextStyles.bodyMedium),
                      onTap: () {
                        onSelected(option);
                        Navigator.pop(ctx);
                      },
                    )).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    final types = [
      ('ktp', l.nikShort, Icons.badge_outlined),
      ('passport', l.passport, Icons.book_outlined),
      ('sim', l.simShort, Icons.drive_eta_outlined),
      ('npwp', l.npwpShort, Icons.receipt_long_outlined),
    ];
    return Wrap(
      spacing: 8,
      children: types.map((t) {
        final selected = _identityType == t.$1;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(t.$3, size: 14, color: selected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(t.$2),
            ],
          ),
          selected: selected,
          onSelected: (_) => setState(() {
            _identityType = t.$1;
            _ktpFile = null;
          }),
          selectedColor: AppColors.primaryColor,
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
          ),
        );
      }).toList(),
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
            color: hasFile ? AppColors.successColor.withAlpha(20) : AppColors.secondaryColor.withAlpha(30),
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
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.bodySmall.copyWith(
                      color: hasFile ? AppColors.successColor : AppColors.textTertiary,
                    )),
                  ],
                ),
              ),
              if (hasFile && onRemove != null)
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l        = AppLocalizations.of(context)!;
    final pState    = ref.watch(profileProvider);
    final userData  = pState.userData;
    final ktpUrl    = pState.ktpUrl    ?? userData?['ktp_photo_url']    as String?;
    final selfieUrl = pState.selfieUrl ?? userData?['selfie_photo_url'] as String?;
    final avatarUrl = Formatters.avatarUrl(pState.userData);
    final completionPercent = pState.completionPercent;

    // Flags untuk menentukan field apa yang perlu diisi
    final firstName  = _firstNameController.text.trim();
    final lastName   = _lastNameController.text.trim();
    final needsName  = firstName.isEmpty && lastName.isEmpty;
    final needsUsername  = (userData?['username'] as String? ?? '').isEmpty;
    final needsAvatar    = avatarUrl == null && _avatarFile == null;
    final needsWhatsapp  = _whatsappController.text.trim().isEmpty;
    final needsNik       = _nikController.text.trim().isEmpty;
    final needsBirthPlace = _birthPlaceController.text.trim().isEmpty;
    final needsBirthDate  = _birthDateController.text.trim().isEmpty;
    final needsCountry    = _countryController.text.trim().isEmpty;
    final needsProvince   = _provinceName.isEmpty;
    final needsCity       = _cityName.isEmpty;
    final needsDistrict   = _districtName.isEmpty;
    final needsVillage    = _villageName.isEmpty;
    final needsPostalCode = _postalCode.isEmpty;
    final needsAddress    = _addressController.text.trim().isEmpty;
    final needsKtp        = ktpUrl == null && _ktpFile == null;
    final needsSelfie     = selfieUrl == null && _selfieFile == null;
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
                        : (completionPercent >= 50 ? Colors.orange : AppColors.primaryColor),
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
                        : (completionPercent >= 50 ? Colors.orange : AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l.completeAllDataForVerification,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: AppSizes.lg),

              // ── Foto Profil ──────────────────────────────────────────────
              KeyedSubtree(
                key: _keyAvatar,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(l.profilePhoto, icon: Icons.account_circle_outlined),
                    Center(
                      child: GestureDetector(
                        onTap: _pickAvatar,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: AppColors.secondaryColor.withAlpha(60),
                              backgroundImage: _avatarFile != null
                                  ? FileImage(_avatarFile!)
                                  : (avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null) as ImageProvider?,
                              child: (_avatarFile == null && avatarUrl == null)
                                  ? Icon(Icons.person, size: 48, color: AppColors.textTertiary)
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
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
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
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),
              const Divider(),
              const SizedBox(height: AppSizes.md),

              // ── Nama ─────────────────────────────────────────────────────
              if (needsName) ...[
                KeyedSubtree(
                  key: _keyName,
                  child: _buildSectionHeader(l.fullName, icon: Icons.person_outline_rounded),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: l.firstName,
                        controller: _firstNameController,
                        readOnly: _namesLocked,
                        validator: Validators.required,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppTextField(
                        label: l.middleName,
                        controller: _midNameController,
                        readOnly: _namesLocked,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: l.lastName,
                        controller: _lastNameController,
                        readOnly: _namesLocked,
                        validator: Validators.required,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _fullName.isEmpty ? l.fullName : _fullName,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _fullName.isEmpty ? AppColors.textTertiary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.md),
              ] else
                SizedBox(key: _keyName),

              // ── Username ──────────────────────────────────────────────────
              if (needsUsername) ...[
                KeyedSubtree(
                  key: _keyUsername,
                  child: _buildSectionHeader(l.username, icon: Icons.alternate_email_rounded),
                ),
                AppTextField(
                  label: l.username,
                  controller: _usernameController,
                  validator: Validators.required,
                ),
                const SizedBox(height: AppSizes.md),
              ] else
                SizedBox(key: _keyUsername),

              // ── WhatsApp ──────────────────────────────────────────────────
              if (needsWhatsapp) ...[
                KeyedSubtree(
                  key: _keyWhatsapp,
                  child: _buildSectionHeader(l.whatsappNumber, icon: Icons.phone_outlined),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final code = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => _CountryCodePicker(selectedCode: _countryCode),
                        );
                        if (code != null) setState(() => _countryCode = code);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.dividerColor),
                        ),
                        child: Text(_countryCode, style: AppTextStyles.bodyMedium),
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
                const SizedBox(height: AppSizes.md),
              ] else
                SizedBox(key: _keyWhatsapp),

              // ── Identitas & Alamat ────────────────────────────────────────
              KeyedSubtree(
                key: _keyIdentity,
                child: _buildSectionHeader(l.identityAndAddress, icon: Icons.badge_outlined),
              ),

              _buildSectionHeader(l.selectIdentityType),
              _buildIdentityTypePicker(),
              const SizedBox(height: AppSizes.sm),

              if (needsNik) ...[
                AppTextField(
                  label: _identityNumberLabel(l),
                  controller: _nikController,
                  keyboardType: _identityType == 'ktp' ? TextInputType.number : TextInputType.text,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l.identityNumberRequired(_identityNumberLabel(l));
                    if (_identityType == 'ktp' && v.trim().length != 16) return l.nikMustBe16Digits;
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              if (needsBirthPlace) ...[
                AppTextField(
                  label: l.placeOfBirth,
                  controller: _birthPlaceController,
                  validator: null,
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              if (needsBirthDate) ...[
                AppDatePickerField(
                  label: l.dateOfBirth,
                  controller: _birthDateController,
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

              if (needsProvince || needsCity || needsDistrict || needsVillage || needsPostalCode) ...[
                AppRegionPickerField(
                  country: _countryController.text.isEmpty ? null : _countryController.text,
                  initialProvinceId:   _provinceId,
                  initialCityId:       _cityId,
                  initialDistrictId:   _districtId,
                  initialVillageId:    _villageId,
                  initialProvinceName: _provinceName,
                  initialCityName:     _cityName,
                  initialDistrictName: _districtName,
                  initialVillageName:  _villageName,
                  initialPostalCode:   _postalCode,
                  onProvinceIdChanged:   (v) { _provinceId   = v; },
                  onCityIdChanged:       (v) { _cityId       = v; },
                  onDistrictIdChanged:   (v) { _districtId   = v; },
                  onVillageIdChanged:    (v) { _villageId    = v; },
                  onProvinceNameChanged: (v) { _provinceName = v; },
                  onCityNameChanged:     (v) { _cityName     = v; },
                  onDistrictNameChanged: (v) { _districtName = v; },
                  onVillageNameChanged:  (v) { _villageName  = v; },
                  onPostalCodeChanged:   (v) { _postalCode   = v; },
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
                const Divider(),
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.gender, icon: Icons.people_outlined),
                GestureDetector(
                  onTap: () => _showPickerSheet(l.selectGender, [l.male, l.female], (v) => setState(() => _gender = v)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.people_outlined, color: AppColors.primaryColor, size: 22),
                        SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Text(
                            _gender.isEmpty ? l.selectGender : _gender,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsReligion) ...[
                const Divider(),
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.religion, icon: Icons.church_outlined),
                GestureDetector(
                  onTap: () => _showPickerSheet(l.selectReligion, [l.islam, l.christian, l.catholic, l.hindu, l.buddha, l.confucian], (v) => setState(() => _religion = v)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.church_outlined, color: AppColors.primaryColor, size: 22),
                        SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Text(
                            _religion.isEmpty ? l.selectReligion : _religion,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsMaritalStatus) ...[
                const Divider(),
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.maritalStatus, icon: Icons.favorite_border),
                GestureDetector(
                  onTap: () => _showPickerSheet(l.selectMaritalStatus, [l.single, l.married, l.divorced], (v) => setState(() => _maritalStatus = v)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border, color: AppColors.primaryColor, size: 22),
                        SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Text(
                            _maritalStatus.isEmpty ? l.selectMaritalStatus : _maritalStatus,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsMotherName) ...[
                const Divider(),
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.motherName, icon: Icons.woman_outlined),
                AppTextField(
                  label: l.motherName,
                  controller: _motherNameController,
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsOccupation) ...[
                const Divider(),
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.occupation, icon: Icons.work_outline),
                GestureDetector(
                  onTap: () => _showPickerSheet(l.selectOccupation, [l.employee, l.entrepreneur, l.student, l.housewife, l.professional, l.other], (v) => setState(() => _occupation = v)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.work_outline, color: AppColors.primaryColor, size: 22),
                        SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Text(
                            _occupation.isEmpty ? l.selectOccupation : _occupation,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsIncomeRange) ...[
                const Divider(),
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.incomeRange, icon: Icons.trending_up_outlined),
                GestureDetector(
                  onTap: () => _showPickerSheet(l.selectIncomeRange, [l.lessThan1M, l.range1to5M, l.range5to10M, l.range10to50M, l.moreThan50M], (v) => setState(() => _incomeRange = v)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up_outlined, color: AppColors.primaryColor, size: 22),
                        SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Text(
                            _incomeRange.isEmpty ? l.selectIncomeRange : _incomeRange,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],
              if (needsSourceOfFunds) ...[
                const Divider(),
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.sourceOfFunds, icon: Icons.account_balance_wallet_outlined),
                GestureDetector(
                  onTap: () => _showPickerSheet(l.selectSourceOfFunds, [l.salary, l.business, l.investment, l.gift, l.other], (v) => setState(() => _sourceOfFunds = v)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined, color: AppColors.primaryColor, size: 22),
                        SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Text(
                            _sourceOfFunds.isEmpty ? l.selectSourceOfFunds : _sourceOfFunds,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
              ],

              // ── Dokumen Identitas ─────────────────────────────────────────
              if (needsKtp) ...[
                const Divider(),
                const SizedBox(height: AppSizes.sm),
                _buildSectionHeader(l.identityDocuments, icon: Icons.credit_card_outlined),
                _buildUploadBox(
                  boxKey: _keyKtpPhoto,
                  icon: Icons.credit_card_outlined,
                  title: _idPhotoLabel(l),
                  subtitle: _ktpFile != null ? l.labelSelected(_idPhotoLabel(l)) : l.uploadClearPhotoOf(_idPhotoLabel(l)),
                  hasFile: _ktpFile != null || ktpUrl != null,
                  onTap: _pickKtpImage,
                  onRemove: _ktpFile != null ? () => setState(() => _ktpFile = null) : null,
                ),
                const SizedBox(height: AppSizes.sm),
              ] else
                SizedBox(key: _keyKtpPhoto),

              if (needsSelfie) ...[
                _buildUploadBox(
                  boxKey: _keySelfie,
                  icon: Icons.face_outlined,
                  title: _idSelfieLabel(l),
                  subtitle: _selfieFile != null ? l.labelSelected(_idSelfieLabel(l)) : l.uploadSelfieHoldingPhoto(_idPhotoLabel(l)),
                  hasFile: _selfieFile != null || selfieUrl != null,
                  onTap: _pickSelfie,
                  onRemove: _selfieFile != null ? () => setState(() => _selfieFile = null) : null,
                ),
                const SizedBox(height: AppSizes.sm),
              ] else
                SizedBox(key: _keySelfie),

              const SizedBox(height: AppSizes.md),
              GestureDetector(
                onTap: () async {
                  final path = await context.push<String>('/face-scanner');
                  if (path != null) setState(() => _faceScanPath = path);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _faceScanPath != null ? AppColors.successColor.withAlpha(20) : AppColors.secondaryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _faceScanPath != null ? AppColors.successColor : AppColors.dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _faceScanPath != null ? Icons.check_circle : Icons.face_retouching_natural,
                        color: _faceScanPath != null ? AppColors.successColor : AppColors.textSecondary,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.faceVerification, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(
                              _faceScanPath != null ? l.faceVerified : l.uploadFacePhotoAction,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: _faceScanPath != null ? AppColors.successColor : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_faceScanPath != null)
                        GestureDetector(
                          onTap: () => setState(() => _faceScanPath = null),
                          child: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                ),
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
}

// ── Country Code Picker Bottom Sheet ─────────────────────────────────────────

class _CountryCodePicker extends StatelessWidget {
  final String selectedCode;
  const _CountryCodePicker({required this.selectedCode});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Text(l.selectCountryCode, style: AppTextStyles.titleSmall),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: countryCodes.length,
              itemBuilder: (_, i) {
                final c = countryCodes[i];
                final isSelected = c.dialCode == selectedCode;
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                  title: Text('${c.name} (${c.dialCode})', style: AppTextStyles.bodySmall),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.primaryColor) : null,
                  onTap: () => Navigator.pop(context, c.dialCode),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
