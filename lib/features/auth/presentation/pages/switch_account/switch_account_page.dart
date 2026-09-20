import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../widgets/auth_modals/auth_modals.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class SwitchAccountPage extends ConsumerWidget {
  const SwitchAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l.switchAccount),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          if (user != null) ...[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                trailing: const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: AppSizes.lg),
          ],
          AppButton(
            label: l.switchAccount,
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/landing');
                showSignInSheet(context);
              }
            },
            type: ButtonType.outline,
            icon: Icons.person_add,
          ),
          SizedBox(height: AppSizes.md),
          AppButton(
            label: l.signOut,
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/landing');
              }
            },
            type: ButtonType.primary,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }
}
