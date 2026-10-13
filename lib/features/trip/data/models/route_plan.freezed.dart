// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoutePlan {
  @JsonKey(fromJson: looseInt)
  int? get nextStopOrder;
  List<RoutePlanStop> get stops;
  RoutePlanSchool? get school;
  PlannedPath? get plannedPath;

  /// Create a copy of RoutePlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoutePlanCopyWith<RoutePlan> get copyWith =>
      _$RoutePlanCopyWithImpl<RoutePlan>(this as RoutePlan, _$identity);

  /// Serializes this RoutePlan to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoutePlan &&
            (identical(other.nextStopOrder, nextStopOrder) ||
                other.nextStopOrder == nextStopOrder) &&
            const DeepCollectionEquality().equals(other.stops, stops) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.plannedPath, plannedPath) ||
                other.plannedPath == plannedPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nextStopOrder,
      const DeepCollectionEquality().hash(stops), school, plannedPath);

  @override
  String toString() {
    return 'RoutePlan(nextStopOrder: $nextStopOrder, stops: $stops, school: $school, plannedPath: $plannedPath)';
  }
}

/// @nodoc
abstract mixin class $RoutePlanCopyWith<$Res> {
  factory $RoutePlanCopyWith(RoutePlan value, $Res Function(RoutePlan) _then) =
      _$RoutePlanCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseInt) int? nextStopOrder,
      List<RoutePlanStop> stops,
      RoutePlanSchool? school,
      PlannedPath? plannedPath});

  $RoutePlanSchoolCopyWith<$Res>? get school;
  $PlannedPathCopyWith<$Res>? get plannedPath;
}

/// @nodoc
class _$RoutePlanCopyWithImpl<$Res> implements $RoutePlanCopyWith<$Res> {
  _$RoutePlanCopyWithImpl(this._self, this._then);

  final RoutePlan _self;
  final $Res Function(RoutePlan) _then;

  /// Create a copy of RoutePlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nextStopOrder = freezed,
    Object? stops = null,
    Object? school = freezed,
    Object? plannedPath = freezed,
  }) {
    return _then(_self.copyWith(
      nextStopOrder: freezed == nextStopOrder
          ? _self.nextStopOrder
          : nextStopOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      stops: null == stops
          ? _self.stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<RoutePlanStop>,
      school: freezed == school
          ? _self.school
          : school // ignore: cast_nullable_to_non_nullable
              as RoutePlanSchool?,
      plannedPath: freezed == plannedPath
          ? _self.plannedPath
          : plannedPath // ignore: cast_nullable_to_non_nullable
              as PlannedPath?,
    ));
  }

  /// Create a copy of RoutePlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoutePlanSchoolCopyWith<$Res>? get school {
    if (_self.school == null) {
      return null;
    }

    return $RoutePlanSchoolCopyWith<$Res>(_self.school!, (value) {
      return _then(_self.copyWith(school: value));
    });
  }

  /// Create a copy of RoutePlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlannedPathCopyWith<$Res>? get plannedPath {
    if (_self.plannedPath == null) {
      return null;
    }

    return $PlannedPathCopyWith<$Res>(_self.plannedPath!, (value) {
      return _then(_self.copyWith(plannedPath: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RoutePlan].
extension RoutePlanPatterns on RoutePlan {
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
    TResult Function(_RoutePlan value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RoutePlan() when $default != null:
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
    TResult Function(_RoutePlan value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlan():
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
    TResult? Function(_RoutePlan value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlan() when $default != null:
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
            @JsonKey(fromJson: looseInt) int? nextStopOrder,
            List<RoutePlanStop> stops,
            RoutePlanSchool? school,
            PlannedPath? plannedPath)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RoutePlan() when $default != null:
        return $default(
            _that.nextStopOrder, _that.stops, _that.school, _that.plannedPath);
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
            @JsonKey(fromJson: looseInt) int? nextStopOrder,
            List<RoutePlanStop> stops,
            RoutePlanSchool? school,
            PlannedPath? plannedPath)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlan():
        return $default(
            _that.nextStopOrder, _that.stops, _that.school, _that.plannedPath);
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
            @JsonKey(fromJson: looseInt) int? nextStopOrder,
            List<RoutePlanStop> stops,
            RoutePlanSchool? school,
            PlannedPath? plannedPath)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlan() when $default != null:
        return $default(
            _that.nextStopOrder, _that.stops, _that.school, _that.plannedPath);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RoutePlan extends RoutePlan {
  const _RoutePlan(
      {@JsonKey(fromJson: looseInt) this.nextStopOrder,
      final List<RoutePlanStop> stops = const <RoutePlanStop>[],
      this.school,
      this.plannedPath})
      : _stops = stops,
        super._();
  factory _RoutePlan.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanFromJson(json);

  @override
  @JsonKey(fromJson: looseInt)
  final int? nextStopOrder;
  final List<RoutePlanStop> _stops;
  @override
  @JsonKey()
  List<RoutePlanStop> get stops {
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stops);
  }

  @override
  final RoutePlanSchool? school;
  @override
  final PlannedPath? plannedPath;

  /// Create a copy of RoutePlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoutePlanCopyWith<_RoutePlan> get copyWith =>
      __$RoutePlanCopyWithImpl<_RoutePlan>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RoutePlanToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoutePlan &&
            (identical(other.nextStopOrder, nextStopOrder) ||
                other.nextStopOrder == nextStopOrder) &&
            const DeepCollectionEquality().equals(other._stops, _stops) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.plannedPath, plannedPath) ||
                other.plannedPath == plannedPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nextStopOrder,
      const DeepCollectionEquality().hash(_stops), school, plannedPath);

  @override
  String toString() {
    return 'RoutePlan(nextStopOrder: $nextStopOrder, stops: $stops, school: $school, plannedPath: $plannedPath)';
  }
}

/// @nodoc
abstract mixin class _$RoutePlanCopyWith<$Res>
    implements $RoutePlanCopyWith<$Res> {
  factory _$RoutePlanCopyWith(
          _RoutePlan value, $Res Function(_RoutePlan) _then) =
      __$RoutePlanCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseInt) int? nextStopOrder,
      List<RoutePlanStop> stops,
      RoutePlanSchool? school,
      PlannedPath? plannedPath});

  @override
  $RoutePlanSchoolCopyWith<$Res>? get school;
  @override
  $PlannedPathCopyWith<$Res>? get plannedPath;
}

