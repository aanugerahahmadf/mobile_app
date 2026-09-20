import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/app_sizes/app_sizes.dart';
import '../app_button/app_button.dart';
import '../../../features/auth/presentation/widgets/auth_modals/auth_modals.dart';

class GuestAuthPrompt extends StatelessWidget {
  final IconData icon;
  final String? title;
  final String? description;

  const GuestAuthPrompt({
    super.key,
    this.icon = Icons.lock_outline_rounded,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.primaryColor),
            const SizedBox(height: AppSizes.md),
            Text(
              title ?? l.guestAccessTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              description ?? l.guestAccessDescription,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.lg),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: l.signIn,
                      type: ButtonType.outline,
                      onPressed: () => showSignInSheet(context),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppButton(
                      label: l.signUp,
                      onPressed: () => showSignUpSheet(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
