import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/core/router/router_provider.dart';
import 'package:smartvan_driver/core/storage/token_store.dart';
import 'package:smartvan_driver/features/auth/application/session_controller.dart';
import 'package:smartvan_driver/features/profile/application/driver_profile_provider.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_profile.dart';
import 'package:smartvan_driver/features/profile/data/profile_repository.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';

import '../../../support/fake_sync_queue.dart';
import '../../../support/fake_tracking.dart';

class _Tokens extends Mock implements TokenStore {}

class _ProfileRepo extends Mock implements ProfileRepository {}

class _Router extends Mock implements GoRouter {}

void main() {
  late _Tokens tokens;
  late FakeSyncQueue queue;
  late TrackingProbe probe;
  late _ProfileRepo profile;
  late _Router router;
  late ProviderContainer c;
  var profileLoads = 0;

  setUp(() {
    tokens = _Tokens();
    queue = FakeSyncQueue();
    probe = TrackingProbe();
    profile = _ProfileRepo();
    profileLoads = 0;
    when(() => tokens.clear()).thenAnswer((_) async {});
    when(() => profile.getProfile()).thenAnswer((_) async {
      profileLoads++;
      return const DriverProfile(fullname: 'Test Driver');
    });
    router = _Router();
    c = ProviderContainer(overrides: [
      tokenStorageProvider.overrideWithValue(tokens),
      syncQueueProvider.overrideWithValue(queue),
      profileRepositoryProvider.overrideWithValue(profile),
      routerProvider.overrideWithValue(router),
      tripTrackingProvider
          .overrideWith(() => FakeTracking(tripId: 't-1', probe: probe)),
    ]);
    addTearDown(c.dispose);
    when(() => queue.clear()).thenAnswer((_) async {});
  });

  test(
      'logout stops tracking, clears the token and the offline queue, '
      'forgets the profile and goes to login', () async {
    await c.read(driverProfileProvider.future);
    expect(profileLoads, 1);

    await c.read(sessionProvider).signOut();

    expect(probe.stops, 1);
    verify(() => tokens.clear()).called(1);
    verify(() => queue.clear()).called(1);
    verify(() => router.go('/login')).called(1);
    await c.read(driverProfileProvider.future);
    expect(profileLoads, 2); // the next driver gets their own profile
  });

  test('an expired session keeps the offline queue', () async {
    await c.read(sessionProvider).signOut(reason: SignOutReason.sessionExpired);

    verify(() => tokens.clear()).called(1);
    verifyNever(() => queue.clear());
    verify(() => router.go('/login')).called(1);
  });

  test('two sign-outs at once run once', () async {
    final session = c.read(sessionProvider);
    await Future.wait([session.signOut(), session.signOut()]);
    verify(() => tokens.clear()).called(1);
  });
}
