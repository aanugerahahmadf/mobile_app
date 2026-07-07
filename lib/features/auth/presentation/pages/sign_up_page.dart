import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
import '../../../../core/utils/ktp_utils.dart';
import '../../../../core/utils/passport_utils.dart';
import '../../../../core/utils/sim_utils.dart';
import '../../../../core/utils/npwp_utils.dart';
import '../../../../core/utils/country_codes.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_modals.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _nikController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _countryController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _rememberMe = false;
  File? _avatarFile;
  File? _ktpFile;
  File? _selfieKtpFile;
  String? _faceScanPath;
  bool _namesLocked = false;
  String _ocrExtractedName = '';
  String _identityType = 'ktp'; // 'ktp' or 'passport'
  String _countryCode = '+62';
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

  String _idLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp': return l.nikLabel;
      case 'passport': return l.passportLabel;
      case 'sim': return l.simLabel;
      case 'npwp': return l.npwpLabel;
      default: return l.identityNumber;
    }
  }
  String _idPhotoLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp': return l.ktpPhoto;
      case 'passport': return l.passportPhoto;
      case 'sim': return l.simPhoto;
      case 'npwp': return l.npwpPhoto;
      default: return l.identityPhoto;
    }
  }
  String _idSelfieLabel(AppLocalizations l) {
    switch (_identityType) {
      case 'ktp': return l.selfieKtp;
      case 'passport': return l.selfiePassport;
      case 'sim': return l.selfieSim;
      case 'npwp': return l.selfieNpwp;
      default: return l.selfieIdentity;
    }
  }

  String get _fullName => [
    _firstNameController.text.trim(),
    _middleNameController.text.trim(),
    _lastNameController.text.trim(),
  ].where((s) => s.isNotEmpty).join(' ');

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 8),
              Text(title, style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              ...options.map((option) => ListTile(
                title: Text(option, style: AppTextStyles.bodyMedium),
                onTap: () {
                  onSelected(option);
                  Navigator.pop(ctx);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showIdentityTypeSheet() {
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.idType, style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.credit_card, color: _identityType == 'ktp' ? AppColors.primaryColor : null),
                title: Text(AppLocalizations.of(context)!.ktp, style: AppTextStyles.bodyMedium),
                trailing: _identityType == 'ktp' ? Icon(Icons.check, color: AppColors.primaryColor) : null,
                onTap: () {
                  setState(() {
                    _identityType = 'ktp';
                    _ktpFile = null;
                    _nikController.clear();
                    _namesLocked = false;
                    _ocrExtractedName = '';
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.card_travel, color: _identityType == 'passport' ? AppColors.primaryColor : null),
                title: Text(AppLocalizations.of(context)!.passport, style: AppTextStyles.bodyMedium),
                trailing: _identityType == 'passport' ? Icon(Icons.check, color: AppColors.primaryColor) : null,
                onTap: () {
                  setState(() {
                    _identityType = 'passport';
                    _ktpFile = null;
                    _nikController.clear();
                    _namesLocked = false;
                    _ocrExtractedName = '';
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.drive_eta, color: _identityType == 'sim' ? AppColors.primaryColor : null),
                title: Text(AppLocalizations.of(context)!.sim, style: AppTextStyles.bodyMedium),
                trailing: _identityType == 'sim' ? Icon(Icons.check, color: AppColors.primaryColor) : null,
                onTap: () {
                  setState(() {
                    _identityType = 'sim';
                    _ktpFile = null;
                    _nikController.clear();
                    _namesLocked = false;
                    _ocrExtractedName = '';
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt_long, color: _identityType == 'npwp' ? AppColors.primaryColor : null),
                title: Text(AppLocalizations.of(context)!.npwp, style: AppTextStyles.bodyMedium),
                trailing: _identityType == 'npwp' ? Icon(Icons.check, color: AppColors.primaryColor) : null,
                onTap: () {
                  setState(() {
                    _identityType = 'npwp';
                    _ktpFile = null;
                    _nikController.clear();
                    _namesLocked = false;
                    _ocrExtractedName = '';
                  });
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdentityTypePicker() {
    final l10n = AppLocalizations.of(context)!;
    final (icon, label) = switch (_identityType) {
      'ktp' => (Icons.credit_card, l10n.ktp),
      'passport' => (Icons.card_travel, l10n.passport),
      'sim' => (Icons.drive_eta, l10n.sim),
      'npwp' => (Icons.receipt_long, l10n.npwp),
      _ => (Icons.credit_card, l10n.idType),
    };
    return GestureDetector(
      onTap: _showIdentityTypeSheet,
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
                label,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(l.whatsappNumber, style: AppTextStyles.titleSmall),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country code button
            GestureDetector(
              onTap: _showCountryCodePicker,
              child: Container(
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dividerColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _countryCode,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.arrow_drop_down, size: 20, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Phone number field
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
      ],
    );
  }


  void _showCountryCodePicker() {
    final searchController = TextEditingController();
    List<CountryCode> codes = List.of(countryCodes);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              children: [
                const SizedBox(height: 8),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(this.context)!.searchCountry,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (v) {
                      setSheetState(() {
                        codes = countryCodes.where((c) =>
                          c.name.toLowerCase().contains(v.toLowerCase()) ||
                          c.dialCode.contains(v)).toList();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: codes.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(
                      dense: true,
                      leading: Text(codes[i].flag, style: const TextStyle(fontSize: 22)),
                      title: Text(codes[i].name, style: AppTextStyles.bodyMedium),
                      trailing: Text(codes[i].dialCode, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      onTap: () {
                        setState(() => _countryCode = codes[i].dialCode);
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _pickImage({required bool isKtp}) async {
    if (isKtp) {
      final file = await pickKtpPhoto(context);
      if (file != null) {
        setState(() => _ktpFile = file);
        String nik = '';
        String name = '';
        if (_identityType == 'ktp') {
          nik = await extractNikFromKtp(file);
          name = await extractNameFromKtp(file);
        } else if (_identityType == 'passport') {
          nik = await extractPassportNumber(file);
          name = await extractNameFromPassport(file);
        } else if (_identityType == 'sim') {
          nik = await extractSimNumber(file);
          name = await extractNameFromSim(file);
        } else if (_identityType == 'npwp') {
          nik = await extractNpwpNumber(file);
          name = await extractNameFromNpwp(file);
        }
        setState(() {
          _ocrExtractedName = name;
          if (nik.isNotEmpty) _nikController.text = nik;
        });
        if (name.isNotEmpty) {
          final parts = splitKtpName(name);
          setState(() {
            _firstNameController.text = parts[0];
            _middleNameController.text = parts[1];
            _lastNameController.text = parts[2];
            _namesLocked = true;
          });
        }
      }
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
    if (picked != null) {
      setState(() => _avatarFile = File(picked.path));
    }
  }

  Widget _buildPasswordStrength(String password) {
    final l = AppLocalizations.of(context)!;
    final checks = [
      password.length >= 12,
      password.contains(RegExp(r'[A-Z]')),
      password.contains(RegExp(r'[a-z]')),
      password.contains(RegExp(r'[0-9]')),
      password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
    ];
    final score = checks.where((c) => c).length;
    final (label, color, value) = switch (score) {
      0 || 1 => (l.passwordStrengthWeak, AppColors.errorColor, 0.2),
      2 || 3 => (l.passwordStrengthMedium, AppColors.warningColor, 0.5),
      _ => (l.passwordStrengthStrong, AppColors.successColor, 0.9),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: AppColors.dividerColor,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
      ],
    );
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      AppSnackBar.show(context, AppLocalizations.of(context)!.youMustAgree, type: SnackBarType.warning);
      return;
    }
    if (!_rememberMe) {
      AppSnackBar.show(context, AppLocalizations.of(context)!.rememberMe, type: SnackBarType.warning);
      return;
    }
    if (_ktpFile != null) {
      if (!_namesLocked && _ocrExtractedName.isEmpty) {
        final l = AppLocalizations.of(context)!;
        AppSnackBar.show(context, '${l.nameVerificationFailed} ${_idPhotoLabel(l)}. ${l.uploadPhoto} ${l.selfieTips}', type: SnackBarType.error);
        return;
      }
      if (_ocrExtractedName.isNotEmpty) {
        final enteredName = _fullName.toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
        final ocrName = _ocrExtractedName.toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
        if (!enteredName.contains(ocrName) && !ocrName.contains(enteredName)) {
          final l = AppLocalizations.of(context)!;
          AppSnackBar.show(context, '${l.nameNotMatch} ${_idPhotoLabel(l)}', type: SnackBarType.error);
          return;
        }
      }
    }
    ref.read(authProvider.notifier).register(
      fullName: _fullName,
      firstName: _firstNameController.text.trim(),
      middleName: _middleNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      whatsapp: '$_countryCode ${_whatsappController.text.trim()}',
      nik: _identityType == 'ktp' ? _nikController.text.trim() : '',
      passportNumber: _identityType == 'passport' ? _nikController.text.trim() : null,
      simNumber: _identityType == 'sim' ? _nikController.text.trim() : null,
      npwpNumber: _identityType == 'npwp' ? _nikController.text.trim() : null,
      identityType: _identityType,
      birthPlace: _birthPlaceController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      country: _countryController.text.trim(),
      provinceId: _provinceId,
      cityId: _cityId,
      districtId: _districtId,
      villageId: _villageId,
      provinceName: _provinceName,
      cityName: _cityName,
      districtName: _districtName,
      villageName: _villageName,
      postalCode: _postalCode,
      address: _addressController.text.trim(),
      gender: _gender,
      religion: _religion,
      maritalStatus: _maritalStatus,
      motherName: _motherNameController.text.trim(),
      occupation: _occupation,
      incomeRange: _incomeRange,
      sourceOfFunds: _sourceOfFunds,
      ktpPhotoPath: _ktpFile?.path,
      selfiePhotoPath: _selfieKtpFile?.path,
      faceScanPath: _faceScanPath,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, state) {
      if (state is AuthAuthenticated) {
        AppSnackBar.show(context, 'Registrasi berhasil', type: SnackBarType.success);
        context.go('/home');
      } else if (state is AuthError) {
        AppSnackBar.show(context, state.message, type: SnackBarType.error);
      }
    });

    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.sm),
              Center(child: Text(l.createAccount, style: AppTextStyles.headlineMedium)),
              SizedBox(height: AppSizes.xs),
              Center(child: Text(l.fillDataCorrectly, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary))),
              SizedBox(height: AppSizes.lg),
              Center(
                child: GestureDetector(
                  onTap: () => _pickImage(isKtp: false),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.secondaryColor,
                        backgroundImage: _avatarFile != null ? FileImage(_avatarFile!) : null,
                        child: _avatarFile == null
                            ? Icon(Icons.camera_alt, size: 28, color: AppColors.primaryColor)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSizes.lg),
              AppTextField(
                label: l.firstName,
                controller: _firstNameController,
                readOnly: _namesLocked,
                validator: Validators.required,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: l.middleName,
                controller: _middleNameController,
                readOnly: _namesLocked,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: l.lastName,
                controller: _lastNameController,
                readOnly: _namesLocked,
                validator: Validators.required,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: AppSizes.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18, color: AppColors.textSecondary),
                    SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        _fullName.isEmpty ? l.fullName : _fullName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _fullName.isEmpty ? AppColors.textTertiary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.lg),
              AppTextField(
                label: l.username,
                controller: _usernameController,
                validator: Validators.required,
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: l.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              SizedBox(height: AppSizes.md),
              _buildPhoneField(),
              SizedBox(height: AppSizes.lg),
              Text(l.idType, style: AppTextStyles.titleSmall),
              SizedBox(height: AppSizes.sm),
              _buildIdentityTypePicker(),
              SizedBox(height: AppSizes.md),
              GestureDetector(
                onTap: () => _pickImage(isKtp: true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _ktpFile != null ? AppColors.successColor.withAlpha(20) : AppColors.secondaryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _ktpFile != null ? AppColors.successColor : AppColors.dividerColor,
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _ktpFile != null ? Icons.check_circle : Icons.credit_card_outlined,
                        color: _ktpFile != null ? AppColors.successColor : AppColors.textSecondary,
                        size: 28,
                      ),
                      SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_idPhotoLabel(l), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text(
                              _ktpFile != null ? l.idPhotoUploaded : l.uploadIdPhotoAction,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: _ktpFile != null ? AppColors.successColor : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_ktpFile != null)
                        GestureDetector(
                          onTap: () => setState(() => _ktpFile = null),
                          child: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSizes.sm),
              GestureDetector(
                onTap: () async {
                  final file = await pickKtpPhoto(context);
                  if (file != null) setState(() => _selfieKtpFile = file);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _selfieKtpFile != null ? AppColors.successColor.withAlpha(20) : AppColors.secondaryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selfieKtpFile != null ? AppColors.successColor : AppColors.dividerColor,
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selfieKtpFile != null ? Icons.check_circle : Icons.person,
                        color: _selfieKtpFile != null ? AppColors.successColor : AppColors.textSecondary,
                        size: 28,
                      ),
                      SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_idSelfieLabel(l), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text(
                              _selfieKtpFile != null ? l.selfiePhotoUploaded : l.uploadSelfiePhotoAction,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: _selfieKtpFile != null ? AppColors.successColor : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selfieKtpFile != null)
                        GestureDetector(
                          onTap: () => setState(() => _selfieKtpFile = null),
                          child: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSizes.sm),
              GestureDetector(
                onTap: () async {
                  final path = await context.push<String>('/face-scanner');
                  if (path != null) setState(() => _faceScanPath = path);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _faceScanPath != null ? AppColors.successColor.withAlpha(20) : AppColors.secondaryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _faceScanPath != null ? AppColors.successColor : AppColors.dividerColor,
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _faceScanPath != null ? Icons.check_circle : Icons.face_retouching_natural,
                        color: _faceScanPath != null ? AppColors.successColor : AppColors.textSecondary,
                        size: 28,
                      ),
                      SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(l.faceVerification, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text(
                              _faceScanPath != null ? l.faceScanSuccess : l.scanFace,
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
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: _idLabel(l),
                controller: _nikController,
                keyboardType: _identityType == 'ktp' ? TextInputType.number : TextInputType.text,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l.identityNumberRequired(_idLabel(l));
                  if (_identityType == 'ktp' && v.trim().length != 16) return l.nikMustBe16Digits;
                  if (_identityType == 'sim' && v.trim().length < 6) return l.simMin6Chars;
                  if (_identityType == 'npwp' && v.trim().length < 15) return l.npwpMin15Chars;
                  if (!['ktp', 'sim', 'npwp'].contains(_identityType) && v.trim().length < 6) return l.nikMin6Chars;
                  return null;
                },
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: l.placeOfBirth,
                controller: _birthPlaceController,
              ),
              SizedBox(height: AppSizes.md),
              AppDatePickerField(
                label: l.dateOfBirth,
                controller: _birthDateController,
              ),
              SizedBox(height: AppSizes.md),
              AppCountryPickerField(
                label: l.country,
                controller: _countryController,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: AppSizes.md),
              AppRegionPickerField(
                country: _countryController.text.isEmpty ? null : _countryController.text,
                onProvinceIdChanged: (id) => _provinceId = id,
                onCityIdChanged: (id) => _cityId = id,
                onDistrictIdChanged: (id) => _districtId = id,
                onVillageIdChanged: (id) => _villageId = id,
                onProvinceNameChanged: (v) => _provinceName = v,
                onCityNameChanged: (v) => _cityName = v,
                onDistrictNameChanged: (v) => _districtName = v,
                onVillageNameChanged: (v) => _villageName = v,
                onPostalCodeChanged: (v) => _postalCode = v,
              ),
              AppTextField(
                label: l.fullAddress,
                controller: _addressController,
                maxLines: 2,
              ),
              SizedBox(height: AppSizes.md),
              Text(l.gender, style: AppTextStyles.titleSmall),
              SizedBox(height: AppSizes.sm),
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
              SizedBox(height: AppSizes.md),
              Text(l.religion, style: AppTextStyles.titleSmall),
              SizedBox(height: AppSizes.sm),
              GestureDetector(
                onTap: () => _showPickerSheet(l.selectReligion, ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'], (v) => setState(() => _religion = v)),
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
              SizedBox(height: AppSizes.md),
              Text(l.maritalStatus, style: AppTextStyles.titleSmall),
              SizedBox(height: AppSizes.sm),
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
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: l.motherName,
                controller: _motherNameController,
              ),
              SizedBox(height: AppSizes.md),
              Text(l.occupation, style: AppTextStyles.titleSmall),
              SizedBox(height: AppSizes.sm),
              GestureDetector(
                onTap: () => _showPickerSheet(l.selectOccupation, ['Karyawan', 'Wiraswasta', 'Pelajar/Mahasiswa', 'Ibu Rumah Tangga', 'Profesional', 'Lainnya'], (v) => setState(() => _occupation = v)),
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
              SizedBox(height: AppSizes.md),
              Text(l.incomeRange, style: AppTextStyles.titleSmall),
              SizedBox(height: AppSizes.sm),
              GestureDetector(
                onTap: () => _showPickerSheet(l.selectIncomeRange, ['< Rp 1 Juta', 'Rp 1-5 Juta', 'Rp 5-10 Juta', 'Rp 10-50 Juta', '> Rp 50 Juta'], (v) => setState(() => _incomeRange = v)),
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
              SizedBox(height: AppSizes.md),
              Text(l.sourceOfFunds, style: AppTextStyles.titleSmall),
              SizedBox(height: AppSizes.sm),
              GestureDetector(
                onTap: () => _showPickerSheet(l.selectSourceOfFunds, ['Gaji', 'Bisnis/Usaha', 'Investasi', 'Hadiah/Warisan', 'Lainnya'], (v) => setState(() => _sourceOfFunds = v)),
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
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: l.password,
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: Validators.password,
                onChanged: (_) => setState(() {}),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              if (_passwordController.text.isNotEmpty) ...[
                const SizedBox(height: 6),
                _buildPasswordStrength(_passwordController.text),
              ],
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: l.confirmPassword,
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                validator: (v) => Validators.confirmPassword(v, _passwordController.text),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
              SizedBox(height: AppSizes.md),
              // Ingat Saya
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (v) => setState(() => _rememberMe = v ?? false),
                      activeColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: Text(
                        l.rememberMe,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.sm),
              // Setujui S&K
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                      child: Checkbox(
                        value: _agreeTerms,
                        onChanged: (v) {
                          if (v == true) {
                            showAgreementModal(context, mode: AgreementMode.wizard, onAgreed: () {
                              setState(() => _agreeTerms = true);
                            });
                          } else {
                            setState(() => _agreeTerms = false);
                          }
                        },
                        activeColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (!_agreeTerms) {
                            showAgreementModal(context, mode: AgreementMode.wizard, onAgreed: () {
                              setState(() => _agreeTerms = true);
                            });
                          } else {
                            setState(() => _agreeTerms = false);
                          }
                        },
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            children: [
                              TextSpan(text: l.agreeTerms),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => context.push('/terms-of-service'),
                                  child: Text(
                                    l.termsOfService,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              const TextSpan(text: ' & '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => context.push('/privacy-policy'),
                                  child: Text(
                                    l.privacyPolicy,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppSizes.lg),
              AppButton(
                label: l.signUp,
                loading: isLoading,
                disabled: !_agreeTerms || !_rememberMe,
                onPressed: _onRegister,
              ),
              SizedBox(height: AppSizes.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l.alreadyHaveAccount, style: AppTextStyles.bodyMedium),
                  GestureDetector(
                    onTap: () => showSignInSheet(context),
                    child: Text(l.signIn, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }
}
