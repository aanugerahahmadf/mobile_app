import 'package:flutter/material.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../Constants/AppTextStyles/AppTextStyles.dart';
import '../../Constants/AppColors/AppColors.dart';
import '../AppButton/AppButton.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, size: 48, color: AppColors.errorColor),
            ),
            const SizedBox(height: 20),
            Text(message, style: AppTextStyles.bodyLarge, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(label: AppLocalizations.of(context)!.tryAgain, onPressed: onRetry, type: ButtonType.outline),
            ],
          ],
        ),
      ),
    );
  }
}
