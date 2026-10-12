// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rate_trip_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RateTripState {
  List<PendingRatee> get queue;

  /// The parent being rated.
  int get index;

  /// 0 = nothing picked yet.
  int get stars;
  bool get submitting;

  /// Create a copy of RateTripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RateTripStateCopyWith<RateTripState> get copyWith =>
      _$RateTripStateCopyWithImpl<RateTripState>(
          this as RateTripState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RateTripState &&
            const DeepCollectionEquality().equals(other.queue, queue) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.stars, stars) || other.stars == stars) &&
            (identical(other.submitting, submitting) ||
                other.submitting == submitting));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(queue), index, stars, submitting);

  @override
  String toString() {
    return 'RateTripState(queue: $queue, index: $index, stars: $stars, submitting: $submitting)';
  }
}

/// @nodoc
abstract mixin class $RateTripStateCopyWith<$Res> {
  factory $RateTripStateCopyWith(
          RateTripState value, $Res Function(RateTripState) _then) =
      _$RateTripStateCopyWithImpl;
  @useResult
  $Res call({List<PendingRatee> queue, int index, int stars, bool submitting});
}

/// @nodoc
class _$RateTripStateCopyWithImpl<$Res>
    implements $RateTripStateCopyWith<$Res> {
  _$RateTripStateCopyWithImpl(this._self, this._then);

  final RateTripState _self;
  final $Res Function(RateTripState) _then;

  /// Create a copy of RateTripState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? queue = null,
    Object? index = null,
    Object? stars = null,
    Object? submitting = null,
  }) {
    return _then(_self.copyWith(
      queue: null == queue
          ? _self.queue
          : queue // ignore: cast_nullable_to_non_nullable
              as List<PendingRatee>,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      stars: null == stars
          ? _self.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      submitting: null == submitting
          ? _self.submitting
          : submitting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [RateTripState].
extension RateTripStatePatterns on RateTripState {
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
    TResult Function(_RateTripState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RateTripState() when $default != null:
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
    TResult Function(_RateTripState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RateTripState():
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
    TResult? Function(_RateTripState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RateTripState() when $default != null:
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
            List<PendingRatee> queue, int index, int stars, bool submitting)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RateTripState() when $default != null:
        return $default(
            _that.queue, _that.index, _that.stars, _that.submitting);
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
            List<PendingRatee> queue, int index, int stars, bool submitting)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RateTripState():
        return $default(
            _that.queue, _that.index, _that.stars, _that.submitting);
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
            List<PendingRatee> queue, int index, int stars, bool submitting)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RateTripState() when $default != null:
        return $default(
            _that.queue, _that.index, _that.stars, _that.submitting);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RateTripState extends RateTripState {
  const _RateTripState(
      {final List<PendingRatee> queue = const <PendingRatee>[],
      this.index = 0,
      this.stars = 0,
      this.submitting = false})
      : _queue = queue,
        super._();

  final List<PendingRatee> _queue;
  @override
  @JsonKey()
  List<PendingRatee> get queue {
    if (_queue is EqualUnmodifiableListView) return _queue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_queue);
  }

  /// The parent being rated.
  @override
  @JsonKey()
  final int index;

  /// 0 = nothing picked yet.
  @override
  @JsonKey()
  final int stars;
  @override
  @JsonKey()
  final bool submitting;

  /// Create a copy of RateTripState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RateTripStateCopyWith<_RateTripState> get copyWith =>
      __$RateTripStateCopyWithImpl<_RateTripState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RateTripState &&
            const DeepCollectionEquality().equals(other._queue, _queue) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.stars, stars) || other.stars == stars) &&
            (identical(other.submitting, submitting) ||
                other.submitting == submitting));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_queue), index, stars, submitting);

  @override
  String toString() {
    return 'RateTripState(queue: $queue, index: $index, stars: $stars, submitting: $submitting)';
  }
}

/// @nodoc
abstract mixin class _$RateTripStateCopyWith<$Res>
    implements $RateTripStateCopyWith<$Res> {
  factory _$RateTripStateCopyWith(
          _RateTripState value, $Res Function(_RateTripState) _then) =
      __$RateTripStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<PendingRatee> queue, int index, int stars, bool submitting});
}

/// @nodoc
class __$RateTripStateCopyWithImpl<$Res>
    implements _$RateTripStateCopyWith<$Res> {
  __$RateTripStateCopyWithImpl(this._self, this._then);

  final _RateTripState _self;
  final $Res Function(_RateTripState) _then;

  /// Create a copy of RateTripState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? queue = null,
    Object? index = null,
    Object? stars = null,
    Object? submitting = null,
  }) {
    return _then(_RateTripState(
      queue: null == queue
          ? _self._queue
          : queue // ignore: cast_nullable_to_non_nullable
              as List<PendingRatee>,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      stars: null == stars
          ? _self.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      submitting: null == submitting
          ? _self.submitting
          : submitting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
