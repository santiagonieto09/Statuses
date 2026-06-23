import 'package:flutter_test/flutter_test.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/ui/widgets/empty_state.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('EmptyState displays default message', (WidgetTester tester) async {
    final t = AppLocale.en.translations;
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: t.empty.default_title,
              subtitle: t.empty.default_subtitle,
            ),
          ),
        ),
      ),
    );

    expect(find.text('No statuses found'), findsOneWidget);
    expect(
      find.text('Open WhatsApp, view some statuses, then come back here.'),
      findsOneWidget,
    );
  });
}
