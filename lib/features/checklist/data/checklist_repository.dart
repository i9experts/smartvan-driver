import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import 'models/checklist_answer.dart';
import 'models/checklist_item_def.dart';
import 'models/today_checklist.dart';

/// The pre-trip van check.
class ChecklistRepository {
  const ChecklistRepository(this._api);

  final ApiClient _api;

  /// `GET /trips/checklist/items` — the questions.
  Future<List<ChecklistItemDef>> items() => _api.get(
        '/trips/checklist/items',
        (json) => asJsonList(json).map(ChecklistItemDef.fromJson).toList(),
      );

  /// `GET /trips/checklist/today`. Reads the whole body: `required` sits
  /// next to `data`.
  Future<TodayChecklist> today() => _api.getEnvelope(
        '/trips/checklist/today',
        (e) => TodayChecklist.fromJson(asJsonMap(e.raw)),
      );

  /// `POST /trips/checklist`. [photoUrl] comes from an earlier image upload.
  Future<void> submit({
    String? routeId,
    required List<ChecklistAnswer> answers,
    String? photoUrl,
  }) =>
      _api.post<void>(
        '/trips/checklist',
        (_) {},
        body: {
          if (routeId != null) 'routeId': routeId,
          'items': answers.map((a) => a.toJson()).toList(),
          if (photoUrl != null) 'photoUrl': photoUrl,
        },
      );
}

final checklistRepositoryProvider = Provider<ChecklistRepository>(
    (ref) => ChecklistRepository(ref.watch(apiClientProvider)));
