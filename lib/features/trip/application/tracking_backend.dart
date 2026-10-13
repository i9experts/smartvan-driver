import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/tracking/location_buffer.dart';
import '../../../core/tracking/tracked_point.dart';
import 'in_app_tracking_backend.dart';
import 'service_tracking_backend.dart';

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

/// Which backend this phone uses: the foreground service on Android (it
/// survives the app being swiped away), the app itself elsewhere (iOS keeps
/// the app running in the background with the location background mode).
final trackingBackendProvider = Provider<TrackingBackend>((ref) {
  if (!kIsWeb && Platform.isAndroid) {
    final backend = ServiceTrackingBackend();
    ref.onDispose(backend.dispose);
    return backend;
  }
  final backend = InAppTrackingBackend(
    location: ref.watch(locationServiceProvider),
    api: ref.watch(apiClientProvider),
    openBuffer: () => HiveLocationBuffer.open(),
    clock: ref.watch(clockProvider),
  );
  ref.onDispose(backend.dispose);
  return backend;
});
