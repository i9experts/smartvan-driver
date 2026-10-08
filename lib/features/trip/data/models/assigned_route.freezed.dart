// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assigned_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssignedRoute {
  @JsonKey(fromJson: looseStringOrEmpty)
  String get routeId;
  @JsonKey(fromJson: looseString)
  String? get routeTitle;
  @JsonKey(fromJson: looseString)
  String? get vehicleNumber;

  /// UTC ISO timestamp; the app only uses hours and minutes of it.
  @JsonKey(fromJson: looseDateTime)
  DateTime? get startTime;
  @JsonKey(unknownEnumValue: TripType.unknown)
  TripType get tripType;

  /// Backend key is `TripStarted` (PascalCase).
  @JsonKey(readValue: readTripStarted, fromJson: looseBool)
  bool get tripStarted;

  /// Today's state of the route; a route can be run once a day.
  @JsonKey(unknownEnumValue: TodayStatus.unknown)
  TodayStatus get todayStatus;

  /// Backend key is `TripCompleted`: today's trip is already done.
  @JsonKey(readValue: readTripCompleted, fromJson: looseBool)
  bool get tripCompleted;

  /// The running trip, when [tripStarted].
  Trip? get tripDetails;
  List<RoutePassenger> get passengers;

  /// Create a copy of AssignedRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssignedRouteCopyWith<AssignedRoute> get copyWith =>
      _$AssignedRouteCopyWithImpl<AssignedRoute>(
          this as AssignedRoute, _$identity);

  /// Serializes this AssignedRoute to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssignedRoute &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.routeTitle, routeTitle) ||
                other.routeTitle == routeTitle) &&
            (identical(other.vehicleNumber, vehicleNumber) ||
                other.vehicleNumber == vehicleNumber) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.tripType, tripType) ||
                other.tripType == tripType) &&
            (identical(other.tripStarted, tripStarted) ||
                other.tripStarted == tripStarted) &&
            (identical(other.todayStatus, todayStatus) ||
                other.todayStatus == todayStatus) &&
            (identical(other.tripCompleted, tripCompleted) ||
                other.tripCompleted == tripCompleted) &&
            (identical(other.tripDetails, tripDetails) ||
                other.tripDetails == tripDetails) &&
            const DeepCollectionEquality()
                .equals(other.passengers, passengers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      routeId,
      routeTitle,
      vehicleNumber,
      startTime,
      tripType,
      tripStarted,
      todayStatus,
      tripCompleted,
      tripDetails,
      const DeepCollectionEquality().hash(passengers));

  @override
  String toString() {
    return 'AssignedRoute(routeId: $routeId, routeTitle: $routeTitle, vehicleNumber: $vehicleNumber, startTime: $startTime, tripType: $tripType, tripStarted: $tripStarted, todayStatus: $todayStatus, tripCompleted: $tripCompleted, tripDetails: $tripDetails, passengers: $passengers)';
  }
}

/// @nodoc
abstract mixin class $AssignedRouteCopyWith<$Res> {
  factory $AssignedRouteCopyWith(
          AssignedRoute value, $Res Function(AssignedRoute) _then) =
      _$AssignedRouteCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String routeId,
      @JsonKey(fromJson: looseString) String? routeTitle,
      @JsonKey(fromJson: looseString) String? vehicleNumber,
      @JsonKey(fromJson: looseDateTime) DateTime? startTime,
      @JsonKey(unknownEnumValue: TripType.unknown) TripType tripType,
      @JsonKey(readValue: readTripStarted, fromJson: looseBool)
      bool tripStarted,
      @JsonKey(unknownEnumValue: TodayStatus.unknown) TodayStatus todayStatus,
      @JsonKey(readValue: readTripCompleted, fromJson: looseBool)
      bool tripCompleted,
      Trip? tripDetails,
      List<RoutePassenger> passengers});

  $TripCopyWith<$Res>? get tripDetails;
}

