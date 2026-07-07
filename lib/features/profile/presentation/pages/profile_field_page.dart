import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
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
import '../../../auth/presentation/providers/auth_provider.dart';

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
  final _firstNameController  = TextEditingController();
  final _midNameController    = TextEditingController();
  final _lastNameController   = TextEditingController();
  final _usernameController   = TextEditingController();
  final _whatsappController   = TextEditingController();
  final _nikController        = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController  = TextEditingController();
  final _countryController    = TextEditingController();
  final _emailController      = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _addressController    = TextEditingController();
  final _motherNameController = TextEditingController();

  String _countryCode   = '+62';
  String _gender = '';
  String _religion = '';
  String _maritalStatus = '';
  String _occupation = '';
  String _incomeRange = '';
  String _sourceOfFunds = '';
  String _identityType  = 'ktp';
  bool   _namesLocked   = false;
  bool   _saving        = false;
  File?  _avatarFile;
  File?  _ktpFile;
  File?  _selfieFile;
  File?  _faceScanFile;

  int?   _provinceId;
  int?   _cityId;
  int?   _districtId;
  int?   _villageId;
  String _provinceName = '';
  String _cityName     = '';
  String _districtName = '';
  String _villageName  = '';
  String _postalCode   = '';

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

  String _pageTitle(AppLocalizations l) {
    switch (widget.fieldKey) {
      case 'full_name':   return l.fieldFullName;
      case 'username':    return l.fieldUsername;
      case 'avatar':      return l.fieldAvatar;
      case 'whatsapp':    return l.fieldWhatsapp;
      case 'nik':         return l.fieldNik;
      case 'birth':       return l.fieldBirth;
      case 'country':     return l.fieldCountry;
      case 'email':       return l.fieldEmail;
      case 'region':      return l.fieldRegion;
      case 'address':     return l.fieldAddress;
      case 'postal_code': return l.fieldPostalCode;
      case 'gender':      return l.fieldGender;
      case 'religion':    return l.fieldReligion;
      case 'marital_status': return l.fieldMaritalStatus;
      case 'mother_name': return l.fieldMotherName;
      case 'occupation':  return l.fieldOccupation;
      case 'income_range': return l.fieldIncomeRange;
      case 'source_of_funds': return l.fieldSourceOfFunds;
      case 'ktp_photo':   return l.fieldKtpPhoto;
      case 'selfie':      return l.fieldSelfie;
      case 'face_scan':   return l.faceVerification;
      default:            return l.fieldCompleteData;
    }
  }

  String _pageSubtitle(AppLocalizations l) {
    switch (widget.fieldKey) {
      case 'full_name':   return l.subtitleFullName;
      case 'username':    return l.subtitleUsername;
      case 'avatar':      return l.subtitleAvatar;
      case 'whatsapp':    return l.subtitleWhatsapp;
      case 'nik':         return l.subtitleNik;
      case 'birth':       return l.subtitleBirth;
      case 'country':     return l.subtitleCountry;
      case 'email':       return l.subtitleEmail;
      case 'region':      return l.subtitleRegion;
      case 'address':     return l.subtitleAddress;
      case 'postal_code': return l.subtitlePostalCode;
      case 'gender':      return l.subtitleGender;
      case 'religion':    return l.subtitleReligion;
      case 'marital_status': return l.subtitleMaritalStatus;
      case 'mother_name': return l.subtitleMotherName;
      case 'occupation':  return l.subtitleOccupation;
      case 'income_range': return l.subtitleIncomeRange;
      case 'source_of_funds': return l.subtitleSourceOfFunds;
      case 'ktp_photo':   return l.subtitleKtpPhoto;
      case 'selfie':      return l.subtitleSelfie;
      case 'face_scan':   return l.faceScanInstruction;
      default:            return l.subtitleCompleteData;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFromProfile());
  }

  void _loadFromProfile() {
    final userData = ref.read(profileProvider).userData;
    if (userData == null) return;

    _firstNameController.text  = userData['first_name'] as String? ?? '';
    _midNameController.text    = userData['mid_name']   as String? ?? '';
    _lastNameController.text   = userData['last_name']  as String? ?? '';
    _usernameController.text   = userData['username']   as String? ?? '';
    _birthPlaceController.text = userData['birth_place'] as String? ?? '';
    _birthDateController.text  = userData['birth_date']  as String? ?? '';
    _countryController.text    = userData['country']     as String? ?? '';
    _emailController.text      = userData['email']       as String? ?? '';
    _postalCodeController.text = userData['postal_code'] as String? ?? '';
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

    // WhatsApp
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
    setState(() {});
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _midNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _whatsappController.dispose();
    _nikController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
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
    setState(() => _saving = true);

    try {
      final notifier = ref.read(profileProvider.notifier);

      switch (widget.fieldKey) {
        case 'full_name':
          await notifier.updateProfile({
            'first_name': _firstNameController.text.trim(),
            'mid_name':   _midNameController.text.trim(),
            'last_name':  _lastNameController.text.trim(),
            'full_name':  _fullName,
          });
          break;

        case 'username':
          await notifier.updateProfile({'username': _usernameController.text.trim()});
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

        case 'nik':
          final data = <String, dynamic>{'identity_type': _identityType};
          if (_identityType == 'ktp')      data['nik']             = _nikController.text.trim();
          if (_identityType == 'passport') data['passport_number'] = _nikController.text.trim();
          if (_identityType == 'sim')      data['sim_number']      = _nikController.text.trim();
          if (_identityType == 'npwp')     data['npwp_number']     = _nikController.text.trim();
          await notifier.updateProfile(data);
          break;

        case 'birth':
          await notifier.updateProfile({
            'birth_place': _birthPlaceController.text.trim(),
            'birth_date':  _birthDateController.text.trim(),
          });
          break;

        case 'email':
          await notifier.updateProfile({'email': _emailController.text.trim()});
          break;

        case 'country':
          await notifier.updateProfile({'country': _countryController.text.trim()});
          break;

        case 'region':
          final data = <String, dynamic>{};
          if (_provinceId != null)      data['province_id']   = _provinceId;
          if (_cityId != null)          data['city_id']       = _cityId;
          if (_districtId != null)      data['district_id']   = _districtId;
          if (_villageId != null)       data['village_id']    = _villageId;
          if (_provinceName.isNotEmpty) data['province_name'] = _provinceName;
          if (_cityName.isNotEmpty)     data['city_name']     = _cityName;
          if (_districtName.isNotEmpty) data['district_name'] = _districtName;
          if (_villageName.isNotEmpty)  data['village_name']  = _villageName;
          if (_postalCode.isNotEmpty)   data['postal_code']   = _postalCode;
          await notifier.updateProfile(data);
          break;

        case 'postal_code':
          await notifier.updateProfile({'postal_code': _postalCodeController.text.trim()});
          break;

        case 'address':
          await notifier.updateProfile({'address': _addressController.text.trim()});
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
          await notifier.updateProfile({'mother_name': _motherNameController.text.trim()});
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
          if (_ktpFile != null) await notifier.uploadKtp(_ktpFile!.path);
          break;

        case 'selfie':
          if (_selfieFile != null) await notifier.uploadSelfie(_selfieFile!.path);
          break;

        case 'face_scan':
          if (_faceScanFile != null) await notifier.uploadFaceScan(_faceScanFile!.path);
          break;
      }

      if (mounted) {
        AppSnackBar.show(context, l.dataSavedSuccess, type: SnackBarType.success);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, l.failedSaveData, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Pick KTP/Selfie ───────────────────────────────────────────────────────

  Future<void> _pickKtp() async {
    final file = await pickKtpPhoto(context);
    if (file != null) {
      setState(() => _ktpFile = file);
      String nikVal  = '';
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
      if (nikVal.isNotEmpty) setState(() => _nikController.text = nikVal);
      if (nameVal.isNotEmpty && !_namesLocked) {
        final parts = nameVal.trim().split(RegExp(r'\s+'));
        setState(() {
          _firstNameController.text = parts.isNotEmpty ? parts[0] : '';
          _midNameController.text   = parts.length > 2 ? parts.sublist(1, parts.length - 1).join(' ') : '';
          _lastNameController.text  = parts.length > 1 ? parts.last : '';
          _namesLocked = true;
        });
      }
    }
  }

  Future<void> _pickSelfie() async {
    final file = await pickKtpPhoto(context);
    if (file != null) setState(() => _selfieFile = file);
  }

  Future<void> _pickAvatar() async {
    final file = await pickKtpPhoto(context);
    if (file != null) setState(() => _avatarFile = file);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l        = AppLocalizations.of(context)!;
    final pState    = ref.watch(profileProvider);
    final userData  = pState.userData;
    final avatarUrl = Formatters.avatarUrl(userData);
    final ktpUrl    = pState.ktpUrl    ?? userData?['ktp_photo_url']    as String?;
    final selfieUrl = pState.selfieUrl ?? userData?['selfie_photo_url'] as String?;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(_pageTitle(l)),
        centerTitle: true,
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryColor.withAlpha(40)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppColors.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _pageSubtitle(l),
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // ── CONTENT berdasarkan fieldKey ────────────────────────────
              ..._buildFields(avatarUrl, ktpUrl, selfieUrl),

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

  List<Widget> _buildFields(String? avatarUrl, String? ktpUrl, String? selfieUrl) {
    final l = AppLocalizations.of(context)!;
    switch (widget.fieldKey) {

      // ── Nama Lengkap ──────────────────────────────────────────────────────
      case 'full_name':
        return [
          Text('${l.firstName}${l.required}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
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
                  Icon(Icons.check_circle_outline, color: AppColors.successColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    l.fullNameValue(_fullName),
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.successColor, fontWeight: FontWeight.w600),
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
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
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
                    backgroundImage: _avatarFile != null
                        ? FileImage(_avatarFile!) as ImageProvider
                        : (avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null),
                    child: (_avatarFile == null && avatarUrl == null)
                        ? Icon(Icons.person, size: 56, color: AppColors.textTertiary)
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
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
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
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ];

      // ── WhatsApp ──────────────────────────────────────────────────────────
      case 'whatsapp':
        return [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final code = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => _CountryCodeSheet(
                    selectedCode: _countryCode,
                    l: AppLocalizations.of(context)!,
                  ),
                  );
                  if (code != null) setState(() => _countryCode = code);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Text(flagFromDialCode(_countryCode) ?? '', style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 4),
                      Text(_countryCode, style: AppTextStyles.bodyMedium),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, size: 18, color: AppColors.textSecondary),
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
          const SizedBox(height: 6),
          Text(
            l.whatsappExample,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
        ];

      // ── Nomor Identitas ───────────────────────────────────────────────────
      case 'nik':
        final idLabel = _identityNumberLabel(l);
        return [
          Text(l.selectIdentityType, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _buildIdentityTypePicker(),
          const SizedBox(height: AppSizes.sm),
          AppTextField(
            label: idLabel,
            controller: _nikController,
            keyboardType: _identityType == 'ktp' ? TextInputType.number : TextInputType.text,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l.identityNumberRequired(idLabel);
              if (_identityType == 'ktp' && v.trim().length != 16) return l.nikMustBe16Digits;
              return null;
            },
          ),
        ];

      // ── Data Kelahiran ────────────────────────────────────────────────────
      case 'birth':
        return [
          AppTextField(
            label: l.placeOfBirth,
            controller: _birthPlaceController,
            validator: Validators.required,
          ),
          const SizedBox(height: AppSizes.sm),
          AppDatePickerField(
            label: l.dateOfBirth,
            controller: _birthDateController,
            validator: Validators.required,
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
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
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
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
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
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
        ];

      // ── Foto KTP / Identitas ──────────────────────────────────────────────
      case 'ktp_photo':
        return [
          Text(l.selectIdentityType, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _buildIdentityTypePicker(),
          const SizedBox(height: AppSizes.md),
          _buildUploadBox(
            icon: Icons.credit_card_outlined,
            title: '${l.identityPhoto} ${_identityTypeLabel(l)}',
            subtitle: _ktpFile != null
                ? l.photoSelected
                : ktpUrl != null
                    ? l.photoAlreadyExists
                    : l.tapToSelectPhoto,
            hasFile: _ktpFile != null || ktpUrl != null,
            onTap: _pickKtp,
            onRemove: _ktpFile != null ? () => setState(() => _ktpFile = null) : null,
          ),
          if (ktpUrl != null && _ktpFile == null) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                l.existingPhotoHint,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
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
            title: l.selfieImageTitle,
            subtitle: _selfieFile != null
                ? l.photoSelected
                : selfieUrl != null
                    ? l.photoAlreadyExists
                    : l.tapToSelectPhoto,
            hasFile: _selfieFile != null || selfieUrl != null,
            onTap: _pickSelfie,
            onRemove: _selfieFile != null ? () => setState(() => _selfieFile = null) : null,
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
                Icon(Icons.tips_and_updates_outlined, color: AppColors.warningColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.selfieTips,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.warningColor),
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
            child: Icon(Icons.face_outlined, size: 80, color: AppColors.primaryColor.withAlpha(150)),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            l.faceScanInstruction,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.lg),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: l.scanFace,
              onPressed: () async {
                final result = await context.push<String>('/face-scanner');
                if (result != null && mounted) {
                  setState(() => _faceScanFile = File(result));
                }
              },
              type: ButtonType.primary,
            ),
          ),
          if (_faceScanFile != null) ...[
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.successColor.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.successColor.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.successColor, size: 20),
                  const SizedBox(width: 8),
                  Text(l.faceScanSuccess, style: AppTextStyles.bodySmall.copyWith(color: AppColors.successColor)),
                ],
              ),
            ),
          ],
        ];

      case 'gender':
        return [
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
        ];

      case 'religion':
        return [
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
        ];

      case 'marital_status':
        return [
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
        ];

      case 'mother_name':
        return [
          AppTextField(
            label: l.motherName,
            controller: _motherNameController,
          ),
        ];

      case 'occupation':
        return [
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
        ];

      case 'income_range':
        return [
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
        ];

      case 'source_of_funds':
        return [
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
        ];

      default:
        return [Text(l.fieldCompleteData)];
    }
  }

  void _showPickerSheet(String title, List<String> options, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 8),
              Text(title, style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: options.map((option) => ListTile(
                    title: Text(option, style: AppTextStyles.bodyMedium),
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(ctx);
                    },
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _identityTypeLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp':      return l.nikShort;
      case 'passport': return l.passport;
      case 'sim':      return l.simShort;
      case 'npwp':     return l.npwpShort;
      default:         return l.identityShort;
    }
  }

  Widget _buildIdentityTypePicker() {
    final l = AppLocalizations.of(context)!;
    final types = [
      ('ktp',      l.idCardKtp, Icons.badge_outlined),
      ('passport', l.passport,  Icons.book_outlined),
      ('sim',      l.idCardSim, Icons.drive_eta_outlined),
      ('npwp',     l.idCardNpwp,Icons.receipt_long_outlined),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 6,
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
          color: hasFile ? AppColors.successColor.withAlpha(18) : AppColors.secondaryColor.withAlpha(30),
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
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(
                    color: hasFile ? AppColors.successColor : AppColors.textTertiary,
                  )),
                ],
              ),
            ),
            if (hasFile && onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: Icon(Icons.close, size: 20, color: AppColors.textSecondary),
              )
            else
              Icon(Icons.upload_rounded, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Country Code Bottom Sheet ─────────────────────────────────────────────────

class _CountryCodeSheet extends StatelessWidget {
  final String selectedCode;
  final AppLocalizations l;
  const _CountryCodeSheet({required this.selectedCode, required this.l});

  @override
  Widget build(BuildContext context) {
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
