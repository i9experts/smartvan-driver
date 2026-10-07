import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'checklist_answer.freezed.dart';
part 'checklist_answer.g.dart';

/// The driver's answer to one checklist item, both in the submitted body
/// and in today's saved checklist.
@freezed
abstract class ChecklistAnswer with _$ChecklistAnswer {
  const factory ChecklistAnswer({
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String key,
    @JsonKey(fromJson: looseBool) @Default(false) bool ok,

    /// Only sent when the answer is "not ok".
    @JsonKey(includeIfNull: false, fromJson: looseString) String? note,
  }) = _ChecklistAnswer;

  factory ChecklistAnswer.fromJson(Map<String, dynamic> json) =>
      _$ChecklistAnswerFromJson(json);
}
