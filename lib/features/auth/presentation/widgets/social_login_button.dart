import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class SocialLoginButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;
  final bool enabled;

  const SocialLoginButton({super.key, required this.provider, this.onPressed, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
            icon: _buildIcon(),
            label: Text(
              _label(l),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider) {
      case SocialProvider.google:
        return Image.asset('assets/images/Google/google.png', width: 22, height: 22);
      case SocialProvider.facebook:
        return const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 22);
      case SocialProvider.apple:
        return Container(
          width: 22, height: 22,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
          child: Center(child: Text('\uF8FF', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
        );
    }
  }

  String _label(AppLocalizations l) {
    switch (provider) {
      case SocialProvider.google:
        return l.continueWithGoogle;
      case SocialProvider.facebook:
        return l.continueWithFacebook;
      case SocialProvider.apple:
        return l.continueWithApple;
    }
  }
}

enum SocialProvider { google, facebook, apple }
