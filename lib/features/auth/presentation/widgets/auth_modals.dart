import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/api/api_endpoints.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/ktp_utils.dart';
import '../../../../core/utils/passport_utils.dart';
import '../../../../core/utils/sim_utils.dart';
import '../../../../core/utils/npwp_utils.dart';
import '../../../../core/utils/country_codes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_date_picker_field.dart';
import '../../../../core/widgets/app_country_picker_field.dart';
import '../../../../core/widgets/app_region_picker_field.dart';
import '../../../legal/data/models/legal_model.dart';
import '../../../legal/presentation/providers/legal_provider.dart';
import '../providers/auth_provider.dart';
import 'auth_header.dart';
import 'social_login_button.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

enum AgreementMode { wizard, terms, privacy, weddingPolicy }

void showAgreementModal(BuildContext context, {AgreementMode mode = AgreementMode.wizard, VoidCallback? onAgreed}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AgreementModal(mode: mode, onAgreed: onAgreed),
  );
}

class _AgreementModal extends StatefulWidget {
  final AgreementMode mode;
  final VoidCallback? onAgreed;
  const _AgreementModal({this.mode = AgreementMode.wizard, this.onAgreed});

  @override
  State<_AgreementModal> createState() => _AgreementModalState();
}

class _AgreementModalState extends State<_AgreementModal> {
  late int _step;

  @override
  void initState() {
    super.initState();
    _step = widget.mode == AgreementMode.wizard ? 1 : 1;
  }

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isWizard = widget.mode == AgreementMode.wizard;
    final isWedding = widget.mode == AgreementMode.weddingPolicy;

    String title;
    if (isWedding) {
      title = l.appPolicy;
    } else if (_step == 1) {
      title = l.termsOfService;
    } else if (_step == 2) {
      title = l.privacyPolicy;
    } else {
      title = l.appPolicy;
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _close,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.dividerColor),
            Expanded(
              child: isWedding
                  ? _LegalContentView(
                      provider: weddingDecorationPolicyProvider,
                      isWizard: false,
                      onNext: null,
                      onAgreed: null,
                      onClose: _close,
                    )
                  : (_step == 1
                      ? _LegalContentView(
                          provider: termsOfServiceProvider,
                          isWizard: isWizard,
                          onNext: isWizard ? () => setState(() => _step = 2) : null,
                          onClose: !isWizard ? _close : null,
                        )
                      : (_step == 2
                          ? _LegalContentView(
                              provider: privacyPolicyProvider,
                              isWizard: isWizard,
                              onNext: isWizard ? () => setState(() => _step = 3) : null,
                              onClose: !isWizard ? _close : null,
                            )
                          : _LegalContentView(
                              provider: weddingDecorationPolicyProvider,
                              isWizard: isWizard,
                              onNext: null,
                              onAgreed: isWizard
                                  ? () {
                                      widget.onAgreed?.call();
                                      _close();
                                    }
                                  : null,
                              onClose: !isWizard ? _close : null,
                            ))),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalContentView extends ConsumerWidget {
  final FutureProvider<LegalContent> provider;
  final bool isWizard;
  final VoidCallback? onNext;
  final VoidCallback? onAgreed;
  final VoidCallback? onClose;

  const _LegalContentView({
    required this.provider,
    this.isWizard = false,
    this.onNext,
    this.onAgreed,
    this.onClose,
  });

  List<dynamic>? _parseContent(dynamic content) {
    if (content is List) return content;
    if (content is String && content.startsWith('[')) {
      try {
        final decoded = jsonDecode(content);
        if (decoded is List) return decoded;
      } catch (_) {}
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(provider);

    return async.when(
      loading: () => const Center(child: AppShimmer(width: 200, height: 16)),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text(l.failedLoadPage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.invalidate(provider),
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l.tryAgain),
              ),
            ],
          ),
        ),
      ),
      data: (content) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(content.title,
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                  if (content.updatedAt != null) ...[
                    const SizedBox(height: 8),
                    Text('${l.lastUpdated}: ${content.updatedAt}',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 16),
                  if (_parseContent(content.content) case final List sections?)
                    ...sections.map<Widget>((section) {
                      final heading = section['heading'] as String?;
                      final body = section['body'] as String?;
                      final isItalic = section['is_italic'] == true;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (heading != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(heading, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                              ),
                            Text(body ?? '', textAlign: TextAlign.justify, style: GoogleFonts.inter(fontSize: 14, height: 1.6, fontStyle: isItalic ? FontStyle.italic : FontStyle.normal)),
                          ],
                        ),
                      );
                    })
                  else
                    Text(
                      content.content is String
                          ? content.content as String
                          : (content.content is Map ? (content.content?['text'] as String? ?? (content.content?['content'] as String? ?? '')) : ''),
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.inter(fontSize: 14, height: 1.6),
                    ),
                ],
              ),
            ),
          ),
          if (onNext != null || onAgreed != null || onClose != null)
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                border: Border(top: BorderSide(color: AppColors.dividerColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onNext != null)
                    AppButton(
                      label: l.proceed,
                      onPressed: onNext,
                      type: ButtonType.primary,
                      width: 140,
                    ),
                  if (onAgreed != null)
                    Expanded(
                      child: AppButton(
                        label: l.iUnderstandAndAgree,
                        onPressed: onAgreed,
                        type: ButtonType.primary,
                      ),
                    ),
                  if (onClose != null)
                    AppButton(
                      label: l.close,
                      onPressed: onClose,
                      type: ButtonType.outline,
                      width: 120,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> showSignInSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _SignInSheetContent()),
  );
}

