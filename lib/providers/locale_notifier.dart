import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuses/i18n/translations.g.dart';

class LocaleNotifier extends ChangeNotifier {
  static const String _key = 'locale';

  AppLocale _locale = AppLocale.en;

  AppLocale get locale => _locale;

  Locale get flutterLocale => _locale.flutterLocale;

  LocaleNotifier() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      _locale = AppLocale.values.firstWhere(
        (l) => l.languageTag == saved,
        orElse: () => AppLocale.en,
      );
      notifyListeners();
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    _locale = locale;
    notifyListeners();
    LocaleSettings.setLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageTag);
  }
}