/// @nodoc
class __$RoutePlanCopyWithImpl<$Res> implements _$RoutePlanCopyWith<$Res> {
  __$RoutePlanCopyWithImpl(this._self, this._then);

  final _RoutePlan _self;
  final $Res Function(_RoutePlan) _then;

  /// Create a copy of RoutePlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? nextStopOrder = freezed,
    Object? stops = null,
    Object? school = freezed,
    Object? plannedPath = freezed,
  }) {
    return _then(_RoutePlan(
      nextStopOrder: freezed == nextStopOrder
          ? _self.nextStopOrder
          : nextStopOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      stops: null == stops
          ? _self._stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<RoutePlanStop>,
      school: freezed == school
          ? _self.school
          : school // ignore: cast_nullable_to_non_nullable
              as RoutePlanSchool?,
      plannedPath: freezed == plannedPath
          ? _self.plannedPath
          : plannedPath // ignore: cast_nullable_to_non_nullable
              as PlannedPath?,
    ));
  }

  /// Create a copy of RoutePlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoutePlanSchoolCopyWith<$Res>? get school {
    if (_self.school == null) {
      return null;
    }

    return $RoutePlanSchoolCopyWith<$Res>(_self.school!, (value) {
      return _then(_self.copyWith(school: value));
    });
  }

  /// Create a copy of RoutePlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlannedPathCopyWith<$Res>? get plannedPath {
    if (_self.plannedPath == null) {
      return null;
    }

    return $PlannedPathCopyWith<$Res>(_self.plannedPath!, (value) {
      return _then(_self.copyWith(plannedPath: value));
    });
  }
}

/// @nodoc
mixin _$RoutePlanStop {
  /// 1-based position in the visiting order.
  @JsonKey(fromJson: _order)
  int get order;
  @JsonKey(fromJson: looseString)
  String? get kidId;
  @JsonKey(fromJson: looseString)
  String? get fullname;
  @JsonKey(fromJson: looseDouble)
  double? get lat;
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  double? get lng;
  @JsonKey(unknownEnumValue: StopStatus.unknown)
  StopStatus get status;

  /// Create a copy of RoutePlanStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoutePlanStopCopyWith<RoutePlanStop> get copyWith =>
      _$RoutePlanStopCopyWithImpl<RoutePlanStop>(
          this as RoutePlanStop, _$identity);

  /// Serializes this RoutePlanStop to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoutePlanStop &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, order, kidId, fullname, lat, lng, status);

  @override
  String toString() {
    return 'RoutePlanStop(order: $order, kidId: $kidId, fullname: $fullname, lat: $lat, lng: $lng, status: $status)';
  }
}

