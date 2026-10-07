// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kid_not_dropped.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KidNotDropped {
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  String get kidId;
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  String get fullname;

  /// Create a copy of KidNotDropped
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KidNotDroppedCopyWith<KidNotDropped> get copyWith =>
      _$KidNotDroppedCopyWithImpl<KidNotDropped>(
          this as KidNotDropped, _$identity);

  /// Serializes this KidNotDropped to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KidNotDropped &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, fullname);

  @override
  String toString() {
    return 'KidNotDropped(kidId: $kidId, fullname: $fullname)';
  }
}

/// @nodoc
abstract mixin class $KidNotDroppedCopyWith<$Res> {
  factory $KidNotDroppedCopyWith(
          KidNotDropped value, $Res Function(KidNotDropped) _then) =
      _$KidNotDroppedCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      String kidId,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname});
}

/// @nodoc
class _$KidNotDroppedCopyWithImpl<$Res>
    implements $KidNotDroppedCopyWith<$Res> {
  _$KidNotDroppedCopyWithImpl(this._self, this._then);

  final KidNotDropped _self;
  final $Res Function(KidNotDropped) _then;

  /// Create a copy of KidNotDropped
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kidId = null,
    Object? fullname = null,
  }) {
    return _then(_self.copyWith(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [KidNotDropped].
extension KidNotDroppedPatterns on KidNotDropped {
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
    TResult Function(_KidNotDropped value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KidNotDropped() when $default != null:
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
    TResult Function(_KidNotDropped value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KidNotDropped():
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
    TResult? Function(_KidNotDropped value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KidNotDropped() when $default != null:
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
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KidNotDropped() when $default != null:
        return $default(_that.kidId, _that.fullname);
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
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KidNotDropped():
        return $default(_that.kidId, _that.fullname);
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
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KidNotDropped() when $default != null:
        return $default(_that.kidId, _that.fullname);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _KidNotDropped implements KidNotDropped {
  const _KidNotDropped(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      this.kidId = '',
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      this.fullname = ''});
  factory _KidNotDropped.fromJson(Map<String, dynamic> json) =>
      _$KidNotDroppedFromJson(json);

  @override
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  final String kidId;
  @override
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  final String fullname;

  /// Create a copy of KidNotDropped
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KidNotDroppedCopyWith<_KidNotDropped> get copyWith =>
      __$KidNotDroppedCopyWithImpl<_KidNotDropped>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KidNotDroppedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KidNotDropped &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, fullname);

  @override
  String toString() {
    return 'KidNotDropped(kidId: $kidId, fullname: $fullname)';
  }
}

/// @nodoc
abstract mixin class _$KidNotDroppedCopyWith<$Res>
    implements $KidNotDroppedCopyWith<$Res> {
  factory _$KidNotDroppedCopyWith(
          _KidNotDropped value, $Res Function(_KidNotDropped) _then) =
      __$KidNotDroppedCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      String kidId,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname});
}

/// @nodoc
class __$KidNotDroppedCopyWithImpl<$Res>
    implements _$KidNotDroppedCopyWith<$Res> {
  __$KidNotDroppedCopyWithImpl(this._self, this._then);

  final _KidNotDropped _self;
  final $Res Function(_KidNotDropped) _then;

  /// Create a copy of KidNotDropped
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kidId = null,
    Object? fullname = null,
  }) {
    return _then(_KidNotDropped(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
