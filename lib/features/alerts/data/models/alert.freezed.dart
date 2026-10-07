// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Alert {
  /// Mongo `_id` (the list used to ignore it; it is what the detail route
  /// carries).
  @JsonKey(readValue: readId, fromJson: looseString)
  String? get id;

  /// `alertType` | `type`.
  @JsonKey(readValue: readAlertType, unknownEnumValue: AlertType.unknown)
  AlertType get type;
  @JsonKey(fromJson: looseString)
  String? get title;

  /// `message` | `description` | `body`.
  @JsonKey(readValue: readAlertMessage, fromJson: looseString)
  String? get message;

  /// `createdAt` | `date`.
  @JsonKey(readValue: readAlertDate, fromJson: looseDateTime)
  DateTime? get createdAt;
  @JsonKey(fromJson: looseString)
  String? get tripId;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get startTime;

  /// Read by the detail screen's "Trip Details" card; the backend does not
  /// send these today.
  @JsonKey(fromJson: looseDateTime)
  DateTime? get date;
  @JsonKey(fromJson: looseString)
  String? get shift;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AlertCopyWith<Alert> get copyWith =>
      _$AlertCopyWithImpl<Alert>(this as Alert, _$identity);

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Alert &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.shift, shift) || other.shift == shift));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, title, message,
      createdAt, tripId, startTime, date, shift);

  @override
  String toString() {
    return 'Alert(id: $id, type: $type, title: $title, message: $message, createdAt: $createdAt, tripId: $tripId, startTime: $startTime, date: $date, shift: $shift)';
  }
}

/// @nodoc
abstract mixin class $AlertCopyWith<$Res> {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) _then) =
      _$AlertCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseString) String? id,
      @JsonKey(readValue: readAlertType, unknownEnumValue: AlertType.unknown)
      AlertType type,
      @JsonKey(fromJson: looseString) String? title,
      @JsonKey(readValue: readAlertMessage, fromJson: looseString)
      String? message,
      @JsonKey(readValue: readAlertDate, fromJson: looseDateTime)
      DateTime? createdAt,
      @JsonKey(fromJson: looseString) String? tripId,
      @JsonKey(fromJson: looseDateTime) DateTime? startTime,
      @JsonKey(fromJson: looseDateTime) DateTime? date,
      @JsonKey(fromJson: looseString) String? shift});
}

/// @nodoc
class _$AlertCopyWithImpl<$Res> implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._self, this._then);

  final Alert _self;
  final $Res Function(Alert) _then;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = null,
    Object? title = freezed,
    Object? message = freezed,
    Object? createdAt = freezed,
    Object? tripId = freezed,
    Object? startTime = freezed,
    Object? date = freezed,
    Object? shift = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertType,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripId: freezed == tripId
          ? _self.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shift: freezed == shift
          ? _self.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Alert].
