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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await DioClient.instance.post(
        ApiEndpoints.forgotPassword,
        data: {'email': _emailController.text.trim()},
      );
      if (!mounted) return;
      AppSnackBar.show(context, 'Kode reset telah dikirim ke email Anda', type: SnackBarType.success);
      context.go('/reset-password');
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(context, 'Gagal mengirim kode reset. Coba lagi.', type: SnackBarType.error);
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
              Text('Lupa Password?', style: AppTextStyles.headlineMedium),
              SizedBox(height: AppSizes.xs),
              Text(
                'Masukkan email Anda untuk menerima kode reset password',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: AppSizes.xl),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              SizedBox(height: AppSizes.xl),
              AppButton(
                label: 'Kirim Kode Reset',
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
