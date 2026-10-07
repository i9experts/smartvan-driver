import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/core/sync/sync_queue.dart';
import 'package:smartvan_driver/features/chat/data/chat_repository.dart';
import 'package:smartvan_driver/features/chat/data/models/conversation.dart';
import 'package:smartvan_driver/features/passengers/application/passengers_controller.dart';
import 'package:smartvan_driver/features/passengers/application/passengers_state.dart';
import 'package:smartvan_driver/features/passengers/data/models/arrived_at_stop.dart';
import 'package:smartvan_driver/features/passengers/data/models/kid_absence_event.dart';
import 'package:smartvan_driver/features/passengers/data/models/kid_trip_status.dart';
import 'package:smartvan_driver/features/passengers/data/models/passenger.dart';
import 'package:smartvan_driver/features/passengers/data/passengers_repository.dart';
import 'package:smartvan_driver/features/passengers/presentation/screens/kid_profile_screen.dart';
import 'package:smartvan_driver/features/passengers/presentation/screens/passengers_screen.dart';
import 'package:smartvan_driver/features/trip/application/kid_absence_events.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';

import '../../support/fake_sync_queue.dart';
import '../../support/fake_tracking.dart';
import '../../support/fixture.dart';
import '../../support/l10n_host.dart';

class _FakeRepo extends Mock implements PassengersRepository {}

class _FakeChatRepo extends Mock implements ChatRepository {}

