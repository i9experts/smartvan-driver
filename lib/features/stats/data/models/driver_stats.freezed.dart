// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverStats {
  /// 0–100.
  @JsonKey(fromJson: looseDouble)
  double? get safetyScore;

  /// 0–100; absent when the driver had no timed trips.
  @JsonKey(fromJson: looseDouble)
  double? get onTimePercent;
  @JsonKey(fromJson: _int)
  int get overspeedCount;
  @JsonKey(fromJson: looseInt)
  int? get speedLimitKmh;
  @JsonKey(fromJson: _int)
  int get trips;
  @JsonKey(fromJson: _double)
  double get distanceKm;
  @JsonKey(fromJson: _int)
  int get drivingMinutes;
  @JsonKey(fromJson: _int)
  int get kidsDropped;
  @JsonKey(fromJson: looseDouble)
  double? get maxSpeedKmh;

  /// Create a copy of DriverStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DriverStatsCopyWith<DriverStats> get copyWith =>
      _$DriverStatsCopyWithImpl<DriverStats>(this as DriverStats, _$identity);

  /// Serializes this DriverStats to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DriverStats &&
            (identical(other.safetyScore, safetyScore) ||
                other.safetyScore == safetyScore) &&
            (identical(other.onTimePercent, onTimePercent) ||
                other.onTimePercent == onTimePercent) &&
            (identical(other.overspeedCount, overspeedCount) ||
                other.overspeedCount == overspeedCount) &&
            (identical(other.speedLimitKmh, speedLimitKmh) ||
                other.speedLimitKmh == speedLimitKmh) &&
            (identical(other.trips, trips) || other.trips == trips) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.drivingMinutes, drivingMinutes) ||
                other.drivingMinutes == drivingMinutes) &&
            (identical(other.kidsDropped, kidsDropped) ||
                other.kidsDropped == kidsDropped) &&
            (identical(other.maxSpeedKmh, maxSpeedKmh) ||
                other.maxSpeedKmh == maxSpeedKmh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      safetyScore,
      onTimePercent,
      overspeedCount,
      speedLimitKmh,
      trips,
      distanceKm,
      drivingMinutes,
      kidsDropped,
      maxSpeedKmh);

  @override
  String toString() {
    return 'DriverStats(safetyScore: $safetyScore, onTimePercent: $onTimePercent, overspeedCount: $overspeedCount, speedLimitKmh: $speedLimitKmh, trips: $trips, distanceKm: $distanceKm, drivingMinutes: $drivingMinutes, kidsDropped: $kidsDropped, maxSpeedKmh: $maxSpeedKmh)';
  }
}

/// @nodoc
abstract mixin class $DriverStatsCopyWith<$Res> {
  factory $DriverStatsCopyWith(
          DriverStats value, $Res Function(DriverStats) _then) =
      _$DriverStatsCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseDouble) double? safetyScore,
      @JsonKey(fromJson: looseDouble) double? onTimePercent,
      @JsonKey(fromJson: _int) int overspeedCount,
      @JsonKey(fromJson: looseInt) int? speedLimitKmh,
      @JsonKey(fromJson: _int) int trips,
      @JsonKey(fromJson: _double) double distanceKm,
      @JsonKey(fromJson: _int) int drivingMinutes,
      @JsonKey(fromJson: _int) int kidsDropped,
      @JsonKey(fromJson: looseDouble) double? maxSpeedKmh});
}

/// @nodoc
class _$DriverStatsCopyWithImpl<$Res> implements $DriverStatsCopyWith<$Res> {
  _$DriverStatsCopyWithImpl(this._self, this._then);

  final DriverStats _self;
  final $Res Function(DriverStats) _then;

