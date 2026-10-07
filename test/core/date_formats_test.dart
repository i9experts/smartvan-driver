import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smartvan_driver/core/formatting/date_formats.dart';

void main() {
  setUpAll(() => initializeDateFormatting('en'));

  test('afternoon times are 12-hour with PM', () {
    expect(formatDateTimeLong(DateTime(2026, 10, 6, 13, 5), 'en'), '6 Oct 2026 — 01:05 PM');
  });

  test('midnight is 12 AM, noon is 12 PM', () {
    expect(formatDateTimeLong(DateTime(2026, 1, 2, 0, 7), 'en'), '2 Jan 2026 — 12:07 AM');
    expect(formatDateTimeLong(DateTime(2026, 1, 2, 12, 0), 'en'), '2 Jan 2026 — 12:00 PM');
  });

  test('morning times', () {
    expect(formatDateTimeLong(DateTime(2026, 12, 31, 9, 30), 'en'), '31 Dec 2026 — 09:30 AM');
  });

  test('a UTC time is shown in local time', () {
    final utc = DateTime.utc(2026, 10, 6, 8, 0);
    final local = utc.toLocal();
    final expected = formatDateTimeLong(local, 'en');
    expect(formatDateTimeLong(utc, 'en'), expected);
  });
}
