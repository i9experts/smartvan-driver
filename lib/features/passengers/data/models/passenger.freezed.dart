// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passenger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Passenger {
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  String get id;
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  String get fullname;
  @JsonKey(readValue: readImage, fromJson: looseString)
  String? get image;

  /// `tripStatus` on some endpoints, `status` on others; missing = pending.
  @JsonKey(readValue: readTripStatus, unknownEnumValue: KidTripStatus.unknown)
  KidTripStatus get tripStatus;
  @JsonKey(fromJson: looseString)
  String? get tripId;
  @JsonKey(fromJson: looseString)
  String? get grade;
  @JsonKey(readValue: readSchoolName, fromJson: looseString)
  String? get schoolName;

  /// Distance to the stop, as the backend formats it (a string).
  @JsonKey(fromJson: looseString)
  String? get distance;
  @JsonKey(readValue: readParentContact)
  ParentContact
      get parent; // ---- Phase 4 ------------------------------------------------------
  /// A parent marked this kid absent for today.
  @JsonKey(fromJson: looseBool)
  bool get absent;
  @JsonKey(fromJson: looseString)
  String? get absenceNote;

  /// Set once the driver pressed "At stop".
  @JsonKey(fromJson: looseDateTime)
  DateTime? get waitingSince;

  /// Driver marked "not at stop — moved on".
  @JsonKey(fromJson: looseBool)
  bool get noShow;

  /// Create a copy of Passenger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PassengerCopyWith<Passenger> get copyWith =>
      _$PassengerCopyWithImpl<Passenger>(this as Passenger, _$identity);

  /// Serializes this Passenger to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Passenger &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.tripStatus, tripStatus) ||
                other.tripStatus == tripStatus) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.schoolName, schoolName) ||
                other.schoolName == schoolName) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.absent, absent) || other.absent == absent) &&
            (identical(other.absenceNote, absenceNote) ||
                other.absenceNote == absenceNote) &&
            (identical(other.waitingSince, waitingSince) ||
                other.waitingSince == waitingSince) &&
            (identical(other.noShow, noShow) || other.noShow == noShow));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullname,
      image,
      tripStatus,
      tripId,
      grade,
      schoolName,
      distance,
      parent,
      absent,
      absenceNote,
      waitingSince,
      noShow);

  @override
  String toString() {
    return 'Passenger(id: $id, fullname: $fullname, image: $image, tripStatus: $tripStatus, tripId: $tripId, grade: $grade, schoolName: $schoolName, distance: $distance, parent: $parent, absent: $absent, absenceNote: $absenceNote, waitingSince: $waitingSince, noShow: $noShow)';
  }
}

/// @nodoc
abstract mixin class $PassengerCopyWith<$Res> {
  factory $PassengerCopyWith(Passenger value, $Res Function(Passenger) _then) =
      _$PassengerCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty) String id,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(readValue: readImage, fromJson: looseString) String? image,
      @JsonKey(
          readValue: readTripStatus, unknownEnumValue: KidTripStatus.unknown)
      KidTripStatus tripStatus,
      @JsonKey(fromJson: looseString) String? tripId,
      @JsonKey(fromJson: looseString) String? grade,
      @JsonKey(readValue: readSchoolName, fromJson: looseString)
      String? schoolName,
      @JsonKey(fromJson: looseString) String? distance,
      @JsonKey(readValue: readParentContact) ParentContact parent,
      @JsonKey(fromJson: looseBool) bool absent,
      @JsonKey(fromJson: looseString) String? absenceNote,
      @JsonKey(fromJson: looseDateTime) DateTime? waitingSince,
      @JsonKey(fromJson: looseBool) bool noShow});

  $ParentContactCopyWith<$Res> get parent;
}

/// @nodoc
class _$PassengerCopyWithImpl<$Res> implements $PassengerCopyWith<$Res> {
  _$PassengerCopyWithImpl(this._self, this._then);

