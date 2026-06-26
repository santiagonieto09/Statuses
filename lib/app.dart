import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:statuses/data/services/permission_service.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/locale_notifier.dart';
import 'package:statuses/providers/theme_notifier.dart';
import 'package:statuses/ui/screens/app_shell.dart';
import 'package:statuses/ui/screens/app_startup_screen.dart';
import 'package:statuses/ui/screens/help_screen.dart';
import 'package:statuses/ui/screens/permission_screen.dart';
import 'package:statuses/ui/screens/settings_screen.dart';
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
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return _buildRoute(const AppStartupScreen());
              case '/permission':
                final state =
                    settings.arguments as PermissionState?;
                return _buildRoute(PermissionScreen(initialState: state));
              case '/home':
                return _buildRoute(const AppShell());
              case '/settings':
                return _buildRoute(const SettingsScreen());
              case '/help':
                return _buildRoute(const HelpScreen());
              default:
                return null;
            }
          },
        );
      },
    );
  }

  PageRouteBuilder _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
