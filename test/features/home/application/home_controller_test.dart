import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/home/application/home_controller.dart';
import 'package:smartvan_driver/features/home/application/start_trip_controller.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/data/models/assigned_route.dart';
import 'package:smartvan_driver/features/trip/data/models/route_passenger.dart';
import 'package:smartvan_driver/features/trip/data/models/trip.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_status.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';

import '../../../support/fake_tracking.dart';

class _FakeTripRepo extends Mock implements TripRepository {}

void main() {
  late _FakeTripRepo repo;
  late TrackingProbe probe;

  const ongoingTrip = Trip(id: 't-1', status: TripStatus.ongoing);
  const running = AssignedRoute(
    routeId: 'r-1',
    routeTitle: 'Morning',
    tripStarted: true,
    tripDetails: ongoingTrip,
    passengers: [
      RoutePassenger(kidId: 'k1', fullname: 'One'),
      RoutePassenger(kidId: 'k2', fullname: 'Two'),
    ],
  );
  const waiting = AssignedRoute(
    routeId: 'r-2',
    routeTitle: 'Afternoon',
    tripType: TripType.drop,
    passengers: [RoutePassenger(kidId: 'k2', fullname: 'Two')],
  );

  setUp(() {
    repo = _FakeTripRepo();
    probe = TrackingProbe();
    when(() => repo.assignedRoutes())
        .thenAnswer((_) async => [running, waiting]);
    when(() => repo.driverTrips()).thenAnswer((_) async => [
          ongoingTrip,
          const Trip(id: 't-2', status: TripStatus.completed),
        ]);
  });

  ProviderContainer make({String? trackedId, bool? isTracking}) {
    final c = ProviderContainer(overrides: [
      tripRepositoryProvider.overrideWithValue(repo),
      tripTrackingProvider.overrideWith(() => FakeTracking(
          tripId: trackedId, isTracking: isTracking, probe: probe)),
    ]);
    addTearDown(c.dispose);
    return c;
  }

  group('HomeController', () {
    test('loads routes and trips and counts kids once', () async {
      final c = make(trackedId: 't-1');
      final s = await c.read(homeControllerProvider.future);
      expect(s.routes, hasLength(2));
      expect(s.trips, hasLength(2));
      expect(s.passengerCount, 2); // k2 is on both routes
      expect(s.completedTrips, 1);
      expect(s.noVan, isFalse);
    });

    test('a trip running on the server but not here is resumed', () async {
      final c = make(isTracking: false);
      final s = await c.read(homeControllerProvider.future);
      expect(probe.started.single.id, 't-1');
      expect(probe.started.single.routeTitle, 'Morning');
      expect(s.resumedAt, isNotNull);
    });

    test('already tracking that trip → nothing to resume', () async {
      final c = make(trackedId: 't-1');
      final s = await c.read(homeControllerProvider.future);
      expect(probe.started, isEmpty);
      expect(s.resumedAt, isNull);
    });

    test('no resume message when tracking could not start', () async {
      probe.startResult = TrackingStartResult.permissionDenied;
      final c = make(isTracking: false);
      final s = await c.read(homeControllerProvider.future);
      expect(probe.started, hasLength(1));
      expect(s.resumedAt, isNull);
    });

    test('tracking here but no started trip any more → stopped', () async {
      when(() => repo.assignedRoutes()).thenAnswer((_) async => [waiting]);
      final c = make(trackedId: 't-9');
      await c.read(homeControllerProvider.future);
      expect(probe.stops, 1);
    });

    test('no van today (400) → empty state, tracking left alone', () async {
      when(() => repo.assignedRoutes()).thenAnswer((_) async =>
          throw const ApiError(status: 400, message: 'Van not found'));
      final c = make(trackedId: 't-1');
      final s = await c.read(homeControllerProvider.future);
      expect(s.noVan, isTrue);
      expect(s.routes, isEmpty);
      expect(probe.stops, 0);
    });

    test('routes failing for another reason is not "no van"', () async {
      when(() => repo.assignedRoutes())
          .thenAnswer((_) async => throw const ServerException(null, 500));
      final c = make(trackedId: 't-1');
      final s = await c.read(homeControllerProvider.future);
      expect(s.noVan, isFalse);
      expect(s.routes, isEmpty);
      expect(probe.stops, 0);
    });

    test('trips failing still shows the routes', () async {
      when(() => repo.driverTrips()).thenAnswer((_) async => throw Exception());
      final c = make(trackedId: 't-1');
      final s = await c.read(homeControllerProvider.future);
      expect(s.trips, isEmpty);
      expect(s.routes, hasLength(2));
    });
  });

  group('StartTripController', () {
    const started = Trip(id: 't-new', routeId: 'r-2', type: TripType.drop);

    test('starts a trip, merges the route title, reloads home', () async {
      when(() => repo.startTrip(routeId: 'r-2', type: TripType.drop))
          .thenAnswer((_) async => started);
      final c = make(trackedId: 't-1');
      c.listen(homeControllerProvider, (_, __) {}); // the screen watching it
      await c.read(homeControllerProvider.future);
      final result = await c
          .read(startTripControllerProvider.notifier)
          .start(waiting, completeChecklist: () async => fail('no check'));
      expect(result, isA<TripStarted>());
      final trip = (result as TripStarted).trip;
      expect(trip.id, 't-new');
      expect(trip.routeTitle, 'Afternoon');
      expect(c.read(startTripControllerProvider), isNull);
      await c.read(homeControllerProvider.future);
      verify(() => repo.assignedRoutes()).called(2); // initial + reload
    });

    test('state names the route being started', () async {
      when(() => repo.startTrip(routeId: 'r-2', type: TripType.drop))
          .thenAnswer((_) async {
        return started;
      });
      final c = make();
      final seen = <String?>[];
      c.listen(startTripControllerProvider, (_, v) => seen.add(v));
      await c
          .read(startTripControllerProvider.notifier)
          .start(waiting, completeChecklist: () async => true);
      expect(seen, ['r-2', null]);
    });

    test('check required → opens the check, then retries once', () async {
      var calls = 0;
      when(() => repo.startTrip(routeId: 'r-2', type: TripType.drop))
          .thenAnswer((_) async {
        if (calls++ == 0) {
          throw const ApiError(
              status: 400, code: 'CHECKLIST_REQUIRED', message: 'Check');
        }
        return started;
      });
      final c = make();
      var opened = 0;
      final result = await c
          .read(startTripControllerProvider.notifier)
          .start(waiting, completeChecklist: () async {
        opened++;
        return true;
      });
      expect(opened, 1);
      expect(calls, 2);
      expect(result, isA<TripStarted>());
    });

    test('check left unfinished → no retry', () async {
      when(() => repo.startTrip(routeId: 'r-2', type: TripType.drop))
          .thenAnswer((_) async => throw const ApiError(
              status: 400, code: 'CHECKLIST_REQUIRED', message: 'Check'));
      final c = make();
      final result = await c
          .read(startTripControllerProvider.notifier)
          .start(waiting, completeChecklist: () async => false);
      expect(result, isA<ChecklistNotDone>());
      verify(() => repo.startTrip(routeId: 'r-2', type: TripType.drop))
          .called(1);
    });

    test(
        '409 TRIP_ALREADY_COMPLETED and TRIP_ALREADY_STARTED are their own results and reload home',
        () async {
      for (final (code, matcher) in [
        ('TRIP_ALREADY_COMPLETED', isA<TripAlreadyCompleted>()),
        ('TRIP_ALREADY_STARTED', isA<TripAlreadyStarted>()),
      ]) {
        when(() => repo.startTrip(routeId: 'r-2', type: TripType.drop))
            .thenAnswer((_) async =>
                throw ApiError(status: 409, code: code, message: 'x'));
        final c = make();
        c.listen(homeControllerProvider, (_, __) {});
        await c.read(homeControllerProvider.future);
        clearInteractions(repo);
        final result = await c
            .read(startTripControllerProvider.notifier)
            .start(waiting, completeChecklist: () async => fail('no check'));
        expect(result, matcher, reason: code);
        await c.read(homeControllerProvider.future);
        verify(() => repo.assignedRoutes()).called(1); // reloaded
      }
    });

    test('other failures come back as StartTripFailed', () async {
      when(() => repo.startTrip(routeId: 'r-2', type: TripType.drop))
          .thenAnswer((_) async =>
              throw const ApiError(status: 400, message: 'Too early'));
      final c = make();
      final result = await c
          .read(startTripControllerProvider.notifier)
          .start(waiting, completeChecklist: () async => true);
      expect(result, isA<StartTripFailed>());
      expect(
          ((result as StartTripFailed).error as ApiError).message, 'Too early');
      expect(c.read(startTripControllerProvider), isNull);
    });
  });
}
