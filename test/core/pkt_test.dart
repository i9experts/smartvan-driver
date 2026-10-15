import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smartvan_driver/core/formatting/pkt.dart';

void main() {
  setUpAll(() => initializeDateFormatting('en'));

  test('times are shown in PKT (UTC+5) whatever the phone zone is', () {
    expect(formatTimePkt(DateTime.utc(2026, 10, 15, 2, 5)), '7:05 AM');
    expect(formatTimePkt(DateTime.utc(2026, 10, 15, 7, 0)), '12:00 PM');
    expect(formatTimePkt(DateTime.utc(2026, 10, 15, 19, 30)), '12:30 AM');
    expect(formatDatePkt(DateTime.utc(2026, 10, 15, 2), 'en'), '15 Oct 2026');
  });

  test('a late-evening UTC trip belongs to the next PKT day', () {
    final t = DateTime.utc(2026, 10, 14, 20, 0); // 01:00 on the 15th in PKT
    expect(pktDay(t), DateTime.utc(2026, 10, 15));
    expect(pktDaysBetween(t, DateTime.utc(2026, 10, 15, 3)), 0);
    expect(
        pktDaysBetween(
            DateTime.utc(2026, 10, 14, 3), DateTime.utc(2026, 10, 15, 3)),
        1);
  });

  test('duration and distance', () {
    expect(durationParts(2466), (hours: 0, minutes: 41));
    expect(durationParts(3900), (hours: 1, minutes: 5));
    expect(durationParts(10), (hours: 0, minutes: 1));
    expect(durationParts(0), (hours: 0, minutes: 0));
    expect(kmText(11840), '11.8');
  });
}
