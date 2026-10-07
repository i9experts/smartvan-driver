import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'driver_profile.freezed.dart';
part 'driver_profile.g.dart';

/// `GET /auth/getProfile` for a driver: the driver and their van in one flat
/// object, including the uploaded documents and their expiry dates.
@freezed
abstract class DriverProfile with _$DriverProfile {
  const factory DriverProfile({
    @JsonKey(readValue: readId, fromJson: looseString) String? id,
    @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
    @Default('')
    String fullname,
    @JsonKey(fromJson: looseString) String? email,
    @JsonKey(fromJson: looseString) String? phoneNo,
    @JsonKey(fromJson: looseString) String? alternatePhoneNo,
    @JsonKey(fromJson: looseString) String? address,

    /// National ID card number — the backend key is upper-case `NIC`.
    @JsonKey(name: 'NIC', fromJson: looseString) String? nic,
    @JsonKey(fromJson: looseString) String? image,
    @JsonKey(fromJson: looseString) String? vanModel,
    @JsonKey(fromJson: looseString) String? plateNumber,

    /// Number of seats; arrives as a number or a numeric string.
    @JsonKey(fromJson: looseInt) int? seats,

    // ---- documents (URLs) ----------------------------------------------
    @JsonKey(readValue: readLicenceFront, fromJson: looseString)
    String? licenceImageFront,
    @JsonKey(readValue: readLicenceBack, fromJson: looseString)
    String? licenceImageBack,
    @JsonKey(fromJson: looseString) String? vehicleCardImageFront,
    @JsonKey(fromJson: looseString) String? vehicleCardImageBack,

    // ---- Phase 4 -------------------------------------------------------
    /// `YYYY-MM-DD`, ISO-8601 or `DD/MM/YYYY`.
    @JsonKey(readValue: readLicenceExpiry, fromJson: looseDate)
    DateTime? expiryDateLicense,
    @JsonKey(fromJson: looseDate) DateTime? expiryDateVehicleCard,
  }) = _DriverProfile;

  factory DriverProfile.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileFromJson(json);
}
