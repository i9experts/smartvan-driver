import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'trip_trail.freezed.dart';
part 'trip_trail.g.dart';

/// `GET /trips/:tripId/trail` → `data`: where the van actually drove.
@freezed
abstract class TripTrail with _$TripTrail {
  const factory TripTrail({
    @JsonKey(fromJson: looseString) String? polyline,
  }) = _TripTrail;

  factory TripTrail.fromJson(Map<String, dynamic> json) =>
      _$TripTrailFromJson(json);
}
