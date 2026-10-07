import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../trip/data/active_trip_store.dart';
import '../../trip/data/models/active_trip.dart';
import '../data/fcm_service.dart';

/// Registers this phone's push token with the backend (needs a signed-in
/// user). Overridable in tests; failures are the caller's to ignore.
final pushRegistrarProvider = Provider<Future<void> Function()>(
  (ref) => FCMService.registerTokenWithBackend,
);

/// The trip that was being tracked when the app was last killed, if any.
// TODO(R.4 group C): replaced by the trip feature's own provider.
final resumableTripProvider = Provider<ActiveTrip?>(
  (ref) => ref.watch(activeTripStoreProvider).read(),
);
