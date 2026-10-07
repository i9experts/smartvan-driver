import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'checklist_record.dart';

part 'today_checklist.freezed.dart';
part 'today_checklist.g.dart';

/// `GET /trips/checklist/today`. Parse the **whole body**: `data` is
/// today's checklist (or null) and `required` is a sibling of it.
@freezed
abstract class TodayChecklist with _$TodayChecklist {
  const TodayChecklist._();

  const factory TodayChecklist({
    /// Today's submitted checklist; null if not done yet.
    @JsonKey(name: 'data') ChecklistRecord? checklist,

    /// Whether the school requires it before starting a trip.
    @JsonKey(fromJson: looseBool) @Default(false) bool required,
  }) = _TodayChecklist;

  factory TodayChecklist.fromJson(Map<String, dynamic> json) =>
      _$TodayChecklistFromJson(json);

  bool get done => checklist != null;
  bool get allOk => checklist?.allOk != false;
}
