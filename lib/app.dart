import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:statuses/data/services/permission_service.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/locale_notifier.dart';
import 'package:statuses/providers/theme_notifier.dart';
import 'package:statuses/ui/screens/app_shell.dart';
import 'package:statuses/ui/screens/app_startup_screen.dart';
import 'package:statuses/ui/screens/permission_screen.dart';
import 'package:statuses/ui/theme/dark_theme.dart';
import 'package:statuses/ui/theme/light_theme.dart';

class StatusesApp extends StatelessWidget {
  const StatusesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        final locale = context.watch<LocaleNotifier>();
        return MaterialApp(
          title: 'Statuses',
          debugShowCheckedModeBanner: false,
          locale: locale.flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: LightTheme.theme,
          darkTheme: DarkTheme.theme,
          themeMode: themeNotifier.themeMode,
          initialRoute: '/',
          routes: {
            '/': (_) => const AppStartupScreen(),
            '/permission': (context) {
              final state =
                  ModalRoute.of(context)?.settings.arguments as PermissionState?;
              return PermissionScreen(initialState: state);
            },
            '/home': (_) => const AppShell(),
          },
        );
      },
    );
  }
}
