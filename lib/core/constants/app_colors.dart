import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool _isDark = false;
  static void updateBrightness(bool dark) => _isDark = dark;

  // Light mode
  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color primaryDark = Color(0xFF0F2440);
  static Color get primaryLight => _isDark ? const Color(0xFF1A237E) : const Color(0xFFEEF2FF);
  static const Color accentColor = Color(0xFFC9A94E);
  static Color get secondaryColor => _isDark ? _secondaryColorDark : _secondaryColorLight;

  // Dynamic text colors (switch with theme)
  static Color get textPrimary => _isDark ? darkTextPrimary : _textPrimaryLight;
  static Color get textSecondary => _isDark ? darkTextSecondary : _textSecondaryLight;
  static Color get textTertiary => _isDark ? darkTextTertiary : _textTertiaryLight;
  static Color get backgroundColor => _isDark ? darkBackground : _backgroundColorLight;
  static Color get surfaceColor => _isDark ? darkSurface : _surfaceColorLight;
  static Color get dividerColor => _isDark ? darkDivider : _dividerColorLight;
  static Color get shimmerBase => _isDark ? _darkShimmerBase : _shimmerBaseLight;
  static Color get shimmerHighlight => _isDark ? _darkShimmerHighlight : _shimmerHighlightLight;

  // Light mode consts
  static const Color _textPrimaryLight = Color(0xFF1A1A2E);
  static const Color _textSecondaryLight = Color(0xFF8E8E9A);
  static const Color _textTertiaryLight = Color(0xFFB0B0BC);
  static const Color _backgroundColorLight = Color(0xFFF8F6F7);
  static const Color _surfaceColorLight = Color(0xFFFFFFFF);
  static const Color _secondaryColorLight = Color(0xFFF0F2F5);
  static const Color _dividerColorLight = Color(0xFFF0F0F3);
  static const Color _shimmerBaseLight = Color(0xFFE8E8EC);
  static const Color _shimmerHighlightLight = Color(0xFFF5F5F8);

  // Dark mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color _secondaryColorDark = Color(0xFF2C2C2C);
  static const Color darkDivider = Color(0xFF3A3A3A);
  static const Color darkTextPrimary = Color(0xFFE8E8E8);
  static const Color darkTextSecondary = Color(0xFFA0A0A0);
  static const Color darkTextTertiary = Color(0xFF707070);
  static const Color _darkShimmerBase = Color(0xFF3A3A3A);
  static const Color _darkShimmerHighlight = Color(0xFF4A4A4A);

  // Theme-independent colors
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);
  static const Color eventDayColor = Color(0xFF9C27B0);
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
