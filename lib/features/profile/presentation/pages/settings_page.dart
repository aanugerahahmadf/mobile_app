import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/errors/app_error_codes.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../auth/data/biometric_auth_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/biometric_settings_provider.dart';
import '../../../auth/presentation/widgets/pin_setup_sheet.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Future<void> _enableBiometric(BiometricType type, AppLocalizations l) async {
    if (type == BiometricType.fingerprint) {
      // Sidik jari = biometrik PERANGKAT (local_auth).
      final service = BiometricAuthService();
      final reason = l.unlockWith.replaceFirst('%s', l.biometricFingerprint);
      suppressAppLock(const Duration(seconds: 20));
      final success = await service.authenticate(reason: reason);
      if (!mounted) return;
      if (success) {
        ref.read(fingerprintUnlockProvider.notifier).setEnabled(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.success)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.failed)),
        );
      }
    } else {
      // Face ID = verifikasi wajah via AI Core (FaceNet) + enrollment.
      await _enrollFaceForAppLock(l);
    }
  }

  Future<void> _enrollFaceForAppLock(AppLocalizations l) async {
    // Navigate to face scanner to capture a live face photo.
    final path = await context.push<String>('/face-scanner');
    if (path == null || !mounted) return;

    // Show loading while AI Core verifies & enrolls.
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final appLockService = ref.read(appLockServiceProvider);
    final result = await appLockService.enrollFace(path);

    if (!mounted) return;
    Navigator.of(context).pop(); // dismiss loading

    if (result != null && result['face_enrolled'] == true) {
      ref.read(faceUnlockProvider.notifier).setEnabled(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.success)),
      );
    } else {
      final reason = result?['reason'] as String?;
      final msg = switch (reason) {
        'FACE_MISMATCH' => 'Wajah tidak cocok dengan data KYC',
        'KYC_NOT_COMPLETED' => 'Verifikasi identitas (KYC) belum diselesaikan',
        _ => result?['message'] as String? ?? l.failed,
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  Future<void> _editBiometric(BiometricType type, AppLocalizations l) async {
    final service = BiometricAuthService();
    final typeName = type == BiometricType.fingerprint ? l.biometricFingerprint : l.appLockFaceId;
    final reason = l.unlockWith.replaceFirst('%s', typeName);
    suppressAppLock(const Duration(seconds: 20));
    final success = await service.authenticate(reason: reason);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? l.success : l.failed)),
    );
  }

  Future<void> _deleteBiometric(BiometricType type, AppLocalizations l) async {
    if (type == BiometricType.fingerprint) {
      ref.read(fingerprintUnlockProvider.notifier).setEnabled(false);
    } else {
      ref.read(faceUnlockProvider.notifier).setEnabled(false);
    }
  }

  Future<void> _addPin(AppLocalizations l) async {
    final hasValidPin = await hasValidStoredPin(email: ref.read(currentAccountEmailProvider));
    if (!mounted) return;
    if (hasValidPin) {
      ref.read(pinUnlockProvider.notifier).setEnabled(true);
      return;
    }
    await clearStoredPin(email: ref.read(currentAccountEmailProvider));
    if (!mounted) return;
    await showPinSetupSheet(context, mode: PinSheetMode.setup);
  }

  Future<void> _editPin() async {
    await showPinSetupSheet(context, mode: PinSheetMode.change);
  }

  Future<void> _deletePin(AppLocalizations l) async {
    await showPinSetupSheet(context, mode: PinSheetMode.disable);
  }

  void _confirmDeleteBiometric(BiometricType type, AppLocalizations l) {
    final label = type == BiometricType.fingerprint ? l.biometricFingerprint : l.appLockFaceId;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.delete),
        content: Text(l.deletePrompt.replaceFirst('%s', label)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteBiometric(type, l);
            },
            child: Text(l.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    final l = AppLocalizations.of(context)!;
    final accountEmail = ref.read(currentAccountEmailProvider);
    if (accountEmail == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _DeleteAccountDialog(accountEmail: accountEmail),
    );
    if (confirmed != true || !mounted) return;
    final ok = await ref.read(authProvider.notifier).deleteAccount();
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.accountDeleted)),
      );
      context.go('/landing');
    } else {
      final authState = ref.read(authProvider);
      final msg = authState is AuthError ? authState.message : AppErrorCodes.anErrorOccurred;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizedError.of(l, msg))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final fingerprintEnabled = ref.watch(fingerprintUnlockProvider);
    final faceEnabled = ref.watch(faceUnlockProvider);
    final pinEnabled = ref.watch(pinUnlockProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: Text(l.settings), backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: ListView(
          children: [
            _menuTile(Icons.language, l.language, () => context.push('/language')),
            _menuTile(Icons.notifications_outlined, l.notifications, () => context.push('/notification-settings')),
            _menuTile(Icons.flag_outlined, l.report, () => context.push('/report', extra: {
              'category': 'general',
              'item_name': '',
            })),
            const SizedBox(height: AppSizes.md),

            // ── TAMPILAN ──────────────────────────────────────────────
            Text(l.appearance.toUpperCase(), style: AppTextStyles.bodySmall),
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
            const SizedBox(height: AppSizes.lg),

            // ── KATA SANDI DAN KEAMANAN ───────────────────────────────
            Text(l.passwordAndSecurity.toUpperCase(), style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSizes.sm),
            _menuTile(Icons.security_outlined, l.passwordAndSecurity, () => context.push('/security-settings')),
            const SizedBox(height: AppSizes.lg),

            // ── KUNCI APLIKASI ────────────────────────────────────────
            Text(l.appLock.toUpperCase(), style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSizes.sm),
            Text(
              l.appLockNote,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.sm),
            _lockMethodCard(
              icon: Icons.fingerprint,
              title: l.biometricFingerprint,
              subtitle: l.useFingerprint,
              enabled: fingerprintEnabled,
              onAdd: () => _enableBiometric(BiometricType.fingerprint, l),
              onEdit: () => _editBiometric(BiometricType.fingerprint, l),
              onDelete: () => _confirmDeleteBiometric(BiometricType.fingerprint, l),
            ),
            _lockMethodCard(
              icon: Icons.screen_lock_portrait,
              title: l.appLockFaceId,
              subtitle: l.useAppLockFaceId,
              enabled: faceEnabled,
              onAdd: () => _enableBiometric(BiometricType.face, l),
              onDelete: () => _confirmDeleteBiometric(BiometricType.face, l),
            ),
            _lockMethodCard(
              icon: Icons.pin_outlined,
              title: l.pinLock,
              subtitle: l.usePinToUnlock,
              enabled: pinEnabled,
              onAdd: () => _addPin(l),
              onEdit: _editPin,
              onDelete: () => _deletePin(l),
            ),
            const SizedBox(height: AppSizes.lg),

            // ── HAPUS AKUN ────────────────────────────────────────────
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
              child: ListTile(
                leading: Icon(Icons.delete_forever_outlined, color: Theme.of(context).colorScheme.error),
                title: Text(l.deleteAccount, style: AppTextStyles.bodyMedium),
                subtitle: Text(l.deleteAccountWarning, style: AppTextStyles.bodySmall),
                trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.error),
                onTap: _deleteAccount,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lockMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    required VoidCallback onAdd,
    VoidCallback? onEdit,
    required VoidCallback onDelete,
  }) {
    final l = AppLocalizations.of(context)!;
    final hasEdit = onEdit != null;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon, color: AppColors.primaryColor),
              title: Text(title, style: AppTextStyles.bodyMedium),
              subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
              trailing: enabled
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 18, color: AppColors.primaryColor),
                        const SizedBox(width: 4),
                        Text(l.enabled, style: AppTextStyles.bodySmall),
                      ],
                    )
                  : Text(l.disabled, style: AppTextStyles.bodySmall),
            ),
            Row(
              children: [
                if (!enabled)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l.add),
                    ),
                  )
                else ...[
                  if (hasEdit)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: Text(l.edit),
                      ),
                    ),
                  if (hasEdit) const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: Text(l.delete),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
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

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({required this.accountEmail});

  final String accountEmail;

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final l = AppLocalizations.of(context)!;
    if (_controller.text.trim().toLowerCase() != widget.accountEmail.trim().toLowerCase()) {
      setState(() => _errorText = l.emailMismatch);
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(l.deleteAccount),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.deleteAccountWarning),
          const SizedBox(height: AppSizes.md),
          Text(l.deleteAccountConfirm, style: AppTextStyles.bodySmall),
          const SizedBox(height: AppSizes.sm),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: widget.accountEmail,
              errorText: _errorText,
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onSubmitted: (_) => _confirm(),
            onChanged: (_) {
              if (_errorText != null) setState(() => _errorText = null);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: _confirm,
          child: Text(l.delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
      ],
    );
  }
}