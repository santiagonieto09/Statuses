import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuses/app.dart';
import 'package:statuses/data/repositories/status_repository.dart';
import 'package:statuses/data/services/permission_service.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/providers/locale_notifier.dart';
import 'package:statuses/providers/notification_notifier.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/providers/theme_notifier.dart';

final Stopwatch _appStartSw = Stopwatch()..start();

void main() async {
  final mainTask = developer.TimelineTask();
  mainTask.start('AppStartup');

  runZonedGuarded(
    () {
      developer.Timeline.timeSync('ensureInitialized', () {
        WidgetsFlutterBinding.ensureInitialized();
      });
      final initTime = _appStartSw.elapsedMilliseconds;
      debugPrint('[PERF] WidgetsFlutterBinding.ensureInitialized: ${initTime}ms');

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
      };

      SharedPreferences.getInstance().then((prefs) {
        final prefsTime = _appStartSw.elapsedMilliseconds;
        debugPrint('[PERF] SharedPreferences.getInstance: ${prefsTime}ms');

        unawaited(androidSdkVersion);

        final saved = prefs.getString(LocaleNotifier.key);
        final initialLocale = saved != null
            ? AppLocale.values.firstWhere(
                (l) => l.languageTag == saved,
                orElse: () => AppLocale.es,
              )
            : AppLocale.es;

        developer.Timeline.timeSync('locale_set', () {
          LocaleSettings.setLocaleSync(initialLocale);
        });

        developer.Timeline.timeSync('runApp', () {
          runApp(
            TranslationProvider(
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) {
                    final sw = Stopwatch()..start();
                    final r = ThemeNotifier();
                    debugPrint('[PERF] ThemeNotifier created: ${sw.elapsedMilliseconds}ms');
                    return r;
                  }),
                  ChangeNotifierProvider(
                    create: (_) {
                      final sw = Stopwatch()..start();
                      final r = LocaleNotifier(initialLocale: initialLocale);
                      debugPrint('[PERF] LocaleNotifier created: ${sw.elapsedMilliseconds}ms');
                      return r;
                    },
                  ),
                  ChangeNotifierProvider(
                    create: (_) {
                      final sw = Stopwatch()..start();
                      final r = StatusNotifier(StatusRepository());
                      debugPrint('[PERF] StatusNotifier created: ${sw.elapsedMilliseconds}ms');
                      return r;
                    },
                  ),
                  ChangeNotifierProvider(
                    create: (ctx) {
                      final sw = Stopwatch()..start();
                      final notifier = DownloadNotifier();
                      notifier.attachStatusNotifier(ctx.read<StatusNotifier>());
                      debugPrint('[PERF] DownloadNotifier created: ${sw.elapsedMilliseconds}ms');
                      return notifier;
                    },
                  ),
                  ChangeNotifierProvider(
                    create: (ctx) {
                      final sw = Stopwatch()..start();
                      final r = NotificationNotifier(ctx.read<StatusNotifier>());
                      debugPrint('[PERF] NotificationNotifier created: ${sw.elapsedMilliseconds}ms');
                      return r;
                    },
                  ),
                ],
                child: const StatusesApp(),
              ),
            ),
          );
        });

        final runAppTime = _appStartSw.elapsedMilliseconds;
        debugPrint('[PERF] main -> runApp completado en ${runAppTime}ms');
        mainTask.finish();
      });
    },
    (error, stack) {
      debugPrint('Error no capturado: $error\n$stack');
    },
  );
}
