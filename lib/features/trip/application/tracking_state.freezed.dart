// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripTrackingState {
  /// The trip on this phone (tracked or not).
  ActiveTrip? get trip;
  bool get isTracking;
  bool get socketConnected;
  GeoPoint? get lastPosition;

  /// Metres per second from the GPS fix (null if the device doesn't report
  /// it). Kept for upcoming overspeed monitoring.
  double? get lastSpeed;

  /// Create a copy of TripTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripTrackingStateCopyWith<TripTrackingState> get copyWith =>
      _$TripTrackingStateCopyWithImpl<TripTrackingState>(
          this as TripTrackingState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TripTrackingState &&
            (identical(other.trip, trip) || other.trip == trip) &&
            (identical(other.isTracking, isTracking) ||
                other.isTracking == isTracking) &&
            (identical(other.socketConnected, socketConnected) ||
                other.socketConnected == socketConnected) &&
            (identical(other.lastPosition, lastPosition) ||
                other.lastPosition == lastPosition) &&
            (identical(other.lastSpeed, lastSpeed) ||
                other.lastSpeed == lastSpeed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, trip, isTracking, socketConnected, lastPosition, lastSpeed);

  @override
  String toString() {
    return 'TripTrackingState(trip: $trip, isTracking: $isTracking, socketConnected: $socketConnected, lastPosition: $lastPosition, lastSpeed: $lastSpeed)';
  }
}

/// @nodoc
abstract mixin class $TripTrackingStateCopyWith<$Res> {
  factory $TripTrackingStateCopyWith(
          TripTrackingState value, $Res Function(TripTrackingState) _then) =
      _$TripTrackingStateCopyWithImpl;
  @useResult
  $Res call(
      {ActiveTrip? trip,
      bool isTracking,
      bool socketConnected,
      GeoPoint? lastPosition,
      double? lastSpeed});

  $ActiveTripCopyWith<$Res>? get trip;
  $GeoPointCopyWith<$Res>? get lastPosition;
}

