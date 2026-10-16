import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/tracking/tracking_session.dart';
import '../background/tracking_service.dart';

/// True after another phone logged in as this driver took the running trip
/// over: this phone stopped tracking and tells the driver. Reset when the
/// driver dismisses the notice or starts tracking again.
final trackingReplacedProvider = StateProvider<bool>((ref) => false);

/// This phone's id, the same every time (a fresh random one is made and kept
/// on first use). Overridden in tests.
final deviceIdProvider = Provider<Future<String> Function()>((ref) {
  return () async {
    const storage = TrackingService.storage;
    final stored = await storage.read(key: TrackingService.stableDeviceIdKey);
    if (stored != null && stored.isNotEmpty) return stored;
    final id = randomId();
    await storage.write(key: TrackingService.stableDeviceIdKey, value: id);
    return id;
  };
});
