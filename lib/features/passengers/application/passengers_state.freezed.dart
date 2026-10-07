// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passengers_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PassengersState {
  /// Riders first; absent and no-show kids at the bottom.
  List<Passenger> get passengers;

  /// Pick/drop saved on the phone but not yet on the server (kidId → state).
  Map<String, KidTripStatus> get pending;

  /// Kids with a pick/drop in flight.
  Set<String> get busy;

  /// Kids with an "at stop" / "no-show" call in flight.
  Set<String> get stopBusy;

  /// The last reload failed; the earlier list is still shown.
  bool get loadFailed;

  /// Create a copy of PassengersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PassengersStateCopyWith<PassengersState> get copyWith =>
      _$PassengersStateCopyWithImpl<PassengersState>(
          this as PassengersState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PassengersState &&
            const DeepCollectionEquality()
                .equals(other.passengers, passengers) &&
            const DeepCollectionEquality().equals(other.pending, pending) &&
            const DeepCollectionEquality().equals(other.busy, busy) &&
            const DeepCollectionEquality().equals(other.stopBusy, stopBusy) &&
            (identical(other.loadFailed, loadFailed) ||
                other.loadFailed == loadFailed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(passengers),
      const DeepCollectionEquality().hash(pending),
      const DeepCollectionEquality().hash(busy),
      const DeepCollectionEquality().hash(stopBusy),
      loadFailed);

  @override
  String toString() {
    return 'PassengersState(passengers: $passengers, pending: $pending, busy: $busy, stopBusy: $stopBusy, loadFailed: $loadFailed)';
  }
}

/// @nodoc
abstract mixin class $PassengersStateCopyWith<$Res> {
  factory $PassengersStateCopyWith(
          PassengersState value, $Res Function(PassengersState) _then) =
      _$PassengersStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Passenger> passengers,
      Map<String, KidTripStatus> pending,
      Set<String> busy,
      Set<String> stopBusy,
      bool loadFailed});
}

