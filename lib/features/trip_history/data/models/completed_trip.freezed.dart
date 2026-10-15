// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completed_trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompletedTrip {
  @JsonKey(readValue: readId, fromJson: looseStringOrEmpty)
  String get id;
  @JsonKey(fromJson: looseString)
  String? get routeName;
  @JsonKey(readValue: readTripTypeLower, unknownEnumValue: TripType.unknown)
  TripType get tripType;

  /// Trip day, `YYYY-MM-DD` (PKT).
  @JsonKey(fromJson: looseString)
  String? get date;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get startedAt;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get endedAt;
  @JsonKey(fromJson: _count)
  int get durationSeconds;
  @JsonKey(fromJson: _count)
  int get distanceMeters;
  @JsonKey(fromJson: _count)
  int get studentCount;
  @JsonKey(fromJson: _count)
  int get pickedCount;
  @JsonKey(fromJson: _count)
  int get droppedCount;
  @JsonKey(fromJson: _count)
  int get absentCount;
  @JsonKey(fromJson: _count)
  int get noShowCount;

  /// Create a copy of CompletedTrip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompletedTripCopyWith<CompletedTrip> get copyWith =>
      _$CompletedTripCopyWithImpl<CompletedTrip>(
          this as CompletedTrip, _$identity);

  /// Serializes this CompletedTrip to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompletedTrip &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routeName, routeName) ||
                other.routeName == routeName) &&
            (identical(other.tripType, tripType) ||
                other.tripType == tripType) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.studentCount, studentCount) ||
                other.studentCount == studentCount) &&
            (identical(other.pickedCount, pickedCount) ||
                other.pickedCount == pickedCount) &&
            (identical(other.droppedCount, droppedCount) ||
                other.droppedCount == droppedCount) &&
            (identical(other.absentCount, absentCount) ||
                other.absentCount == absentCount) &&
            (identical(other.noShowCount, noShowCount) ||
                other.noShowCount == noShowCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      routeName,
      tripType,
      date,
      startedAt,
      endedAt,
      durationSeconds,
      distanceMeters,
      studentCount,
      pickedCount,
      droppedCount,
      absentCount,
      noShowCount);

  @override
  String toString() {
    return 'CompletedTrip(id: $id, routeName: $routeName, tripType: $tripType, date: $date, startedAt: $startedAt, endedAt: $endedAt, durationSeconds: $durationSeconds, distanceMeters: $distanceMeters, studentCount: $studentCount, pickedCount: $pickedCount, droppedCount: $droppedCount, absentCount: $absentCount, noShowCount: $noShowCount)';
  }
}

/// @nodoc
abstract mixin class $CompletedTripCopyWith<$Res> {
  factory $CompletedTripCopyWith(
          CompletedTrip value, $Res Function(CompletedTrip) _then) =
      _$CompletedTripCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
      @JsonKey(fromJson: looseString) String? routeName,
      @JsonKey(readValue: readTripTypeLower, unknownEnumValue: TripType.unknown)
      TripType tripType,
      @JsonKey(fromJson: looseString) String? date,
      @JsonKey(fromJson: looseDateTime) DateTime? startedAt,
      @JsonKey(fromJson: looseDateTime) DateTime? endedAt,
      @JsonKey(fromJson: _count) int durationSeconds,
      @JsonKey(fromJson: _count) int distanceMeters,
      @JsonKey(fromJson: _count) int studentCount,
      @JsonKey(fromJson: _count) int pickedCount,
      @JsonKey(fromJson: _count) int droppedCount,
      @JsonKey(fromJson: _count) int absentCount,
      @JsonKey(fromJson: _count) int noShowCount});
}

