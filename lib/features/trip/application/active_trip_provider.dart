import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/active_trip_store.dart';
import '../data/models/active_trip.dart';
import 'trip_tracking.dart';

part 'active_trip_provider.g.dart';

/// The running trip with id [tripId]: what tracking holds, or — right after
/// the app was killed and reopened — what was saved on disk. Null when this
/// phone has no such trip.
@riverpod
ActiveTrip? activeTripFor(Ref ref, String tripId) {
  final tracked = ref.watch(tripTrackingProvider.select((s) => s.trip));
  if (tracked?.id == tripId) return tracked;
  final stored = ref.watch(activeTripStoreProvider).read();
  return stored?.id == tripId ? stored : null;
}
