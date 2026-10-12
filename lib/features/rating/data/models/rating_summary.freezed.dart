// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RatingSummary {
  /// 0 when nobody has rated yet.
  @JsonKey(fromJson: _double)
  double get avgRating;
  @JsonKey(fromJson: _int)
  int get ratingCount;
  @JsonKey(fromJson: _int)
  int get completedTripCount;

  /// Create a copy of RatingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RatingSummaryCopyWith<RatingSummary> get copyWith =>
      _$RatingSummaryCopyWithImpl<RatingSummary>(
          this as RatingSummary, _$identity);

  /// Serializes this RatingSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RatingSummary &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.completedTripCount, completedTripCount) ||
                other.completedTripCount == completedTripCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, avgRating, ratingCount, completedTripCount);

  @override
  String toString() {
    return 'RatingSummary(avgRating: $avgRating, ratingCount: $ratingCount, completedTripCount: $completedTripCount)';
  }
}

/// @nodoc
abstract mixin class $RatingSummaryCopyWith<$Res> {
  factory $RatingSummaryCopyWith(
          RatingSummary value, $Res Function(RatingSummary) _then) =
      _$RatingSummaryCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _double) double avgRating,
      @JsonKey(fromJson: _int) int ratingCount,
      @JsonKey(fromJson: _int) int completedTripCount});
}

/// @nodoc
class _$RatingSummaryCopyWithImpl<$Res>
    implements $RatingSummaryCopyWith<$Res> {
  _$RatingSummaryCopyWithImpl(this._self, this._then);

  final RatingSummary _self;
  final $Res Function(RatingSummary) _then;

  /// Create a copy of RatingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgRating = null,
    Object? ratingCount = null,
    Object? completedTripCount = null,
  }) {
    return _then(_self.copyWith(
      avgRating: null == avgRating
          ? _self.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedTripCount: null == completedTripCount
          ? _self.completedTripCount
          : completedTripCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [RatingSummary].
extension RatingSummaryPatterns on RatingSummary {
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
    TResult Function(_RatingSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RatingSummary() when $default != null:
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
    TResult Function(_RatingSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RatingSummary():
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
    TResult? Function(_RatingSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RatingSummary() when $default != null:
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
            @JsonKey(fromJson: _double) double avgRating,
            @JsonKey(fromJson: _int) int ratingCount,
            @JsonKey(fromJson: _int) int completedTripCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RatingSummary() when $default != null:
        return $default(
            _that.avgRating, _that.ratingCount, _that.completedTripCount);
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
            @JsonKey(fromJson: _double) double avgRating,
            @JsonKey(fromJson: _int) int ratingCount,
            @JsonKey(fromJson: _int) int completedTripCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RatingSummary():
        return $default(
            _that.avgRating, _that.ratingCount, _that.completedTripCount);
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
            @JsonKey(fromJson: _double) double avgRating,
            @JsonKey(fromJson: _int) int ratingCount,
            @JsonKey(fromJson: _int) int completedTripCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RatingSummary() when $default != null:
        return $default(
            _that.avgRating, _that.ratingCount, _that.completedTripCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RatingSummary implements RatingSummary {
  const _RatingSummary(
      {@JsonKey(fromJson: _double) this.avgRating = 0,
      @JsonKey(fromJson: _int) this.ratingCount = 0,
      @JsonKey(fromJson: _int) this.completedTripCount = 0});
  factory _RatingSummary.fromJson(Map<String, dynamic> json) =>
      _$RatingSummaryFromJson(json);

  /// 0 when nobody has rated yet.
  @override
  @JsonKey(fromJson: _double)
  final double avgRating;
  @override
  @JsonKey(fromJson: _int)
  final int ratingCount;
  @override
  @JsonKey(fromJson: _int)
  final int completedTripCount;

  /// Create a copy of RatingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RatingSummaryCopyWith<_RatingSummary> get copyWith =>
      __$RatingSummaryCopyWithImpl<_RatingSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RatingSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RatingSummary &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.completedTripCount, completedTripCount) ||
                other.completedTripCount == completedTripCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, avgRating, ratingCount, completedTripCount);

  @override
  String toString() {
    return 'RatingSummary(avgRating: $avgRating, ratingCount: $ratingCount, completedTripCount: $completedTripCount)';
  }
}

/// @nodoc
abstract mixin class _$RatingSummaryCopyWith<$Res>
    implements $RatingSummaryCopyWith<$Res> {
  factory _$RatingSummaryCopyWith(
          _RatingSummary value, $Res Function(_RatingSummary) _then) =
      __$RatingSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _double) double avgRating,
      @JsonKey(fromJson: _int) int ratingCount,
      @JsonKey(fromJson: _int) int completedTripCount});
}

/// @nodoc
class __$RatingSummaryCopyWithImpl<$Res>
    implements _$RatingSummaryCopyWith<$Res> {
  __$RatingSummaryCopyWithImpl(this._self, this._then);

  final _RatingSummary _self;
  final $Res Function(_RatingSummary) _then;

  /// Create a copy of RatingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? avgRating = null,
    Object? ratingCount = null,
    Object? completedTripCount = null,
  }) {
    return _then(_RatingSummary(
      avgRating: null == avgRating
          ? _self.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedTripCount: null == completedTripCount
          ? _self.completedTripCount
          : completedTripCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
