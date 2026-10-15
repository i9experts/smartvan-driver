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
import 'package:smartvan_driver/features/rating/data/models/rating_summary.dart';
import 'package:smartvan_driver/features/rating/data/rating_repository.dart';
import 'package:smartvan_driver/features/trip/application/trip_tracking.dart';
import 'package:smartvan_driver/features/home/presentation/widgets/home_header.dart';
import 'package:smartvan_driver/features/trip/data/models/assigned_route.dart';
import 'package:smartvan_driver/features/trip/data/models/route_passenger.dart';
import 'package:smartvan_driver/features/trip/data/models/today_status.dart';
import 'package:smartvan_driver/features/trip/data/models/trip.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_status.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip/data/trip_repository.dart';
import 'package:smartvan_driver/features/trip_history/data/models/completed_trip.dart';
import 'package:smartvan_driver/features/trip_history/data/models/completed_trips_page.dart';
import 'package:smartvan_driver/features/trip_history/data/trip_history_repository.dart';

import '../../../support/fake_sync_queue.dart';
import '../../../support/fake_tracking.dart';
import '../../../support/l10n_host.dart';

class _TripRepo extends Mock implements TripRepository {}

class _ProfileRepo extends Mock implements ProfileRepository {}

class _ChatRepo extends Mock implements ChatRepository {}

class _RatingRepo extends Mock implements RatingRepository {}

class _ChecklistRepo extends Mock implements ChecklistRepository {}

class _HistoryRepo extends Mock implements TripHistoryRepository {}

void main() {
  late _TripRepo trips;
  late _ProfileRepo profile;
  late _ChatRepo chat;
  late _RatingRepo rating;
  late _ChecklistRepo checklist;
  late _HistoryRepo history;
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
    rating = _RatingRepo();
    when(() => rating.mySummary()).thenAnswer((_) async => const RatingSummary(
        avgRating: 4.6, ratingCount: 12, completedTripCount: 87));
    checklist = _ChecklistRepo();
    history = _HistoryRepo();
    when(() => history.completed(
            scope: HistoryScope.today, limit: any(named: 'limit')))
        .thenAnswer((_) async => CompletedTripsPage(items: [
              CompletedTrip(
                id: 'h-1',
                routeName: 'Gulshan Morning',
                tripType: TripType.pick,
                startedAt: now.subtract(const Duration(minutes: 41)),
                endedAt: now,
                durationSeconds: 2460,
                studentCount: 12,
              ),
            ]));
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
          ratingRepositoryProvider.overrideWithValue(rating),
          checklistRepositoryProvider.overrideWithValue(checklist),
          tripHistoryRepositoryProvider.overrideWithValue(history),
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
    expect(find.text("Today's completed trips"), findsOneWidget);
    expect(find.text('Gulshan Morning'), findsOneWidget);
    expect(find.text('12 students'), findsOneWidget);
  });

  testWidgets('the rating card shows the average, review count and trips',
      (tester) async {
    useTallView(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('4.6'), findsOneWidget);
    expect(find.text('Your rating · 12 reviews'), findsOneWidget);
    expect(find.text('87'), findsOneWidget);
    expect(find.text('trips completed'), findsOneWidget);
  });

  testWidgets('one review is singular', (tester) async {
    useTallView(tester);
    when(() => rating.mySummary()).thenAnswer((_) async => const RatingSummary(
        avgRating: 5, ratingCount: 1, completedTripCount: 1));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Your rating · 1 review'), findsOneWidget);
  });

  testWidgets('no ratings yet, and a failed load looks the same',
      (tester) async {
    useTallView(tester);
    when(() => rating.mySummary())
        .thenAnswer((_) async => throw const NetworkException());
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('No ratings yet'), findsOneWidget);
    expect(find.text('—'), findsWidgets);
    expect(find.text('0'), findsWidgets);
    expect(
        find.text("Today's completed trips"), findsOneWidget); // rest is fine
  });

  testWidgets(
      'scrolled down, a slim bar with the name and buttons stays on top',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    double barOpacity() => tester
        .widget<AnimatedOpacity>(find.byKey(const Key('pinned-header-bar')))
        .opacity;
    expect(barOpacity(), 0);
    await tester.drag(
        find.byType(SingleChildScrollView).first, const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(barOpacity(), 1);
    final bar = find.byType(HomeCompactBar);
    expect(find.descendant(of: bar, matching: find.textContaining('Danish')),
        findsOneWidget);
    expect(find.descendant(of: bar, matching: find.byTooltip('Messages')),
        findsOneWidget);
    expect(find.descendant(of: bar, matching: find.byTooltip('Alerts')),
        findsOneWidget);
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

  testWidgets('a route finished today shows Completed and cannot be started',
      (tester) async {
    useTallView(tester);
    when(() => trips.assignedRoutes()).thenAnswer((_) async => [
          morning.copyWith(
              todayStatus: TodayStatus.completed, tripCompleted: true),
        ]);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Completed ✓'), findsOneWidget);
    expect(find.text("Today's trip is done"), findsOneWidget);
    expect(find.text('Not Started'), findsNothing);
    expect(find.text('Continue Trip'), findsNothing);
    final start = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Start Trip'));
    expect(start.onPressed, isNull);
  });

  testWidgets('a 409 already-completed answer says so and reloads the list',
      (tester) async {
    useTallView(tester);
    var loads = 0;
    when(() => trips.assignedRoutes()).thenAnswer((_) async {
      loads++;
      return [
        loads == 1
            ? morning
            : morning.copyWith(
                todayStatus: TodayStatus.completed, tripCompleted: true),
      ];
    });
    when(() => trips.startTrip(routeId: 'r-1', type: TripType.unknown))
        .thenAnswer((_) async => throw const ApiError(
            status: 409, code: 'TRIP_ALREADY_COMPLETED', message: 'done'));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Trip'));
    await tester.pumpAndSettle();
    expect(find.text("Today's trip for this route is already completed."),
        findsOneWidget);
    expect(find.text('Completed ✓'), findsOneWidget);
  });

  testWidgets('a 409 already-started answer points to Continue Trip',
      (tester) async {
    useTallView(tester);
    var loads = 0;
    when(() => trips.assignedRoutes()).thenAnswer((_) async {
      loads++;
      return [
        loads == 1
            ? morning
            : morning.copyWith(
                tripStarted: true,
                todayStatus: TodayStatus.ongoing,
                tripDetails: const Trip(id: 't-1', status: TripStatus.ongoing)),
      ];
    });
    when(() => trips.startTrip(routeId: 'r-1', type: TripType.unknown))
        .thenAnswer((_) async => throw const ApiError(
            status: 409, code: 'TRIP_ALREADY_STARTED', message: 'running'));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Trip'));
    await tester.pumpAndSettle();
    // The reload turns the card into Continue Trip (home then resumes the
    // trip and says so, which replaces the 409 message).
    expect(find.text('Start Trip'), findsNothing);
    expect(find.text('Continue Trip'), findsOneWidget);
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

  testWidgets('a driver with no van sees no routes', (tester) async {
    useTallView(tester);
    when(() => trips.assignedRoutes()).thenAnswer((_) async =>
        throw const ApiError(status: 400, message: 'Van not found'));
    when(() => trips.driverTrips()).thenAnswer((_) async => []);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('My Route Today'), findsNothing);
    expect(find.text('Start Trip'), findsNothing);
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
        tripHistoryRepositoryProvider.overrideWithValue(history),
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
