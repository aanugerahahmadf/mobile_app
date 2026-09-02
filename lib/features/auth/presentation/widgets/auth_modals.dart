import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/reference/dropdown_option.dart';
import '../../../../core/reference/dropdown_options_provider.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/image_scan_analyzer.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/media_viewer.dart';
import '../../../../core/utils/ktp_utils.dart';
import '../../../../core/utils/identity_document_utils.dart';
import '../../../../core/utils/camera_scan_utils.dart';
import '../../../../core/utils/profile_media_picker.dart';
import '../../../../core/utils/country_codes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_notification.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_country_picker_field.dart';
import '../../../../core/widgets/app_region_picker_field.dart';
import '../../../../core/widgets/whatsapp_otp_verifier.dart';
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
    isDismissible: false,
    enableDrag: false,
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
      color: AppColors.surfaceColor,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
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
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isWedding
                  ? _LegalContentView(
                      provider: weddingDecorationPolicyProvider,
                      isWizard: false,
                      onNext: null,
                      onAgreed: null,
                    )
                  : (_step == 1
                      ? _LegalContentView(
                          provider: termsOfServiceProvider,
                          isWizard: isWizard,
                          onNext: isWizard ? () => setState(() => _step = 2) : null,
                        )
                      : (_step == 2
                          ? _LegalContentView(
                              provider: privacyPolicyProvider,
                              isWizard: isWizard,
                              onNext: isWizard ? () => setState(() => _step = 3) : null,
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

  const _LegalContentView({
    required this.provider,
    this.isWizard = false,
    this.onNext,
    this.onAgreed,
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
                            Text(body ?? '', textAlign: TextAlign.justify, style: GoogleFonts.inter(fontSize: 14, height: 1.6)),
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
          if (onNext != null || onAgreed != null)
            Container(
              padding: EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.sm,
                AppSizes.md,
                AppSizes.md + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
              ),
              child: onNext != null
                  ? AppButton(
                      label: l.proceed,
                      onPressed: onNext,
                      type: ButtonType.primary,
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    )
                  : AppButton(
                      label: l.iUnderstandAndAgree,
                      onPressed: onAgreed,
                      type: ButtonType.primary,
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _AuthSheetSwitcher(initialType: _AuthSheetType.signIn)),
  );
}

Future<void> showSignUpSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _AuthSheetSwitcher(initialType: _AuthSheetType.signUp)),
  );
}

class _AuthSheetSwitcher extends StatefulWidget {
  final _AuthSheetType initialType;
  const _AuthSheetSwitcher({required this.initialType});

  @override
  State<_AuthSheetSwitcher> createState() => _AuthSheetSwitcherState();
}

class _AuthSheetSwitcherState extends State<_AuthSheetSwitcher> {
  late _AuthSheetType _type;
  bool _hasSwitched = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  void _switchToSignUp() => setState(() { _type = _AuthSheetType.signUp; _hasSwitched = true; });
  void _switchToSignIn() => setState(() { _type = _AuthSheetType.signIn; _hasSwitched = true; });

  @override
  Widget build(BuildContext context) {
    final openedDirectlyAsSignUp = widget.initialType == _AuthSheetType.signUp && !_hasSwitched;

    return PopScope(
      canPop: openedDirectlyAsSignUp || _type == _AuthSheetType.signIn,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _switchToSignIn();
      },
      child: _type == _AuthSheetType.signIn
          ? _SignInSheetContent(onSwitchToSignUp: _switchToSignUp)
          : _SignUpSheetContent(
              onSwitchToSignIn: _switchToSignIn,
              onBack: openedDirectlyAsSignUp
                  ? () => Navigator.of(context).pop()
                  : _switchToSignIn,
            ),
    );
  }
}

Future<void> showForgotPasswordSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _ForgotPasswordSheetContent()),
  );
}

