import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import '../../passengers/data/models/scan_result.dart';
import '../../trip/data/models/geo_point.dart';

/// Backend codes of `POST /trips/scanStudent` (`ApiError.code`).
class ScanErrorCodes {
  ScanErrorCodes._();
  static const invalidQr = 'INVALID_QR';
  static const kidNotOnTrip = 'KID_NOT_ON_TRIP';
  static const alreadyPicked = 'ALREADY_PICKED';
  static const alreadyDropped = 'ALREADY_DROPPED';
  static const locationRequired = 'LOCATION_REQUIRED';
  static const tripNotOngoing = 'TRIP_NOT_ONGOING';
}

class ScanRepository {
  const ScanRepository(this._api);

  final ApiClient _api;

  /// Only payloads that look like a SmartVan card are sent to the server.
  static bool looksLikeCard(String raw) =>
      RegExp(r'^(smartvan:kid:)?[A-Za-z0-9_-]{24,64}$').hasMatch(raw.trim());

  /// `POST /trips/scanStudent`. The server decides pick or drop from the
  /// kid's state, so queued picks/drops must be flushed first (the caller
  /// does that). Errors carry the codes in [ScanErrorCodes]; offline is a
  /// `NetworkException`.
  Future<ScanResult> scan({
    required String tripId,
    required String qrPayload,
    GeoPoint? position,
  }) =>
      _api.post(
        '/trips/scanStudent',
        (json) => ScanResult.fromJson(asJsonMap(json)),
        body: {
          'tripId': tripId,
          'qrPayload': qrPayload.trim(),
          if (position != null) 'lat': position.lat,
          // REST spells longitude `lng`.
          if (position != null) 'lng': position.lng,
        },
      );
}

final scanRepositoryProvider = Provider<ScanRepository>(
    (ref) => ScanRepository(ref.watch(apiClientProvider)));
