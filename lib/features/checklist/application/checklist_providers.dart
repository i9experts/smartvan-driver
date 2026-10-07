import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/checklist_repository.dart';
import '../data/models/checklist_item_def.dart';
import '../data/models/today_checklist.dart';

part 'checklist_providers.g.dart';

/// Today's van check status (done? all ok? required by the school?). The
/// home screen's card watches it; invalidate after a submit.
@riverpod
Future<TodayChecklist> todayChecklist(Ref ref) =>
    ref.watch(checklistRepositoryProvider).today();

/// What the checklist screen needs: the questions and today's saved answers.
class ChecklistFormData {
  const ChecklistFormData(this.items, this.today);

  final List<ChecklistItemDef> items;
  final TodayChecklist today;
}

@riverpod
Future<ChecklistFormData> checklistFormData(Ref ref) async {
  final repo = ref.watch(checklistRepositoryProvider);
  final results = await Future.wait([repo.items(), repo.today()]);
  return ChecklistFormData(
    results[0] as List<ChecklistItemDef>,
    results[1] as TodayChecklist,
  );
}
