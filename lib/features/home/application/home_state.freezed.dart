// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeState {
  /// Today's routes with their kids (empty when none or no van).
  List<AssignedRoute> get routes;

  /// The driver's trips.
  List<Trip> get trips;

  /// The server says this driver has no van — there is nothing to show
  /// today. (The screen treats it like "no trip today".)
  bool get noVan;

  /// Set when this load found a trip already running on the server that
  /// this phone was not tracking, and resumed tracking it.
  DateTime? get resumedAt;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeStateCopyWith<HomeState> get copyWith =>
      _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeState &&
            const DeepCollectionEquality().equals(other.routes, routes) &&
            const DeepCollectionEquality().equals(other.trips, trips) &&
            (identical(other.noVan, noVan) || other.noVan == noVan) &&
            (identical(other.resumedAt, resumedAt) ||
                other.resumedAt == resumedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(routes),
      const DeepCollectionEquality().hash(trips),
      noVan,
      resumedAt);

  @override
  String toString() {
    return 'HomeState(routes: $routes, trips: $trips, noVan: $noVan, resumedAt: $resumedAt)';
  }
}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) =
      _$HomeStateCopyWithImpl;
  @useResult
  $Res call(
      {List<AssignedRoute> routes,
      List<Trip> trips,
      bool noVan,
      DateTime? resumedAt});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res> implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routes = null,
    Object? trips = null,
    Object? noVan = null,
    Object? resumedAt = freezed,
  }) {
    return _then(_self.copyWith(
      routes: null == routes
          ? _self.routes
          : routes // ignore: cast_nullable_to_non_nullable
              as List<AssignedRoute>,
      trips: null == trips
          ? _self.trips
          : trips // ignore: cast_nullable_to_non_nullable
              as List<Trip>,
      noVan: null == noVan
          ? _self.noVan
          : noVan // ignore: cast_nullable_to_non_nullable
              as bool,
      resumedAt: freezed == resumedAt
          ? _self.resumedAt
          : resumedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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
    TResult Function(_HomeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
    TResult Function(_HomeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
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
    TResult? Function(_HomeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
    TResult Function(List<AssignedRoute> routes, List<Trip> trips, bool noVan,
            DateTime? resumedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(
            _that.routes, _that.trips, _that.noVan, _that.resumedAt);
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
    TResult Function(List<AssignedRoute> routes, List<Trip> trips, bool noVan,
            DateTime? resumedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
        return $default(
            _that.routes, _that.trips, _that.noVan, _that.resumedAt);
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
    TResult? Function(List<AssignedRoute> routes, List<Trip> trips, bool noVan,
            DateTime? resumedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(
            _that.routes, _that.trips, _that.noVan, _that.resumedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HomeState extends HomeState {
  const _HomeState(
      {final List<AssignedRoute> routes = const <AssignedRoute>[],
      final List<Trip> trips = const <Trip>[],
      this.noVan = false,
      this.resumedAt})
      : _routes = routes,
        _trips = trips,
        super._();

  /// Today's routes with their kids (empty when none or no van).
  final List<AssignedRoute> _routes;

  /// Today's routes with their kids (empty when none or no van).
  @override
  @JsonKey()
  List<AssignedRoute> get routes {
    if (_routes is EqualUnmodifiableListView) return _routes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routes);
  }

  /// The driver's trips.
  final List<Trip> _trips;

  /// The driver's trips.
  @override
  @JsonKey()
  List<Trip> get trips {
    if (_trips is EqualUnmodifiableListView) return _trips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trips);
  }

  /// The server says this driver has no van — there is nothing to show
  /// today. (The screen treats it like "no trip today".)
  @override
  @JsonKey()
  final bool noVan;

  /// Set when this load found a trip already running on the server that
  /// this phone was not tracking, and resumed tracking it.
  @override
  final DateTime? resumedAt;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeStateCopyWith<_HomeState> get copyWith =>
      __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeState &&
            const DeepCollectionEquality().equals(other._routes, _routes) &&
            const DeepCollectionEquality().equals(other._trips, _trips) &&
            (identical(other.noVan, noVan) || other.noVan == noVan) &&
            (identical(other.resumedAt, resumedAt) ||
                other.resumedAt == resumedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_routes),
      const DeepCollectionEquality().hash(_trips),
      noVan,
      resumedAt);

  @override
  String toString() {
    return 'HomeState(routes: $routes, trips: $trips, noVan: $noVan, resumedAt: $resumedAt)';
  }
}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(
          _HomeState value, $Res Function(_HomeState) _then) =
      __$HomeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<AssignedRoute> routes,
      List<Trip> trips,
      bool noVan,
      DateTime? resumedAt});
}

/// @nodoc
class __$HomeStateCopyWithImpl<$Res> implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? routes = null,
    Object? trips = null,
    Object? noVan = null,
    Object? resumedAt = freezed,
  }) {
    return _then(_HomeState(
      routes: null == routes
          ? _self._routes
          : routes // ignore: cast_nullable_to_non_nullable
              as List<AssignedRoute>,
      trips: null == trips
          ? _self._trips
          : trips // ignore: cast_nullable_to_non_nullable
              as List<Trip>,
      noVan: null == noVan
          ? _self.noVan
          : noVan // ignore: cast_nullable_to_non_nullable
              as bool,
      resumedAt: freezed == resumedAt
          ? _self.resumedAt
          : resumedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
