import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';

void main() {
  group('readValue helpers', () {
    test('id variants', () {
      expect(readId({'_id': 'a', 'id': 'b'}, ''), 'a');
      expect(readId({'id': 'b'}, ''), 'b');
      expect(readKidId({'kidId': 'k', '_id': 'a'}, ''), 'k');
      expect(readKidId({'_id': 'a'}, ''), 'a');
      expect(readKidId({'id': 'b'}, ''), 'b');
      expect(readKidId({}, ''), isNull);
    });

    test('name, image, lng', () {
      expect(readFullname({'name': 'N'}, ''), 'N');
      expect(readFullname({'fullname': 'F', 'name': 'N'}, ''), 'F');
      expect(readImage({'profileImage': 'p'}, ''), 'p');
      expect(readLng({'long': 3.0}, ''), 3.0);
      expect(readLng({'lng': 1.0, 'long': 3.0}, ''), 1.0);
    });

    test('type is lower-cased', () {
      expect(readTypeLower({'type': 'Drop'}, ''), 'drop');
      expect(readTypeLower({}, ''), isNull);
    });

    test('TripStarted and statuses', () {
      expect(readTripStarted({'TripStarted': true}, ''), true);
      expect(readTripStarted({'tripStarted': false}, ''), false);
      expect(readTripStatus({'tripStatus': 'PICKED'}, ''), 'picked');
      expect(readTripStatus({'status': 'Dropped'}, ''), 'dropped');
      expect(readTripStatus({}, ''), isNull);
    });

    test('nested variants', () {
      expect(
          readSchoolName({
            'school': {'schoolName': 'S'}
          }, ''),
          'S');
      expect(readSchoolName({'schoolName': 'T'}, ''), 'T');
      expect(
          readParentPhone({
            'parent': {'phoneNo': '1'}
          }, ''),
          '1');
      expect(readParentPhone({'parentPhone': '2'}, ''), '2');
      expect(readParentPhone({'phoneNo': '3'}, ''), '3');
      expect(readParentAlternatePhone({'alternatePhone': '4'}, ''), '4');
      expect(
          readParentAddress({
            'parent': {'address': 'A'}
          }, ''),
          'A');
      expect(
          readTripStartTime({
            'tripStart': {'startTime': 'x'}
          }, ''),
          'x');
      expect(readTripStartTime({'startTime': 'y'}, ''), 'y');
    });

    test('trip name falls through four keys', () {
      expect(readTripName({'schoolRoute': 'R'}, ''), 'R');
      expect(readTripName({'route': 'Q', 'name': 'N'}, ''), 'N');
    });

    test('licence / license spelling', () {
      expect(readLicenceFront({'licenseImageFront': 'u'}, ''), 'u');
      expect(readLicenceBack({'licenceImageBack': 'v'}, ''), 'v');
      expect(readLicenceExpiry({'expiryDateLicence': 'd'}, ''), 'd');
    });

    test('alert variants', () {
      expect(readAlertType({'type': 'SOS'}, ''), 'sos');
      expect(readAlertType({'alertType': 'trip', 'type': 'x'}, ''), 'trip');
      expect(readAlertMessage({'body': 'b'}, ''), 'b');
      expect(readAlertDate({'date': 'd'}, ''), 'd');
    });
  });

  group('converters', () {
    test('looseInt', () {
      expect(looseInt(5), 5);
      expect(looseInt(5.9), 5);
      expect(looseInt(' 12 '), 12);
      expect(looseInt('7.0'), 7);
      expect(looseInt('x'), isNull);
      expect(looseInt(null), isNull);
    });

    test('looseDouble', () {
      expect(looseDouble(5), 5.0);
      expect(looseDouble('2.5'), 2.5);
      expect(looseDouble('x'), isNull);
    });

    test('looseBool', () {
      expect(looseBool(true), isTrue);
      expect(looseBool('true'), isTrue);
      expect(looseBool(1), isTrue);
      expect(looseBool('no'), isFalse);
      expect(looseBool(null), isFalse);
    });

    test('looseString', () {
      expect(looseString(12), '12');
      expect(looseString('  '), isNull);
      expect(looseString({'a': 1}), isNull);
      expect(looseStringOrEmpty(null), '');
    });

    test('dates', () {
      expect(looseDateTime('2026-10-06T08:30:00.000Z'),
          DateTime.utc(2026, 10, 6, 8, 30));
      expect(looseDateTime('nope'), isNull);
      expect(looseDate('2026-10-06'), DateTime(2026, 10, 6));
      expect(looseDate('06/10/2026'), DateTime(2026, 10, 6));
      expect(looseDate('6-1-2027'), DateTime(2027, 1, 6));
      expect(looseDate(''), isNull);
      expect(looseDate(5), isNull);
    });
  });
}
