import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../core/widgets/app_text_field/app_text_field.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/utils/guest_mode/guest_mode.dart';
import '../../../../../core/widgets/app_snackbar/app_snackbar.dart';
import '../../../../../core/utils/validators/validators.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../widgets/auth_modals/auth_modals.dart';
import '../../widgets/social_login_button/social_login_button.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeTerms = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      AppSnackBar.show(
        context,
        AppLocalizations.of(context)!.youMustAgree,
        type: SnackBarType.warning,
      );
      return;
    }
    ref
        .read(authProvider.notifier)
        .login(
          login: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  Future<void> _onGoogleLogin() async {
    if (!_agreeTerms) {
      AppSnackBar.show(
        context,
        AppLocalizations.of(context)!.youMustAgree,
        type: SnackBarType.warning,
      );
      return;
    }
    await ref.read(authProvider.notifier).googleLogin();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, state) {
      if (state is AuthAuthenticated) {
        clearGuestMode();
        if (state.needsOtp) {
          showOtpVerificationSheet(
            context,
            email: state.user.email,
            purpose: 'google_register',
          );
        } else if (state.needsCompletion) {
          AppSnackBar.show(
            context,
            l.completeYourProfile,
            type: SnackBarType.info,
          );
          context.push('/edit-profile');
        } else {
          AppSnackBar.show(context, l.success, type: SnackBarType.success);
          context.go('/home');
        }
      } else if (state is AuthError) {
        AppSnackBar.show(
          context,
          LocalizedError.of(l, state.message),
          type: SnackBarType.error,
        );
      }
    });

    final isLoading = authState is AuthLoading;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [AppColors.primaryLight, AppColors.surfaceColor],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.lg),
                  // Email
                  AppTextField(
                    label: l.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: AppSizes.md),
                  // Password + Lupa Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l.password,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => showForgotPasswordSheet(context),
                        child: Text(
                          l.forgotPassword,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppTextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: Validators.password,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  // Ingat Saya
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (v) =>
                              setState(() => _rememberMe = v ?? false),
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _rememberMe = !_rememberMe),
                        child: Text(
                          l.rememberMe,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
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
                              showAgreementModal(
                                context,
                                mode: AgreementMode.wizard,
                                onAgreed: () {
                                  setState(() => _agreeTerms = true);
                                },
                              );
                            } else {
                              setState(() => _agreeTerms = false);
                            }
                          },
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!_agreeTerms) {
                              showAgreementModal(
                                context,
                                mode: AgreementMode.wizard,
                                onAgreed: () {
                                  setState(() => _agreeTerms = true);
                                },
                              );
                            } else {
                              setState(() => _agreeTerms = false);
                            }
                          },
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(text: l.agreementPrefix),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () =>
                                        context.push('/terms-of-service'),
                                    child: Text(
                                      l.userAgreement,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(text: l.comma),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () =>
                                        context.push('/privacy-policy'),
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
                                TextSpan(text: l.andWord),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => showAgreementModal(
                                      context,
                                      mode: AgreementMode.weddingPolicy,
                                    ),
                                    child: Text(
                                      l.appPolicy,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(text: l.agreementSuffix),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.lg),
                  // Tombol Masuk
                  AppButton(
                    label: l.signIn,
                    loading: isLoading,
                    disabled: !_agreeTerms,
                    onPressed: _onLogin,
                    type: ButtonType.primaryGradient,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  // Atau
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                        ),
                        child: Text(
                          l.or,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),
                  SocialLoginButton(
                    provider: SocialProvider.google,
                    enabled: true,
                    onPressed: _onGoogleLogin,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  // Daftar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l.dontHaveAccount, style: AppTextStyles.bodyMedium),
                      GestureDetector(
                        onTap: () => showSignUpSheet(context),
                        child: Text(
                          ' ${l.signUp}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
