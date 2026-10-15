import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/features/trip/data/models/trip_type.dart';
import 'package:smartvan_driver/features/trip_history/data/models/completed_trip.dart';
import 'package:smartvan_driver/features/trip_history/data/models/completed_trips_page.dart';
import 'package:smartvan_driver/features/trip_history/data/trip_history_repository.dart';

class MockHistoryRepo extends Mock implements TripHistoryRepository {}

/// A finished trip ending [endedAt] (UTC).
CompletedTrip completedTrip(
  String id,
  DateTime endedAt, {
  TripType type = TripType.pick,
  String? route,
}) =>
    CompletedTrip(
      id: id,
      routeName: route ?? 'Route $id',
      tripType: type,
      startedAt: endedAt.subtract(const Duration(minutes: 41)),
      endedAt: endedAt,
      durationSeconds: 2460,
      studentCount: 12,
    );

CompletedTripsPage historyPage(List<CompletedTrip> items,
        {int page = 1, bool hasMore = false}) =>
    CompletedTripsPage(
        items: items, total: items.length, page: page, hasMore: hasMore);
