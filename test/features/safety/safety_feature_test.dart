import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/safety/application/sos_controller.dart';
import 'package:smartvan_driver/features/safety/data/safety_repository.dart';
import 'package:smartvan_driver/features/safety/presentation/widgets/sos_button.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/data/models/geo_point.dart';

import '../../support/fake_tracking.dart';
import '../../support/l10n_host.dart';

class _FakeSafetyRepo extends Mock implements SafetyRepository {}

void main() {
  late _FakeSafetyRepo repo;
  GeoPoint? gps;

  setUpAll(() => registerFallbackValue(const GeoPoint(lat: 0, lng: 0)));

  setUp(() {
    repo = _FakeSafetyRepo();
    gps = const GeoPoint(lat: 24.8607, lng: 67.0011);
    when(() => repo.sendSos(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'),
          message: any(named: 'message'),
        )).thenAnswer((_) async => 4);
  });

  List<Override> overrides() => [
        safetyRepositoryProvider.overrideWithValue(repo),
        tripTrackingProvider.overrideWith(
            () => FakeTracking(tripId: 'trip-001', position: gps)),
      ];

  group('SosController', () {
    ProviderContainer make() {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      c.listen(sosControllerProvider, (_, __) {});
      return c;
    }

    test('sent: with the trip and the GPS position', () async {
      final c = make();
      final r = await c.read(sosControllerProvider.notifier).send();
      expect((r as SosSent).parentsNotified, 4);
      verify(() => repo.sendSos(
          tripId: 'trip-001',
          position: const GeoPoint(lat: 24.8607, lng: 67.0011),
          message: null)).called(1);
      expect(c.read(sosControllerProvider), isFalse);
    });

    test('no GPS: nothing is sent', () async {
      gps = null;
      final c = make();
      expect(await c.read(sosControllerProvider.notifier).send(),
          isA<SosNoLocation>());
      verifyNever(() => repo.sendSos(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'),
          message: any(named: 'message')));
    });

    test('SOS_RATE_LIMITED counts as sent', () async {
      when(() => repo.sendSos(
              tripId: any(named: 'tripId'),
              position: any(named: 'position'),
              message: any(named: 'message')))
          .thenAnswer((_) async => throw const ApiError(
              code: 'SOS_RATE_LIMITED', status: 429, message: 'Already sent'));
      final c = make();
      expect(await c.read(sosControllerProvider.notifier).send(),
          isA<SosRateLimited>());
    });

    test('other failures', () async {
      when(() => repo.sendSos(
              tripId: any(named: 'tripId'),
              position: any(named: 'position'),
              message: any(named: 'message')))
          .thenAnswer((_) async => throw const NetworkException());
      final c = make();
      final r = await c.read(sosControllerProvider.notifier).send();
      expect((r as SosFailed).error, isA<NetworkException>());
      expect(c.read(sosControllerProvider), isFalse);
    });
  });

  group('SosButton', () {
    Widget app() =>
        l10nHost(const Center(child: SosButton()), overrides: overrides());

    testWidgets('a tap only explains how to use it', (tester) async {
      await tester.pumpWidget(app());
      await tester.tap(find.text('SOS'));
      await tester.pump();
      expect(find.text('Press and hold SOS to send an emergency alert.'),
          findsOneWidget);
      verifyNever(() => repo.sendSos(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'),
          message: any(named: 'message')));
    });

    testWidgets('holding for 1.5 seconds sends the SOS and shows the result',
        (tester) async {
      await tester.pumpWidget(app());
      final gesture =
          await tester.startGesture(tester.getCenter(find.text('SOS')));
      await tester
          .pump(const Duration(milliseconds: 600)); // long-press recognised
      await tester.pump(SosButton.holdDuration);
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle();
      verify(() => repo.sendSos(
          tripId: 'trip-001',
          position: const GeoPoint(lat: 24.8607, lng: 67.0011),
          message: null)).called(1);
      expect(find.text('SOS sent'), findsOneWidget);
      expect(find.text('The school has your location. 4 parents notified.'),
          findsOneWidget);
      expect(find.text('Police'), findsOneWidget);
      expect(find.text('1122'), findsOneWidget);
    });

    testWidgets('letting go early sends nothing', (tester) async {
      await tester.pumpWidget(app());
      final gesture =
          await tester.startGesture(tester.getCenter(find.text('SOS')));
      await tester.pump(const Duration(milliseconds: 700));
      await gesture.up();
      await tester.pumpAndSettle();
      verifyNever(() => repo.sendSos(
          tripId: any(named: 'tripId'),
          position: any(named: 'position'),
          message: any(named: 'message')));
      expect(find.text('SOS sent'), findsNothing);
    });

    testWidgets('no GPS: asks to turn it on, with the call buttons',
        (tester) async {
      gps = null;
      await tester.pumpWidget(app());
      final gesture =
          await tester.startGesture(tester.getCenter(find.text('SOS')));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(SosButton.holdDuration);
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Could not get your location'), findsOneWidget);
      expect(find.text('Turn on GPS and try again, or call for help directly.'),
          findsOneWidget);
      expect(find.text('Edhi'), findsOneWidget);
    });

    testWidgets('failure shows the reason and "Call for help directly:"',
        (tester) async {
      when(() => repo.sendSos(
              tripId: any(named: 'tripId'),
              position: any(named: 'position'),
              message: any(named: 'message')))
          .thenAnswer((_) async => throw const NetworkException());
      await tester.pumpWidget(app());
      final gesture =
          await tester.startGesture(tester.getCenter(find.text('SOS')));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(SosButton.holdDuration);
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('SOS could not be sent'), findsOneWidget);
      expect(
          find.text(
              'No internet connection. Please check your network and try again.\nCall for help directly:'),
          findsOneWidget);
    });
  });
}
