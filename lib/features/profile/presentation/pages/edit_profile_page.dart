import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_date_picker_field.dart';
import '../../../../core/widgets/app_country_picker_field.dart';
import '../../../../core/widgets/app_region_picker_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _midNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nikController = TextEditingController();
  final _passportController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _countryController = TextEditingController();
  final _addressController = TextEditingController();
  bool _obscurePassword = true;
  File? _avatarFile;
  File? _ktpFile;
  File? _selfieFile;
  bool _editing = false;

  String _identityType = 'ktp';
  bool _requireCompletion = false;
  String get _identityNumberLabel {
    switch (_identityType) {
      case 'ktp': return 'Nomer Induk Kependudukan (NIK)';
      case 'passport': return 'Nomer Passport';
      case 'sim': return 'Surat Izin Mengemudi (SIM)';
      case 'npwp': return 'Nomor Pokok Wajib Pajak (NPWP)';
      default: return 'Nomor Identitas';
    }
  }
  String get _idPhotoLabel {
    switch (_identityType) {
      case 'ktp': return 'Foto KTP';
      case 'passport': return 'Foto Passport';
      case 'sim': return 'Foto SIM';
      case 'npwp': return 'Foto NPWP';
      default: return 'Foto Identitas';
    }
  }
  String get _idSelfieLabel {
    switch (_identityType) {
      case 'ktp': return 'Foto Selfie + KTP';
      case 'passport': return 'Foto Selfie + Passport';
      case 'sim': return 'Foto Selfie + SIM';
      case 'npwp': return 'Foto Selfie + NPWP';
      default: return 'Foto Selfie + Identitas';
    }
  }
  int? _provinceId;
  int? _cityId;
  int? _districtId;
  int? _villageId;
  String _provinceName = '';
  String _cityName = '';
  String _districtName = '';
  String _villageName = '';
  String _postalCode = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(profileProvider);
      final userData = state.userData;
      if (userData != null) {
        _firstNameController.text = userData['first_name'] as String? ?? '';
        _midNameController.text = userData['mid_name'] as String? ?? '';
        _lastNameController.text = userData['last_name'] as String? ?? '';
        _fullNameController.text = userData['full_name'] as String? ?? '';
        _usernameController.text = userData['username'] as String? ?? '';
        _emailController.text = userData['email'] as String? ?? '';
        _whatsappController.text = userData['whatsapp'] as String? ?? '';
        _nikController.text = userData['nik'] as String? ?? '';
        _passportController.text = userData['passport_number'] as String? ?? '';
        _birthPlaceController.text = userData['birth_place'] as String? ?? '';
        _birthDateController.text = userData['birth_date'] as String? ?? '';
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
        final identityType = userData['identity_type'] as String?;
        if (identityType == null || identityType.isEmpty) {
          _requireCompletion = true;
          _editing = true;
        }
        if (identityType != null && ['ktp', 'passport', 'sim', 'npwp'].contains(identityType)) {
          _identityType = identityType;
          if (identityType == 'passport') {
            _nikController.text = userData['passport_number'] as String? ?? '';
          } else if (identityType == 'sim') {
            _nikController.text = userData['sim_number'] as String? ?? '';
          } else if (identityType == 'npwp') {
            _nikController.text = userData['npwp_number'] as String? ?? '';
          }
        } else {
          final nik = userData['nik'] as String? ?? '';
          _identityType = (nik.length == 16 && RegExp(r'^\d{16}$').hasMatch(nik)) ? 'ktp' : 'passport';
        }
      }
      ref.read(profileProvider.notifier).fetchCompletion();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _midNameController.dispose();
    _lastNameController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _passwordController.dispose();
    _nikController.dispose();
    _passportController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ValueChanged<File> onPicked) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
    if (picked != null) {
      onPicked(File(picked.path));
    }
  }

  void _toggleEdit() {
    if (!_editing) {
      setState(() => _editing = true);
      return;
    }
    _save();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_requireCompletion) {
      if (_birthPlaceController.text.trim().isEmpty) {
        AppSnackBar.show(context, 'Lengkapi tempat lahir', type: SnackBarType.warning);
        return;
      }
      if (_birthDateController.text.trim().isEmpty) {
        AppSnackBar.show(context, 'Lengkapi tanggal lahir', type: SnackBarType.warning);
        return;
      }
      if (_whatsappController.text.trim().isEmpty) {
        AppSnackBar.show(context, 'Lengkapi nomor WhatsApp', type: SnackBarType.warning);
        return;
      }
    }

    final profileNotifier = ref.read(profileProvider.notifier);

    final data = <String, dynamic>{
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      'whatsapp': _whatsappController.text.trim(),
    };

    if (_requireCompletion) {
      data['identity_type'] = _identityType;
      if (_identityType == 'ktp') data['nik'] = _nikController.text.trim();
      if (_identityType == 'passport') data['passport_number'] = _nikController.text.trim();
      if (_identityType == 'sim') data['sim_number'] = _nikController.text.trim();
      if (_identityType == 'npwp') data['npwp_number'] = _nikController.text.trim();
      data['birth_place'] = _birthPlaceController.text.trim();
      data['birth_date'] = _birthDateController.text.trim();
      data['country'] = _countryController.text.trim();
      data['address'] = _addressController.text.trim();
      if (_provinceId != null) data['province_id'] = _provinceId;
      if (_cityId != null) data['city_id'] = _cityId;
      if (_districtId != null) data['district_id'] = _districtId;
      if (_villageId != null) data['village_id'] = _villageId;
      if (_provinceName.isNotEmpty) data['province_name'] = _provinceName;
      if (_cityName.isNotEmpty) data['city_name'] = _cityName;
      if (_districtName.isNotEmpty) data['district_name'] = _districtName;
      if (_villageName.isNotEmpty) data['village_name'] = _villageName;
      if (_postalCode.isNotEmpty) data['postal_code'] = _postalCode;
    }

    final password = _passwordController.text.trim();
    if (password.isNotEmpty) {
      data['password'] = password;
    }

    try {
      await profileNotifier.updateProfile(data);

      if (_avatarFile != null) {
        await profileNotifier.uploadAvatar(_avatarFile!.path);
      }

      if (mounted) {
        AppSnackBar.show(context, 'Profil berhasil diperbarui', type: SnackBarType.success);
        setState(() => _editing = false);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, 'Gagal mengupdate profil', type: SnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pState = ref.watch(profileProvider);
    final userData = pState.userData;
    final ktpUrl = pState.ktpUrl ?? userData?['ktp_photo_url'] as String?;
    final selfieUrl = pState.selfieUrl ?? userData?['selfie_photo_url'] as String?;
    final identityVerified = userData?['identity_verified_at'] != null;
    final loading = pState.saving || pState.ktpUploading || pState.selfieUploading;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompletionBar(pState.completionPercent),
              SizedBox(height: AppSizes.lg),
              _buildAvatarSection(pState),
              SizedBox(height: AppSizes.lg),
              Text('nama', style: AppTextStyles.titleMedium),
              SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Expanded(child: _buildField(
                    label: 'first_name',
                    controller: _firstNameController,
                    alwaysReadOnly: true,
                  )),
                  SizedBox(width: 8),
                  Expanded(child: _buildField(
                    label: 'mid_name',
                    controller: _midNameController,
                    alwaysReadOnly: true,
                  )),
                ],
              ),
              SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Expanded(child: _buildField(
                    label: 'last_name',
                    controller: _lastNameController,
                    alwaysReadOnly: true,
                  )),
                  SizedBox(width: 8),
                  Expanded(child: _buildField(
                    label: 'Nama Lengkap',
                    controller: _fullNameController,
                    readOnly: true,
                    alwaysReadOnly: true,
                  )),
                ],
              ),
              SizedBox(height: AppSizes.md),
              _buildField(
                label: 'Username',
                controller: _usernameController,
                validator: Validators.required,
              ),
              SizedBox(height: AppSizes.md),
              _buildField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              SizedBox(height: AppSizes.md),
              _buildField(
                label: 'WhatsApp',
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              SizedBox(height: AppSizes.md),
              _buildField(
                label: 'Password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: (v) {
                  if (v != null && v.isNotEmpty && v.length < 12) return 'Minimal 12 karakter';
                  return null;
                },
                onChanged: (_) => setState(() {}),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              SizedBox(height: AppSizes.lg),
              Text('Data Identitas', style: AppTextStyles.titleMedium),
              SizedBox(height: AppSizes.sm),
              _buildIdentityTypePill(label: 'KTP', active: _identityType == 'ktp', onTap: _editing ? () { setState(() { _identityType = 'ktp'; _nikController.clear(); }); } : null),
              SizedBox(height: AppSizes.sm),
              _buildIdentityTypePill(label: 'Passport', active: _identityType == 'passport', onTap: _editing ? () { setState(() { _identityType = 'passport'; _nikController.clear(); }); } : null),
              SizedBox(height: AppSizes.sm),
              _buildIdentityTypePill(label: 'SIM', active: _identityType == 'sim', onTap: _editing ? () { setState(() { _identityType = 'sim'; _nikController.clear(); }); } : null),
              SizedBox(height: AppSizes.sm),
              _buildIdentityTypePill(label: 'NPWP', active: _identityType == 'npwp', onTap: _editing ? () { setState(() { _identityType = 'npwp'; _nikController.clear(); }); } : null),
              SizedBox(height: AppSizes.md),
              _buildField(
                label: _identityNumberLabel,
                controller: _nikController,
                alwaysReadOnly: !_requireCompletion && !_editing,
              ),
              SizedBox(height: AppSizes.md),
              _buildField(
                label: 'Tempat Lahir',
                controller: _birthPlaceController,
                alwaysReadOnly: !_requireCompletion && !_editing,
              ),
              SizedBox(height: AppSizes.md),
              _buildField(
                label: 'Tanggal Lahir',
                controller: _birthDateController,
                alwaysReadOnly: !_requireCompletion && !_editing,
                isDatePicker: true,
              ),
              SizedBox(height: AppSizes.md),
              _buildField(
                label: 'Negara',
                controller: _countryController,
                alwaysReadOnly: !_requireCompletion && !_editing,
                isCountryPicker: true,
              ),
              SizedBox(height: AppSizes.md),
              AppRegionPickerField(
                country: _countryController.text.isEmpty ? null : _countryController.text,
                initialProvinceId: _provinceId,
                initialCityId: _cityId,
                initialDistrictId: _districtId,
                initialVillageId: _villageId,
                initialProvinceName: _provinceName,
                initialCityName: _cityName,
                initialDistrictName: _districtName,
                initialVillageName: _villageName,
                initialPostalCode: _postalCode,
                readOnly: !_requireCompletion && !_editing,
                onProvinceIdChanged: (v) { _provinceId = v; },
                onCityIdChanged: (v) { _cityId = v; },
                onDistrictIdChanged: (v) { _districtId = v; },
                onVillageIdChanged: (v) { _villageId = v; },
                onProvinceNameChanged: (v) { _provinceName = v; },
                onCityNameChanged: (v) { _cityName = v; },
                onDistrictNameChanged: (v) { _districtName = v; },
                onVillageNameChanged: (v) { _villageName = v; },
                onPostalCodeChanged: (v) { _postalCode = v; },
              ),
              _buildField(
                label: 'Alamat',
                controller: _addressController,
                maxLines: 3,
                alwaysReadOnly: !_requireCompletion && !_editing,
              ),
              SizedBox(height: AppSizes.md),
              _buildPhotoCard(
                label: _idPhotoLabel,
                file: _ktpFile,
                existingUrl: ktpUrl,
                uploading: pState.ktpUploading,
                editable: false,
              ),
              SizedBox(height: AppSizes.md),
              SizedBox(height: AppSizes.md),
              _buildPhotoCard(
                label: _idSelfieLabel,
                file: _selfieFile,
                existingUrl: selfieUrl,
                uploading: pState.selfieUploading,
                verified: identityVerified,
                editable: false,
              ),
              SizedBox(height: AppSizes.xl),
              AppButton(
                label: _editing ? 'Simpan' : 'Edit',
                loading: loading,
                onPressed: _toggleEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdentityTypePill({required String label, required bool active, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryColor.withAlpha(30) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.primaryColor : AppColors.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: active ? AppColors.primaryColor : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    bool alwaysReadOnly = false,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    Widget? suffixIcon,
    bool isDatePicker = false,
    bool isCountryPicker = false,
  }) {
    if (isDatePicker) {
      return AppDatePickerField(label: label, controller: controller, validator: validator);
    }
    if (isCountryPicker) {
      return AppCountryPickerField(label: label, controller: controller, validator: validator);
    }
    if (alwaysReadOnly) {
      return Opacity(
        opacity: 0.6,
        child: AbsorbPointer(
          child: AppTextField(
            label: label,
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
          ),
        ),
      );
    }
    if (!_editing) {
      return Opacity(
        opacity: 0.6,
        child: AbsorbPointer(
          child: AppTextField(
            label: label,
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
          ),
        ),
      );
    }
    return AppTextField(
      label: label,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: readOnly ? null : validator,
      onChanged: readOnly ? null : onChanged,
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildCompletionBar(int percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('kelengkapan_profil', style: AppTextStyles.titleSmall),
            Text('$percent%', style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryColor, fontWeight: FontWeight.w600,
            )),
          ],
        ),
        SizedBox(height: AppSizes.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 10,
            backgroundColor: AppColors.secondaryColor.withAlpha(50),
            valueColor: AlwaysStoppedAnimation<Color>(
              percent >= 80 ? Colors.green : (percent >= 50 ? Colors.orange : AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSection(ProfileState pState) {
    return Center(
      child: GestureDetector(
        onTap: _editing ? () => _pickImage((f) => setState(() => _avatarFile = f)) : null,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.secondaryColor,
              backgroundImage: _avatarFile != null
                  ? FileImage(_avatarFile!)
                  : (pState.userData?['avatar_url'] != null
                      ? CachedNetworkImageProvider(pState.userData!['avatar_url'] as String)
                      : null),
              child: pState.userData?['avatar_url'] == null && _avatarFile == null
                  ? Icon(Icons.camera_alt, size: 28, color: AppColors.primaryColor)
                  : null,
            ),
            if (_editing)
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard({
    required String label,
    File? file,
    String? existingUrl,
    bool uploading = false,
    bool verified = false,
    bool editable = true,
    VoidCallback? onPick,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondaryColor.withAlpha(80)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 64,
              height: 64,
              child: file != null
                  ? Image.file(file, fit: BoxFit.cover)
                  : (existingUrl != null
                      ? CachedNetworkImage(imageUrl: existingUrl, fit: BoxFit.cover)
                      : Container(color: AppColors.secondaryColor.withAlpha(40), child: const Icon(Icons.image, color: Colors.grey))),
            ),
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodyMedium),
                if (verified) ...[
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.verified, size: 14, color: Colors.green),
                      SizedBox(width: 4),
                      Text('terverifikasi', style: AppTextStyles.bodySmall.copyWith(color: Colors.green)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (uploading)
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          else if (_editing && editable)
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: onPick,
            ),
        ],
      ),
    );
  }
}
