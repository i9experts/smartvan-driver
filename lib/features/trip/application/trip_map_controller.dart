import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/map/geo_math.dart';
import '../../../core/map/polyline_codec.dart';
import '../../passengers/application/passengers_controller.dart';
import '../../passengers/application/passengers_state.dart';
import '../data/models/route_plan.dart';
import '../data/trip_repository.dart';
import 'trip_tracking.dart';

part 'trip_map_controller.g.dart';

/// How often the plan is reloaded even when nothing happened (the server
/// re-routes from the van's position).
const routePlanRefreshInterval = Duration(seconds: 60);

/// A new live fix closer than this to the last trail point is not added.
const _minTrailStepMeters = 1.0;

/// The trip's planned route: stops, school and the road ahead. Reloaded
/// every 60 s and whenever a kid's pick / drop / absent / no-show state
/// changes. A failed reload keeps the last plan.
@riverpod
class RoutePlanController extends _$RoutePlanController {
  Timer? _timer;

  @override
  Future<RoutePlan> build(String tripId) async {
    _timer = Timer.periodic(routePlanRefreshInterval, (_) => reload());
    ref.onDispose(() => _timer?.cancel());
    ref.listen(passengersControllerProvider(tripId), (previous, next) {
      final before = _signature(previous?.valueOrNull);
      final after = _signature(next.valueOrNull);
      if (before != null && after != null && before != after) reload();
    });
    return ref.read(tripRepositoryProvider).routePlan(tripId);
  }

  /// Same value as long as no kid's state changed.
  String? _signature(PassengersState? p) => p?.passengers
      .map((k) => '${k.id}:${p.statusOf(k)}:${k.absent}:${k.noShow}')
      .join('|');

  /// Reloads quietly; the old plan stays if it fails.
  Future<void> reload() async {
    try {
      final plan = await ref.read(tripRepositoryProvider).routePlan(tripId);
      state = AsyncData(plan);
    } catch (_) {
      // Keep what is on the map.
    }
  }
}

/// Where the van has been: the server's trail, then every live fix.
@riverpod
class TripTrailController extends _$TripTrailController {
  @override
  Future<List<LatLng>> build(String tripId) async {
    final trail = await ref.read(tripRepositoryProvider).trail(tripId);
    final points = decodePolyline(trail.polyline);
    ref.listen(tripTrackingProvider.select((s) => s.lastPosition),
        (_, position) {
      if (position == null) return;
      _append(LatLng(position.lat, position.lng));
    });
    return points;
  }

  void _append(LatLng point) {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.isNotEmpty &&
        distanceMeters(current.last, point) < _minTrailStepMeters) {
      return;
    }
    state = AsyncData([...current, point]);
  }
}
