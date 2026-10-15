import 'package:intl/intl.dart';

/// Pakistan Standard Time is UTC+5 all year (no daylight saving). History
/// screens show trip times in PKT whatever the phone's time zone is, because
/// the server decides which day a trip belongs to in PKT.
const pktOffset = Duration(hours: 5);

/// [time] as PKT wall-clock time (a UTC `DateTime` whose fields read as PKT).
DateTime toPkt(DateTime time) => time.toUtc().add(pktOffset);

/// The PKT calendar day of [time], as a UTC midnight (comparable with `==`).
DateTime pktDay(DateTime time) {
  final p = toPkt(time);
  return DateTime.utc(p.year, p.month, p.day);
}

/// Whole PKT calendar days from [from] to [to].
int pktDaysBetween(DateTime from, DateTime to) =>
    pktDay(to).difference(pktDay(from)).inDays;

/// "8:05 AM" in PKT.
String formatTimePkt(DateTime time) {
  final p = toPkt(time);
  final hour12 = p.hour % 12 == 0 ? 12 : p.hour % 12;
  final minute = p.minute.toString().padLeft(2, '0');
  return '$hour12:$minute ${p.hour < 12 ? 'AM' : 'PM'}';
}

/// "15 Oct 2026" in PKT, in the active [locale].
String formatDatePkt(DateTime time, String locale) =>
    DateFormat('d MMM yyyy', locale).format(toPkt(time));

/// "Thu, 15 Oct 2026" for a [pktDay] value, in the active [locale].
String formatPktDay(DateTime day, String locale) =>
    DateFormat('EEE, d MMM yyyy', locale).format(day);

/// "41 min", "1 h 5 min" — [seconds] rounded to whole minutes (at least 1).
({int hours, int minutes}) durationParts(int seconds) {
  final totalMinutes =
      seconds <= 0 ? 0 : (seconds / 60).round().clamp(1, 1 << 30);
  return (hours: totalMinutes ~/ 60, minutes: totalMinutes % 60);
}

/// Metres as kilometres with one decimal ("11.8").
String kmText(int meters) => (meters / 1000).toStringAsFixed(1);
