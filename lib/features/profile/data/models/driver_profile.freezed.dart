// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverProfile {
  @JsonKey(readValue: readId, fromJson: looseString)
  String? get id;
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  String get fullname;
  @JsonKey(fromJson: looseString)
  String? get email;
  @JsonKey(fromJson: looseString)
  String? get phoneNo;
  @JsonKey(fromJson: looseString)
  String? get alternatePhoneNo;
  @JsonKey(fromJson: looseString)
  String? get address;

  /// National ID card number — the backend key is upper-case `NIC`.
  @JsonKey(name: 'NIC', fromJson: looseString)
  String? get nic;
  @JsonKey(fromJson: looseString)
  String? get image;
  @JsonKey(fromJson: looseString)
  String? get vanModel;
  @JsonKey(fromJson: looseString)
  String? get plateNumber;

  /// Number of seats; arrives as a number or a numeric string.
  @JsonKey(fromJson: looseInt)
  int?
      get seats; // ---- documents (URLs) ----------------------------------------------
  @JsonKey(readValue: readLicenceFront, fromJson: looseString)
  String? get licenceImageFront;
  @JsonKey(readValue: readLicenceBack, fromJson: looseString)
  String? get licenceImageBack;
  @JsonKey(fromJson: looseString)
  String? get vehicleCardImageFront;
  @JsonKey(fromJson: looseString)
  String?
      get vehicleCardImageBack; // ---- Phase 4 -------------------------------------------------------
  /// `YYYY-MM-DD`, ISO-8601 or `DD/MM/YYYY`.
  @JsonKey(readValue: readLicenceExpiry, fromJson: looseDate)
  DateTime? get expiryDateLicense;
  @JsonKey(fromJson: looseDate)
  DateTime? get expiryDateVehicleCard;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DriverProfileCopyWith<DriverProfile> get copyWith =>
      _$DriverProfileCopyWithImpl<DriverProfile>(
          this as DriverProfile, _$identity);

  /// Serializes this DriverProfile to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DriverProfile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo) &&
            (identical(other.alternatePhoneNo, alternatePhoneNo) ||
                other.alternatePhoneNo == alternatePhoneNo) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.nic, nic) || other.nic == nic) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.vanModel, vanModel) ||
                other.vanModel == vanModel) &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.seats, seats) || other.seats == seats) &&
            (identical(other.licenceImageFront, licenceImageFront) ||
                other.licenceImageFront == licenceImageFront) &&
            (identical(other.licenceImageBack, licenceImageBack) ||
                other.licenceImageBack == licenceImageBack) &&
            (identical(other.vehicleCardImageFront, vehicleCardImageFront) ||
                other.vehicleCardImageFront == vehicleCardImageFront) &&
            (identical(other.vehicleCardImageBack, vehicleCardImageBack) ||
                other.vehicleCardImageBack == vehicleCardImageBack) &&
            (identical(other.expiryDateLicense, expiryDateLicense) ||
                other.expiryDateLicense == expiryDateLicense) &&
            (identical(other.expiryDateVehicleCard, expiryDateVehicleCard) ||
                other.expiryDateVehicleCard == expiryDateVehicleCard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullname,
      email,
      phoneNo,
      alternatePhoneNo,
      address,
      nic,
      image,
      vanModel,
      plateNumber,
      seats,
      licenceImageFront,
      licenceImageBack,
      vehicleCardImageFront,
      vehicleCardImageBack,
      expiryDateLicense,
      expiryDateVehicleCard);

  @override
  String toString() {
    return 'DriverProfile(id: $id, fullname: $fullname, email: $email, phoneNo: $phoneNo, alternatePhoneNo: $alternatePhoneNo, address: $address, nic: $nic, image: $image, vanModel: $vanModel, plateNumber: $plateNumber, seats: $seats, licenceImageFront: $licenceImageFront, licenceImageBack: $licenceImageBack, vehicleCardImageFront: $vehicleCardImageFront, vehicleCardImageBack: $vehicleCardImageBack, expiryDateLicense: $expiryDateLicense, expiryDateVehicleCard: $expiryDateVehicleCard)';
  }
}

