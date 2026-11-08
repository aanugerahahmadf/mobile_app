import 'package:flutter/material.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../Constants/AppColors/AppColors.dart';
import '../AppButton/AppButton.dart';

enum NotificationType { success, error, warning, info }

class AppNotification {
  static void show(
    BuildContext context,
    String message, {
    NotificationType type = NotificationType.info,
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    bool barrierDismissible = true,
  }) {
    final config = _configs[type]!;

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.overlayColor,
      builder: (ctx) => _AppNotificationDialog(
        message: message,
        title: title,
        type: type,
        icon: config.icon,
        color: config.color,
        actionLabel: actionLabel,
        onAction: onAction,
        barrierDismissible: barrierDismissible,
      ),
    );
  }
}

class _NotificationConfig {
  final IconData icon;
  final Color color;

  const _NotificationConfig({
    required this.icon,
    required this.color,
  });
}

const _configs = {
  NotificationType.success: _NotificationConfig(
    icon: Icons.check_circle_rounded,
    color: AppColors.successColor,
  ),
  NotificationType.error: _NotificationConfig(
    icon: Icons.error_rounded,
    color: AppColors.errorColor,
  ),
  NotificationType.warning: _NotificationConfig(
    icon: Icons.warning_amber_rounded,
    color: AppColors.warningColor,
  ),
  NotificationType.info: _NotificationConfig(
    icon: Icons.info_rounded,
    color: AppColors.infoColor,
  ),
};

class _AppNotificationDialog extends StatelessWidget {
  final String message;
  final String? title;
  final NotificationType type;
  final IconData icon;
  final Color color;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool barrierDismissible;

  const _AppNotificationDialog({
    required this.message,
    this.title,
    required this.type,
    required this.icon,
    required this.color,
    this.actionLabel,
    this.onAction,
    required this.barrierDismissible,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isIndonesian = l?.localeName.startsWith('id') ?? true;

    final resolvedTitle = title ??
        switch (type) {
          NotificationType.success => l?.success ?? (isIndonesian ? 'Berhasil' : 'Success'),
          NotificationType.error => l?.error ?? (isIndonesian ? 'Gagal' : 'Error'),
          NotificationType.warning => isIndonesian ? 'Perhatian' : 'Warning',
          NotificationType.info => isIndonesian ? 'Informasi' : 'Information',
        };

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.surfaceColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              resolvedTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (actionLabel != null && onAction != null)
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: actionLabel!,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onAction!();
                  },
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: l?.close ?? (isIndonesian ? 'Tutup' : 'Close'),
                  type: ButtonType.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
