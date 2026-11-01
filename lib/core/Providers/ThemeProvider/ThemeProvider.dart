import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadPreference();
  }

  static const String _darkModeKey = 'dark_mode';

  ThemeMode toMaterialThemeMode() => state;

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_darkModeKey) ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleDarkMode([bool? value]) async {
    final next = value ?? (state != ThemeMode.dark);
    state = next ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, next);
  }
}
