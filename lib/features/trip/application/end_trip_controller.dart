import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/app_exception.dart';
import '../data/kids_not_dropped_error.dart';
import '../data/models/kid_not_dropped.dart';
import 'trip_tracking.dart';

part 'end_trip_controller.g.dart';

/// How an attempt to end the trip went.
sealed class EndTripResult {
  const EndTripResult();
}

class TripEnded extends EndTripResult {
  const TripEnded({required this.forced});

  /// Ended although kids were still marked picked (the driver confirmed).
  final bool forced;
}

/// The server refused: these kids are still marked in the van.
class KidsStillOnBoard extends EndTripResult {
  const KidsStillOnBoard(this.kids);
  final List<KidNotDropped> kids;
}

/// Pickups/drops are still waiting to sync; ending now would lose them.
class UnsyncedUpdates extends EndTripResult {
  const UnsyncedUpdates(this.count);
  final int count;
}

class EndTripFailed extends EndTripResult {
  const EndTripFailed(this.error);
  final Object error;
}

/// Ends the trip. State is true while a request is in flight.
@riverpod
class EndTripController extends _$EndTripController {
  @override
  bool build() => false;

  Future<EndTripResult> end({bool forceEnd = false, String? note}) async {
    state = true;
    try {
      await ref
          .read(tripTrackingProvider.notifier)
          .endTrip(forceEnd: forceEnd, confirmationNote: note);
      return TripEnded(forced: forceEnd);
    } on PendingSyncException catch (e) {
      return UnsyncedUpdates(e.pending);
    } on ApiError catch (e) {
      return e.isKidsNotDropped ? KidsStillOnBoard(e.kidsNotDropped) : EndTripFailed(e);
    } catch (e) {
      return EndTripFailed(e);
    } finally {
      state = false;
    }
  }
}