  final Passenger _self;
  final $Res Function(Passenger) _then;

  /// Create a copy of Passenger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullname = null,
    Object? image = freezed,
    Object? tripStatus = null,
    Object? tripId = freezed,
    Object? grade = freezed,
    Object? schoolName = freezed,
    Object? distance = freezed,
    Object? parent = null,
    Object? absent = null,
    Object? absenceNote = freezed,
    Object? waitingSince = freezed,
    Object? noShow = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      tripStatus: null == tripStatus
          ? _self.tripStatus
          : tripStatus // ignore: cast_nullable_to_non_nullable
              as KidTripStatus,
      tripId: freezed == tripId
          ? _self.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolName: freezed == schoolName
          ? _self.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      distance: freezed == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as String?,
      parent: null == parent
          ? _self.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as ParentContact,
      absent: null == absent
          ? _self.absent
          : absent // ignore: cast_nullable_to_non_nullable
              as bool,
      absenceNote: freezed == absenceNote
          ? _self.absenceNote
          : absenceNote // ignore: cast_nullable_to_non_nullable
              as String?,
      waitingSince: freezed == waitingSince
          ? _self.waitingSince
          : waitingSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      noShow: null == noShow
          ? _self.noShow
          : noShow // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of Passenger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParentContactCopyWith<$Res> get parent {
    return $ParentContactCopyWith<$Res>(_self.parent, (value) {
      return _then(_self.copyWith(parent: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Passenger].
extension PassengerPatterns on Passenger {
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
    TResult Function(_Passenger value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Passenger() when $default != null:
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
    TResult Function(_Passenger value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Passenger():
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
    TResult? Function(_Passenger value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Passenger() when $default != null:
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
            @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
            String id,
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname,
            @JsonKey(readValue: readImage, fromJson: looseString) String? image,
            @JsonKey(
                readValue: readTripStatus,
                unknownEnumValue: KidTripStatus.unknown)
            KidTripStatus tripStatus,
            @JsonKey(fromJson: looseString) String? tripId,
            @JsonKey(fromJson: looseString) String? grade,
            @JsonKey(readValue: readSchoolName, fromJson: looseString)
            String? schoolName,
            @JsonKey(fromJson: looseString) String? distance,
            @JsonKey(readValue: readParentContact) ParentContact parent,
            @JsonKey(fromJson: looseBool) bool absent,
            @JsonKey(fromJson: looseString) String? absenceNote,
            @JsonKey(fromJson: looseDateTime) DateTime? waitingSince,
            @JsonKey(fromJson: looseBool) bool noShow)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Passenger() when $default != null:
        return $default(
            _that.id,
            _that.fullname,
            _that.image,
            _that.tripStatus,
            _that.tripId,
            _that.grade,
            _that.schoolName,
            _that.distance,
            _that.parent,
            _that.absent,
            _that.absenceNote,
            _that.waitingSince,
            _that.noShow);
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
            @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
            String id,
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname,
            @JsonKey(readValue: readImage, fromJson: looseString) String? image,
            @JsonKey(
                readValue: readTripStatus,
                unknownEnumValue: KidTripStatus.unknown)
            KidTripStatus tripStatus,
            @JsonKey(fromJson: looseString) String? tripId,
            @JsonKey(fromJson: looseString) String? grade,
            @JsonKey(readValue: readSchoolName, fromJson: looseString)
            String? schoolName,
            @JsonKey(fromJson: looseString) String? distance,
            @JsonKey(readValue: readParentContact) ParentContact parent,
            @JsonKey(fromJson: looseBool) bool absent,
            @JsonKey(fromJson: looseString) String? absenceNote,
            @JsonKey(fromJson: looseDateTime) DateTime? waitingSince,
            @JsonKey(fromJson: looseBool) bool noShow)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Passenger():
        return $default(
            _that.id,
            _that.fullname,
            _that.image,
            _that.tripStatus,
            _that.tripId,
            _that.grade,
            _that.schoolName,
            _that.distance,
            _that.parent,
            _that.absent,
            _that.absenceNote,
            _that.waitingSince,
            _that.noShow);
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
            @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
            String id,
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname,
            @JsonKey(readValue: readImage, fromJson: looseString) String? image,
            @JsonKey(
                readValue: readTripStatus,
                unknownEnumValue: KidTripStatus.unknown)
            KidTripStatus tripStatus,
            @JsonKey(fromJson: looseString) String? tripId,
            @JsonKey(fromJson: looseString) String? grade,
            @JsonKey(readValue: readSchoolName, fromJson: looseString)
            String? schoolName,
            @JsonKey(fromJson: looseString) String? distance,
            @JsonKey(readValue: readParentContact) ParentContact parent,
            @JsonKey(fromJson: looseBool) bool absent,
            @JsonKey(fromJson: looseString) String? absenceNote,
            @JsonKey(fromJson: looseDateTime) DateTime? waitingSince,
            @JsonKey(fromJson: looseBool) bool noShow)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Passenger() when $default != null:
        return $default(
            _that.id,
            _that.fullname,
            _that.image,
            _that.tripStatus,
            _that.tripId,
            _that.grade,
            _that.schoolName,
            _that.distance,
            _that.parent,
            _that.absent,
            _that.absenceNote,
            _that.waitingSince,
            _that.noShow);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Passenger extends Passenger {
  const _Passenger(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      this.id = '',
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      this.fullname = '',
      @JsonKey(readValue: readImage, fromJson: looseString) this.image,
      @JsonKey(
          readValue: readTripStatus, unknownEnumValue: KidTripStatus.unknown)
      this.tripStatus = KidTripStatus.pending,
      @JsonKey(fromJson: looseString) this.tripId,
      @JsonKey(fromJson: looseString) this.grade,
      @JsonKey(readValue: readSchoolName, fromJson: looseString)
      this.schoolName,
      @JsonKey(fromJson: looseString) this.distance,
      @JsonKey(readValue: readParentContact)
      this.parent = const ParentContact(),
      @JsonKey(fromJson: looseBool) this.absent = false,
      @JsonKey(fromJson: looseString) this.absenceNote,
      @JsonKey(fromJson: looseDateTime) this.waitingSince,
      @JsonKey(fromJson: looseBool) this.noShow = false})
      : super._();
  factory _Passenger.fromJson(Map<String, dynamic> json) =>
      _$PassengerFromJson(json);

  @override
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  final String id;
  @override
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  final String fullname;
  @override
  @JsonKey(readValue: readImage, fromJson: looseString)
  final String? image;

  /// `tripStatus` on some endpoints, `status` on others; missing = pending.
  @override
  @JsonKey(readValue: readTripStatus, unknownEnumValue: KidTripStatus.unknown)
  final KidTripStatus tripStatus;
  @override
  @JsonKey(fromJson: looseString)
  final String? tripId;
  @override
  @JsonKey(fromJson: looseString)
  final String? grade;
  @override
  @JsonKey(readValue: readSchoolName, fromJson: looseString)
  final String? schoolName;

  /// Distance to the stop, as the backend formats it (a string).
  @override
  @JsonKey(fromJson: looseString)
  final String? distance;
  @override
  @JsonKey(readValue: readParentContact)
  final ParentContact parent;
// ---- Phase 4 ------------------------------------------------------
  /// A parent marked this kid absent for today.
  @override
  @JsonKey(fromJson: looseBool)
  final bool absent;
  @override
  @JsonKey(fromJson: looseString)
  final String? absenceNote;

  /// Set once the driver pressed "At stop".
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? waitingSince;

  /// Driver marked "not at stop — moved on".
  @override
  @JsonKey(fromJson: looseBool)
  final bool noShow;

  /// Create a copy of Passenger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PassengerCopyWith<_Passenger> get copyWith =>
      __$PassengerCopyWithImpl<_Passenger>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PassengerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Passenger &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.tripStatus, tripStatus) ||
                other.tripStatus == tripStatus) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.schoolName, schoolName) ||
                other.schoolName == schoolName) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.absent, absent) || other.absent == absent) &&
            (identical(other.absenceNote, absenceNote) ||
                other.absenceNote == absenceNote) &&
            (identical(other.waitingSince, waitingSince) ||
                other.waitingSince == waitingSince) &&
            (identical(other.noShow, noShow) || other.noShow == noShow));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullname,
      image,
      tripStatus,
      tripId,
      grade,
      schoolName,
      distance,
      parent,
      absent,
      absenceNote,
      waitingSince,
      noShow);

  @override
  String toString() {
    return 'Passenger(id: $id, fullname: $fullname, image: $image, tripStatus: $tripStatus, tripId: $tripId, grade: $grade, schoolName: $schoolName, distance: $distance, parent: $parent, absent: $absent, absenceNote: $absenceNote, waitingSince: $waitingSince, noShow: $noShow)';
  }
}

