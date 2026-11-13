import 'package:flutter/material.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';

class SocialSignInButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool loading;

  const SocialSignInButton({
    super.key,
    required this.provider,
    this.onPressed,
    this.enabled = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isInteractive = enabled && !loading;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Material(
        elevation: isInteractive ? 3 : 1,
        shadowColor: Colors.black.withValues(alpha: isInteractive ? 0.2 : 0.05),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: isInteractive ? onPressed : null,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isInteractive
                    ? AppColors.dividerColor
                    : AppColors.dividerColor.withValues(alpha: 0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: isInteractive
                  ? AppColors.surfaceColor
                  : AppColors.surfaceColor.withValues(alpha: 0.7),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
            child: loading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l.loading,
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIcon(),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
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
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Image.asset(
      'assets/images/Google/google.png',
      width: 22,
      height: 22,
      fit: BoxFit.contain,
    );
  }

  String _label(AppLocalizations l) {
    return l.continueWithGoogle;
  }
}

enum SocialProvider { google }
