import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart' as loc;
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../sync/sync_queue.dart';

/// Dependency-injection seams from docs/ARCHITECTURE.md §3. Each wraps the
/// object the app used to reach through a static / global / inline `new`,
/// so tests can override it with a fake. Callers move over feature by
/// feature in R.4; until then these return the very same instances.

/// Offline queue for picks/drops/locations (was `SyncQueue.instance`).
final syncQueueProvider = Provider<SyncQueue>((ref) => SyncQueue.instance);

/// GPS access (was `Location()` created inside `TripTrackingNotifier`).
final locationServiceProvider =
    Provider<loc.Location>((ref) => loc.Location());

/// Creates a Socket.IO client (was `io.io(...)` created inline).
typedef SocketFactory = io.Socket Function(
    String url, Map<String, dynamic> options);

final socketFactoryProvider = Provider<SocketFactory>(
  (ref) => (url, options) => io.io(url, options),
);
