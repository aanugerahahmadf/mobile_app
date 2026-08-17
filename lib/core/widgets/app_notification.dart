import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_button.dart';

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
    final effectiveTitle = title ?? config.defaultTitle;

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.overlayColor,
      builder: (ctx) => _AppNotificationDialog(
        message: message,
        title: effectiveTitle,
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
  final String defaultTitle;

  const _NotificationConfig({
    required this.icon,
    required this.color,
    required this.defaultTitle,
  });
}

const _configs = {
  NotificationType.success: _NotificationConfig(
    icon: Icons.check_circle_rounded,
    color: AppColors.successColor,
    defaultTitle: 'Berhasil',
  ),
  NotificationType.error: _NotificationConfig(
    icon: Icons.error_rounded,
    color: AppColors.errorColor,
    defaultTitle: 'Gagal',
  ),
  NotificationType.warning: _NotificationConfig(
    icon: Icons.warning_amber_rounded,
    color: AppColors.warningColor,
    defaultTitle: 'Perhatian',
  ),
  NotificationType.info: _NotificationConfig(
    icon: Icons.info_rounded,
    color: AppColors.infoColor,
    defaultTitle: 'Informasi',
  ),
};

class _AppNotificationDialog extends StatelessWidget {
  final String message;
  final String title;
  final IconData icon;
  final Color color;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool barrierDismissible;

  const _AppNotificationDialog({
    required this.message,
    required this.title,
    required this.icon,
    required this.color,
    this.actionLabel,
    this.onAction,
    required this.barrierDismissible,
  });

  @override
  Widget build(BuildContext context) {
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
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
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
                  label: 'Tutup',
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
