// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_checklist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodayChecklist {
  /// Today's submitted checklist; null if not done yet.
  @JsonKey(name: 'data')
  ChecklistRecord? get checklist;

  /// Whether the school requires it before starting a trip.
  @JsonKey(fromJson: looseBool)
  bool get required;

  /// Create a copy of TodayChecklist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TodayChecklistCopyWith<TodayChecklist> get copyWith =>
      _$TodayChecklistCopyWithImpl<TodayChecklist>(
          this as TodayChecklist, _$identity);

  /// Serializes this TodayChecklist to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TodayChecklist &&
            (identical(other.checklist, checklist) ||
                other.checklist == checklist) &&
            (identical(other.required, required) ||
                other.required == required));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, checklist, required);

  @override
  String toString() {
    return 'TodayChecklist(checklist: $checklist, required: $required)';
  }
}

/// @nodoc
abstract mixin class $TodayChecklistCopyWith<$Res> {
  factory $TodayChecklistCopyWith(
          TodayChecklist value, $Res Function(TodayChecklist) _then) =
      _$TodayChecklistCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'data') ChecklistRecord? checklist,
      @JsonKey(fromJson: looseBool) bool required});

  $ChecklistRecordCopyWith<$Res>? get checklist;
}

/// @nodoc
class _$TodayChecklistCopyWithImpl<$Res>
    implements $TodayChecklistCopyWith<$Res> {
  _$TodayChecklistCopyWithImpl(this._self, this._then);

  final TodayChecklist _self;
  final $Res Function(TodayChecklist) _then;

  /// Create a copy of TodayChecklist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checklist = freezed,
    Object? required = null,
  }) {
    return _then(_self.copyWith(
      checklist: freezed == checklist
          ? _self.checklist
          : checklist // ignore: cast_nullable_to_non_nullable
              as ChecklistRecord?,
      required: null == required
          ? _self.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of TodayChecklist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChecklistRecordCopyWith<$Res>? get checklist {
    if (_self.checklist == null) {
      return null;
    }

    return $ChecklistRecordCopyWith<$Res>(_self.checklist!, (value) {
      return _then(_self.copyWith(checklist: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TodayChecklist].
extension TodayChecklistPatterns on TodayChecklist {
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
    TResult Function(_TodayChecklist value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TodayChecklist() when $default != null:
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
    TResult Function(_TodayChecklist value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodayChecklist():
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
    TResult? Function(_TodayChecklist value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodayChecklist() when $default != null:
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
    TResult Function(@JsonKey(name: 'data') ChecklistRecord? checklist,
            @JsonKey(fromJson: looseBool) bool required)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TodayChecklist() when $default != null:
        return $default(_that.checklist, _that.required);
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
    TResult Function(@JsonKey(name: 'data') ChecklistRecord? checklist,
            @JsonKey(fromJson: looseBool) bool required)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodayChecklist():
        return $default(_that.checklist, _that.required);
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
    TResult? Function(@JsonKey(name: 'data') ChecklistRecord? checklist,
            @JsonKey(fromJson: looseBool) bool required)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodayChecklist() when $default != null:
        return $default(_that.checklist, _that.required);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TodayChecklist extends TodayChecklist {
  const _TodayChecklist(
      {@JsonKey(name: 'data') this.checklist,
      @JsonKey(fromJson: looseBool) this.required = false})
      : super._();
  factory _TodayChecklist.fromJson(Map<String, dynamic> json) =>
      _$TodayChecklistFromJson(json);

  /// Today's submitted checklist; null if not done yet.
  @override
  @JsonKey(name: 'data')
  final ChecklistRecord? checklist;

  /// Whether the school requires it before starting a trip.
  @override
  @JsonKey(fromJson: looseBool)
  final bool required;

  /// Create a copy of TodayChecklist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TodayChecklistCopyWith<_TodayChecklist> get copyWith =>
      __$TodayChecklistCopyWithImpl<_TodayChecklist>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TodayChecklistToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodayChecklist &&
            (identical(other.checklist, checklist) ||
                other.checklist == checklist) &&
            (identical(other.required, required) ||
                other.required == required));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, checklist, required);

  @override
  String toString() {
    return 'TodayChecklist(checklist: $checklist, required: $required)';
  }
}

/// @nodoc
abstract mixin class _$TodayChecklistCopyWith<$Res>
    implements $TodayChecklistCopyWith<$Res> {
  factory _$TodayChecklistCopyWith(
          _TodayChecklist value, $Res Function(_TodayChecklist) _then) =
      __$TodayChecklistCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'data') ChecklistRecord? checklist,
      @JsonKey(fromJson: looseBool) bool required});

  @override
  $ChecklistRecordCopyWith<$Res>? get checklist;
}

/// @nodoc
class __$TodayChecklistCopyWithImpl<$Res>
    implements _$TodayChecklistCopyWith<$Res> {
  __$TodayChecklistCopyWithImpl(this._self, this._then);

  final _TodayChecklist _self;
  final $Res Function(_TodayChecklist) _then;

  /// Create a copy of TodayChecklist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? checklist = freezed,
    Object? required = null,
  }) {
    return _then(_TodayChecklist(
      checklist: freezed == checklist
          ? _self.checklist
          : checklist // ignore: cast_nullable_to_non_nullable
              as ChecklistRecord?,
      required: null == required
          ? _self.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of TodayChecklist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChecklistRecordCopyWith<$Res>? get checklist {
    if (_self.checklist == null) {
      return null;
    }

    return $ChecklistRecordCopyWith<$Res>(_self.checklist!, (value) {
      return _then(_self.copyWith(checklist: value));
    });
  }
}

// dart format on
