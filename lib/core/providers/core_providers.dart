import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart' as loc;
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../network/network_providers.dart';
import '../sync/sync_queue.dart';

/// Dependency-injection seams from docs/ARCHITECTURE.md §3. Each wraps the
/// object the app used to reach through a static / global / inline `new`,
/// so tests can override it with a fake. Callers move over feature by
/// feature in R.4; until then these return the very same instances.

/// Offline queue for picks/drops/locations. Call `init()` once at start-up.
final syncQueueProvider = Provider<SyncQueue>((ref) {
  final queue = SyncQueue(ref.watch(apiClientProvider));
  ref.onDispose(queue.dispose);
  return queue;
});

/// GPS access (was `Location()` created inside `TripTrackingNotifier`).
final locationServiceProvider = Provider<loc.Location>((ref) => loc.Location());

/// Creates a Socket.IO client (was `io.io(...)` created inline).
typedef SocketFactory = io.Socket Function(
    String url, Map<String, dynamic> options);

final socketFactoryProvider = Provider<SocketFactory>(
  (ref) => (url, options) => io.io(url, options),
);

/// "Now" — a provider so time-dependent logic can be tested.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
