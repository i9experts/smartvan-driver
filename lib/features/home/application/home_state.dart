import 'package:freezed_annotation/freezed_annotation.dart';
import '../../trip/data/models/assigned_route.dart';
import '../../trip/data/models/trip.dart';
import '../../trip/data/models/trip_status.dart';

part 'home_state.freezed.dart';

/// What the Home screen shows about today.
@freezed
abstract class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    /// Today's routes with their kids (empty when none or no van).
    @Default(<AssignedRoute>[]) List<AssignedRoute> routes,

    /// The driver's trips.
    @Default(<Trip>[]) List<Trip> trips,

    /// The server says this driver has no van — there is nothing to show
    /// today. (The screen treats it like "no trip today".)
    @Default(false) bool noVan,

    /// Set when this load found a trip already running on the server that
    /// this phone was not tracking, and resumed tracking it.
    DateTime? resumedAt,
  }) = _HomeState;

  /// Distinct kids across today's routes.
  int get passengerCount => {
        for (final r in routes)
          for (final p in r.passengers)
            if (p.kidId.isNotEmpty) p.kidId
      }.length;

  int get completedTrips =>
      trips.where((t) => t.status == TripStatus.completed).length;
}
