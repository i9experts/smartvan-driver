// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'optimized_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OptimizedRoute {
  List<OptimizedStop> get stops;

  /// Where the suggestion starts (the driver's position) — absent means
  /// there is nothing to navigate.
  @JsonKey(fromJson: _point)
  GeoPoint? get origin;
  @JsonKey(fromJson: _point)
  GeoPoint? get destination;
  @JsonKey(fromJson: _double)
  double get distanceSavedMeters;
  @JsonKey(fromJson: _double)
  double get durationSavedSeconds;

  /// Create a copy of OptimizedRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OptimizedRouteCopyWith<OptimizedRoute> get copyWith =>
      _$OptimizedRouteCopyWithImpl<OptimizedRoute>(
          this as OptimizedRoute, _$identity);

  /// Serializes this OptimizedRoute to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OptimizedRoute &&
            const DeepCollectionEquality().equals(other.stops, stops) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.distanceSavedMeters, distanceSavedMeters) ||
                other.distanceSavedMeters == distanceSavedMeters) &&
            (identical(other.durationSavedSeconds, durationSavedSeconds) ||
                other.durationSavedSeconds == durationSavedSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(stops),
      origin,
      destination,
      distanceSavedMeters,
      durationSavedSeconds);

  @override
  String toString() {
    return 'OptimizedRoute(stops: $stops, origin: $origin, destination: $destination, distanceSavedMeters: $distanceSavedMeters, durationSavedSeconds: $durationSavedSeconds)';
  }
}

/// @nodoc
abstract mixin class $OptimizedRouteCopyWith<$Res> {
  factory $OptimizedRouteCopyWith(
          OptimizedRoute value, $Res Function(OptimizedRoute) _then) =
      _$OptimizedRouteCopyWithImpl;
  @useResult
  $Res call(
      {List<OptimizedStop> stops,
      @JsonKey(fromJson: _point) GeoPoint? origin,
      @JsonKey(fromJson: _point) GeoPoint? destination,
      @JsonKey(fromJson: _double) double distanceSavedMeters,
      @JsonKey(fromJson: _double) double durationSavedSeconds});

  $GeoPointCopyWith<$Res>? get origin;
  $GeoPointCopyWith<$Res>? get destination;
}

/// @nodoc
class _$OptimizedRouteCopyWithImpl<$Res>
    implements $OptimizedRouteCopyWith<$Res> {
  _$OptimizedRouteCopyWithImpl(this._self, this._then);

  final OptimizedRoute _self;
  final $Res Function(OptimizedRoute) _then;

  /// Create a copy of OptimizedRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stops = null,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? distanceSavedMeters = null,
    Object? durationSavedSeconds = null,
  }) {
    return _then(_self.copyWith(
      stops: null == stops
          ? _self.stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<OptimizedStop>,
      origin: freezed == origin
          ? _self.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      destination: freezed == destination
          ? _self.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      distanceSavedMeters: null == distanceSavedMeters
          ? _self.distanceSavedMeters
          : distanceSavedMeters // ignore: cast_nullable_to_non_nullable
              as double,
      durationSavedSeconds: null == durationSavedSeconds
          ? _self.durationSavedSeconds
          : durationSavedSeconds // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of OptimizedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get origin {
    if (_self.origin == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_self.origin!, (value) {
      return _then(_self.copyWith(origin: value));
    });
  }

  /// Create a copy of OptimizedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get destination {
    if (_self.destination == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_self.destination!, (value) {
      return _then(_self.copyWith(destination: value));
    });
  }
}

/// Adds pattern-matching-related methods to [OptimizedRoute].
extension OptimizedRoutePatterns on OptimizedRoute {
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
    TResult Function(_OptimizedRoute value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OptimizedRoute() when $default != null:
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
    TResult Function(_OptimizedRoute value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OptimizedRoute():
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
    TResult? Function(_OptimizedRoute value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OptimizedRoute() when $default != null:
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
            List<OptimizedStop> stops,
            @JsonKey(fromJson: _point) GeoPoint? origin,
            @JsonKey(fromJson: _point) GeoPoint? destination,
            @JsonKey(fromJson: _double) double distanceSavedMeters,
            @JsonKey(fromJson: _double) double durationSavedSeconds)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OptimizedRoute() when $default != null:
        return $default(_that.stops, _that.origin, _that.destination,
            _that.distanceSavedMeters, _that.durationSavedSeconds);
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
            List<OptimizedStop> stops,
            @JsonKey(fromJson: _point) GeoPoint? origin,
            @JsonKey(fromJson: _point) GeoPoint? destination,
            @JsonKey(fromJson: _double) double distanceSavedMeters,
            @JsonKey(fromJson: _double) double durationSavedSeconds)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OptimizedRoute():
        return $default(_that.stops, _that.origin, _that.destination,
            _that.distanceSavedMeters, _that.durationSavedSeconds);
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
            List<OptimizedStop> stops,
            @JsonKey(fromJson: _point) GeoPoint? origin,
            @JsonKey(fromJson: _point) GeoPoint? destination,
            @JsonKey(fromJson: _double) double distanceSavedMeters,
            @JsonKey(fromJson: _double) double durationSavedSeconds)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OptimizedRoute() when $default != null:
        return $default(_that.stops, _that.origin, _that.destination,
            _that.distanceSavedMeters, _that.durationSavedSeconds);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OptimizedRoute extends OptimizedRoute {
  const _OptimizedRoute(
      {final List<OptimizedStop> stops = const <OptimizedStop>[],
      @JsonKey(fromJson: _point) this.origin,
      @JsonKey(fromJson: _point) this.destination,
      @JsonKey(fromJson: _double) this.distanceSavedMeters = 0,
      @JsonKey(fromJson: _double) this.durationSavedSeconds = 0})
      : _stops = stops,
        super._();
  factory _OptimizedRoute.fromJson(Map<String, dynamic> json) =>
      _$OptimizedRouteFromJson(json);

  final List<OptimizedStop> _stops;
  @override
  @JsonKey()
  List<OptimizedStop> get stops {
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stops);
  }