  /// Create a copy of DriverStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? safetyScore = freezed,
    Object? onTimePercent = freezed,
    Object? overspeedCount = null,
    Object? speedLimitKmh = freezed,
    Object? trips = null,
    Object? distanceKm = null,
    Object? drivingMinutes = null,
    Object? kidsDropped = null,
    Object? maxSpeedKmh = freezed,
  }) {
    return _then(_self.copyWith(
      safetyScore: freezed == safetyScore
          ? _self.safetyScore
          : safetyScore // ignore: cast_nullable_to_non_nullable
              as double?,
      onTimePercent: freezed == onTimePercent
          ? _self.onTimePercent
          : onTimePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      overspeedCount: null == overspeedCount
          ? _self.overspeedCount
          : overspeedCount // ignore: cast_nullable_to_non_nullable
              as int,
      speedLimitKmh: freezed == speedLimitKmh
          ? _self.speedLimitKmh
          : speedLimitKmh // ignore: cast_nullable_to_non_nullable
              as int?,
      trips: null == trips
          ? _self.trips
          : trips // ignore: cast_nullable_to_non_nullable
              as int,
      distanceKm: null == distanceKm
          ? _self.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      drivingMinutes: null == drivingMinutes
          ? _self.drivingMinutes
          : drivingMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      kidsDropped: null == kidsDropped
          ? _self.kidsDropped
          : kidsDropped // ignore: cast_nullable_to_non_nullable
              as int,
      maxSpeedKmh: freezed == maxSpeedKmh
          ? _self.maxSpeedKmh
          : maxSpeedKmh // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DriverStats].
extension DriverStatsPatterns on DriverStats {
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
    TResult Function(_DriverStats value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DriverStats() when $default != null:
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
    TResult Function(_DriverStats value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DriverStats():
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
    TResult? Function(_DriverStats value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DriverStats() when $default != null:
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
            @JsonKey(fromJson: looseDouble) double? safetyScore,
            @JsonKey(fromJson: looseDouble) double? onTimePercent,
            @JsonKey(fromJson: _int) int overspeedCount,
            @JsonKey(fromJson: looseInt) int? speedLimitKmh,
            @JsonKey(fromJson: _int) int trips,
            @JsonKey(fromJson: _double) double distanceKm,
            @JsonKey(fromJson: _int) int drivingMinutes,
            @JsonKey(fromJson: _int) int kidsDropped,
            @JsonKey(fromJson: looseDouble) double? maxSpeedKmh)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DriverStats() when $default != null:
        return $default(
            _that.safetyScore,
            _that.onTimePercent,
            _that.overspeedCount,
            _that.speedLimitKmh,
            _that.trips,
            _that.distanceKm,
            _that.drivingMinutes,
            _that.kidsDropped,
            _that.maxSpeedKmh);
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
            @JsonKey(fromJson: looseDouble) double? safetyScore,
            @JsonKey(fromJson: looseDouble) double? onTimePercent,
            @JsonKey(fromJson: _int) int overspeedCount,
            @JsonKey(fromJson: looseInt) int? speedLimitKmh,
            @JsonKey(fromJson: _int) int trips,
            @JsonKey(fromJson: _double) double distanceKm,
            @JsonKey(fromJson: _int) int drivingMinutes,
            @JsonKey(fromJson: _int) int kidsDropped,
            @JsonKey(fromJson: looseDouble) double? maxSpeedKmh)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DriverStats():
        return $default(
            _that.safetyScore,
            _that.onTimePercent,
            _that.overspeedCount,
            _that.speedLimitKmh,
            _that.trips,
            _that.distanceKm,
            _that.drivingMinutes,
            _that.kidsDropped,
            _that.maxSpeedKmh);
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
            @JsonKey(fromJson: looseDouble) double? safetyScore,
            @JsonKey(fromJson: looseDouble) double? onTimePercent,
            @JsonKey(fromJson: _int) int overspeedCount,
            @JsonKey(fromJson: looseInt) int? speedLimitKmh,
            @JsonKey(fromJson: _int) int trips,
            @JsonKey(fromJson: _double) double distanceKm,
            @JsonKey(fromJson: _int) int drivingMinutes,
            @JsonKey(fromJson: _int) int kidsDropped,
            @JsonKey(fromJson: looseDouble) double? maxSpeedKmh)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DriverStats() when $default != null:
        return $default(
            _that.safetyScore,
            _that.onTimePercent,
            _that.overspeedCount,
            _that.speedLimitKmh,
            _that.trips,
            _that.distanceKm,
            _that.drivingMinutes,
            _that.kidsDropped,
            _that.maxSpeedKmh);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DriverStats implements DriverStats {
  const _DriverStats(
      {@JsonKey(fromJson: looseDouble) this.safetyScore,
      @JsonKey(fromJson: looseDouble) this.onTimePercent,
      @JsonKey(fromJson: _int) this.overspeedCount = 0,
      @JsonKey(fromJson: looseInt) this.speedLimitKmh,
      @JsonKey(fromJson: _int) this.trips = 0,
      @JsonKey(fromJson: _double) this.distanceKm = 0,
      @JsonKey(fromJson: _int) this.drivingMinutes = 0,
      @JsonKey(fromJson: _int) this.kidsDropped = 0,
      @JsonKey(fromJson: looseDouble) this.maxSpeedKmh});
  factory _DriverStats.fromJson(Map<String, dynamic> json) =>
      _$DriverStatsFromJson(json);

  /// 0–100.
  @override
  @JsonKey(fromJson: looseDouble)
  final double? safetyScore;

  /// 0–100; absent when the driver had no timed trips.
  @override
  @JsonKey(fromJson: looseDouble)
  final double? onTimePercent;
  @override
  @JsonKey(fromJson: _int)
  final int overspeedCount;
  @override
  @JsonKey(fromJson: looseInt)
  final int? speedLimitKmh;
  @override
  @JsonKey(fromJson: _int)
  final int trips;
  @override
  @JsonKey(fromJson: _double)
  final double distanceKm;
  @override
  @JsonKey(fromJson: _int)
  final int drivingMinutes;
  @override
  @JsonKey(fromJson: _int)
  final int kidsDropped;
  @override
  @JsonKey(fromJson: looseDouble)
  final double? maxSpeedKmh;

  /// Create a copy of DriverStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DriverStatsCopyWith<_DriverStats> get copyWith =>
      __$DriverStatsCopyWithImpl<_DriverStats>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DriverStatsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DriverStats &&
            (identical(other.safetyScore, safetyScore) ||
                other.safetyScore == safetyScore) &&
            (identical(other.onTimePercent, onTimePercent) ||
                other.onTimePercent == onTimePercent) &&
            (identical(other.overspeedCount, overspeedCount) ||
                other.overspeedCount == overspeedCount) &&
            (identical(other.speedLimitKmh, speedLimitKmh) ||
                other.speedLimitKmh == speedLimitKmh) &&
            (identical(other.trips, trips) || other.trips == trips) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.drivingMinutes, drivingMinutes) ||
                other.drivingMinutes == drivingMinutes) &&
            (identical(other.kidsDropped, kidsDropped) ||
                other.kidsDropped == kidsDropped) &&
            (identical(other.maxSpeedKmh, maxSpeedKmh) ||
                other.maxSpeedKmh == maxSpeedKmh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      safetyScore,
      onTimePercent,
      overspeedCount,
      speedLimitKmh,
      trips,
      distanceKm,
      drivingMinutes,
      kidsDropped,
      maxSpeedKmh);

  @override
  String toString() {
    return 'DriverStats(safetyScore: $safetyScore, onTimePercent: $onTimePercent, overspeedCount: $overspeedCount, speedLimitKmh: $speedLimitKmh, trips: $trips, distanceKm: $distanceKm, drivingMinutes: $drivingMinutes, kidsDropped: $kidsDropped, maxSpeedKmh: $maxSpeedKmh)';
  }
}

/// @nodoc
abstract mixin class _$DriverStatsCopyWith<$Res>
    implements $DriverStatsCopyWith<$Res> {
  factory _$DriverStatsCopyWith(
          _DriverStats value, $Res Function(_DriverStats) _then) =
      __$DriverStatsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseDouble) double? safetyScore,
      @JsonKey(fromJson: looseDouble) double? onTimePercent,
      @JsonKey(fromJson: _int) int overspeedCount,
      @JsonKey(fromJson: looseInt) int? speedLimitKmh,
      @JsonKey(fromJson: _int) int trips,
      @JsonKey(fromJson: _double) double distanceKm,
      @JsonKey(fromJson: _int) int drivingMinutes,
      @JsonKey(fromJson: _int) int kidsDropped,
      @JsonKey(fromJson: looseDouble) double? maxSpeedKmh});
}

