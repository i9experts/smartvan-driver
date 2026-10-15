import '../../../core/formatting/pkt.dart';
import '../data/models/completed_trip.dart';

/// One line of the History list.
sealed class HistoryRow {
  const HistoryRow();
}

/// A day heading (the PKT day, as a UTC midnight).
class HistoryHeaderRow extends HistoryRow {
  const HistoryHeaderRow(this.day);
  final DateTime day;
}

class HistoryTripRow extends HistoryRow {
  const HistoryTripRow(this.trip);
  final CompletedTrip trip;
}

/// [trips] (newest first) with a [HistoryHeaderRow] before each new PKT day.
/// A trip without any date joins the previous group.
List<HistoryRow> groupByDay(List<CompletedTrip> trips) {
  final rows = <HistoryRow>[];
  DateTime? day;
  for (final trip in trips) {
    final when = trip.when;
    if (when != null) {
      final d = pktDay(when);
      if (d != day) {
        rows.add(HistoryHeaderRow(d));
        day = d;
      }
    }
    rows.add(HistoryTripRow(trip));
  }
  return rows;
}
