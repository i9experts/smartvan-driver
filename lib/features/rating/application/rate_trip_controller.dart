import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/rating_repository.dart';
import 'rate_trip_state.dart';
import 'rating_providers.dart';

part 'rate_trip_controller.g.dart';

/// How rating or skipping a parent went.
sealed class RateTripResult {
  const RateTripResult();
}

/// Moved on (or finished, when [finished]).
class RateTripAdvanced extends RateTripResult {
  const RateTripAdvanced({required this.finished, required this.rated});

  /// That was the last parent: leave the screen.
  final bool finished;

  /// A rating was sent (false when skipped).
  final bool rated;
}

class RateTripFailed extends RateTripResult {
  const RateTripFailed(this.error);
  final Object error;
}

/// Steps through the parents of one ended trip: rate and go on, or skip.
@riverpod
class RateTripController extends _$RateTripController {
  @override
  Future<RateTripState> build(String tripId) async {
    final queue = await ref.watch(pendingRateesProvider(tripId).future);
    return RateTripState(queue: queue);
  }

  void setStars(int stars) {
    final s = state.valueOrNull;
    if (s != null) state = AsyncData(s.copyWith(stars: stars));
  }

  /// Goes to the next parent without rating this one.
  RateTripAdvanced skip() => _advance(rated: false);

  /// Sends the rating for the current parent, then goes on. Does nothing
  /// until a star is picked or while a request is in flight.
  Future<RateTripResult?> submit(String comment) async {
    final s = state.valueOrNull;
    if (s == null || s.stars == 0 || s.submitting) return null;
    state = AsyncData(s.copyWith(submitting: true));
    try {
      await ref.read(ratingRepositoryProvider).rateTrip(
            tripId: s.current.tripId,
            rateeUserId: s.current.parentId,
            stars: s.stars,
            comment: comment.trim(),
          );
      return _advance(rated: true);
    } catch (e) {
      return RateTripFailed(e);
    } finally {
      final now = state.valueOrNull;
      if (now != null) state = AsyncData(now.copyWith(submitting: false));
    }
  }

  RateTripAdvanced _advance({required bool rated}) {
    final s = state.requireValue;
    if (s.isLast) return RateTripAdvanced(finished: true, rated: rated);
    state = AsyncData(s.copyWith(index: s.index + 1, stars: 0));
    return RateTripAdvanced(finished: false, rated: rated);
  }
}
