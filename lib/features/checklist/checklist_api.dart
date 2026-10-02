import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_service.dart';

class ChecklistItemDef {
  final String key;
  final String label;
  const ChecklistItemDef(this.key, this.label);
}

class TodayChecklist {
  /// Today's submitted checklist (null if not done yet).
  final Map<String, dynamic>? checklist;

  /// Whether the school requires it before starting a trip.
  final bool required;
  const TodayChecklist(this.checklist, this.required);

  bool get done => checklist != null;
  bool get allOk => checklist?['allOk'] != false;
}

class ChecklistApi {
  ChecklistApi._();

  static Future<List<ChecklistItemDef>> items() async {
    final res = await ApiService.get('/trips/checklist/items');
    final data = res.data is Map ? res.data['data'] : null;
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((m) => ChecklistItemDef(m['key'].toString(), m['label'].toString()))
        .toList();
  }

  static Future<TodayChecklist> today() async {
    final res = await ApiService.get('/trips/checklist/today');
    final body = res.data is Map ? res.data as Map : const {};
    final data = body['data'];
    return TodayChecklist(
      data is Map ? Map<String, dynamic>.from(data) : null,
      body['required'] == true,
    );
  }

  static Future<void> submit({
    String? routeId,
    required List<Map<String, dynamic>> items,
    String? photoUrl,
  }) async {
    await ApiService.post('/trips/checklist', {
      if (routeId != null) 'routeId': routeId,
      'items': items,
      if (photoUrl != null) 'photoUrl': photoUrl,
    });
  }
}

/// Today's van check status for the home screen. Invalidate after submit.
final todayChecklistProvider =
    FutureProvider.autoDispose<TodayChecklist>((ref) => ChecklistApi.today());
