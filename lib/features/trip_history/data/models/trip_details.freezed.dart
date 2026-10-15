// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripStudent {
  @JsonKey(fromJson: looseStringOrEmpty)
  String get kidId;
  @JsonKey(fromJson: looseStringOrEmpty)
  String get name;
  @JsonKey(readValue: _readStatus, unknownEnumValue: StudentOutcome.unknown)
  StudentOutcome get status;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get at;

  /// Create a copy of TripStudent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripStudentCopyWith<TripStudent> get copyWith =>
      _$TripStudentCopyWithImpl<TripStudent>(this as TripStudent, _$identity);

  /// Serializes this TripStudent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TripStudent &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.at, at) || other.at == at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, name, status, at);

  @override
  String toString() {
    return 'TripStudent(kidId: $kidId, name: $name, status: $status, at: $at)';
  }
}

/// @nodoc
abstract mixin class $TripStudentCopyWith<$Res> {
  factory $TripStudentCopyWith(
          TripStudent value, $Res Function(TripStudent) _then) =
      _$TripStudentCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String kidId,
      @JsonKey(fromJson: looseStringOrEmpty) String name,
      @JsonKey(readValue: _readStatus, unknownEnumValue: StudentOutcome.unknown)
      StudentOutcome status,
      @JsonKey(fromJson: looseDateTime) DateTime? at});
}

/// @nodoc
class _$TripStudentCopyWithImpl<$Res> implements $TripStudentCopyWith<$Res> {
  _$TripStudentCopyWithImpl(this._self, this._then);

  final TripStudent _self;
  final $Res Function(TripStudent) _then;

  /// Create a copy of TripStudent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kidId = null,
    Object? name = null,
    Object? status = null,
    Object? at = freezed,
  }) {
    return _then(_self.copyWith(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as StudentOutcome,
      at: freezed == at
          ? _self.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TripStudent].
extension TripStudentPatterns on TripStudent {
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
    TResult Function(_TripStudent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripStudent() when $default != null:
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
    TResult Function(_TripStudent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripStudent():
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
    TResult? Function(_TripStudent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripStudent() when $default != null:
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
            @JsonKey(fromJson: looseStringOrEmpty) String kidId,
            @JsonKey(fromJson: looseStringOrEmpty) String name,
            @JsonKey(
                readValue: _readStatus,
                unknownEnumValue: StudentOutcome.unknown)
            StudentOutcome status,
            @JsonKey(fromJson: looseDateTime) DateTime? at)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripStudent() when $default != null:
        return $default(_that.kidId, _that.name, _that.status, _that.at);
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
            @JsonKey(fromJson: looseStringOrEmpty) String kidId,
            @JsonKey(fromJson: looseStringOrEmpty) String name,
            @JsonKey(
                readValue: _readStatus,
                unknownEnumValue: StudentOutcome.unknown)
            StudentOutcome status,
            @JsonKey(fromJson: looseDateTime) DateTime? at)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripStudent():
        return $default(_that.kidId, _that.name, _that.status, _that.at);
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
            @JsonKey(fromJson: looseStringOrEmpty) String kidId,
            @JsonKey(fromJson: looseStringOrEmpty) String name,
            @JsonKey(
                readValue: _readStatus,
                unknownEnumValue: StudentOutcome.unknown)
            StudentOutcome status,
            @JsonKey(fromJson: looseDateTime) DateTime? at)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripStudent() when $default != null:
        return $default(_that.kidId, _that.name, _that.status, _that.at);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TripStudent implements TripStudent {
  const _TripStudent(
      {@JsonKey(fromJson: looseStringOrEmpty) this.kidId = '',
      @JsonKey(fromJson: looseStringOrEmpty) this.name = '',
      @JsonKey(readValue: _readStatus, unknownEnumValue: StudentOutcome.unknown)
      this.status = StudentOutcome.unknown,
      @JsonKey(fromJson: looseDateTime) this.at});
  factory _TripStudent.fromJson(Map<String, dynamic> json) =>
      _$TripStudentFromJson(json);

  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String kidId;
  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String name;
  @override
  @JsonKey(readValue: _readStatus, unknownEnumValue: StudentOutcome.unknown)
  final StudentOutcome status;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? at;

  /// Create a copy of TripStudent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripStudentCopyWith<_TripStudent> get copyWith =>
      __$TripStudentCopyWithImpl<_TripStudent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TripStudentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TripStudent &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.at, at) || other.at == at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, name, status, at);

  @override
  String toString() {
    return 'TripStudent(kidId: $kidId, name: $name, status: $status, at: $at)';
  }
}

/// @nodoc
abstract mixin class _$TripStudentCopyWith<$Res>
    implements $TripStudentCopyWith<$Res> {
  factory _$TripStudentCopyWith(
          _TripStudent value, $Res Function(_TripStudent) _then) =
      __$TripStudentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String kidId,
      @JsonKey(fromJson: looseStringOrEmpty) String name,
      @JsonKey(readValue: _readStatus, unknownEnumValue: StudentOutcome.unknown)
      StudentOutcome status,
      @JsonKey(fromJson: looseDateTime) DateTime? at});
}

