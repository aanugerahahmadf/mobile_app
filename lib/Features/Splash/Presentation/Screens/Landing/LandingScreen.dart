import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import '../../../../Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart';
import '../../../../Auth/Data/AppLockService/AppLockService.dart';
import '../../../../Auth/Presentation/Utils/AuthNavigation.dart';
import '../../../../Auth/Presentation/Widgets/SocialSignInButton/SocialSignInButton.dart';
import '../../../../Auth/Presentation/Widgets/AuthModals/AuthModals.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Widgets/AppBlurBackdrop/AppBlurBackdrop.dart';
import 'package:flutter/gestures.dart';
import '../../../../../Core/Providers/LocaleProvider/LocaleProvider.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final current = ref.read(authProvider);
      if (current is! AuthAuthenticated) {
        ref.read(authProvider.notifier).checkAuth();
      }
    });
  }

  /// Tandai bahwa pengguna sudah melewati layar awal.
  ///
  /// Flag `onboarding_seen` dibaca `redirect` global di `AppRouter.dart`.
  /// Selama flag ini belum true, semua navigasi dipaksa balik ke '/landing'.
  /// Karena itu flag wajib di-set di MOMEN pengguna melanjutkan (login berhasil
  /// atau "continue as guest"), bukan hanya di layar onboarding â€” halaman itu
  /// tidak pernah di-route sehingga tidak pernah dieksekusi.
  Future<void> _markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
  }

  Future<void> _routeAfterAuth() async {
    // Set flag dulu: bila `loadAppLockFlags` melempar, pengguna tidak boleh
    // terjebak di '/landing' tanpa jalan keluar.
    await _markOnboardingSeen();
    // Sync from DB first so the latest app lock flags are available locally.
    // Without this, a user who just enabled app lock on another device would
    // bypass the lock screen on this device.
    final service = AppLockService();
    await syncAppLockFromDb(
      service,
      email: ref.read(currentAccountEmailProvider),
    );
    final flags = await loadAppLockFlags(
      email: ref.read(currentAccountEmailProvider),
    );
    if (!mounted) return;
    if (flags.any) {
      context.go('/app-lock');
    } else {
      context.go('/home');
    }
  }

  bool _routeScheduled = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    // Watch locale provider to ensure footer text updates when language changes
    ref.watch(localeProvider);

    final isDirectHome = authState is AuthAuthenticated &&
        !authState.needsOtp &&
        !authState.needsCompletion;
    if (!isDirectHome) {
      _routeScheduled = false;
    }
    if (isDirectHome && !_routeScheduled) {
      _routeScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _routeAfterAuth();
      });
    }

    ref.listen<AuthState>(authProvider, (previous, next) {
      // Tombol Google di halaman ini memanggil `googleLogin()` LANGSUNG,
      // tanpa modal. Semua cabang (needsOtp, needsCompletion, 2FA) ditangani
      // oleh handleAuthContinuation dari AuthNavigation â€” screen-based routing.
      //
      // Cabang "langsung Home" (AuthAuthenticated tanpa needsOtp/needsCompletion)
      // TIDAK dinavigasi di sini secara sinkron: navigasi diserahkan ke
      // postFrameCallback di build() di bawah.
      if (handleAuthContinuation(
        context: context,
        ref: ref,
        state: next,
        l: l,
      )) {
        return;
      }
    });

    return _buildLandingUI(l, authState);
  }

  Widget _buildLandingUI(AppLocalizations l, AuthState authState) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/article/article-4.png', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.primaryDark.withAlpha(128),
                  AppColors.primaryDark.withAlpha(204),
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -50,
            child: _blob(300, AppColors.primaryColor.withValues(alpha: 0.15)),
          ),
          Positioned(
            top: 100,
            left: -70,
            child: _blob(150, AppColors.secondaryColor.withValues(alpha: 0.12)),
          ),
          Positioned(
            top: 240,
            left: -40,
            child: _blob(140, AppColors.accentColor.withValues(alpha: 0.08)),
          ),
          Positioned(
            bottom: 340,
            right: -30,
            child: _blob(120, AppColors.infoColor.withValues(alpha: 0.06)),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: IconButton(
              onPressed: _openCs,
              icon: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 24,
              ),
              splashRadius: 20,
              tooltip: 'Customer Service',
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.lg,
                    vertical: AppSizes.sm,
                  ),
                  child: Text(
                    l.welcomeToShopFloralDecorations,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headTitle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildButtons(l),
                _buildFooter(l),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCs() {
    context.push('/chat-list', extra: {'isGuestMode': true});
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildButtons(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: AppBlurBackdrop(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SocialSignInButton(
              provider: SocialProvider.google,
              onPressed: () async {
                // Tandai onboarding sudah dilihat SEBELUM memulai autentikasi,
                // supaya route perantara (OTP, Complete Profile, Security
                // Question, Two-Factor Setup) tidak diblokir redirect global
                // yang memaksa balik ke '/landing' selama flag ini false.
                // _routeAfterAuth juga men-set flag ini, jadi pemanggilan di
                // sini aman (idempotent).
                await _markOnboardingSeen();
                if (!mounted) return;
                ref.read(authProvider.notifier).googleSignIn();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.footer.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
          children: [
            TextSpan(text: l.agreementPrefix),
            TextSpan(
              text: l.termsOfService,
              style: AppTextStyles.footer.copyWith(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showAgreementModal(context, mode: AgreementMode.terms);
                },
            ),
            TextSpan(text: l.agreeComma),
            TextSpan(
              text: l.privacyPolicy,
              style: AppTextStyles.footer.copyWith(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showAgreementModal(context, mode: AgreementMode.privacy);
                },
            ),
            TextSpan(text: l.agreeAnd),
            TextSpan(
              text: l.appPolicy,
              style: AppTextStyles.footer.copyWith(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showAgreementModal(context, mode: AgreementMode.weddingPolicy);
                },
            ),
            TextSpan(text: l.agreementSuffix),
          ],
        ),
      ),
    );
  }
}

