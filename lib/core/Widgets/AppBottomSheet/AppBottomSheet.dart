import 'package:flutter/material.dart';
import '../../Constants/AppColors/AppColors.dart';
import '../../Constants/AppSizes/AppSizes.dart';
import '../AppBlurBackdrop/AppBlurBackdrop.dart';

class AppBottomSheet {
  static Future<T?> show<T>(
    BuildContext context,
    Widget child, {
    String? title,
    double initial = 0.5,
    double min = 0.25,
    double max = 0.9,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBlurBackdrop(
        borderRadius: 24,
        child: DraggableScrollableSheet(
          initialChildSize: initial,
          minChildSize: min,
          maxChildSize: max,
          expand: false,
          builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (title != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