/// @nodoc
abstract mixin class $RoutePlanStopCopyWith<$Res> {
  factory $RoutePlanStopCopyWith(
          RoutePlanStop value, $Res Function(RoutePlanStop) _then) =
      _$RoutePlanStopCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _order) int order,
      @JsonKey(fromJson: looseString) String? kidId,
      @JsonKey(fromJson: looseString) String? fullname,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
      @JsonKey(unknownEnumValue: StopStatus.unknown) StopStatus status});
}

/// @nodoc
class _$RoutePlanStopCopyWithImpl<$Res>
    implements $RoutePlanStopCopyWith<$Res> {
  _$RoutePlanStopCopyWithImpl(this._self, this._then);

  final RoutePlanStop _self;
  final $Res Function(RoutePlanStop) _then;

  /// Create a copy of RoutePlanStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? kidId = freezed,
    Object? fullname = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      kidId: freezed == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String?,
      fullname: freezed == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as StopStatus,
    ));
  }
}

/// Adds pattern-matching-related methods to [RoutePlanStop].
extension RoutePlanStopPatterns on RoutePlanStop {
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
    TResult Function(_RoutePlanStop value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RoutePlanStop() when $default != null:
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
    TResult Function(_RoutePlanStop value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlanStop():
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
    TResult? Function(_RoutePlanStop value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlanStop() when $default != null:
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
            @JsonKey(fromJson: looseString) String? kidId,
            @JsonKey(fromJson: looseString) String? fullname,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
            @JsonKey(unknownEnumValue: StopStatus.unknown) StopStatus status)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RoutePlanStop() when $default != null:
        return $default(_that.order, _that.kidId, _that.fullname, _that.lat,
            _that.lng, _that.status);
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
            @JsonKey(fromJson: looseString) String? kidId,
            @JsonKey(fromJson: looseString) String? fullname,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
            @JsonKey(unknownEnumValue: StopStatus.unknown) StopStatus status)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlanStop():
        return $default(_that.order, _that.kidId, _that.fullname, _that.lat,
            _that.lng, _that.status);
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
            @JsonKey(fromJson: looseString) String? kidId,
            @JsonKey(fromJson: looseString) String? fullname,
            @JsonKey(fromJson: looseDouble) double? lat,
            @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
            @JsonKey(unknownEnumValue: StopStatus.unknown) StopStatus status)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlanStop() when $default != null:
        return $default(_that.order, _that.kidId, _that.fullname, _that.lat,
            _that.lng, _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RoutePlanStop implements RoutePlanStop {
  const _RoutePlanStop(
      {@JsonKey(fromJson: _order) this.order = 0,
      @JsonKey(fromJson: looseString) this.kidId,
      @JsonKey(fromJson: looseString) this.fullname,
      @JsonKey(fromJson: looseDouble) this.lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) this.lng,
      @JsonKey(unknownEnumValue: StopStatus.unknown)
      this.status = StopStatus.waiting});
  factory _RoutePlanStop.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanStopFromJson(json);

  /// 1-based position in the visiting order.
  @override
  @JsonKey(fromJson: _order)
  final int order;
  @override
  @JsonKey(fromJson: looseString)
  final String? kidId;
  @override
  @JsonKey(fromJson: looseString)
  final String? fullname;
  @override
  @JsonKey(fromJson: looseDouble)
  final double? lat;
  @override
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  final double? lng;
  @override
  @JsonKey(unknownEnumValue: StopStatus.unknown)
  final StopStatus status;

  /// Create a copy of RoutePlanStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoutePlanStopCopyWith<_RoutePlanStop> get copyWith =>
      __$RoutePlanStopCopyWithImpl<_RoutePlanStop>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RoutePlanStopToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoutePlanStop &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, order, kidId, fullname, lat, lng, status);

