import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_providers.dart';
import '../../trip/data/models/geo_point.dart';

class SafetyRepository {
  const SafetyRepository(this._api);

  final ApiClient _api;

  /// `POST /alert/sos`. Returns how many parents were notified.
  ///
  /// Throws `ApiError` on failure; `code == 'SOS_RATE_LIMITED'` (429) means
  /// an SOS was already sent recently — the caller treats that as success.
  Future<int> sendSos({
    String? tripId,
    required GeoPoint position,
    String? message,
  }) {
    final text = message?.trim();
    return _api.post(
      '/alert/sos',
      (json) {
        final n = json is Map ? json['parentsNotified'] : null;
        return n is int ? n : 0;
      },
      body: {
        if (tripId != null) 'tripId': tripId,
        // REST spells longitude `lng`.
        'lat': position.lat,
        'lng': position.lng,
        if (text != null && text.isNotEmpty) 'message': text,
      },
    );
  }
}

final safetyRepositoryProvider = Provider<SafetyRepository>(
    (ref) => SafetyRepository(ref.watch(apiClientProvider)));
