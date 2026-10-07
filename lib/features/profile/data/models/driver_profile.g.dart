// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverProfile _$DriverProfileFromJson(Map<String, dynamic> json) =>
    _DriverProfile(
      id: looseString(readId(json, 'id')),
      fullname: readFullname(json, 'fullname') == null
          ? ''
          : looseStringOrEmpty(readFullname(json, 'fullname')),
      email: looseString(json['email']),
      phoneNo: looseString(json['phoneNo']),
      alternatePhoneNo: looseString(json['alternatePhoneNo']),
      address: looseString(json['address']),
      nic: looseString(json['NIC']),
      image: looseString(json['image']),
      vanModel: looseString(json['vanModel']),
      plateNumber: looseString(json['plateNumber']),
      seats: looseInt(json['seats']),
      licenceImageFront:
          looseString(readLicenceFront(json, 'licenceImageFront')),
      licenceImageBack: looseString(readLicenceBack(json, 'licenceImageBack')),
      vehicleCardImageFront: looseString(json['vehicleCardImageFront']),
      vehicleCardImageBack: looseString(json['vehicleCardImageBack']),
      expiryDateLicense:
          looseDate(readLicenceExpiry(json, 'expiryDateLicense')),
      expiryDateVehicleCard: looseDate(json['expiryDateVehicleCard']),
    );

Map<String, dynamic> _$DriverProfileToJson(_DriverProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'phoneNo': instance.phoneNo,
      'alternatePhoneNo': instance.alternatePhoneNo,
      'address': instance.address,
      'NIC': instance.nic,
      'image': instance.image,
      'vanModel': instance.vanModel,
      'plateNumber': instance.plateNumber,
      'seats': instance.seats,
      'licenceImageFront': instance.licenceImageFront,
      'licenceImageBack': instance.licenceImageBack,
      'vehicleCardImageFront': instance.vehicleCardImageFront,
      'vehicleCardImageBack': instance.vehicleCardImageBack,
      'expiryDateLicense': instance.expiryDateLicense?.toIso8601String(),
      'expiryDateVehicleCard':
          instance.expiryDateVehicleCard?.toIso8601String(),
    };
