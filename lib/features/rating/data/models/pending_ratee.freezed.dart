// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_ratee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingRatee {
  @JsonKey(fromJson: looseStringOrEmpty)
  String get tripId;

  /// Sent as `rateeUserId` when rating.
  @JsonKey(fromJson: looseStringOrEmpty)
  String get parentId;
  @JsonKey(fromJson: looseString)
  String? get parentName;
  @JsonKey(fromJson: looseString)
  String? get parentImage;

  /// Create a copy of PendingRatee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PendingRateeCopyWith<PendingRatee> get copyWith =>
      _$PendingRateeCopyWithImpl<PendingRatee>(
          this as PendingRatee, _$identity);

  /// Serializes this PendingRatee to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PendingRatee &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.parentName, parentName) ||
                other.parentName == parentName) &&
            (identical(other.parentImage, parentImage) ||
                other.parentImage == parentImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tripId, parentId, parentName, parentImage);

  @override
  String toString() {
    return 'PendingRatee(tripId: $tripId, parentId: $parentId, parentName: $parentName, parentImage: $parentImage)';
  }
}

/// @nodoc
abstract mixin class $PendingRateeCopyWith<$Res> {
  factory $PendingRateeCopyWith(
          PendingRatee value, $Res Function(PendingRatee) _then) =
      _$PendingRateeCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String tripId,
      @JsonKey(fromJson: looseStringOrEmpty) String parentId,
      @JsonKey(fromJson: looseString) String? parentName,
      @JsonKey(fromJson: looseString) String? parentImage});
}

/// @nodoc
class _$PendingRateeCopyWithImpl<$Res> implements $PendingRateeCopyWith<$Res> {
  _$PendingRateeCopyWithImpl(this._self, this._then);

  final PendingRatee _self;
  final $Res Function(PendingRatee) _then;

  /// Create a copy of PendingRatee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? parentId = null,
    Object? parentName = freezed,
    Object? parentImage = freezed,
  }) {
    return _then(_self.copyWith(
      tripId: null == tripId
          ? _self.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: null == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String,
      parentName: freezed == parentName
          ? _self.parentName
          : parentName // ignore: cast_nullable_to_non_nullable
              as String?,
      parentImage: freezed == parentImage
          ? _self.parentImage
          : parentImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PendingRatee].
extension PendingRateePatterns on PendingRatee {
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
    TResult Function(_PendingRatee value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PendingRatee() when $default != null:
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
    TResult Function(_PendingRatee value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingRatee():
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
    TResult? Function(_PendingRatee value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingRatee() when $default != null:
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
            @JsonKey(fromJson: looseStringOrEmpty) String tripId,
            @JsonKey(fromJson: looseStringOrEmpty) String parentId,
            @JsonKey(fromJson: looseString) String? parentName,
            @JsonKey(fromJson: looseString) String? parentImage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PendingRatee() when $default != null:
        return $default(
            _that.tripId, _that.parentId, _that.parentName, _that.parentImage);
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
            @JsonKey(fromJson: looseStringOrEmpty) String tripId,
            @JsonKey(fromJson: looseStringOrEmpty) String parentId,
            @JsonKey(fromJson: looseString) String? parentName,
            @JsonKey(fromJson: looseString) String? parentImage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingRatee():
        return $default(
            _that.tripId, _that.parentId, _that.parentName, _that.parentImage);
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
            @JsonKey(fromJson: looseStringOrEmpty) String tripId,
            @JsonKey(fromJson: looseStringOrEmpty) String parentId,
            @JsonKey(fromJson: looseString) String? parentName,
            @JsonKey(fromJson: looseString) String? parentImage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PendingRatee() when $default != null:
        return $default(
            _that.tripId, _that.parentId, _that.parentName, _that.parentImage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PendingRatee implements PendingRatee {
  const _PendingRatee(
      {@JsonKey(fromJson: looseStringOrEmpty) this.tripId = '',
      @JsonKey(fromJson: looseStringOrEmpty) this.parentId = '',
      @JsonKey(fromJson: looseString) this.parentName,
      @JsonKey(fromJson: looseString) this.parentImage});
  factory _PendingRatee.fromJson(Map<String, dynamic> json) =>
      _$PendingRateeFromJson(json);

  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String tripId;

  /// Sent as `rateeUserId` when rating.
  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String parentId;
  @override
  @JsonKey(fromJson: looseString)
  final String? parentName;
  @override
  @JsonKey(fromJson: looseString)
  final String? parentImage;

  /// Create a copy of PendingRatee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PendingRateeCopyWith<_PendingRatee> get copyWith =>
      __$PendingRateeCopyWithImpl<_PendingRatee>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PendingRateeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PendingRatee &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.parentName, parentName) ||
                other.parentName == parentName) &&
            (identical(other.parentImage, parentImage) ||
                other.parentImage == parentImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tripId, parentId, parentName, parentImage);

  @override
  String toString() {
    return 'PendingRatee(tripId: $tripId, parentId: $parentId, parentName: $parentName, parentImage: $parentImage)';
  }
}

/// @nodoc
abstract mixin class _$PendingRateeCopyWith<$Res>
    implements $PendingRateeCopyWith<$Res> {
  factory _$PendingRateeCopyWith(
          _PendingRatee value, $Res Function(_PendingRatee) _then) =
      __$PendingRateeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String tripId,
      @JsonKey(fromJson: looseStringOrEmpty) String parentId,
      @JsonKey(fromJson: looseString) String? parentName,
      @JsonKey(fromJson: looseString) String? parentImage});
}

/// @nodoc
class __$PendingRateeCopyWithImpl<$Res>
    implements _$PendingRateeCopyWith<$Res> {
  __$PendingRateeCopyWithImpl(this._self, this._then);

  final _PendingRatee _self;
  final $Res Function(_PendingRatee) _then;

  /// Create a copy of PendingRatee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tripId = null,
    Object? parentId = null,
    Object? parentName = freezed,
    Object? parentImage = freezed,
  }) {
    return _then(_PendingRatee(
      tripId: null == tripId
          ? _self.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: null == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String,
      parentName: freezed == parentName
          ? _self.parentName
          : parentName // ignore: cast_nullable_to_non_nullable
              as String?,
      parentImage: freezed == parentImage
          ? _self.parentImage
          : parentImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
