// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripHistoryState {
  List<CompletedTrip> get items;

  /// The last page loaded.
  int get page;
  bool get hasMore;
  bool get loadingMore;

  /// The last "load more" failed (the list stays; a retry row shows).
  bool get loadMoreFailed;

  /// null = All, else only trips of this direction.
  TripType? get filter;

  /// Create a copy of TripHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TripHistoryStateCopyWith<TripHistoryState> get copyWith =>
      _$TripHistoryStateCopyWithImpl<TripHistoryState>(
          this as TripHistoryState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TripHistoryState &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.loadingMore, loadingMore) ||
                other.loadingMore == loadingMore) &&
            (identical(other.loadMoreFailed, loadMoreFailed) ||
                other.loadMoreFailed == loadMoreFailed) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(items),
      page,
      hasMore,
      loadingMore,
      loadMoreFailed,
      filter);

  @override
  String toString() {
    return 'TripHistoryState(items: $items, page: $page, hasMore: $hasMore, loadingMore: $loadingMore, loadMoreFailed: $loadMoreFailed, filter: $filter)';
  }
}

/// @nodoc
abstract mixin class $TripHistoryStateCopyWith<$Res> {
  factory $TripHistoryStateCopyWith(
          TripHistoryState value, $Res Function(TripHistoryState) _then) =
      _$TripHistoryStateCopyWithImpl;
  @useResult
  $Res call(
      {List<CompletedTrip> items,
      int page,
      bool hasMore,
      bool loadingMore,
      bool loadMoreFailed,
      TripType? filter});
}

/// @nodoc
class _$TripHistoryStateCopyWithImpl<$Res>
    implements $TripHistoryStateCopyWith<$Res> {
  _$TripHistoryStateCopyWithImpl(this._self, this._then);

  final TripHistoryState _self;
  final $Res Function(TripHistoryState) _then;

  /// Create a copy of TripHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? hasMore = null,
    Object? loadingMore = null,
    Object? loadMoreFailed = null,
    Object? filter = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CompletedTrip>,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMore: null == loadingMore
          ? _self.loadingMore
          : loadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadMoreFailed: null == loadMoreFailed
          ? _self.loadMoreFailed
          : loadMoreFailed // ignore: cast_nullable_to_non_nullable
              as bool,
      filter: freezed == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as TripType?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TripHistoryState].
extension TripHistoryStatePatterns on TripHistoryState {
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
    TResult Function(_TripHistoryState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripHistoryState() when $default != null:
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
    TResult Function(_TripHistoryState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripHistoryState():
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
    TResult? Function(_TripHistoryState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripHistoryState() when $default != null:
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
    TResult Function(List<CompletedTrip> items, int page, bool hasMore,
            bool loadingMore, bool loadMoreFailed, TripType? filter)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TripHistoryState() when $default != null:
        return $default(_that.items, _that.page, _that.hasMore,
            _that.loadingMore, _that.loadMoreFailed, _that.filter);
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
    TResult Function(List<CompletedTrip> items, int page, bool hasMore,
            bool loadingMore, bool loadMoreFailed, TripType? filter)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripHistoryState():
        return $default(_that.items, _that.page, _that.hasMore,
            _that.loadingMore, _that.loadMoreFailed, _that.filter);
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
    TResult? Function(List<CompletedTrip> items, int page, bool hasMore,
            bool loadingMore, bool loadMoreFailed, TripType? filter)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TripHistoryState() when $default != null:
        return $default(_that.items, _that.page, _that.hasMore,
            _that.loadingMore, _that.loadMoreFailed, _that.filter);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TripHistoryState extends TripHistoryState {
  const _TripHistoryState(
      {final List<CompletedTrip> items = const <CompletedTrip>[],
      this.page = 1,
      this.hasMore = false,
      this.loadingMore = false,
      this.loadMoreFailed = false,
      this.filter})
      : _items = items,
        super._();

  final List<CompletedTrip> _items;
  @override
  @JsonKey()
  List<CompletedTrip> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// The last page loaded.
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool loadingMore;

  /// The last "load more" failed (the list stays; a retry row shows).
  @override
  @JsonKey()
  final bool loadMoreFailed;

  /// null = All, else only trips of this direction.
  @override
  final TripType? filter;

  /// Create a copy of TripHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TripHistoryStateCopyWith<_TripHistoryState> get copyWith =>
      __$TripHistoryStateCopyWithImpl<_TripHistoryState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TripHistoryState &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.loadingMore, loadingMore) ||
                other.loadingMore == loadingMore) &&
            (identical(other.loadMoreFailed, loadMoreFailed) ||
                other.loadMoreFailed == loadMoreFailed) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      page,
      hasMore,
      loadingMore,
      loadMoreFailed,
      filter);

  @override
  String toString() {
    return 'TripHistoryState(items: $items, page: $page, hasMore: $hasMore, loadingMore: $loadingMore, loadMoreFailed: $loadMoreFailed, filter: $filter)';
  }
}

/// @nodoc
abstract mixin class _$TripHistoryStateCopyWith<$Res>
    implements $TripHistoryStateCopyWith<$Res> {
  factory _$TripHistoryStateCopyWith(
          _TripHistoryState value, $Res Function(_TripHistoryState) _then) =
      __$TripHistoryStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<CompletedTrip> items,
      int page,
      bool hasMore,
      bool loadingMore,
      bool loadMoreFailed,
      TripType? filter});
}

/// @nodoc
class __$TripHistoryStateCopyWithImpl<$Res>
    implements _$TripHistoryStateCopyWith<$Res> {
  __$TripHistoryStateCopyWithImpl(this._self, this._then);

  final _TripHistoryState _self;
  final $Res Function(_TripHistoryState) _then;

  /// Create a copy of TripHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? hasMore = null,
    Object? loadingMore = null,
    Object? loadMoreFailed = null,
    Object? filter = freezed,
  }) {
    return _then(_TripHistoryState(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CompletedTrip>,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMore: null == loadingMore
          ? _self.loadingMore
          : loadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadMoreFailed: null == loadMoreFailed
          ? _self.loadMoreFailed
          : loadMoreFailed // ignore: cast_nullable_to_non_nullable
              as bool,
      filter: freezed == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as TripType?,
    ));
  }
}

// dart format on