/// @nodoc
class _$CompletedTripCopyWithImpl<$Res>
    implements $CompletedTripCopyWith<$Res> {
  _$CompletedTripCopyWithImpl(this._self, this._then);

  final CompletedTrip _self;
  final $Res Function(CompletedTrip) _then;

  /// Create a copy of CompletedTrip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeName = freezed,
    Object? tripType = null,
    Object? date = freezed,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
    Object? durationSeconds = null,
    Object? distanceMeters = null,
    Object? studentCount = null,
    Object? pickedCount = null,
    Object? droppedCount = null,
    Object? absentCount = null,
    Object? noShowCount = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeName: freezed == routeName
          ? _self.routeName
          : routeName // ignore: cast_nullable_to_non_nullable
              as String?,
      tripType: null == tripType
          ? _self.tripType
          : tripType // ignore: cast_nullable_to_non_nullable
              as TripType,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSeconds: null == durationSeconds
          ? _self.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      distanceMeters: null == distanceMeters
          ? _self.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int,
      studentCount: null == studentCount
          ? _self.studentCount
          : studentCount // ignore: cast_nullable_to_non_nullable
              as int,
      pickedCount: null == pickedCount
          ? _self.pickedCount
          : pickedCount // ignore: cast_nullable_to_non_nullable
              as int,
      droppedCount: null == droppedCount
          ? _self.droppedCount
          : droppedCount // ignore: cast_nullable_to_non_nullable
              as int,
      absentCount: null == absentCount
          ? _self.absentCount
          : absentCount // ignore: cast_nullable_to_non_nullable
              as int,
      noShowCount: null == noShowCount
          ? _self.noShowCount
          : noShowCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [CompletedTrip].
extension CompletedTripPatterns on CompletedTrip {
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
    TResult Function(_CompletedTrip value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CompletedTrip() when $default != null:
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
    TResult Function(_CompletedTrip value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompletedTrip():
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
    TResult? Function(_CompletedTrip value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompletedTrip() when $default != null:
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
            @JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
            @JsonKey(fromJson: looseString) String? routeName,
            @JsonKey(
                readValue: readTripTypeLower,
                unknownEnumValue: TripType.unknown)
            TripType tripType,
            @JsonKey(fromJson: looseString) String? date,
            @JsonKey(fromJson: looseDateTime) DateTime? startedAt,
            @JsonKey(fromJson: looseDateTime) DateTime? endedAt,
            @JsonKey(fromJson: _count) int durationSeconds,
            @JsonKey(fromJson: _count) int distanceMeters,
            @JsonKey(fromJson: _count) int studentCount,
            @JsonKey(fromJson: _count) int pickedCount,
            @JsonKey(fromJson: _count) int droppedCount,
            @JsonKey(fromJson: _count) int absentCount,
            @JsonKey(fromJson: _count) int noShowCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CompletedTrip() when $default != null:
        return $default(
            _that.id,
            _that.routeName,
            _that.tripType,
            _that.date,
            _that.startedAt,
            _that.endedAt,
            _that.durationSeconds,
            _that.distanceMeters,
            _that.studentCount,
            _that.pickedCount,
            _that.droppedCount,
            _that.absentCount,
            _that.noShowCount);
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
            @JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
            @JsonKey(fromJson: looseString) String? routeName,
            @JsonKey(
                readValue: readTripTypeLower,
                unknownEnumValue: TripType.unknown)
            TripType tripType,
            @JsonKey(fromJson: looseString) String? date,
            @JsonKey(fromJson: looseDateTime) DateTime? startedAt,
            @JsonKey(fromJson: looseDateTime) DateTime? endedAt,
            @JsonKey(fromJson: _count) int durationSeconds,
            @JsonKey(fromJson: _count) int distanceMeters,
            @JsonKey(fromJson: _count) int studentCount,
            @JsonKey(fromJson: _count) int pickedCount,
            @JsonKey(fromJson: _count) int droppedCount,
            @JsonKey(fromJson: _count) int absentCount,
            @JsonKey(fromJson: _count) int noShowCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompletedTrip():
        return $default(
            _that.id,
            _that.routeName,
            _that.tripType,
            _that.date,
            _that.startedAt,
            _that.endedAt,
            _that.durationSeconds,
            _that.distanceMeters,
            _that.studentCount,
            _that.pickedCount,
            _that.droppedCount,
            _that.absentCount,
            _that.noShowCount);
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
            @JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
            @JsonKey(fromJson: looseString) String? routeName,
            @JsonKey(
                readValue: readTripTypeLower,
                unknownEnumValue: TripType.unknown)
            TripType tripType,
            @JsonKey(fromJson: looseString) String? date,
            @JsonKey(fromJson: looseDateTime) DateTime? startedAt,
            @JsonKey(fromJson: looseDateTime) DateTime? endedAt,
            @JsonKey(fromJson: _count) int durationSeconds,
            @JsonKey(fromJson: _count) int distanceMeters,
            @JsonKey(fromJson: _count) int studentCount,
            @JsonKey(fromJson: _count) int pickedCount,
            @JsonKey(fromJson: _count) int droppedCount,
            @JsonKey(fromJson: _count) int absentCount,
            @JsonKey(fromJson: _count) int noShowCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompletedTrip() when $default != null:
        return $default(
            _that.id,
            _that.routeName,
            _that.tripType,
            _that.date,
            _that.startedAt,
            _that.endedAt,
            _that.durationSeconds,
            _that.distanceMeters,
            _that.studentCount,
            _that.pickedCount,
            _that.droppedCount,
            _that.absentCount,
            _that.noShowCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CompletedTrip extends CompletedTrip {
  const _CompletedTrip(
      {@JsonKey(readValue: readId, fromJson: looseStringOrEmpty) this.id = '',
      @JsonKey(fromJson: looseString) this.routeName,
      @JsonKey(readValue: readTripTypeLower, unknownEnumValue: TripType.unknown)
      this.tripType = TripType.unknown,
      @JsonKey(fromJson: looseString) this.date,
      @JsonKey(fromJson: looseDateTime) this.startedAt,
      @JsonKey(fromJson: looseDateTime) this.endedAt,
      @JsonKey(fromJson: _count) this.durationSeconds = 0,
      @JsonKey(fromJson: _count) this.distanceMeters = 0,
      @JsonKey(fromJson: _count) this.studentCount = 0,
      @JsonKey(fromJson: _count) this.pickedCount = 0,
      @JsonKey(fromJson: _count) this.droppedCount = 0,
      @JsonKey(fromJson: _count) this.absentCount = 0,
      @JsonKey(fromJson: _count) this.noShowCount = 0})
      : super._();
  factory _CompletedTrip.fromJson(Map<String, dynamic> json) =>
      _$CompletedTripFromJson(json);

  @override
  @JsonKey(readValue: readId, fromJson: looseStringOrEmpty)
  final String id;
  @override
  @JsonKey(fromJson: looseString)
  final String? routeName;
  @override
  @JsonKey(readValue: readTripTypeLower, unknownEnumValue: TripType.unknown)
  final TripType tripType;

  /// Trip day, `YYYY-MM-DD` (PKT).
  @override
  @JsonKey(fromJson: looseString)
  final String? date;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? startedAt;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? endedAt;
  @override
  @JsonKey(fromJson: _count)
  final int durationSeconds;
  @override
  @JsonKey(fromJson: _count)
  final int distanceMeters;
  @override
  @JsonKey(fromJson: _count)
  final int studentCount;
  @override
  @JsonKey(fromJson: _count)
  final int pickedCount;
  @override
  @JsonKey(fromJson: _count)
  final int droppedCount;
  @override
  @JsonKey(fromJson: _count)
  final int absentCount;
  @override
  @JsonKey(fromJson: _count)
  final int noShowCount;

  /// Create a copy of CompletedTrip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompletedTripCopyWith<_CompletedTrip> get copyWith =>
      __$CompletedTripCopyWithImpl<_CompletedTrip>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CompletedTripToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompletedTrip &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routeName, routeName) ||
                other.routeName == routeName) &&
            (identical(other.tripType, tripType) ||
                other.tripType == tripType) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.studentCount, studentCount) ||
                other.studentCount == studentCount) &&
            (identical(other.pickedCount, pickedCount) ||
                other.pickedCount == pickedCount) &&
            (identical(other.droppedCount, droppedCount) ||
                other.droppedCount == droppedCount) &&
            (identical(other.absentCount, absentCount) ||
                other.absentCount == absentCount) &&
            (identical(other.noShowCount, noShowCount) ||
                other.noShowCount == noShowCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      routeName,
      tripType,
      date,
      startedAt,
      endedAt,
      durationSeconds,
      distanceMeters,
      studentCount,
      pickedCount,
      droppedCount,
      absentCount,
      noShowCount);

  @override
  String toString() {
    return 'CompletedTrip(id: $id, routeName: $routeName, tripType: $tripType, date: $date, startedAt: $startedAt, endedAt: $endedAt, durationSeconds: $durationSeconds, distanceMeters: $distanceMeters, studentCount: $studentCount, pickedCount: $pickedCount, droppedCount: $droppedCount, absentCount: $absentCount, noShowCount: $noShowCount)';
  }
}

/// @nodoc
abstract mixin class _$CompletedTripCopyWith<$Res>
    implements $CompletedTripCopyWith<$Res> {
  factory _$CompletedTripCopyWith(
          _CompletedTrip value, $Res Function(_CompletedTrip) _then) =
      __$CompletedTripCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseStringOrEmpty) String id,
      @JsonKey(fromJson: looseString) String? routeName,
      @JsonKey(readValue: readTripTypeLower, unknownEnumValue: TripType.unknown)
      TripType tripType,
      @JsonKey(fromJson: looseString) String? date,
      @JsonKey(fromJson: looseDateTime) DateTime? startedAt,
      @JsonKey(fromJson: looseDateTime) DateTime? endedAt,
      @JsonKey(fromJson: _count) int durationSeconds,
      @JsonKey(fromJson: _count) int distanceMeters,
      @JsonKey(fromJson: _count) int studentCount,
      @JsonKey(fromJson: _count) int pickedCount,
      @JsonKey(fromJson: _count) int droppedCount,
      @JsonKey(fromJson: _count) int absentCount,
      @JsonKey(fromJson: _count) int noShowCount});
}