Future<void> showSignUpSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _SignUpSheetContent()),
  );
}

Future<void> showForgotPasswordSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _ForgotPasswordSheetContent()),
  );
}

Future<void> showOtpVerificationSheet(BuildContext context, {String? email, String purpose = 'forgot_password'}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AuthSheetWrapper(child: _OtpVerificationSheetContent(email: email, purpose: purpose)),
  );
}

Future<void> showResetPasswordSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _ResetPasswordSheetContent()),
  );
}

class _AuthSheetWrapper extends StatelessWidget {
  final Widget child;
  const _AuthSheetWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SignInSheetContent extends ConsumerStatefulWidget {
  const _SignInSheetContent();

  @override
  ConsumerState<_SignInSheetContent> createState() => _SignInSheetContentState();
}

class _SignInSheetContentState extends ConsumerState<_SignInSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeTerms = false;
  bool _rememberMe = false;
  String _loginType = 'email';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _loginLabel {
    final l = AppLocalizations.of(context)!;
    switch (_loginType) {
      case 'nik':
        return l.nikLabel;
      case 'passport':
        return l.passportLabel;
      case 'sim':
        return l.simLabel;
      case 'npwp':
        return l.npwpLabel;
      case 'username':
        return l.username;
      default:
        return l.email;
    }
  }

  TextInputType get _loginKeyboardType {
    switch (_loginType) {
      case 'nik':
      case 'npwp':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  String? _loginValidator(String? value) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) return '$_loginLabel ${l.fieldRequired}';
    final clean = value.trim();
    switch (_loginType) {
      case 'email':
        return Validators.email(value);
      case 'nik':
        if (!RegExp(r'^\d{16}$').hasMatch(clean)) return l.nikMustBe16Digits;
        return null;
      case 'passport':
        if (!RegExp(r'^[A-Z0-9]{6,9}$').hasMatch(clean.toUpperCase())) return l.invalidPassportFormat;
        return null;
      case 'sim':
        if (!isValidSimNumber(clean)) return l.invalidSimNumber;
        return null;
      case 'npwp':
        if (!isValidNpwpNumber(clean)) return l.invalidNpwpNumber;
        return null;
      default:
        return null;
    }
  }

