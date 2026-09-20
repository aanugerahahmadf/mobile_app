import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../../core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import '../../../../../auth/presentation/providers/auth_provider/auth_provider.dart';

class PasswordAndSecurityPage extends ConsumerWidget {
  const PasswordAndSecurityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final isAuthenticated = ref.watch(authProvider) is AuthAuthenticated;

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(l.passwordAndSecurity),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const GuestAuthPrompt(icon: Icons.security_outlined),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l.passwordAndSecurity),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: AppSizes.sm),

          // HEADER 1: SIGN IN DAN PEMULIHAN
          _sectionHeader(context, l.loginAndRecovery.toUpperCase()),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _menuTile(
                  context,
                  icon: Icons.lock_outline,
                  title: l.changePassword,
                  subtitle: l.changePasswordDesc,
                  onTap: () => context.push('/change-password'),
                ),
                const Divider(height: 1, indent: 56),
                _menuTile(
                  context,
                  icon: Icons.security_outlined,
                  title: l.twoFactorAuth,
                  subtitle: l.twoFactorAuthDesc,
                  onTap: () => context.push('/two-factor-settings'),
                ),
                const Divider(height: 1, indent: 56),
                _menuTile(
                  context,
                  icon: Icons.bookmark_outline,
                  title: l.savedLoginInfo,
                  subtitle: l.savedLoginInfoDescShort,
                  onTap: () => context.push('/saved-login-info'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // HEADER 2: PEMERIKSAAN KEAMANAN
          _sectionHeader(context, l.securityCheck.toUpperCase()),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _menuTile(
                  context,
                  icon: Icons.location_on_outlined,
                  title: l.whereYouLoggedIn,
                  subtitle: l.whereYouLoggedInDesc,
                  onTap: () => context.push('/login-activity'),
                ),
                const Divider(height: 1, indent: 56),
                _menuTile(
                  context,
                  icon: Icons.email_outlined,
                  title: l.recentEmails,
                  subtitle: l.recentEmailsDesc,
                  onTap: () => context.push('/recent-emails'),
                ),
                const Divider(height: 1, indent: 56),
                _menuTile(
                  context,
                  icon: Icons.shield_outlined,
                  title: l.securityCheckup,
                  subtitle: l.securityCheckupDesc,
                  onTap: () => context.push('/security-checkup'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xxl),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        0,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyles.bodySmall)
          : null,
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
