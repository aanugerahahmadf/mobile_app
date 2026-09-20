import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/utils/guest_mode/guest_mode.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../auth/presentation/providers/biometric_settings_provider/biometric_settings_provider.dart';
import '../../../../auth/presentation/widgets/auth_modals/auth_modals.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authProvider.notifier).checkAuth();
    });
  }

  Future<void> _routeAfterAuth() async {
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    if (authState is AuthAuthenticated) {
      if (!authState.needsOtp && !authState.needsCompletion) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _routeAfterAuth();
        });
      }
    }

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        if (next.needsOtp || next.needsCompletion) return;
        _routeAfterAuth();
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
            bottom: MediaQuery.of(context).padding.bottom + AppSizes.xl,
            child: _buildButtons(l),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Column(
        children: [
          AppButton(
                label: l.getStarted,
                type: ButtonType.primaryGradient,
                icon: Icons.arrow_forward_rounded,
                height: 52,
                onPressed: () => showSignInSheet(context),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(begin: 0.2, duration: 500.ms),
          const SizedBox(height: AppSizes.sm),
          AppButton(
                label: l.continueAsGuest,
                type: ButtonType.outline,
                height: 52,
                onPressed: _continueAsGuest,
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 300.ms)
              .slideY(begin: 0.2, duration: 500.ms),
        ],
      ),
    );
  }

  Future<void> _continueAsGuest() async {
    await ref.read(guestModeProvider.notifier).setEnabled(true);
    if (mounted) context.go('/home');
  }
}