/// @nodoc
abstract mixin class _$PassengerCopyWith<$Res>
    implements $PassengerCopyWith<$Res> {
  factory _$PassengerCopyWith(
          _Passenger value, $Res Function(_Passenger) _then) =
      __$PassengerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty) String id,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(readValue: readImage, fromJson: looseString) String? image,
      @JsonKey(
          readValue: readTripStatus, unknownEnumValue: KidTripStatus.unknown)
      KidTripStatus tripStatus,
      @JsonKey(fromJson: looseString) String? tripId,
      @JsonKey(fromJson: looseString) String? grade,
      @JsonKey(readValue: readSchoolName, fromJson: looseString)
      String? schoolName,
      @JsonKey(fromJson: looseString) String? distance,
      @JsonKey(readValue: readParentContact) ParentContact parent,
      @JsonKey(fromJson: looseBool) bool absent,
      @JsonKey(fromJson: looseString) String? absenceNote,
      @JsonKey(fromJson: looseDateTime) DateTime? waitingSince,
      @JsonKey(fromJson: looseBool) bool noShow});

  @override
  $ParentContactCopyWith<$Res> get parent;
}

/// @nodoc
class __$PassengerCopyWithImpl<$Res> implements _$PassengerCopyWith<$Res> {
  __$PassengerCopyWithImpl(this._self, this._then);

