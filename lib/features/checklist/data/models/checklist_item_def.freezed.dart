// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_item_def.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChecklistItemDef {
  @JsonKey(fromJson: looseStringOrEmpty)
  String get key;
  @JsonKey(fromJson: looseStringOrEmpty)
  String get label;

  /// Create a copy of ChecklistItemDef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChecklistItemDefCopyWith<ChecklistItemDef> get copyWith =>
      _$ChecklistItemDefCopyWithImpl<ChecklistItemDef>(
          this as ChecklistItemDef, _$identity);

  /// Serializes this ChecklistItemDef to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChecklistItemDef &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, label);

  @override
  String toString() {
    return 'ChecklistItemDef(key: $key, label: $label)';
  }
}

/// @nodoc
abstract mixin class $ChecklistItemDefCopyWith<$Res> {
  factory $ChecklistItemDefCopyWith(
          ChecklistItemDef value, $Res Function(ChecklistItemDef) _then) =
      _$ChecklistItemDefCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String key,
      @JsonKey(fromJson: looseStringOrEmpty) String label});
}

/// @nodoc
class _$ChecklistItemDefCopyWithImpl<$Res>
    implements $ChecklistItemDefCopyWith<$Res> {
  _$ChecklistItemDefCopyWithImpl(this._self, this._then);

  final ChecklistItemDef _self;
  final $Res Function(ChecklistItemDef) _then;

  /// Create a copy of ChecklistItemDef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
  }) {
    return _then(_self.copyWith(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChecklistItemDef].
extension ChecklistItemDefPatterns on ChecklistItemDef {
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
    TResult Function(_ChecklistItemDef value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChecklistItemDef() when $default != null:
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
    TResult Function(_ChecklistItemDef value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistItemDef():
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
    TResult? Function(_ChecklistItemDef value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistItemDef() when $default != null:
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
    TResult Function(@JsonKey(fromJson: looseStringOrEmpty) String key,
            @JsonKey(fromJson: looseStringOrEmpty) String label)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChecklistItemDef() when $default != null:
        return $default(_that.key, _that.label);
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
    TResult Function(@JsonKey(fromJson: looseStringOrEmpty) String key,
            @JsonKey(fromJson: looseStringOrEmpty) String label)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistItemDef():
        return $default(_that.key, _that.label);
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
    TResult? Function(@JsonKey(fromJson: looseStringOrEmpty) String key,
            @JsonKey(fromJson: looseStringOrEmpty) String label)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistItemDef() when $default != null:
        return $default(_that.key, _that.label);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChecklistItemDef implements ChecklistItemDef {
  const _ChecklistItemDef(
      {@JsonKey(fromJson: looseStringOrEmpty) this.key = '',
      @JsonKey(fromJson: looseStringOrEmpty) this.label = ''});
  factory _ChecklistItemDef.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemDefFromJson(json);

  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String key;
  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String label;

  /// Create a copy of ChecklistItemDef
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChecklistItemDefCopyWith<_ChecklistItemDef> get copyWith =>
      __$ChecklistItemDefCopyWithImpl<_ChecklistItemDef>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChecklistItemDefToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChecklistItemDef &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, label);

  @override
  String toString() {
    return 'ChecklistItemDef(key: $key, label: $label)';
  }
}

/// @nodoc
abstract mixin class _$ChecklistItemDefCopyWith<$Res>
    implements $ChecklistItemDefCopyWith<$Res> {
  factory _$ChecklistItemDefCopyWith(
          _ChecklistItemDef value, $Res Function(_ChecklistItemDef) _then) =
      __$ChecklistItemDefCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String key,
      @JsonKey(fromJson: looseStringOrEmpty) String label});
}

/// @nodoc
class __$ChecklistItemDefCopyWithImpl<$Res>
    implements _$ChecklistItemDefCopyWith<$Res> {
  __$ChecklistItemDefCopyWithImpl(this._self, this._then);

  final _ChecklistItemDef _self;
  final $Res Function(_ChecklistItemDef) _then;

  /// Create a copy of ChecklistItemDef
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? key = null,
    Object? label = null,
  }) {
    return _then(_ChecklistItemDef(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
