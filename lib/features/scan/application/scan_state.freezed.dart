// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanState {
  /// A scan request is in flight.
  bool get busy;

  /// Shown for a few seconds, then cleared.
  ScanOutcome? get outcome;

  /// Kids picked up / dropped during this visit to the screen.
  List<ScanResult> get session;

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScanStateCopyWith<ScanState> get copyWith =>
      _$ScanStateCopyWithImpl<ScanState>(this as ScanState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScanState &&
            (identical(other.busy, busy) || other.busy == busy) &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            const DeepCollectionEquality().equals(other.session, session));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, busy, outcome, const DeepCollectionEquality().hash(session));

  @override
  String toString() {
    return 'ScanState(busy: $busy, outcome: $outcome, session: $session)';
  }
}

/// @nodoc
abstract mixin class $ScanStateCopyWith<$Res> {
  factory $ScanStateCopyWith(ScanState value, $Res Function(ScanState) _then) =
      _$ScanStateCopyWithImpl;
  @useResult
  $Res call({bool busy, ScanOutcome? outcome, List<ScanResult> session});
}

/// @nodoc
class _$ScanStateCopyWithImpl<$Res> implements $ScanStateCopyWith<$Res> {
  _$ScanStateCopyWithImpl(this._self, this._then);

  final ScanState _self;
  final $Res Function(ScanState) _then;

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? busy = null,
    Object? outcome = freezed,
    Object? session = null,
  }) {
    return _then(_self.copyWith(
      busy: null == busy
          ? _self.busy
          : busy // ignore: cast_nullable_to_non_nullable
              as bool,
      outcome: freezed == outcome
          ? _self.outcome
          : outcome // ignore: cast_nullable_to_non_nullable
              as ScanOutcome?,
      session: null == session
          ? _self.session
          : session // ignore: cast_nullable_to_non_nullable
              as List<ScanResult>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ScanState].
extension ScanStatePatterns on ScanState {
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
    TResult Function(_ScanState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScanState() when $default != null:
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
    TResult Function(_ScanState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScanState():
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
    TResult? Function(_ScanState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScanState() when $default != null:
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
    TResult Function(bool busy, ScanOutcome? outcome, List<ScanResult> session)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScanState() when $default != null:
        return $default(_that.busy, _that.outcome, _that.session);
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
    TResult Function(bool busy, ScanOutcome? outcome, List<ScanResult> session)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScanState():
        return $default(_that.busy, _that.outcome, _that.session);
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
            bool busy, ScanOutcome? outcome, List<ScanResult> session)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScanState() when $default != null:
        return $default(_that.busy, _that.outcome, _that.session);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ScanState implements ScanState {
  const _ScanState(
      {this.busy = false,
      this.outcome,
      final List<ScanResult> session = const <ScanResult>[]})
      : _session = session;

  /// A scan request is in flight.
  @override
  @JsonKey()
  final bool busy;

  /// Shown for a few seconds, then cleared.
  @override
  final ScanOutcome? outcome;

  /// Kids picked up / dropped during this visit to the screen.
  final List<ScanResult> _session;

  /// Kids picked up / dropped during this visit to the screen.
  @override
  @JsonKey()
  List<ScanResult> get session {
    if (_session is EqualUnmodifiableListView) return _session;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_session);
  }

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScanStateCopyWith<_ScanState> get copyWith =>
      __$ScanStateCopyWithImpl<_ScanState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScanState &&
            (identical(other.busy, busy) || other.busy == busy) &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            const DeepCollectionEquality().equals(other._session, _session));
  }

  @override
  int get hashCode => Object.hash(runtimeType, busy, outcome,
      const DeepCollectionEquality().hash(_session));

  @override
  String toString() {
    return 'ScanState(busy: $busy, outcome: $outcome, session: $session)';
  }
}

/// @nodoc
abstract mixin class _$ScanStateCopyWith<$Res>
    implements $ScanStateCopyWith<$Res> {
  factory _$ScanStateCopyWith(
          _ScanState value, $Res Function(_ScanState) _then) =
      __$ScanStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool busy, ScanOutcome? outcome, List<ScanResult> session});
}

/// @nodoc
class __$ScanStateCopyWithImpl<$Res> implements _$ScanStateCopyWith<$Res> {
  __$ScanStateCopyWithImpl(this._self, this._then);

  final _ScanState _self;
  final $Res Function(_ScanState) _then;

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? busy = null,
    Object? outcome = freezed,
    Object? session = null,
  }) {
    return _then(_ScanState(
      busy: null == busy
          ? _self.busy
          : busy // ignore: cast_nullable_to_non_nullable
              as bool,
      outcome: freezed == outcome
          ? _self.outcome
          : outcome // ignore: cast_nullable_to_non_nullable
              as ScanOutcome?,
      session: null == session
          ? _self._session
          : session // ignore: cast_nullable_to_non_nullable
              as List<ScanResult>,
    ));
  }
}

// dart format on
