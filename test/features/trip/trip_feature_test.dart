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
import 'package:smartvan_driver/features/trip/application/active_trip_provider.dart';
import 'package:smartvan_driver/features/trip/application/end_trip_controller.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/data/active_trip_store.dart';
import 'package:smartvan_driver/features/trip/data/models/active_trip.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip/presentation/screens/trip_screen.dart';
import 'package:smartvan_driver/features/trip/presentation/widgets/trip_map.dart';

import '../../support/fake_sync_queue.dart';
import '../../support/fake_tracking.dart';
import '../../support/l10n_host.dart';
import '../../support/memory_active_trip_store.dart';

class _FakePassengersRepo extends Mock implements PassengersRepository {}

class _FakeProfileRepo extends Mock implements ProfileRepository {}

void main() {
  late TrackingProbe probe;
  Set<Marker> mapMarkers = {};
  late _FakePassengersRepo passengersRepo;
  late _FakeProfileRepo profileRepo;
  late FakeSyncQueue queue;
  late MemoryActiveTripStore store;
  late List<Passenger> kids;

  final trip = ActiveTrip(
      id: 'trip-001',
      name: 'Sample School - Morning Pick',
      routeTitle: 'Sample School - Morning',
      type: TripType.pick,
      startTime: DateTime(2026, 10, 6, 12));

  setUp(() {
    probe = TrackingProbe();
    passengersRepo = _FakePassengersRepo();
    profileRepo = _FakeProfileRepo();
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
        syncQueueProvider.overrideWithValue(queue),
        activeTripStoreProvider.overrideWithValue(store),
        tripTrackingProvider.overrideWith(() => FakeTracking(
            tripId: trackedId,
            position: position,
            socketConnected: connected,
            isTracking: tracking,
            probe: probe)),
        tripMapBuilderProvider.overrideWithValue((context,
            {required target, required markers, required onCreated}) {
          mapMarkers = markers;
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
      final van = mapMarkers.single;
      expect(van.position, const LatLng(24.8607, 67.0011));
      expect(van.flat, isTrue);
      expect(van.anchor, const Offset(0.5, 0.5));
      expect(van.infoWindow.title, 'Your Location');
    });

    testWidgets('no marker until there is a GPS fix', (tester) async {
      await tester.pumpWidget(app(o: overrides(position: null)));
      await tester.pumpAndSettle();
      expect(mapMarkers, isEmpty);
    });

    testWidgets('touching the map stops following; Re-center resumes',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.text('Re-center'), findsNothing);
      // A bare spot of map: top middle, clear of the SOS button and the pill.
      await tester.tapAt(
          tester.getTopLeft(find.byKey(const Key('fake-map'))) +
              const Offset(400, 20));
      await tester.pump();
      expect(find.text('Re-center'), findsOneWidget);
      await tester.tap(find.text('Re-center'));
      await tester.pump();
      expect(find.text('Re-center'), findsNothing);
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
}
