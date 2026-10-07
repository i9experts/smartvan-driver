// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Trip {
  @JsonKey(readValue: readId, fromJson: looseString)
  String? get id;
  @JsonKey(
      readValue: readTripDocumentStatus, unknownEnumValue: TripStatus.unknown)
  TripStatus get status;
  @JsonKey(unknownEnumValue: TripType.unknown)
  TripType get type;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get createdAt;
  @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
  DateTime? get startTime;
  @JsonKey(readValue: readTripName, fromJson: looseString)
  String? get name;
  @JsonKey(fromJson: looseString)
  String? get routeId;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripCopyWith<Trip> get copyWith =>
      _$TripCopyWithImpl<Trip>(this as Trip, _$identity);

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Trip &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.routeId, routeId) || other.routeId == routeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, status, type, createdAt, startTime, name, routeId);

  @override
  String toString() {
    return 'Trip(id: $id, status: $status, type: $type, createdAt: $createdAt, startTime: $startTime, name: $name, routeId: $routeId)';
  }
}

/// @nodoc
abstract mixin class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) _then) =
      _$TripCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseString) String? id,
      @JsonKey(
          readValue: readTripDocumentStatus,
          unknownEnumValue: TripStatus.unknown)
      TripStatus status,
      @JsonKey(unknownEnumValue: TripType.unknown) TripType type,
      @JsonKey(fromJson: looseDateTime) DateTime? createdAt,
      @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
      DateTime? startTime,
      @JsonKey(readValue: readTripName, fromJson: looseString) String? name,
      @JsonKey(fromJson: looseString) String? routeId});
}

/// @nodoc
class _$TripCopyWithImpl<$Res> implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._self, this._then);

  final Trip _self;
  final $Res Function(Trip) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? status = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? startTime = freezed,
    Object? name = freezed,
    Object? routeId = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TripType,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      routeId: freezed == routeId
          ? _self.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Trip].
extension TripPatterns on Trip {
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
    TResult Function(_Trip value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Trip() when $default != null:
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
    TResult Function(_Trip value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Trip():
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
    TResult? Function(_Trip value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Trip() when $default != null:
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
            @JsonKey(
                readValue: readTripDocumentStatus,
                unknownEnumValue: TripStatus.unknown)
            TripStatus status,
            @JsonKey(unknownEnumValue: TripType.unknown) TripType type,
            @JsonKey(fromJson: looseDateTime) DateTime? createdAt,
            @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
            DateTime? startTime,
            @JsonKey(readValue: readTripName, fromJson: looseString)
            String? name,
            @JsonKey(fromJson: looseString) String? routeId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Trip() when $default != null:
        return $default(_that.id, _that.status, _that.type, _that.createdAt,
            _that.startTime, _that.name, _that.routeId);
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
            @JsonKey(
                readValue: readTripDocumentStatus,
                unknownEnumValue: TripStatus.unknown)
            TripStatus status,
            @JsonKey(unknownEnumValue: TripType.unknown) TripType type,
            @JsonKey(fromJson: looseDateTime) DateTime? createdAt,
            @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
            DateTime? startTime,
            @JsonKey(readValue: readTripName, fromJson: looseString)
            String? name,
            @JsonKey(fromJson: looseString) String? routeId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Trip():
        return $default(_that.id, _that.status, _that.type, _that.createdAt,
            _that.startTime, _that.name, _that.routeId);
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
            @JsonKey(
                readValue: readTripDocumentStatus,
                unknownEnumValue: TripStatus.unknown)
            TripStatus status,
            @JsonKey(unknownEnumValue: TripType.unknown) TripType type,
            @JsonKey(fromJson: looseDateTime) DateTime? createdAt,
            @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
            DateTime? startTime,
            @JsonKey(readValue: readTripName, fromJson: looseString)
            String? name,
            @JsonKey(fromJson: looseString) String? routeId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Trip() when $default != null:
        return $default(_that.id, _that.status, _that.type, _that.createdAt,
            _that.startTime, _that.name, _that.routeId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Trip implements Trip {
  const _Trip(
      {@JsonKey(readValue: readId, fromJson: looseString) this.id,
      @JsonKey(
          readValue: readTripDocumentStatus,
          unknownEnumValue: TripStatus.unknown)
      this.status = TripStatus.unknown,
      @JsonKey(unknownEnumValue: TripType.unknown) this.type = TripType.unknown,
      @JsonKey(fromJson: looseDateTime) this.createdAt,
      @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
      this.startTime,
      @JsonKey(readValue: readTripName, fromJson: looseString) this.name,
      @JsonKey(fromJson: looseString) this.routeId});
  factory _Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  @override
  @JsonKey(readValue: readId, fromJson: looseString)
  final String? id;
  @override
  @JsonKey(
      readValue: readTripDocumentStatus, unknownEnumValue: TripStatus.unknown)
  final TripStatus status;
  @override
  @JsonKey(unknownEnumValue: TripType.unknown)
  final TripType type;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
  final DateTime? startTime;
  @override
  @JsonKey(readValue: readTripName, fromJson: looseString)
  final String? name;
  @override
  @JsonKey(fromJson: looseString)
  final String? routeId;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripCopyWith<_Trip> get copyWith =>
      __$TripCopyWithImpl<_Trip>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TripToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Trip &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.routeId, routeId) || other.routeId == routeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, status, type, createdAt, startTime, name, routeId);

  @override
  String toString() {
    return 'Trip(id: $id, status: $status, type: $type, createdAt: $createdAt, startTime: $startTime, name: $name, routeId: $routeId)';
  }
}

/// @nodoc
abstract mixin class _$TripCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$TripCopyWith(_Trip value, $Res Function(_Trip) _then) =
      __$TripCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseString) String? id,
      @JsonKey(
          readValue: readTripDocumentStatus,
          unknownEnumValue: TripStatus.unknown)
      TripStatus status,
      @JsonKey(unknownEnumValue: TripType.unknown) TripType type,
      @JsonKey(fromJson: looseDateTime) DateTime? createdAt,
      @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
      DateTime? startTime,
      @JsonKey(readValue: readTripName, fromJson: looseString) String? name,
      @JsonKey(fromJson: looseString) String? routeId});
}

/// @nodoc
class __$TripCopyWithImpl<$Res> implements _$TripCopyWith<$Res> {
  __$TripCopyWithImpl(this._self, this._then);

  final _Trip _self;
  final $Res Function(_Trip) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? status = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? startTime = freezed,
    Object? name = freezed,
    Object? routeId = freezed,
  }) {
    return _then(_Trip(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TripType,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      routeId: freezed == routeId
          ? _self.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