/// @nodoc
abstract mixin class $DriverProfileCopyWith<$Res> {
  factory $DriverProfileCopyWith(
          DriverProfile value, $Res Function(DriverProfile) _then) =
      _$DriverProfileCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseString) String? id,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(fromJson: looseString) String? email,
      @JsonKey(fromJson: looseString) String? phoneNo,
      @JsonKey(fromJson: looseString) String? alternatePhoneNo,
      @JsonKey(fromJson: looseString) String? address,
      @JsonKey(name: 'NIC', fromJson: looseString) String? nic,
      @JsonKey(fromJson: looseString) String? image,
      @JsonKey(fromJson: looseString) String? vanModel,
      @JsonKey(fromJson: looseString) String? plateNumber,
      @JsonKey(fromJson: looseInt) int? seats,
      @JsonKey(readValue: readLicenceFront, fromJson: looseString)
      String? licenceImageFront,
      @JsonKey(readValue: readLicenceBack, fromJson: looseString)
      String? licenceImageBack,
      @JsonKey(fromJson: looseString) String? vehicleCardImageFront,
      @JsonKey(fromJson: looseString) String? vehicleCardImageBack,
      @JsonKey(readValue: readLicenceExpiry, fromJson: looseDate)
      DateTime? expiryDateLicense,
      @JsonKey(fromJson: looseDate) DateTime? expiryDateVehicleCard});
}