/// @nodoc
class _$AssignedRouteCopyWithImpl<$Res>
    implements $AssignedRouteCopyWith<$Res> {
  _$AssignedRouteCopyWithImpl(this._self, this._then);

  final AssignedRoute _self;
  final $Res Function(AssignedRoute) _then;

  /// Create a copy of AssignedRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routeId = null,
    Object? routeTitle = freezed,
    Object? vehicleNumber = freezed,
    Object? startTime = freezed,
    Object? tripType = null,
    Object? tripStarted = null,
    Object? todayStatus = null,
    Object? tripCompleted = null,
    Object? tripDetails = freezed,
    Object? passengers = null,
  }) {
    return _then(_self.copyWith(
      routeId: null == routeId
          ? _self.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String,
      routeTitle: freezed == routeTitle
          ? _self.routeTitle
          : routeTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleNumber: freezed == vehicleNumber
          ? _self.vehicleNumber
          : vehicleNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripType: null == tripType
          ? _self.tripType
          : tripType // ignore: cast_nullable_to_non_nullable
              as TripType,
      tripStarted: null == tripStarted
          ? _self.tripStarted
          : tripStarted // ignore: cast_nullable_to_non_nullable
              as bool,
      todayStatus: null == todayStatus
          ? _self.todayStatus
          : todayStatus // ignore: cast_nullable_to_non_nullable
              as TodayStatus,
      tripCompleted: null == tripCompleted
          ? _self.tripCompleted
          : tripCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      tripDetails: freezed == tripDetails
          ? _self.tripDetails
          : tripDetails // ignore: cast_nullable_to_non_nullable
              as Trip?,
      passengers: null == passengers
          ? _self.passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<RoutePassenger>,
    ));
  }

  /// Create a copy of AssignedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripCopyWith<$Res>? get tripDetails {
    if (_self.tripDetails == null) {
      return null;
    }

    return $TripCopyWith<$Res>(_self.tripDetails!, (value) {
      return _then(_self.copyWith(tripDetails: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AssignedRoute].
extension AssignedRoutePatterns on AssignedRoute {
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
    TResult Function(_AssignedRoute value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssignedRoute() when $default != null:
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
    TResult Function(_AssignedRoute value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssignedRoute():
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
    TResult? Function(_AssignedRoute value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssignedRoute() when $default != null:
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
            @JsonKey(fromJson: looseStringOrEmpty) String routeId,
            @JsonKey(fromJson: looseString) String? routeTitle,
            @JsonKey(fromJson: looseString) String? vehicleNumber,
            @JsonKey(fromJson: looseDateTime) DateTime? startTime,
            @JsonKey(unknownEnumValue: TripType.unknown) TripType tripType,
            @JsonKey(readValue: readTripStarted, fromJson: looseBool)
            bool tripStarted,
            @JsonKey(unknownEnumValue: TodayStatus.unknown)
            TodayStatus todayStatus,
            @JsonKey(readValue: readTripCompleted, fromJson: looseBool)
            bool tripCompleted,
            Trip? tripDetails,
            List<RoutePassenger> passengers)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssignedRoute() when $default != null:
        return $default(
            _that.routeId,
            _that.routeTitle,
            _that.vehicleNumber,
            _that.startTime,
            _that.tripType,
            _that.tripStarted,
            _that.todayStatus,
            _that.tripCompleted,
            _that.tripDetails,
            _that.passengers);
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
            @JsonKey(fromJson: looseStringOrEmpty) String routeId,
            @JsonKey(fromJson: looseString) String? routeTitle,
            @JsonKey(fromJson: looseString) String? vehicleNumber,
            @JsonKey(fromJson: looseDateTime) DateTime? startTime,
            @JsonKey(unknownEnumValue: TripType.unknown) TripType tripType,
            @JsonKey(readValue: readTripStarted, fromJson: looseBool)
            bool tripStarted,
            @JsonKey(unknownEnumValue: TodayStatus.unknown)
            TodayStatus todayStatus,
            @JsonKey(readValue: readTripCompleted, fromJson: looseBool)
            bool tripCompleted,
            Trip? tripDetails,
            List<RoutePassenger> passengers)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssignedRoute():
        return $default(
            _that.routeId,
            _that.routeTitle,
            _that.vehicleNumber,
            _that.startTime,
            _that.tripType,
            _that.tripStarted,
            _that.todayStatus,
            _that.tripCompleted,
            _that.tripDetails,
            _that.passengers);
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
            @JsonKey(fromJson: looseStringOrEmpty) String routeId,
            @JsonKey(fromJson: looseString) String? routeTitle,
            @JsonKey(fromJson: looseString) String? vehicleNumber,
            @JsonKey(fromJson: looseDateTime) DateTime? startTime,
            @JsonKey(unknownEnumValue: TripType.unknown) TripType tripType,
            @JsonKey(readValue: readTripStarted, fromJson: looseBool)
            bool tripStarted,
            @JsonKey(unknownEnumValue: TodayStatus.unknown)
            TodayStatus todayStatus,
            @JsonKey(readValue: readTripCompleted, fromJson: looseBool)
            bool tripCompleted,
            Trip? tripDetails,
            List<RoutePassenger> passengers)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssignedRoute() when $default != null:
        return $default(
            _that.routeId,
            _that.routeTitle,
            _that.vehicleNumber,
            _that.startTime,
            _that.tripType,
            _that.tripStarted,
            _that.todayStatus,
            _that.tripCompleted,
            _that.tripDetails,
            _that.passengers);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssignedRoute implements AssignedRoute {
  const _AssignedRoute(
      {@JsonKey(fromJson: looseStringOrEmpty) this.routeId = '',
      @JsonKey(fromJson: looseString) this.routeTitle,
      @JsonKey(fromJson: looseString) this.vehicleNumber,
      @JsonKey(fromJson: looseDateTime) this.startTime,
      @JsonKey(unknownEnumValue: TripType.unknown)
      this.tripType = TripType.unknown,
      @JsonKey(readValue: readTripStarted, fromJson: looseBool)
      this.tripStarted = false,
      @JsonKey(unknownEnumValue: TodayStatus.unknown)
      this.todayStatus = TodayStatus.unknown,
      @JsonKey(readValue: readTripCompleted, fromJson: looseBool)
      this.tripCompleted = false,
      this.tripDetails,
      final List<RoutePassenger> passengers = const <RoutePassenger>[]})
      : _passengers = passengers;
  factory _AssignedRoute.fromJson(Map<String, dynamic> json) =>
      _$AssignedRouteFromJson(json);

  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String routeId;
  @override
  @JsonKey(fromJson: looseString)
  final String? routeTitle;
  @override
  @JsonKey(fromJson: looseString)
  final String? vehicleNumber;

  /// UTC ISO timestamp; the app only uses hours and minutes of it.
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? startTime;
  @override
  @JsonKey(unknownEnumValue: TripType.unknown)
  final TripType tripType;

  /// Backend key is `TripStarted` (PascalCase).
  @override
  @JsonKey(readValue: readTripStarted, fromJson: looseBool)
  final bool tripStarted;

  /// Today's state of the route; a route can be run once a day.
  @override
  @JsonKey(unknownEnumValue: TodayStatus.unknown)
  final TodayStatus todayStatus;

  /// Backend key is `TripCompleted`: today's trip is already done.
  @override
  @JsonKey(readValue: readTripCompleted, fromJson: looseBool)
  final bool tripCompleted;

  /// The running trip, when [tripStarted].
  @override
  final Trip? tripDetails;
  final List<RoutePassenger> _passengers;
  @override
  @JsonKey()
  List<RoutePassenger> get passengers {
    if (_passengers is EqualUnmodifiableListView) return _passengers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passengers);
  }

  /// Create a copy of AssignedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssignedRouteCopyWith<_AssignedRoute> get copyWith =>
      __$AssignedRouteCopyWithImpl<_AssignedRoute>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssignedRouteToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssignedRoute &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.routeTitle, routeTitle) ||
                other.routeTitle == routeTitle) &&
            (identical(other.vehicleNumber, vehicleNumber) ||
                other.vehicleNumber == vehicleNumber) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.tripType, tripType) ||
                other.tripType == tripType) &&
            (identical(other.tripStarted, tripStarted) ||
                other.tripStarted == tripStarted) &&
            (identical(other.todayStatus, todayStatus) ||
                other.todayStatus == todayStatus) &&
            (identical(other.tripCompleted, tripCompleted) ||
                other.tripCompleted == tripCompleted) &&
            (identical(other.tripDetails, tripDetails) ||
                other.tripDetails == tripDetails) &&
            const DeepCollectionEquality()
                .equals(other._passengers, _passengers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      routeId,
      routeTitle,
      vehicleNumber,
      startTime,
      tripType,
      tripStarted,
      todayStatus,
      tripCompleted,
      tripDetails,
      const DeepCollectionEquality().hash(_passengers));

  @override
  String toString() {
    return 'AssignedRoute(routeId: $routeId, routeTitle: $routeTitle, vehicleNumber: $vehicleNumber, startTime: $startTime, tripType: $tripType, tripStarted: $tripStarted, todayStatus: $todayStatus, tripCompleted: $tripCompleted, tripDetails: $tripDetails, passengers: $passengers)';
  }
}

