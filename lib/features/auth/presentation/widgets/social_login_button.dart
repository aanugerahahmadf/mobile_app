import 'package:flutter/material.dart';
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
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.white,
          ),
          icon: Image.asset('assets/images/Google/google.png', width: 22, height: 22),
          label: Text(
            'Lanjutkan dengan Google',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
          ),
        ),
      ),
    );
  }
}

enum SocialProvider { google }