/// @nodoc
class __$CompletedTripCopyWithImpl<$Res>
    implements _$CompletedTripCopyWith<$Res> {
  __$CompletedTripCopyWithImpl(this._self, this._then);

  final _CompletedTrip _self;
  final $Res Function(_CompletedTrip) _then;

  /// Create a copy of CompletedTrip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? routeName = freezed,
    Object? tripType = null,
    Object? date = freezed,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
    Object? durationSeconds = null,
    Object? distanceMeters = null,
    Object? studentCount = null,
    Object? pickedCount = null,
    Object? droppedCount = null,
    Object? absentCount = null,
    Object? noShowCount = null,
  }) {
    return _then(_CompletedTrip(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeName: freezed == routeName
          ? _self.routeName
          : routeName // ignore: cast_nullable_to_non_nullable
              as String?,
      tripType: null == tripType
          ? _self.tripType
          : tripType // ignore: cast_nullable_to_non_nullable
              as TripType,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSeconds: null == durationSeconds
          ? _self.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      distanceMeters: null == distanceMeters
          ? _self.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int,
      studentCount: null == studentCount
          ? _self.studentCount
          : studentCount // ignore: cast_nullable_to_non_nullable
              as int,
      pickedCount: null == pickedCount
          ? _self.pickedCount
          : pickedCount // ignore: cast_nullable_to_non_nullable
              as int,
      droppedCount: null == droppedCount
          ? _self.droppedCount
          : droppedCount // ignore: cast_nullable_to_non_nullable
              as int,
      absentCount: null == absentCount
          ? _self.absentCount
          : absentCount // ignore: cast_nullable_to_non_nullable
              as int,
      noShowCount: null == noShowCount
          ? _self.noShowCount
          : noShowCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
