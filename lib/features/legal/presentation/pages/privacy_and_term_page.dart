import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class PrivacyAndTermPage extends StatelessWidget {
  const PrivacyAndTermPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privasi & Ketentuan')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.privacy_tip, color: AppColors.primaryColor),
              title: Text('Kebijakan Privasi', style: AppTextStyles.bodyMedium),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => context.push('/legal/privacy'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.description, color: AppColors.primaryColor),
              title: Text('Ketentuan Layanan', style: AppTextStyles.bodyMedium),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => context.push('/legal/terms'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
