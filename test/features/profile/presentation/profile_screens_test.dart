import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/providers/image_picker_provider.dart';
import 'package:smartvan_driver/features/auth/data/auth_repository.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_document_type.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_profile.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_report.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_type.dart';
import 'package:smartvan_driver/features/profile/data/profile_repository.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/change_password_screen.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/documents_screen.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/profile_screen.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/report_issue_screen.dart';

import '../../../support/fake_files.dart';
import '../../../support/fixture.dart';
import '../../../support/l10n_host.dart';

class _FakeProfileRepo extends Mock implements ProfileRepository {}

class _FakeAuthRepo extends Mock implements AuthRepository {}

class _FakePicker extends Mock implements ImagePicker {}

/// Pumps [widget] on a tall surface so nothing needs scrolling into view.
Future<void> pumpScreen(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(800, 3200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(widget);
}

void main() {
  late _FakeProfileRepo repo;
  late _FakeAuthRepo authRepo;
  late _FakePicker picker;
  late DriverProfile profile;

  setUpAll(() {
    registerFallbackValue(ImageSource.gallery);
    registerFallbackValue(File('x'));
    registerFallbackValue(DriverDocumentType.vehicleCard);
    registerFallbackValue(const IssueReport());
  });

  setUp(() {
    repo = _FakeProfileRepo();
    authRepo = _FakeAuthRepo();
    picker = _FakePicker();
    // No avatar URL: tests have no network and Image.network would fail.
    profile = DriverProfile.fromJson(Map<String, dynamic>.from(
            (fixtureMap('profile/driver_profile.json'))['data'] as Map))
        .copyWith(image: null);
    when(() => repo.getProfile()).thenAnswer((_) async => profile);
  });

  List<Override> overrides() => [
        profileRepositoryProvider.overrideWithValue(repo),
        authRepositoryProvider.overrideWithValue(authRepo),
        imagePickerProvider.overrideWithValue(picker),
      ];

  Widget screen(Widget child, {String path = '/x'}) => routerHost(
        {
          path: (_) => child,
          '/profile': (_) => const Text('profile-stub'),
          '/edit-profile': (_) => const Text('edit-stub'),
          '/documents': (_) => const Text('documents-stub'),
          '/change-password': (_) => const Text('password-stub'),
          '/report-issue': (_) => const Text('report-stub'),
          '/stats': (_) => const Text('stats-stub'),
          '/fee-collection': (_) => const Text('fees-stub'),
        },
        initial: path,
        overrides: overrides(),
      );

  group('ProfileScreen', () {
    testWidgets('shows the driver and vehicle details', (tester) async {
      await pumpScreen(tester, screen(const ProfileScreen()));
      await tester.pumpAndSettle();
      for (final t in [
        'Test Driver',
        'My Profile',
        'Full Name',
        'test.driver@example.test',
        '0300-0000010',
        'Alternate Phone',
        '0300-0000011',
        'CNIC',
        '00000-0000000-0',
        '10 Example Road, Test City',
        'Vehicle Details',
        'Sample Hiace',
        'TST-1234',
        '14',
        'Quick Actions',
        'My Driving Stats',
        'Fee Collection',
        'My Documents',
        'Change Password',
        'Report an Issue',
        'Logout',
      ]) {
        expect(find.text(t), findsWidgets, reason: t);
      }
    });

    testWidgets('a failed load shows the snackbar and placeholders',
        (tester) async {
      when(() => repo.getProfile())
          .thenAnswer((_) async => throw const NetworkException());
      await pumpScreen(tester, screen(const ProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Failed to load profile'), findsOneWidget);
      expect(find.text('Driver'), findsWidgets); // name fallback + badge
      expect(find.text('—'), findsWidgets);
    });

    testWidgets('the quick actions navigate', (tester) async {
      await pumpScreen(tester, screen(const ProfileScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My Documents'));
      await tester.pumpAndSettle();
      expect(find.text('documents-stub'), findsOneWidget);
    });

    testWidgets('Logout asks for confirmation', (tester) async {
      await pumpScreen(tester, screen(const ProfileScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Are you sure you want to logout?'), findsNothing);
    });
  });

  group('EditProfileScreen', () {
    testWidgets('fills the fields from the profile', (tester) async {
      await pumpScreen(tester, screen(const EditProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Edit Profile'), findsOneWidget);
      final fields =
          tester.widgetList<TextFormField>(find.byType(TextFormField)).toList();
      expect(fields.map((f) => f.controller!.text), [
        'Test Driver',
        '0300-0000010',
        '0300-0000011',
        '10 Example Road, Test City',
        '00000-0000000-0',
      ]);
    });

    testWidgets('Update Profile saves the edited values and goes back',
        (tester) async {
      when(() => repo.updateProfile(
            fullname: any(named: 'fullname'),
            phoneNo: any(named: 'phoneNo'),
            alternatePhoneNo: any(named: 'alternatePhoneNo'),
            address: any(named: 'address'),
            nic: any(named: 'nic'),
            image: any(named: 'image'),
          )).thenAnswer((_) async {});
      await pumpScreen(tester, screen(const EditProfileScreen()));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextFormField).first, 'Renamed Driver');
      await tester.tap(find.text('Update Profile'));
      await tester.pumpAndSettle();
      verify(() => repo.updateProfile(
          fullname: 'Renamed Driver',
          phoneNo: '0300-0000010',
          alternatePhoneNo: '0300-0000011',
          address: '10 Example Road, Test City',
          nic: '00000-0000000-0',
          image: null)).called(1);
      expect(find.text('profile-stub'), findsOneWidget);
      // The shared profile was refreshed after the save.
      verify(() => repo.getProfile()).called(2);
    });

    testWidgets('a failed save shows the message and stays', (tester) async {
      when(() => repo.updateProfile(
                fullname: any(named: 'fullname'),
                phoneNo: any(named: 'phoneNo'),
                alternatePhoneNo: any(named: 'alternatePhoneNo'),
                address: any(named: 'address'),
                nic: any(named: 'nic'),
                image: any(named: 'image'),
              ))
          .thenThrow(
              const ApiError(status: 400, message: 'Phone already in use'));
      await pumpScreen(tester, screen(const EditProfileScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Update Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Failed to update profile'), findsOneWidget);
      expect(find.text('profile-stub'), findsNothing);
    });

    testWidgets(
        'when the profile cannot load, editing is blocked until Retry works',
        (tester) async {
      var fail = true;
      when(() => repo.getProfile()).thenAnswer((_) async {
        if (fail) throw const NetworkException();
        return profile;
      });
      await pumpScreen(tester, screen(const EditProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Couldn\'t Load Your Profile'), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
      fail = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.byType(TextFormField), findsNWidgets(5));
    });
  });

  group('DocumentsScreen', () {
    testWidgets('shows both cards, the uploaded badge and the generic button',
        (tester) async {
      profile = const DriverProfile();
      await pumpScreen(tester, screen(const DocumentsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('No Documents'), findsOneWidget);
      expect(find.text('Vehicle Registration Certificate'), findsOneWidget);
      expect(find.text('Driving License'), findsOneWidget);
      expect(find.text('Upload New Document'), findsOneWidget);
      expect(find.text('Upload'), findsNWidgets(2));
    });

    testWidgets('a driver with a licence sees the Uploaded badge',
        (tester) async {
      await pumpScreen(tester, screen(const DocumentsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Uploaded'), findsWidgets);
      expect(find.text('No Documents'), findsNothing);
    });

    testWidgets('generic upload: asks which document, uploads it, confirms',
        (tester) async {
      profile = const DriverProfile();
      final file = tempImage('smartvan_doc_test.png');
      addTearDown(file.deleteSync);
      when(() => picker.pickImage(
              source: any(named: 'source'),
              imageQuality: any(named: 'imageQuality')))
          .thenAnswer((_) async => XFile(file.path));
      when(() => repo.uploadImage(any()))
          .thenAnswer((_) async => 'https://example.test/d.png');
      when(() => repo.uploadDocument(any(), any())).thenAnswer((_) async {});

      await pumpScreen(tester, screen(const DocumentsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Upload New Document'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Driving License').last);
      await tester.pumpAndSettle();
      verify(() => repo.uploadDocument(
              DriverDocumentType.drivingLicense, 'https://example.test/d.png'))
          .called(1);
      expect(
          find.text('Driving License uploaded successfully!'), findsOneWidget);
    });

    testWidgets('dismissing the type sheet uploads nothing', (tester) async {
      profile = const DriverProfile();
      await pumpScreen(tester, screen(const DocumentsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Upload New Document'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10)); // barrier
      await tester.pumpAndSettle();
      verifyNever(() => picker.pickImage(
          source: any(named: 'source'),
          imageQuality: any(named: 'imageQuality')));
    });
  });

  group('ChangePasswordScreen', () {
    Future<void> fill(WidgetTester t, String a, String b, String c) async {
      final f = find.byType(TextFormField);
      await t.enterText(f.at(0), a);
      await t.enterText(f.at(1), b);
      await t.enterText(f.at(2), c);
      await t.tap(find.text('Update Password'));
      await t.pump();
    }

    testWidgets('validates empty, mismatching and short passwords',
        (tester) async {
      await pumpScreen(tester, screen(const ChangePasswordScreen()));
      await tester.pumpAndSettle();
      await fill(tester, '', '', '');
      expect(find.text('Please fill in all fields'), findsOneWidget);
      await fill(tester, 'old', 'new-secret', 'different');
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('New passwords do not match'), findsOneWidget);
      await fill(tester, 'old', 'abc', 'abc');
      await tester.pump(const Duration(seconds: 5));
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
      verifyNever(() => authRepo.changePassword(
          oldPassword: any(named: 'oldPassword'),
          newPassword: any(named: 'newPassword')));
    });

    testWidgets('success shows the dialog; Done goes back to the profile',
        (tester) async {
      when(() => authRepo.changePassword(
          oldPassword: 'old',
          newPassword: 'new-secret')).thenAnswer((_) async {});
      await pumpScreen(tester, screen(const ChangePasswordScreen()));
      await tester.pumpAndSettle();
      await fill(tester, 'old', 'new-secret', 'new-secret');
      await tester.pumpAndSettle();
      expect(find.text('Password Updated!'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('profile-stub'), findsOneWidget);
    });

    testWidgets('a wrong current password shows the server message',
        (tester) async {
      when(() =>
          authRepo.changePassword(
              oldPassword: any(named: 'oldPassword'),
              newPassword: any(named: 'newPassword'))).thenThrow(
          const ApiError(status: 400, message: 'Old password is incorrect'));
      await pumpScreen(tester, screen(const ChangePasswordScreen()));
      await tester.pumpAndSettle();
      await fill(tester, 'bad', 'new-secret', 'new-secret');
      await tester.pumpAndSettle();
      expect(find.text('Old password is incorrect'), findsOneWidget);
      expect(find.text('Password Updated!'), findsNothing);
    });
  });

  group('ReportIssueScreen', () {
    testWidgets('requires a description', (tester) async {
      await pumpScreen(tester, screen(const ReportIssueScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(find.text('Please describe the issue'), findsOneWidget);
      verifyNever(() => repo.submitReport(any()));
    });

    testWidgets('picks an issue type, submits, shows the thank-you card',
        (tester) async {
      when(() => repo.submitReport(any())).thenAnswer((_) async {});
      await pumpScreen(tester, screen(const ReportIssueScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Vehicle Issue'), findsOneWidget);
      await tester.tap(find.text('Vehicle Issue'));
      await tester.pumpAndSettle();
      expect(find.text('Select Issue Type'),
          findsNWidgets(2)); // label + sheet title
      await tester.tap(find.text('Running Late'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Stuck on the bridge');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      final sent = verify(() => repo.submitReport(captureAny())).captured.single
          as IssueReport;
      expect(sent.issueType, IssueType.runningLate);
      expect(sent.description, 'Stuck on the bridge');
      expect(find.text('Thank you for your feedback!'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('profile-stub'), findsOneWidget);
    });

    testWidgets('a failed submit never shows the thank-you card',
        (tester) async {
      when(() => repo.submitReport(any())).thenThrow(const NetworkException());
      await pumpScreen(tester, screen(const ReportIssueScreen()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'x');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('Thank you for your feedback!'), findsNothing);
      expect(
          find.text(
              'No internet connection. Please check your network and try again.'),
          findsOneWidget);
    });
  });
}
