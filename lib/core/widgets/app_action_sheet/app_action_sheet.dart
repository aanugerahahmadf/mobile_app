import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/app_text_styles/app_text_styles.dart';

class AppSheetAction<T> {
  final T value;
  final String label;
  final IconData? icon;
  final bool destructive;

  const AppSheetAction({
    required this.value,
    required this.label,
    this.icon,
    this.destructive = false,
  });
}

Future<T?> showAppActionSheet<T>(
  BuildContext context, {
  String? title,
  required List<AppSheetAction<T>> actions,
}) async {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  if (isIOS) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: title == null ? null : Text(title),
        actions: [
          for (final a in actions)
            CupertinoActionSheetAction(
              isDestructiveAction: a.destructive,
              onPressed: () => Navigator.of(sheetContext).pop(a.value),
              child: a.icon == null
                  ? Text(a.label)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(a.icon, size: 18),
                        const SizedBox(width: 8),
                        Text(a.label),
                      ],
                    ),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (sheetContext) => Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            for (final a in actions)
              ListTile(
                leading: a.icon == null
                    ? null
                    : Icon(
                        a.icon,
                        size: 20,
                        color: a.destructive
                            ? AppColors.errorColor
                            : AppColors.textPrimary,
                      ),
                title: Text(
                  a.label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: a.destructive
                        ? AppColors.errorColor
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () => Navigator.of(sheetContext).pop(a.value),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}