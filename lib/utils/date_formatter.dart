import 'package:intl/intl.dart';
import 'package:statuses/i18n/translations.g.dart';

class DateFormatter {
  static String formatRelative(DateTime date, Translations t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateDay).inDays;

    if (difference == 0) return t.date.today;
    if (difference == 1) return t.date.yesterday;
    if (difference <= 7) return t.date.days_ago(count: difference);

    final weekDifference = (difference / 7).floor();
    if (weekDifference <= 4) {
      return weekDifference == 1
          ? t.date.week_ago
          : t.date.weeks_ago(count: weekDifference);
    }

    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  static String formatDateTime(DateTime date, Translations t) {
    return '${formatRelative(date, t)} ${t.date.at} ${formatTime(date)}';
  }
}