extension AlertPatterns on Alert {
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
    TResult Function(_Alert value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Alert() when $default != null:
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
    TResult Function(_Alert value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Alert():
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
    TResult? Function(_Alert value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Alert() when $default != null:
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
            @JsonKey(readValue: readId, fromJson: looseString) String? id,
            @JsonKey(
                readValue: readAlertType, unknownEnumValue: AlertType.unknown)
            AlertType type,
            @JsonKey(fromJson: looseString) String? title,
            @JsonKey(readValue: readAlertMessage, fromJson: looseString)
            String? message,
            @JsonKey(readValue: readAlertDate, fromJson: looseDateTime)
            DateTime? createdAt,
            @JsonKey(fromJson: looseString) String? tripId,
            @JsonKey(fromJson: looseDateTime) DateTime? startTime,
            @JsonKey(fromJson: looseDateTime) DateTime? date,
            @JsonKey(fromJson: looseString) String? shift)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Alert() when $default != null:
        return $default(
            _that.id,
            _that.type,
            _that.title,
            _that.message,
            _that.createdAt,
            _that.tripId,
            _that.startTime,
            _that.date,
            _that.shift);
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
            @JsonKey(readValue: readId, fromJson: looseString) String? id,
            @JsonKey(
                readValue: readAlertType, unknownEnumValue: AlertType.unknown)
            AlertType type,
            @JsonKey(fromJson: looseString) String? title,
            @JsonKey(readValue: readAlertMessage, fromJson: looseString)
            String? message,
            @JsonKey(readValue: readAlertDate, fromJson: looseDateTime)
            DateTime? createdAt,
            @JsonKey(fromJson: looseString) String? tripId,
            @JsonKey(fromJson: looseDateTime) DateTime? startTime,
            @JsonKey(fromJson: looseDateTime) DateTime? date,
            @JsonKey(fromJson: looseString) String? shift)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Alert():
        return $default(
            _that.id,
            _that.type,
            _that.title,
            _that.message,
            _that.createdAt,
            _that.tripId,
            _that.startTime,
            _that.date,
            _that.shift);
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
            @JsonKey(readValue: readId, fromJson: looseString) String? id,
            @JsonKey(
                readValue: readAlertType, unknownEnumValue: AlertType.unknown)
            AlertType type,
            @JsonKey(fromJson: looseString) String? title,
            @JsonKey(readValue: readAlertMessage, fromJson: looseString)
            String? message,
            @JsonKey(readValue: readAlertDate, fromJson: looseDateTime)
            DateTime? createdAt,
            @JsonKey(fromJson: looseString) String? tripId,
            @JsonKey(fromJson: looseDateTime) DateTime? startTime,
            @JsonKey(fromJson: looseDateTime) DateTime? date,
            @JsonKey(fromJson: looseString) String? shift)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Alert() when $default != null:
        return $default(
            _that.id,
            _that.type,
            _that.title,
            _that.message,
            _that.createdAt,
            _that.tripId,
            _that.startTime,
            _that.date,
            _that.shift);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Alert implements Alert {
  const _Alert(
      {@JsonKey(readValue: readId, fromJson: looseString) this.id,
      @JsonKey(readValue: readAlertType, unknownEnumValue: AlertType.unknown)
      this.type = AlertType.unknown,
      @JsonKey(fromJson: looseString) this.title,
      @JsonKey(readValue: readAlertMessage, fromJson: looseString) this.message,
      @JsonKey(readValue: readAlertDate, fromJson: looseDateTime)
      this.createdAt,
      @JsonKey(fromJson: looseString) this.tripId,
      @JsonKey(fromJson: looseDateTime) this.startTime,
      @JsonKey(fromJson: looseDateTime) this.date,
      @JsonKey(fromJson: looseString) this.shift});
  factory _Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  /// Mongo `_id` (the list used to ignore it; it is what the detail route
  /// carries).
  @override
  @JsonKey(readValue: readId, fromJson: looseString)
  final String? id;

  /// `alertType` | `type`.
  @override
  @JsonKey(readValue: readAlertType, unknownEnumValue: AlertType.unknown)
  final AlertType type;
  @override
  @JsonKey(fromJson: looseString)
  final String? title;

  /// `message` | `description` | `body`.
  @override
  @JsonKey(readValue: readAlertMessage, fromJson: looseString)
  final String? message;

  /// `createdAt` | `date`.
  @override
  @JsonKey(readValue: readAlertDate, fromJson: looseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: looseString)
  final String? tripId;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? startTime;

  /// Read by the detail screen's "Trip Details" card; the backend does not
  /// send these today.
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? date;
  @override
  @JsonKey(fromJson: looseString)
  final String? shift;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AlertCopyWith<_Alert> get copyWith =>
      __$AlertCopyWithImpl<_Alert>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AlertToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Alert &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.shift, shift) || other.shift == shift));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, title, message,
      createdAt, tripId, startTime, date, shift);

  @override
  String toString() {
    return 'Alert(id: $id, type: $type, title: $title, message: $message, createdAt: $createdAt, tripId: $tripId, startTime: $startTime, date: $date, shift: $shift)';
  }
}

/// @nodoc
abstract mixin class _$AlertCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$AlertCopyWith(_Alert value, $Res Function(_Alert) _then) =
      __$AlertCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: readId, fromJson: looseString) String? id,
      @JsonKey(readValue: readAlertType, unknownEnumValue: AlertType.unknown)
      AlertType type,
      @JsonKey(fromJson: looseString) String? title,
      @JsonKey(readValue: readAlertMessage, fromJson: looseString)
      String? message,
      @JsonKey(readValue: readAlertDate, fromJson: looseDateTime)
      DateTime? createdAt,
      @JsonKey(fromJson: looseString) String? tripId,
      @JsonKey(fromJson: looseDateTime) DateTime? startTime,
      @JsonKey(fromJson: looseDateTime) DateTime? date,
      @JsonKey(fromJson: looseString) String? shift});
}

/// @nodoc
class __$AlertCopyWithImpl<$Res> implements _$AlertCopyWith<$Res> {
  __$AlertCopyWithImpl(this._self, this._then);

  final _Alert _self;
  final $Res Function(_Alert) _then;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? type = null,
    Object? title = freezed,
    Object? message = freezed,
    Object? createdAt = freezed,
    Object? tripId = freezed,
    Object? startTime = freezed,
    Object? date = freezed,
    Object? shift = freezed,
  }) {
    return _then(_Alert(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertType,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripId: freezed == tripId
          ? _self.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shift: freezed == shift
          ? _self.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