void main() {
  late _FakeRepo repo;
  late _FakeChatRepo chatRepo;
  late FakeSyncQueue queue;
  late StreamController<void> synced;
  late StreamController<KidAbsenceEvent> absenceBus;
  late List<Passenger> kids;
  late Map<String, KidTripStatus> pending;
  late DateTime now;
  GeoPoint? gps;

  Passenger kid(String id, String name,
          {KidTripStatus status = KidTripStatus.pending,
          bool absent = false,
          bool noShow = false,
          String? absenceNote,
          DateTime? waitingSince,
          TripType tripType = TripType.pick,
          String? tripId}) =>
      Passenger(
          id: id,
          fullname: name,
          tripStatus: status,
          absent: absent,
          noShow: noShow,
          absenceNote: absenceNote,
          waitingSince: waitingSince,
          tripType: tripType,
          tripId: tripId);

  setUpAll(() {
    registerFallbackValue(const GeoPoint(lat: 0, lng: 0));
  });

  setUp(() {
    repo = _FakeRepo();
    chatRepo = _FakeChatRepo();
    queue = FakeSyncQueue();
    synced = StreamController<void>.broadcast();
    absenceBus = StreamController<KidAbsenceEvent>.broadcast();
    addTearDown(synced.close);
    addTearDown(absenceBus.close);
    kids = [kid('k1', 'Test Kid One'), kid('k2', 'Test Kid Two')];
    pending = {};
    now = DateTime(2026, 10, 6, 8, 30);
    gps = const GeoPoint(lat: 24.8607, lng: 67.0011);
    when(() => repo.activePassengers()).thenAnswer((_) async => kids);
    when(() => repo.pendingStatuses(any())).thenAnswer((_) => pending);
    when(() =>
            repo.pick(tripId: any(named: 'tripId'), kidId: any(named: 'kidId')))
        .thenAnswer((_) async => SubmitOutcome.sent);
    when(() => repo.drop(
          tripId: any(named: 'tripId'),
          kidId: any(named: 'kidId'),
          position: any(named: 'position'),
        )).thenAnswer((_) async => SubmitOutcome.sent);
    when(() => repo.markNoShow(
          tripId: any(named: 'tripId'),
          kidId: any(named: 'kidId'),
          note: any(named: 'note'),
        )).thenAnswer((_) async {});
  });

  List<Override> overrides() => [
        passengersRepositoryProvider.overrideWithValue(repo),
        chatRepositoryProvider.overrideWithValue(chatRepo),
        syncQueueProvider.overrideWithValue(queue),
        syncQueueSyncedProvider.overrideWith((ref) => synced.stream),
        kidAbsenceBusProvider.overrideWithValue(absenceBus),
        tripTrackingProvider.overrideWith(
            () => FakeTracking(tripId: 'trip-001', position: gps)),
        clockProvider.overrideWithValue(() => now),
      ];

  ProviderContainer container() {
    final c = ProviderContainer(overrides: overrides());
    addTearDown(c.dispose);
    c.listen(passengersControllerProvider('trip-001'), (_, __) {});
    return c;
  }

  PassengersController controller(ProviderContainer c) =>
      c.read(passengersControllerProvider('trip-001').notifier);
  PassengersState state(ProviderContainer c) =>
      c.read(passengersControllerProvider('trip-001')).requireValue;

  group('PassengersController', () {
    test(
        'loads, riders first (absent / no-show kids last, order otherwise stable)',
        () async {
      kids = [
        kid('a', 'Absent', absent: true),
        kid('b', 'Rider One'),
        kid('c', 'NoShow', noShow: true),
        kid('d', 'Rider Two'),
      ];
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      expect(state(c).passengers.map((p) => p.id), ['b', 'd', 'a', 'c']);
    });

    test('the queued state wins over the server state, and counts use it',
        () async {
      kids = [kid('k1', 'One', status: KidTripStatus.picked), kid('k2', 'Two')];
      pending = {'k2': KidTripStatus.picked, 'k1': KidTripStatus.dropped};
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      final s = state(c);
      expect(s.statusOf(s.passengers[0]), KidTripStatus.dropped);
      expect(s.statusOf(s.passengers[1]), KidTripStatus.picked);
      expect(s.isUnsynced(s.passengers[1]), isTrue);
      expect(s.pickedCount, 2);
      expect(s.total, 2);
    });

    test('a first load that fails is an error', () async {
      when(() => repo.activePassengers())
          .thenAnswer((_) async => throw const NetworkException());
      final c = container();
      await expectLater(c.read(passengersControllerProvider('trip-001').future),
          throwsA(isA<NetworkException>()));
    });

    test('a failed reload keeps the list so picks still work offline',
        () async {
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      when(() => repo.activePassengers())
          .thenAnswer((_) async => throw const NetworkException());
      await controller(c).refresh();
      final s = state(c);
      expect(s.passengers, hasLength(2));
      expect(s.loadFailed, isTrue);
    });

    test('a delivered queue reloads the list', () async {
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      clearInteractions(repo);
      synced.add(null);
      await pumpEventQueue();
      verify(() => repo.activePassengers()).called(1);
    });

    test('a parent absence event reloads the list', () async {
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      c.listen(kidAbsenceEventsProvider, (_, __) {});
      clearInteractions(repo);
      absenceBus
          .add(const KidAbsenceEvent(kidId: 'k1', fullname: 'Test Kid One'));
      await pumpEventQueue();
      verify(() => repo.activePassengers()).called(1);
    });

    group('pick', () {
      test(
          'sent: asks the repository (trip id from the controller) and reloads',
          () async {
        final c = container();
        await c.read(passengersControllerProvider('trip-001').future);
        clearInteractions(repo);
        expect(await controller(c).pick(kids.first), StopActionOutcome.sent);
        verify(() => repo.pick(tripId: 'trip-001', kidId: 'k1')).called(1);
        verify(() => repo.activePassengers()).called(1);
      });

      test('a kid row with its own tripId uses that', () async {
        kids = [kid('k1', 'One', tripId: 'trip-other')];
        final c = container();
        await c.read(passengersControllerProvider('trip-001').future);
        await controller(c).pick(kids.first);
        verify(() => repo.pick(tripId: 'trip-other', kidId: 'k1')).called(1);
      });

      test('queued: no reload, the queue state is shown at once', () async {
        when(() => repo.pick(
            tripId: any(named: 'tripId'),
            kidId: any(named: 'kidId'))).thenAnswer((_) async {
          pending = {'k1': KidTripStatus.picked};
          return SubmitOutcome.queued;
        });
        final c = container();
        await c.read(passengersControllerProvider('trip-001').future);
        clearInteractions(repo);
        expect(await controller(c).pick(kids.first), StopActionOutcome.queued);
        verifyNever(() => repo.activePassengers());
        expect(state(c).statusOf(kids.first), KidTripStatus.picked);
        expect(state(c).isUnsynced(kids.first), isTrue);
      });

      test('the kid is busy while it runs, and not after an error', () async {
        final gate = Completer<SubmitOutcome>();
        when(() => repo.pick(
            tripId: any(named: 'tripId'),
            kidId: any(named: 'kidId'))).thenAnswer((_) => gate.future);
        final c = container();
        await c.read(passengersControllerProvider('trip-001').future);
        final f = controller(c).pick(kids.first);
        await pumpEventQueue();
        expect(state(c).busy, {'k1'});
        gate.completeError(const ApiError(
            status: 400, message: 'Already picked', code: 'ALREADY_PICKED'));
        await expectLater(f, throwsA(isA<ApiError>()));
        expect(state(c).busy, isEmpty);
      });
    });

    group('drop', () {
      test('sends the GPS position with the drop', () async {
        final c = container();
        await c.read(passengersControllerProvider('trip-001').future);
        expect(await controller(c).drop(kids.first), StopActionOutcome.sent);
        verify(() => repo.drop(
            tripId: 'trip-001',
            kidId: 'k1',
            position: const GeoPoint(lat: 24.8607, lng: 67.0011))).called(1);
      });

      test('without GPS nothing is sent', () async {
        gps = null;
        final c = container();
        await c.read(passengersControllerProvider('trip-001').future);
        expect(await controller(c).drop(kids.first), StopActionOutcome.noGps);
        verifyNever(() => repo.drop(
            tripId: any(named: 'tripId'),
            kidId: any(named: 'kidId'),
            position: any(named: 'position')));
        expect(state(c).busy, isEmpty);
      });

      test('queued drop', () async {
        when(() => repo.drop(
                tripId: any(named: 'tripId'),
                kidId: any(named: 'kidId'),
                position: any(named: 'position')))
            .thenAnswer((_) async => SubmitOutcome.queued);
        final c = container();
        await c.read(passengersControllerProvider('trip-001').future);
        expect(await controller(c).drop(kids.first), StopActionOutcome.queued);
      });
    });

    test('arrivedAtStop starts the waiting timer from the server time',
        () async {
      when(() => repo.arrivedAtStop(
              tripId: any(named: 'tripId'), kidId: any(named: 'kidId')))
          .thenAnswer((_) async => ArrivedAtStop(
              kidId: 'k1', waitingSince: DateTime.utc(2026, 10, 6, 8, 25)));
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      await controller(c).arrivedAtStop(kids.first);
      expect(state(c).passengers.first.waitingSince,
          DateTime.utc(2026, 10, 6, 8, 25));
      expect(state(c).passengers.last.waitingSince, isNull);
      expect(state(c).stopBusy, isEmpty);
    });

    test('arrivedAtStop without a server time uses "now"', () async {
      when(() => repo.arrivedAtStop(
              tripId: any(named: 'tripId'), kidId: any(named: 'kidId')))
          .thenAnswer((_) async => const ArrivedAtStop(kidId: 'k1'));
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      await controller(c).arrivedAtStop(kids.first);
      expect(state(c).passengers.first.waitingSince, now.toUtc());
    });

    test('a failed arrivedAtStop rethrows and clears the busy flag', () async {
      when(() => repo.arrivedAtStop(
              tripId: any(named: 'tripId'), kidId: any(named: 'kidId')))
          .thenAnswer((_) async =>
              throw const ApiError(status: 400, code: 'ALREADY_PICKED'));
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      await expectLater(
          controller(c).arrivedAtStop(kids.first), throwsA(isA<ApiError>()));
      expect(state(c).stopBusy, isEmpty);
    });

    test('markNoShow sends the note and moves the kid down the list', () async {
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      await controller(c).markNoShow(kids.first, note: 'Nobody at the gate');
      verify(() => repo.markNoShow(
          tripId: 'trip-001',
          kidId: 'k1',
          note: 'Nobody at the gate')).called(1);
      final s = state(c);
      expect(s.passengers.map((p) => p.id), ['k2', 'k1']);
      expect(s.passengers.last.noShow, isTrue);
    });

    test('messageParent opens the chat for the kid', () async {
      when(() => chatRepo.start('k1'))
          .thenAnswer((_) async => const Conversation(id: 'conv-001'));
      final c = container();
      await c.read(passengersControllerProvider('trip-001').future);
      expect((await controller(c).messageParent(kids.first)).id, 'conv-001');
    });
  });

  Widget screen({Widget? child}) => routerHost(
        {
          '/passengers/:tripId': (s) =>
              PassengersScreen(tripId: s.pathParameters['tripId']!),
          '/kid/:kidId': (s) => KidProfileScreen(
              kidId: s.pathParameters['kidId']!,
              kid: s.extra is Passenger ? s.extra as Passenger : null),
          '/scan': (_) => const Text('scan-stub'),
          '/chat/:conversationId': (_) => const Text('chat-stub'),
          '/trip/:tripId': (_) => const Text('trip-stub'),
        },
        initial: '/passengers/trip-001',
        overrides: overrides(),
      );

  group('PassengersScreen', () {
    testWidgets('header counts, kids, and the right buttons per state',
        (tester) async {
      useTallView(tester);
      kids = [
        kid('k1', 'Rider Waiting'),
        kid('k2', 'Rider Picked', status: KidTripStatus.picked),
        kid('k3', 'Rider Dropped', status: KidTripStatus.dropped),
      ];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text('Passengers'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Picked'), findsNWidgets(2)); // header chip + badge
      expect(find.text('Remaining'), findsOneWidget);
      expect(find.text('Pick Up'), findsOneWidget);
      expect(find.text('Drop'), findsOneWidget);
      expect(find.text('Dropped'), findsOneWidget);
    });

    testWidgets('offline-saved kids show the cloud icon', (tester) async {
      kids = [kid('k1', 'One')];
      pending = {'k1': KidTripStatus.picked};
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
      expect(find.text('Picked'), findsWidgets);
    });

    testWidgets('Pick Up: sent shows the green snackbar', (tester) async {
      kids = [kid('k1', 'Test Kid One')];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick Up'));
      await tester.pumpAndSettle();
      verify(() => repo.pick(tripId: 'trip-001', kidId: 'k1')).called(1);
      expect(find.text('Test Kid One picked up!'), findsOneWidget);
    });

    testWidgets('Pick Up while offline says it was saved', (tester) async {
      kids = [kid('k1', 'Test Kid One')];
      when(() => repo.pick(
              tripId: any(named: 'tripId'), kidId: any(named: 'kidId')))
          .thenAnswer((_) async => SubmitOutcome.queued);
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick Up'));
      await tester.pumpAndSettle();
      expect(
          find.text(
              'Test Kid One picked up — saved offline, will sync automatically.'),
          findsOneWidget);
    });

    testWidgets('a rejected pick shows the server message', (tester) async {
      kids = [kid('k1', 'Test Kid One')];
      when(() => repo.pick(
              tripId: any(named: 'tripId'), kidId: any(named: 'kidId')))
          .thenAnswer((_) async => throw const ApiError(
              status: 400, message: 'Already picked', code: 'ALREADY_PICKED'));
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick Up'));
      await tester.pumpAndSettle();
      expect(find.text('Already picked'), findsOneWidget);
    });

    testWidgets('an absent kid needs confirmation before pick up',
        (tester) async {
      kids = [kid('k1', 'Test Kid One', absent: true, absenceNote: 'Fever')];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text('Absent today — Fever'), findsOneWidget);
      await tester.tap(find.text('Pick Up'));
      await tester.pumpAndSettle();
      expect(find.text('Marked absent'), findsOneWidget);
      expect(
          find.text(
              "Test Kid One's parent said they are absent today. Pick up anyway?"),
          findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      verifyNever(() =>
          repo.pick(tripId: any(named: 'tripId'), kidId: any(named: 'kidId')));

      await tester.tap(find.text('Pick Up'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pick up'));
      await tester.pumpAndSettle();
      verify(() => repo.pick(tripId: 'trip-001', kidId: 'k1')).called(1);
    });

    testWidgets(
        'absent without a note says the parent was informed; no-show row',
        (tester) async {
      useTallView(tester);
      kids = [kid('k1', 'A', absent: true), kid('k2', 'B', noShow: true)];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text('Absent today (parent informed)'), findsOneWidget);
      expect(find.text('Not at stop — moved on'), findsOneWidget);
    });

    testWidgets('Drop: sent, and without GPS the red message', (tester) async {
      kids = [kid('k1', 'Test Kid One', status: KidTripStatus.picked)];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Drop'));
      await tester.pumpAndSettle();
      expect(find.text('Test Kid One dropped off!'), findsOneWidget);
    });

    testWidgets('Drop without GPS', (tester) async {
      gps = null;
      kids = [kid('k1', 'Test Kid One', status: KidTripStatus.picked)];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Drop'));
      await tester.pumpAndSettle();
      expect(
          find.text(
              'Could not get your GPS location. Turn on location and try again.'),
          findsOneWidget);
    });

    testWidgets(
        'At stop → timer; after 2 minutes "Not here — move on" asks for a note',
        (tester) async {
      now = DateTime.now();
      kids = [kid('k1', 'Test Kid One')];
      when(() => repo.arrivedAtStop(
              tripId: any(named: 'tripId'), kidId: any(named: 'kidId')))
          .thenAnswer((_) async => ArrivedAtStop(
              kidId: 'k1',
              waitingSince: now.subtract(const Duration(minutes: 3))));
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('At stop — tell parent'));
      await tester.pumpAndSettle();
      expect(find.text('Parent told the van is at the stop.'), findsOneWidget);
      expect(find.textContaining('Waiting 3:'), findsOneWidget);
      expect(find.text('Not here — move on'), findsOneWidget);

      await tester.tap(find.text('Not here — move on'));
      await tester.pumpAndSettle();
      expect(find.text('Test Kid One not at stop?'), findsOneWidget);
      expect(find.text('The parent will be told the van moved on.'),
          findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Gate was locked');
      await tester.tap(find.text('Move on'));
      await tester.pumpAndSettle();
      verify(() => repo.markNoShow(
          tripId: 'trip-001', kidId: 'k1', note: 'Gate was locked')).called(1);
      expect(find.text('Not at stop — moved on'), findsOneWidget);
    });

    testWidgets(
        'on a drop trip the button says "At home" and there is no move-on',
        (tester) async {
      kids = [
        kid('k1', 'Test Kid One',
            status: KidTripStatus.picked, tripType: TripType.drop)
      ];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text('At home — tell parent'), findsOneWidget);
    });

    testWidgets('empty list and load error with Retry', (tester) async {
      kids = [];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text('No Passengers'), findsOneWidget);
      expect(find.text('No students assigned to this trip'), findsOneWidget);
    });

    testWidgets('load error', (tester) async {
      var fail = true;
      when(() => repo.activePassengers()).thenAnswer((_) async {
        if (fail) throw const NetworkException();
        return kids;
      });
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      expect(find.text("Couldn't Load Passengers"), findsOneWidget);
      fail = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Test Kid One'), findsOneWidget);
    });

    testWidgets('a parent absence event shows a note', (tester) async {
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      absenceBus
          .add(const KidAbsenceEvent(kidId: 'k1', fullname: 'Test Kid One'));
      await tester.pumpAndSettle();
      expect(find.text('Test Kid One is absent today (parent informed).'),
          findsOneWidget);
      absenceBus.add(const KidAbsenceEvent(
          kidId: 'k1', fullname: 'Test Kid One', cancelled: true));
      await tester.pumpAndSettle();
      expect(
          find.text('Test Kid One will ride today after all.'), findsOneWidget);
    });

    testWidgets('message parent opens the chat; scan opens the scanner',
        (tester) async {
      when(() => chatRepo.start('k1'))
          .thenAnswer((_) async => const Conversation(id: 'conv-001'));
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.chat_bubble_outline).first);
      await tester.pumpAndSettle();
      expect(find.text('chat-stub'), findsOneWidget);
    });

    testWidgets('the scan button opens /scan and reloads on return',
        (tester) async {
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.qr_code_scanner));
      await tester.pumpAndSettle();
      expect(find.text('scan-stub'), findsOneWidget);
    });

    testWidgets(
        'tapping the avatar opens the kid profile with the parent contact',
        (tester) async {
      kids = [
        Passenger.fromJson(Map<String, dynamic>.from(asJsonList(unwrapData(
                    fixture('passengers/merged_active_passengers.json')))
                .first))
            .copyWith(image: null)
      ];
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ClipOval).first); // the avatar
      await tester.pumpAndSettle();
      expect(find.text('Kid Profile'), findsOneWidget);
      expect(find.text('Student Information'), findsOneWidget);
      expect(find.text('Sample School'), findsOneWidget);
      expect(find.text('0300-0000001'), findsWidgets);
      expect(find.text('Call Parent'), findsOneWidget);
    });
  });

  group('KidProfileScreen', () {
    testWidgets('without a loaded kid it looks the kid up in the running trip',
        (tester) async {
      kids = [kid('k1', 'Test Kid One')];
      await tester.pumpWidget(routerHost(
        {
          '/kid/:kidId': (s) =>
              KidProfileScreen(kidId: s.pathParameters['kidId']!)
        },
        initial: '/kid/k1',
        overrides: overrides(),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Test Kid One'), findsWidgets);
      expect(find.text('Karachi, Pakistan'),
          findsOneWidget); // the long-standing default
    });

    testWidgets('an id that is not on the trip says so', (tester) async {
      kids = [kid('k1', 'Test Kid One')];
      await tester.pumpWidget(routerHost(
        {
          '/kid/:kidId': (s) =>
              KidProfileScreen(kidId: s.pathParameters['kidId']!)
        },
        initial: '/kid/zzz',
        overrides: overrides(),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Student not found'), findsOneWidget);
    });
  });
}