  @override
  String toString() {
    return 'RoutePlanStop(order: $order, kidId: $kidId, fullname: $fullname, lat: $lat, lng: $lng, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$RoutePlanStopCopyWith<$Res>
    implements $RoutePlanStopCopyWith<$Res> {
  factory _$RoutePlanStopCopyWith(
          _RoutePlanStop value, $Res Function(_RoutePlanStop) _then) =
      __$RoutePlanStopCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _order) int order,
      @JsonKey(fromJson: looseString) String? kidId,
      @JsonKey(fromJson: looseString) String? fullname,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng,
      @JsonKey(unknownEnumValue: StopStatus.unknown) StopStatus status});
}

/// @nodoc
class __$RoutePlanStopCopyWithImpl<$Res>
    implements _$RoutePlanStopCopyWith<$Res> {
  __$RoutePlanStopCopyWithImpl(this._self, this._then);

  final _RoutePlanStop _self;
  final $Res Function(_RoutePlanStop) _then;

  /// Create a copy of RoutePlanStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? order = null,
    Object? kidId = freezed,
    Object? fullname = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? status = null,
  }) {
    return _then(_RoutePlanStop(
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      kidId: freezed == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String?,
      fullname: freezed == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as StopStatus,
    ));
  }
}

/// @nodoc
mixin _$RoutePlanSchool {
  @JsonKey(fromJson: looseString)
  String? get name;
  @JsonKey(fromJson: looseDouble)
  double? get lat;
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  double? get lng;

  /// Create a copy of RoutePlanSchool
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoutePlanSchoolCopyWith<RoutePlanSchool> get copyWith =>
      _$RoutePlanSchoolCopyWithImpl<RoutePlanSchool>(
          this as RoutePlanSchool, _$identity);

  /// Serializes this RoutePlanSchool to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoutePlanSchool &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, lat, lng);

  @override
  String toString() {
    return 'RoutePlanSchool(name: $name, lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class $RoutePlanSchoolCopyWith<$Res> {
  factory $RoutePlanSchoolCopyWith(
          RoutePlanSchool value, $Res Function(RoutePlanSchool) _then) =
      _$RoutePlanSchoolCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? name,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng});
}

