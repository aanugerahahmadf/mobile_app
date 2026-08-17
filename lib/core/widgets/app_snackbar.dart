import 'package:flutter/material.dart';
import 'app_notification.dart';

class AppSnackBar {
  static void show(BuildContext context, String message, {SnackBarType type = SnackBarType.info}) {
    final notifType = switch (type) {
      SnackBarType.success => NotificationType.success,
      SnackBarType.error => NotificationType.error,
      SnackBarType.warning => NotificationType.warning,
      SnackBarType.info => NotificationType.info,
    };
    AppNotification.show(context, message, type: notifType);
  }
}

enum SnackBarType { success, error, warning, info }
