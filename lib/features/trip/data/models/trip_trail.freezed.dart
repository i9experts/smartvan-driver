// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_trail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrailPoint {
  @JsonKey(fromJson: _toDouble)
  double get lat;
  @JsonKey(readValue: readLng, fromJson: _toDouble)
  double get lng;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get t;

  /// Create a copy of TrailPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrailPointCopyWith<TrailPoint> get copyWith =>
      _$TrailPointCopyWithImpl<TrailPoint>(this as TrailPoint, _$identity);

  /// Serializes this TrailPoint to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrailPoint &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.t, t) || other.t == t));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng, t);

  @override
  String toString() {
    return 'TrailPoint(lat: $lat, lng: $lng, t: $t)';
  }
}

/// @nodoc
abstract mixin class $TrailPointCopyWith<$Res> {
  factory $TrailPointCopyWith(
          TrailPoint value, $Res Function(TrailPoint) _then) =
      _$TrailPointCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _toDouble) double lat,
      @JsonKey(readValue: readLng, fromJson: _toDouble) double lng,
      @JsonKey(fromJson: looseDateTime) DateTime? t});
}

/// @nodoc
class _$TrailPointCopyWithImpl<$Res> implements $TrailPointCopyWith<$Res> {
  _$TrailPointCopyWithImpl(this._self, this._then);

  final TrailPoint _self;
  final $Res Function(TrailPoint) _then;

  /// Create a copy of TrailPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? t = freezed,
  }) {
    return _then(_self.copyWith(
      lat: null == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      t: freezed == t
          ? _self.t
          : t // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TrailPoint].
extension TrailPointPatterns on TrailPoint {
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
    TResult Function(_TrailPoint value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrailPoint() when $default != null:
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
    TResult Function(_TrailPoint value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrailPoint():
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
    TResult? Function(_TrailPoint value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrailPoint() when $default != null:
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
            @JsonKey(fromJson: _toDouble) double lat,
            @JsonKey(readValue: readLng, fromJson: _toDouble) double lng,
            @JsonKey(fromJson: looseDateTime) DateTime? t)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrailPoint() when $default != null:
        return $default(_that.lat, _that.lng, _that.t);
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
            @JsonKey(fromJson: _toDouble) double lat,
            @JsonKey(readValue: readLng, fromJson: _toDouble) double lng,
            @JsonKey(fromJson: looseDateTime) DateTime? t)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrailPoint():
        return $default(_that.lat, _that.lng, _that.t);
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
            @JsonKey(fromJson: _toDouble) double lat,
            @JsonKey(readValue: readLng, fromJson: _toDouble) double lng,
            @JsonKey(fromJson: looseDateTime) DateTime? t)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrailPoint() when $default != null:
        return $default(_that.lat, _that.lng, _that.t);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TrailPoint implements TrailPoint {
  const _TrailPoint(
      {@JsonKey(fromJson: _toDouble) required this.lat,
      @JsonKey(readValue: readLng, fromJson: _toDouble) required this.lng,
      @JsonKey(fromJson: looseDateTime) this.t});
  factory _TrailPoint.fromJson(Map<String, dynamic> json) =>
      _$TrailPointFromJson(json);

  @override
  @JsonKey(fromJson: _toDouble)
  final double lat;
  @override
  @JsonKey(readValue: readLng, fromJson: _toDouble)
  final double lng;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? t;

  /// Create a copy of TrailPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrailPointCopyWith<_TrailPoint> get copyWith =>
      __$TrailPointCopyWithImpl<_TrailPoint>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrailPointToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrailPoint &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.t, t) || other.t == t));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng, t);

  @override
  String toString() {
    return 'TrailPoint(lat: $lat, lng: $lng, t: $t)';
  }
}

/// @nodoc
abstract mixin class _$TrailPointCopyWith<$Res>
    implements $TrailPointCopyWith<$Res> {
  factory _$TrailPointCopyWith(
          _TrailPoint value, $Res Function(_TrailPoint) _then) =
      __$TrailPointCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _toDouble) double lat,
      @JsonKey(readValue: readLng, fromJson: _toDouble) double lng,
      @JsonKey(fromJson: looseDateTime) DateTime? t});
}