/// @nodoc
class _$TripTrackingStateCopyWithImpl<$Res>
    implements $TripTrackingStateCopyWith<$Res> {
  _$TripTrackingStateCopyWithImpl(this._self, this._then);

  final TripTrackingState _self;
  final $Res Function(TripTrackingState) _then;

  /// Create a copy of TripTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trip = freezed,
    Object? isTracking = null,
    Object? socketConnected = null,
    Object? lastPosition = freezed,
    Object? lastSpeed = freezed,
  }) {
    return _then(_self.copyWith(
      trip: freezed == trip
          ? _self.trip
          : trip // ignore: cast_nullable_to_non_nullable
              as ActiveTrip?,
      isTracking: null == isTracking
          ? _self.isTracking
          : isTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      socketConnected: null == socketConnected
          ? _self.socketConnected
          : socketConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      lastPosition: freezed == lastPosition
          ? _self.lastPosition
          : lastPosition // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      lastSpeed: freezed == lastSpeed
          ? _self.lastSpeed
          : lastSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }

  /// Create a copy of TripTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActiveTripCopyWith<$Res>? get trip {
    if (_self.trip == null) {
      return null;
    }

    return $ActiveTripCopyWith<$Res>(_self.trip!, (value) {
      return _then(_self.copyWith(trip: value));
    });
  }

  /// Create a copy of TripTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get lastPosition {
    if (_self.lastPosition == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_self.lastPosition!, (value) {
      return _then(_self.copyWith(lastPosition: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TripTrackingState].
extension TripTrackingStatePatterns on TripTrackingState {
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
    TResult Function(_TripTrackingState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripTrackingState() when $default != null:
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
    TResult Function(_TripTrackingState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrackingState():
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
    TResult? Function(_TripTrackingState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrackingState() when $default != null:
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
    TResult Function(ActiveTrip? trip, bool isTracking, bool socketConnected,
            GeoPoint? lastPosition, double? lastSpeed)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripTrackingState() when $default != null:
        return $default(_that.trip, _that.isTracking, _that.socketConnected,
            _that.lastPosition, _that.lastSpeed);
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
    TResult Function(ActiveTrip? trip, bool isTracking, bool socketConnected,
            GeoPoint? lastPosition, double? lastSpeed)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrackingState():
        return $default(_that.trip, _that.isTracking, _that.socketConnected,
            _that.lastPosition, _that.lastSpeed);
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
    TResult? Function(ActiveTrip? trip, bool isTracking, bool socketConnected,
            GeoPoint? lastPosition, double? lastSpeed)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrackingState() when $default != null:
        return $default(_that.trip, _that.isTracking, _that.socketConnected,
            _that.lastPosition, _that.lastSpeed);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TripTrackingState extends TripTrackingState {
  const _TripTrackingState(
      {this.trip,
      this.isTracking = false,
      this.socketConnected = false,
      this.lastPosition,
      this.lastSpeed})
      : super._();

  /// The trip on this phone (tracked or not).
  @override
  final ActiveTrip? trip;
  @override
  @JsonKey()
  final bool isTracking;
  @override
  @JsonKey()
  final bool socketConnected;
  @override
  final GeoPoint? lastPosition;

  /// Metres per second from the GPS fix (null if the device doesn't report
  /// it). Kept for upcoming overspeed monitoring.
  @override
  final double? lastSpeed;

  /// Create a copy of TripTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripTrackingStateCopyWith<_TripTrackingState> get copyWith =>
      __$TripTrackingStateCopyWithImpl<_TripTrackingState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TripTrackingState &&
            (identical(other.trip, trip) || other.trip == trip) &&
            (identical(other.isTracking, isTracking) ||
                other.isTracking == isTracking) &&
            (identical(other.socketConnected, socketConnected) ||
                other.socketConnected == socketConnected) &&
            (identical(other.lastPosition, lastPosition) ||
                other.lastPosition == lastPosition) &&
            (identical(other.lastSpeed, lastSpeed) ||
                other.lastSpeed == lastSpeed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, trip, isTracking, socketConnected, lastPosition, lastSpeed);

  @override
  String toString() {
    return 'TripTrackingState(trip: $trip, isTracking: $isTracking, socketConnected: $socketConnected, lastPosition: $lastPosition, lastSpeed: $lastSpeed)';
  }
}

/// @nodoc
abstract mixin class _$TripTrackingStateCopyWith<$Res>
    implements $TripTrackingStateCopyWith<$Res> {
  factory _$TripTrackingStateCopyWith(
          _TripTrackingState value, $Res Function(_TripTrackingState) _then) =
      __$TripTrackingStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ActiveTrip? trip,
      bool isTracking,
      bool socketConnected,
      GeoPoint? lastPosition,
      double? lastSpeed});

  @override
  $ActiveTripCopyWith<$Res>? get trip;
  @override
  $GeoPointCopyWith<$Res>? get lastPosition;
}

/// @nodoc
class __$TripTrackingStateCopyWithImpl<$Res>
    implements _$TripTrackingStateCopyWith<$Res> {
  __$TripTrackingStateCopyWithImpl(this._self, this._then);

  final _TripTrackingState _self;
  final $Res Function(_TripTrackingState) _then;

  /// Create a copy of TripTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? trip = freezed,
    Object? isTracking = null,
    Object? socketConnected = null,
    Object? lastPosition = freezed,
    Object? lastSpeed = freezed,
  }) {
    return _then(_TripTrackingState(
      trip: freezed == trip
          ? _self.trip
          : trip // ignore: cast_nullable_to_non_nullable
              as ActiveTrip?,
      isTracking: null == isTracking
          ? _self.isTracking
          : isTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      socketConnected: null == socketConnected
          ? _self.socketConnected
          : socketConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      lastPosition: freezed == lastPosition
          ? _self.lastPosition
          : lastPosition // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      lastSpeed: freezed == lastSpeed
          ? _self.lastSpeed
          : lastSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }

  /// Create a copy of TripTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActiveTripCopyWith<$Res>? get trip {
    if (_self.trip == null) {
      return null;
    }

    return $ActiveTripCopyWith<$Res>(_self.trip!, (value) {
      return _then(_self.copyWith(trip: value));
    });
  }

  /// Create a copy of TripTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoPointCopyWith<$Res>? get lastPosition {
    if (_self.lastPosition == null) {
      return null;
    }

    return $GeoPointCopyWith<$Res>(_self.lastPosition!, (value) {
      return _then(_self.copyWith(lastPosition: value));
    });
  }
}

// dart format on
