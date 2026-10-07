import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/passengers/data/models/absence.dart';
import 'package:smartvan_driver/features/passengers/data/models/arrived_at_stop.dart';
import 'package:smartvan_driver/features/passengers/data/models/kid_absence_event.dart';
import 'package:smartvan_driver/features/passengers/data/models/kid_trip_status.dart';
import 'package:smartvan_driver/features/passengers/data/models/passenger.dart';
import 'package:smartvan_driver/features/passengers/data/models/scan_result.dart';

import '../../../../support/fixture.dart';

void main() {
  group('Passenger', () {
    final list = asJsonList(
            unwrapData(fixture('passengers/merged_active_passengers.json')))
        .map(Passenger.fromJson)
        .toList();

    test('nested shape: tripStatus, school{}, parent{}', () {
      final p = list[0];
      expect(p.id, 'kid-001');
      expect(p.fullname, 'Test Kid One');
      expect(p.image, 'https://example.test/img/1.png');
      expect(p.tripStatus, KidTripStatus.picked); // "PICKED"
      expect(p.isPicked, isTrue);
      expect(p.isDropped, isFalse);
      expect(p.tripId, 'trip-001');
      expect(p.grade, '3');
      expect(p.schoolName, 'Sample School');
      expect(p.distance, '1.2 km');
      expect(p.parent.phoneNo, '0300-0000001');
      expect(p.parent.alternatePhoneNo, '0300-0000002');
      expect(p.parent.address, '1 Example Street, Test City');
      expect(p.absent, isFalse);
      expect(p.absenceNote, isNull);
      expect(p.waitingSince, isNull);
      expect(p.noShow, isFalse);
    });

    test('flat shape: _id, name, profileImage, status, parentPhone, numbers',
        () {
      final p = list[1];
      expect(p.id, 'kid-002');
      expect(p.fullname, 'Test Kid Two');
      expect(p.image, 'https://example.test/img/2.png');
      expect(p.tripStatus, KidTripStatus.pending); // `status`
      expect(p.schoolName, 'Sample School');
      expect(p.grade, '4'); // number
      expect(p.distance, '2.5'); // number
      expect(p.parent.phoneNo, '0300-0000003');
      expect(p.parent.alternatePhoneNo, '0300-0000004');
      expect(p.parent.address, '2 Example Street, Test City');
    });

    test('Phase 4 fields: absent, absenceNote, waitingSince, noShow', () {
      final p = list[1];
      expect(p.absent, isTrue);
      expect(p.absenceNote, 'Fever, back on Monday');
      expect(p.waitingSince, DateTime.utc(2026, 10, 6, 8, 12));
      expect(p.noShow, isTrue);
    });

    test('sparse kid: id, phoneNo fallback, defaults', () {
      final p = list[2];
      expect(p.id, 'kid-003');
      expect(p.tripStatus, KidTripStatus.pending); // missing = pending
      expect(p.parent.phoneNo, '0300-0000005'); // bare phoneNo
      expect(p.parent.alternatePhoneNo, isNull);
      expect(p.absent, isFalse);
      expect(p.noShow, isFalse);
      expect(p.image, isNull);
    });

    test('unknown status value', () {
      expect(list[3].tripStatus, KidTripStatus.unknown);
    });
  });

  group('Absence', () {
    final list =
        asJsonList(unwrapData(fixture('passengers/absences_today.json')))
            .map(Absence.fromJson)
            .toList();

    test('full absence', () {
      final a = list[0];
      expect(a.absenceId, 'abs-001');
      expect(a.kidId, 'kid-002');
      expect(a.date, DateTime(2026, 10, 6));
      expect(a.tripType, AbsenceTripType.both);
      expect(a.note, 'Fever, back on Monday');
      expect(a.createdAt, DateTime.utc(2026, 10, 5, 17, 30));
    });

    test('optional fields missing', () {
      expect(list[1].tripType, AbsenceTripType.drop);
      expect(list[1].note, isNull);
      expect(list[1].createdAt, isNull);
    });

    test('unknown tripType and blank note', () {
      expect(list[2].tripType, AbsenceTripType.unknown);
      expect(list[2].note, isNull);
    });
  });

  test('KidAbsenceEvent', () {
    final events = fixtureMap('passengers/kid_absence_events.json');
    final added = KidAbsenceEvent.fromJson(
        Map<String, dynamic>.from(events['kidAbsence'] as Map));
    expect(added.kidId, 'kid-002');
    expect(added.fullname, 'Test Kid Two');
    expect(added.date, DateTime(2026, 10, 6));
    expect(added.tripType, AbsenceTripType.pick);
    expect(added.cancelled, isFalse);

    final cancelled = KidAbsenceEvent.fromJson(
        Map<String, dynamic>.from(events['kidAbsenceCancelled'] as Map));
    expect(cancelled.cancelled, isTrue);
    expect(cancelled.tripType, AbsenceTripType.both);
  });

  group('ScanResult and ArrivedAtStop', () {
    final f = fixtureMap('passengers/scan_and_stop.json');
    Map<String, dynamic> data(String key) => asJsonMap(unwrapData(f[key]));

    test('picked and dropped', () {
      final picked = ScanResult.fromJson(data('scanPicked'));
      expect(picked.action, ScanAction.picked);
      expect(picked.kidId, 'kid-001');
      expect(picked.fullname, 'Test Kid One');
      expect(
          ScanResult.fromJson(data('scanDropped')).action, ScanAction.dropped);
    });

    test('unknown action, missing name', () {
      final odd = ScanResult.fromJson(data('scanOdd'));
      expect(odd.action, ScanAction.unknown);
      expect(odd.fullname, '');
    });

    test('arrived at stop', () {
      final a = ArrivedAtStop.fromJson(data('arrived'));
      expect(a.kidId, 'kid-002');
      expect(a.waitingSince, DateTime.utc(2026, 10, 6, 8, 12));
    });
  });
}