Future<void> showOtpVerificationSheet(
  BuildContext context, {
  String? email,
  String purpose = 'forgot_password',
  Future<void> Function()? onVerified,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => _AuthSheetWrapper(
      child: _OtpVerificationSheetContent(email: email, purpose: purpose, onVerified: onVerified),
    ),
  );
}

Future<void> showResetPasswordSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AuthSheetWrapper(child: _ResetPasswordSheetContent()),
  );
}

class _AuthSheetWrapper extends StatelessWidget {
  final Widget child;
  const _AuthSheetWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          color: AppColors.surfaceColor,
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
        ),
      ),
    );
  }
}

enum _AuthSheetType { signIn, signUp }

class _SignInSheetContent extends ConsumerStatefulWidget {
  final VoidCallback? onSwitchToSignUp;
  const _SignInSheetContent({this.onSwitchToSignUp});

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _loginLabel {
    final l = AppLocalizations.of(context)!;

    return l.emailOrUsername;
  }

  TextInputType get _loginKeyboardType => TextInputType.text;

  String? _loginValidator(String? value) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) return '$_loginLabel ${l.fieldRequired}';
    return null;
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
    AppNotification.show(context, msg, type: NotificationType.warning);
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
          final navigator = Navigator.of(context);
          final router = GoRouter.of(context);
          navigator.pop();
          AppNotification.show(navigator.context, l.completeYourProfile, type: NotificationType.info);
          router.push('/complete-profile');
        } else {
          final navigator = Navigator.of(context);
          final router = GoRouter.of(context);
          navigator.pop();
          AppNotification.show(navigator.context, l.loginSuccess, type: NotificationType.success);
          router.go('/home');
        }
      } else if (state is AuthError) {
        AppNotification.show(context, LocalizedError.of(l, state.message), type: NotificationType.error);
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
            AuthHeader(title: l.signIn, subtitle: l.signInSubtitle),
            const SizedBox(height: AppSizes.lg),
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
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: widget.onSwitchToSignUp,
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
  final VoidCallback? onSwitchToSignIn;
  final VoidCallback? onBack;
  const _SignUpSheetContent({this.onSwitchToSignIn, this.onBack});

  @override
  ConsumerState<_SignUpSheetContent> createState() => _SignUpSheetContentState();
}

class _SignUpSheetContentState extends ConsumerState<_SignUpSheetContent> {
  Map<String, List<DropdownOption>> _dropdownOptions = {};
  bool _optionsLoaded = false;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _ktpNumberController = TextEditingController();
  final _birthPlaceController = TextEditingController();
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
  bool _whatsappVerified = false;
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
  OverlayEntry? _dropdownOverlay;

