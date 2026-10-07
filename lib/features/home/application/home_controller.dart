import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/providers/core_providers.dart';
import '../../trip/application/trip_tracking.dart';
import '../../trip/data/models/active_trip.dart';
import '../../trip/data/models/assigned_route.dart';
import '../../trip/data/models/trip.dart';
import '../../trip/data/trip_repository.dart';
import 'home_state.dart';

part 'home_controller.g.dart';

/// Today's routes and trips, and keeping tracking in line with the server.
@riverpod
class HomeController extends _$HomeController {
  @override
  Future<HomeState> build() async {
    final repo = ref.read(tripRepositoryProvider);
    final results = await Future.wait([_routes(repo), _trips(repo)]);
    final routes = results[0] as _RoutesResult;
    final trips = results[1] as List<Trip>;

    DateTime? resumedAt;
    if (routes.loaded) {
      resumedAt = await _reconcileTracking(routes.routes);
    }
    return HomeState(
      routes: routes.routes,
      trips: trips,
      noVan: routes.noVan,
      resumedAt: resumedAt,
    );
  }

  /// A driver with no van / no routes today (or a failed call) is "nothing to
  /// show", never a crash: the empty state covers it.
  Future<_RoutesResult> _routes(TripRepository repo) async {
    try {
      return _RoutesResult(await repo.assignedRoutes(), loaded: true);
    } on ApiError catch (e) {
      return _RoutesResult(const [], noVan: e.status == 400);
    } catch (_) {
      return const _RoutesResult([]);
    }
  }

  /// Non-fatal: falls back to the empty state; pull-to-refresh recovers it.
  Future<List<Trip>> _trips(TripRepository repo) async {
    try {
      return await repo.driverTrips();
    } catch (e) {
      debugPrint('Failed to load driver trips: $e');
      return const [];
    }
  }

  /// Keeps on-device tracking in line with the server:
  /// - a trip is ongoing on the server but this device isn't tracking it
  ///   (app was killed / reinstalled / driver switched phone) → resume;
  /// - this device is tracking but no route has a started trip any more
  ///   (ended from the admin panel) → stop the GPS + foreground service.
  /// Returns when a trip was resumed.
  Future<DateTime?> _reconcileTracking(List<AssignedRoute> routes) async {
    final tracking = ref.read(tripTrackingProvider);
    final notifier = ref.read(tripTrackingProvider.notifier);

    ActiveTrip? ongoing;
    for (final r in routes) {
      final details = r.tripDetails;
      if (r.tripStarted && details != null) {
        ongoing = ActiveTrip.fromTrip(details, routeTitle: r.routeTitle);
        break;
      }
    }

    if (ongoing != null) {
      if (!tracking.isTracking || tracking.tripId != ongoing.id) {
        final result = await notifier.start(ongoing);
        if (result == TrackingStartResult.started) {
          return ref.read(clockProvider)();
        }
      }
    } else if (tracking.isTracking) {
      await notifier.stop();
    }
    return null;
  }

  /// Reloads routes and trips.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

class _RoutesResult {
  const _RoutesResult(this.routes, {this.loaded = false, this.noVan = false});

  final List<AssignedRoute> routes;

  /// The call succeeded (so tracking can be reconciled with it).
  final bool loaded;
  final bool noVan;
}
