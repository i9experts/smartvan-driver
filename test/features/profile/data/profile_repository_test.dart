import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_document_type.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_report.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_type.dart';
import 'package:smartvan_driver/features/profile/data/profile_repository.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late ProfileRepository repo;

  setUp(() {
    env = ApiTestEnv();
    repo = ProfileRepository(env.client);
  });

  test('getProfile GETs /auth/getProfile and parses the driver', () async {
    env.adapter.onGet('/auth/getProfile',
        (s) => s.reply(200, fixture('profile/driver_profile.json')));
    final p = await repo.getProfile();
    expect(p.fullname, 'Test Driver');
    expect(p.nic, '00000-0000000-0');
    expect(p.expiryDateLicense, DateTime(2027, 3, 15));
  });

  test('getProfile also accepts an un-enveloped profile', () async {
    env.adapter.onGet(
        '/auth/getProfile',
        (s) =>
            s.reply(200, fixtureMap('profile/driver_profile_variants.json')));
    expect((await repo.getProfile()).fullname, 'Test Driver Two');
  });

  test('getProfile maps a server error', () async {
    env.adapter
        .onGet('/auth/getProfile', (s) => s.reply(500, {'message': 'db down'}));
    await expectLater(repo.getProfile(), throwsA(isA<ServerException>()));
  });

  group('updateProfile', () {
    test('sends NIC (upper-case), userType and, if given, image', () async {
      env.adapter.onPost(
        '/van/update-profile',
        (s) => s.reply(200, {'success': true}),
        data: {
          'fullname': 'Test Driver',
          'phoneNo': '0300-0000010',
          'alternatePhoneNo': '',
          'address': '10 Example Road',
          'NIC': '00000-0000000-0',
          'userType': 'driver',
          'image': 'https://example.test/img/new.png',
        },
      );
      await repo.updateProfile(
        fullname: 'Test Driver',
        phoneNo: '0300-0000010',
        alternatePhoneNo: '',
        address: '10 Example Road',
        nic: '00000-0000000-0',
        image: 'https://example.test/img/new.png',
      );
    });

    test('leaves image out when there is none', () async {
      env.adapter.onPost(
        '/van/update-profile',
        (s) => s.reply(200, {}),
        data: {
          'fullname': 'A',
          'phoneNo': '1',
          'alternatePhoneNo': '2',
          'address': '3',
          'NIC': '4',
          'userType': 'driver',
        },
      );
      await repo.updateProfile(
          fullname: 'A',
          phoneNo: '1',
          alternatePhoneNo: '2',
          address: '3',
          nic: '4');
    });

    test('a rejected update is an ApiError with the message', () async {
      env.adapter.onPost('/van/update-profile',
          (s) => s.reply(400, {'message': 'Phone number already in use'}),
          data: Matchers.any);
      await expectLater(
          repo.updateProfile(
              fullname: 'A',
              phoneNo: '1',
              alternatePhoneNo: '',
              address: '',
              nic: ''),
          throwsA(isA<ApiError>().having(
              (e) => e.userMessage, 'message', 'Phone number already in use')));
    });
  });

  group('uploadImage', () {
    late File file;
    setUp(() {
      file = File('${Directory.systemTemp.path}/smartvan_test_upload.png')
        ..writeAsBytesSync([137, 80, 78, 71]);
    });
    tearDown(() => file.deleteSync());

    test('POSTs multipart to /upload/image and returns the URL', () async {
      env.record();
      env.adapter.onPost('/upload/image',
          (s) => s.reply(201, {'url': 'https://example.test/img/up.png'}),
          data: Matchers.any);
      expect(await repo.uploadImage(file), 'https://example.test/img/up.png');
      expect(env.lastRequest!.path, '/upload/image');
      expect(env.lastRequest!.method, 'POST');
    });

    test('2xx without a url is an ApiError(UPLOAD_FAILED)', () async {
      env.adapter
          .onPost('/upload/image', (s) => s.reply(200, {}), data: Matchers.any);
      await expectLater(
          repo.uploadImage(file),
          throwsA(
              isA<ApiError>().having((e) => e.code, 'code', 'UPLOAD_FAILED')));
    });

    test('offline: NetworkException', () async {
      env.adapter.onPost(
          '/upload/image', (s) => s.throws(0, connectionError('/upload/image')),
          data: Matchers.any);
      await expectLater(
          repo.uploadImage(file), throwsA(isA<NetworkException>()));
    });
  });

  group('uploadDocument', () {
    test('vehicle card uses vehicleCardImageFront', () async {
      env.adapter.onPost(
        '/van/uploadDocuments',
        (s) => s.reply(200, {}),
        data: {
          'title': 'vehicle_card',
          'vehicleCardImageFront': 'https://example.test/d/1.png'
        },
      );
      await repo.uploadDocument(
          DriverDocumentType.vehicleCard, 'https://example.test/d/1.png');
    });

    test('driving licence uses licenceImageFront', () async {
      env.adapter.onPost(
        '/van/uploadDocuments',
        (s) => s.reply(200, {}),
        data: {
          'title': 'driving_license',
          'licenceImageFront': 'https://example.test/d/2.png'
        },
      );
      await repo.uploadDocument(
          DriverDocumentType.drivingLicense, 'https://example.test/d/2.png');
    });
  });

  group('uploadDocument with an expiry date', () {
    test('sends it as YYYY-MM-DD under the document\'s own key', () async {
      env.adapter.onPost(
        '/van/uploadDocuments',
        (s) => s.reply(200, {}),
        data: {
          'title': 'driving_license',
          'licenceImageFront': 'https://example.test/d/2.png',
          'expiryDateLicense': '2027-03-05',
        },
      );
      await repo.uploadDocument(
          DriverDocumentType.drivingLicense, 'https://example.test/d/2.png',
          expiry: DateTime(2027, 3, 5));
    });

    test('vehicle card uses expiryDateVehicleCard', () async {
      env.adapter.onPost(
        '/van/uploadDocuments',
        (s) => s.reply(200, {}),
        data: {
          'title': 'vehicle_card',
          'vehicleCardImageFront': 'https://example.test/d/1.png',
          'expiryDateVehicleCard': '2026-11-30',
        },
      );
      await repo.uploadDocument(
          DriverDocumentType.vehicleCard, 'https://example.test/d/1.png',
          expiry: DateTime(2026, 11, 30));
    });
  });

  group('removeDocument', () {
    test('POSTs the licence with both sides', () async {
      env.adapter.onPost(
        '/van/removeDocument',
        (s) => s.reply(200, {'success': true}),
        data: {'document': 'licence', 'side': 'both'},
      );
      await repo.removeDocument(DriverDocumentType.drivingLicense);
    });

    test('POSTs the vehicle card', () async {
      env.adapter.onPost(
        '/van/removeDocument',
        (s) => s.reply(200, {'success': true}),
        data: {'document': 'vehicleCard', 'side': 'both'},
      );
      await repo.removeDocument(DriverDocumentType.vehicleCard);
    });

    test('a rejected removal is an ApiError', () async {
      env.adapter.onPost(
        '/van/removeDocument',
        (s) => s.reply(404, {'success': false, 'message': 'Not found'}),
        data: Matchers.any,
      );
      await expectLater(repo.removeDocument(DriverDocumentType.vehicleCard),
          throwsA(isA<ApiError>()));
    });
  });

  test('submitReport POSTs the report body to /report/addReportByDriver',
      () async {
    env.adapter.onPost(
      '/report/addReportByDriver',
      (s) => s.reply(201, {'success': true}),
      data: {
        'issueType': 'Vehicle Issue',
        'description': 'Left mirror cracked',
        'type': 'driverReport',
        'image': 'https://example.test/img/r.png',
      },
    );
    await repo.submitReport(const IssueReport(
      issueType: IssueType.vehicleIssue,
      description: 'Left mirror cracked',
      image: 'https://example.test/img/r.png',
    ));
  });

  test('submitReport without an image omits the key', () async {
    env.adapter.onPost(
      '/report/addReportByDriver',
      (s) => s.reply(201, {}),
      data: {'issueType': 'Other', 'description': 'x', 'type': 'driverReport'},
    );
    await repo.submitReport(const IssueReport(description: 'x'));
  });
}
