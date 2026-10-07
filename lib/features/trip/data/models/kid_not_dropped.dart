import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'kid_not_dropped.freezed.dart';
part 'kid_not_dropped.g.dart';

/// A kid still on the van, from the 409 `KIDS_NOT_DROPPED` answer of
/// `POST /trips/endTrip` (`ApiError.data['kids']`).
@freezed
abstract class KidNotDropped with _$KidNotDropped {
  const factory KidNotDropped({
    @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
    @Default('')
    String kidId,
    @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
    @Default('')
    String fullname,
  }) = _KidNotDropped;

  factory KidNotDropped.fromJson(Map<String, dynamic> json) =>
      _$KidNotDroppedFromJson(json);
}
