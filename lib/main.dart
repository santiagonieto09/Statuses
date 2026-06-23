import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuses/app.dart';
import 'package:statuses/data/repositories/status_repository.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/providers/locale_notifier.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/providers/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(LocaleNotifier.key);
  final initialLocale = saved != null
      ? AppLocale.values.firstWhere(
          (l) => l.languageTag == saved,
          orElse: () => AppLocale.es,
        )
      : AppLocale.es;

  LocaleSettings.setLocaleSync(initialLocale);

  runApp(
    TranslationProvider(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider(
            create: (_) => LocaleNotifier(initialLocale: initialLocale),
          ),
          ChangeNotifierProvider(
            create: (_) => StatusNotifier(StatusRepository()),
          ),
          ChangeNotifierProvider(create: (_) => DownloadNotifier()),
        ],
        child: const StatusesApp(),
      ),
    ),
  );
}
