import 'package:intl/intl.dart';

class DateFormatter {
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateDay).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference <= 7) return '$difference days ago';

    final weekDifference = (difference / 7).floor();
    if (weekDifference <= 4) {
      return weekDifference == 1 ? '1 week ago' : '$weekDifference weeks ago';
    }

    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  static String formatDateTime(DateTime date) {
    return '${formatRelative(date)} at ${formatTime(date)}';
  }
}
