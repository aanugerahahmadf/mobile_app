import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_modals.dart';

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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool isKtp}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200, maxHeight: 800);
    if (picked != null) {
      setState(() {
        if (isKtp) {
          _ktpFile = File(picked.path);
        } else {
          _avatarFile = File(picked.path);
        }
      });
    }
  }

  Widget _buildPasswordStrength(String password) {
    final checks = [
      password.length >= 12,
      password.contains(RegExp(r'[A-Z]')),
      password.contains(RegExp(r'[a-z]')),
      password.contains(RegExp(r'[0-9]')),
      password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
    ];
    final score = checks.where((c) => c).length;
    final (label, color, value) = switch (score) {
      0 || 1 => ('password_weak'.tr(), AppColors.errorColor, 0.2),
      2 || 3 => ('password_medium'.tr(), AppColors.warningColor, 0.5),
      _ => ('password_strong'.tr(), AppColors.successColor, 0.9),
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

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      AppSnackBar.show(context, 'setujui_syarat_dulu'.tr(), type: SnackBarType.warning);
      return;
    }
    if (!_rememberMe) {
      AppSnackBar.show(context, 'centang_ingat_saya'.tr(), type: SnackBarType.warning);
      return;
    }
    ref.read(authProvider.notifier).register(
      fullName: _fullName,
      firstName: _firstNameController.text.trim(),
      middleName: _middleNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      nik: _nikController.text.trim(),
      birthPlace: _birthPlaceController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      country: _countryController.text.trim(),
      address: _addressController.text.trim(),
      ktpPhotoPath: _ktpFile?.path,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, state) {
      if (state is AuthAuthenticated) {
        AppSnackBar.show(context, 'registrasi_berhasil'.tr(), type: SnackBarType.success);
        context.go('/home');
      } else if (state is AuthError) {
        AppSnackBar.show(context, state.message, type: SnackBarType.error);
      }
    });

    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: Colors.white,
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
              Center(
                child: Image.asset('assets/images/logo.png', width: 64, height: 64),
              ),
              SizedBox(height: AppSizes.sm),
              Center(child: Text('daftar_akun'.tr(), style: AppTextStyles.headlineMedium)),
              SizedBox(height: AppSizes.xs),
              Center(child: Text('isi_data_diri'.tr(), style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary))),
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
              Row(
                children: [
                  Expanded(flex: 3, child: AppTextField(
                    label: 'nama_depan'.tr(),
                    hint: 'masukkan_nama_depan'.tr(),
                    controller: _firstNameController,
                    validator: Validators.required,
                    onChanged: (_) => setState(() {}),
                  )),
                  SizedBox(width: AppSizes.sm),
                  Expanded(flex: 2, child: AppTextField(
                    label: 'nama_tengah'.tr(),
                    hint: 'masukkan_nama_tengah'.tr(),
                    controller: _middleNameController,
                    onChanged: (_) => setState(() {}),
                  )),
                ],
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: 'nama_belakang'.tr(),
                hint: 'masukkan_nama_belakang'.tr(),
                controller: _lastNameController,
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
                        _fullName.isEmpty ? 'nama_lengkap'.tr() : _fullName,
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
                label: 'username'.tr(),
                hint: 'masukkan_username'.tr(),
                controller: _usernameController,
                validator: Validators.required,
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: 'email'.tr(),
                hint: 'masukkan_email'.tr(),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: 'whatsapp'.tr(),
                hint: 'phone_hint'.tr(),
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: 'nik'.tr(),
                hint: 'nik_hint'.tr(),
                controller: _nikController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'nik_required'.tr();
                  if (v.trim().length != 16) return 'nik_length'.tr();
                  return null;
                },
              ),
              SizedBox(height: AppSizes.sm),
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
                            Text('ktp_photo'.tr(), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text(
                              _ktpFile != null ? 'ktp_photo_uploaded'.tr() : 'ktp_photo_hint'.tr(),
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
              SizedBox(height: AppSizes.md),
              Text('data_identitas'.tr(), style: AppTextStyles.titleMedium),
              SizedBox(height: AppSizes.sm),
              AppTextField(
                label: 'birth_place'.tr(),
                hint: 'birth_place_hint'.tr(),
                controller: _birthPlaceController,
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: 'birth_date'.tr(),
                hint: 'birth_date_hint'.tr(),
                controller: _birthDateController,
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: 'country'.tr(),
                hint: 'country_hint'.tr(),
                controller: _countryController,
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: 'address'.tr(),
                hint: 'address_hint'.tr(),
                controller: _addressController,
                maxLines: 3,
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: 'password'.tr(),
                hint: 'minimal_6_karakter'.tr(),
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
                label: 'konfirmasi_password'.tr(),
                hint: 'ulangi_password'.tr(),
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                validator: (v) => Validators.confirmPassword(v, _passwordController.text),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
              SizedBox(height: AppSizes.md),
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
                          text: TextSpan(
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            children: [
                              TextSpan(text: '${'saya_menyetujui'.tr()} '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => showAgreementModal(context, mode: AgreementMode.terms),
                                  child: Text(
                                    'syarat_ketentuan'.tr(),
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
                                  onTap: () => showAgreementModal(context, mode: AgreementMode.privacy),
                                  child: Text(
                                    'kebijakan_privasi'.tr(),
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
              SizedBox(height: AppSizes.sm),
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
                        'ingat_saya'.tr(),
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.lg),
              AppButton(
                label: 'daftar_sekarang'.tr(),
                loading: isLoading,
                disabled: !_agreeTerms || !_rememberMe,
                onPressed: _onRegister,
              ),
              SizedBox(height: AppSizes.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('sudah_punya_akun'.tr(), style: AppTextStyles.bodyMedium),
                  GestureDetector(
                    onTap: () => showSignInSheet(context),
                    child: Text('sign_in'.tr(), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
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
