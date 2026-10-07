import 'package:intl/intl.dart';

/// "6 Oct 2026 — 01:05 PM" in the active locale (12-hour clock with the
/// hour padded, as the alert detail screen has always shown it).
String formatDateTimeLong(DateTime dateTime, String locale) =>
    DateFormat('d MMM yyyy — hh:mm a', locale).format(dateTime.toLocal());