  final _Passenger _self;
  final $Res Function(_Passenger) _then;

  /// Create a copy of Passenger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? fullname = null,
    Object? image = freezed,
    Object? tripStatus = null,
    Object? tripId = freezed,
    Object? grade = freezed,
    Object? schoolName = freezed,
    Object? distance = freezed,
    Object? parent = null,
    Object? absent = null,
    Object? absenceNote = freezed,
    Object? waitingSince = freezed,
    Object? noShow = null,
  }) {
    return _then(_Passenger(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      tripStatus: null == tripStatus
          ? _self.tripStatus
          : tripStatus // ignore: cast_nullable_to_non_nullable
              as KidTripStatus,
      tripId: freezed == tripId
          ? _self.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolName: freezed == schoolName
          ? _self.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      distance: freezed == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as String?,
      parent: null == parent
          ? _self.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as ParentContact,
      absent: null == absent
          ? _self.absent
          : absent // ignore: cast_nullable_to_non_nullable
              as bool,
      absenceNote: freezed == absenceNote
          ? _self.absenceNote
          : absenceNote // ignore: cast_nullable_to_non_nullable
              as String?,
      waitingSince: freezed == waitingSince
          ? _self.waitingSince
          : waitingSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      noShow: null == noShow
          ? _self.noShow
          : noShow // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of Passenger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParentContactCopyWith<$Res> get parent {
    return $ParentContactCopyWith<$Res>(_self.parent, (value) {
      return _then(_self.copyWith(parent: value));
    });
  }
}

// dart format on