  /// Where the suggestion starts (the driver's position) — absent means
  /// there is nothing to navigate.
  @override
  @JsonKey(fromJson: _point)
  final GeoPoint? origin;
  @override
  @JsonKey(fromJson: _point)
  final GeoPoint? destination;
  @override
  @JsonKey(fromJson: _double)
  final double distanceSavedMeters;
  @override
  @JsonKey(fromJson: _double)
  final double durationSavedSeconds;

  /// Create a copy of OptimizedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OptimizedRouteCopyWith<_OptimizedRoute> get copyWith =>
      __$OptimizedRouteCopyWithImpl<_OptimizedRoute>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OptimizedRouteToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OptimizedRoute &&
            const DeepCollectionEquality().equals(other._stops, _stops) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.distanceSavedMeters, distanceSavedMeters) ||
                other.distanceSavedMeters == distanceSavedMeters) &&
            (identical(other.durationSavedSeconds, durationSavedSeconds) ||
                other.durationSavedSeconds == durationSavedSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_stops),
      origin,
      destination,
      distanceSavedMeters,
      durationSavedSeconds);

  @override
  String toString() {
    return 'OptimizedRoute(stops: $stops, origin: $origin, destination: $destination, distanceSavedMeters: $distanceSavedMeters, durationSavedSeconds: $durationSavedSeconds)';
  }
}

/// @nodoc
abstract mixin class _$OptimizedRouteCopyWith<$Res>
    implements $OptimizedRouteCopyWith<$Res> {
  factory _$OptimizedRouteCopyWith(
          _OptimizedRoute value, $Res Function(_OptimizedRoute) _then) =
      __$OptimizedRouteCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<OptimizedStop> stops,
      @JsonKey(fromJson: _point) GeoPoint? origin,
      @JsonKey(fromJson: _point) GeoPoint? destination,
      @JsonKey(fromJson: _double) double distanceSavedMeters,
      @JsonKey(fromJson: _double) double durationSavedSeconds});

  @override
  $GeoPointCopyWith<$Res>? get origin;
  @override
  $GeoPointCopyWith<$Res>? get destination;
}

/// @nodoc
class __$OptimizedRouteCopyWithImpl<$Res>
    implements _$OptimizedRouteCopyWith<$Res> {
  __$OptimizedRouteCopyWithImpl(this._self, this._then);

  final _OptimizedRoute _self;
  final $Res Function(_OptimizedRoute) _then;

  /// Create a copy of OptimizedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stops = null,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? distanceSavedMeters = null,
    Object? durationSavedSeconds = null,
  }) {
    return _then(_OptimizedRoute(
      stops: null == stops
          ? _self._stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<OptimizedStop>,
      origin: freezed == origin
          ? _self.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      destination: freezed == destination
          ? _self.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      distanceSavedMeters: null == distanceSavedMeters
          ? _self.distanceSavedMeters
          : distanceSavedMeters // ignore: cast_nullable_to_non_nullable
              as double,
      durationSavedSeconds: null == durationSavedSeconds
          ? _self.durationSavedSeconds
          : durationSavedSeconds // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of OptimizedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get origin {
    if (_self.origin == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_self.origin!, (value) {
      return _then(_self.copyWith(origin: value));
    });
  }

  /// Create a copy of OptimizedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get destination {
    if (_self.destination == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_self.destination!, (value) {
      return _then(_self.copyWith(destination: value));
    });
  }
}

