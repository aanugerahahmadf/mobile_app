import 'package:flutter/material.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/app_sizes/app_sizes.dart';

class AppTheme {
  static TextTheme _textTheme(Color primary, Color secondary) {
    TextStyle style(double size, FontWeight weight, Color color) => TextStyle(
      fontFamily: 'InstrumentSans',
      fontSize: size,
      fontWeight: weight,
      color: color,
    );

    return TextTheme(
      displayLarge: style(57, FontWeight.w400, primary),
      displayMedium: style(45, FontWeight.w400, primary),
      displaySmall: style(36, FontWeight.w400, primary),
      headlineLarge: style(32, FontWeight.w600, primary),
      headlineMedium: style(28, FontWeight.w600, primary),
      headlineSmall: style(24, FontWeight.w600, primary),
      titleLarge: style(22, FontWeight.w600, primary),
      titleMedium: style(16, FontWeight.w400, primary),
      titleSmall: style(14, FontWeight.w400, primary),
      bodyLarge: style(16, FontWeight.w400, primary),
      bodyMedium: style(14, FontWeight.w400, primary),
      bodySmall: style(12, FontWeight.w400, secondary),
      labelLarge: style(14, FontWeight.w400, primary),
      labelMedium: style(12, FontWeight.w400, secondary),
      labelSmall: style(11, FontWeight.w400, secondary),
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.primaryColor,
      secondaryContainer: AppColors.primaryLight,
      surface: AppColors.surfaceColor,
      onSurface: AppColors.textPrimary,
      error: AppColors.errorColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'InstrumentSans',
      textTheme: _textTheme(AppColors.textPrimary, AppColors.textSecondary),
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceColor,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(fontFamily: 'InstrumentSans', 
          fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.primaryColor.withAlpha(76),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          textStyle: TextStyle(fontFamily: 'InstrumentSans', 
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          side: BorderSide(color: AppColors.primaryColor.withAlpha(77)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          textStyle: TextStyle(fontFamily: 'InstrumentSans', 
            fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          textStyle: TextStyle(fontFamily: 'InstrumentSans', 
            fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundColor,
        hintStyle: TextStyle(fontFamily: 'InstrumentSans', 
          fontSize: 14, fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide(color: AppColors.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        prefixIconColor: AppColors.textTertiary,
        suffixIconColor: AppColors.textTertiary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.black.withAlpha(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        clipBehavior: Clip.antiAlias,
        color: AppColors.surfaceColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12, fontWeight: FontWeight.w400),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        side: BorderSide(color: AppColors.dividerColor),
        selectedColor: AppColors.primaryLight,
        labelStyle: TextStyle(fontFamily: 'InstrumentSans', 
          fontSize: 13, fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentTextStyle: TextStyle(fontFamily: 'InstrumentSans', 
          fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.accentColor,
      secondaryContainer: AppColors.primaryDark,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.errorColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'InstrumentSans',
      textTheme: _textTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(fontFamily: 'InstrumentSans', 
          fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.primaryColor.withAlpha(76),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          textStyle: TextStyle(fontFamily: 'InstrumentSans', 
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentColor,
          side: BorderSide(color: AppColors.accentColor.withAlpha(77)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          textStyle: TextStyle(fontFamily: 'InstrumentSans', 
            fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentColor,
          textStyle: TextStyle(fontFamily: 'InstrumentSans', 
            fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        hintStyle: TextStyle(fontFamily: 'InstrumentSans', 
          fontSize: 14, fontWeight: FontWeight.w400,
          color: AppColors.darkTextTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide(color: AppColors.darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        prefixIconColor: AppColors.darkTextTertiary,
        suffixIconColor: AppColors.darkTextTertiary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.black.withAlpha(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        clipBehavior: Clip.antiAlias,
        color: AppColors.darkCard,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.accentColor,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12, fontWeight: FontWeight.w400),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        side: BorderSide(color: AppColors.darkDivider),
        selectedColor: AppColors.primaryDark,
        labelStyle: TextStyle(fontFamily: 'InstrumentSans', 
          fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.darkTextPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        backgroundColor: AppColors.darkSurface,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentTextStyle: TextStyle(fontFamily: 'InstrumentSans', 
          fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white,
        ),
      ),
    );
  }
}