/// @nodoc
abstract mixin class _$AssignedRouteCopyWith<$Res>
    implements $AssignedRouteCopyWith<$Res> {
  factory _$AssignedRouteCopyWith(
          _AssignedRoute value, $Res Function(_AssignedRoute) _then) =
      __$AssignedRouteCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String routeId,
      @JsonKey(fromJson: looseString) String? routeTitle,
      @JsonKey(fromJson: looseString) String? vehicleNumber,
      @JsonKey(fromJson: looseDateTime) DateTime? startTime,
      @JsonKey(unknownEnumValue: TripType.unknown) TripType tripType,
      @JsonKey(readValue: readTripStarted, fromJson: looseBool)
      bool tripStarted,
      @JsonKey(unknownEnumValue: TodayStatus.unknown) TodayStatus todayStatus,
      @JsonKey(readValue: readTripCompleted, fromJson: looseBool)
      bool tripCompleted,
      Trip? tripDetails,
      List<RoutePassenger> passengers});

  @override
  $TripCopyWith<$Res>? get tripDetails;
}

/// @nodoc
class __$AssignedRouteCopyWithImpl<$Res>
    implements _$AssignedRouteCopyWith<$Res> {
  __$AssignedRouteCopyWithImpl(this._self, this._then);

  final _AssignedRoute _self;
  final $Res Function(_AssignedRoute) _then;

  /// Create a copy of AssignedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? routeId = null,
    Object? routeTitle = freezed,
    Object? vehicleNumber = freezed,
    Object? startTime = freezed,
    Object? tripType = null,
    Object? tripStarted = null,
    Object? todayStatus = null,
    Object? tripCompleted = null,
    Object? tripDetails = freezed,
    Object? passengers = null,
  }) {
    return _then(_AssignedRoute(
      routeId: null == routeId
          ? _self.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String,
      routeTitle: freezed == routeTitle
          ? _self.routeTitle
          : routeTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleNumber: freezed == vehicleNumber
          ? _self.vehicleNumber
          : vehicleNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripType: null == tripType
          ? _self.tripType
          : tripType // ignore: cast_nullable_to_non_nullable
              as TripType,
      tripStarted: null == tripStarted
          ? _self.tripStarted
          : tripStarted // ignore: cast_nullable_to_non_nullable
              as bool,
      todayStatus: null == todayStatus
          ? _self.todayStatus
          : todayStatus // ignore: cast_nullable_to_non_nullable
              as TodayStatus,
      tripCompleted: null == tripCompleted
          ? _self.tripCompleted
          : tripCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      tripDetails: freezed == tripDetails
          ? _self.tripDetails
          : tripDetails // ignore: cast_nullable_to_non_nullable
              as Trip?,
      passengers: null == passengers
          ? _self._passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<RoutePassenger>,
    ));
  }

  /// Create a copy of AssignedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripCopyWith<$Res>? get tripDetails {
    if (_self.tripDetails == null) {
      return null;
    }

    return $TripCopyWith<$Res>(_self.tripDetails!, (value) {
      return _then(_self.copyWith(tripDetails: value));
    });
  }
}

// dart format on