/// @nodoc
class _$PassengersStateCopyWithImpl<$Res>
    implements $PassengersStateCopyWith<$Res> {
  _$PassengersStateCopyWithImpl(this._self, this._then);

  final PassengersState _self;
  final $Res Function(PassengersState) _then;

  /// Create a copy of PassengersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? passengers = null,
    Object? pending = null,
    Object? busy = null,
    Object? stopBusy = null,
    Object? loadFailed = null,
  }) {
    return _then(_self.copyWith(
      passengers: null == passengers
          ? _self.passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<Passenger>,
      pending: null == pending
          ? _self.pending
          : pending // ignore: cast_nullable_to_non_nullable
              as Map<String, KidTripStatus>,
      busy: null == busy
          ? _self.busy
          : busy // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      stopBusy: null == stopBusy
          ? _self.stopBusy
          : stopBusy // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      loadFailed: null == loadFailed
          ? _self.loadFailed
          : loadFailed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [PassengersState].
extension PassengersStatePatterns on PassengersState {
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
    TResult Function(_PassengersState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PassengersState() when $default != null:
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
    TResult Function(_PassengersState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PassengersState():
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
    TResult? Function(_PassengersState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PassengersState() when $default != null:
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
            List<Passenger> passengers,
            Map<String, KidTripStatus> pending,
            Set<String> busy,
            Set<String> stopBusy,
            bool loadFailed)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PassengersState() when $default != null:
        return $default(_that.passengers, _that.pending, _that.busy,
            _that.stopBusy, _that.loadFailed);
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
            List<Passenger> passengers,
            Map<String, KidTripStatus> pending,
            Set<String> busy,
            Set<String> stopBusy,
            bool loadFailed)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PassengersState():
        return $default(_that.passengers, _that.pending, _that.busy,
            _that.stopBusy, _that.loadFailed);
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
            List<Passenger> passengers,
            Map<String, KidTripStatus> pending,
            Set<String> busy,
            Set<String> stopBusy,
            bool loadFailed)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PassengersState() when $default != null:
        return $default(_that.passengers, _that.pending, _that.busy,
            _that.stopBusy, _that.loadFailed);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PassengersState extends PassengersState {
  const _PassengersState(
      {final List<Passenger> passengers = const <Passenger>[],
      final Map<String, KidTripStatus> pending =
          const <String, KidTripStatus>{},
      final Set<String> busy = const <String>{},
      final Set<String> stopBusy = const <String>{},
      this.loadFailed = false})
      : _passengers = passengers,
        _pending = pending,
        _busy = busy,
        _stopBusy = stopBusy,
        super._();

  /// Riders first; absent and no-show kids at the bottom.
  final List<Passenger> _passengers;

  /// Riders first; absent and no-show kids at the bottom.
  @override
  @JsonKey()
  List<Passenger> get passengers {
    if (_passengers is EqualUnmodifiableListView) return _passengers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passengers);
  }

  /// Pick/drop saved on the phone but not yet on the server (kidId → state).
  final Map<String, KidTripStatus> _pending;

  /// Pick/drop saved on the phone but not yet on the server (kidId → state).
  @override
  @JsonKey()
  Map<String, KidTripStatus> get pending {
    if (_pending is EqualUnmodifiableMapView) return _pending;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pending);
  }

  /// Kids with a pick/drop in flight.
  final Set<String> _busy;

  /// Kids with a pick/drop in flight.
  @override
  @JsonKey()
  Set<String> get busy {
    if (_busy is EqualUnmodifiableSetView) return _busy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_busy);
  }

  /// Kids with an "at stop" / "no-show" call in flight.
  final Set<String> _stopBusy;

  /// Kids with an "at stop" / "no-show" call in flight.
  @override
  @JsonKey()
  Set<String> get stopBusy {
    if (_stopBusy is EqualUnmodifiableSetView) return _stopBusy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_stopBusy);
  }

  /// The last reload failed; the earlier list is still shown.
  @override
  @JsonKey()
  final bool loadFailed;

  /// Create a copy of PassengersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PassengersStateCopyWith<_PassengersState> get copyWith =>
      __$PassengersStateCopyWithImpl<_PassengersState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengersState &&
            const DeepCollectionEquality()
                .equals(other._passengers, _passengers) &&
            const DeepCollectionEquality().equals(other._pending, _pending) &&
            const DeepCollectionEquality().equals(other._busy, _busy) &&
            const DeepCollectionEquality().equals(other._stopBusy, _stopBusy) &&
            (identical(other.loadFailed, loadFailed) ||
                other.loadFailed == loadFailed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_passengers),
      const DeepCollectionEquality().hash(_pending),
      const DeepCollectionEquality().hash(_busy),
      const DeepCollectionEquality().hash(_stopBusy),
      loadFailed);

  @override
  String toString() {
    return 'PassengersState(passengers: $passengers, pending: $pending, busy: $busy, stopBusy: $stopBusy, loadFailed: $loadFailed)';
  }
}

/// @nodoc
abstract mixin class _$PassengersStateCopyWith<$Res>
    implements $PassengersStateCopyWith<$Res> {
  factory _$PassengersStateCopyWith(
          _PassengersState value, $Res Function(_PassengersState) _then) =
      __$PassengersStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Passenger> passengers,
      Map<String, KidTripStatus> pending,
      Set<String> busy,
      Set<String> stopBusy,
      bool loadFailed});
}

/// @nodoc
class __$PassengersStateCopyWithImpl<$Res>
    implements _$PassengersStateCopyWith<$Res> {
  __$PassengersStateCopyWithImpl(this._self, this._then);

  final _PassengersState _self;
  final $Res Function(_PassengersState) _then;

  /// Create a copy of PassengersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? passengers = null,
    Object? pending = null,
    Object? busy = null,
    Object? stopBusy = null,
    Object? loadFailed = null,
  }) {
    return _then(_PassengersState(
      passengers: null == passengers
          ? _self._passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<Passenger>,
      pending: null == pending
          ? _self._pending
          : pending // ignore: cast_nullable_to_non_nullable
              as Map<String, KidTripStatus>,
      busy: null == busy
          ? _self._busy
          : busy // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      stopBusy: null == stopBusy
          ? _self._stopBusy
          : stopBusy // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      loadFailed: null == loadFailed
          ? _self.loadFailed
          : loadFailed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
