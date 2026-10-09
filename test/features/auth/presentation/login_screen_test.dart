import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/storage/token_store.dart';
import 'package:smartvan_driver/features/auth/application/session_providers.dart';
import 'package:smartvan_driver/features/auth/data/auth_repository.dart';
import 'package:smartvan_driver/features/auth/presentation/screens/login_screen.dart';

import '../../../support/l10n_host.dart';

class _FakeAuthRepo extends Mock implements AuthRepository {}

class _FakeTokens extends Mock implements TokenStore {}

void main() {
  late _FakeAuthRepo repo;
  late _FakeTokens tokens;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = _FakeAuthRepo();
    tokens = _FakeTokens();
    when(() => tokens.save(any())).thenAnswer((_) async {});
  });

  Widget app() => routerHost(
        {
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const Text('home-stub'),
        },
        initial: '/login',
        overrides: [
          authRepositoryProvider.overrideWithValue(repo),
          tokenStorageProvider.overrideWithValue(tokens),
          pushRegistrarProvider.overrideWithValue(() async {}),
        ],
      );

  testWidgets('on a small phone with the keyboard open Sign In stays on screen',
      (tester) async {
    tester.view.physicalSize = const Size(750, 1334); // iPhone SE: 375x667
    tester.view.devicePixelRatio = 2;
    tester.view.viewInsets = const FakeViewPadding(bottom: 600); // 300pt keyboard
    addTearDown(tester.view.reset);

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    final button = tester.getRect(find.text('Sign In'));
    expect(button.bottom, lessThanOrEqualTo(667 - 300));
    expect(button.top, greaterThanOrEqualTo(0));
  });

  testWidgets('shows the English texts', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    for (final t in [
      'SmartVan Driver',
      'Driver Portal',
      'Welcome Back!',
      'Sign in to manage your trips',
      'Phone Number or CNIC',
      'Password',
      'Sign In',
    ]) {
      expect(find.text(t), findsOneWidget, reason: t);
    }
    expect(find.text('e.g. 03211181555 or your CNIC'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
  });

  testWidgets(
      'empty fields show the validation message and do not call the API',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    expect(find.text('Please fill in all fields'), findsOneWidget);
    verifyNever(() => repo.login(
        loginId: any(named: 'loginId'), password: any(named: 'password')));
  });

  testWidgets('successful sign-in goes home', (tester) async {
    when(() => repo.login(loginId: 'driver@example.test', password: 'secret'))
        .thenAnswer((_) async => 'fake-jwt');
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextFormField).first, 'driver@example.test');
    await tester.enterText(find.byType(TextFormField).last, 'secret');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('home-stub'), findsOneWidget);
    verify(() => tokens.save('fake-jwt')).called(1);
  });

  testWidgets('wrong password shows the server message and stays on the screen',
      (tester) async {
    when(() => repo.login(
            loginId: any(named: 'loginId'), password: any(named: 'password')))
        .thenThrow(const UnauthorizedException('Invalid credentials'));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'x');
    await tester.enterText(find.byType(TextFormField).last, 'y');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('Invalid credentials'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('home-stub'), findsNothing);
  });

  testWidgets('offline shows the no-internet message', (tester) async {
    when(() => repo.login(
        loginId: any(named: 'loginId'),
        password: any(named: 'password'))).thenThrow(const NetworkException());
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'x');
    await tester.enterText(find.byType(TextFormField).last, 'y');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(
        find.text(
            'No internet connection. Please check your network and try again.'),
        findsOneWidget);
  });

  testWidgets('the eye icon toggles password visibility', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    EditableText field() =>
        tester.widget<EditableText>(find.byType(EditableText).last);
    expect(field().obscureText, isTrue);
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    expect(field().obscureText, isFalse);
  });
}
