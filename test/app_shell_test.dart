import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/providers/theme_notifier.dart';
import 'package:statuses/ui/screens/app_shell.dart';
import 'mocks.dart';

Widget createTestApp() {
  final repo = FakeStatusRepository();
  return TranslationProvider(
    child: MaterialApp(
      locale: const Locale('en'),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider(create: (_) => StatusNotifier(repo)),
          ChangeNotifierProvider(create: (_) => DownloadNotifier()),
        ],
        child: const AppShell(),
      ),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('AppShell displays bottom NavigationBar', (tester) async {
    await tester.pumpWidget(createTestApp());

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(3));
  });

  testWidgets('NavigationBar has stories and saved tabs', (tester) async {
    final t = AppLocale.en.translations;
    await tester.pumpWidget(createTestApp());

    expect(find.text(t.nav.statuses), findsOneWidget);
    expect(find.text(t.nav.saved), findsOneWidget);
  });

  testWidgets('Setting icon is present', (tester) async {
    await tester.pumpWidget(createTestApp());

    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });
}