/// @nodoc
class __$TrailPointCopyWithImpl<$Res> implements _$TrailPointCopyWith<$Res> {
  __$TrailPointCopyWithImpl(this._self, this._then);

  final _TrailPoint _self;
  final $Res Function(_TrailPoint) _then;

  /// Create a copy of TrailPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? t = freezed,
  }) {
    return _then(_TrailPoint(
      lat: null == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      t: freezed == t
          ? _self.t
          : t // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$TripTrail {
  @JsonKey(fromJson: looseString)
  String? get polyline;
  List<TrailPoint> get path;
  TrailPoint? get start;
  TrailPoint? get end;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get endedAt;

  /// Create a copy of TripTrail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripTrailCopyWith<TripTrail> get copyWith =>
      _$TripTrailCopyWithImpl<TripTrail>(this as TripTrail, _$identity);

  /// Serializes this TripTrail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TripTrail &&
            (identical(other.polyline, polyline) ||
                other.polyline == polyline) &&
            const DeepCollectionEquality().equals(other.path, path) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, polyline,
      const DeepCollectionEquality().hash(path), start, end, endedAt);

  @override
  String toString() {
    return 'TripTrail(polyline: $polyline, path: $path, start: $start, end: $end, endedAt: $endedAt)';
  }
}

/// @nodoc
abstract mixin class $TripTrailCopyWith<$Res> {
  factory $TripTrailCopyWith(TripTrail value, $Res Function(TripTrail) _then) =
      _$TripTrailCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? polyline,
      List<TrailPoint> path,
      TrailPoint? start,
      TrailPoint? end,
      @JsonKey(fromJson: looseDateTime) DateTime? endedAt});

  $TrailPointCopyWith<$Res>? get start;
  $TrailPointCopyWith<$Res>? get end;
}

/// @nodoc
class _$TripTrailCopyWithImpl<$Res> implements $TripTrailCopyWith<$Res> {
  _$TripTrailCopyWithImpl(this._self, this._then);

  final TripTrail _self;
  final $Res Function(TripTrail) _then;