/// @nodoc
class __$TripStudentCopyWithImpl<$Res> implements _$TripStudentCopyWith<$Res> {
  __$TripStudentCopyWithImpl(this._self, this._then);

  final _TripStudent _self;
  final $Res Function(_TripStudent) _then;

  /// Create a copy of TripStudent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kidId = null,
    Object? name = null,
    Object? status = null,
    Object? at = freezed,
  }) {
    return _then(_TripStudent(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as StudentOutcome,
      at: freezed == at
          ? _self.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$TripStop {
  @JsonKey(fromJson: _order)
  int get order;
  @JsonKey(fromJson: looseString)
  String? get placeName;
  @JsonKey(fromJson: looseDouble)
  double? get lat;
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  double? get lng;
  List<TripStudent> get students;

  /// Create a copy of TripStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripStopCopyWith<TripStop> get copyWith =>
      _$TripStopCopyWithImpl<TripStop>(this as TripStop, _$identity);

  /// Serializes this TripStop to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TripStop &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            const DeepCollectionEquality().equals(other.students, students));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, order, placeName, lat, lng,
      const DeepCollectionEquality().hash(students));

  @override
  String toString() {
    return 'TripStop(order: $order, placeName: $placeName, lat: $lat, lng: $lng, students: $students)';
  }
}

/// @nodoc
abstract mixin class $TripStopCopyWith<$Res> {
  factory $TripStopCopyWith(TripStop value, $Res Function(TripStop) _then) =
      _$TripStopCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _order) int order,
      @JsonKey(fromJson: looseString) String? placeName,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
      List<TripStudent> students});
}

/// @nodoc
class _$TripStopCopyWithImpl<$Res> implements $TripStopCopyWith<$Res> {
  _$TripStopCopyWithImpl(this._self, this._then);

  final TripStop _self;
  final $Res Function(TripStop) _then;

  /// Create a copy of TripStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? placeName = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? students = null,
  }) {
    return _then(_self.copyWith(
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      placeName: freezed == placeName
          ? _self.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      students: null == students
          ? _self.students
          : students // ignore: cast_nullable_to_non_nullable
              as List<TripStudent>,
    ));
  }
}

/// Adds pattern-matching-related methods to [TripStop].
extension TripStopPatterns on TripStop {
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
    TResult Function(_TripStop value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripStop() when $default != null:
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
    TResult Function(_TripStop value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripStop():
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
    TResult? Function(_TripStop value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripStop() when $default != null:
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
            @JsonKey(fromJson: _order) int order,
            @JsonKey(fromJson: looseString) String? placeName,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
            List<TripStudent> students)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripStop() when $default != null:
        return $default(
            _that.order, _that.placeName, _that.lat, _that.lng, _that.students);
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
            @JsonKey(fromJson: _order) int order,
            @JsonKey(fromJson: looseString) String? placeName,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
            List<TripStudent> students)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripStop():
        return $default(
            _that.order, _that.placeName, _that.lat, _that.lng, _that.students);
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
            @JsonKey(fromJson: _order) int order,
            @JsonKey(fromJson: looseString) String? placeName,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
            List<TripStudent> students)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripStop() when $default != null:
        return $default(
            _that.order, _that.placeName, _that.lat, _that.lng, _that.students);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TripStop implements TripStop {
  const _TripStop(
      {@JsonKey(fromJson: _order) this.order = 0,
      @JsonKey(fromJson: looseString) this.placeName,
      @JsonKey(fromJson: looseDouble) this.lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) this.lng,
      final List<TripStudent> students = const <TripStudent>[]})
      : _students = students;
  factory _TripStop.fromJson(Map<String, dynamic> json) =>
      _$TripStopFromJson(json);

