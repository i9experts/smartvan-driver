import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/geo_point.dart';
import '../data/models/optimized_route.dart';
import '../data/trip_repository.dart';

part 'optimize_route_controller.g.dart';

/// How asking for a better stop order went.
sealed class OptimizeRouteResult {
  const OptimizeRouteResult();
}

class RouteOptimized extends OptimizeRouteResult {
  const RouteOptimized(this.route);
  final OptimizedRoute route;
}

class OptimizeRouteFailed extends OptimizeRouteResult {
  const OptimizeRouteFailed(this.error);
  final Object error;
}

/// Asks the backend for the best stop order. State is true while a request
/// is in flight.
@riverpod
class OptimizeRouteController extends _$OptimizeRouteController {
  @override
  bool build() => false;

  /// Null when a request is already running.
  Future<OptimizeRouteResult?> optimize({
    required String tripId,
    required GeoPoint position,
  }) async {
    if (state) return null;
    state = true;
    try {
      final route = await ref
          .read(tripRepositoryProvider)
          .optimizeRoute(tripId: tripId, position: position);
      return RouteOptimized(route);
    } catch (e) {
      return OptimizeRouteFailed(e);
    } finally {
      state = false;
    }
  }
}
