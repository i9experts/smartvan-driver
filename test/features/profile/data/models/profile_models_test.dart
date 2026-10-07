import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_profile.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_report.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_type.dart';

import '../../../../support/fixture.dart';

void main() {
  group('DriverProfile', () {
    test('full profile with documents and expiry dates', () {
      final p = DriverProfile.fromJson(
          asJsonMap(unwrapData(fixture('profile/driver_profile.json'))));
      expect(p.id, '65f000000000000000000c01');
      expect(p.fullname, 'Test Driver');
      expect(p.email, 'test.driver@example.test');
      expect(p.phoneNo, '0300-0000010');
      expect(p.alternatePhoneNo, '0300-0000011');
      expect(p.address, '10 Example Road, Test City');
      expect(p.nic, '00000-0000000-0'); // upper-case NIC key
      expect(p.image, 'https://example.test/img/driver.png');
      expect(p.vanModel, 'Sample Hiace');
      expect(p.plateNumber, 'TST-1234');
      expect(p.seats, 14);
      expect(p.licenceImageFront, 'https://example.test/doc/licence-front.png');
      expect(p.licenceImageBack, 'https://example.test/doc/licence-back.png');
      expect(
          p.vehicleCardImageFront, 'https://example.test/doc/card-front.png');
      expect(p.vehicleCardImageBack, isNull); // "" counts as no document
      expect(p.expiryDateLicense, DateTime(2027, 3, 15));
      expect(p.expiryDateVehicleCard, DateTime.utc(2026, 11, 30));
    });

    test('absorbs id/name, license spelling, string seats, DD/MM/YYYY', () {
      final p = DriverProfile.fromJson(
          fixtureMap('profile/driver_profile_variants.json'));
      expect(p.id, 'driver-2'); // `id`
      expect(p.fullname, 'Test Driver Two'); // `name`
      expect(p.seats, 12); // "12"
      expect(
          p.licenceImageFront, 'https://example.test/doc/licence-front-2.png');
      expect(p.licenceImageBack, 'https://example.test/doc/licence-back-2.png');
      expect(p.expiryDateLicense, DateTime(2027, 3, 15)); // "15/03/2027"
      expect(p.expiryDateVehicleCard, isNull); // unparsable
    });

    test('sparse profile gets safe defaults', () {
      final p = DriverProfile.fromJson(
          fixtureMap('profile/driver_profile_sparse.json'));
      expect(p.fullname, 'Test Driver Three');
      expect(p.seats, isNull); // "n/a"
      expect(p.phoneNo, '3000000012'); // number-as-phone becomes a string
      expect(p.email, isNull);
      expect(p.expiryDateLicense, isNull);
    });

    test('empty object does not throw', () {
      final p = DriverProfile.fromJson({});
      expect(p.fullname, '');
      expect(p.id, isNull);
    });
  });

  group('IssueReport', () {
    test('serialises the display label, type and optional image', () {
      const r = IssueReport(
          issueType: IssueType.runningLate,
          description: 'Traffic on the bridge');
      expect(r.toJson(), {
        'issueType': 'Running Late',
        'description': 'Traffic on the bridge',
        'type': 'driverReport',
      });
      expect(
          r.copyWith(image: 'https://example.test/img/r.png').toJson()['image'],
          'https://example.test/img/r.png');
    });

    test('all six labels round-trip; unknown label maps to unknown', () {
      for (final t in IssueType.values.where((t) => t != IssueType.unknown)) {
        final json = IssueReport(issueType: t).toJson();
        expect(IssueReport.fromJson(json).issueType, t);
      }
      expect(IssueReport.fromJson({'issueType': 'Flat tyre'}).issueType,
          IssueType.unknown);
    });
  });
}
