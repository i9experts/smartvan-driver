import 'package:url_launcher/url_launcher.dart';
import '../../core/network/api_service.dart';

/// Pakistan emergency numbers shown when an SOS can't be sent (or as a
/// follow-up after it is).
class EmergencyNumbers {
  EmergencyNumbers._();
  static const police = '15';
  static const rescue = '1122';
  static const edhi = '115';

  static Future<void> call(String number) async {
    await launchUrl(Uri(scheme: 'tel', path: number));
  }
}

class SosService {
  SosService._();

  /// Sends a driver SOS. Returns how many parents were notified.
  /// Throws the API error on failure (429 = already sent recently).
  static Future<int> send({
    String? tripId,
    required double lat,
    required double lng,
    String? message,
  }) async {
    final response = await ApiService.post('/alert/sos', {
      if (tripId != null) 'tripId': tripId,
      'lat': lat,
      'lng': lng,
      if (message != null && message.trim().isNotEmpty) 'message': message.trim(),
    });
    final data = response.data is Map ? response.data['data'] : null;
    final n = data is Map ? data['parentsNotified'] : null;
    return n is int ? n : 0;
  }
}
