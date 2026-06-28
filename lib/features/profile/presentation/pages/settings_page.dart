import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
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

  Future<void> _checkBiometric() async {
    final available = await BiometricAuthService().isAvailable();
    if (mounted) setState(() => _biometricAvailable = available);
  }

  @override
  Widget build(BuildContext context) {
    final fingerprintEnabled = ref.watch(fingerprintUnlockProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            _menuTile(Icons.language, 'Bahasa', () => context.push('/language')),
            _menuTile(Icons.notifications_outlined, 'Pengaturan Notifikasi', () => context.push('/notification-settings')),
            _menuTile(Icons.privacy_tip_outlined, 'Privasi & Ketentuan', () => context.push('/legal/privacy-term')),
            SizedBox(height: AppSizes.sm),
            _menuTile(Icons.face_outlined, 'Verifikasi Wajah', () => context.push('/face-scanner'), subtitle: 'Scan wajah untuk verifikasi identitas'),
            if (_biometricAvailable) ...[
              const SizedBox(height: AppSizes.sm),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  secondary: Icon(Icons.fingerprint, color: AppColors.primaryColor),
                  title: Text('Buka Kunci Sidik Jari', style: AppTextStyles.bodyMedium),
                  subtitle: Text('Gunakan sidik jari untuk membuka aplikasi', style: AppTextStyles.bodySmall),
                  value: fingerprintEnabled,
                  onChanged: (v) => ref.read(fingerprintUnlockProvider.notifier).setEnabled(v),
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
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
