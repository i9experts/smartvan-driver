import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/trip/application/stop_icons.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_trail.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';
import 'package:smartvan_driver/features/trip_history/data/models/trip_details.dart';
import 'package:smartvan_driver/features/trip_history/data/trip_history_repository.dart';
import 'package:smartvan_driver/features/trip_history/presentation/screens/trip_details_screen.dart';
import 'package:smartvan_driver/features/trip_history/presentation/widgets/history_route_map.dart';

import '../../../support/fixture.dart';
import '../../../support/l10n_host.dart';
import '../../../support/trip_history_fakes.dart';

class _TripRepo extends Mock implements TripRepository {}

Map<String, dynamic> _data(String name) =>
    Map<String, dynamic>.from(fixtureMap(name)['data'] as Map);

void main() {
  late MockHistoryRepo history;
  late _TripRepo trips;
  var mapMarkers = <Marker>{};
  var mapPolylines = <Polyline>{};

  final details = TripDetails.fromJson(_data('trip_history/details.json'));
  final trail = TripTrail.fromJson(_data('trip_history/trail.json'));

  setUpAll(() => initializeDateFormatting('en'));

  setUp(() {
    history = MockHistoryRepo();
    trips = _TripRepo();
    mapMarkers = {};
    mapPolylines = {};
    when(() => history.details('trip-1')).thenAnswer((_) async => details);
    when(() => trips.trail('trip-1')).thenAnswer((_) async => trail);
  });

  Widget app() => l10nHost(
        const TripDetailsScreen(tripId: 'trip-1'),
        overrides: [
          tripHistoryRepositoryProvider.overrideWithValue(history),
          tripRepositoryProvider.overrideWithValue(trips),
          stopIconFactoryProvider.overrideWithValue((style,
                  {required devicePixelRatio}) async =>
              BitmapDescriptor.defaultMarker),
          historyMapBuilderProvider.overrideWithValue((context,
              {required target,
              required markers,
              required polylines,
              required onCreated}) {
            mapMarkers = markers;
            mapPolylines = polylines;
            return Container(key: const Key('fake-map'), color: Colors.black12);
          }),
        ],
      );

  testWidgets('with a trail: path, start, end, stops and school on the map',
      (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('fake-map')), findsOneWidget);
    expect(find.byKey(const Key('route-unavailable')), findsNothing);
    expect(mapPolylines.single.points,
        const [LatLng(24.9, 67.1), LatLng(24.88, 67.05), LatLng(24.86, 67.0)]);
    expect(mapMarkers.map((m) => m.markerId.value),
        unorderedEquals(['start', 'end', 'stop-1', 'stop-2', 'school']));
    final start = mapMarkers.firstWhere((m) => m.markerId.value == 'start');
    expect(start.position, const LatLng(24.9, 67.1));
    final end = mapMarkers.firstWhere((m) => m.markerId.value == 'end');
    expect(end.position, const LatLng(24.86, 67.0));
    final school = mapMarkers.firstWhere((m) => m.markerId.value == 'school');
    expect(school.infoWindow.title, 'City School');
  });

  testWidgets('without a trail: a note over the map, stops still shown',
      (tester) async {
    useTallView(tester);
    when(() => trips.trail('trip-1'))
        .thenAnswer((_) async => const TripTrail());
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Route not available for this trip'), findsOneWidget);
    expect(mapPolylines, isEmpty);
    expect(mapMarkers.map((m) => m.markerId.value),
        unorderedEquals(['stop-1', 'stop-2', 'school']));
    // The rest of the screen is unaffected.
    expect(find.text('Gulshan Morning'), findsOneWidget);
  });

  testWidgets('a trail that fails to load is treated as no route',
      (tester) async {
    useTallView(tester);
    when(() => trips.trail('trip-1'))
        .thenAnswer((_) async => throw const NetworkException());
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Route not available for this trip'), findsOneWidget);
    expect(find.text('Gulshan Morning'), findsOneWidget);
  });

  testWidgets('the summary shows PKT times, duration and kilometres',
      (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Gulshan Morning'), findsOneWidget);
    expect(find.text('Pick up'), findsOneWidget);
    expect(find.text('15 Oct 2026'), findsOneWidget);
    expect(find.text('7:00 AM'), findsOneWidget); // 02:00 UTC
    expect(find.text('7:41 AM'), findsOneWidget); // 02:41 UTC
    expect(find.text('41 min'), findsOneWidget);
    expect(find.text('11.8 km'), findsOneWidget);
  });

  testWidgets('students show their status and time', (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Students (3)'), findsOneWidget);
    expect(find.text('Ayesha Test'), findsOneWidget);
    expect(find.text('Picked up'), findsOneWidget);
    expect(find.text('7:10 AM'), findsOneWidget);
    expect(find.text('Absent'), findsOneWidget);
    expect(find.text('No-show'), findsOneWidget);
    expect(find.text('7:20 AM'), findsOneWidget);
  });

  testWidgets('alerts during the trip are listed with times and open a sheet',
      (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Alerts during this trip'), findsOneWidget);
    expect(find.text('Overspeeding'), findsOneWidget);
    expect(find.text('7:15 AM'), findsOneWidget);
    expect(find.text('SOS'), findsOneWidget);
    expect(find.text('7:30 AM'), findsOneWidget);

    await tester.tap(find.text('Overspeeding'));
    await tester.pumpAndSettle();
    expect(find.text('Van went 82 km/h'), findsOneWidget);
  });

  testWidgets('no students and no alerts show their notes', (tester) async {
    useTallView(tester);
    when(() => history.details('trip-1')).thenAnswer((_) async =>
        TripDetails(trip: details.trip, stops: const [], alerts: const []));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('No students on this trip'), findsOneWidget);
    expect(find.text('No alerts during this trip'), findsOneWidget);
  });

  testWidgets('a failed load shows an error with Retry', (tester) async {
    useTallView(tester);
    var calls = 0;
    when(() => history.details('trip-1')).thenAnswer((_) async {
      if (calls++ == 0) {
        throw const ApiError(
            status: 404, code: 'TRIP_NOT_FOUND', message: 'Trip not found');
      }
      return details;
    });
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Trip not found'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Gulshan Morning'), findsOneWidget);
  });
}
