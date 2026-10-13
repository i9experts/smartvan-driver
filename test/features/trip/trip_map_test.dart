import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/features/passengers/application/passengers_controller.dart';
import 'package:smartvan_driver/features/passengers/data/models/kid_trip_status.dart';
import 'package:smartvan_driver/features/passengers/data/models/passenger.dart';
import 'package:smartvan_driver/features/passengers/data/passengers_repository.dart';
import 'package:smartvan_driver/features/trip/application/tracking_state.dart';
import 'package:smartvan_driver/features/trip/application/trip_map_controller.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/route_plan.dart';
import 'package:smartvan_driver/features/trip/data/models/stop_status.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_trail.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';
import 'package:smartvan_driver/features/trip/presentation/widgets/trip_map_layers.dart';

import '../../support/api_env.dart';
import '../../support/fake_sync_queue.dart';

class _TripRepo extends Mock implements TripRepository {}

class _PassengersRepo extends Mock implements PassengersRepository {}

/// Tracking whose position the test moves.
class _MovingTracking extends TripTracking {
  @override
  TripTrackingState build() => const TripTrackingState();

  void moveTo(double lat, double lng) =>
      state = state.copyWith(lastPosition: GeoPoint(lat: lat, lng: lng));
}

Map<String, dynamic> _planJson() => {
      'type': 'pick',
      'status': 'ongoing',
      'nextStopOrder': 2,
      'school': {'name': 'Saima Paari Star', 'lat': 24.9, 'lng': 67.1},
      'stops': [
        {
          'order': 1,
          'kidId': 'k1',
          'fullname': 'One',
          'lat': 24.81,
          'lng': 67.01,
          'status': 'picked'
        },
        {
          'order': 2,
          'kidId': 'k2',
          'fullname': 'Two',
          'lat': 24.82,
          'lng': 67.02,
          'status': 'waiting'
        },
        {
          'order': 3,
          'kidId': 'k3',
          'fullname': 'Three',
          'lat': 24.83,
          'lng': 67.03,
          'status': 'no_show'
        },
        {
          'order': 4,
          'kidId': 'k4',
          'fullname': 'Four',
          'lat': 24.84,
          'lng': 67.04,
          'status': 'absent'
        },
        {
          'order': 5,
          'kidId': 'k5',
          'fullname': 'Five',
          'lat': 24.85,
          'lng': 67.05,
          'status': 'dropped'
        },
      ],
      'plannedPath': {
        'polyline': '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
        'distanceMeters': 1000,
        'durationSeconds': 600,
        'legs': [],
      },
    };

