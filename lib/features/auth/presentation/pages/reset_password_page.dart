import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_modals.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await DioClient.instance.post(
        ApiEndpoints.resetPassword,
        data: {
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController.text,
        },
      );
      if (!mounted) return;
      AppSnackBar.show(context, 'Password berhasil direset. Silakan masuk.', type: SnackBarType.success);
      showSignInSheet(context);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(context, 'Gagal mereset password. Coba lagi.', type: SnackBarType.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reset Password', style: AppTextStyles.headlineMedium),
              SizedBox(height: AppSizes.xs),
              Text(
                'Buat password baru untuk akun Anda',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: AppSizes.xl),
              AppTextField(
                label: 'Password Baru',
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: Validators.password,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: 'Konfirmasi Password Baru',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                validator: (v) => Validators.confirmPassword(v, _passwordController.text),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
              SizedBox(height: AppSizes.xl),
              AppButton(
                label: 'Reset Password',
                loading: _loading,
                onPressed: _onResetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
