import '../../core/network/api_service.dart';

/// "At stop" / no-show calls (backend Phase 4).
class StopApi {
  StopApi._();

  /// Tells the parent the van is at the stop. Returns waitingSince.
  static Future<DateTime> arrived(String tripId, String kidId) async {
    final res = await ApiService.post('/trips/arrivedAtStop', {'tripId': tripId, 'kidId': kidId});
    final data = res.data is Map ? res.data['data'] : null;
    final at = data is Map ? DateTime.tryParse(data['waitingSince']?.toString() ?? '') : null;
    return (at ?? DateTime.now().toUtc()).toLocal();
  }

  static Future<void> noShow(String tripId, String kidId, {String? note}) async {
    await ApiService.post('/trips/noShow', {
      'tripId': tripId,
      'kidId': kidId,
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
    });
  }
}
