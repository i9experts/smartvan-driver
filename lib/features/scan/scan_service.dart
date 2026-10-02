import '../../core/network/api_errors.dart';
import '../../core/network/api_service.dart';

class ScanResult {
  /// 'picked' or 'dropped'.
  final String action;
  final String kidId;
  final String fullname;
  const ScanResult(this.action, this.kidId, this.fullname);
}

class ScanException implements Exception {
  /// Backend code (INVALID_QR, KID_NOT_ON_TRIP, ALREADY_PICKED, ...),
  /// 'NETWORK' when offline, or null.
  final String? code;
  final String message;
  const ScanException(this.code, this.message);
  @override
  String toString() => message;
}

class ScanService {
  ScanService._();

  /// Only payloads that look like a SmartVan card are sent to the server.
  static bool looksLikeCard(String raw) =>
      RegExp(r'^(smartvan:kid:)?[A-Za-z0-9_-]{24,64}$').hasMatch(raw.trim());

  static Future<ScanResult> scan({
    required String tripId,
    required String qrPayload,
    double? lat,
    double? lng,
  }) async {
    try {
      final response = await ApiService.post('/trips/scanStudent', {
        'tripId': tripId,
        'qrPayload': qrPayload.trim(),
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      });
      final data = response.data is Map ? response.data['data'] : null;
      if (data is! Map) {
        throw const ScanException(null, 'Unexpected response from server.');
      }
      return ScanResult(
        data['action']?.toString() ?? 'picked',
        data['kidId']?.toString() ?? '',
        data['fullname']?.toString() ?? 'Student',
      );
    } on ScanException {
      rethrow;
    } catch (e) {
      if (ApiErrors.isNetworkError(e)) {
        throw const ScanException('NETWORK',
            'No internet. Scanning needs a connection — use the Passengers list instead (it works offline).');
      }
      throw ScanException(ApiErrors.code(e), ApiErrors.message(e, fallback: 'Scan failed. Try again.'));
    }
  }
}