/// @nodoc
class _$RoutePlanSchoolCopyWithImpl<$Res>
    implements $RoutePlanSchoolCopyWith<$Res> {
  _$RoutePlanSchoolCopyWithImpl(this._self, this._then);

  final RoutePlanSchool _self;
  final $Res Function(RoutePlanSchool) _then;

  /// Create a copy of RoutePlanSchool
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

/// Adds pattern-matching-related methods to [RoutePlanSchool].
extension RoutePlanSchoolPatterns on RoutePlanSchool {
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
    TResult Function(_RoutePlanSchool value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RoutePlanSchool() when $default != null:
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
    TResult Function(_RoutePlanSchool value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlanSchool():
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
    TResult? Function(_RoutePlanSchool value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RoutePlanSchool() when $default != null:
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
      case _RoutePlanSchool() when $default != null:
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
      case _RoutePlanSchool():
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
      case _RoutePlanSchool() when $default != null:
        return $default(_that.name, _that.lat, _that.lng);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RoutePlanSchool implements RoutePlanSchool {
  const _RoutePlanSchool(
      {@JsonKey(fromJson: looseString) this.name,
      @JsonKey(fromJson: looseDouble) this.lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) this.lng});
  factory _RoutePlanSchool.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanSchoolFromJson(json);

  @override
  @JsonKey(fromJson: looseString)
  final String? name;
  @override
  @JsonKey(fromJson: looseDouble)
  final double? lat;
  @override
  @JsonKey(readValue: readLng, fromJson: looseDouble)
  final double? lng;

  /// Create a copy of RoutePlanSchool
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoutePlanSchoolCopyWith<_RoutePlanSchool> get copyWith =>
      __$RoutePlanSchoolCopyWithImpl<_RoutePlanSchool>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RoutePlanSchoolToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoutePlanSchool &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, lat, lng);

  @override
  String toString() {
    return 'RoutePlanSchool(name: $name, lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class _$RoutePlanSchoolCopyWith<$Res>
    implements $RoutePlanSchoolCopyWith<$Res> {
  factory _$RoutePlanSchoolCopyWith(
          _RoutePlanSchool value, $Res Function(_RoutePlanSchool) _then) =
      __$RoutePlanSchoolCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? name,
      @JsonKey(fromJson: looseDouble) double? lat,
      @JsonKey(readValue: readLng, fromJson: looseDouble) double? lng});
}

/// @nodoc
class __$RoutePlanSchoolCopyWithImpl<$Res>
    implements _$RoutePlanSchoolCopyWith<$Res> {
  __$RoutePlanSchoolCopyWithImpl(this._self, this._then);

  final _RoutePlanSchool _self;
  final $Res Function(_RoutePlanSchool) _then;

  /// Create a copy of RoutePlanSchool
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_RoutePlanSchool(
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
mixin _$PlannedPath {
  @JsonKey(fromJson: looseString)
  String? get polyline;

  /// Create a copy of PlannedPath
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlannedPathCopyWith<PlannedPath> get copyWith =>
      _$PlannedPathCopyWithImpl<PlannedPath>(this as PlannedPath, _$identity);

  /// Serializes this PlannedPath to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlannedPath &&
            (identical(other.polyline, polyline) ||
                other.polyline == polyline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, polyline);

  @override
  String toString() {
    return 'PlannedPath(polyline: $polyline)';
  }
}

/// @nodoc
abstract mixin class $PlannedPathCopyWith<$Res> {
  factory $PlannedPathCopyWith(
          PlannedPath value, $Res Function(PlannedPath) _then) =
      _$PlannedPathCopyWithImpl;
  @useResult
  $Res call({@JsonKey(fromJson: looseString) String? polyline});
}

/// @nodoc
class _$PlannedPathCopyWithImpl<$Res> implements $PlannedPathCopyWith<$Res> {
  _$PlannedPathCopyWithImpl(this._self, this._then);

  final PlannedPath _self;
  final $Res Function(PlannedPath) _then;

  /// Create a copy of PlannedPath
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? polyline = freezed,
  }) {
    return _then(_self.copyWith(
      polyline: freezed == polyline
          ? _self.polyline
          : polyline // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlannedPath].
extension PlannedPathPatterns on PlannedPath {
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
    TResult Function(_PlannedPath value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlannedPath() when $default != null:
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
    TResult Function(_PlannedPath value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlannedPath():
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
    TResult? Function(_PlannedPath value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlannedPath() when $default != null:
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
    TResult Function(@JsonKey(fromJson: looseString) String? polyline)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlannedPath() when $default != null:
        return $default(_that.polyline);
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
    TResult Function(@JsonKey(fromJson: looseString) String? polyline) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlannedPath():
        return $default(_that.polyline);
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
    TResult? Function(@JsonKey(fromJson: looseString) String? polyline)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlannedPath() when $default != null:
        return $default(_that.polyline);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PlannedPath implements PlannedPath {
  const _PlannedPath({@JsonKey(fromJson: looseString) this.polyline});
  factory _PlannedPath.fromJson(Map<String, dynamic> json) =>
      _$PlannedPathFromJson(json);

  @override
  @JsonKey(fromJson: looseString)
  final String? polyline;

  /// Create a copy of PlannedPath
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlannedPathCopyWith<_PlannedPath> get copyWith =>
      __$PlannedPathCopyWithImpl<_PlannedPath>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlannedPathToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlannedPath &&
            (identical(other.polyline, polyline) ||
                other.polyline == polyline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, polyline);

  @override
  String toString() {
    return 'PlannedPath(polyline: $polyline)';
  }
}

/// @nodoc
abstract mixin class _$PlannedPathCopyWith<$Res>
    implements $PlannedPathCopyWith<$Res> {
  factory _$PlannedPathCopyWith(
          _PlannedPath value, $Res Function(_PlannedPath) _then) =
      __$PlannedPathCopyWithImpl;
  @override
  @useResult
  $Res call({@JsonKey(fromJson: looseString) String? polyline});
}

/// @nodoc
class __$PlannedPathCopyWithImpl<$Res> implements _$PlannedPathCopyWith<$Res> {
  __$PlannedPathCopyWithImpl(this._self, this._then);

  final _PlannedPath _self;
  final $Res Function(_PlannedPath) _then;

  /// Create a copy of PlannedPath
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? polyline = freezed,
  }) {
    return _then(_PlannedPath(
      polyline: freezed == polyline
          ? _self.polyline
          : polyline // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
