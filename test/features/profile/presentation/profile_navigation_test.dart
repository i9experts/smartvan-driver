import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/router/app_routes.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_profile.dart';
import 'package:smartvan_driver/features/profile/data/profile_repository.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/change_password_screen.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/documents_screen.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/profile_screen.dart';
import 'package:smartvan_driver/features/profile/presentation/screens/report_issue_screen.dart';

import '../../../support/l10n_host.dart';

class _FakeProfileRepo extends Mock implements ProfileRepository {}

/// The screens reached from Profile are *pushed*, so system back and
/// swipe-back return to Profile.
void main() {
  late _FakeProfileRepo repo;

  setUp(() {
    repo = _FakeProfileRepo();
    when(() => repo.getProfile())
        .thenAnswer((_) async => const DriverProfile(fullname: 'Test Driver'));
  });

  Widget app() => routerHost(
        {
          AppRoutes.profile: (_) => const ProfileScreen(),
          AppRoutes.editProfile: (_) => const EditProfileScreen(),
          AppRoutes.documents: (_) => const DocumentsScreen(),
          AppRoutes.changePassword: (_) => const ChangePasswordScreen(),
          AppRoutes.reportIssue: (_) => const ReportIssueScreen(),
          AppRoutes.feeCollection: (_) => const Text('fees-stub'),
          AppRoutes.stats: (_) => const Text('stats-stub'),
        },
        initial: AppRoutes.profile,
        overrides: [profileRepositoryProvider.overrideWithValue(repo)],
      );

  for (final (label, marker) in [
    ('My Documents', 'Documents'),
    ('Change Password', 'Update Password'),
    ('Report an Issue', 'Select Issue Type'),
    ('Fee Collection', 'fees-stub'),
    ('My Driving Stats', 'stats-stub'),
  ]) {
    testWidgets('$label opens on top of Profile and Back returns to it',
        (tester) async {
      useTallView(tester);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text(marker), findsWidgets);
      final router = GoRouter.of(tester.element(find.text(marker).first));
      expect(router.canPop(),
          isTrue); // system back / swipe-back have somewhere to go
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('My Profile'), findsOneWidget);
    });
  }

  testWidgets('the pencil opens Edit Profile on top of Profile',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Edit Profile'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();
    expect(find.text('My Profile'), findsOneWidget);
  });

  testWidgets('the on-screen back arrow pops too', (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Documents'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();
    expect(find.text('My Profile'), findsOneWidget);
  });

  testWidgets('a screen opened without a stack falls back to Profile',
      (tester) async {
    await tester.pumpWidget(routerHost(
      {
        AppRoutes.documents: (_) => const DocumentsScreen(),
        AppRoutes.profile: (_) => const Text('profile-stub'),
      },
      initial: AppRoutes.documents,
      overrides: [profileRepositoryProvider.overrideWithValue(repo)],
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();
    expect(find.text('profile-stub'), findsOneWidget);
  });
}