void main() {
  group('models', () {
    test('RoutePlan reads stops, school, status and the path', () {
      final plan = RoutePlan.fromJson(_planJson());
      expect(plan.nextStopOrder, 2);
      expect(plan.stops.map((s) => s.status), [
        StopStatus.picked,
        StopStatus.waiting,
        StopStatus.noShow,
        StopStatus.absent,
        StopStatus.dropped,
      ]);
      expect(plan.stops[1].lat, 24.82);
      expect(plan.stops[1].lng, 67.02);
      expect(plan.school?.name, 'Saima Paari Star');
      expect(plan.plannedPath?.polyline, startsWith('_p~iF'));
    });

    test('a missing path, school or an unknown status do not break it', () {
      final plan = RoutePlan.fromJson({
        'stops': [
          {'order': 1, 'lat': 1, 'long': 2, 'status': 'teleported'},
          {'order': 2, 'status': 'waiting'},
        ],
        'plannedPath': null,
      });
      expect(plan.plannedPath, isNull);
      expect(plan.school, isNull);
      expect(plan.stops.first.status, StopStatus.unknown);
      expect(plan.stops.first.lng, 2);
      expect(plan.drawableStops, hasLength(1));
    });

    test('stops and school at 0, 0 (home never set) are not drawn', () {
      final plan = RoutePlan.fromJson({
        'school': {'name': 'S', 'lat': 0, 'lng': 0},
        'stops': [
          {'order': 1, 'lat': 0, 'lng': 0, 'status': 'waiting'},
          {'order': 2, 'lat': 24.8, 'lng': 67.0, 'status': 'waiting'},
        ],
      });
      expect(plan.drawableStops.map((s) => s.order), [2]);
      expect(
          planMarkers(plan, icons: const {}, schoolTitle: 'School')
              .map((m) => m.markerId.value),
          ['stop-2-']);
    });

    test('TripTrail reads the polyline', () {
      expect(
          TripTrail.fromJson({'polyline': 'abc', 'points': 3}).polyline, 'abc');
    });
  });

  group('repository', () {
    late ApiTestEnv env;
    late TripRepository repo;

    setUp(() {
      env = ApiTestEnv();
      repo = TripRepository(env.client, FakeSyncQueue());
    });

    test('routePlan GETs /trips/:id/route-plan and unwraps data', () async {
      env.adapter.onGet('/trips/t1/route-plan',
          (s) => s.reply(200, {'success': true, 'data': _planJson()}));
      final plan = await repo.routePlan('t1');
      expect(plan.stops, hasLength(5));
    });

    test('trail GETs /trips/:id/trail and unwraps data', () async {
      env.adapter.onGet(
          '/trips/t1/trail',
          (s) => s.reply(200, {
                'success': true,
                'data': {'polyline': 'xyz', 'points': 2}
              }));
      expect((await repo.trail('t1')).polyline, 'xyz');
    });
  });

  group('layers', () {
    test('pin colours follow the status; absent and no-show are crossed', () {
      final plan = RoutePlan.fromJson(_planJson());
      final styles = {
        for (final s in plan.stops) s.order: stopStyle(s, plan.nextStopOrder)
      };
      expect(styles[1]!.color, const Color(0xFF27AE60)); // picked: green
      expect(styles[2]!.color, const Color(0xFFFEC610)); // waiting: yellow
      expect(styles[3]!.color, const Color(0xFFEB5757)); // no-show: red
      expect(styles[4]!.color, const Color(0xFFEB5757)); // absent: red
      expect(styles[5]!.color, const Color(0xFF9AA3B2)); // dropped: grey
      expect(styles.values.where((s) => s.crossedOut).map((s) => s.number),
          [3, 4]);
    });

    test('only the next stop is highlighted', () {
      final plan = RoutePlan.fromJson(_planJson());
      final highlighted = plan.stops
          .where((s) => stopStyle(s, plan.nextStopOrder).highlighted)
          .map((s) => s.order);
      expect(highlighted, [2]);
    });

    test('markers: one per stop plus the school; icon missing → default', () {
      final plan = RoutePlan.fromJson(_planJson());
      final iconA = BitmapDescriptor.defaultMarkerWithHue(10);
      final next = stopStyle(plan.stops[1], plan.nextStopOrder);
      final markers =
          planMarkers(plan, icons: {next: iconA}, schoolTitle: 'School');
      expect(markers, hasLength(6));
      final two =
          markers.firstWhere((m) => m.markerId.value.startsWith('stop-2'));
      expect(two.icon, iconA);
      expect(two.zIndex, greaterThan(0.5));
      expect(two.position, const LatLng(24.82, 67.02));
      final school = markers.firstWhere((m) => m.markerId.value == 'school');
      expect(school.infoWindow.title, 'Saima Paari Star');
    });

    test('lines: planned (blue) below, trail (navy) on top', () {
      final plan = RoutePlan.fromJson(_planJson());
      final lines = mapLines(plan: plan, trail: const [
        LatLng(1, 1),
        LatLng(1.1, 1.1),
      ]);
      final planned = lines.firstWhere((l) => l.polylineId.value == 'planned');
      final trail = lines.firstWhere((l) => l.polylineId.value == 'trail');
      expect(planned.points, hasLength(3));
      expect(planned.color, planLineColor);
      expect(trail.color, trailLineColor);
      expect(trail.zIndex, greaterThan(planned.zIndex));
    });

    test('no plan and a one-point trail draw no lines', () {
      expect(mapLines(), isEmpty);
      expect(mapLines(trail: const [LatLng(1, 1)]), isEmpty);
    });
  });

  group('controllers', () {
    late _TripRepo tripRepo;
    late _PassengersRepo passengersRepo;
    late List<Passenger> kids;
    late int planCalls;

    setUp(() {
      tripRepo = _TripRepo();
      passengersRepo = _PassengersRepo();
      kids = [const Passenger(id: 'k1', fullname: 'One')];
      planCalls = 0;
      when(() => tripRepo.routePlan('t1')).thenAnswer((_) async {
        planCalls++;
        return RoutePlan.fromJson(_planJson());
      });
      when(() => tripRepo.trail('t1')).thenAnswer(
          (_) async => const TripTrail(polyline: '_p~iF~ps|U_ulLnnqC'));
      when(() => passengersRepo.activePassengers())
          .thenAnswer((_) async => kids);
      when(() => passengersRepo.pendingStatuses(any())).thenReturn({});
    });

    ProviderContainer make() {
      final c = ProviderContainer(overrides: [
        tripRepositoryProvider.overrideWithValue(tripRepo),
        passengersRepositoryProvider.overrideWithValue(passengersRepo),
        tripTrackingProvider.overrideWith(_MovingTracking.new),
      ]);
      addTearDown(c.dispose);
      return c;
    }

    test('the plan loads, then reloads every 60 seconds', () {
      fakeAsync((async) {
        final c = make();
        c.listen(routePlanControllerProvider('t1'), (_, __) {});
        async.flushMicrotasks();
        expect(planCalls, 1);
        async.elapse(const Duration(seconds: 59));
        expect(planCalls, 1);
        async.elapse(const Duration(seconds: 2));
        async.flushMicrotasks();
        expect(planCalls, 2);
        async.elapse(const Duration(seconds: 60));
        async.flushMicrotasks();
        expect(planCalls, 3);
      });
    });

    test('a pick / drop / no-show reloads the plan, an unchanged list not',
        () async {
      final c = make();
      c.listen(routePlanControllerProvider('t1'), (_, __) {});
      c.listen(passengersControllerProvider('t1'), (_, __) {});
      await c.read(routePlanControllerProvider('t1').future);
      await c.read(passengersControllerProvider('t1').future);
      expect(planCalls, 1);

      await c.read(passengersControllerProvider('t1').notifier).refresh();
      expect(planCalls, 1, reason: 'nothing changed');

      kids = [
        const Passenger(
            id: 'k1', fullname: 'One', tripStatus: KidTripStatus.picked)
      ];
      await c.read(passengersControllerProvider('t1').notifier).refresh();
      await pumpEventQueue();
      expect(planCalls, 2);

      kids = [
        const Passenger(
            id: 'k1',
            fullname: 'One',
            tripStatus: KidTripStatus.picked,
            noShow: true)
      ];
      await c.read(passengersControllerProvider('t1').notifier).refresh();
      await pumpEventQueue();
      expect(planCalls, 3);
    });

    test('a failed reload keeps the plan on the map', () async {
      final c = make();
      c.listen(routePlanControllerProvider('t1'), (_, __) {});
      await c.read(routePlanControllerProvider('t1').future);
      when(() => tripRepo.routePlan('t1')).thenThrow(Exception('offline'));
      await c.read(routePlanControllerProvider('t1').notifier).reload();
      expect(c.read(routePlanControllerProvider('t1')).valueOrNull?.stops,
          hasLength(5));
    });

    test('the trail starts from the server and grows with every live fix',
        () async {
      final c = make();
      c.listen(tripTrailControllerProvider('t1'), (_, __) {});
      final start = await c.read(tripTrailControllerProvider('t1').future);
      expect(start, hasLength(2));

      final tracking = c.read(tripTrackingProvider.notifier) as _MovingTracking;
      tracking.moveTo(43.3, -126.5);
      expect(c.read(tripTrailControllerProvider('t1')).value, hasLength(3));
      tracking.moveTo(43.3, -126.5); // same spot: not added again
      expect(c.read(tripTrailControllerProvider('t1')).value, hasLength(3));
      tracking.moveTo(43.301, -126.5);
      expect(c.read(tripTrailControllerProvider('t1')).value, hasLength(4));
      expect(c.read(tripTrailControllerProvider('t1')).value!.last,
          const LatLng(43.301, -126.5));
    });
  });
}
