import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/features/passengers/data/models/kid_trip_status.dart';
import 'package:smartvan_driver/features/passengers/data/models/passenger.dart';
import 'package:smartvan_driver/features/passengers/data/passengers_repository.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_profile.dart';
import 'package:smartvan_driver/features/profile/data/profile_repository.dart';
import 'package:smartvan_driver/features/rating/data/models/pending_ratee.dart';
import 'package:smartvan_driver/features/rating/data/rating_repository.dart';
import 'package:smartvan_driver/core/map/map_compass_button.dart';
import 'package:smartvan_driver/features/trip/application/active_trip_provider.dart';
import 'package:smartvan_driver/features/trip/application/end_trip_controller.dart';
import 'package:smartvan_driver/features/trip/application/optimize_route_controller.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/data/active_trip_store.dart';
import 'package:smartvan_driver/features/trip/data/models/active_trip.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/optimized_route.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';
import 'package:smartvan_driver/features/trip/data/models/route_plan.dart';
import 'package:smartvan_driver/features/trip/data/models/stop_status.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_trail.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip/application/stop_icons.dart';
import 'package:smartvan_driver/features/trip/presentation/screens/trip_screen.dart';
import 'package:smartvan_driver/features/trip/presentation/widgets/trip_map.dart';
import 'package:smartvan_driver/features/trip/presentation/widgets/trip_map_button.dart';

import '../../support/fake_sync_queue.dart';
import '../../support/fake_tracking.dart';
import '../../support/l10n_host.dart';
import '../../support/memory_active_trip_store.dart';

class _FakePassengersRepo extends Mock implements PassengersRepository {}

class _FakeProfileRepo extends Mock implements ProfileRepository {}

class _FakeRatingRepo extends Mock implements RatingRepository {}

class _FakeTripRepo extends Mock implements TripRepository {}

