import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/storage/token_store.dart';
import 'package:smartvan_driver/features/auth/application/login_controller.dart';
import 'package:smartvan_driver/features/auth/application/session_providers.dart';
import 'package:smartvan_driver/features/auth/application/splash_controller.dart';
import 'package:smartvan_driver/features/auth/data/auth_repository.dart';

class _FakeAuthRepo extends Mock implements AuthRepository {}

class _FakeTokens extends Mock implements TokenStore {}

void main() {
  late _FakeAuthRepo repo;
  late _FakeTokens tokens;
  late int pushCalls;
  late ProviderContainer container;
  Map<String, dynamic>? resumable;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = _FakeAuthRepo();
    tokens = _FakeTokens();
    pushCalls = 0;
    resumable = null;
    when(() => tokens.save(any())).thenAnswer((_) async {});
    when(() => tokens.hasToken()).thenAnswer((_) async => true);
    container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      tokenStorageProvider.overrideWithValue(tokens),
      pushRegistrarProvider.overrideWithValue(() async => pushCalls++),
      resumableTripProvider.overrideWith((ref) => resumable),
    ]);
    addTearDown(container.dispose);
  });

  group('LoginController', () {
    test('success saves the token and user type, registers push, returns true',
        () async {
      when(() => repo.login(loginId: 'driver', password: 'pw'))
          .thenAnswer((_) async => 'fake-jwt');
      final ok = await container
          .read(loginControllerProvider.notifier)
          .signIn(loginId: 'driver', password: 'pw');
      expect(ok, isTrue);
      expect(container.read(loginControllerProvider).hasError, isFalse);
      verify(() => tokens.save('fake-jwt')).called(1);
      expect((await SharedPreferences.getInstance()).getString('user_type'),
          'driver');
      await pumpEventQueue();
      expect(pushCalls, 1);
    });

    test('a failed push registration never fails the login', () async {
      when(() => repo.login(
          loginId: any(named: 'loginId'),
          password: any(named: 'password'))).thenAnswer((_) async => 't');
      final failing = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        tokenStorageProvider.overrideWithValue(tokens),
        pushRegistrarProvider
            .overrideWithValue(() async => throw StateError('no fcm')),
      ]);
      addTearDown(failing.dispose);
      expect(
          await failing
              .read(loginControllerProvider.notifier)
              .signIn(loginId: 'a', password: 'b'),
          isTrue);
    });

    test('wrong password: error state, false, nothing saved', () async {
      when(() => repo.login(
              loginId: any(named: 'loginId'), password: any(named: 'password')))
          .thenThrow(const UnauthorizedException('Invalid credentials'));
      final ok = await container
          .read(loginControllerProvider.notifier)
          .signIn(loginId: 'x', password: 'y');
      expect(ok, isFalse);
      expect(container.read(loginControllerProvider).error,
          isA<UnauthorizedException>());
      verifyNever(() => tokens.save(any()));
      expect(pushCalls, 0);
    });

    test('is loading while the request runs', () async {
      final sub = container.listen(loginControllerProvider, (_, __) {});
      addTearDown(sub.close);
      when(() => repo.login(
          loginId: any(named: 'loginId'),
          password: any(named: 'password'))).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return 't';
      });
      final future = container
          .read(loginControllerProvider.notifier)
          .signIn(loginId: 'x', password: 'y');
      expect(container.read(loginControllerProvider).isLoading, isTrue);
      await future;
      expect(container.read(loginControllerProvider).isLoading, isFalse);
    });
  });

  group('SplashController', () {
    test('no token goes to login', () async {
      when(() => tokens.hasToken()).thenAnswer((_) async => false);
      expect(await container.read(splashControllerProvider.notifier).decide(),
          isA<GoToLogin>());
    });

    test('a token goes home', () async {
      expect(await container.read(splashControllerProvider.notifier).decide(),
          isA<GoToHome>());
    });

    test('a token and a trip in progress resumes the trip', () async {
      resumable = {'_id': 'trip-001'};
      final fresh = ProviderContainer(overrides: [
        tokenStorageProvider.overrideWithValue(tokens),
        resumableTripProvider.overrideWith((ref) => resumable),
      ]);
      addTearDown(fresh.dispose);
      final d = await fresh.read(splashControllerProvider.notifier).decide();
      expect((d as ResumeTrip).trip['_id'], 'trip-001');
    });

    test('a trip in progress without a token still goes to login', () async {
      when(() => tokens.hasToken()).thenAnswer((_) async => false);
      resumable = {'_id': 'trip-001'};
      final fresh = ProviderContainer(overrides: [
        tokenStorageProvider.overrideWithValue(tokens),
        resumableTripProvider.overrideWith((ref) => resumable),
      ]);
      addTearDown(fresh.dispose);
      expect(await fresh.read(splashControllerProvider.notifier).decide(),
          isA<GoToLogin>());
    });
  });
}