  @override
  @JsonKey(fromJson: _order)
  final int order;
  @override
  @JsonKey(fromJson: looseString)
  final String? placeName;
  @override
  @JsonKey(fromJson: looseDouble)
  final double? lat;
  @override
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  final double? lng;
  final List<TripStudent> _students;
  @override
  @JsonKey()
  List<TripStudent> get students {
    if (_students is EqualUnmodifiableListView) return _students;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_students);
  }

  /// Create a copy of TripStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripStopCopyWith<_TripStop> get copyWith =>
      __$TripStopCopyWithImpl<_TripStop>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TripStopToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TripStop &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            const DeepCollectionEquality().equals(other._students, _students));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, order, placeName, lat, lng,
      const DeepCollectionEquality().hash(_students));

  @override
  String toString() {
    return 'TripStop(order: $order, placeName: $placeName, lat: $lat, lng: $lng, students: $students)';
  }
}

/// @nodoc
abstract mixin class _$TripStopCopyWith<$Res>
    implements $TripStopCopyWith<$Res> {
  factory _$TripStopCopyWith(_TripStop value, $Res Function(_TripStop) _then) =
      __$TripStopCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _order) int order,
      @JsonKey(fromJson: looseString) String? placeName,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
      List<TripStudent> students});
}

/// @nodoc
class __$TripStopCopyWithImpl<$Res> implements _$TripStopCopyWith<$Res> {
  __$TripStopCopyWithImpl(this._self, this._then);

  final _TripStop _self;
  final $Res Function(_TripStop) _then;

  /// Create a copy of TripStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? order = null,
    Object? placeName = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? students = null,
  }) {
    return _then(_TripStop(
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      placeName: freezed == placeName
          ? _self.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      students: null == students
          ? _self._students
          : students // ignore: cast_nullable_to_non_nullable
              as List<TripStudent>,
    ));
  }
}

/// @nodoc
mixin _$TripAlert {
  @JsonKey(readValue: _readType, unknownEnumValue: TripAlertKind.unknown)
  TripAlertKind get type;
  @JsonKey(fromJson: looseString)
  String? get title;
  @JsonKey(fromJson: looseString)
  String? get message;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get at;

  /// Create a copy of TripAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripAlertCopyWith<TripAlert> get copyWith =>
      _$TripAlertCopyWithImpl<TripAlert>(this as TripAlert, _$identity);

  /// Serializes this TripAlert to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TripAlert &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.at, at) || other.at == at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, title, message, at);

  @override
  String toString() {
    return 'TripAlert(type: $type, title: $title, message: $message, at: $at)';
  }
}

/// @nodoc
abstract mixin class $TripAlertCopyWith<$Res> {
  factory $TripAlertCopyWith(TripAlert value, $Res Function(TripAlert) _then) =
      _$TripAlertCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: _readType, unknownEnumValue: TripAlertKind.unknown)
      TripAlertKind type,
      @JsonKey(fromJson: looseString) String? title,
      @JsonKey(fromJson: looseString) String? message,
      @JsonKey(fromJson: looseDateTime) DateTime? at});
}

/// @nodoc
class _$TripAlertCopyWithImpl<$Res> implements $TripAlertCopyWith<$Res> {
  _$TripAlertCopyWithImpl(this._self, this._then);

  final TripAlert _self;
  final $Res Function(TripAlert) _then;

  /// Create a copy of TripAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = freezed,
    Object? message = freezed,
    Object? at = freezed,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TripAlertKind,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      at: freezed == at
          ? _self.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TripAlert].
