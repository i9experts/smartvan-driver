import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/features/passengers/data/models/scan_result.dart';
import 'package:smartvan_driver/features/scan/application/scan_controller.dart';
import 'package:smartvan_driver/features/scan/application/scan_state.dart';
import 'package:smartvan_driver/features/scan/data/scan_repository.dart';
import 'package:smartvan_driver/features/scan/presentation/screens/scan_screen.dart';
import 'package:smartvan_driver/features/scan/presentation/widgets/qr_scanner_view.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';
import 'package:smartvan_driver/features/trip/services/trip_tracking_service.dart';

import '../../support/fake_sync_queue.dart';
import '../../support/fake_tracking.dart';
import '../../support/l10n_host.dart';

class _FakeScanRepo extends Mock implements ScanRepository {}

class _FlushQueue extends FakeSyncQueue {
  int flushes = 0;
  @override
  Future<bool> flush() async {
    flushes++;
    return true;
  }
}

void main() {
  const card = 'smartvan:kid:AbCdEfGhIjKlMnOpQrStUvWx';
  const card2 = 'smartvan:kid:ZyXwVuTsRqPoNmLkJiHgFeDc';
  late _FakeScanRepo repo;
  late _FlushQueue queue;

  setUpAll(() => registerFallbackValue(const GeoPoint(lat: 0, lng: 0)));

  setUp(() {
    repo = _FakeScanRepo();
    queue = _FlushQueue();
    when(() => repo.scan(
              tripId: any(named: 'tripId'),
              qrPayload: any(named: 'qrPayload'),
              position: any(named: 'position'),
            ))
        .thenAnswer((_) async => const ScanResult(
            action: ScanAction.picked,
            kidId: 'kid-001',
            fullname: 'Test Kid One'));
  });

  List<Override> overrides({String? tripId = 'trip-001', LatLng? position}) => [
        scanRepositoryProvider.overrideWithValue(repo),
        syncQueueProvider.overrideWithValue(queue),
        tripTrackingProvider.overrideWith(() => FakeTracking(
            tripId: tripId,
            position: position ?? const LatLng(24.8607, 67.0011))),
      ];

  ProviderContainer container([List<Override>? o]) {
    final c = ProviderContainer(overrides: o ?? overrides());
    addTearDown(c.dispose);
    c.listen(scanControllerProvider, (_, __) {});
    return c;
  }

  group('ScanController', () {
    test('a card: flushes the queue first, sends trip, payload and position',
        () async {
      final c = container();
      await c.read(scanControllerProvider.notifier).onCode(card);
      expect(queue.flushes, 1);
      verify(() => repo.scan(
          tripId: 'trip-001',
          qrPayload: card,
          position: const GeoPoint(lat: 24.8607, lng: 67.0011))).called(1);
      final s = c.read(scanControllerProvider);
      expect((s.outcome as ScanSucceeded).result.fullname, 'Test Kid One');
      expect(s.session, hasLength(1));
      expect(s.busy, isFalse);
    });

    test('something that is not a SmartVan card is not sent', () async {
      final c = container();
      await c
          .read(scanControllerProvider.notifier)
          .onCode('https://example.test/promo');
      expect(c.read(scanControllerProvider).outcome, isA<ScanNotACard>());
      verifyNever(() => repo.scan(
          tripId: any(named: 'tripId'),
          qrPayload: any(named: 'qrPayload'),
          position: any(named: 'position')));
    });

    test('no trip on this phone', () async {
      final c = container(overrides(tripId: null));
      await c.read(scanControllerProvider.notifier).onCode(card);
      expect(c.read(scanControllerProvider).outcome, isA<ScanNoActiveTrip>());
      expect(queue.flushes, 0);
    });

    test('the same card is ignored for 4 seconds, other cards are not', () {
      fakeAsync((async) {
        final c = container();
        final n = c.read(scanControllerProvider.notifier);
        n.onCode(card);
        async.flushMicrotasks();
        n.onCode(card); // repeat
        async.flushMicrotasks();
        n.onCode(card2); // another card
        async.flushMicrotasks();
        verify(() => repo.scan(
            tripId: 'trip-001',
            qrPayload: card,
            position: any(named: 'position'))).called(1);
        verify(() => repo.scan(
            tripId: 'trip-001',
            qrPayload: card2,
            position: any(named: 'position'))).called(1);

        async.elapse(const Duration(seconds: 5));
        n.onCode(card); // after the window
        async.flushMicrotasks();
        verify(() => repo.scan(
            tripId: 'trip-001',
            qrPayload: card,
            position: any(named: 'position'))).called(1);
      });
    });

    test('offline: ScanOffline', () async {
      when(() => repo.scan(
              tripId: any(named: 'tripId'),
              qrPayload: any(named: 'qrPayload'),
              position: any(named: 'position')))
          .thenAnswer((_) async => throw const NetworkException());
      final c = container();
      await c.read(scanControllerProvider.notifier).onCode(card);
      expect(c.read(scanControllerProvider).outcome, isA<ScanOffline>());
      expect(c.read(scanControllerProvider).session, isEmpty);
    });

    test('backend codes are kept on ScanFailed', () async {
      when(() => repo.scan(
              tripId: any(named: 'tripId'),
              qrPayload: any(named: 'qrPayload'),
              position: any(named: 'position')))
          .thenAnswer((_) async => throw const ApiError(
              code: 'ALREADY_PICKED', status: 400, message: 'Already picked'));
      final c = container();
      await c.read(scanControllerProvider.notifier).onCode(card);
      final o = c.read(scanControllerProvider).outcome as ScanFailed;
      expect(o.code, 'ALREADY_PICKED');
    });

    test('the outcome clears itself after 3 seconds', () {
      fakeAsync((async) {
        final c = container();
        c.read(scanControllerProvider.notifier).onCode(card);
        async.flushMicrotasks();
        expect(c.read(scanControllerProvider).outcome, isA<ScanSucceeded>());
        async.elapse(const Duration(seconds: 2));
        expect(c.read(scanControllerProvider).outcome, isNotNull);
        async.elapse(const Duration(seconds: 2));
        expect(c.read(scanControllerProvider).outcome, isNull);
      });
    });
  });

  group('ScanScreen', () {
    void Function(String)? emit;

    Widget app({List<Override>? o}) => routerHost(
          {
            '/start': (_) => Builder(
                builder: (context) => TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('x'),
                    child: const Text('x'))),
            '/scan': (_) => const ScanScreen(),
          },
          initial: '/scan',
          overrides: [
            ...(o ?? overrides()),
            scannerViewBuilderProvider
                .overrideWithValue((context, controller, onCode) {
              emit = onCode;
              return const ColoredBox(
                  color: Colors.black12, child: SizedBox.expand());
            }),
          ],
        );

    testWidgets('opens with the hint, title and torch', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.text('Scan student card'), findsOneWidget);
      expect(find.text("Point the camera at the student's QR card."),
          findsOneWidget);
      expect(find.byTooltip('Torch'), findsOneWidget);
    });

    testWidgets('a pick shows the kid and "Picked up", then the session hint',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      emit!(card);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Test Kid One'), findsOneWidget);
      expect(find.text('Picked up'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(
          find.text('1 scanned this session. Keep scanning.'), findsOneWidget);
    });

    testWidgets('a drop shows "Dropped off"', (tester) async {
      when(() => repo.scan(
              tripId: any(named: 'tripId'),
              qrPayload: any(named: 'qrPayload'),
              position: any(named: 'position')))
          .thenAnswer((_) async => const ScanResult(
              action: ScanAction.dropped,
              kidId: 'k',
              fullname: 'Test Kid One'));
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      emit!(card);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Dropped off'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('offline shows the scan-specific message', (tester) async {
      when(() => repo.scan(
              tripId: any(named: 'tripId'),
              qrPayload: any(named: 'qrPayload'),
              position: any(named: 'position')))
          .thenAnswer((_) async => throw const NetworkException());
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      emit!(card);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('No internet'), findsOneWidget);
      expect(
          find.text(
              'No internet. Scanning needs a connection — use the Passengers list instead (it works offline).'),
          findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });

    for (final (code, title) in [
      ('INVALID_QR', 'Card not recognised'),
      ('KID_NOT_ON_TRIP', 'Not on this van'),
      ('ALREADY_PICKED', 'Already picked up'),
      ('ALREADY_DROPPED', 'Already dropped'),
      ('LOCATION_REQUIRED', 'GPS needed'),
      ('TRIP_NOT_ONGOING', 'Trip not in progress'),
      ('SOMETHING_NEW', 'Scan failed'),
    ]) {
      testWidgets('backend code $code shows "$title" and the server message',
          (tester) async {
        when(() => repo.scan(
                tripId: any(named: 'tripId'),
                qrPayload: any(named: 'qrPayload'),
                position: any(named: 'position')))
            .thenAnswer((_) async => throw ApiError(
                code: code, status: 400, message: 'Server says $code'));
        await tester.pumpWidget(app());
        await tester.pumpAndSettle();
        emit!(card);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Server says $code'), findsOneWidget);
        await tester.pump(const Duration(seconds: 4));
      });
    }

    testWidgets('not a card and no trip', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      emit!('hello');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Not a SmartVan card'), findsOneWidget);
      expect(find.text("Scan the student's SmartVan QR card."), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));

      await tester.pumpWidget(app(o: overrides(tripId: null)));
      await tester.pumpAndSettle();
      emit!(card);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('No active trip'), findsOneWidget);
      expect(find.text('Start a trip before scanning.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
