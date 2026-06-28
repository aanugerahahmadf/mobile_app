import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_modals.dart';

class SwitchAccountPage extends ConsumerWidget {
  const SwitchAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(title: Text('Ganti Akun')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          if (user != null) ...[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(AppSizes.md),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: user.avatarUrl != null
                      ? CachedNetworkImageProvider(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                title: Text(user.fullName, style: AppTextStyles.titleMedium),
                subtitle: Text(user.email, style: AppTextStyles.bodySmall),
                trailing: const Icon(Icons.check_circle, color: AppColors.primaryColor),
              ),
            ),
            SizedBox(height: AppSizes.lg),
          ],
          AppButton(
            label: 'Tambah Akun',
            onPressed: () async {
              await const FlutterSecureStorage().delete(key: 'auth_token');
              if (context.mounted) showSignInSheet(context);
            },
            type: ButtonType.outline,
            icon: Icons.person_add,
          ),
          SizedBox(height: AppSizes.md),
          AppButton(
            label: 'Keluar',
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) showSignInSheet(context);
            },
            type: ButtonType.primary,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }
}
