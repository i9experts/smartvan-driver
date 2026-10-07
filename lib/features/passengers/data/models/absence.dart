import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'absence.freezed.dart';
part 'absence.g.dart';

/// Which trip(s) an absence covers.
enum AbsenceTripType {
  @JsonValue('pick')
  pick,
  @JsonValue('drop')
  drop,
  @JsonValue('both')
  both,

  /// Anything the backend adds later.
  unknown,
}

/// A parent-declared absence (`GET /kid/absence/today`, backend Phase 4).
@freezed
abstract class Absence with _$Absence {
  const factory Absence({
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String absenceId,
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String kidId,

    /// Calendar day (`YYYY-MM-DD`).
    @JsonKey(fromJson: looseDate) DateTime? date,
    @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
    @Default(AbsenceTripType.unknown)
    AbsenceTripType tripType,
    @JsonKey(fromJson: looseString) String? note,
    @JsonKey(fromJson: looseDateTime) DateTime? createdAt,
  }) = _Absence;

  factory Absence.fromJson(Map<String, dynamic> json) =>
      _$AbsenceFromJson(json);
}
