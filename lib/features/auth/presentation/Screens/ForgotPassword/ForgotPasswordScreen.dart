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
import 'package:mobile_app/L10n/AppLocalizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetCode() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await DioClient.instance.post(
        ApiEndpoints.forgotPassword,
        data: {'email': _emailController.text.trim()},
      );
      if (!mounted) return;
      AppSnackBar.show(context, l.resetCodeSent, type: SnackBarType.success);
      context.go('/reset-password');
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(context, l.sendFailed, type: SnackBarType.error);
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
              Text(l.forgotPassword, style: AppTextStyles.headlineMedium),
              SizedBox(height: AppSizes.xs),
              Text(
                l.enterEmailForResetPassword,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.xl),
              AppTextField(
                label: l.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              SizedBox(height: AppSizes.xl),
              AppButton(
                label: l.sendOtp,
                loading: _loading,
                onPressed: _onSendResetCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
