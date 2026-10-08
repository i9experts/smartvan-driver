import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/app_exception.dart';
import '../../trip/data/kids_not_dropped_error.dart';
import '../../trip/data/models/active_trip.dart';
import '../../trip/data/models/assigned_route.dart';
import '../../trip/data/trip_repository.dart';
import 'home_controller.dart';

part 'start_trip_controller.g.dart';

/// How "Start Trip" ended.
sealed class StartTripResult {
  const StartTripResult();
}

class TripStarted extends StartTripResult {
  const TripStarted(this.trip);

  /// The new trip, with the route's title merged in.
  final ActiveTrip trip;
}

/// The school needs today's van check and the driver did not finish it.
class ChecklistNotDone extends StartTripResult {
  const ChecklistNotDone();
}

/// 409 `TRIP_ALREADY_COMPLETED`: the route's trip for today is done.
class TripAlreadyCompleted extends StartTripResult {
  const TripAlreadyCompleted();
}

/// 409 `TRIP_ALREADY_STARTED`: the route's trip is already running.
class TripAlreadyStarted extends StartTripResult {
  const TripAlreadyStarted();
}

class StartTripFailed extends StartTripResult {
  const StartTripFailed(this.error);
  final Object error;
}

/// Starts a trip from a route. State is the id of the route being started
/// (null when idle).
@riverpod
class StartTripController extends _$StartTripController {
  @override
  String? build() => null;

  /// Starts [route]'s trip. When the school requires the van check first,
  /// [completeChecklist] is called (it opens the check; true = submitted) and
  /// the start is retried once it was.
  Future<StartTripResult> start(
    AssignedRoute route, {
    required Future<bool> Function() completeChecklist,
  }) async {
    if (route.routeId.isEmpty) return const StartTripFailed('no route id');
    state = route.routeId;
    try {
      try {
        return await _start(route);
      } on ApiError catch (e) {
        if (e.code != TripErrorCodes.checklistRequired) return _failed(e);
      }
      if (!await completeChecklist()) return const ChecklistNotDone();
      return await _start(route);
    } catch (e) {
      return _failed(e);
    } finally {
      state = null;
    }
  }

  /// The two 409s say the home list is out of date: reload it so the card
  /// shows what the server knows.
  StartTripResult _failed(Object error) {
    final code = error is ApiError ? error.code : null;
    if (code == TripErrorCodes.tripAlreadyCompleted) {
      ref.invalidate(homeControllerProvider);
      return const TripAlreadyCompleted();
    }
    if (code == TripErrorCodes.tripAlreadyStarted) {
      ref.invalidate(homeControllerProvider);
      return const TripAlreadyStarted();
    }
    return StartTripFailed(error);
  }

  Future<StartTripResult> _start(AssignedRoute route) async {
    final trip = await ref
        .read(tripRepositoryProvider)
        .startTrip(routeId: route.routeId, type: route.tripType);
    // The raw trip document has no route title of its own (just a bare
    // routeId) — merge it in from the route we already have.
    final active = ActiveTrip.fromTrip(trip, routeTitle: route.routeTitle);
    ref.invalidate(homeControllerProvider);
    return TripStarted(active);
  }
}
