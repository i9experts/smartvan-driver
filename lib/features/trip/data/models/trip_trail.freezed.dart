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
mixin _$TripTrail {
  @JsonKey(fromJson: looseString)
  String? get polyline;

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
                other.polyline == polyline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, polyline);

  @override
  String toString() {
    return 'TripTrail(polyline: $polyline)';
  }
}

/// @nodoc
abstract mixin class $TripTrailCopyWith<$Res> {
  factory $TripTrailCopyWith(TripTrail value, $Res Function(TripTrail) _then) =
      _$TripTrailCopyWithImpl;
  @useResult
  $Res call({@JsonKey(fromJson: looseString) String? polyline});
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
  }) {
    return _then(_self.copyWith(
      polyline: freezed == polyline
          ? _self.polyline
          : polyline // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
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
    TResult Function(@JsonKey(fromJson: looseString) String? polyline)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripTrail() when $default != null:
        return $default(_that.polyline);
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
    TResult Function(@JsonKey(fromJson: looseString) String? polyline) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrail():
        return $default(_that.polyline);
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
    TResult? Function(@JsonKey(fromJson: looseString) String? polyline)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripTrail() when $default != null:
        return $default(_that.polyline);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TripTrail implements TripTrail {
  const _TripTrail({@JsonKey(fromJson: looseString) this.polyline});
  factory _TripTrail.fromJson(Map<String, dynamic> json) =>
      _$TripTrailFromJson(json);

  @override
  @JsonKey(fromJson: looseString)
  final String? polyline;

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
                other.polyline == polyline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, polyline);

  @override
  String toString() {
    return 'TripTrail(polyline: $polyline)';
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
  $Res call({@JsonKey(fromJson: looseString) String? polyline});
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
  }) {
    return _then(_TripTrail(
      polyline: freezed == polyline
          ? _self.polyline
          : polyline // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
