import 'dart:ui';

import 'package:flutter/material.dart';
import '../../constants/app_colors/app_colors.dart';

/// Frosted-glass backdrop shared by every blurred surface in the app.
///
/// Spec:
///  - Night: blur 15 + dark tint at 50% opacity
///  - Light: blur 15 + light tint at 50% opacity
///
/// The tint is applied as the surface fill (rather than on top of an opaque
/// surface), otherwise it would fully hide the blurred content behind it.
class AppBlurBackdrop extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;

  const AppBlurBackdrop({
    super.key,
    required this.child,
    this.borderRadius = 14,
    this.padding,
    this.margin,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = isDark ? AppColors.blurTintNight : AppColors.blurTintLight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppColors.blurSigma,
          sigmaY: AppColors.blurSigma,
        ),
        child: Container(
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}
