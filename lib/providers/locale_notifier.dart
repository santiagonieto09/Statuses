import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuses/i18n/translations.g.dart';

class LocaleNotifier extends ChangeNotifier {
  static const String key = 'locale';

  AppLocale _locale;
  bool _initialized = false;

  AppLocale get locale => _locale;
  bool get isInitialized => _initialized;

  Locale get flutterLocale => _locale.flutterLocale;

  LocaleNotifier({AppLocale? initialLocale}) : _locale = initialLocale ?? AppLocale.es {
    _init();
  }

  Future<void> _init() async {
    try {
      await _loadLocale();
    } catch (_) {
      _locale = AppLocale.es;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(key);
    if (saved != null) {
      _locale = AppLocale.values.firstWhere(
        (l) => l.languageTag == saved,
        orElse: () => AppLocale.es,
      );
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    _locale = locale;
    await LocaleSettings.setLocale(locale);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, locale.languageTag);
    } catch (_) {
      // Persistence failed but locale already applied
    }
    notifyListeners();
  }
}