  String get _idLabel {
    final l = AppLocalizations.of(context)!;
    switch (_identityType) {
      case 'ktp': return l.ktpNumberLabel;
      case 'passport': return l.passportLabel;
      case 'sim': return l.simLabel;
      case 'npwp': return l.npwpLabel;
      default: return l.idNumber;
    }
  }
  String get _idPhotoLabel {
    final l = AppLocalizations.of(context)!;
    switch (_identityType) {
      case 'ktp': return l.ktpPhoto;
      case 'passport': return l.passportPhoto;
      case 'sim': return l.simPhoto;
      case 'npwp': return l.npwpPhoto;
      default: return l.identityPhoto;
    }
  }
  String get _idSelfieLabel {
    final l = AppLocalizations.of(context)!;
    switch (_identityType) {
      case 'ktp': return l.selfieKtp;
      case 'passport': return l.selfiePassport;
      case 'sim': return l.selfieSim;
      case 'npwp': return l.selfieNpwp;
      default: return l.selfiePhoto;
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
    _ktpNumberController.dispose();
    _birthPlaceController.dispose();

    _countryController.dispose();
    _addressController.dispose();
    _motherNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _removeDropdown();
    super.dispose();
  }

  void _showDropdown(BuildContext fieldContext, String title, List<String> options, String currentValue, Function(String) onSelected) {
    _removeDropdown();
    final overlay = Overlay.of(fieldContext);
    final renderBox = fieldContext.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final searchController = TextEditingController();

    _dropdownOverlay = OverlayEntry(
      builder: (ctx) {
        List<String> filtered = List.of(options);
        return StatefulBuilder(
          builder: (_, setDropdownState) {
            return GestureDetector(
              onTap: () {},
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _removeDropdown,
                    child: Container(color: Colors.transparent),
                  ),
                  Positioned(
                    top: position.dy + size.height + 4,
                    left: position.dx,
                    width: size.width,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.surfaceColor,
                      surfaceTintColor: AppColors.surfaceColor,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 280),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: title,
                                  prefixIcon: const Icon(Icons.search, size: 20),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                onChanged: (v) {
                                  setDropdownState(() {
                                    filtered = options.where((o) =>
                                      o.toLowerCase().contains(v.toLowerCase())).toList();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 4),
                            Flexible(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                children: filtered.map((option) => ListTile(
                                  dense: true,
                                  title: Text(option, style: AppTextStyles.bodyMedium),
                                  trailing: option == currentValue
                                      ? Icon(Icons.check, color: AppColors.primaryColor, size: 20)
                                      : null,
                                  onTap: () {
                                    onSelected(option);
                                    _removeDropdown();
                                  },
                                )).toList(),
                              ),
                            ),
                          ],
                        ),
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
    overlay.insert(_dropdownOverlay!);
  }

  void _removeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  List<String> _optLabels(String type, List<String> fallback) {
    return _dropdownOptions[type]?.map((o) => o.label).toList() ?? fallback;
  }

  Widget _buildIdentityTypePicker() {
    final l = AppLocalizations.of(context)!;
    final options = [l.idCardKtp, l.passport, l.idCardSim, l.idCardNpwp];
    final currentLabel = switch (_identityType) {
      'ktp' => l.idCardKtp,
      'passport' => l.passport,
      'sim' => l.idCardSim,
      'npwp' => l.idCardNpwp,
      _ => l.selectIdentityType,
    };
    final icon = switch (_identityType) {
      'ktp' => Icons.credit_card,
      'passport' => Icons.card_travel,
      'sim' => Icons.drive_eta,
      'npwp' => Icons.receipt_long,
      _ => Icons.credit_card,
    };
    return Builder(
      builder: (fieldCtx) => GestureDetector(
        onTap: () => _showDropdown(fieldCtx, l.selectIdentityType, options, currentLabel, (v) {
          setState(() {
            if (v == l.passport) {
              _identityType = 'passport';
            } else if (v == l.idCardSim) {
              _identityType = 'sim';
            } else if (v == l.idCardNpwp) {
              _identityType = 'npwp';
            } else {
              _identityType = 'ktp';
            }
            _ktpFile = null;
            _ktpNumberController.clear();
            _namesLocked = false;
            _ocrExtractedName = '';
          });
        }),
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
                  currentLabel,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage({required bool isKtp}) async {
    if (isKtp) {
      // Langsung buka kamera dengan panduan bingkai kartu (persegi panjang)
      // untuk dokumen identitas KTP/SIM/NPWP/Paspor.
      final l = AppLocalizations.of(context)!;
      final file = await scanWithCamera(
        context,
        type: scanContentTypeForIdentity(_identityType),
      );
      if (file == null) return;
      setState(() => _ktpFile = file);
      if (isVideoPath(file.path)) return;
      final ktpData = await extractIdentityData(file, _identityType);
      setState(() {
        _ocrExtractedName = ktpData.name;
        if (ktpData.number.isNotEmpty) _ktpNumberController.text = ktpData.number;
      });
      if (ktpData.name.isNotEmpty) {
        final parts = splitKtpName(ktpData.name);
        setState(() {
          _firstNameController.text = parts[0];
          _middleNameController.text = parts[1];
          _lastNameController.text = parts[2];
          _namesLocked = true;
        });
      }
      setState(() {
        if (ktpData.birthPlaceCombo.isNotEmpty && _birthPlaceController.text.trim().isEmpty) {
          _birthPlaceController.text = ktpData.birthPlaceCombo;
        }
        if (_gender.isEmpty) {
          _gender = matchOcrToDropdownLabel('gender', ktpData.gender, _optLabels('gender', [l.male, l.female]));
        }
        if (_religion.isEmpty) {
          _religion = matchOcrToDropdownLabel('religion', ktpData.religion, _optLabels('religion', [l.islam, l.christian, l.catholic, l.hindu, l.buddha, l.confucian]));
        }
        if (_maritalStatus.isEmpty) {
          _maritalStatus = matchOcrToDropdownLabel('marital_status', ktpData.maritalStatus, _optLabels('marital_status', [l.single, l.married, l.divorced]));
        }
        if (_occupation.isEmpty) {
          _occupation = matchOcrToDropdownLabel('occupation', ktpData.occupation, _optLabels('occupation', [l.employee, l.entrepreneur, l.student, l.housewife, l.professional, l.other]));
        }
        if (ktpData.address.isNotEmpty && _addressController.text.trim().isEmpty) {
          _addressController.text = ktpData.address;
        }
      });
      return;
    }
    final file = await pickProfileMedia(context);
    if (file != null) {
      setState(() => _avatarFile = file);
    }
  }

  Future<void> _pickSelfie() async {
    // Langsung buka kamera depan dengan panduan oval wajah + bingkai kartu
    // identitas (KTP/SIM/NPWP/Paspor) yang dipegang bersama wajah.
    final l = AppLocalizations.of(context)!;
    final file = await scanSelfieWithDocument(context, docType: _identityType);
    if (file == null) return;
    setState(() => _selfieKtpFile = file);
    if (isVideoPath(file.path)) return;
    final ktpData = await extractIdentityData(file, _identityType);
    setState(() {
      if (ktpData.number.isNotEmpty && _ktpNumberController.text.trim().isEmpty) {
        _ktpNumberController.text = ktpData.number;
      }
      if (ktpData.name.isNotEmpty) {
        _ocrExtractedName = ktpData.name;
        final parts = splitKtpName(ktpData.name);
        _firstNameController.text = parts[0];
        _middleNameController.text = parts[1];
        _lastNameController.text = parts[2];
        _namesLocked = true;
      }
      if (ktpData.birthPlaceCombo.isNotEmpty && _birthPlaceController.text.trim().isEmpty) {
        _birthPlaceController.text = ktpData.birthPlaceCombo;
      }
      if (_gender.isEmpty) {
        _gender = matchOcrToDropdownLabel('gender', ktpData.gender, _optLabels('gender', [l.male, l.female]));
      }
      if (_religion.isEmpty) {
        _religion = matchOcrToDropdownLabel('religion', ktpData.religion, _optLabels('religion', [l.islam, l.christian, l.catholic, l.hindu, l.buddha, l.confucian]));
      }
      if (_maritalStatus.isEmpty) {
        _maritalStatus = matchOcrToDropdownLabel('marital_status', ktpData.maritalStatus, _optLabels('marital_status', [l.single, l.married, l.divorced]));
      }
      if (_occupation.isEmpty) {
        _occupation = matchOcrToDropdownLabel('occupation', ktpData.occupation, _optLabels('occupation', [l.employee, l.entrepreneur, l.student, l.housewife, l.professional, l.other]));
      }
      if (ktpData.address.isNotEmpty && _addressController.text.trim().isEmpty) {
        _addressController.text = ktpData.address;
      }
    });
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
    if (_whatsappController.text.trim().isNotEmpty && !_whatsappVerified) {
      _showWarning(l.whatsappVerifyRequired);
      return;
    }
    if (_ktpFile != null && !isVideoPath(_ktpFile!.path)) {
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
      ktpNumber: _identityType == 'ktp' ? _ktpNumberController.text.trim() : '',
      passportNumber: _identityType == 'passport' ? _ktpNumberController.text.trim() : null,
      simNumber: _identityType == 'sim' ? _ktpNumberController.text.trim() : null,
      npwpNumber: _identityType == 'npwp' ? _ktpNumberController.text.trim() : null,
      identityType: _identityType,
      birthPlace: _birthPlaceController.text.trim(),
      birthDate: '',
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
    AppNotification.show(context, msg, type: NotificationType.warning);
  }

  Widget _buildPhoneField() {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Builder(
        builder: (fieldCtx) => TextFormField(
          controller: _whatsappController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: Validators.phone,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            labelText: l.whatsappNumber,
            labelStyle: AppTextStyles.titleSmall,
            prefix: GestureDetector(
              onTap: () => _showDropdown(
                fieldCtx,
                l.selectCountryCode,
                _countryCodeOptions(),
                _countryCodeLabel(),
                (v) {
                  final code = _dialCodeFromOption(v);
                  if (code != null) setState(() => _countryCode = code);
                },
              ),
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
      ),
    );
  }

  List<String> _countryCodeOptions() =>
      countryCodes.map((c) => '${c.flag} ${c.name} (${c.dialCode})').toList();

  String _countryCodeLabel() {
    for (final c in countryCodes) {
      if (c.dialCode == _countryCode) {
        return '${c.flag} ${c.name} (${c.dialCode})';
      }
    }
    return _countryCode;
  }

  String? _dialCodeFromOption(String option) {
    for (final c in countryCodes) {
      if ('${c.flag} ${c.name} (${c.dialCode})' == option) return c.dialCode;
    }
    return null;
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

    if (!_optionsLoaded) {
      ref.read(dropdownOptionsProvider.future).then((opts) {
        if (mounted) setState(() { _dropdownOptions = opts; _optionsLoaded = true; });
      });
    }

    ref.listen<AuthState>(authProvider, (_, state) {
      if (state is AuthAuthenticated) {
        final navigator = Navigator.of(context);
        final router = GoRouter.of(context);
        navigator.pop();
        AppNotification.show(navigator.context, l.registerSuccess, type: NotificationType.success);
        router.go('/home');
      } else if (state is AuthError) {
        AppNotification.show(context, LocalizedError.of(l, state.message), type: NotificationType.error);
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
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    onPressed: widget.onBack ?? widget.onSwitchToSignIn,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                Expanded(
                  child: Text(l.createAccount, style: AppTextStyles.headlineMedium, textAlign: TextAlign.center),
                ),
                const SizedBox(width: 40),
              ],
            ),
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
                      backgroundImage: (!(_avatarFile != null && isVideoPath(_avatarFile!.path)) && _avatarFile != null)
                          ? FileImage(_avatarFile!) as ImageProvider?
                          : null,
                      child: (_avatarFile != null && isVideoPath(_avatarFile!.path))
                          ? Icon(Icons.videocam, size: 28, color: AppColors.primaryColor)
                          : _avatarFile == null
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
              onTap: () => _pickSelfie(),
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
            const SizedBox(height: AppSizes.md),
            AppTextField(
              label: _idLabel,
              controller: _ktpNumberController,
              keyboardType: _identityType == 'ktp' ? TextInputType.number : TextInputType.text,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.idNumberRequired;
                if (_identityType == 'ktp' && v.trim().length != 16) return l.ktpNumberMustBe16Digits;
                if (_identityType == 'sim' && v.trim().length < 6) return l.simMin6Chars;
                if (_identityType == 'npwp' && v.trim().length < 15) return l.npwpMin15Chars;
                if (!['ktp', 'sim', 'npwp'].contains(_identityType) && v.trim().length < 6) return l.passportMin6Chars;
                return null;
              },
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(height: AppSizes.sm),
            AppTextField(
              label: l.placeAndDateOfBirth,
              controller: _birthPlaceController,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, size: 20),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    locale: const Locale('id'),
                  );
                  if (picked != null) {
                    final formatted = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                    _birthPlaceController.text = '${_birthPlaceController.text.trim()}, $formatted';
                    _birthPlaceController.selection = TextSelection.fromPosition(TextPosition(offset: _birthPlaceController.text.length));
                  }
                },
              ),
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
            const SizedBox(height: AppSizes.md),
            _buildPhoneField(),
            WhatsappOtpVerifier(
              numberController: _whatsappController,
              countryCode: _countryCode,
              initialFullNumber: '',
              minDigits: 10,
              onVerifiedChanged: (v) {
                if (_whatsappVerified != v) {
                  setState(() => _whatsappVerified = v);
                }
              },
            ),
            const SizedBox(height: AppSizes.md),
            Text(l.gender, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
            Builder(
              builder: (fieldCtx) => GestureDetector(
                onTap: () => _showDropdown(fieldCtx, l.selectGender, _optLabels('gender', [l.male, l.female]), _gender, (v) => setState(() => _gender = v)),
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
            ),
            SizedBox(height: AppSizes.md),
            Text(l.religionLabel, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
            Builder(
              builder: (fieldCtx) => GestureDetector(
                onTap: () => _showDropdown(fieldCtx, l.selectReligion, _optLabels('religion', [l.islam, l.christian, l.catholic, l.hindu, l.buddha, l.confucian]), _religion, (v) => setState(() => _religion = v)),
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
            ),
            SizedBox(height: AppSizes.md),
            Text(l.maritalStatusLabel, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
            Builder(
              builder: (fieldCtx) => GestureDetector(
                onTap: () => _showDropdown(fieldCtx, l.selectMaritalStatus, _optLabels('marital_status', [l.single, l.married, l.divorced]), _maritalStatus, (v) => setState(() => _maritalStatus = v)),
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
            ),
            SizedBox(height: AppSizes.md),
            AppTextField(
              label: l.motherNameLabel,
              controller: _motherNameController,
            ),
            SizedBox(height: AppSizes.md),
            Text(l.occupationLabel, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
            Builder(
              builder: (fieldCtx) => GestureDetector(
                onTap: () => _showDropdown(fieldCtx, l.selectOccupation, _optLabels('occupation', [l.employee, l.entrepreneur, l.student, l.housewife, l.professional, l.other]), _occupation, (v) => setState(() => _occupation = v)),
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
            ),
            SizedBox(height: AppSizes.md),
            Text(l.incomeRangeLabel, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
            Builder(
              builder: (fieldCtx) => GestureDetector(
                onTap: () => _showDropdown(fieldCtx, l.selectIncomeRange, _optLabels('income_range', [l.lessThan1M, l.range1to5M, l.range5to10M, l.range10to50M, l.moreThan50M]), _incomeRange, (v) => setState(() => _incomeRange = v)),
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
            ),
            SizedBox(height: AppSizes.md),
            Text(l.sourceOfFundsLabel, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.sm),
            Builder(
              builder: (fieldCtx) => GestureDetector(
                onTap: () => _showDropdown(fieldCtx, l.selectSourceOfFunds, _optLabels('source_of_funds', [l.salary, l.business, l.investment, l.gift, l.other]), _sourceOfFunds, (v) => setState(() => _sourceOfFunds = v)),
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
            ),
            SizedBox(height: AppSizes.md),
            GestureDetector(
              onTap: () async {
                final file = await scanWithCamera(context, type: ScanContentType.face);
                if (file != null) setState(() => _faceScanPath = file.path);
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
            SocialLoginButton(provider: SocialProvider.google, enabled: _agreeTerms && _rememberMe, onPressed: () async {
              if (!_agreeTerms) {
                _showWarning(l.warningMustAgree);
                return;
              }
              if (!_rememberMe) {
                _showWarning(l.warningCheckRemember);
                return;
              }
              await ref.read(authProvider.notifier).googleLogin();
            }),
            const SizedBox(height: AppSizes.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l.alreadyHaveAccount, style: AppTextStyles.bodyMedium),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: widget.onSwitchToSignIn,
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
  final Future<void> Function()? onVerified;
  const _OtpVerificationSheetContent({this.email, this.purpose = 'forgot_password', this.onVerified});

  @override
  State<_OtpVerificationSheetContent> createState() => _OtpVerificationSheetContentState();
}

class _OtpVerificationSheetContentState extends State<_OtpVerificationSheetContent> {
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  int _resendSeconds = 0;
  Timer? _resendTimer;
  bool _verifying = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _autoSendOtp();
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
      // OTP may have been sent already
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
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

  Future<void> _onVerify() async {
    final l = AppLocalizations.of(context)!;
    final otp = _otpController.text.replaceAll(RegExp(r'\D'), '');
    if (otp.length < 6) {
      AppNotification.show(context, l.enter6DigitOtp, type: NotificationType.error);
      return;
    }
    setState(() => _verifying = true);
    try {
      await DioClient.instance.post(
        ApiEndpoints.verifyOtp,
        data: {'email': widget.email, 'otp': otp, 'purpose': widget.purpose},
      );
      if (!mounted) return;
      AppNotification.show(context, l.verificationCodeSent, type: NotificationType.success);
      Navigator.of(context).pop();
      final onVerified = widget.onVerified;
      if (onVerified != null) {
        await onVerified();
      } else if (widget.purpose == 'forgot_password') {
        showResetPasswordSheet(context);
      } else if (widget.purpose == 'google_register') {
        context.go('/complete-profile');
      } else if (widget.purpose == 'verify_email') {
        context.go('/home');
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? l.failedVerifyOtp;
      if (mounted) {
        AppNotification.show(context, msg, type: NotificationType.error);
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
        AppNotification.show(context, l.verificationCodeSent, type: NotificationType.success);
        _startResendTimer();
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ?? l.failedSendVerificationCode;
      if (mounted) {
        AppNotification.show(context, msg, type: NotificationType.error);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              Expanded(
                child: Text(l.verify, style: AppTextStyles.headlineMedium, textAlign: TextAlign.center),
              ),
              const SizedBox(width: 40),
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
          const SizedBox(height: 24),
          TextField(
            controller: _otpController,
            focusNode: _otpFocusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 8),
            decoration: InputDecoration(

              counterText: '',
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (v) {
              if (v.length == 6) _onVerify();
            },
          ),
          const SizedBox(height: 16),
          if (_verifying)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.primaryColor)),
                  const SizedBox(width: 8),
                  Text(l.verifying, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: _resendSeconds <= 0 && !_sending ? _onResend : null,
              child: Text(
                _sending
                    ? l.sending
                    : _resendSeconds > 0
                        ? '${l.resendOtp} · ${_resendSeconds}s'
                        : l.resendOtp,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _resendSeconds <= 0 && !_sending ? AppColors.primaryColor : AppColors.textSecondary,
                  fontWeight: _resendSeconds <= 0 && !_sending ? FontWeight.w600 : FontWeight.normal,
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
      AppNotification.show(context, l.passwordResetSuccess, type: NotificationType.success);
      Navigator.of(context).pop();
      showSignInSheet(context);
    } catch (e) {
      if (!mounted) return;
      AppNotification.show(context, l.passwordResetFailed, type: NotificationType.error);
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
      AppNotification.show(context, l.resetCodeSentToEmail, type: NotificationType.success);
      Navigator.of(context).pop();
      showOtpVerificationSheet(context, email: _emailController.text.trim());
    } catch (e) {
      if (!mounted) return;
      AppNotification.show(context, l.failedSendResetCode, type: NotificationType.error);
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
