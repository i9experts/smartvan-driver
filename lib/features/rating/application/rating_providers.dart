import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/pending_ratee.dart';
import '../data/models/rating_summary.dart';
import '../data/rating_repository.dart';

part 'rating_providers.g.dart';

/// The driver's own rating for the Home card. Non-fatal: when it can't be
/// loaded the card just shows "No ratings yet".
@riverpod
Future<RatingSummary> ratingSummary(Ref ref) async {
  try {
    return await ref.watch(ratingRepositoryProvider).mySummary();
  } catch (e) {
    debugPrint('Failed to load rating summary: $e');
    return const RatingSummary();
  }
}

/// The parents of the just-ended [tripId] still to be rated. Best-effort: a
/// failed load is an empty list, so ending a trip is never blocked by it.
///
/// Kept alive so the answer fetched when the trip ends is the one the rating
/// screen shows; invalidate it before asking again.
@Riverpod(keepAlive: true)
Future<List<PendingRatee>> pendingRatees(Ref ref, String tripId) async {
  try {
    return await ref.read(ratingRepositoryProvider).pendingForTrip(tripId);
  } catch (e) {
    debugPrint('Failed to load pending ratings: $e');
    return const [];
  }
}