/// @nodoc
class __$DriverStatsCopyWithImpl<$Res> implements _$DriverStatsCopyWith<$Res> {
  __$DriverStatsCopyWithImpl(this._self, this._then);

  final _DriverStats _self;
  final $Res Function(_DriverStats) _then;

  /// Create a copy of DriverStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? safetyScore = freezed,
    Object? onTimePercent = freezed,
    Object? overspeedCount = null,
    Object? speedLimitKmh = freezed,
    Object? trips = null,
    Object? distanceKm = null,
    Object? drivingMinutes = null,
    Object? kidsDropped = null,
    Object? maxSpeedKmh = freezed,
  }) {
    return _then(_DriverStats(
      safetyScore: freezed == safetyScore
          ? _self.safetyScore
          : safetyScore // ignore: cast_nullable_to_non_nullable
              as double?,
      onTimePercent: freezed == onTimePercent
          ? _self.onTimePercent
          : onTimePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      overspeedCount: null == overspeedCount
          ? _self.overspeedCount
          : overspeedCount // ignore: cast_nullable_to_non_nullable
              as int,
      speedLimitKmh: freezed == speedLimitKmh
          ? _self.speedLimitKmh
          : speedLimitKmh // ignore: cast_nullable_to_non_nullable
              as int?,
      trips: null == trips
          ? _self.trips
          : trips // ignore: cast_nullable_to_non_nullable
              as int,
      distanceKm: null == distanceKm
          ? _self.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      drivingMinutes: null == drivingMinutes
          ? _self.drivingMinutes
          : drivingMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      kidsDropped: null == kidsDropped
          ? _self.kidsDropped
          : kidsDropped // ignore: cast_nullable_to_non_nullable
              as int,
      maxSpeedKmh: freezed == maxSpeedKmh
          ? _self.maxSpeedKmh
          : maxSpeedKmh // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