/// @nodoc
mixin _$OptimizedStop {
  /// 1-based position in the suggested order.
  @JsonKey(fromJson: looseInt)
  int? get sequence;
  @JsonKey(fromJson: looseString)
  String? get kidName;
  @JsonKey(fromJson: looseDouble)
  double? get lat;
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  double? get lng;

  /// Create a copy of OptimizedStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OptimizedStopCopyWith<OptimizedStop> get copyWith =>
      _$OptimizedStopCopyWithImpl<OptimizedStop>(
          this as OptimizedStop, _$identity);

  /// Serializes this OptimizedStop to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OptimizedStop &&
            (identical(other.sequence, sequence) ||
                other.sequence == sequence) &&
            (identical(other.kidName, kidName) || other.kidName == kidName) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sequence, kidName, lat, lng);

  @override
  String toString() {
    return 'OptimizedStop(sequence: $sequence, kidName: $kidName, lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class $OptimizedStopCopyWith<$Res> {
  factory $OptimizedStopCopyWith(
          OptimizedStop value, $Res Function(OptimizedStop) _then) =
      _$OptimizedStopCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseInt) int? sequence,
      @JsonKey(fromJson: looseString) String? kidName,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng});
}

/// @nodoc
class _$OptimizedStopCopyWithImpl<$Res>
    implements $OptimizedStopCopyWith<$Res> {
  _$OptimizedStopCopyWithImpl(this._self, this._then);

  final OptimizedStop _self;
  final $Res Function(OptimizedStop) _then;

  /// Create a copy of OptimizedStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sequence = freezed,
    Object? kidName = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_self.copyWith(
      sequence: freezed == sequence
          ? _self.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int?,
      kidName: freezed == kidName
          ? _self.kidName
          : kidName // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [OptimizedStop].
extension OptimizedStopPatterns on OptimizedStop {
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
    TResult Function(_OptimizedStop value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OptimizedStop() when $default != null:
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
    TResult Function(_OptimizedStop value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OptimizedStop():
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
    TResult? Function(_OptimizedStop value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OptimizedStop() when $default != null:
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
            @JsonKey(fromJson: looseInt) int? sequence,
            @JsonKey(fromJson: looseString) String? kidName,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OptimizedStop() when $default != null:
        return $default(_that.sequence, _that.kidName, _that.lat, _that.lng);
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
            @JsonKey(fromJson: looseInt) int? sequence,
            @JsonKey(fromJson: looseString) String? kidName,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OptimizedStop():
        return $default(_that.sequence, _that.kidName, _that.lat, _that.lng);
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
            @JsonKey(fromJson: looseInt) int? sequence,
            @JsonKey(fromJson: looseString) String? kidName,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OptimizedStop() when $default != null:
        return $default(_that.sequence, _that.kidName, _that.lat, _that.lng);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OptimizedStop implements OptimizedStop {
  const _OptimizedStop(
      {@JsonKey(fromJson: looseInt) this.sequence,
      @JsonKey(fromJson: looseString) this.kidName,
      @JsonKey(fromJson: looseDouble) this.lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) this.lng});
  factory _OptimizedStop.fromJson(Map<String, dynamic> json) =>
      _$OptimizedStopFromJson(json);

  /// 1-based position in the suggested order.
  @override
  @JsonKey(fromJson: looseInt)
  final int? sequence;
  @override
  @JsonKey(fromJson: looseString)
  final String? kidName;
  @override
  @JsonKey(fromJson: looseDouble)
  final double? lat;
  @override
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  final double? lng;

  /// Create a copy of OptimizedStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OptimizedStopCopyWith<_OptimizedStop> get copyWith =>
      __$OptimizedStopCopyWithImpl<_OptimizedStop>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OptimizedStopToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OptimizedStop &&
            (identical(other.sequence, sequence) ||
                other.sequence == sequence) &&
            (identical(other.kidName, kidName) || other.kidName == kidName) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sequence, kidName, lat, lng);

  @override
  String toString() {
    return 'OptimizedStop(sequence: $sequence, kidName: $kidName, lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class _$OptimizedStopCopyWith<$Res>
    implements $OptimizedStopCopyWith<$Res> {
  factory _$OptimizedStopCopyWith(
          _OptimizedStop value, $Res Function(_OptimizedStop) _then) =
      __$OptimizedStopCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseInt) int? sequence,
      @JsonKey(fromJson: looseString) String? kidName,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng});
}

/// @nodoc
class __$OptimizedStopCopyWithImpl<$Res>
    implements _$OptimizedStopCopyWith<$Res> {
  __$OptimizedStopCopyWithImpl(this._self, this._then);

  final _OptimizedStop _self;
  final $Res Function(_OptimizedStop) _then;

  /// Create a copy of OptimizedStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sequence = freezed,
    Object? kidName = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_OptimizedStop(
      sequence: freezed == sequence
          ? _self.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int?,
      kidName: freezed == kidName
          ? _self.kidName
          : kidName // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
