import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'route_passenger.freezed.dart';
part 'route_passenger.g.dart';

/// A kid listed on an assigned route (`/route/getAssignedTripByDriver`).
/// Not the same as the live trip `Passenger` (pickup state, parent contact).
@freezed
abstract class RoutePassenger with _$RoutePassenger {
  const factory RoutePassenger({
    @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
    @Default('')
    String kidId,
    @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
    @Default('')
    String fullname,
    @JsonKey(readValue: readImage, fromJson: looseString) String? image,
    @JsonKey(fromJson: looseString) String? grade,
  }) = _RoutePassenger;

  factory RoutePassenger.fromJson(Map<String, dynamic> json) =>
      _$RoutePassengerFromJson(json);
}
