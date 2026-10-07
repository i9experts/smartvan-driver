import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'checklist_answer.dart';

part 'checklist_record.freezed.dart';
part 'checklist_record.g.dart';

/// A checklist the driver has already submitted today.
@freezed
abstract class ChecklistRecord with _$ChecklistRecord {
  const factory ChecklistRecord({
    /// null when the backend did not say; treated as "all ok".
    @JsonKey(fromJson: _nullableBool) bool? allOk,
    @Default(<ChecklistAnswer>[]) List<ChecklistAnswer> items,
    @JsonKey(fromJson: looseString) String? photoUrl,
  }) = _ChecklistRecord;

  factory ChecklistRecord.fromJson(Map<String, dynamic> json) =>
      _$ChecklistRecordFromJson(json);
}

bool? _nullableBool(Object? v) => v == null ? null : looseBool(v);
