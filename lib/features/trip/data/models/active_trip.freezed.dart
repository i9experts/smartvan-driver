// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActiveTrip {
  @JsonKey(readValue: readId, fromJson: looseStringOrEmpty)
  String get id;
  @JsonKey(fromJson: looseString)
  String? get routeId;

  /// The route's title (stored as `schoolRoute`).
  @JsonKey(
      name: 'schoolRoute', readValue: _readRouteTitle, fromJson: looseString)
  String? get routeTitle;

  /// The trip document's own name (`tripName` | `name`).
  @JsonKey(name: 'tripName', readValue: _readName, fromJson: looseString)
  String? get name;
  @JsonKey(readValue: readTypeLower, unknownEnumValue: TripType.unknown)
  TripType get type;

  /// When the trip started (`tripStart.startTime`); null if unknown.
  @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
  DateTime? get startTime;

  /// Create a copy of ActiveTrip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActiveTripCopyWith<ActiveTrip> get copyWith =>
      _$ActiveTripCopyWithImpl<ActiveTrip>(this as ActiveTrip, _$identity);

  /// Serializes this ActiveTrip to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActiveTrip &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.routeTitle, routeTitle) ||
                other.routeTitle == routeTitle) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, routeId, routeTitle, name, type, startTime);

  @override
  String toString() {
    return 'ActiveTrip(id: $id, routeId: $routeId, routeTitle: $routeTitle, name: $name, type: $type, startTime: $startTime)';
  }
}

/// @nodoc
abstract mixin class $ActiveTripCopyWith<$Res> {
  factory $ActiveTripCopyWith(
          ActiveTrip value, $Res Function(ActiveTrip) _then) =
      _$ActiveTripCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
      @JsonKey(fromJson: looseString) String? routeId,
      @JsonKey(
          name: 'schoolRoute',
          readValue: _readRouteTitle,
          fromJson: looseString)
      String? routeTitle,
      @JsonKey(name: 'tripName', readValue: _readName, fromJson: looseString)
      String? name,
      @JsonKey(readValue: readTypeLower, unknownEnumValue: TripType.unknown)
      TripType type,
      @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
      DateTime? startTime});
}

/// @nodoc
class _$ActiveTripCopyWithImpl<$Res> implements $ActiveTripCopyWith<$Res> {
  _$ActiveTripCopyWithImpl(this._self, this._then);

  final ActiveTrip _self;
  final $Res Function(ActiveTrip) _then;

  /// Create a copy of ActiveTrip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeId = freezed,
    Object? routeTitle = freezed,
    Object? name = freezed,
    Object? type = null,
    Object? startTime = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: freezed == routeId
          ? _self.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      routeTitle: freezed == routeTitle
          ? _self.routeTitle
          : routeTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TripType,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActiveTrip].
