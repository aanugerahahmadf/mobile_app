import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
        const SizedBox(height: AppSizes.xs),
        Text(subtitle, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
      ],
    );
  }
}
