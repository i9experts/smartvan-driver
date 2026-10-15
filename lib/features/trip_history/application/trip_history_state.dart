import 'package:freezed_annotation/freezed_annotation.dart';
import '../../trip/data/models/trip_type.dart';
import '../data/models/completed_trip.dart';

part 'trip_history_state.freezed.dart';

/// The History list: the pages loaded so far and the type filter.
@freezed
abstract class TripHistoryState with _$TripHistoryState {
  const TripHistoryState._();

  const factory TripHistoryState({
    @Default(<CompletedTrip>[]) List<CompletedTrip> items,

    /// The last page loaded.
    @Default(1) int page,
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,

    /// The last "load more" failed (the list stays; a retry row shows).
    @Default(false) bool loadMoreFailed,

    /// null = All, else only trips of this direction.
    TripType? filter,
  }) = _TripHistoryState;

  /// [items] after the filter.
  List<CompletedTrip> get visible => filter == null
      ? items
      : items.where((t) => t.tripType == filter).toList();
}
