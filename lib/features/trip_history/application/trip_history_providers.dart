import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/formatting/pkt.dart';
import '../../../core/providers/core_providers.dart';
import '../../trip/data/models/trip_trail.dart';
import '../../trip/data/models/trip_type.dart';
import '../../trip/data/trip_repository.dart';
import '../data/models/completed_trip.dart';
import '../data/models/trip_details.dart';
import '../data/trip_history_repository.dart';
import 'trip_history_state.dart';

part 'trip_history_providers.g.dart';

/// How many of today's trips Home shows.
const homeTodayTripLimit = 3;

/// Page size of the History list.
const historyPageSize = 20;

/// Most pages fetched in one go while a filter leaves a page empty.
const _maxFilterPages = 5;

/// Today's (PKT) completed trips for Home: at most [homeTodayTripLimit],
/// newest first. The server already limits to today; the PKT-day check
/// guards against a trip of another day slipping in.
@riverpod
Future<List<CompletedTrip>> todayCompletedTrips(Ref ref) async {
  final page = await ref
      .watch(tripHistoryRepositoryProvider)
      .completed(scope: HistoryScope.today, limit: homeTodayTripLimit);
  final today = pktDay(ref.read(clockProvider)());
  return page.items
      .where((t) => t.when != null && pktDay(t.when!) == today)
      .take(homeTodayTripLimit)
      .toList();
}

/// The paginated History list (infinite scroll, pull-to-refresh, filter).
@riverpod
class TripHistory extends _$TripHistory {
  @override
  Future<TripHistoryState> build() async {
    final page = await ref
        .watch(tripHistoryRepositoryProvider)
        .completed(limit: historyPageSize);
    return TripHistoryState(items: page.items, hasMore: page.hasMore);
  }

  TripHistoryState? get _current => state.valueOrNull;

  /// Reloads from the first page; the list stays on screen meanwhile.
  Future<void> refresh() async {
    final filter = _current?.filter;
    ref.invalidateSelf();
    final fresh = await future;
    if (filter != null) state = AsyncData(fresh.copyWith(filter: filter));
  }

  /// Shows [filter] (null = All). Loads more when the filter leaves nothing
  /// to show yet.
  Future<void> setFilter(TripType? filter) async {
    final current = _current;
    if (current == null) return;
    state = AsyncData(current.copyWith(filter: filter));
    await loadMore(untilVisible: true);
  }

  /// Loads the next page. Failures keep the list and set `loadMoreFailed`.
  /// With [untilVisible] it keeps going (a few pages at most) while the
  /// filter shows nothing.
  Future<void> loadMore({bool untilVisible = false}) async {
    var current = _current;
    if (current == null || current.loadingMore || !current.hasMore) return;
    if (untilVisible && current.visible.isNotEmpty) return;
    state =
        AsyncData(current.copyWith(loadingMore: true, loadMoreFailed: false));
    try {
      for (var i = 0; i < _maxFilterPages; i++) {
        final latest = _current ?? current!;
        final page = await ref
            .read(tripHistoryRepositoryProvider)
            .completed(page: latest.page + 1, limit: historyPageSize);
        final known = {for (final t in latest.items) t.id};
        current = (_current ?? latest).copyWith(
          items: [
            ...latest.items,
            ...page.items.where((t) => !known.contains(t.id)),
          ],
          page: page.page,
          hasMore: page.hasMore,
        );
        state = AsyncData(current.copyWith(loadingMore: true));
        if (!untilVisible || current.visible.isNotEmpty || !current.hasMore) {
          break;
        }
      }
      state = AsyncData(current!.copyWith(loadingMore: false));
    } catch (_) {
      final latest = _current ?? current!;
      state =
          AsyncData(latest.copyWith(loadingMore: false, loadMoreFailed: true));
    }
  }
}

/// One finished trip with its stops, students, alerts and school.
@riverpod
Future<TripDetails> tripDetails(Ref ref, String tripId) =>
    ref.watch(tripHistoryRepositoryProvider).details(tripId);

/// The saved driven path of a finished trip. A trail that cannot be loaded
/// is an empty one: the screen says the route is not available.
@riverpod
Future<TripTrail> historyTrail(Ref ref, String tripId) async {
  try {
    return await ref.watch(tripRepositoryProvider).trail(tripId);
  } catch (_) {
    return const TripTrail();
  }
}