  Widget _buildLoginTypeSelector() {
    final l = AppLocalizations.of(context)!;
    final types = ['email', 'username', 'nik', 'passport', 'sim', 'npwp'];
    final labels = {'email': l.email, 'username': l.username, 'nik': l.nikShort, 'passport': l.passport, 'sim': l.simShort, 'npwp': l.npwpShort};
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((key) {
        final isSelected = _loginType == key;
        final label = labels[key]!;
          return Padding(
            padding: EdgeInsets.only(left: key == 'email' ? 0 : 4),
            child: SizedBox(
              height: 32,
              child: OutlinedButton(
            onPressed: () {
              setState(() {
                _loginType = key;
                _emailController.clear();
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: isSelected ? AppColors.primaryColor : Colors.transparent,
              side: BorderSide(color: isSelected ? AppColors.primaryColor : AppColors.textTertiary),
              foregroundColor: isSelected ? Colors.white : AppColors.textSecondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),
        );
        }).toList(),
      ),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      _showWarning(AppLocalizations.of(context)!.warningMustAgree);
      return;
    }
    if (!_rememberMe) {
      _showWarning(AppLocalizations.of(context)!.warningCheckRemember);
      return;
    }
    ref.read(authProvider.notifier).login(
      login: _emailController.text.trim(),
      password: _passwordController.text,
      loginType: _loginType,
    );
  }

  Future<void> _onGoogleLogin() async {
    final l = AppLocalizations.of(context)!;
    if (!_agreeTerms) {
      _showWarning(l.warningMustAgree);
      return;
    }
    if (!_rememberMe) {
      _showWarning(l.warningCheckRemember);
      return;
    }
    await ref.read(authProvider.notifier).googleLogin();
  }

  void _showWarning(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.warningColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, state) {
      if (state is AuthAuthenticated) {
        if (state.needsOtp) {
          Navigator.of(context).pop();
          showOtpVerificationSheet(context, email: state.user.email, purpose: 'google_register');
        } else if (state.needsCompletion) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.completeYourProfile), backgroundColor: AppColors.infoColor),
          );
          GoRouter.of(context).push('/profile-field');
        } else {
          final messenger = ScaffoldMessenger.of(context);
          final router = GoRouter.of(context);
          Navigator.of(context).pop();
          messenger.showSnackBar(
            SnackBar(content: Text(l.loginSuccess), backgroundColor: AppColors.successColor),
          );
          router.go('/home');
        }
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: AppColors.errorColor),
        );
      }
    });

    final isLoading = authState is AuthLoading;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg + MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AuthHeader(title: '${l.welcome},', subtitle: l.signInSubtitle),
            const SizedBox(height: AppSizes.lg),
            _buildLoginTypeSelector(),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: _loginLabel,
              controller: _emailController,
              keyboardType: _loginKeyboardType,
              validator: _loginValidator,
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(l.password, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showForgotPasswordSheet(context);
                  },
                  child: Text(l.forgotPassword, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            AppTextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: Validators.password,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            _rememberCheckbox(),
            const SizedBox(height: AppSizes.sm),
            _agreementCheckbox(),
            const SizedBox(height: AppSizes.md),
            AppButton(
              label: l.signIn,
              loading: isLoading,
              disabled: !_agreeTerms || !_rememberMe,
              onPressed: _onLogin,
              type: ButtonType.primaryGradient,
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Text(l.or, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            SocialLoginButton(provider: SocialProvider.google, enabled: _agreeTerms && _rememberMe, onPressed: _onGoogleLogin),
            const SizedBox(height: AppSizes.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l.dontHaveAccount, style: AppTextStyles.bodyMedium),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    showSignUpSheet(context);
                  },
                  child: Text(l.signUp, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _agreementCheckbox() {
    final l = AppLocalizations.of(context)!;
    return Row(
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
        const SizedBox(width: 8),
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
                  TextSpan(text: l.agreementPrefix),
                  TextSpan(
                    text: l.userAgreement,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => showAgreementModal(context, mode: AgreementMode.terms),
                  ),
                  TextSpan(text: l.comma),
                  TextSpan(
                    text: l.privacyPolicy,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => showAgreementModal(context, mode: AgreementMode.privacy),
                  ),
                  TextSpan(text: l.andWord),
                  TextSpan(
                    text: l.appPolicy,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => showAgreementModal(context, mode: AgreementMode.weddingPolicy),
                  ),
                  TextSpan(text: l.agreementSuffix),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rememberCheckbox() {
    final l = AppLocalizations.of(context)!;
    return Row(
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
        const SizedBox(width: 8),
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
    );
  }
}

class _SignUpSheetContent extends ConsumerStatefulWidget {
  const _SignUpSheetContent();

  @override
  ConsumerState<_SignUpSheetContent> createState() => _SignUpSheetContentState();
}

class _SignUpSheetContentState extends ConsumerState<_SignUpSheetContent> {
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
  int? _provinceId;
  int? _cityId;
  int? _districtId;
  int? _villageId;
  String _provinceName = '';
  String _cityName = '';
  String _districtName = '';
  String _villageName = '';
  String _postalCode = '';
  String _identityType = 'ktp';
  String _countryCode = '+62';
  String _gender = '';
  String _religion = '';
  String _maritalStatus = '';
  final _motherNameController = TextEditingController();
  String _occupation = '';
  String _incomeRange = '';
  String _sourceOfFunds = '';

  String get _idLabel {
    final l = AppLocalizations.of(context)!;
    switch (_identityType) {
      case 'ktp': return l.nikLabel;
      case 'passport': return l.passportLabel;
      case 'sim': return l.simLabel;
      case 'npwp': return l.npwpLabel;
      default: return l.idNumber;
    }
  }
  String get _idPhotoLabel {
    return AppLocalizations.of(context)!.identityPhoto;
  }
  String get _idSelfieLabel {
    return AppLocalizations.of(context)!.selfiePhoto;
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
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
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
      ),
    );
  }

  void _showIdentityTypeSheet() {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 8),
                Text(l.selectIdentityType, style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text(l.idCardKtp, style: AppTextStyles.bodyMedium),
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
                        leading: const Icon(Icons.card_travel),
                        title: Text(l.passport, style: AppTextStyles.bodyMedium),
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
                        leading: const Icon(Icons.drive_eta),
                        title: Text(l.idCardSim, style: AppTextStyles.bodyMedium),
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
                        leading: const Icon(Icons.receipt_long),
                        title: Text(l.idCardNpwp, style: AppTextStyles.bodyMedium),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentityTypePicker() {
    final l = AppLocalizations.of(context)!;
    final (icon, label) = switch (_identityType) {
      'ktp' => (Icons.credit_card, l.idCardKtp),
      'passport' => (Icons.card_travel, l.passport),
      'sim' => (Icons.drive_eta, l.idCardSim),
      'npwp' => (Icons.receipt_long, l.idCardNpwp),
      _ => (Icons.credit_card, l.selectIdentityType),
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

  Future<void> _onRegister() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      _showWarning(l.warningMustAgree);
      return;
    }
    if (!_rememberMe) {
      _showWarning(l.warningCheckRemember);
      return;
    }
    if (_ktpFile != null) {
      if (!_namesLocked && _ocrExtractedName.isEmpty) {
        _showWarning('${l.nameVerificationFailed} $_idPhotoLabel');
        return;
      }
      if (_ocrExtractedName.isNotEmpty) {
        final enteredName = _fullName.toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
        final ocrName = _ocrExtractedName.toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
        if (!enteredName.contains(ocrName) && !ocrName.contains(enteredName)) {
          _showWarning('${l.nameNotMatch} $_idPhotoLabel');
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

  void _showWarning(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.warningColor),
    );
  }

  Widget _buildPhoneField() {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: _whatsappController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: Validators.phone,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          labelText: l.whatsappNumber,
          labelStyle: AppTextStyles.titleSmall,
          prefix: GestureDetector(
            onTap: _showCountryCodePicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(flagFromDialCode(_countryCode) ?? '', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 4),
                  Text(_countryCode, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  Icon(Icons.arrow_drop_down, size: 20, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCountryCodePicker() {
    final l = AppLocalizations.of(context)!;
    final searchController = TextEditingController();
    List<CountryCode> codes = List.of(countryCodes);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 8),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: l.searchCountry,
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
              ),
            );
          },
        );
      },
    );
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
    final l = AppLocalizations.of(context)!;
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, state) {
      if (state is AuthAuthenticated) {
        final messenger = ScaffoldMessenger.of(context);
        final router = GoRouter.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(content: Text(l.registerSuccess), backgroundColor: AppColors.successColor),
        );
        router.go('/home');
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: AppColors.errorColor),
        );
      }
    });

    final isLoading = authState is AuthLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.sm),
            Center(child: Text(l.createAccount, style: AppTextStyles.headlineMedium)),
            const SizedBox(height: AppSizes.xs),
            Center(child: Text(l.fillDataCorrectly, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary))),

            const SizedBox(height: AppSizes.lg),
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
            const SizedBox(height: AppSizes.lg),
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
                color: AppColors.secondaryColor.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.badge_outlined, size: 18, color: AppColors.textSecondary),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      _fullName.isNotEmpty ? _fullName : l.yourNameAppearsHere,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _fullName.isNotEmpty ? AppColors.textPrimary : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: l.username,
              controller: _usernameController,
              validator: Validators.required,
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: l.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(height: AppSizes.lg),
            Text(l.selectIdentityType, style: AppTextStyles.titleSmall),
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
                          Text(_idPhotoLabel, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
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
                          Text(_idSelfieLabel, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
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
                final path = await GoRouter.of(context).push<String>('/face-scanner');
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
            SizedBox(height: AppSizes.md),
            AppTextField(
              label: _idLabel,
              controller: _nikController,
              keyboardType: _identityType == 'ktp' ? TextInputType.number : TextInputType.text,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.idNumberRequired;
                if (_identityType == 'ktp' && v.trim().length != 16) return l.nikMustBe16Digits;
                if (_identityType == 'sim' && v.trim().length < 6) return l.simMin6Chars;
                if (_identityType == 'npwp' && v.trim().length < 15) return l.npwpMin15Chars;
                if (!['ktp', 'sim', 'npwp'].contains(_identityType) && v.trim().length < 6) return l.passportMin6Chars;
                return null;
              },
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(height: AppSizes.sm),
            AppTextField(
              label: l.placeOfBirthLabel,
              controller: _birthPlaceController,
            ),
            SizedBox(height: AppSizes.md),
            AppDatePickerField(
              label: l.dateOfBirthLabel,
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
            _buildPhoneField(),
            const SizedBox(height: AppSizes.md),
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
            Text(l.religionLabel, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
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
            SizedBox(height: AppSizes.md),
            Text(l.maritalStatusLabel, style: AppTextStyles.titleSmall),
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
              label: l.motherNameLabel,
              controller: _motherNameController,
            ),
            SizedBox(height: AppSizes.md),
            Text(l.occupationLabel, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
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
            SizedBox(height: AppSizes.md),
            Text(l.incomeRangeLabel, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
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
            SizedBox(height: AppSizes.md),
            Text(l.sourceOfFundsLabel, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
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
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: l.confirmPasswordLabel,
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              validator: (v) => Validators.confirmPassword(v, _passwordController.text),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            _rememberCheckbox(),
            const SizedBox(height: AppSizes.sm),
            _agreementCheckbox(),
            const SizedBox(height: AppSizes.lg),
            AppButton(
              label: l.signUpNow,
              loading: isLoading,
              disabled: !_agreeTerms || !_rememberMe,
              onPressed: _onRegister,
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l.alreadyHaveAccount, style: AppTextStyles.bodyMedium),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    showSignInSheet(context);
                  },
                  child: Text(l.signIn, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _agreementCheckbox() {
    final l = AppLocalizations.of(context)!;
    return Row(
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
        const SizedBox(width: 8),
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
                  TextSpan(text: l.agreeJoinText),
                  TextSpan(
                    text: l.userAgreement,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => showAgreementModal(context, mode: AgreementMode.terms),
                  ),
                  TextSpan(text: l.agreeComma),
                  TextSpan(
                    text: l.privacyPolicy,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => showAgreementModal(context, mode: AgreementMode.privacy),
                  ),
                  TextSpan(text: l.agreeAnd),
                  TextSpan(
                    text: l.appPolicy,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => showAgreementModal(context, mode: AgreementMode.weddingPolicy),
                  ),
                  TextSpan(text: l.agreeSuffix),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rememberCheckbox() {
    final l = AppLocalizations.of(context)!;
    return Row(
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
        const SizedBox(width: 8),
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
    );
  }
}

class _OtpVerificationSheetContent extends StatefulWidget {
  final String? email;
  final String purpose;
  const _OtpVerificationSheetContent({this.email, this.purpose = 'forgot_password'});

  @override
  State<_OtpVerificationSheetContent> createState() => _OtpVerificationSheetContentState();
}

class _OtpVerificationSheetContentState extends State<_OtpVerificationSheetContent> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());
  int _resendSeconds = 0;
  Timer? _resendTimer;
  bool _verifying = false;
  bool _sending = false;
  bool _showPaste = false;

  @override
  void initState() {
    super.initState();
    _autoSendOtp();
    _checkClipboard();
  }

  Future<void> _autoSendOtp() async {
    if (widget.email == null || widget.email!.isEmpty) return;
    setState(() => _sending = true);
    try {
      await DioClient.instance.post(
        ApiEndpoints.sendOtp,
        data: {'email': widget.email, 'purpose': widget.purpose},
      );
      if (mounted) _startResendTimer();
    } on DioException {
      // caller may have sent OTP already; auto-resend handles retry
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _checkClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) return;
    final digits = data!.text!.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 6 && mounted) {
      setState(() => _showPaste = true);
    }
  }

  Future<void> _pasteOtp() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) return;
    final digits = data!.text!.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < 6 && i < digits.length; i++) {
      _otpControllers[i].text = digits[i];
    }
    _otpFocusNodes[5].requestFocus();
    if (mounted) setState(() => _showPaste = false);
  }

  void _clearAll() {
    for (final c in _otpControllers) { c.clear(); }
    _otpFocusNodes[0].requestFocus();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in _otpControllers) { c.dispose(); }
    for (final f in _otpFocusNodes) { f.dispose(); }
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _startResendTimer() async {
    _resendSeconds = 120;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 0) {
        timer.cancel();
        _onResend();
        return;
      }
      setState(() => _resendSeconds--);
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < 6 && i < digits.length; i++) {
        _otpControllers[i].text = digits[i];
      }
      final nextIndex = digits.length < 6 ? digits.length : 5;
      _otpFocusNodes[nextIndex].requestFocus();
      return;
    }
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index == 0) {
      _clearAll();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    if (mounted) setState(() {});
  }

  Future<void> _onVerify() async {
    final l = AppLocalizations.of(context)!;
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.enter6DigitOtp), backgroundColor: AppColors.errorColor),
      );
      return;
    }
    setState(() => _verifying = true);
    try {
      await DioClient.instance.post(
        ApiEndpoints.verifyOtp,
        data: {'email': widget.email, 'otp': otp, 'purpose': widget.purpose},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.verificationCodeSent), backgroundColor: AppColors.successColor),
      );
      Navigator.of(context).pop();
      if (widget.purpose == 'forgot_password') {
        showResetPasswordSheet(context);
      } else if (widget.purpose == 'google_register') {
        context.go('/complete-profile');
      } else if (widget.purpose == 'verify_email') {
        context.go('/home');
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? l.failedVerifyOtp;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: AppColors.errorColor),
        );
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _onResend() async {
    final l = AppLocalizations.of(context)!;
    if (_resendSeconds > 0 || _sending) return;
    setState(() => _sending = true);
    try {
      await DioClient.instance.post(
        ApiEndpoints.sendOtp,
        data: {'email': widget.email, 'purpose': widget.purpose},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.verificationCodeSent), backgroundColor: AppColors.successColor),
        );
        _startResendTimer();
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? l.failedSendVerificationCode;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: AppColors.errorColor),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final boxFg = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final boxBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);
    final boxBorder = isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
    final boxFocusedBorder = AppColors.primaryColor;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(l.verify, style: AppTextStyles.headlineMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            widget.email != null
                ? '${l.enterOtpSentTo} ${widget.email!}'
                : '${l.enterOtpSentTo} ${l.email}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) {
              return Padding(
                padding: EdgeInsets.only(left: i > 0 ? 8 : 0),
                child: SizedBox(
                    width: 44,
                    height: 54,
                    child: TextFormField(
                      controller: _otpControllers[i],
                      focusNode: _otpFocusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: boxFg,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: boxBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: boxBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: boxBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: boxFocusedBorder, width: 1.8),
                        ),
                      ),
                      onChanged: (v) => _onOtpChanged(i, v),
                    ),
                  ),
                );
              }),
            ),
          const SizedBox(height: 16),
          if (_showPaste)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: _pasteOtp,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.content_paste_rounded, size: 16, color: AppColors.primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        l.pasteOtp,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: AppButton(
              label: l.verify,
              loading: _verifying,
              onPressed: _onVerify,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _sending
                  ? l.sending
                  : _resendSeconds > 0
                      ? '${l.resendOtp} · ${_resendSeconds}s'
                      : l.sending,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    );
  }
}

