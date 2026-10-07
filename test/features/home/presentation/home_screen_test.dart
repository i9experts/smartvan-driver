import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/core/providers/core_providers.dart';
import 'package:smartvan_driver/features/chat/data/chat_repository.dart';
import 'package:smartvan_driver/features/checklist/data/checklist_repository.dart';
import 'package:smartvan_driver/features/checklist/data/models/today_checklist.dart';
import 'package:smartvan_driver/features/home/presentation/screens/home_screen.dart';
import 'package:smartvan_driver/features/profile/data/models/driver_profile.dart';
import 'package:smartvan_driver/features/profile/data/profile_repository.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/trip/data/models/assigned_route.dart';
import 'package:smartvan_driver/features/trip/data/models/route_passenger.dart';
import 'package:smartvan_driver/features/trip/data/models/trip.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_status.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';

import '../../../support/fake_sync_queue.dart';
import '../../../support/fake_tracking.dart';
import '../../../support/l10n_host.dart';

class _TripRepo extends Mock implements TripRepository {}

class _ProfileRepo extends Mock implements ProfileRepository {}

class _ChatRepo extends Mock implements ChatRepository {}

class _ChecklistRepo extends Mock implements ChecklistRepository {}

void main() {
  late _TripRepo trips;
  late _ProfileRepo profile;
  late _ChatRepo chat;
  late _ChecklistRepo checklist;
  late TrackingProbe probe;

  // 8:30 in the morning, local time.
  final now = DateTime(2026, 10, 6, 8, 30);
  final morning = AssignedRoute(
    routeId: 'r-1',
    routeTitle: 'Sample School - Morning',
    vehicleNumber: 'TST-1234',
    startTime: DateTime(2026, 10, 6, 8, 0),
    passengers: const [
      RoutePassenger(kidId: 'k1', fullname: 'Test Kid One', grade: '3'),
    ],
  );
  final afternoon = AssignedRoute(
    routeId: 'r-2',
    routeTitle: 'Sample School - Afternoon',
    startTime: DateTime(2026, 10, 6, 14, 0),
    tripType: TripType.drop,
  );

  setUp(() {
    trips = _TripRepo();
    profile = _ProfileRepo();
    chat = _ChatRepo();
    checklist = _ChecklistRepo();
    probe = TrackingProbe();
    when(() => trips.assignedRoutes())
        .thenAnswer((_) async => [morning, afternoon]);
    when(() => trips.driverTrips()).thenAnswer((_) async => [
          Trip(
            id: 't-1',
            name: 'Sample School - Morning Pick',
            status: TripStatus.ongoing,
            createdAt: DateTime(2026, 10, 6, 8),
            startTime: DateTime(2026, 10, 6, 8, 5),
          ),
          const Trip(id: 't-2', status: TripStatus.completed),
        ]);
    when(() => profile.getProfile()).thenAnswer((_) async => DriverProfile(
          fullname: 'Danish Test',
          expiryDateLicense: DateTime(2026, 10, 16),
        ));
    when(() => chat.unread()).thenAnswer((_) async => 3);
    when(() => checklist.today())
        .thenAnswer((_) async => const TodayChecklist(required: true));
  });

  Widget app({String home = '/home'}) => routerHost(
        {
          '/home': (_) => const HomeScreen(),
          '/checklist': (_) => Scaffold(
                body: Builder(
                  builder: (context) => TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Submit check'),
                  ),
                ),
              ),
          '/trip/:tripId': (s) =>
              Scaffold(body: Text('Trip ${s.pathParameters['tripId']}')),
        },
        initial: home,
        overrides: [
          tripRepositoryProvider.overrideWithValue(trips),
          profileRepositoryProvider.overrideWithValue(profile),
          chatRepositoryProvider.overrideWithValue(chat),
          checklistRepositoryProvider.overrideWithValue(checklist),
          syncQueueProvider.overrideWithValue(FakeSyncQueue()),
          clockProvider.overrideWithValue(() => now),
          tripTrackingProvider
              .overrideWith(() => FakeTracking(tripId: 't-1', probe: probe)),
        ],
      );

  testWidgets('shows the header, banners, routes and trips', (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Good Morning,'), findsOneWidget);
    expect(find.text('Danish'), findsOneWidget);
    expect(find.text('3'), findsWidgets); // chat badge
    expect(find.text('Karachi, Pakistan'), findsOneWidget);
    expect(find.text('Required before you can start a trip'), findsOneWidget);
    expect(find.textContaining('Driving licence expires in 10 days'),
        findsOneWidget);
    expect(find.text('Sample School - Morning'), findsOneWidget);
    expect(find.text('8:00 AM'), findsOneWidget);
    expect(find.text('Grade 3'), findsOneWidget);
    expect(find.text('2 trips'), findsOneWidget);
    expect(find.text('Completed'), findsWidgets);
  });

  testWidgets('a running trip shows the banner and Continue Trip',
      (tester) async {
    useTallView(tester);
    when(() => trips.assignedRoutes()).thenAnswer((_) async => [
          morning.copyWith(
              tripStarted: true,
              tripDetails: const Trip(id: 't-1', status: TripStatus.ongoing)),
        ]);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Trip in progress'), findsOneWidget);
    expect(find.text('In Progress'), findsOneWidget);
    expect(find.text('Continue Trip'), findsOneWidget);
    expect(find.text('Start Trip'), findsNothing);
    expect(probe.stops, 0);

    await tester.tap(find.text('Continue Trip'));
    await tester.pumpAndSettle();
    expect(find.text('Trip t-1'), findsOneWidget);
  });

  testWidgets('Start Trip only inside the window', (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Start Trip'), findsOneWidget);
    expect(find.text('Available at 2:00 PM'), findsOneWidget);
    final late = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Available at 2:00 PM'));
    expect(late.onPressed, isNull);
  });

  testWidgets('start → check required → check done → trip opens',
      (tester) async {
    useTallView(tester);
    var calls = 0;
    when(() => trips.startTrip(routeId: 'r-1', type: TripType.unknown))
        .thenAnswer((_) async {
      if (calls++ == 0) {
        throw const ApiError(
            status: 400, code: 'CHECKLIST_REQUIRED', message: 'Check first');
      }
      return const Trip(id: 't-new', routeId: 'r-1');
    });
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Trip'));
    await tester.pumpAndSettle();
    expect(find.text('Submit check'), findsOneWidget);

    await tester.tap(find.text('Submit check'));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.text('Trip t-new'), findsOneWidget);
  });

  testWidgets('a failed start shows the server message', (tester) async {
    useTallView(tester);
    when(() => trips.startTrip(routeId: 'r-1', type: TripType.unknown))
        .thenAnswer((_) async =>
            throw const ApiError(status: 400, message: 'Too early to start'));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Trip'));
    await tester.pumpAndSettle();
    expect(find.text('Too early to start'), findsOneWidget);
    expect(find.text('Start Trip'), findsOneWidget);
  });

  testWidgets('a driver with no van sees "No Trip Today"', (tester) async {
    useTallView(tester);
    when(() => trips.assignedRoutes()).thenAnswer((_) async =>
        throw const ApiError(status: 400, message: 'Van not found'));
    when(() => trips.driverTrips()).thenAnswer((_) async => []);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('No Trip Today'), findsOneWidget);
    expect(find.text('My Route Today'), findsNothing);
    expect(find.text('Start Trip'), findsNothing);
  });

  testWidgets('View Trip opens the trip and Back returns home', (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('View Trip'));
    await tester.pumpAndSettle();
    expect(find.text('Trip t-1'), findsOneWidget);

    final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
    nav.pop();
    await tester.pumpAndSettle();
    expect(find.text('Good Morning,'), findsOneWidget);
  });

  testWidgets('tracking stops when the server has no running trip',
      (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(probe.stops, 1);
    expect(find.text('Trip in progress'), findsNothing);
  });

  testWidgets('resuming a trip found on the server says so', (tester) async {
    useTallView(tester);
    when(() => trips.assignedRoutes()).thenAnswer((_) async => [
          morning.copyWith(
              tripStarted: true,
              tripDetails: const Trip(id: 't-1', status: TripStatus.ongoing)),
        ]);
    await tester.pumpWidget(routerHost(
      {'/home': (_) => const HomeScreen()},
      initial: '/home',
      overrides: [
        tripRepositoryProvider.overrideWithValue(trips),
        profileRepositoryProvider.overrideWithValue(profile),
        chatRepositoryProvider.overrideWithValue(chat),
        checklistRepositoryProvider.overrideWithValue(checklist),
        syncQueueProvider.overrideWithValue(FakeSyncQueue()),
        clockProvider.overrideWithValue(() => now),
        tripTrackingProvider
            .overrideWith(() => FakeTracking(isTracking: false, probe: probe)),
      ],
    ));
    await tester.pumpAndSettle();
    expect(probe.started.single.id, 't-1');
    expect(find.text('Your ongoing trip was resumed — location sharing is on.'),
        findsOneWidget);
  });

  testWidgets('has the three bottom tabs', (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