/// @nodoc
class _$DriverProfileCopyWithImpl<$Res>
    implements $DriverProfileCopyWith<$Res> {
  _$DriverProfileCopyWithImpl(this._self, this._then);

  final DriverProfile _self;
  final $Res Function(DriverProfile) _then;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullname = null,
    Object? email = freezed,
    Object? phoneNo = freezed,
    Object? alternatePhoneNo = freezed,
    Object? address = freezed,
    Object? nic = freezed,
    Object? image = freezed,
    Object? vanModel = freezed,
    Object? plateNumber = freezed,
    Object? seats = freezed,
    Object? licenceImageFront = freezed,
    Object? licenceImageBack = freezed,
    Object? vehicleCardImageFront = freezed,
    Object? vehicleCardImageBack = freezed,
    Object? expiryDateLicense = freezed,
    Object? expiryDateVehicleCard = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNo: freezed == phoneNo
          ? _self.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      alternatePhoneNo: freezed == alternatePhoneNo
          ? _self.alternatePhoneNo
          : alternatePhoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      nic: freezed == nic
          ? _self.nic
          : nic // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      vanModel: freezed == vanModel
          ? _self.vanModel
          : vanModel // ignore: cast_nullable_to_non_nullable
              as String?,
      plateNumber: freezed == plateNumber
          ? _self.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      seats: freezed == seats
          ? _self.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int?,
      licenceImageFront: freezed == licenceImageFront
          ? _self.licenceImageFront
          : licenceImageFront // ignore: cast_nullable_to_non_nullable
              as String?,
      licenceImageBack: freezed == licenceImageBack
          ? _self.licenceImageBack
          : licenceImageBack // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleCardImageFront: freezed == vehicleCardImageFront
          ? _self.vehicleCardImageFront
          : vehicleCardImageFront // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleCardImageBack: freezed == vehicleCardImageBack
          ? _self.vehicleCardImageBack
          : vehicleCardImageBack // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDateLicense: freezed == expiryDateLicense
          ? _self.expiryDateLicense
          : expiryDateLicense // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDateVehicleCard: freezed == expiryDateVehicleCard
          ? _self.expiryDateVehicleCard
          : expiryDateVehicleCard // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DriverProfile].
extension DriverProfilePatterns on DriverProfile {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DriverProfile value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DriverProfile() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DriverProfile value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DriverProfile():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DriverProfile value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DriverProfile() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(readValue: readId, fromJson: looseString) String? id,
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname,
            @JsonKey(fromJson: looseString) String? email,
            @JsonKey(fromJson: looseString) String? phoneNo,
            @JsonKey(fromJson: looseString) String? alternatePhoneNo,
            @JsonKey(fromJson: looseString) String? address,
            @JsonKey(name: 'NIC', fromJson: looseString) String? nic,
            @JsonKey(fromJson: looseString) String? image,
            @JsonKey(fromJson: looseString) String? vanModel,
            @JsonKey(fromJson: looseString) String? plateNumber,
            @JsonKey(fromJson: looseInt) int? seats,
            @JsonKey(readValue: readLicenceFront, fromJson: looseString)
            String? licenceImageFront,
            @JsonKey(readValue: readLicenceBack, fromJson: looseString)
            String? licenceImageBack,
            @JsonKey(fromJson: looseString) String? vehicleCardImageFront,
            @JsonKey(fromJson: looseString) String? vehicleCardImageBack,
            @JsonKey(readValue: readLicenceExpiry, fromJson: looseDate)
            DateTime? expiryDateLicense,
            @JsonKey(fromJson: looseDate) DateTime? expiryDateVehicleCard)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DriverProfile() when $default != null:
        return $default(
            _that.id,
            _that.fullname,
            _that.email,
            _that.phoneNo,
            _that.alternatePhoneNo,
            _that.address,
            _that.nic,
            _that.image,
            _that.vanModel,
            _that.plateNumber,
            _that.seats,
            _that.licenceImageFront,
            _that.licenceImageBack,
            _that.vehicleCardImageFront,
            _that.vehicleCardImageBack,
            _that.expiryDateLicense,
            _that.expiryDateVehicleCard);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(readValue: readId, fromJson: looseString) String? id,
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname,
            @JsonKey(fromJson: looseString) String? email,
            @JsonKey(fromJson: looseString) String? phoneNo,
            @JsonKey(fromJson: looseString) String? alternatePhoneNo,
            @JsonKey(fromJson: looseString) String? address,
            @JsonKey(name: 'NIC', fromJson: looseString) String? nic,
            @JsonKey(fromJson: looseString) String? image,
            @JsonKey(fromJson: looseString) String? vanModel,
            @JsonKey(fromJson: looseString) String? plateNumber,
            @JsonKey(fromJson: looseInt) int? seats,
            @JsonKey(readValue: readLicenceFront, fromJson: looseString)
            String? licenceImageFront,
            @JsonKey(readValue: readLicenceBack, fromJson: looseString)
            String? licenceImageBack,
            @JsonKey(fromJson: looseString) String? vehicleCardImageFront,
            @JsonKey(fromJson: looseString) String? vehicleCardImageBack,
            @JsonKey(readValue: readLicenceExpiry, fromJson: looseDate)
            DateTime? expiryDateLicense,
            @JsonKey(fromJson: looseDate) DateTime? expiryDateVehicleCard)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DriverProfile():
        return $default(
            _that.id,
            _that.fullname,
            _that.email,
            _that.phoneNo,
            _that.alternatePhoneNo,
            _that.address,
            _that.nic,
            _that.image,
            _that.vanModel,
            _that.plateNumber,
            _that.seats,
            _that.licenceImageFront,
            _that.licenceImageBack,
            _that.vehicleCardImageFront,
            _that.vehicleCardImageBack,
            _that.expiryDateLicense,
            _that.expiryDateVehicleCard);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(readValue: readId, fromJson: looseString) String? id,
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname,
            @JsonKey(fromJson: looseString) String? email,
            @JsonKey(fromJson: looseString) String? phoneNo,
            @JsonKey(fromJson: looseString) String? alternatePhoneNo,
            @JsonKey(fromJson: looseString) String? address,
            @JsonKey(name: 'NIC', fromJson: looseString) String? nic,
            @JsonKey(fromJson: looseString) String? image,
            @JsonKey(fromJson: looseString) String? vanModel,
            @JsonKey(fromJson: looseString) String? plateNumber,
            @JsonKey(fromJson: looseInt) int? seats,
            @JsonKey(readValue: readLicenceFront, fromJson: looseString)
            String? licenceImageFront,
            @JsonKey(readValue: readLicenceBack, fromJson: looseString)
            String? licenceImageBack,
            @JsonKey(fromJson: looseString) String? vehicleCardImageFront,
            @JsonKey(fromJson: looseString) String? vehicleCardImageBack,
            @JsonKey(readValue: readLicenceExpiry, fromJson: looseDate)
            DateTime? expiryDateLicense,
            @JsonKey(fromJson: looseDate) DateTime? expiryDateVehicleCard)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DriverProfile() when $default != null:
        return $default(
            _that.id,
            _that.fullname,
            _that.email,
            _that.phoneNo,
            _that.alternatePhoneNo,
            _that.address,
            _that.nic,
            _that.image,
            _that.vanModel,
            _that.plateNumber,
            _that.seats,
            _that.licenceImageFront,
            _that.licenceImageBack,
            _that.vehicleCardImageFront,
            _that.vehicleCardImageBack,
            _that.expiryDateLicense,
            _that.expiryDateVehicleCard);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DriverProfile implements DriverProfile {
  const _DriverProfile(
      {@JsonKey(readValue: readId, fromJson: looseString) this.id,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      this.fullname = '',
      @JsonKey(fromJson: looseString) this.email,
      @JsonKey(fromJson: looseString) this.phoneNo,
      @JsonKey(fromJson: looseString) this.alternatePhoneNo,
      @JsonKey(fromJson: looseString) this.address,
      @JsonKey(name: 'NIC', fromJson: looseString) this.nic,
      @JsonKey(fromJson: looseString) this.image,
      @JsonKey(fromJson: looseString) this.vanModel,
      @JsonKey(fromJson: looseString) this.plateNumber,
      @JsonKey(fromJson: looseInt) this.seats,
      @JsonKey(readValue: readLicenceFront, fromJson: looseString)
      this.licenceImageFront,
      @JsonKey(readValue: readLicenceBack, fromJson: looseString)
      this.licenceImageBack,
      @JsonKey(fromJson: looseString) this.vehicleCardImageFront,
      @JsonKey(fromJson: looseString) this.vehicleCardImageBack,
      @JsonKey(readValue: readLicenceExpiry, fromJson: looseDate)
      this.expiryDateLicense,
      @JsonKey(fromJson: looseDate) this.expiryDateVehicleCard});
  factory _DriverProfile.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileFromJson(json);

  @override
  @JsonKey(readValue: readId, fromJson: looseString)
  final String? id;
  @override
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  final String fullname;
  @override
  @JsonKey(fromJson: looseString)
  final String? email;
  @override
  @JsonKey(fromJson: looseString)
  final String? phoneNo;
  @override
  @JsonKey(fromJson: looseString)
  final String? alternatePhoneNo;
  @override
  @JsonKey(fromJson: looseString)
  final String? address;

  /// National ID card number — the backend key is upper-case `NIC`.
  @override
  @JsonKey(name: 'NIC', fromJson: looseString)
  final String? nic;
  @override
  @JsonKey(fromJson: looseString)
  final String? image;
  @override
  @JsonKey(fromJson: looseString)
  final String? vanModel;
  @override
  @JsonKey(fromJson: looseString)
  final String? plateNumber;

  /// Number of seats; arrives as a number or a numeric string.
  @override
  @JsonKey(fromJson: looseInt)
  final int? seats;
// ---- documents (URLs) ----------------------------------------------
  @override
  @JsonKey(readValue: readLicenceFront, fromJson: looseString)
  final String? licenceImageFront;
  @override
  @JsonKey(readValue: readLicenceBack, fromJson: looseString)
  final String? licenceImageBack;
  @override
  @JsonKey(fromJson: looseString)
  final String? vehicleCardImageFront;
  @override
  @JsonKey(fromJson: looseString)
  final String? vehicleCardImageBack;
// ---- Phase 4 -------------------------------------------------------
  /// `YYYY-MM-DD`, ISO-8601 or `DD/MM/YYYY`.
  @override
  @JsonKey(readValue: readLicenceExpiry, fromJson: looseDate)
  final DateTime? expiryDateLicense;
  @override
  @JsonKey(fromJson: looseDate)
  final DateTime? expiryDateVehicleCard;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DriverProfileCopyWith<_DriverProfile> get copyWith =>
      __$DriverProfileCopyWithImpl<_DriverProfile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DriverProfileToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DriverProfile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo) &&
            (identical(other.alternatePhoneNo, alternatePhoneNo) ||
                other.alternatePhoneNo == alternatePhoneNo) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.nic, nic) || other.nic == nic) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.vanModel, vanModel) ||
                other.vanModel == vanModel) &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.seats, seats) || other.seats == seats) &&
            (identical(other.licenceImageFront, licenceImageFront) ||
                other.licenceImageFront == licenceImageFront) &&
            (identical(other.licenceImageBack, licenceImageBack) ||
                other.licenceImageBack == licenceImageBack) &&
            (identical(other.vehicleCardImageFront, vehicleCardImageFront) ||
                other.vehicleCardImageFront == vehicleCardImageFront) &&
            (identical(other.vehicleCardImageBack, vehicleCardImageBack) ||
                other.vehicleCardImageBack == vehicleCardImageBack) &&
            (identical(other.expiryDateLicense, expiryDateLicense) ||
                other.expiryDateLicense == expiryDateLicense) &&
            (identical(other.expiryDateVehicleCard, expiryDateVehicleCard) ||
                other.expiryDateVehicleCard == expiryDateVehicleCard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullname,
      email,
      phoneNo,
      alternatePhoneNo,
      address,
      nic,
      image,
      vanModel,
      plateNumber,
      seats,
      licenceImageFront,
      licenceImageBack,
      vehicleCardImageFront,
      vehicleCardImageBack,
      expiryDateLicense,
      expiryDateVehicleCard);

  @override
  String toString() {
    return 'DriverProfile(id: $id, fullname: $fullname, email: $email, phoneNo: $phoneNo, alternatePhoneNo: $alternatePhoneNo, address: $address, nic: $nic, image: $image, vanModel: $vanModel, plateNumber: $plateNumber, seats: $seats, licenceImageFront: $licenceImageFront, licenceImageBack: $licenceImageBack, vehicleCardImageFront: $vehicleCardImageFront, vehicleCardImageBack: $vehicleCardImageBack, expiryDateLicense: $expiryDateLicense, expiryDateVehicleCard: $expiryDateVehicleCard)';
  }
}

