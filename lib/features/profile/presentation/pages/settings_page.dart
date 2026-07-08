import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../auth/data/biometric_auth_service.dart';
import '../../../auth/presentation/providers/biometric_settings_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _toggleFingerprint(bool enable, AppLocalizations l) async {
    if (!enable) {
      ref.read(fingerprintUnlockProvider.notifier).setEnabled(false);
      return;
    }
    final service = BiometricAuthService();
    final typeName = await service.biometricTypeName;
    final reason = l.unlockWith.replaceFirst('%s', typeName);
    final success = await service.authenticate(reason: reason);
    if (success && mounted) {
      ref.read(fingerprintUnlockProvider.notifier).setEnabled(true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.failed)),
      );
    }
  }

  Future<void> _checkBiometric() async {
    final available = await BiometricAuthService().isAvailable();
    if (mounted) setState(() => _biometricAvailable = available);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fingerprintEnabled = ref.watch(fingerprintUnlockProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            _menuTile(Icons.language, l.language, () => context.push('/language')),
            _menuTile(Icons.notifications_outlined, l.notifications, () => context.push('/notification-settings')),
            const SizedBox(height: AppSizes.sm),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile(
                secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: AppColors.primaryColor),
                title: Text(l.darkMode, style: AppTextStyles.bodyMedium),
                subtitle: Text(isDark ? l.useLightTheme : l.useDarkTheme, style: AppTextStyles.bodySmall),
                value: isDark,
                onChanged: (v) => ref.read(themeProvider.notifier).toggleDarkMode(v),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
              if (_biometricAvailable) ...[
              const SizedBox(height: AppSizes.sm),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  secondary: Icon(Icons.fingerprint, color: AppColors.primaryColor),
                  title: Text(l.biometricLock, style: AppTextStyles.bodyMedium),
                  subtitle: Text(l.useFingerprint, style: AppTextStyles.bodySmall),
                  value: fingerprintEnabled,
                  onChanged: (v) => _toggleFingerprint(v, l),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _menuTile(IconData icon, String label, VoidCallback onTap, {String? subtitle}) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor),
        title: Text(label, style: AppTextStyles.bodyMedium),
        subtitle: subtitle != null ? Text(subtitle, style: AppTextStyles.bodySmall) : null,
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