extension TripAlertPatterns on TripAlert {
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
    TResult Function(_TripAlert value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripAlert() when $default != null:
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
    TResult Function(_TripAlert value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripAlert():
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
    TResult? Function(_TripAlert value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripAlert() when $default != null:
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
            @JsonKey(
                readValue: _readType, unknownEnumValue: TripAlertKind.unknown)
            TripAlertKind type,
            @JsonKey(fromJson: looseString) String? title,
            @JsonKey(fromJson: looseString) String? message,
            @JsonKey(fromJson: looseDateTime) DateTime? at)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripAlert() when $default != null:
        return $default(_that.type, _that.title, _that.message, _that.at);
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
            @JsonKey(
                readValue: _readType, unknownEnumValue: TripAlertKind.unknown)
            TripAlertKind type,
            @JsonKey(fromJson: looseString) String? title,
            @JsonKey(fromJson: looseString) String? message,
            @JsonKey(fromJson: looseDateTime) DateTime? at)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripAlert():
        return $default(_that.type, _that.title, _that.message, _that.at);
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
            @JsonKey(
                readValue: _readType, unknownEnumValue: TripAlertKind.unknown)
            TripAlertKind type,
            @JsonKey(fromJson: looseString) String? title,
            @JsonKey(fromJson: looseString) String? message,
            @JsonKey(fromJson: looseDateTime) DateTime? at)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripAlert() when $default != null:
        return $default(_that.type, _that.title, _that.message, _that.at);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TripAlert implements TripAlert {
  const _TripAlert(
      {@JsonKey(readValue: _readType, unknownEnumValue: TripAlertKind.unknown)
      this.type = TripAlertKind.unknown,
      @JsonKey(fromJson: looseString) this.title,
      @JsonKey(fromJson: looseString) this.message,
      @JsonKey(fromJson: looseDateTime) this.at});
  factory _TripAlert.fromJson(Map<String, dynamic> json) =>
      _$TripAlertFromJson(json);

  @override
  @JsonKey(readValue: _readType, unknownEnumValue: TripAlertKind.unknown)
  final TripAlertKind type;
  @override
  @JsonKey(fromJson: looseString)
  final String? title;
  @override
  @JsonKey(fromJson: looseString)
  final String? message;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? at;

  /// Create a copy of TripAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripAlertCopyWith<_TripAlert> get copyWith =>
      __$TripAlertCopyWithImpl<_TripAlert>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TripAlertToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TripAlert &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.at, at) || other.at == at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, title, message, at);

  @override
  String toString() {
    return 'TripAlert(type: $type, title: $title, message: $message, at: $at)';
  }
}

/// @nodoc
abstract mixin class _$TripAlertCopyWith<$Res>
    implements $TripAlertCopyWith<$Res> {
  factory _$TripAlertCopyWith(
          _TripAlert value, $Res Function(_TripAlert) _then) =
      __$TripAlertCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: _readType, unknownEnumValue: TripAlertKind.unknown)
      TripAlertKind type,
      @JsonKey(fromJson: looseString) String? title,
      @JsonKey(fromJson: looseString) String? message,
      @JsonKey(fromJson: looseDateTime) DateTime? at});
}

/// @nodoc
class __$TripAlertCopyWithImpl<$Res> implements _$TripAlertCopyWith<$Res> {
  __$TripAlertCopyWithImpl(this._self, this._then);

  final _TripAlert _self;
  final $Res Function(_TripAlert) _then;

