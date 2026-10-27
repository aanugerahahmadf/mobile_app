import 'package:flutter/material.dart';
import '../app_colors/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Standar Material (default sizes) dengan Instrument Sans.
  // Judul/head semi bold (w600), lainnya normal (w400).
  static TextStyle get headTitle => TextStyle(fontFamily: 'InstrumentSans', 
    fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle get subHeadTitle => TextStyle(fontFamily: 'InstrumentSans', 
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle get h3 => TextStyle(fontFamily: 'InstrumentSans', 
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle get h4 => TextStyle(fontFamily: 'InstrumentSans', 
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle get description => TextStyle(fontFamily: 'InstrumentSans', 
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
    height: 1.4,
  );
  static TextStyle get button => TextStyle(fontFamily: 'InstrumentSans', 
    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
  );

  static TextStyle get displayLarge => headTitle;
  static TextStyle get displayMedium => subHeadTitle;
  static TextStyle get headlineLarge => headTitle;
  static TextStyle get headlineMedium => subHeadTitle;
  static TextStyle get headlineSmall => h3;
  static TextStyle get titleLarge => headTitle;
  static TextStyle get titleMedium => subHeadTitle;
  static TextStyle get titleSmall => h3;
  static TextStyle get bodyLarge => description;
  static TextStyle get bodyMedium => description;
  static TextStyle get bodySmall => h4;
  static TextStyle get labelLarge => h4;
  static TextStyle get labelMedium => h4;
  static TextStyle get labelSmall => h4;
  static TextStyle get price => TextStyle(fontFamily: 'InstrumentSans', 
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryColor,
  );
  static TextStyle get priceSmall => TextStyle(fontFamily: 'InstrumentSans', 
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryColor,
  );
}