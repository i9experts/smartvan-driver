import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/pending_ratee.dart';

part 'rate_trip_state.freezed.dart';

/// Where the driver is in rating the parents of a finished trip.
@freezed
abstract class RateTripState with _$RateTripState {
  const RateTripState._();

  const factory RateTripState({
    @Default(<PendingRatee>[]) List<PendingRatee> queue,

    /// The parent being rated.
    @Default(0) int index,

    /// 0 = nothing picked yet.
    @Default(0) int stars,
    @Default(false) bool submitting,
  }) = _RateTripState;

  PendingRatee get current => queue[index];
  bool get isLast => index >= queue.length - 1;
}
