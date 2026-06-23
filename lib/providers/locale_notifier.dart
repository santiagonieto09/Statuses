import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuses/i18n/translations.g.dart';

class LocaleNotifier extends ChangeNotifier {
  static const String _key = 'locale';

  AppLocale _locale = AppLocale.en;
  bool _initialized = false;

  AppLocale get locale => _locale;
  bool get isInitialized => _initialized;

  Locale get flutterLocale => _locale.flutterLocale;

  LocaleNotifier() {
    _init();
  }

  Future<void> _init() async {
    try {
      await _loadLocale();
    } catch (_) {
      _locale = AppLocale.en;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      _locale = AppLocale.values.firstWhere(
        (l) => l.languageTag == saved,
        orElse: () => AppLocale.en,
      );
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    _locale = locale;
    await LocaleSettings.setLocale(locale);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, locale.languageTag);
    } catch (_) {
      // Persistence failed but locale already applied
    }
    notifyListeners();
  }
}
