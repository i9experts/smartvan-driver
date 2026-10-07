// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_passenger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoutePassenger {
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  String get kidId;
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  String get fullname;
  @JsonKey(readValue: readImage, fromJson: looseString)
  String? get image;
  @JsonKey(fromJson: looseString)
  String? get grade;

  /// Create a copy of RoutePassenger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoutePassengerCopyWith<RoutePassenger> get copyWith =>
      _$RoutePassengerCopyWithImpl<RoutePassenger>(
          this as RoutePassenger, _$identity);

  /// Serializes this RoutePassenger to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoutePassenger &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.grade, grade) || other.grade == grade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, fullname, image, grade);

  @override
  String toString() {
    return 'RoutePassenger(kidId: $kidId, fullname: $fullname, image: $image, grade: $grade)';
  }
}

/// @nodoc
abstract mixin class $RoutePassengerCopyWith<$Res> {
  factory $RoutePassengerCopyWith(
          RoutePassenger value, $Res Function(RoutePassenger) _then) =
      _$RoutePassengerCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      String kidId,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(readValue: readImage, fromJson: looseString) String? image,
      @JsonKey(fromJson: looseString) String? grade});
}

/// @nodoc
class _$RoutePassengerCopyWithImpl<$Res>
    implements $RoutePassengerCopyWith<$Res> {
  _$RoutePassengerCopyWithImpl(this._self, this._then);

  final RoutePassenger _self;
  final $Res Function(RoutePassenger) _then;

  /// Create a copy of RoutePassenger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kidId = null,
    Object? fullname = null,
    Object? image = freezed,
    Object? grade = freezed,
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
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RoutePassenger].
extension RoutePassengerPatterns on RoutePassenger {
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
    TResult Function(_RoutePassenger value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RoutePassenger() when $default != null:
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
    TResult Function(_RoutePassenger value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePassenger():
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
    TResult? Function(_RoutePassenger value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePassenger() when $default != null:
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
            String fullname,
            @JsonKey(readValue: readImage, fromJson: looseString) String? image,
            @JsonKey(fromJson: looseString) String? grade)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RoutePassenger() when $default != null:
        return $default(_that.kidId, _that.fullname, _that.image, _that.grade);
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
            String fullname,
            @JsonKey(readValue: readImage, fromJson: looseString) String? image,
            @JsonKey(fromJson: looseString) String? grade)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePassenger():
        return $default(_that.kidId, _that.fullname, _that.image, _that.grade);
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
            String fullname,
            @JsonKey(readValue: readImage, fromJson: looseString) String? image,
            @JsonKey(fromJson: looseString) String? grade)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePassenger() when $default != null:
        return $default(_that.kidId, _that.fullname, _that.image, _that.grade);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RoutePassenger implements RoutePassenger {
  const _RoutePassenger(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      this.kidId = '',
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      this.fullname = '',
      @JsonKey(readValue: readImage, fromJson: looseString) this.image,
      @JsonKey(fromJson: looseString) this.grade});
  factory _RoutePassenger.fromJson(Map<String, dynamic> json) =>
      _$RoutePassengerFromJson(json);

  @override
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  final String kidId;
  @override
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  final String fullname;
  @override
  @JsonKey(readValue: readImage, fromJson: looseString)
  final String? image;
  @override
  @JsonKey(fromJson: looseString)
  final String? grade;

  /// Create a copy of RoutePassenger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoutePassengerCopyWith<_RoutePassenger> get copyWith =>
      __$RoutePassengerCopyWithImpl<_RoutePassenger>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RoutePassengerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoutePassenger &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.grade, grade) || other.grade == grade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, fullname, image, grade);

  @override
  String toString() {
    return 'RoutePassenger(kidId: $kidId, fullname: $fullname, image: $image, grade: $grade)';
  }
}

/// @nodoc
abstract mixin class _$RoutePassengerCopyWith<$Res>
    implements $RoutePassengerCopyWith<$Res> {
  factory _$RoutePassengerCopyWith(
          _RoutePassenger value, $Res Function(_RoutePassenger) _then) =
      __$RoutePassengerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      String kidId,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(readValue: readImage, fromJson: looseString) String? image,
      @JsonKey(fromJson: looseString) String? grade});
}

/// @nodoc
class __$RoutePassengerCopyWithImpl<$Res>
    implements _$RoutePassengerCopyWith<$Res> {
  __$RoutePassengerCopyWithImpl(this._self, this._then);

  final _RoutePassenger _self;
  final $Res Function(_RoutePassenger) _then;

  /// Create a copy of RoutePassenger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kidId = null,
    Object? fullname = null,
    Object? image = freezed,
    Object? grade = freezed,
  }) {
    return _then(_RoutePassenger(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
