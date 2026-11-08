import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadPreference();
  }

  static const String _themeModeKey = 'app_theme_mode';
  static const String _darkModeKey = 'dark_mode';

  ThemeMode toMaterialThemeMode() => state;

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeModeKey);
    if (savedMode != null) {
      switch (savedMode) {
        case 'light':
          state = ThemeMode.light;
          return;
        case 'dark':
        case 'night':
          state = ThemeMode.dark;
          return;
        case 'system':
        default:
          state = ThemeMode.system;
          return;
      }
    }

    // Fallback backwards compatibility with legacy boolean dark_mode
    if (prefs.containsKey(_darkModeKey)) {
      final isDark = prefs.getBool(_darkModeKey) ?? false;
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    final modeStr = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_themeModeKey, modeStr);
    await prefs.setBool(_darkModeKey, mode == ThemeMode.dark);
  }

  Future<void> toggleDarkMode([bool? value]) async {
    final next = value ?? (state != ThemeMode.dark);
    await setThemeMode(next ? ThemeMode.dark : ThemeMode.light);
  }
}

