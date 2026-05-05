import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_sports/core/utils/dimensions.dart';

class ThemeController extends GetxController {
  static const String _themeModeKey = 'theme_mode';

  final SharedPreferences preferences;
  ThemeController(this.preferences);

  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode != ThemeMode.light;

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: Dimensions.fontFamily,
        fontFamilyFallback: const ['NotoSansBengali', 'NotoSans', 'Apple Color Emoji', 'Segoe UI Emoji', 'Noto Color Emoji'],
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonGold,
          secondary: AppColors.neonCyan,
          surface: AppColors.bgCard,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: Dimensions.fontFamily,
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      );

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: Dimensions.fontFamily,
        fontFamilyFallback: const ['NotoSansBengali', 'NotoSans', 'Apple Color Emoji', 'Segoe UI Emoji', 'Noto Color Emoji'],
        colorScheme: const ColorScheme.light(
          primary: AppColors.neonGoldDim,
          secondary: AppColors.neonBlue,
          surface: Colors.white,
        ),
        cardColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: const Color(0xFF0F172A),
            fontFamily: Dimensions.fontFamily,
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      );

  @override
  void onInit() {
    super.onInit();
    final savedMode = preferences.getString(_themeModeKey);
    if (savedMode == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }
    _themeMode = mode;
    await preferences.setString(_themeModeKey, mode == ThemeMode.light ? 'light' : 'dark');
    update();
  }
}