  /// Create a copy of TripTrail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? polyline = freezed,
    Object? path = null,
    Object? start = freezed,
    Object? end = freezed,
    Object? endedAt = freezed,
  }) {
    return _then(_self.copyWith(
      polyline: freezed == polyline
          ? _self.polyline
          : polyline // ignore: cast_nullable_to_non_nullable
              as String?,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as List<TrailPoint>,
      start: freezed == start
          ? _self.start
          : start // ignore: cast_nullable_to_non_nullable
              as TrailPoint?,
      end: freezed == end
          ? _self.end
          : end // ignore: cast_nullable_to_non_nullable
              as TrailPoint?,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of TripTrail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrailPointCopyWith<$Res>? get start {
    if (_self.start == null) {
      return null;
    }

    return $TrailPointCopyWith<$Res>(_self.start!, (value) {
      return _then(_self.copyWith(start: value));
    });
  }

  /// Create a copy of TripTrail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrailPointCopyWith<$Res>? get end {
    if (_self.end == null) {
      return null;
    }

    return $TrailPointCopyWith<$Res>(_self.end!, (value) {
      return _then(_self.copyWith(end: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TripTrail].
extension TripTrailPatterns on TripTrail {
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
    TResult Function(_TripTrail value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripTrail() when $default != null:
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
    TResult Function(_TripTrail value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrail():
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
    TResult? Function(_TripTrail value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrail() when $default != null:
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
            @JsonKey(fromJson: looseString) String? polyline,
            List<TrailPoint> path,
            TrailPoint? start,
            TrailPoint? end,
            @JsonKey(fromJson: looseDateTime) DateTime? endedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripTrail() when $default != null:
        return $default(
            _that.polyline, _that.path, _that.start, _that.end, _that.endedAt);
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
            @JsonKey(fromJson: looseString) String? polyline,
            List<TrailPoint> path,
            TrailPoint? start,
            TrailPoint? end,
            @JsonKey(fromJson: looseDateTime) DateTime? endedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrail():
        return $default(
            _that.polyline, _that.path, _that.start, _that.end, _that.endedAt);
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
            @JsonKey(fromJson: looseString) String? polyline,
            List<TrailPoint> path,
            TrailPoint? start,
            TrailPoint? end,
            @JsonKey(fromJson: looseDateTime) DateTime? endedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrail() when $default != null:
        return $default(
            _that.polyline, _that.path, _that.start, _that.end, _that.endedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TripTrail extends TripTrail {
  const _TripTrail(
      {@JsonKey(fromJson: looseString) this.polyline,
      final List<TrailPoint> path = const <TrailPoint>[],
      this.start,
      this.end,
      @JsonKey(fromJson: looseDateTime) this.endedAt})
      : _path = path,
        super._();
  factory _TripTrail.fromJson(Map<String, dynamic> json) =>
      _$TripTrailFromJson(json);

  @override
  @JsonKey(fromJson: looseString)
  final String? polyline;
  final List<TrailPoint> _path;
  @override
  @JsonKey()
  List<TrailPoint> get path {
    if (_path is EqualUnmodifiableListView) return _path;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_path);
  }

  @override
  final TrailPoint? start;
  @override
  final TrailPoint? end;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? endedAt;

  /// Create a copy of TripTrail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripTrailCopyWith<_TripTrail> get copyWith =>
      __$TripTrailCopyWithImpl<_TripTrail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TripTrailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TripTrail &&
            (identical(other.polyline, polyline) ||
                other.polyline == polyline) &&
            const DeepCollectionEquality().equals(other._path, _path) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, polyline,
      const DeepCollectionEquality().hash(_path), start, end, endedAt);

  @override
  String toString() {
    return 'TripTrail(polyline: $polyline, path: $path, start: $start, end: $end, endedAt: $endedAt)';
  }
}

/// @nodoc
abstract mixin class _$TripTrailCopyWith<$Res>
    implements $TripTrailCopyWith<$Res> {
  factory _$TripTrailCopyWith(
          _TripTrail value, $Res Function(_TripTrail) _then) =
      __$TripTrailCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? polyline,
      List<TrailPoint> path,
      TrailPoint? start,
      TrailPoint? end,
      @JsonKey(fromJson: looseDateTime) DateTime? endedAt});

  @override
  $TrailPointCopyWith<$Res>? get start;
  @override
  $TrailPointCopyWith<$Res>? get end;
}

/// @nodoc
class __$TripTrailCopyWithImpl<$Res> implements _$TripTrailCopyWith<$Res> {
  __$TripTrailCopyWithImpl(this._self, this._then);

  final _TripTrail _self;
  final $Res Function(_TripTrail) _then;

  /// Create a copy of TripTrail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? polyline = freezed,
    Object? path = null,
    Object? start = freezed,
    Object? end = freezed,
    Object? endedAt = freezed,
  }) {
    return _then(_TripTrail(
      polyline: freezed == polyline
          ? _self.polyline
          : polyline // ignore: cast_nullable_to_non_nullable
              as String?,
      path: null == path
          ? _self._path
          : path // ignore: cast_nullable_to_non_nullable
              as List<TrailPoint>,
      start: freezed == start
          ? _self.start
          : start // ignore: cast_nullable_to_non_nullable
              as TrailPoint?,
      end: freezed == end
          ? _self.end
          : end // ignore: cast_nullable_to_non_nullable
              as TrailPoint?,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of TripTrail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrailPointCopyWith<$Res>? get start {
    if (_self.start == null) {
      return null;
    }

    return $TrailPointCopyWith<$Res>(_self.start!, (value) {
      return _then(_self.copyWith(start: value));
    });
  }

  /// Create a copy of TripTrail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrailPointCopyWith<$Res>? get end {
    if (_self.end == null) {
      return null;
    }

    return $TrailPointCopyWith<$Res>(_self.end!, (value) {
      return _then(_self.copyWith(end: value));
    });
  }
}

// dart format on
