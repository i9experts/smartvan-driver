// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Absence {
  @JsonKey(fromJson: looseStringOrEmpty)
  String get absenceId;
  @JsonKey(fromJson: looseStringOrEmpty)
  String get kidId;

  /// Calendar day (`YYYY-MM-DD`).
  @JsonKey(fromJson: looseDate)
  DateTime? get date;
  @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
  AbsenceTripType get tripType;
  @JsonKey(fromJson: looseString)
  String? get note;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get createdAt;

  /// Create a copy of Absence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AbsenceCopyWith<Absence> get copyWith =>
      _$AbsenceCopyWithImpl<Absence>(this as Absence, _$identity);

  /// Serializes this Absence to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Absence &&
            (identical(other.absenceId, absenceId) ||
                other.absenceId == absenceId) &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.tripType, tripType) ||
                other.tripType == tripType) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, absenceId, kidId, date, tripType, note, createdAt);

  @override
  String toString() {
    return 'Absence(absenceId: $absenceId, kidId: $kidId, date: $date, tripType: $tripType, note: $note, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $AbsenceCopyWith<$Res> {
  factory $AbsenceCopyWith(Absence value, $Res Function(Absence) _then) =
      _$AbsenceCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String absenceId,
      @JsonKey(fromJson: looseStringOrEmpty) String kidId,
      @JsonKey(fromJson: looseDate) DateTime? date,
      @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
      AbsenceTripType tripType,
      @JsonKey(fromJson: looseString) String? note,
      @JsonKey(fromJson: looseDateTime) DateTime? createdAt});
}

/// @nodoc
class _$AbsenceCopyWithImpl<$Res> implements $AbsenceCopyWith<$Res> {
  _$AbsenceCopyWithImpl(this._self, this._then);

  final Absence _self;
  final $Res Function(Absence) _then;

  /// Create a copy of Absence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? absenceId = null,
    Object? kidId = null,
    Object? date = freezed,
    Object? tripType = null,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      absenceId: null == absenceId
          ? _self.absenceId
          : absenceId // ignore: cast_nullable_to_non_nullable
              as String,
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripType: null == tripType
          ? _self.tripType
          : tripType // ignore: cast_nullable_to_non_nullable
              as AbsenceTripType,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Absence].
extension AbsencePatterns on Absence {
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
    TResult Function(_Absence value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Absence() when $default != null:
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
    TResult Function(_Absence value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Absence():
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
    TResult? Function(_Absence value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Absence() when $default != null:
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
            @JsonKey(fromJson: looseStringOrEmpty) String absenceId,
            @JsonKey(fromJson: looseStringOrEmpty) String kidId,
            @JsonKey(fromJson: looseDate) DateTime? date,
            @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
            AbsenceTripType tripType,
            @JsonKey(fromJson: looseString) String? note,
            @JsonKey(fromJson: looseDateTime) DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Absence() when $default != null:
        return $default(_that.absenceId, _that.kidId, _that.date,
            _that.tripType, _that.note, _that.createdAt);
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
            @JsonKey(fromJson: looseStringOrEmpty) String absenceId,
            @JsonKey(fromJson: looseStringOrEmpty) String kidId,
            @JsonKey(fromJson: looseDate) DateTime? date,
            @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
            AbsenceTripType tripType,
            @JsonKey(fromJson: looseString) String? note,
            @JsonKey(fromJson: looseDateTime) DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Absence():
        return $default(_that.absenceId, _that.kidId, _that.date,
            _that.tripType, _that.note, _that.createdAt);
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
            @JsonKey(fromJson: looseStringOrEmpty) String absenceId,
            @JsonKey(fromJson: looseStringOrEmpty) String kidId,
            @JsonKey(fromJson: looseDate) DateTime? date,
            @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
            AbsenceTripType tripType,
            @JsonKey(fromJson: looseString) String? note,
            @JsonKey(fromJson: looseDateTime) DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Absence() when $default != null:
        return $default(_that.absenceId, _that.kidId, _that.date,
            _that.tripType, _that.note, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Absence implements Absence {
  const _Absence(
      {@JsonKey(fromJson: looseStringOrEmpty) this.absenceId = '',
      @JsonKey(fromJson: looseStringOrEmpty) this.kidId = '',
      @JsonKey(fromJson: looseDate) this.date,
      @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
      this.tripType = AbsenceTripType.unknown,
      @JsonKey(fromJson: looseString) this.note,
      @JsonKey(fromJson: looseDateTime) this.createdAt});
  factory _Absence.fromJson(Map<String, dynamic> json) =>
      _$AbsenceFromJson(json);

  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String absenceId;
  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String kidId;

  /// Calendar day (`YYYY-MM-DD`).
  @override
  @JsonKey(fromJson: looseDate)
  final DateTime? date;
  @override
  @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
  final AbsenceTripType tripType;
  @override
  @JsonKey(fromJson: looseString)
  final String? note;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? createdAt;

  /// Create a copy of Absence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AbsenceCopyWith<_Absence> get copyWith =>
      __$AbsenceCopyWithImpl<_Absence>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AbsenceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Absence &&
            (identical(other.absenceId, absenceId) ||
                other.absenceId == absenceId) &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.tripType, tripType) ||
                other.tripType == tripType) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, absenceId, kidId, date, tripType, note, createdAt);

  @override
  String toString() {
    return 'Absence(absenceId: $absenceId, kidId: $kidId, date: $date, tripType: $tripType, note: $note, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$AbsenceCopyWith<$Res> implements $AbsenceCopyWith<$Res> {
  factory _$AbsenceCopyWith(_Absence value, $Res Function(_Absence) _then) =
      __$AbsenceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String absenceId,
      @JsonKey(fromJson: looseStringOrEmpty) String kidId,
      @JsonKey(fromJson: looseDate) DateTime? date,
      @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
      AbsenceTripType tripType,
      @JsonKey(fromJson: looseString) String? note,
      @JsonKey(fromJson: looseDateTime) DateTime? createdAt});
}

/// @nodoc
class __$AbsenceCopyWithImpl<$Res> implements _$AbsenceCopyWith<$Res> {
  __$AbsenceCopyWithImpl(this._self, this._then);

  final _Absence _self;
  final $Res Function(_Absence) _then;

  /// Create a copy of Absence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? absenceId = null,
    Object? kidId = null,
    Object? date = freezed,
    Object? tripType = null,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_Absence(
      absenceId: null == absenceId
          ? _self.absenceId
          : absenceId // ignore: cast_nullable_to_non_nullable
              as String,
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripType: null == tripType
          ? _self.tripType
          : tripType // ignore: cast_nullable_to_non_nullable
              as AbsenceTripType,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
