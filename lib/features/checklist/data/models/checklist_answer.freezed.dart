// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChecklistAnswer {
  @JsonKey(fromJson: looseStringOrEmpty)
  String get key;
  @JsonKey(fromJson: looseBool)
  bool get ok;

  /// Only sent when the answer is "not ok".
  @JsonKey(includeIfNull: false, fromJson: looseString)
  String? get note;

  /// Create a copy of ChecklistAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChecklistAnswerCopyWith<ChecklistAnswer> get copyWith =>
      _$ChecklistAnswerCopyWithImpl<ChecklistAnswer>(
          this as ChecklistAnswer, _$identity);

  /// Serializes this ChecklistAnswer to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChecklistAnswer &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.ok, ok) || other.ok == ok) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, ok, note);

  @override
  String toString() {
    return 'ChecklistAnswer(key: $key, ok: $ok, note: $note)';
  }
}

/// @nodoc
abstract mixin class $ChecklistAnswerCopyWith<$Res> {
  factory $ChecklistAnswerCopyWith(
          ChecklistAnswer value, $Res Function(ChecklistAnswer) _then) =
      _$ChecklistAnswerCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String key,
      @JsonKey(fromJson: looseBool) bool ok,
      @JsonKey(includeIfNull: false, fromJson: looseString) String? note});
}

/// @nodoc
class _$ChecklistAnswerCopyWithImpl<$Res>
    implements $ChecklistAnswerCopyWith<$Res> {
  _$ChecklistAnswerCopyWithImpl(this._self, this._then);

  final ChecklistAnswer _self;
  final $Res Function(ChecklistAnswer) _then;

  /// Create a copy of ChecklistAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? ok = null,
    Object? note = freezed,
  }) {
    return _then(_self.copyWith(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      ok: null == ok
          ? _self.ok
          : ok // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChecklistAnswer].
extension ChecklistAnswerPatterns on ChecklistAnswer {
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
    TResult Function(_ChecklistAnswer value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChecklistAnswer() when $default != null:
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
    TResult Function(_ChecklistAnswer value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistAnswer():
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
    TResult? Function(_ChecklistAnswer value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistAnswer() when $default != null:
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
            @JsonKey(fromJson: looseStringOrEmpty) String key,
            @JsonKey(fromJson: looseBool) bool ok,
            @JsonKey(includeIfNull: false, fromJson: looseString) String? note)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChecklistAnswer() when $default != null:
        return $default(_that.key, _that.ok, _that.note);
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
            @JsonKey(fromJson: looseStringOrEmpty) String key,
            @JsonKey(fromJson: looseBool) bool ok,
            @JsonKey(includeIfNull: false, fromJson: looseString) String? note)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistAnswer():
        return $default(_that.key, _that.ok, _that.note);
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
            @JsonKey(fromJson: looseStringOrEmpty) String key,
            @JsonKey(fromJson: looseBool) bool ok,
            @JsonKey(includeIfNull: false, fromJson: looseString) String? note)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistAnswer() when $default != null:
        return $default(_that.key, _that.ok, _that.note);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChecklistAnswer implements ChecklistAnswer {
  const _ChecklistAnswer(
      {@JsonKey(fromJson: looseStringOrEmpty) this.key = '',
      @JsonKey(fromJson: looseBool) this.ok = false,
      @JsonKey(includeIfNull: false, fromJson: looseString) this.note});
  factory _ChecklistAnswer.fromJson(Map<String, dynamic> json) =>
      _$ChecklistAnswerFromJson(json);

  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String key;
  @override
  @JsonKey(fromJson: looseBool)
  final bool ok;

  /// Only sent when the answer is "not ok".
  @override
  @JsonKey(includeIfNull: false, fromJson: looseString)
  final String? note;

  /// Create a copy of ChecklistAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChecklistAnswerCopyWith<_ChecklistAnswer> get copyWith =>
      __$ChecklistAnswerCopyWithImpl<_ChecklistAnswer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChecklistAnswerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChecklistAnswer &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.ok, ok) || other.ok == ok) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, ok, note);

  @override
  String toString() {
    return 'ChecklistAnswer(key: $key, ok: $ok, note: $note)';
  }
}

/// @nodoc
abstract mixin class _$ChecklistAnswerCopyWith<$Res>
    implements $ChecklistAnswerCopyWith<$Res> {
  factory _$ChecklistAnswerCopyWith(
          _ChecklistAnswer value, $Res Function(_ChecklistAnswer) _then) =
      __$ChecklistAnswerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String key,
      @JsonKey(fromJson: looseBool) bool ok,
      @JsonKey(includeIfNull: false, fromJson: looseString) String? note});
}

/// @nodoc
class __$ChecklistAnswerCopyWithImpl<$Res>
    implements _$ChecklistAnswerCopyWith<$Res> {
  __$ChecklistAnswerCopyWithImpl(this._self, this._then);

  final _ChecklistAnswer _self;
  final $Res Function(_ChecklistAnswer) _then;

  /// Create a copy of ChecklistAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? key = null,
    Object? ok = null,
    Object? note = freezed,
  }) {
    return _then(_ChecklistAnswer(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      ok: null == ok
          ? _self.ok
          : ok // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
