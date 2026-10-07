import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'checklist_item_def.freezed.dart';
part 'checklist_item_def.g.dart';

/// One question of the pre-trip van check (`GET /trips/checklist/items`).
@freezed
abstract class ChecklistItemDef with _$ChecklistItemDef {
  const factory ChecklistItemDef({
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String key,
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String label,
  }) = _ChecklistItemDef;

  factory ChecklistItemDef.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemDefFromJson(json);
}
