/// One place to read a kid's pickup status for the current trip.
///
/// The backend isn't consistent about the field name (`tripStatus` on
/// some endpoints, `status` on others), and the offline queue may hold a
/// newer status that hasn't reached the server yet.
class KidStatus {
  KidStatus._();

  static const picked = 'picked';
  static const dropped = 'dropped';
  static const pending = 'pending';

  static String? idOf(Map kid) =>
      (kid['kidId'] ?? kid['_id'] ?? kid['id'])?.toString();

  /// [pendingSync] = SyncQueue.pendingKidStatuses(tripId).
  static String of(Map kid, {Map<String, String> pendingSync = const {}}) {
    final id = idOf(kid);
    final local = id == null ? null : pendingSync[id];
    if (local != null) return local;
    final server = (kid['tripStatus'] ?? kid['status'] ?? '').toString().toLowerCase();
    return server.isEmpty ? pending : server;
  }

  static bool isPickedOrDropped(String status) =>
      status == picked || status == dropped;
}
