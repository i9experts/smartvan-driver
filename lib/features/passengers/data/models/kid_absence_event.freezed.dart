// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kid_absence_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KidAbsenceEvent {
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  String get kidId;
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  String get fullname;
  @JsonKey(fromJson: looseDate)
  DateTime? get date;
  @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
  AbsenceTripType get tripType;
  @JsonKey(fromJson: looseBool)
  bool get cancelled;

  /// Create a copy of KidAbsenceEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KidAbsenceEventCopyWith<KidAbsenceEvent> get copyWith =>
      _$KidAbsenceEventCopyWithImpl<KidAbsenceEvent>(
          this as KidAbsenceEvent, _$identity);

  /// Serializes this KidAbsenceEvent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KidAbsenceEvent &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.tripType, tripType) ||
                other.tripType == tripType) &&
            (identical(other.cancelled, cancelled) ||
                other.cancelled == cancelled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, kidId, fullname, date, tripType, cancelled);

  @override
  String toString() {
    return 'KidAbsenceEvent(kidId: $kidId, fullname: $fullname, date: $date, tripType: $tripType, cancelled: $cancelled)';
  }
}

/// @nodoc
abstract mixin class $KidAbsenceEventCopyWith<$Res> {
  factory $KidAbsenceEventCopyWith(
          KidAbsenceEvent value, $Res Function(KidAbsenceEvent) _then) =
      _$KidAbsenceEventCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      String kidId,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(fromJson: looseDate) DateTime? date,
      @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
      AbsenceTripType tripType,
      @JsonKey(fromJson: looseBool) bool cancelled});
}

/// @nodoc
class _$KidAbsenceEventCopyWithImpl<$Res>
    implements $KidAbsenceEventCopyWith<$Res> {
  _$KidAbsenceEventCopyWithImpl(this._self, this._then);

  final KidAbsenceEvent _self;
  final $Res Function(KidAbsenceEvent) _then;

  /// Create a copy of KidAbsenceEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kidId = null,
    Object? fullname = null,
    Object? date = freezed,
    Object? tripType = null,
    Object? cancelled = null,
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
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripType: null == tripType
          ? _self.tripType
          : tripType // ignore: cast_nullable_to_non_nullable
              as AbsenceTripType,
      cancelled: null == cancelled
          ? _self.cancelled
          : cancelled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [KidAbsenceEvent].
extension KidAbsenceEventPatterns on KidAbsenceEvent {
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
    TResult Function(_KidAbsenceEvent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KidAbsenceEvent() when $default != null:
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
    TResult Function(_KidAbsenceEvent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KidAbsenceEvent():
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
    TResult? Function(_KidAbsenceEvent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KidAbsenceEvent() when $default != null:
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
            @JsonKey(fromJson: looseDate) DateTime? date,
            @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
            AbsenceTripType tripType,
            @JsonKey(fromJson: looseBool) bool cancelled)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KidAbsenceEvent() when $default != null:
        return $default(_that.kidId, _that.fullname, _that.date, _that.tripType,
            _that.cancelled);
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
            @JsonKey(fromJson: looseDate) DateTime? date,
            @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
            AbsenceTripType tripType,
            @JsonKey(fromJson: looseBool) bool cancelled)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KidAbsenceEvent():
        return $default(_that.kidId, _that.fullname, _that.date, _that.tripType,
            _that.cancelled);
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
            @JsonKey(fromJson: looseDate) DateTime? date,
            @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
            AbsenceTripType tripType,
            @JsonKey(fromJson: looseBool) bool cancelled)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KidAbsenceEvent() when $default != null:
        return $default(_that.kidId, _that.fullname, _that.date, _that.tripType,
            _that.cancelled);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _KidAbsenceEvent implements KidAbsenceEvent {
  const _KidAbsenceEvent(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      this.kidId = '',
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      this.fullname = '',
      @JsonKey(fromJson: looseDate) this.date,
      @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
      this.tripType = AbsenceTripType.unknown,
      @JsonKey(fromJson: looseBool) this.cancelled = false});
  factory _KidAbsenceEvent.fromJson(Map<String, dynamic> json) =>
      _$KidAbsenceEventFromJson(json);

  @override
  @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
  final String kidId;
  @override
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  final String fullname;
  @override
  @JsonKey(fromJson: looseDate)
  final DateTime? date;
  @override
  @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
  final AbsenceTripType tripType;
  @override
  @JsonKey(fromJson: looseBool)
  final bool cancelled;

  /// Create a copy of KidAbsenceEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KidAbsenceEventCopyWith<_KidAbsenceEvent> get copyWith =>
      __$KidAbsenceEventCopyWithImpl<_KidAbsenceEvent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KidAbsenceEventToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KidAbsenceEvent &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.tripType, tripType) ||
                other.tripType == tripType) &&
            (identical(other.cancelled, cancelled) ||
                other.cancelled == cancelled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, kidId, fullname, date, tripType, cancelled);

  @override
  String toString() {
    return 'KidAbsenceEvent(kidId: $kidId, fullname: $fullname, date: $date, tripType: $tripType, cancelled: $cancelled)';
  }
}

/// @nodoc
abstract mixin class _$KidAbsenceEventCopyWith<$Res>
    implements $KidAbsenceEventCopyWith<$Res> {
  factory _$KidAbsenceEventCopyWith(
          _KidAbsenceEvent value, $Res Function(_KidAbsenceEvent) _then) =
      __$KidAbsenceEventCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
      String kidId,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(fromJson: looseDate) DateTime? date,
      @JsonKey(unknownEnumValue: AbsenceTripType.unknown)
      AbsenceTripType tripType,
      @JsonKey(fromJson: looseBool) bool cancelled});
}

/// @nodoc
class __$KidAbsenceEventCopyWithImpl<$Res>
    implements _$KidAbsenceEventCopyWith<$Res> {
  __$KidAbsenceEventCopyWithImpl(this._self, this._then);

  final _KidAbsenceEvent _self;
  final $Res Function(_KidAbsenceEvent) _then;

  /// Create a copy of KidAbsenceEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kidId = null,
    Object? fullname = null,
    Object? date = freezed,
    Object? tripType = null,
    Object? cancelled = null,
  }) {
    return _then(_KidAbsenceEvent(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripType: null == tripType
          ? _self.tripType
          : tripType // ignore: cast_nullable_to_non_nullable
              as AbsenceTripType,
      cancelled: null == cancelled
          ? _self.cancelled
          : cancelled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