/// @nodoc
abstract mixin class _$DriverProfileCopyWith<$Res>
    implements $DriverProfileCopyWith<$Res> {
  factory _$DriverProfileCopyWith(
          _DriverProfile value, $Res Function(_DriverProfile) _then) =
      __$DriverProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseString) String? id,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(fromJson: looseString) String? email,
      @JsonKey(fromJson: looseString) String? phoneNo,
      @JsonKey(fromJson: looseString) String? alternatePhoneNo,
      @JsonKey(fromJson: looseString) String? address,
      @JsonKey(name: 'NIC', fromJson: looseString) String? nic,
      @JsonKey(fromJson: looseString) String? image,
      @JsonKey(fromJson: looseString) String? vanModel,
      @JsonKey(fromJson: looseString) String? plateNumber,
      @JsonKey(fromJson: looseInt) int? seats,
      @JsonKey(readValue: readLicenceFront, fromJson: looseString)
      String? licenceImageFront,
      @JsonKey(readValue: readLicenceBack, fromJson: looseString)
      String? licenceImageBack,
      @JsonKey(fromJson: looseString) String? vehicleCardImageFront,
      @JsonKey(fromJson: looseString) String? vehicleCardImageBack,
      @JsonKey(readValue: readLicenceExpiry, fromJson: looseDate)
      DateTime? expiryDateLicense,
      @JsonKey(fromJson: looseDate) DateTime? expiryDateVehicleCard});
}

