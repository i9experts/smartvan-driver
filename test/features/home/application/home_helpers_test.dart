import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/formatting/date_formats.dart';
import 'package:smartvan_driver/features/home/application/doc_expiry.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_profile.dart';
import 'package:smartvan_driver/features/trip/application/start_window.dart';

void main() {
  group('isWithinStartWindow', () {
    // 08:00 local, whatever the machine's zone is.
    final start = DateTime(2026, 10, 6, 8, 0);
    DateTime at(int h, int m) => DateTime(2026, 10, 6, h, m);

    test('no scheduled time → always allowed', () {
      expect(isWithinStartWindow(null, at(3, 0)), isTrue);
    });
    test('closed before the start, open from it until an hour after', () {
      expect(isWithinStartWindow(start, at(7, 59)), isFalse);
      expect(isWithinStartWindow(start, at(8, 0)), isTrue);
      expect(isWithinStartWindow(start, at(9, 0)), isTrue);
      expect(isWithinStartWindow(start, at(9, 1)), isFalse);
    });
    test('only the clock time counts, not the date', () {
      final lastWeek = DateTime(2026, 9, 29, 8, 30);
      expect(isWithinStartWindow(lastWeek, at(8, 45)), isTrue);
    });
  });

  group('formatting', () {
    test('12-hour clock', () {
      expect(formatTime12h(DateTime(2026, 1, 1, 0, 5)), '12:05 AM');
      expect(formatTime12h(DateTime(2026, 1, 1, 8, 0)), '8:00 AM');
      expect(formatTime12h(DateTime(2026, 1, 1, 12, 30)), '12:30 PM');
      expect(formatTime12h(DateTime(2026, 1, 1, 23, 9)), '11:09 PM');
    });
    test('day/month/year', () {
      expect(formatDayMonthYear(DateTime(2026, 3, 7)), '07/03/2026');
    });
    test('daysUntil counts calendar days', () {
      final now = DateTime(2026, 10, 6, 23, 59);
      expect(daysUntil(DateTime(2026, 10, 6), now), 0);
      expect(daysUntil(DateTime(2026, 10, 7), now), 1);
      expect(daysUntil(DateTime(2026, 10, 5), now), -1);
    });
  });

  group('expiringDocuments', () {
    final now = DateTime(2026, 10, 6, 10);

    test('nothing without a profile or dates', () {
      expect(expiringDocuments(null, now), isEmpty);
      expect(expiringDocuments(const DriverProfile(), now), isEmpty);
    });
    test('only documents expiring within 30 days (or expired) are listed', () {
      final docs = expiringDocuments(
        DriverProfile(
          expiryDateLicense: DateTime(2026, 11, 5), // 30 days
          expiryDateVehicleCard: DateTime(2026, 11, 6), // 31 days
        ),
        now,
      );
      expect(docs.map((d) => d.document), [ExpiringDocument.licence]);
      expect(docs.single.days, 30);
    });
    test('expired and expiring-today are flagged', () {
      final docs = expiringDocuments(
        DriverProfile(
          expiryDateLicense: DateTime(2026, 10, 1),
          expiryDateVehicleCard: DateTime(2026, 10, 6),
        ),
        now,
      );
      expect(docs[0].expired, isTrue);
      expect(docs[1].days, 0);
      expect(docs[1].expired, isFalse);
    });
  });
}