void main() {
  setUpAll(() => registerFallbackValue(const GeoPoint(lat: 0, lng: 0)));

  late TrackingProbe probe;
  Set<Marker> mapMarkers = {};
  Set<Polyline> mapPolylines = {};
  void Function(CameraPosition)? cameraMoved;
  late _FakePassengersRepo passengersRepo;
  late _FakeProfileRepo profileRepo;
  late _FakeRatingRepo ratingRepo;
  late _FakeTripRepo tripRepo;
  late List<Uri> launched;
  late bool launchFails;
  late FakeSyncQueue queue;
  late MemoryActiveTripStore store;
  late List<Passenger> kids;
  late RoutePlan plan;

  final trip = ActiveTrip(
      id: 'trip-001',
      name: 'Sample School - Morning Pick',
      routeTitle: 'Sample School - Morning',
      type: TripType.pick,
      startTime: DateTime(2026, 10, 6, 12));

  setUp(() {
    plan = const RoutePlan(
      nextStopOrder: 2,
      school: RoutePlanSchool(name: 'Test School', lat: 24.9, lng: 67.1),
      stops: [
        RoutePlanStop(
            order: 1,
            kidId: 'k1',
            fullname: 'One',
            lat: 24.81,
            lng: 67.01,
            status: StopStatus.picked),
        RoutePlanStop(
            order: 2,
            kidId: 'k2',
            fullname: 'Two',
            lat: 24.82,
            lng: 67.02,
            status: StopStatus.waiting),
      ],
      plannedPath: PlannedPath(polyline: '_p~iF~ps|U_ulLnnqC_mqNvxq`@'),
    );
    probe = TrackingProbe();
    passengersRepo = _FakePassengersRepo();
    profileRepo = _FakeProfileRepo();
    ratingRepo = _FakeRatingRepo();
    tripRepo = _FakeTripRepo();
    launched = [];
    launchFails = false;
    when(() => ratingRepo.pendingForTrip(any())).thenAnswer((_) async => []);
    when(() => tripRepo.routePlan(any())).thenAnswer((_) async => plan);
    when(() => tripRepo.trail(any())).thenAnswer(
        (_) async => const TripTrail(polyline: '_p~iF~ps|U_ulLnnqC'));
    queue = FakeSyncQueue();
    store = MemoryActiveTripStore();
    kids = [
      const Passenger(
          id: 'k1', fullname: 'One', tripStatus: KidTripStatus.picked),
      const Passenger(id: 'k2', fullname: 'Two'),
      const Passenger(
          id: 'k3', fullname: 'Three', tripStatus: KidTripStatus.dropped),
    ];
    when(() => passengersRepo.activePassengers()).thenAnswer((_) async => kids);
    when(() => passengersRepo.pendingStatuses(any())).thenReturn({});
    when(() => profileRepo.getProfile())
        .thenAnswer((_) async => const DriverProfile(fullname: 'Test Driver'));
  });

  List<Override> overrides({
    String? trackedId = 'trip-001',
    bool connected = true,
    bool? tracking,
    GeoPoint? position = const GeoPoint(lat: 24.8607, lng: 67.0011),
  }) =>
      [
        passengersRepositoryProvider.overrideWithValue(passengersRepo),
        profileRepositoryProvider.overrideWithValue(profileRepo),
        ratingRepositoryProvider.overrideWithValue(ratingRepo),
        tripRepositoryProvider.overrideWithValue(tripRepo),
        externalUrlLauncherProvider.overrideWithValue((uri) async {
          if (launchFails) throw Exception('no handler');
          launched.add(uri);
          return true;
        }),
        syncQueueProvider.overrideWithValue(queue),
        activeTripStoreProvider.overrideWithValue(store),
        tripTrackingProvider.overrideWith(() => FakeTracking(
            tripId: trackedId,
            position: position,
            socketConnected: connected,
            isTracking: tracking,
            probe: probe)),
        stopIconFactoryProvider.overrideWithValue((style,
                {required devicePixelRatio}) async =>
            BitmapDescriptor.defaultMarker),
        tripMapBuilderProvider.overrideWithValue((context,
            {required target,
            required markers,
            required polylines,
            required onCreated,
            required onCameraMove}) {
          mapMarkers = markers;
          mapPolylines = polylines;
          cameraMoved = onCameraMove;
          return Container(key: const Key('fake-map'), color: Colors.black12);
        }),
      ];

  group('activeTripFor', () {
    test('the tracked trip, the saved trip, or nothing', () {
      final tracked = ProviderContainer(overrides: overrides());
      addTearDown(tracked.dispose);
      expect(tracked.read(activeTripForProvider('trip-001'))?.id, 'trip-001');
      expect(tracked.read(activeTripForProvider('other')), isNull);

      store.saved = trip;
      final resumed = ProviderContainer(overrides: overrides(trackedId: null));
      addTearDown(resumed.dispose);
      expect(resumed.read(activeTripForProvider('trip-001')), trip);
      expect(resumed.read(activeTripForProvider('other')), isNull);
    });
  });

  group('EndTripController', () {
    ProviderContainer make() {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      c.listen(endTripControllerProvider, (_, __) {});
      return c;
    }

    test('ended', () async {
      final c = make();
      final r = await c.read(endTripControllerProvider.notifier).end();
      expect(r, isA<TripEnded>().having((e) => e.forced, 'forced', false));
      expect(probe.ends, 1);
      expect(c.read(endTripControllerProvider), isFalse);
    });

    test('force end passes the note', () async {
      final c = make();
      final r = await c
          .read(endTripControllerProvider.notifier)
          .end(forceEnd: true, note: 'Van checked');
      expect((r as TripEnded).forced, isTrue);
      expect(probe.lastForceEnd, isTrue);
      expect(probe.lastNote, 'Van checked');
    });

    test('unsynced updates', () async {
      probe.endError = PendingSyncException(2);
      final c = make();
      final r = await c.read(endTripControllerProvider.notifier).end();
      expect((r as UnsyncedUpdates).count, 2);
    });

    test('kids still on board', () async {
      probe.endError =
          const ApiError(code: 'KIDS_NOT_DROPPED', status: 409, data: {
        'kids': [
          {'kidId': 'k1', 'fullname': 'One'}
        ]
      });
      final c = make();
      final r = await c.read(endTripControllerProvider.notifier).end();
      expect((r as KidsStillOnBoard).kids.single.fullname, 'One');
    });

    test('other failures', () async {
      probe.endError = const NetworkException();
      final c = make();
      final r = await c.read(endTripControllerProvider.notifier).end();
      expect((r as EndTripFailed).error, isA<NetworkException>());
      expect(c.read(endTripControllerProvider), isFalse);
    });
  });

  Widget app({ActiveTrip? extra, List<Override>? o}) => routerHost(
        {
          '/trip/:tripId': (s) =>
              TripScreen(tripId: s.pathParameters['tripId']!, trip: extra),
          '/home': (_) => const Text('home-stub'),
          '/rate-trip/:tripId': (s) =>
              Text('rate-stub ${s.pathParameters['tripId']}'),
          '/passengers/:tripId': (_) => const Text('passengers-stub'),
          '/scan': (_) => const Text('scan-stub'),
        },
        initial: '/trip/trip-001',
        overrides: o ?? overrides(),
      );

  group('TripScreen', () {
    testWidgets('shows the trip, driver, route and passenger counts',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('fake-map')), findsOneWidget);
      expect(find.text('Sample School - Morning Pick'), findsOneWidget);
      expect(find.text('Live'), findsOneWidget);
      expect(find.text('3 Passengers'), findsOneWidget);
      expect(find.text('3 Pass.'), findsOneWidget);
      expect(find.text('Test Driver'), findsOneWidget);
      expect(
          find.text('School Route: Sample School - Morning'), findsOneWidget);
      expect(find.text('2/3'), findsOneWidget); // picked + dropped
      expect(find.text('Morning'), findsOneWidget); // pick = Morning
      expect(find.text('06/10/2026'), findsOneWidget);
      expect(find.text('End Trip'), findsOneWidget);
      expect(find.text('Scan student card'), findsOneWidget);
      expect(find.text('SOS'), findsOneWidget);
    });

    testWidgets('a drop trip is the Afternoon shift', (tester) async {
      final drop = trip.copyWith(type: TripType.drop);
      await tester.pumpWidget(app(extra: drop));
      await tester.pumpAndSettle();
      expect(find.text('Afternoon'), findsOneWidget);
      expect(find.text('Morning'), findsNothing);
    });

    testWidgets('no trip type and no start time show a dash', (tester) async {
      const bare = ActiveTrip(id: 'trip-001', routeTitle: 'R');
      await tester.pumpWidget(app(extra: bare));
      await tester.pumpAndSettle();
      expect(find.text('—'), findsNWidgets(2)); // shift and date
    });

    testWidgets('the van is a flat marker at the GPS position', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      final van = mapMarkers.singleWhere((m) => m.markerId.value == 'van');
      expect(van.position, const LatLng(24.8607, 67.0011));
      expect(van.flat, isTrue);
      expect(van.anchor, const Offset(0.5, 0.5));
      expect(van.infoWindow.title, 'Your Location');
    });

    testWidgets('no marker until there is a GPS fix', (tester) async {
      await tester.pumpWidget(app(o: overrides(position: null)));
      await tester.pumpAndSettle();
      expect(mapMarkers.where((m) => m.markerId.value == 'van'), isEmpty);
    });

    testWidgets('numbered stops, the school and both lines are on the map',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      final ids = mapMarkers.map((m) => m.markerId.value).toSet();
      expect(ids, containsAll(['van', 'school', 'stop-1-k1', 'stop-2-k2']));
      expect(
          mapMarkers
              .singleWhere((m) => m.markerId.value == 'school')
              .infoWindow
              .title,
          'Test School');
      expect(mapPolylines.map((l) => l.polylineId.value),
          unorderedEquals(['planned', 'trail']));
      verify(() => tripRepo.routePlan('trip-001')).called(1);
      verify(() => tripRepo.trail('trip-001')).called(1);
    });

    testWidgets('a failing plan still shows the van', (tester) async {
      when(() => tripRepo.routePlan(any())).thenThrow(Exception('boom'));
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(mapMarkers.map((m) => m.markerId.value), ['van']);
    });

    testWidgets('touching the map stops following; Re-center resumes',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.text('Re-center'), findsNothing);
      // A bare spot of map: top middle, clear of the SOS button and the pill.
      await tester.tapAt(tester.getTopLeft(find.byKey(const Key('fake-map'))) +
          const Offset(400, 20));
      await tester.pump();
      expect(find.text('Re-center'), findsOneWidget);
      await tester.tap(find.text('Re-center'));
      await tester.pump();
      expect(find.text('Re-center'), findsNothing);
    });

    group('compass', () {
      Finder north() => find.bySemanticsLabel('Point map north');
      Finder rotate() => find.bySemanticsLabel('Rotate map with van');

      Future<void> touchMap(WidgetTester tester) async {
        await tester.tapAt(
            tester.getTopLeft(find.byKey(const Key('fake-map'))) +
                const Offset(400, 20));
        await tester.pump();
      }

      void cameraAt(double bearing) => cameraMoved!(CameraPosition(
          target: const LatLng(24.86, 67.0), zoom: 15, bearing: bearing));

      testWidgets('is always on the map, even while following', (tester) async {
        await tester.pumpWidget(app());
        await tester.pumpAndSettle();
        expect(find.byType(MapCompassButton), findsOneWidget);
        expect(find.text('Re-center'), findsNothing);
      });

      testWidgets('the needle follows the camera bearing', (tester) async {
        await tester.pumpWidget(app());
        await tester.pumpAndSettle();
        cameraAt(90);
        await tester.pump();
        final turns = tester
            .widget<AnimatedRotation>(find.byKey(const Key('compass-needle')))
            .turns;
        expect(turns, closeTo(-0.25, 1e-9));
      });

      testWidgets('its label says what a tap does', (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(app());
        await tester.pumpAndSettle();
        cameraAt(0);
        await tester.pump();
        expect(rotate(), findsOneWidget, reason: 'north + following');
        cameraAt(60);
        await tester.pump();
        expect(north(), findsOneWidget, reason: 'turned: first back to north');
        handle.dispose();
      });

      testWidgets('tap on a north map: heading-up arrow; tap again: needle',
          (tester) async {
        await tester.pumpWidget(app());
        await tester.pumpAndSettle();
        cameraAt(0);
        await tester.pump();
        await tester.tap(find.byType(MapCompassButton));
        await tester.pump();
        expect(find.byKey(const Key('compass-heading-up')), findsOneWidget);
        expect(find.byKey(const Key('compass-needle')), findsNothing);

        await tester.tap(find.byType(MapCompassButton));
        await tester.pump();
        expect(find.byKey(const Key('compass-needle')), findsOneWidget);
      });

      testWidgets('touching the map ends heading-up and shows Re-center',
          (tester) async {
        await tester.pumpWidget(app());
        await tester.pumpAndSettle();
        cameraAt(0);
        await tester.pump();
        await tester.tap(find.byType(MapCompassButton));
        await tester.pump();
        await touchMap(tester);
        expect(find.byKey(const Key('compass-needle')), findsOneWidget);
        expect(find.text('Re-center'), findsOneWidget);
        expect(find.byType(MapCompassButton), findsOneWidget,
            reason: 'the compass stays next to Re-center');
      });

      testWidgets('when not following a tap only points north (no heading-up)',
          (tester) async {
        await tester.pumpWidget(app());
        await tester.pumpAndSettle();
        await touchMap(tester);
        cameraAt(0);
        await tester.pump();
        await tester.tap(find.byType(MapCompassButton));
        await tester.pump();
        expect(find.byKey(const Key('compass-heading-up')), findsNothing);
      });
    });

    testWidgets('offline pill, and defaults when nothing else is known',
        (tester) async {
      await tester.pumpWidget(app(o: overrides(connected: false)));
      await tester.pumpAndSettle();
      expect(find.text('Offline'), findsOneWidget);
    });

    testWidgets('tracking is started with the trip', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(probe.started.single.id, 'trip-001');
    });

    testWidgets('permission problems show a message', (tester) async {
      probe.startResult = TrackingStartResult.permissionDeniedForever;
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(
          find.text(
              'Location permission permanently denied. Enable it in app settings.'),
          findsOneWidget);
    });

    testWidgets('location off banner turns tracking on again', (tester) async {
      await tester.pumpWidget(app(o: overrides(tracking: false)));
      await tester.pumpAndSettle();
      expect(find.text("Location sharing is off — parents can't see the van."),
          findsOneWidget);
      probe.started.clear();
      await tester.tap(find.text('Turn on'));
      await tester.pumpAndSettle();
      expect(probe.started, hasLength(1));
    });

    testWidgets('queued updates banner is plural-aware and live',
        (tester) async {
      queue.pending.value = 1;
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.text('1 update saved offline — will sync automatically.'),
          findsOneWidget);
      queue.pending.value = 3;
      await tester.pump();
      expect(find.text('3 updates saved offline — will sync automatically.'),
          findsOneWidget);
      queue.pending.value = 0;
      await tester.pump();
      expect(find.textContaining('saved offline'), findsNothing);
    });

    testWidgets('the passengers pill and scan button navigate', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('3 Passengers'));
      await tester.pumpAndSettle();
      expect(find.text('passengers-stub'), findsOneWidget);
    });

    testWidgets('scan opens the scanner', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Scan student card'));
      await tester.pumpAndSettle();
      expect(find.text('scan-stub'), findsOneWidget);
    });

    testWidgets('End Trip asks first, then ends and goes home', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip'));
      await tester.pumpAndSettle();
      expect(
          find.text('Are you sure you want to end this trip?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(probe.ends, 0);

      await tester.tap(find.text('End Trip'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip').last);
      await tester.pumpAndSettle();
      expect(probe.ends, 1);
      expect(find.text('home-stub'), findsOneWidget);
    });

    Future<void> endTrip(WidgetTester tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip').last);
      await tester.pumpAndSettle();
    }

    testWidgets('parents still to rate: ending goes to rating, not home',
        (tester) async {
      when(() => ratingRepo.pendingForTrip('trip-001')).thenAnswer((_) async =>
          [const PendingRatee(tripId: 'trip-001', parentId: 'p-1')]);
      await endTrip(tester);
      expect(probe.ends, 1);
      expect(find.text('rate-stub trip-001'), findsOneWidget);
      expect(find.text('home-stub'), findsNothing);
    });

    testWidgets('a failed pending-ratings check still goes home',
        (tester) async {
      when(() => ratingRepo.pendingForTrip(any()))
          .thenAnswer((_) async => throw const NetworkException());
      await endTrip(tester);
      expect(probe.ends, 1);
      expect(find.text('home-stub'), findsOneWidget);
    });

    testWidgets('unsynced updates block ending with a message', (tester) async {
      probe.endError = PendingSyncException(1);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip').last);
      await tester.pumpAndSettle();
      expect(
          find.text(
              '1 pickup/drop update not synced yet. Connect to the internet, wait for sync, then end the trip.'),
          findsOneWidget);
      expect(find.text('home-stub'), findsNothing);
    });

    testWidgets('a failed end shows why', (tester) async {
      probe.endError =
          const ApiError(status: 400, message: 'Trip already ended');
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip').last);
      await tester.pumpAndSettle();
      expect(find.text('Trip already ended'), findsOneWidget);
    });

    Future<void> endWithKidsOnBoard(WidgetTester tester) async {
      probe.endError =
          const ApiError(code: 'KIDS_NOT_DROPPED', status: 409, data: {
        'kids': [
          {'kidId': 'k1', 'fullname': 'Test Kid One'},
          {'kidId': 'k2', 'fullname': 'Test Kid Two'},
        ]
      });
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Trip').last);
      await tester.pumpAndSettle();
    }

    testWidgets('kids still in the van: the safe action goes to passengers',
        (tester) async {
      await endWithKidsOnBoard(tester);
      expect(
          find.text('2 students are still marked in the van'), findsOneWidget);
      expect(find.text('Test Kid One'), findsOneWidget);
      expect(find.text('Please check every seat before ending the trip.'),
          findsOneWidget);
      await tester.tap(find.text('Go to passengers and drop them'));
      await tester.pumpAndSettle();
      expect(find.text('passengers-stub'), findsOneWidget);
    });

    testWidgets(
        'kids still in the van: force end needs the check box and a real note',
        (tester) async {
      await endWithKidsOnBoard(tester);
      await tester.tap(find.text('They are not in the van — end trip anyway'));
      await tester.pumpAndSettle();
      final endButton =
          find.widgetWithText(ElevatedButton, 'End trip and alert school');
      expect(tester.widget<ElevatedButton>(endButton).onPressed, isNull);
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pump();
      expect(tester.widget<ElevatedButton>(endButton).onPressed, isNull);
      await tester.enterText(
          find.byType(TextField), 'Parent collected him at school');
      await tester.pump();
      probe.endError = null;
      await tester.tap(endButton);
      await tester.pumpAndSettle();
      expect(probe.lastForceEnd, isTrue);
      expect(probe.lastNote, 'Parent collected him at school');
      expect(find.text('home-stub'), findsOneWidget);
    });

    testWidgets('a trip this phone does not know says so', (tester) async {
      await tester.pumpWidget(routerHost(
        {
          '/trip/:tripId': (s) =>
              TripScreen(tripId: s.pathParameters['tripId']!),
          '/home': (_) => const Text('home-stub'),
        },
        initial: '/trip/ghost',
        overrides: overrides(),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Trip not found'), findsOneWidget);
      await tester.tap(find.text('Back to home'));
      await tester.pumpAndSettle();
      expect(find.text('home-stub'), findsOneWidget);
    });

    testWidgets('after the app was killed, the saved trip is resumed',
        (tester) async {
      store.saved = trip;
      await tester.pumpWidget(app(o: overrides(trackedId: null)));
      await tester.pumpAndSettle();
      expect(find.text('Sample School - Morning Pick'), findsOneWidget);
      expect(probe.started.single, trip);
    });

    testWidgets('the passed-in trip wins and is what tracking starts',
        (tester) async {
      await tester.pumpWidget(app(
          extra: const ActiveTrip(id: 'trip-001', name: 'Fresh from Home'),
          o: overrides(trackedId: null)));
      await tester.pumpAndSettle();
      expect(find.text('Fresh from Home'), findsOneWidget);
      expect(probe.started.single.name, 'Fresh from Home');
    });
  });

  group('Optimize route', () {
    const origin = GeoPoint(lat: 24.8607, lng: 67.0011);
    const route = OptimizedRoute(
      origin: origin,
      destination: GeoPoint(lat: 24.95, lng: 67.2),
      stops: [
        OptimizedStop(
            sequence: 1, kidName: 'Test Kid Two', lat: 24.9, lng: 67.1),
        OptimizedStop(sequence: 2, lat: 24.91, lng: 67.12),
      ],
      distanceSavedMeters: 2600,
      durationSavedSeconds: 480,
    );

    setUp(() {
      when(() => tripRepo.optimizeRoute(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'))).thenAnswer((_) async => route);
    });

    Future<void> tapOptimize(WidgetTester tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Optimize'));
      await tester.pumpAndSettle();
    }

    test('controller: sends the trip and position, one request at a time',
        () async {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      c.listen(optimizeRouteControllerProvider, (_, __) {});
      final r = await c
          .read(optimizeRouteControllerProvider.notifier)
          .optimize(tripId: 'trip-001', position: origin);
      expect((r as RouteOptimized).route, route);
      verify(() => tripRepo.optimizeRoute(tripId: 'trip-001', position: origin))
          .called(1);
      expect(c.read(optimizeRouteControllerProvider), isFalse);
    });

    test('controller: a failure is a result, and a second tap is ignored',
        () async {
      final gate = Completer<OptimizedRoute>();
      when(() => tripRepo.optimizeRoute(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'))).thenAnswer((_) => gate.future);
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      c.listen(optimizeRouteControllerProvider, (_, __) {});
      final notifier = c.read(optimizeRouteControllerProvider.notifier);
      final first = notifier.optimize(tripId: 'trip-001', position: origin);
      expect(c.read(optimizeRouteControllerProvider), isTrue);
      expect(await notifier.optimize(tripId: 'trip-001', position: origin),
          isNull);
      gate.completeError(const NetworkException());
      expect(await first, isA<OptimizeRouteFailed>());
      expect(c.read(optimizeRouteControllerProvider), isFalse);
    });

    testWidgets('the button asks from the van position and shows the sheet',
        (tester) async {
      await tapOptimize(tester);
      verify(() => tripRepo.optimizeRoute(tripId: 'trip-001', position: origin))
          .called(1);
      expect(find.text('Suggested Stop Order'), findsOneWidget);
      expect(
          find.text(
              'Following this order saves about 8 min and 2.6 km versus the planned order.'),
          findsOneWidget);
      expect(find.text('Test Kid Two'), findsOneWidget);
      expect(find.text('Student'), findsOneWidget); // a stop without a name
      expect(find.text('1'), findsWidgets);
      expect(find.text('Open in Google Maps'), findsOneWidget);
    });

    testWidgets('no savings: says the planned order is already good',
        (tester) async {
      when(() => tripRepo.optimizeRoute(
              tripId: any(named: 'tripId'), position: any(named: 'position')))
          .thenAnswer((_) async =>
              route.copyWith(distanceSavedMeters: 0, durationSavedSeconds: 0));
      await tapOptimize(tester);
      expect(
          find.text(
              'The planned order is already close to optimal for your current position.'),
          findsOneWidget);
    });

    testWidgets('Open in Google Maps hands the directions link over',
        (tester) async {
      await tapOptimize(tester);
      await tester.tap(find.text('Open in Google Maps'));
      await tester.pumpAndSettle();
      expect(launched.single.queryParameters, {
        'api': '1',
        'origin': '24.8607,67.0011',
        'destination': '24.95,67.2',
        'waypoints': '24.9,67.1|24.91,67.12',
        'travelmode': 'driving',
      });
    });

    testWidgets('a launcher that throws shows the message', (tester) async {
      launchFails = true;
      await tapOptimize(tester);
      await tester.tap(find.text('Open in Google Maps'));
      await tester.pumpAndSettle();
      expect(find.text('Could not open Google Maps.'), findsOneWidget);
    });

    testWidgets('"I\'ll use my own order" just closes the sheet',
        (tester) async {
      await tapOptimize(tester);
      await tester.tap(find.text("I'll use my own order"));
      await tester.pumpAndSettle();
      expect(find.text('Suggested Stop Order'), findsNothing);
      expect(launched, isEmpty);
      expect(find.text('Optimize'), findsOneWidget);
    });

    testWidgets('a failure shows the message and no sheet', (tester) async {
      when(() => tripRepo.optimizeRoute(
              tripId: any(named: 'tripId'), position: any(named: 'position')))
          .thenAnswer((_) async => throw const NetworkException());
      await tapOptimize(tester);
      expect(find.text('Could not optimize this route right now.'),
          findsOneWidget);
      expect(find.text('Suggested Stop Order'), findsNothing);
    });

    testWidgets('while it loads the button shows a spinner', (tester) async {
      final gate = Completer<OptimizedRoute>();
      when(() => tripRepo.optimizeRoute(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'))).thenAnswer((_) => gate.future);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Optimize'));
      await tester.pump();
      expect(
          find.descendant(
              of: find.ancestor(
                  of: find.text('Optimize'),
                  matching: find.byType(TripMapButton)),
              matching: find.byType(CircularProgressIndicator)),
          findsOneWidget);
      await tester.tap(find.text('Optimize'), warnIfMissed: false);
      verify(() => tripRepo.optimizeRoute(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'))).called(1);
      gate.complete(route);
      await tester.pumpAndSettle();
    });
  });
}
