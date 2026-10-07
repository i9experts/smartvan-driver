import 'package:intl/intl.dart';

/// "6 Oct 2026 — 01:05 PM" in the active locale (12-hour clock with the
/// hour padded, as the alert detail screen has always shown it).
String formatDateTimeLong(DateTime dateTime, String locale) =>
    DateFormat('d MMM yyyy — hh:mm a', locale).format(dateTime.toLocal());

/// "8:00 AM" — 12-hour clock, hour not padded, in the device's local time.
String formatTime12h(DateTime dateTime) {
  final local = dateTime.toLocal();
  final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour12:$minute ${local.hour < 12 ? 'AM' : 'PM'}';
}

/// "06/10/2026" (day/month/year, local time).
String formatDayMonthYear(DateTime dateTime) {
  final local = dateTime.toLocal();
  return '${local.day.toString().padLeft(2, '0')}/'
      '${local.month.toString().padLeft(2, '0')}/${local.year}';
}

/// Whole calendar days from [now] to [date] (negative once past).
int daysUntil(DateTime date, DateTime now) =>
    DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
