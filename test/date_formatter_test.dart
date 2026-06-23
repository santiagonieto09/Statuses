import 'package:flutter_test/flutter_test.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/utils/date_formatter.dart';

void main() {
  final t = AppLocale.en.translations;

  group('DateFormatter.formatRelative', () {
    test('returns Today for current date', () {
      final now = DateTime.now();
      expect(DateFormatter.formatRelative(now, t), 'Today');
    });

    test('returns Yesterday for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(DateFormatter.formatRelative(yesterday, t), 'Yesterday');
    });

    test('returns days ago for recent dates', () {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      expect(DateFormatter.formatRelative(threeDaysAgo, t), '3 days ago');
    });
  });

  group('DateFormatter.formatTime', () {
    test('returns formatted time', () {
      final date = DateTime(2024, 1, 15, 14, 30);
      expect(DateFormatter.formatTime(date), '2:30 PM');
    });
  });

  group('DateFormatter.formatDateTime', () {
    test('returns combined date and time', () {
      final now = DateTime.now();
      final result = DateFormatter.formatDateTime(now, t);
      expect(result, contains('Today'));
      expect(result, contains('at'));
    });
  });
}
