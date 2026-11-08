import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../../Core/Api/DioClient/DioClient.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../../../../Core/Widgets/AppTextField/AppTextField.dart';
import '../../../../../Core/Widgets/AppSnackbar/AppSnackbar.dart';
import '../../../../../Core/Utils/Validators/Validators.dart';
import '../../Widgets/AuthModals/AuthModals.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordScreen> {
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
    final l = AppLocalizations.of(context)!;
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
      AppSnackBar.show(
        context,
        l.passwordResetSuccess,
        type: SnackBarType.success,
      );
      showSignInSheet(context);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        l.passwordResetFailed,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.resetPassword, style: AppTextStyles.headlineMedium),
              SizedBox(height: AppSizes.xs),
              Text(
                l.createNewPassword,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.xl),
              AppTextField(
                label: l.newPassword,
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: Validators.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              SizedBox(height: AppSizes.md),
              AppTextField(
                label: l.confirmNewPassword,
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                validator: (v) =>
                    Validators.confirmPassword(v, _passwordController.text),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.xl),
              AppButton(
                label: l.resetPassword,
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
