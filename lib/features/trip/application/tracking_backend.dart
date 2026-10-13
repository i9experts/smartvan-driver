import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/tracking/location_buffer.dart';
import '../../../core/tracking/tracked_point.dart';
import 'in_app_tracking_backend.dart';

/// Whatever produces and uploads the van's points while a trip runs. The
/// trip's [TripTracking] only starts and stops it and listens to what it
/// reports.
abstract interface class TrackingBackend {
  /// Every point as the van moves — real readings and the repeats while it
  /// stands still — for the live map relay and the screen.
  Stream<TrackedPoint> get fixes;

  /// The server says this trip is not ongoing any more.
  Stream<void> get tripOver;

  Future<void> start(String tripId);

  Future<void> stop();

  Future<void> dispose();
}

/// Which backend this phone uses. In the app itself everywhere (iOS keeps the
/// app alive in the background with the location background mode); the
/// Android build swaps in the foreground-service backend (see
/// `service_tracking_backend.dart`) from `bootstrap`.
final trackingBackendProvider = Provider<TrackingBackend>((ref) {
  final backend = InAppTrackingBackend(
    location: ref.watch(locationServiceProvider),
    api: ref.watch(apiClientProvider),
    openBuffer: () => HiveLocationBuffer.open(),
    clock: ref.watch(clockProvider),
  );
  ref.onDispose(backend.dispose);
  return backend;
});
