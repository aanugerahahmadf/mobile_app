import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color primaryDark = Color(0xFF0F2440);
  static const Color primaryLight = Color(0xFF8BA3C3);
  static const Color secondaryColor = Color(0xFFF0F2F5);
  static const Color accentColor = Color(0xFFC9A94E);
  static const Color backgroundColor = Color(0xFFF8F6F7);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF8E8E9A);
  static const Color textTertiary = Color(0xFFB0B0BC);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);
  static const Color shimmerBase = Color(0xFFE8E8EC);
  static const Color shimmerHighlight = Color(0xFFF5F5F8);
  static const Color dividerColor = Color(0xFFF0F0F3);
  static const Color overlayColor = Color(0x883B3B4F);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, Color(0xFF2C5282)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientH = LinearGradient(
    colors: [primaryColor, Color(0xFF2C5282)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const List<Color> categoryColors = [
    Color(0xFFE8EDF3),
    Color(0xFFF0ECD8),
    Color(0xFFE8F0EA),
    Color(0xFFE3EAF5),
    Color(0xFFEDE8F3),
    Color(0xFFF5F0E0),
  ];

  static const List<IconData> categoryIcons = [
    Icons.card_giftcard,
    Icons.local_florist,
    Icons.emoji_nature,
    Icons.spa,
    Icons.celebration,
    Icons.palette,
  ];
}
