// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChecklistRecord {
  /// null when the backend did not say; treated as "all ok".
  @JsonKey(fromJson: _nullableBool)
  bool? get allOk;
  List<ChecklistAnswer> get items;
  @JsonKey(fromJson: looseString)
  String? get photoUrl;

  /// Create a copy of ChecklistRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChecklistRecordCopyWith<ChecklistRecord> get copyWith =>
      _$ChecklistRecordCopyWithImpl<ChecklistRecord>(
          this as ChecklistRecord, _$identity);

  /// Serializes this ChecklistRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChecklistRecord &&
            (identical(other.allOk, allOk) || other.allOk == allOk) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, allOk, const DeepCollectionEquality().hash(items), photoUrl);

  @override
  String toString() {
    return 'ChecklistRecord(allOk: $allOk, items: $items, photoUrl: $photoUrl)';
  }
}

/// @nodoc
abstract mixin class $ChecklistRecordCopyWith<$Res> {
  factory $ChecklistRecordCopyWith(
          ChecklistRecord value, $Res Function(ChecklistRecord) _then) =
      _$ChecklistRecordCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _nullableBool) bool? allOk,
      List<ChecklistAnswer> items,
      @JsonKey(fromJson: looseString) String? photoUrl});
}

/// @nodoc
class _$ChecklistRecordCopyWithImpl<$Res>
    implements $ChecklistRecordCopyWith<$Res> {
  _$ChecklistRecordCopyWithImpl(this._self, this._then);

  final ChecklistRecord _self;
  final $Res Function(ChecklistRecord) _then;

  /// Create a copy of ChecklistRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allOk = freezed,
    Object? items = null,
    Object? photoUrl = freezed,
  }) {
    return _then(_self.copyWith(
      allOk: freezed == allOk
          ? _self.allOk
          : allOk // ignore: cast_nullable_to_non_nullable
              as bool?,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ChecklistAnswer>,
      photoUrl: freezed == photoUrl
          ? _self.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChecklistRecord].
extension ChecklistRecordPatterns on ChecklistRecord {
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
    TResult Function(_ChecklistRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChecklistRecord() when $default != null:
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
    TResult Function(_ChecklistRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistRecord():
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
    TResult? Function(_ChecklistRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistRecord() when $default != null:
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
            @JsonKey(fromJson: _nullableBool) bool? allOk,
            List<ChecklistAnswer> items,
            @JsonKey(fromJson: looseString) String? photoUrl)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChecklistRecord() when $default != null:
        return $default(_that.allOk, _that.items, _that.photoUrl);
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
            @JsonKey(fromJson: _nullableBool) bool? allOk,
            List<ChecklistAnswer> items,
            @JsonKey(fromJson: looseString) String? photoUrl)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistRecord():
        return $default(_that.allOk, _that.items, _that.photoUrl);
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
            @JsonKey(fromJson: _nullableBool) bool? allOk,
            List<ChecklistAnswer> items,
            @JsonKey(fromJson: looseString) String? photoUrl)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChecklistRecord() when $default != null:
        return $default(_that.allOk, _that.items, _that.photoUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChecklistRecord implements ChecklistRecord {
  const _ChecklistRecord(
      {@JsonKey(fromJson: _nullableBool) this.allOk,
      final List<ChecklistAnswer> items = const <ChecklistAnswer>[],
      @JsonKey(fromJson: looseString) this.photoUrl})
      : _items = items;
  factory _ChecklistRecord.fromJson(Map<String, dynamic> json) =>
      _$ChecklistRecordFromJson(json);

  /// null when the backend did not say; treated as "all ok".
  @override
  @JsonKey(fromJson: _nullableBool)
  final bool? allOk;
  final List<ChecklistAnswer> _items;
  @override
  @JsonKey()
  List<ChecklistAnswer> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(fromJson: looseString)
  final String? photoUrl;

  /// Create a copy of ChecklistRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChecklistRecordCopyWith<_ChecklistRecord> get copyWith =>
      __$ChecklistRecordCopyWithImpl<_ChecklistRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChecklistRecordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChecklistRecord &&
            (identical(other.allOk, allOk) || other.allOk == allOk) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, allOk,
      const DeepCollectionEquality().hash(_items), photoUrl);

  @override
  String toString() {
    return 'ChecklistRecord(allOk: $allOk, items: $items, photoUrl: $photoUrl)';
  }
}

/// @nodoc
abstract mixin class _$ChecklistRecordCopyWith<$Res>
    implements $ChecklistRecordCopyWith<$Res> {
  factory _$ChecklistRecordCopyWith(
          _ChecklistRecord value, $Res Function(_ChecklistRecord) _then) =
      __$ChecklistRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _nullableBool) bool? allOk,
      List<ChecklistAnswer> items,
      @JsonKey(fromJson: looseString) String? photoUrl});
}

/// @nodoc
class __$ChecklistRecordCopyWithImpl<$Res>
    implements _$ChecklistRecordCopyWith<$Res> {
  __$ChecklistRecordCopyWithImpl(this._self, this._then);

  final _ChecklistRecord _self;
  final $Res Function(_ChecklistRecord) _then;

  /// Create a copy of ChecklistRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? allOk = freezed,
    Object? items = null,
    Object? photoUrl = freezed,
  }) {
    return _then(_ChecklistRecord(
      allOk: freezed == allOk
          ? _self.allOk
          : allOk // ignore: cast_nullable_to_non_nullable
              as bool?,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ChecklistAnswer>,
      photoUrl: freezed == photoUrl
          ? _self.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
