import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart' as loc;
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/config/app_config.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/core/storage/token_store.dart';
import 'package:smartvan_driver/core/sync/sync_queue.dart';
import 'package:smartvan_driver/features/trip/application/kid_absence_events.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/data/active_trip_store.dart';
import 'package:smartvan_driver/features/trip/data/kids_not_dropped_error.dart';
import 'package:smartvan_driver/features/trip/data/models/active_trip.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';

import '../../../support/fake_location.dart';
import '../../../support/fake_socket.dart';
import '../../../support/fake_sync_queue.dart';
import '../../../support/memory_active_trip_store.dart';

class _FakeTripRepo extends Mock implements TripRepository {}

class _FakeTokens extends Mock implements TokenStore {}

void main() {
  late FakeLocation location;
  late FakeSocket socket;
  late FakeSyncQueue queue;
  late _FakeTripRepo repo;
  late MemoryActiveTripStore store;
  late _FakeTokens tokens;
  late DateTime now;
  late List<(String, Map<String, dynamic>)> socketsCreated;
  late ProviderContainer container;

  const trip = ActiveTrip(
      id: 'trip-001',
      routeId: 'route-001',
      routeTitle: 'Sample School - Morning',
      type: TripType.pick);

  setUpAll(() => registerFallbackValue(const GeoPoint(lat: 0, lng: 0)));

  setUp(() {
    location = FakeLocation();
    socket = FakeSocket();
    queue = FakeSyncQueue();
    repo = _FakeTripRepo();
    store = MemoryActiveTripStore();
    tokens = _FakeTokens();
    now = DateTime(2026, 10, 6, 8, 0);
    socketsCreated = [];
    when(() => tokens.read()).thenAnswer((_) async => 'fake-jwt');
    when(() => repo.sendLocation(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'),
          speedMetersPerSecond: any(named: 'speedMetersPerSecond'),
        )).thenAnswer((_) async => SubmitOutcome.sent);
    when(() => repo.endTrip(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'),
          forceEnd: any(named: 'forceEnd'),
          confirmationNote: any(named: 'confirmationNote'),
        )).thenAnswer((_) async {});

    container = ProviderContainer(overrides: [
      locationServiceProvider.overrideWithValue(location),
      socketFactoryProvider.overrideWithValue((url, options) {
        socketsCreated.add((url, options));
        return socket;
      }),
      syncQueueProvider.overrideWithValue(queue),
      tripRepositoryProvider.overrideWithValue(repo),
      activeTripStoreProvider.overrideWithValue(store),
      tokenStorageProvider.overrideWithValue(tokens),
      clockProvider.overrideWithValue(() => now),
      appConfigProvider.overrideWithValue(const AppConfig(
          apiBaseUrl: 'http://api.test', socketUrl: 'http://socket.test')),
    ]);
    addTearDown(container.dispose);
    addTearDown(location.close);
  });

  TripTracking tracking() => container.read(tripTrackingProvider.notifier);
  dynamic state() => container.read(tripTrackingProvider);

  group('start', () {
    test('without location services: remembers the trip, does not track',
        () async {
      location.serviceEnabledAnswer = false;
      location.requestServiceAnswer = false;
      expect(
          await tracking().start(trip), TrackingStartResult.locationServiceOff);
      expect(state().isTracking, isFalse);
      expect(state().trip, trip);
      expect(socketsCreated, isEmpty);
    });

    test('permission denied / denied forever', () async {
      location.permission = loc.PermissionStatus.denied;
      location.permissionAfterRequest = loc.PermissionStatus.denied;
      expect(
          await tracking().start(trip), TrackingStartResult.permissionDenied);

      location.permissionAfterRequest = loc.PermissionStatus.deniedForever;
      expect(await tracking().start(trip),
          TrackingStartResult.permissionDeniedForever);
      expect(state().isTracking, isFalse);
    });

    test('an empty trip id is refused', () async {
      expect(await tracking().start(const ActiveTrip()),
          TrackingStartResult.permissionDenied);
    });

    test(
        'starts: tracking on, trip saved, GPS configured, socket joined, background mode on',
        () async {
      expect(await tracking().start(trip), TrackingStartResult.started);
      expect(state().isTracking, isTrue);
      expect(state().tripId, 'trip-001');
      expect(store.saved, trip);
      verify(() => location.changeSettings(
          accuracy: loc.LocationAccuracy.high,
          interval: 5000,
          distanceFilter: 10)).called(1);
      verify(() => location.enableBackgroundMode(enable: true)).called(1);
      expect(socketsCreated.single.$1, 'http://socket.test');
      expect(socketsCreated.single.$2['transports'], ['websocket']);
      expect(socketsCreated.single.$2['autoConnect'], isFalse);
      verify(() => socket.connect()).called(1);

      socket.serverConnects();
      expect(state().socketConnected, isTrue);
      verify(() => socket.emit('startTrip', {'tripId': 'trip-001'})).called(1);
      expect(
          queue.flushes, 1); // pending items go out as soon as the socket is up

      socket.serverDisconnects();
      expect(state().socketConnected, isFalse);
    });

    test('the socket asks for the current token on every connect', () async {
      await tracking().start(trip);
      final auth =
          socketsCreated.single.$2['auth'] as void Function(void Function(Map));
      final sent = <Map>[];
      auth(sent.add);
      await pumpEventQueue();
      expect(sent.single, {'token': 'fake-jwt'});
    });

    test('starting the same trip again only merges details', () async {
      await tracking().start(trip);
      expect(
          await tracking()
              .start(const ActiveTrip(id: 'trip-001', name: 'Morning run')),
          TrackingStartResult.alreadyRunning);
      expect(state().trip.routeTitle, 'Sample School - Morning'); // kept
      expect(state().trip.name, 'Morning run'); // added
      expect(store.saved!.name, 'Morning run');
      expect(socketsCreated, hasLength(1));
    });

    test('a different trip replaces the running one', () async {
      await tracking().start(trip);
      await tracking().start(const ActiveTrip(id: 'trip-002'));
      expect(state().tripId, 'trip-002');
      verify(() => socket.dispose()).called(greaterThanOrEqualTo(1));
      expect(socketsCreated, hasLength(2));
    });
  });

  group('location fixes', () {
    test('update the state and go over the socket with `long` once connected',
        () async {
      await tracking().start(trip);
      socket.serverConnects();
      location.emit(24.8607, 67.0011, speed: 8.0);
      await pumpEventQueue();
      expect(state().lastPosition, const GeoPoint(lat: 24.8607, lng: 67.0011));
      expect(state().lastSpeed, 8.0);
      verify(() => socket.emit('updateLocation', {
            'tripId': 'trip-001',
            'location': {'lat': 24.8607, 'long': 67.0011},
          })).called(1);
    });

    test('nothing is emitted while the socket is down', () async {
      await tracking().start(trip);
      location.emit(1, 2);
      await pumpEventQueue();
      verifyNever(() => socket.emit('updateLocation', any()));
    });

    test('HTTP updates (with speed) are throttled to one per 5 seconds',
        () async {
      await tracking().start(trip);
      location.emit(1, 2, speed: 5);
      await pumpEventQueue();
      verify(() => repo.sendLocation(
          tripId: 'trip-001',
          position: const GeoPoint(lat: 1, lng: 2),
          speedMetersPerSecond: 5)).called(1);

      now = now.add(const Duration(seconds: 3));
      location.emit(3, 4);
      await pumpEventQueue();
      verifyNever(() => repo.sendLocation(
          tripId: 'trip-001',
          position: const GeoPoint(lat: 3, lng: 4),
          speedMetersPerSecond: any(named: 'speedMetersPerSecond')));

      now = now.add(const Duration(seconds: 3));
      location.emit(5, 6);
      await pumpEventQueue();
      verify(() => repo.sendLocation(
          tripId: 'trip-001',
          position: const GeoPoint(lat: 5, lng: 6),
          speedMetersPerSecond: any(named: 'speedMetersPerSecond'))).called(1);
    });

    test('TRIP_NOT_ONGOING from the server stops tracking', () async {
      when(() => repo.sendLocation(
              tripId: any(named: 'tripId'),
              position: any(named: 'position'),
              speedMetersPerSecond: any(named: 'speedMetersPerSecond')))
          .thenAnswer((_) async => throw const ApiError(
              code: 'TRIP_NOT_ONGOING', status: 400, message: 'over'));
      await tracking().start(trip);
      location.emit(1, 2);
      await pumpEventQueue();
      expect(state().isTracking, isFalse);
      expect(state().trip, isNull);
      expect(store.saved, isNull);
    });

    test('any other send failure is ignored', () async {
      when(() => repo.sendLocation(
              tripId: any(named: 'tripId'),
              position: any(named: 'position'),
              speedMetersPerSecond: any(named: 'speedMetersPerSecond')))
          .thenAnswer(
              (_) async => throw const ApiError(status: 400, message: 'nope'));
      await tracking().start(trip);
      location.emit(1, 2);
      await pumpEventQueue();
      expect(state().isTracking, isTrue);
    });
  });

  group('stop', () {
    test('tears everything down and forgets the trip', () async {
      await tracking().start(trip);
      await tracking().stop();
      expect(state().isTracking, isFalse);
      expect(state().trip, isNull);
      expect(store.saved, isNull);
      expect(location.hasListener, isFalse);
      verify(() => socket.disconnect()).called(1);
      verify(() => location.enableBackgroundMode(enable: false)).called(1);
    });
  });

  group('endTrip', () {
    test('with no trip it just stops', () async {
      await tracking().endTrip();
      verifyNever(() => repo.endTrip(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'),
          forceEnd: any(named: 'forceEnd'),
          confirmationNote: any(named: 'confirmationNote')));
    });

    test('refuses while pickups/drops are unsynced', () async {
      await tracking().start(trip);
      queue.flushResult = false;
      queue.pending.value = 3;
      await expectLater(
          tracking().endTrip(),
          throwsA(isA<PendingSyncException>()
              .having((e) => e.pending, 'pending', 3)));
      expect(state().isTracking, isTrue);
    });

    test('flushes, ends on the server with the last position, then stops',
        () async {
      await tracking().start(trip);
      location.emit(24.0, 67.0);
      await pumpEventQueue();
      await tracking().endTrip();
      expect(queue.flushes, greaterThanOrEqualTo(1));
      verify(() => repo.endTrip(
          tripId: 'trip-001',
          position: const GeoPoint(lat: 24.0, lng: 67.0),
          forceEnd: false,
          confirmationNote: null)).called(1);
      expect(state().isTracking, isFalse);
      expect(store.saved, isNull);
    });

    test('force end passes the note', () async {
      await tracking().start(trip);
      await tracking().endTrip(forceEnd: true, confirmationNote: 'Van checked');
      verify(() => repo.endTrip(
          tripId: 'trip-001',
          position: null,
          forceEnd: true,
          confirmationNote: 'Van checked')).called(1);
    });

    test(
        'KIDS_NOT_DROPPED is rethrown with the kids and tracking keeps running',
        () async {
      when(() => repo.endTrip(
              tripId: any(named: 'tripId'),
              position: any(named: 'position'),
              forceEnd: any(named: 'forceEnd'),
              confirmationNote: any(named: 'confirmationNote')))
          .thenAnswer((_) async => throw const ApiError(
                code: 'KIDS_NOT_DROPPED',
                status: 409,
                message: '1 kid',
                data: {
                  'kids': [
                    {'kidId': 'k1', 'fullname': 'Test Kid One'}
                  ]
                },
              ));
      await tracking().start(trip);
      try {
        await tracking().endTrip();
        fail('should throw');
      } on ApiError catch (e) {
        expect(e.kidsNotDropped.single.fullname, 'Test Kid One');
      }
      expect(state().isTracking, isTrue);
    });
  });

  group('currentPosition', () {
    test('uses the last streamed fix', () async {
      await tracking().start(trip);
      location.emit(1, 2);
      await pumpEventQueue();
      expect(
          await tracking().currentPosition(), const GeoPoint(lat: 1, lng: 2));
      verifyNever(() => location.getLocation());
    });

    test('otherwise reads once', () async {
      when(() => location.getLocation()).thenAnswer((_) async =>
          loc.LocationData.fromMap({'latitude': 9.0, 'longitude': 8.0}));
      expect(
          await tracking().currentPosition(), const GeoPoint(lat: 9, lng: 8));
    });

    test('null when GPS is unavailable', () async {
      when(() => location.getLocation())
          .thenAnswer((_) async => throw StateError('no gps'));
      expect(await tracking().currentPosition(), isNull);
    });
  });

  test(
      'parent absence events from the socket reach the bus with the cancelled flag',
      () async {
    await tracking().start(trip);
    final received = <(String, bool)>[];
    final sub = container
        .read(kidAbsenceBusProvider)
        .stream
        .listen((e) => received.add((e.fullname, e.cancelled)));
    addTearDown(sub.cancel);
    socket.serverSends('kidAbsence', {
      'kidId': 'k1',
      'fullname': 'Test Kid One',
      'date': '2026-10-06',
      'tripType': 'pick'
    });
    socket.serverSends('kidAbsenceCancelled', {
      'kidId': 'k1',
      'fullname': 'Test Kid One',
      'date': '2026-10-06',
      'tripType': 'pick'
    });
    socket.serverSends('kidAbsence', 'garbage');
    await pumpEventQueue();
    expect(received, [('Test Kid One', false), ('Test Kid One', true)]);
  });

  test('the persisted trip survives a read back', () async {
    await tracking().start(trip);
    final fresh = ProviderContainer(
        overrides: [activeTripStoreProvider.overrideWithValue(store)]);
    addTearDown(fresh.dispose);
    expect(fresh.read(activeTripStoreProvider).read(), trip);
  });
}
