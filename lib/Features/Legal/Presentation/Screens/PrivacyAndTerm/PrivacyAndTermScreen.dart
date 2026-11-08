import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';

class PrivacyAndTermScreen extends StatelessWidget {
  const PrivacyAndTermScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l.privacyAndTerms),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38),
          child: const AppBreadcrumbs.global(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.privacy_tip,
                color: AppColors.primaryColor,
              ),
              title: Text(l.privacyPolicy, style: AppTextStyles.bodyMedium),
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () => context.push('/privacy-policy'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.description,
                color: AppColors.primaryColor,
              ),
              title: Text(l.termsOfService, style: AppTextStyles.bodyMedium),
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () => context.push('/terms-of-service'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.local_florist,
                color: AppColors.primaryColor,
              ),
              title: Text(l.weddingPolicy, style: AppTextStyles.bodyMedium),
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () => context.push('/wedding-policy'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