  /// Create a copy of TripAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? title = freezed,
    Object? message = freezed,
    Object? at = freezed,
  }) {
    return _then(_TripAlert(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TripAlertKind,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      at: freezed == at
          ? _self.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$TripSchool {
  @JsonKey(fromJson: looseString)
  String? get name;
  @JsonKey(fromJson: looseDouble)
  double? get lat;
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  double? get lng;

  /// Create a copy of TripSchool
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripSchoolCopyWith<TripSchool> get copyWith =>
      _$TripSchoolCopyWithImpl<TripSchool>(this as TripSchool, _$identity);

  /// Serializes this TripSchool to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TripSchool &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, lat, lng);

  @override
  String toString() {
    return 'TripSchool(name: $name, lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class $TripSchoolCopyWith<$Res> {
  factory $TripSchoolCopyWith(
          TripSchool value, $Res Function(TripSchool) _then) =
      _$TripSchoolCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? name,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng});
}

/// @nodoc
class _$TripSchoolCopyWithImpl<$Res> implements $TripSchoolCopyWith<$Res> {
  _$TripSchoolCopyWithImpl(this._self, this._then);

  final TripSchool _self;
  final $Res Function(TripSchool) _then;

  /// Create a copy of TripSchool
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TripSchool].
extension TripSchoolPatterns on TripSchool {
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
    TResult Function(_TripSchool value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripSchool() when $default != null:
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
    TResult Function(_TripSchool value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripSchool():
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
    TResult? Function(_TripSchool value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripSchool() when $default != null:
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
            @JsonKey(fromJson: looseString) String? name,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripSchool() when $default != null:
        return $default(_that.name, _that.lat, _that.lng);
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
            @JsonKey(fromJson: looseString) String? name,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripSchool():
        return $default(_that.name, _that.lat, _that.lng);
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
            @JsonKey(fromJson: looseString) String? name,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripSchool() when $default != null:
        return $default(_that.name, _that.lat, _that.lng);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TripSchool implements TripSchool {
  const _TripSchool(
      {@JsonKey(fromJson: looseString) this.name,
      @JsonKey(fromJson: looseDouble) this.lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) this.lng});
  factory _TripSchool.fromJson(Map<String, dynamic> json) =>
      _$TripSchoolFromJson(json);

  @override
  @JsonKey(fromJson: looseString)
  final String? name;
  @override
  @JsonKey(fromJson: looseDouble)
  final double? lat;
  @override
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  final double? lng;

  /// Create a copy of TripSchool
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripSchoolCopyWith<_TripSchool> get copyWith =>
      __$TripSchoolCopyWithImpl<_TripSchool>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TripSchoolToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TripSchool &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, lat, lng);

  @override
  String toString() {
    return 'TripSchool(name: $name, lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class _$TripSchoolCopyWith<$Res>
    implements $TripSchoolCopyWith<$Res> {
  factory _$TripSchoolCopyWith(
          _TripSchool value, $Res Function(_TripSchool) _then) =
      __$TripSchoolCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? name,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng});
}

/// @nodoc
class __$TripSchoolCopyWithImpl<$Res> implements _$TripSchoolCopyWith<$Res> {
  __$TripSchoolCopyWithImpl(this._self, this._then);

  final _TripSchool _self;
  final $Res Function(_TripSchool) _then;

  /// Create a copy of TripSchool
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_TripSchool(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
mixin _$TripDetails {
  CompletedTrip get trip;
  List<TripStop> get stops;
  List<TripAlert> get alerts;
  TripSchool? get school;

  /// Create a copy of TripDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripDetailsCopyWith<TripDetails> get copyWith =>
      _$TripDetailsCopyWithImpl<TripDetails>(this as TripDetails, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TripDetails &&
            (identical(other.trip, trip) || other.trip == trip) &&
            const DeepCollectionEquality().equals(other.stops, stops) &&
            const DeepCollectionEquality().equals(other.alerts, alerts) &&
            (identical(other.school, school) || other.school == school));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      trip,
      const DeepCollectionEquality().hash(stops),
      const DeepCollectionEquality().hash(alerts),
      school);

  @override
  String toString() {
    return 'TripDetails(trip: $trip, stops: $stops, alerts: $alerts, school: $school)';
  }
}

/// @nodoc
abstract mixin class $TripDetailsCopyWith<$Res> {
  factory $TripDetailsCopyWith(
          TripDetails value, $Res Function(TripDetails) _then) =
      _$TripDetailsCopyWithImpl;
  @useResult
  $Res call(
      {CompletedTrip trip,
      List<TripStop> stops,
      List<TripAlert> alerts,
      TripSchool? school});

  $CompletedTripCopyWith<$Res> get trip;
  $TripSchoolCopyWith<$Res>? get school;
}

/// @nodoc
class _$TripDetailsCopyWithImpl<$Res> implements $TripDetailsCopyWith<$Res> {
  _$TripDetailsCopyWithImpl(this._self, this._then);

  final TripDetails _self;
  final $Res Function(TripDetails) _then;

  /// Create a copy of TripDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trip = null,
    Object? stops = null,
    Object? alerts = null,
    Object? school = freezed,
  }) {
    return _then(_self.copyWith(
      trip: null == trip
          ? _self.trip
          : trip // ignore: cast_nullable_to_non_nullable
              as CompletedTrip,
      stops: null == stops
          ? _self.stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<TripStop>,
      alerts: null == alerts
          ? _self.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<TripAlert>,
      school: freezed == school
          ? _self.school
          : school // ignore: cast_nullable_to_non_nullable
              as TripSchool?,
    ));
  }

  /// Create a copy of TripDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompletedTripCopyWith<$Res> get trip {
    return $CompletedTripCopyWith<$Res>(_self.trip, (value) {
      return _then(_self.copyWith(trip: value));
    });
  }

  /// Create a copy of TripDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripSchoolCopyWith<$Res>? get school {
    if (_self.school == null) {
      return null;
    }

    return $TripSchoolCopyWith<$Res>(_self.school!, (value) {
      return _then(_self.copyWith(school: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TripDetails].
extension TripDetailsPatterns on TripDetails {
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
    TResult Function(_TripDetails value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripDetails() when $default != null:
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
    TResult Function(_TripDetails value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripDetails():
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
    TResult? Function(_TripDetails value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripDetails() when $default != null:
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
    TResult Function(CompletedTrip trip, List<TripStop> stops,
            List<TripAlert> alerts, TripSchool? school)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripDetails() when $default != null:
        return $default(_that.trip, _that.stops, _that.alerts, _that.school);
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
    TResult Function(CompletedTrip trip, List<TripStop> stops,
            List<TripAlert> alerts, TripSchool? school)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripDetails():
        return $default(_that.trip, _that.stops, _that.alerts, _that.school);
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
    TResult? Function(CompletedTrip trip, List<TripStop> stops,
            List<TripAlert> alerts, TripSchool? school)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripDetails() when $default != null:
        return $default(_that.trip, _that.stops, _that.alerts, _that.school);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TripDetails extends TripDetails {
  const _TripDetails(
      {required this.trip,
      final List<TripStop> stops = const <TripStop>[],
      final List<TripAlert> alerts = const <TripAlert>[],
      this.school})
      : _stops = stops,
        _alerts = alerts,
        super._();

  @override
  final CompletedTrip trip;
  final List<TripStop> _stops;
  @override
  @JsonKey()
  List<TripStop> get stops {
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stops);
  }

  final List<TripAlert> _alerts;
  @override
  @JsonKey()
  List<TripAlert> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  @override
  final TripSchool? school;

  /// Create a copy of TripDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripDetailsCopyWith<_TripDetails> get copyWith =>
      __$TripDetailsCopyWithImpl<_TripDetails>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TripDetails &&
            (identical(other.trip, trip) || other.trip == trip) &&
            const DeepCollectionEquality().equals(other._stops, _stops) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts) &&
            (identical(other.school, school) || other.school == school));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      trip,
      const DeepCollectionEquality().hash(_stops),
      const DeepCollectionEquality().hash(_alerts),
      school);

  @override
  String toString() {
    return 'TripDetails(trip: $trip, stops: $stops, alerts: $alerts, school: $school)';
  }
}

/// @nodoc
abstract mixin class _$TripDetailsCopyWith<$Res>
    implements $TripDetailsCopyWith<$Res> {
  factory _$TripDetailsCopyWith(
          _TripDetails value, $Res Function(_TripDetails) _then) =
      __$TripDetailsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {CompletedTrip trip,
      List<TripStop> stops,
      List<TripAlert> alerts,
      TripSchool? school});

  @override
  $CompletedTripCopyWith<$Res> get trip;
  @override
  $TripSchoolCopyWith<$Res>? get school;
}

/// @nodoc
class __$TripDetailsCopyWithImpl<$Res> implements _$TripDetailsCopyWith<$Res> {
  __$TripDetailsCopyWithImpl(this._self, this._then);

  final _TripDetails _self;
  final $Res Function(_TripDetails) _then;

  /// Create a copy of TripDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? trip = null,
    Object? stops = null,
    Object? alerts = null,
    Object? school = freezed,
  }) {
    return _then(_TripDetails(
      trip: null == trip
          ? _self.trip
          : trip // ignore: cast_nullable_to_non_nullable
              as CompletedTrip,
      stops: null == stops
          ? _self._stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<TripStop>,
      alerts: null == alerts
          ? _self._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<TripAlert>,
      school: freezed == school
          ? _self.school
          : school // ignore: cast_nullable_to_non_nullable
              as TripSchool?,
    ));
  }

  /// Create a copy of TripDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompletedTripCopyWith<$Res> get trip {
    return $CompletedTripCopyWith<$Res>(_self.trip, (value) {
      return _then(_self.copyWith(trip: value));
    });
  }

  /// Create a copy of TripDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripSchoolCopyWith<$Res>? get school {
    if (_self.school == null) {
      return null;
    }

    return $TripSchoolCopyWith<$Res>(_self.school!, (value) {
      return _then(_self.copyWith(school: value));
    });
  }
}

// dart format on
