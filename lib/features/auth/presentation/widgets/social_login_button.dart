import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class SocialLoginButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;
  final bool enabled;

  const SocialLoginButton({super.key, required this.provider, this.onPressed, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Material(
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: enabled ? onPressed : null,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.dividerColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: AppColors.surfaceColor,
            ),
            icon: Image.asset('assets/images/Google/google.png', width: 22, height: 22),
            label: Text(
              'Lanjutkan dengan Google',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}

enum SocialProvider { google }