class _ResetPasswordSheetContent extends StatefulWidget {
  const _ResetPasswordSheetContent();

  @override
  State<_ResetPasswordSheetContent> createState() => _ResetPasswordSheetContentState();
}

class _ResetPasswordSheetContentState extends State<_ResetPasswordSheetContent> {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.passwordResetSuccess), backgroundColor: AppColors.successColor),
      );
      Navigator.of(context).pop();
      showSignInSheet(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.passwordResetFailed), backgroundColor: AppColors.errorColor),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg + MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(l.resetPassword, style: AppTextStyles.headlineMedium),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              l.createNewPassword,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.xl),
            AppTextField(
              label: l.newPassword,
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: Validators.password,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: l.confirmNewPassword,
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              validator: (v) => Validators.confirmPassword(v, _passwordController.text),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            AppButton(
              label: l.resetPassword,
              loading: _loading,
              onPressed: _onResetPassword,
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordSheetContent extends StatefulWidget {
  const _ForgotPasswordSheetContent();

  @override
  State<_ForgotPasswordSheetContent> createState() => _ForgotPasswordSheetContentState();
}

class _ForgotPasswordSheetContentState extends State<_ForgotPasswordSheetContent> {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.resetCodeSentToEmail), backgroundColor: AppColors.successColor),
      );
      Navigator.of(context).pop();
      showOtpVerificationSheet(context, email: _emailController.text.trim());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.failedSendResetCode), backgroundColor: AppColors.errorColor),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg + MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(l.forgotPassword, style: AppTextStyles.headlineMedium),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              l.enterEmailForResetPassword,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.xl),
            AppTextField(
              label: l.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: AppSizes.xl),
            AppButton(
              label: l.sendResetCode,
              loading: _loading,
              onPressed: _onSendResetCode,
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}
