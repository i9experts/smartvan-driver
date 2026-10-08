import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/auth/data/auth_repository.dart';
import 'package:smartvan_driver/features/profile/application/change_password_controller.dart';
import 'package:smartvan_driver/features/profile/application/documents_controller.dart';
import 'package:smartvan_driver/features/profile/application/driver_profile_provider.dart';
import 'package:smartvan_driver/features/profile/application/edit_profile_controller.dart';
import 'package:smartvan_driver/features/profile/application/report_issue_controller.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_document_type.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_profile.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_report.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_type.dart';
import 'package:smartvan_driver/features/profile/data/profile_repository.dart';

import '../../../support/fake_files.dart';

class _FakeProfileRepo extends Mock implements ProfileRepository {}

class _FakeAuthRepo extends Mock implements AuthRepository {}

void main() {
  late _FakeProfileRepo profileRepo;
  late _FakeAuthRepo authRepo;
  late ProviderContainer container;
  late File image;

  setUpAll(() {
    registerFallbackValue(DriverDocumentType.vehicleCard);
    registerFallbackValue(const IssueReport());
    registerFallbackValue(File('x'));
  });

  setUp(() {
    profileRepo = _FakeProfileRepo();
    authRepo = _FakeAuthRepo();
    image = tempImage();
    container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(profileRepo),
      authRepositoryProvider.overrideWithValue(authRepo),
    ]);
    addTearDown(container.dispose);
    addTearDown(() => image.existsSync() ? image.deleteSync() : null);
  });

  group('driverProfileProvider', () {
    test('loads once and is cached until invalidated', () async {
      var calls = 0;
      when(() => profileRepo.getProfile()).thenAnswer((_) async {
        calls++;
        return DriverProfile(fullname: 'Test Driver $calls');
      });
      expect((await container.read(driverProfileProvider.future)).fullname,
          'Test Driver 1');
      expect((await container.read(driverProfileProvider.future)).fullname,
          'Test Driver 1');
      expect(calls, 1);
      container.invalidate(driverProfileProvider);
      expect((await container.read(driverProfileProvider.future)).fullname,
          'Test Driver 2');
    });

    test('a failure surfaces as an error state', () async {
      when(() => profileRepo.getProfile()).thenThrow(const NetworkException());
      await expectLater(container.read(driverProfileProvider.future),
          throwsA(isA<NetworkException>()));
    });
  });

  group('EditProfileController', () {
    void stubUpdate() => when(() => profileRepo.updateProfile(
          fullname: any(named: 'fullname'),
          phoneNo: any(named: 'phoneNo'),
          alternatePhoneNo: any(named: 'alternatePhoneNo'),
          address: any(named: 'address'),
          nic: any(named: 'nic'),
          image: any(named: 'image'),
        )).thenAnswer((_) async {});

    test(
        'without a new image: updates the profile and refreshes the shared copy',
        () async {
      stubUpdate();
      when(() => profileRepo.getProfile())
          .thenAnswer((_) async => const DriverProfile(fullname: 'A'));
      await container.read(driverProfileProvider.future);
      clearInteractions(profileRepo);
      when(() => profileRepo.getProfile())
          .thenAnswer((_) async => const DriverProfile(fullname: 'B'));

      final ok = await container
          .read(editProfileControllerProvider.notifier)
          .save(
              fullname: 'B',
              phoneNo: '1',
              alternatePhoneNo: '2',
              address: '3',
              nic: '4');
      expect(ok, isTrue);
      verifyNever(() => profileRepo.uploadImage(any()));
      verify(() => profileRepo.updateProfile(
          fullname: 'B',
          phoneNo: '1',
          alternatePhoneNo: '2',
          address: '3',
          nic: '4',
          image: null)).called(1);
      expect(
          (await container.read(driverProfileProvider.future)).fullname, 'B');
    });

    test('with a new image: uploads first and sends the URL', () async {
      stubUpdate();
      when(() => profileRepo.uploadImage(image))
          .thenAnswer((_) async => 'https://example.test/i.png');
      final ok = await container
          .read(editProfileControllerProvider.notifier)
          .save(
              fullname: 'A',
              phoneNo: '1',
              alternatePhoneNo: '',
              address: '',
              nic: '',
              newImage: image);
      expect(ok, isTrue);
      verify(() => profileRepo.updateProfile(
          fullname: 'A',
          phoneNo: '1',
          alternatePhoneNo: '',
          address: '',
          nic: '',
          image: 'https://example.test/i.png')).called(1);
    });

    test('a failed upload stops the save', () async {
      when(() => profileRepo.uploadImage(any()))
          .thenThrow(const ApiError(code: 'UPLOAD_FAILED', status: 200));
      final ok = await container
          .read(editProfileControllerProvider.notifier)
          .save(
              fullname: 'A',
              phoneNo: '1',
              alternatePhoneNo: '',
              address: '',
              nic: '',
              newImage: image);
      expect(ok, isFalse);
      expect(
          (container.read(editProfileControllerProvider).error as ApiError)
              .code,
          'UPLOAD_FAILED');
      verifyNever(() => profileRepo.updateProfile(
          fullname: any(named: 'fullname'),
          phoneNo: any(named: 'phoneNo'),
          alternatePhoneNo: any(named: 'alternatePhoneNo'),
          address: any(named: 'address'),
          nic: any(named: 'nic'),
          image: any(named: 'image')));
    });

    test('a rejected update is an error state', () async {
      when(() => profileRepo.updateProfile(
          fullname: any(named: 'fullname'),
          phoneNo: any(named: 'phoneNo'),
          alternatePhoneNo: any(named: 'alternatePhoneNo'),
          address: any(named: 'address'),
          nic: any(named: 'nic'),
          image: any(named: 'image'))).thenThrow(const ApiError(status: 400));
      expect(
          await container.read(editProfileControllerProvider.notifier).save(
              fullname: 'A',
              phoneNo: '1',
              alternatePhoneNo: '',
              address: '',
              nic: ''),
          isFalse);
    });
  });

  group('DocumentsController', () {
    setUp(() {
      when(() => profileRepo.getProfile())
          .thenAnswer((_) async => const DriverProfile());
    });

    test(
        'uploads the image, attaches it with the expiry and refreshes the profile',
        () async {
      when(() => profileRepo.uploadImage(image))
          .thenAnswer((_) async => 'https://example.test/d.png');
      when(() => profileRepo.uploadDocument(any(), any(),
          expiry: any(named: 'expiry'))).thenAnswer((_) async {});
      await container.read(driverProfileProvider.future);
      clearInteractions(profileRepo);
      when(() => profileRepo.getProfile())
          .thenAnswer((_) async => const DriverProfile());

      final error = await container
          .read(documentsControllerProvider.notifier)
          .upload(DriverDocumentType.drivingLicense, image,
              expiry: DateTime(2027, 3, 5));
      expect(error, isNull);
      verify(() => profileRepo.uploadDocument(
          DriverDocumentType.drivingLicense, 'https://example.test/d.png',
          expiry: DateTime(2027, 3, 5))).called(1);
      await container.read(driverProfileProvider.future);
      verify(() => profileRepo.getProfile()).called(1);
    });

    test('without an expiry none is sent', () async {
      when(() => profileRepo.uploadImage(image))
          .thenAnswer((_) async => 'https://example.test/d.png');
      when(() => profileRepo.uploadDocument(any(), any(),
          expiry: any(named: 'expiry'))).thenAnswer((_) async {});
      await container
          .read(documentsControllerProvider.notifier)
          .upload(DriverDocumentType.vehicleCard, image);
      verify(() => profileRepo.uploadDocument(
              DriverDocumentType.vehicleCard, 'https://example.test/d.png'))
          .called(1);
    });

    test('state names the document being worked on, then goes idle', () async {
      when(() => profileRepo.uploadImage(image))
          .thenAnswer((_) async => 'https://example.test/d.png');
      when(() => profileRepo.uploadDocument(any(), any(),
          expiry: any(named: 'expiry'))).thenAnswer((_) async {});
      final seen = <DriverDocumentType?>[];
      container.listen(documentsControllerProvider, (_, v) => seen.add(v));
      await container
          .read(documentsControllerProvider.notifier)
          .upload(DriverDocumentType.vehicleCard, image);
      expect(seen, [DriverDocumentType.vehicleCard, null]);
    });

    test('a failed upload never attaches a document or refreshes', () async {
      when(() => profileRepo.uploadImage(any()))
          .thenThrow(const NetworkException());
      await container.read(driverProfileProvider.future);
      clearInteractions(profileRepo);
      final error = await container
          .read(documentsControllerProvider.notifier)
          .upload(DriverDocumentType.vehicleCard, image);
      expect(error, isA<NetworkException>());
      verifyNever(() => profileRepo.uploadDocument(any(), any(),
          expiry: any(named: 'expiry')));
      verifyNever(() => profileRepo.getProfile());
      expect(container.read(documentsControllerProvider), isNull);
    });

    test('a rejected attach is an error and the profile is left alone',
        () async {
      when(() => profileRepo.uploadImage(any()))
          .thenAnswer((_) async => 'https://example.test/d.png');
      when(() => profileRepo.uploadDocument(any(), any(),
              expiry: any(named: 'expiry')))
          .thenThrow(const ApiError(status: 400, message: 'bad'));
      await container.read(driverProfileProvider.future);
      clearInteractions(profileRepo);
      final error = await container
          .read(documentsControllerProvider.notifier)
          .upload(DriverDocumentType.vehicleCard, image);
      expect(error, isA<ApiError>());
      verifyNever(() => profileRepo.getProfile());
    });

    test('remove calls the repository and refreshes the profile', () async {
      when(() => profileRepo.removeDocument(any())).thenAnswer((_) async {});
      await container.read(driverProfileProvider.future);
      clearInteractions(profileRepo);
      when(() => profileRepo.getProfile())
          .thenAnswer((_) async => const DriverProfile());
      final error = await container
          .read(documentsControllerProvider.notifier)
          .remove(DriverDocumentType.drivingLicense);
      expect(error, isNull);
      verify(() =>
              profileRepo.removeDocument(DriverDocumentType.drivingLicense))
          .called(1);
      await container.read(driverProfileProvider.future);
      verify(() => profileRepo.getProfile()).called(1);
    });

    test('a failed remove returns the error and keeps the profile', () async {
      when(() => profileRepo.removeDocument(any()))
          .thenThrow(const NetworkException());
      await container.read(driverProfileProvider.future);
      clearInteractions(profileRepo);
      final error = await container
          .read(documentsControllerProvider.notifier)
          .remove(DriverDocumentType.vehicleCard);
      expect(error, isA<NetworkException>());
      verifyNever(() => profileRepo.getProfile());
      expect(container.read(documentsControllerProvider), isNull);
    });
  });

  group('ChangePasswordController', () {
    test('success', () async {
      when(() => authRepo.changePassword(
          oldPassword: 'old',
          newPassword: 'new-secret')).thenAnswer((_) async {});
      expect(
          await container
              .read(changePasswordControllerProvider.notifier)
              .change(oldPassword: 'old', newPassword: 'new-secret'),
          isTrue);
    });

    test('the server message is kept in the error state', () async {
      when(() =>
          authRepo.changePassword(
              oldPassword: any(named: 'oldPassword'),
              newPassword: any(named: 'newPassword'))).thenThrow(
          const ApiError(status: 400, message: 'Old password is incorrect'));
      final ok = await container
          .read(changePasswordControllerProvider.notifier)
          .change(oldPassword: 'x', newPassword: 'y');
      expect(ok, isFalse);
      expect(
          (container.read(changePasswordControllerProvider).error
                  as AppException)
              .userMessage,
          'Old password is incorrect');
    });
  });

  group('ReportIssueController', () {
    test('without a photo: sends a trimmed report', () async {
      when(() => profileRepo.submitReport(any())).thenAnswer((_) async {});
      final ok = await container
          .read(reportIssueControllerProvider.notifier)
          .submit(issueType: IssueType.runningLate, description: '  Traffic  ');
      expect(ok, isTrue);
      final sent = verify(() => profileRepo.submitReport(captureAny()))
          .captured
          .single as IssueReport;
      expect(sent.issueType, IssueType.runningLate);
      expect(sent.description, 'Traffic');
      expect(sent.image, isNull);
      verifyNever(() => profileRepo.uploadImage(any()));
    });

    test('with a photo: uploads first and sends the URL', () async {
      when(() => profileRepo.uploadImage(image))
          .thenAnswer((_) async => 'https://example.test/r.png');
      when(() => profileRepo.submitReport(any())).thenAnswer((_) async {});
      await container.read(reportIssueControllerProvider.notifier).submit(
          issueType: IssueType.emergency, description: 'x', photo: image);
      final sent = verify(() => profileRepo.submitReport(captureAny()))
          .captured
          .single as IssueReport;
      expect(sent.image, 'https://example.test/r.png');
    });

    test('a failed photo upload never sends the report', () async {
      when(() => profileRepo.uploadImage(any()))
          .thenThrow(const ApiError(code: 'UPLOAD_FAILED', status: 200));
      final ok = await container
          .read(reportIssueControllerProvider.notifier)
          .submit(issueType: IssueType.other, description: 'x', photo: image);
      expect(ok, isFalse);
      verifyNever(() => profileRepo.submitReport(any()));
    });
  });
}
