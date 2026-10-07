// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arrived_at_stop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArrivedAtStop {
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  String get kidId;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get waitingSince;

  /// Create a copy of ArrivedAtStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ArrivedAtStopCopyWith<ArrivedAtStop> get copyWith =>
      _$ArrivedAtStopCopyWithImpl<ArrivedAtStop>(
          this as ArrivedAtStop, _$identity);

  /// Serializes this ArrivedAtStop to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ArrivedAtStop &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.waitingSince, waitingSince) ||
                other.waitingSince == waitingSince));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, waitingSince);

  @override
  String toString() {
    return 'ArrivedAtStop(kidId: $kidId, waitingSince: $waitingSince)';
  }
}

/// @nodoc
abstract mixin class $ArrivedAtStopCopyWith<$Res> {
  factory $ArrivedAtStopCopyWith(
          ArrivedAtStop value, $Res Function(ArrivedAtStop) _then) =
      _$ArrivedAtStopCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      String kidId,
      @JsonKey(fromJson: looseDateTime) DateTime? waitingSince});
}

/// @nodoc
class _$ArrivedAtStopCopyWithImpl<$Res>
    implements $ArrivedAtStopCopyWith<$Res> {
  _$ArrivedAtStopCopyWithImpl(this._self, this._then);

  final ArrivedAtStop _self;
  final $Res Function(ArrivedAtStop) _then;

  /// Create a copy of ArrivedAtStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kidId = null,
    Object? waitingSince = freezed,
  }) {
    return _then(_self.copyWith(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      waitingSince: freezed == waitingSince
          ? _self.waitingSince
          : waitingSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ArrivedAtStop].
extension ArrivedAtStopPatterns on ArrivedAtStop {
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
    TResult Function(_ArrivedAtStop value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ArrivedAtStop() when $default != null:
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
    TResult Function(_ArrivedAtStop value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ArrivedAtStop():
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
    TResult? Function(_ArrivedAtStop value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ArrivedAtStop() when $default != null:
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
            @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
            String kidId,
            @JsonKey(fromJson: looseDateTime) DateTime? waitingSince)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ArrivedAtStop() when $default != null:
        return $default(_that.kidId, _that.waitingSince);
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
            @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
            String kidId,
            @JsonKey(fromJson: looseDateTime) DateTime? waitingSince)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ArrivedAtStop():
        return $default(_that.kidId, _that.waitingSince);
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
            @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
            String kidId,
            @JsonKey(fromJson: looseDateTime) DateTime? waitingSince)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ArrivedAtStop() when $default != null:
        return $default(_that.kidId, _that.waitingSince);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ArrivedAtStop implements ArrivedAtStop {
  const _ArrivedAtStop(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      this.kidId = '',
      @JsonKey(fromJson: looseDateTime) this.waitingSince});
  factory _ArrivedAtStop.fromJson(Map<String, dynamic> json) =>
      _$ArrivedAtStopFromJson(json);

  @override
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  final String kidId;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? waitingSince;

  /// Create a copy of ArrivedAtStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ArrivedAtStopCopyWith<_ArrivedAtStop> get copyWith =>
      __$ArrivedAtStopCopyWithImpl<_ArrivedAtStop>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ArrivedAtStopToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ArrivedAtStop &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.waitingSince, waitingSince) ||
                other.waitingSince == waitingSince));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, waitingSince);

  @override
  String toString() {
    return 'ArrivedAtStop(kidId: $kidId, waitingSince: $waitingSince)';
  }
}

/// @nodoc
abstract mixin class _$ArrivedAtStopCopyWith<$Res>
    implements $ArrivedAtStopCopyWith<$Res> {
  factory _$ArrivedAtStopCopyWith(
          _ArrivedAtStop value, $Res Function(_ArrivedAtStop) _then) =
      __$ArrivedAtStopCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      String kidId,
      @JsonKey(fromJson: looseDateTime) DateTime? waitingSince});
}

/// @nodoc
class __$ArrivedAtStopCopyWithImpl<$Res>
    implements _$ArrivedAtStopCopyWith<$Res> {
  __$ArrivedAtStopCopyWithImpl(this._self, this._then);

  final _ArrivedAtStop _self;
  final $Res Function(_ArrivedAtStop) _then;

  /// Create a copy of ArrivedAtStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kidId = null,
    Object? waitingSince = freezed,
  }) {
    return _then(_ArrivedAtStop(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      waitingSince: freezed == waitingSince
          ? _self.waitingSince
          : waitingSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
