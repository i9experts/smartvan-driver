import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'absence.dart';

part 'kid_absence_event.freezed.dart';
part 'kid_absence_event.g.dart';

/// Socket event `kidAbsence` / `kidAbsenceCancelled` on `user:<driverId>`:
/// `{ kidId, fullname, date, tripType }`. [cancelled] is not sent; the
/// listener sets it from the event name.
@freezed
abstract class KidAbsenceEvent with _$KidAbsenceEvent {
  const factory KidAbsenceEvent({
    @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
    @Default('')
    String kidId,
    @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
    @Default('')
    String fullname,
    @JsonKey(fromJson: looseDate) DateTime? date,
    @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
    @Default(AbsenceTripType.unknown)
    AbsenceTripType tripType,
    @JsonKey(fromJson: looseBool) @Default(false) bool cancelled,
  }) = _KidAbsenceEvent;

  factory KidAbsenceEvent.fromJson(Map<String, dynamic> json) =>
      _$KidAbsenceEventFromJson(json);
}
