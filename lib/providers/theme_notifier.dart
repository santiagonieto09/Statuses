import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const String _key = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key) ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[index];
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, mode.index);
  }

  Future<void> toggleTheme() async {
    switch (_themeMode) {
      case ThemeMode.system:
        await setThemeMode(ThemeMode.light);
      case ThemeMode.light:
        await setThemeMode(ThemeMode.dark);
      case ThemeMode.dark:
        await setThemeMode(ThemeMode.system);
    }
  }
}