/// @nodoc
class __$DriverProfileCopyWithImpl<$Res>
    implements _$DriverProfileCopyWith<$Res> {
  __$DriverProfileCopyWithImpl(this._self, this._then);

  final _DriverProfile _self;
  final $Res Function(_DriverProfile) _then;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? fullname = null,
    Object? email = freezed,
    Object? phoneNo = freezed,
    Object? alternatePhoneNo = freezed,
    Object? address = freezed,
    Object? nic = freezed,
    Object? image = freezed,
    Object? vanModel = freezed,
    Object? plateNumber = freezed,
    Object? seats = freezed,
    Object? licenceImageFront = freezed,
    Object? licenceImageBack = freezed,
    Object? vehicleCardImageFront = freezed,
    Object? vehicleCardImageBack = freezed,
    Object? expiryDateLicense = freezed,
    Object? expiryDateVehicleCard = freezed,
  }) {
    return _then(_DriverProfile(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNo: freezed == phoneNo
          ? _self.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      alternatePhoneNo: freezed == alternatePhoneNo
          ? _self.alternatePhoneNo
          : alternatePhoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      nic: freezed == nic
          ? _self.nic
          : nic // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      vanModel: freezed == vanModel
          ? _self.vanModel
          : vanModel // ignore: cast_nullable_to_non_nullable
              as String?,
      plateNumber: freezed == plateNumber
          ? _self.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      seats: freezed == seats
          ? _self.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int?,
      licenceImageFront: freezed == licenceImageFront
          ? _self.licenceImageFront
          : licenceImageFront // ignore: cast_nullable_to_non_nullable
              as String?,
      licenceImageBack: freezed == licenceImageBack
          ? _self.licenceImageBack
          : licenceImageBack // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleCardImageFront: freezed == vehicleCardImageFront
          ? _self.vehicleCardImageFront
          : vehicleCardImageFront // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleCardImageBack: freezed == vehicleCardImageBack
          ? _self.vehicleCardImageBack
          : vehicleCardImageBack // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDateLicense: freezed == expiryDateLicense
          ? _self.expiryDateLicense
          : expiryDateLicense // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDateVehicleCard: freezed == expiryDateVehicleCard
          ? _self.expiryDateVehicleCard
          : expiryDateVehicleCard // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
