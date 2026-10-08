import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/core/providers/image_picker_provider.dart';
import 'package:smartvan_driver/features/auth/data/auth_repository.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_document_type.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_profile.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_report.dart';
import 'package:smartvan_driver/features/profile/data/models/issue_type.dart';
import 'package:smartvan_driver/features/profile/data/profile_repository.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/change_password_screen.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/document_viewer_screen.dart';
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
        clockProvider.overrideWithValue(() => DateTime(2026, 10, 8)),
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
    testWidgets('collapsing the header keeps the name in the toolbar',
        (tester) async {
      tester.view.physicalSize = const Size(800, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(screen(const ProfileScreen()));
      await tester.pumpAndSettle();
      double titleOpacity() => tester
          .widget<Opacity>(find.byKey(const Key('profile-collapsed-title')))
          .opacity;
      expect(titleOpacity(), 0); // open: the big avatar and name show
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
      await tester.pumpAndSettle();
      expect(titleOpacity(), 1);
      expect(
          find.descendant(
              of: find.byKey(const Key('profile-collapsed-title')),
              matching: find.text('Test Driver')),
          findsOneWidget);
      // The toolbar still has the edit button.
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      // And back to the top it fades out again.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 1200));
      await tester.pumpAndSettle();
      expect(titleOpacity(), 0);
    });

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
    void stubPick() {
      final file = tempImage('smartvan_doc_test.png');
      addTearDown(() => file.existsSync() ? file.deleteSync() : null);
      when(() => picker.pickImage(
              source: any(named: 'source'),
              imageQuality: any(named: 'imageQuality')))
          .thenAnswer((_) async => XFile(file.path));
    }

    Future<void> open(WidgetTester tester) async {
      await pumpScreen(tester, screen(const DocumentsScreen()));
      await tester.pumpAndSettle();
    }

    setUp(() {
      when(() => repo.uploadImage(any()))
          .thenAnswer((_) async => 'https://example.test/d.png');
      when(() =>
              repo.uploadDocument(any(), any(), expiry: any(named: 'expiry')))
          .thenAnswer((_) async {});
      when(() => repo.removeDocument(any())).thenAnswer((_) async {});
    });

    testWidgets('no generic upload button; empty cards say Upload',
        (tester) async {
      profile = const DriverProfile();
      await open(tester);
      expect(find.text('No Documents'), findsOneWidget);
      expect(find.text('Vehicle Registration Certificate'), findsOneWidget);
      expect(find.text('Driving License'), findsOneWidget);
      expect(find.text('Upload New Document'), findsNothing);
      expect(find.text('Upload'), findsNWidgets(2));
      expect(find.text('Tap to change'), findsNothing);
    });

    testWidgets('an uploaded document has the badge, expiry and the hint',
        (tester) async {
      await open(tester);
      expect(find.text('Uploaded'), findsWidgets);
      expect(find.text('Tap to change'), findsWidgets);
      expect(find.text('No Documents'), findsNothing);
      expect(find.text('Expires 15/03/2027'), findsOneWidget); // licence
      expect(find.text('Expires 30/11/2026'), findsOneWidget); // vehicle card
    });

    testWidgets('only the uploaded card has the hint', (tester) async {
      profile = profile.copyWith(vehicleCardImageFront: null);
      await open(tester);
      expect(find.text('Tap to change'), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
    });

    testWidgets('expiry colours: ok grey, within 30 days orange, past red',
        (tester) async {
      profile = profile.copyWith(
          expiryDateLicense: DateTime(2026, 11, 7), // 30 days
          expiryDateVehicleCard: DateTime(2026, 10, 7)); // yesterday
      await open(tester);
      Color? colorOf(String text) =>
          tester.widget<Text>(find.text(text)).style?.color;
      expect(colorOf('Expires 07/11/2026'), const Color(0xFFF57C00));
      expect(colorOf('Expired 07/10/2026'), const Color(0xFFE53935));
    });

    testWidgets('a far expiry is plain grey', (tester) async {
      await open(tester);
      expect(tester.widget<Text>(find.text('Expires 15/03/2027')).style?.color,
          const Color(0xFF8A94A6));
    });

    testWidgets('uploaded: tapping the card offers View, Change and Remove',
        (tester) async {
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      expect(find.text('View'), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    });

    testWidgets('View opens the picture full screen with zoom', (tester) async {
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('View'));
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.byType(DocumentViewerScreen), findsOneWidget);
    });

    testWidgets('not uploaded: tapping goes straight to camera / gallery',
        (tester) async {
      profile = const DriverProfile();
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      expect(find.text('Take photo'), findsOneWidget);
      expect(find.text('Choose from gallery'), findsOneWidget);
      expect(find.text('View'), findsNothing);
      expect(find.text('Remove'), findsNothing);
    });

    testWidgets('Change → gallery → expiry date → uploads with it and confirms',
        (tester) async {
      stubPick();
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from gallery'));
      await tester.pumpAndSettle();
      verify(() => picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: any(named: 'imageQuality'))).called(1);
      // The old date (15 Mar 2027) is already selected.
      expect(find.text('Expiry date (optional)'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      verify(() => repo.uploadDocument(
          DriverDocumentType.drivingLicense, 'https://example.test/d.png',
          expiry: DateTime(2027, 3, 15))).called(1);
      expect(
          find.text('Driving License uploaded successfully!'), findsOneWidget);
    });

    testWidgets('Take photo uses the camera', (tester) async {
      stubPick();
      profile = const DriverProfile();
      await open(tester);
      await tester.tap(find.text('Vehicle Registration Certificate'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take photo'));
      await tester.pumpAndSettle();
      verify(() => picker.pickImage(
          source: ImageSource.camera,
          imageQuality: any(named: 'imageQuality'))).called(1);
      // No old date: today is offered; skipping it uploads without one.
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      verify(() => repo.uploadDocument(
              DriverDocumentType.vehicleCard, 'https://example.test/d.png'))
          .called(1);
    });

    testWidgets('backing out of the source sheet or the picker uploads nothing',
        (tester) async {
      profile = const DriverProfile();
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10)); // barrier
      await tester.pumpAndSettle();
      when(() => picker.pickImage(
              source: any(named: 'source'),
              imageQuality: any(named: 'imageQuality')))
          .thenAnswer((_) async => null);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from gallery'));
      await tester.pumpAndSettle();
      verifyNever(() => repo.uploadImage(any()));
    });

    testWidgets('a failed upload shows an error and keeps the old image',
        (tester) async {
      stubPick();
      when(() => repo.uploadImage(any())).thenThrow(const NetworkException());
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from gallery'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(
          find.text(
              'No internet connection. Please check your network and try again.'),
          findsOneWidget);
      verifyNever(() =>
          repo.uploadDocument(any(), any(), expiry: any(named: 'expiry')));
      expect(find.text('Uploaded'), findsWidgets); // still there
      expect(find.text('Tap to change'), findsWidgets);
    });

    testWidgets('the card shows a spinner while it uploads', (tester) async {
      stubPick();
      final gate = Completer<String>();
      when(() => repo.uploadImage(any())).thenAnswer((_) => gate.future);
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from gallery'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      gate.complete('https://example.test/d.png');
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Remove asks first; confirming removes and says so',
        (tester) async {
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Remove Driving License?'), findsOneWidget);
      verifyNever(() => repo.removeDocument(any()));
      await tester.tap(find.widgetWithText(TextButton, 'Remove'));
      await tester.pumpAndSettle();
      verify(() => repo.removeDocument(DriverDocumentType.drivingLicense))
          .called(1);
      expect(find.text('Driving License removed.'), findsOneWidget);
    });

    testWidgets('cancelling the confirmation removes nothing', (tester) async {
      await open(tester);
      await tester.tap(find.text('Vehicle Registration Certificate'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Remove Vehicle Registration Certificate?'),
          findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      verifyNever(() => repo.removeDocument(any()));
    });

    testWidgets('a failed removal shows the error and the card stays',
        (tester) async {
      when(() => repo.removeDocument(any()))
          .thenThrow(const ApiError(status: 500));
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Driving License removed.'), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Tap to change'), findsWidgets);
    });

    testWidgets('after removal the refreshed profile shows an empty card',
        (tester) async {
      when(() => repo.removeDocument(any())).thenAnswer((_) async {
        profile = profile.copyWith(
            licenceImageFront: null,
            licenceImageBack: null,
            expiryDateLicense: null);
      });
      await open(tester);
      await tester.tap(find.text('Driving License'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Upload'), findsOneWidget);
      expect(find.text('Expires 15/03/2027'), findsNothing);
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