extension ActiveTripPatterns on ActiveTrip {
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
    TResult Function(_ActiveTrip value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActiveTrip() when $default != null:
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
    TResult Function(_ActiveTrip value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveTrip():
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
    TResult? Function(_ActiveTrip value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveTrip() when $default != null:
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
            @JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
            @JsonKey(fromJson: looseString) String? routeId,
            @JsonKey(
                name: 'schoolRoute',
                readValue: _readRouteTitle,
                fromJson: looseString)
            String? routeTitle,
            @JsonKey(
                name: 'tripName', readValue: _readName, fromJson: looseString)
            String? name,
            @JsonKey(
                readValue: readTypeLower, unknownEnumValue: TripType.unknown)
            TripType type,
            @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
            DateTime? startTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActiveTrip() when $default != null:
        return $default(_that.id, _that.routeId, _that.routeTitle, _that.name,
            _that.type, _that.startTime);
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
            @JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
            @JsonKey(fromJson: looseString) String? routeId,
            @JsonKey(
                name: 'schoolRoute',
                readValue: _readRouteTitle,
                fromJson: looseString)
            String? routeTitle,
            @JsonKey(
                name: 'tripName', readValue: _readName, fromJson: looseString)
            String? name,
            @JsonKey(
                readValue: readTypeLower, unknownEnumValue: TripType.unknown)
            TripType type,
            @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
            DateTime? startTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveTrip():
        return $default(_that.id, _that.routeId, _that.routeTitle, _that.name,
            _that.type, _that.startTime);
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
            @JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
            @JsonKey(fromJson: looseString) String? routeId,
            @JsonKey(
                name: 'schoolRoute',
                readValue: _readRouteTitle,
                fromJson: looseString)
            String? routeTitle,
            @JsonKey(
                name: 'tripName', readValue: _readName, fromJson: looseString)
            String? name,
            @JsonKey(
                readValue: readTypeLower, unknownEnumValue: TripType.unknown)
            TripType type,
            @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
            DateTime? startTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveTrip() when $default != null:
        return $default(_that.id, _that.routeId, _that.routeTitle, _that.name,
            _that.type, _that.startTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActiveTrip implements ActiveTrip {
  const _ActiveTrip(
      {@JsonKey(readValue: readId, fromJson: looseStringOrEmpty) this.id = '',
      @JsonKey(fromJson: looseString) this.routeId,
      @JsonKey(
          name: 'schoolRoute',
          readValue: _readRouteTitle,
          fromJson: looseString)
      this.routeTitle,
      @JsonKey(name: 'tripName', readValue: _readName, fromJson: looseString)
      this.name,
      @JsonKey(readValue: readTypeLower, unknownEnumValue: TripType.unknown)
      this.type = TripType.unknown,
      @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
      this.startTime});
  factory _ActiveTrip.fromJson(Map<String, dynamic> json) =>
      _$ActiveTripFromJson(json);

  @override
  @JsonKey(readValue: readId, fromJson: looseStringOrEmpty)
  final String id;
  @override
  @JsonKey(fromJson: looseString)
  final String? routeId;

  /// The route's title (stored as `schoolRoute`).
  @override
  @JsonKey(
      name: 'schoolRoute', readValue: _readRouteTitle, fromJson: looseString)
  final String? routeTitle;

  /// The trip document's own name (`tripName` | `name`).
  @override
  @JsonKey(name: 'tripName', readValue: _readName, fromJson: looseString)
  final String? name;
  @override
  @JsonKey(readValue: readTypeLower, unknownEnumValue: TripType.unknown)
  final TripType type;

  /// When the trip started (`tripStart.startTime`); null if unknown.
  @override
  @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
  final DateTime? startTime;

  /// Create a copy of ActiveTrip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActiveTripCopyWith<_ActiveTrip> get copyWith =>
      __$ActiveTripCopyWithImpl<_ActiveTrip>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActiveTripToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActiveTrip &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.routeTitle, routeTitle) ||
                other.routeTitle == routeTitle) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, routeId, routeTitle, name, type, startTime);

  @override
  String toString() {
    return 'ActiveTrip(id: $id, routeId: $routeId, routeTitle: $routeTitle, name: $name, type: $type, startTime: $startTime)';
  }
}

/// @nodoc
abstract mixin class _$ActiveTripCopyWith<$Res>
    implements $ActiveTripCopyWith<$Res> {
  factory _$ActiveTripCopyWith(
          _ActiveTrip value, $Res Function(_ActiveTrip) _then) =
      __$ActiveTripCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
      @JsonKey(fromJson: looseString) String? routeId,
      @JsonKey(
          name: 'schoolRoute',
          readValue: _readRouteTitle,
          fromJson: looseString)
      String? routeTitle,
      @JsonKey(name: 'tripName', readValue: _readName, fromJson: looseString)
      String? name,
      @JsonKey(readValue: readTypeLower, unknownEnumValue: TripType.unknown)
      TripType type,
      @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
      DateTime? startTime});
}

/// @nodoc
class __$ActiveTripCopyWithImpl<$Res> implements _$ActiveTripCopyWith<$Res> {
  __$ActiveTripCopyWithImpl(this._self, this._then);

  final _ActiveTrip _self;
  final $Res Function(_ActiveTrip) _then;

  /// Create a copy of ActiveTrip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? routeId = freezed,
    Object? routeTitle = freezed,
    Object? name = freezed,
    Object? type = null,
    Object? startTime = freezed,
  }) {
    return _then(_ActiveTrip(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: freezed == routeId
          ? _self.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      routeTitle: freezed == routeTitle
          ? _self.routeTitle
          : routeTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TripType,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
