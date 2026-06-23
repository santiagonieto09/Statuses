import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuses/app.dart';
import 'package:statuses/data/repositories/status_repository.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/providers/locale_notifier.dart';
import 'package:statuses/providers/notification_notifier.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/providers/theme_notifier.dart';

void main() async {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
      };

      SharedPreferences.getInstance().then((prefs) {
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
                ChangeNotifierProvider(
                  create: (ctx) {
                    final notifier = DownloadNotifier();
                    notifier.attachStatusNotifier(ctx.read<StatusNotifier>());
                    return notifier;
                  },
                ),
                ChangeNotifierProvider(
                  create: (ctx) => NotificationNotifier(ctx.read<StatusNotifier>()),
                ),
              ],
              child: const StatusesApp(),
            ),
          ),
        );
      });
    },
    (error, stack) {
      debugPrint('Error no capturado: $error\n$stack');
    },
  );
}
