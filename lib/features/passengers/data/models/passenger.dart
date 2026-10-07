import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import '../../../trip/data/models/trip_type.dart';
import 'kid_trip_status.dart';
import 'parent_contact.dart';

part 'passenger.freezed.dart';
part 'passenger.g.dart';

/// A kid on the live trip (`GET /Route/getMergedActivePassengers`).
///
/// The offline queue may hold a newer status than the server; overlaying it
/// is the controller's job, not the model's.
@freezed
abstract class Passenger with _$Passenger {
  const Passenger._();

  const factory Passenger({
    @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
    @Default('')
    String id,
    @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
    @Default('')
    String fullname,
    @JsonKey(readValue: readImage, fromJson: looseString) String? image,

    /// `tripStatus` on some endpoints, `status` on others; missing = pending.
    @JsonKey(readValue: readTripStatus, unknownEnumValue: KidTripStatus.unknown)
    @Default(KidTripStatus.pending)
    KidTripStatus tripStatus,
    @JsonKey(fromJson: looseString) String? tripId,

    /// Direction of the trip this row belongs to (`pick` | `drop`).
    @JsonKey(readValue: readTripTypeLower, unknownEnumValue: TripType.unknown)
    @Default(TripType.unknown)
    TripType tripType,
    @JsonKey(fromJson: looseString) String? grade,
    @JsonKey(readValue: readSchoolName, fromJson: looseString)
    String? schoolName,

    /// Distance to the stop, as the backend formats it (a string).
    @JsonKey(fromJson: looseString) String? distance,
    @JsonKey(readValue: readParentContact)
    @Default(ParentContact())
    ParentContact parent,

    // ---- Phase 4 ------------------------------------------------------

    /// A parent marked this kid absent for today.
    @JsonKey(fromJson: looseBool) @Default(false) bool absent,
    @JsonKey(fromJson: looseString) String? absenceNote,

    /// Set once the driver pressed "At stop".
    @JsonKey(fromJson: looseDateTime) DateTime? waitingSince,

    /// Driver marked "not at stop — moved on".
    @JsonKey(fromJson: looseBool) @Default(false) bool noShow,
  }) = _Passenger;

  factory Passenger.fromJson(Map<String, dynamic> json) =>
      _$PassengerFromJson(json);

  bool get isPicked => tripStatus == KidTripStatus.picked;
  bool get isDropped => tripStatus == KidTripStatus.dropped;
}
