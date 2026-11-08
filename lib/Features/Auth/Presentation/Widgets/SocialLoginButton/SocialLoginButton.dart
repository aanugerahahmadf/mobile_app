import 'package:flutter/material.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';

class SocialLoginButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;
  final bool enabled;

  const SocialLoginButton({
    super.key,
    required this.provider,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceColor,
            foregroundColor: AppColors.textPrimary,
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: AppColors.dividerColor, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildIcon(),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  _label(l),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider) {
      case SocialProvider.google:
        return Image.asset(
          'assets/images/Google/google.png',
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        );
      case SocialProvider.facebook:
        return const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 22);
      case SocialProvider.apple:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: const Center(
            child: Text(
              '\uF8FF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
