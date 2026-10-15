// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completed_trips_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompletedTripsPage {
  List<CompletedTrip> get items;
  int get total;
  int get page;
  int get limit;
  bool get hasMore;

  /// Create a copy of CompletedTripsPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompletedTripsPageCopyWith<CompletedTripsPage> get copyWith =>
      _$CompletedTripsPageCopyWithImpl<CompletedTripsPage>(
          this as CompletedTripsPage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompletedTripsPage &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(items), total, page, limit, hasMore);

  @override
  String toString() {
    return 'CompletedTripsPage(items: $items, total: $total, page: $page, limit: $limit, hasMore: $hasMore)';
  }
}

/// @nodoc
abstract mixin class $CompletedTripsPageCopyWith<$Res> {
  factory $CompletedTripsPageCopyWith(
          CompletedTripsPage value, $Res Function(CompletedTripsPage) _then) =
      _$CompletedTripsPageCopyWithImpl;
  @useResult
  $Res call(
      {List<CompletedTrip> items,
      int total,
      int page,
      int limit,
      bool hasMore});
}

/// @nodoc
class _$CompletedTripsPageCopyWithImpl<$Res>
    implements $CompletedTripsPageCopyWith<$Res> {
  _$CompletedTripsPageCopyWithImpl(this._self, this._then);

  final CompletedTripsPage _self;
  final $Res Function(CompletedTripsPage) _then;

  /// Create a copy of CompletedTripsPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? hasMore = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CompletedTrip>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [CompletedTripsPage].
extension CompletedTripsPagePatterns on CompletedTripsPage {
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
    TResult Function(_CompletedTripsPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CompletedTripsPage() when $default != null:
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
    TResult Function(_CompletedTripsPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompletedTripsPage():
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
    TResult? Function(_CompletedTripsPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompletedTripsPage() when $default != null:
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
    TResult Function(List<CompletedTrip> items, int total, int page, int limit,
            bool hasMore)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CompletedTripsPage() when $default != null:
        return $default(
            _that.items, _that.total, _that.page, _that.limit, _that.hasMore);
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
    TResult Function(List<CompletedTrip> items, int total, int page, int limit,
            bool hasMore)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompletedTripsPage():
        return $default(
            _that.items, _that.total, _that.page, _that.limit, _that.hasMore);
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
    TResult? Function(List<CompletedTrip> items, int total, int page, int limit,
            bool hasMore)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompletedTripsPage() when $default != null:
        return $default(
            _that.items, _that.total, _that.page, _that.limit, _that.hasMore);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CompletedTripsPage extends CompletedTripsPage {
  const _CompletedTripsPage(
      {final List<CompletedTrip> items = const <CompletedTrip>[],
      this.total = 0,
      this.page = 1,
      this.limit = 20,
      this.hasMore = false})
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

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final bool hasMore;

  /// Create a copy of CompletedTripsPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompletedTripsPageCopyWith<_CompletedTripsPage> get copyWith =>
      __$CompletedTripsPageCopyWithImpl<_CompletedTripsPage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompletedTripsPage &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), total, page, limit, hasMore);

  @override
  String toString() {
    return 'CompletedTripsPage(items: $items, total: $total, page: $page, limit: $limit, hasMore: $hasMore)';
  }
}

/// @nodoc
abstract mixin class _$CompletedTripsPageCopyWith<$Res>
    implements $CompletedTripsPageCopyWith<$Res> {
  factory _$CompletedTripsPageCopyWith(
          _CompletedTripsPage value, $Res Function(_CompletedTripsPage) _then) =
      __$CompletedTripsPageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<CompletedTrip> items,
      int total,
      int page,
      int limit,
      bool hasMore});
}

/// @nodoc
class __$CompletedTripsPageCopyWithImpl<$Res>
    implements _$CompletedTripsPageCopyWith<$Res> {
  __$CompletedTripsPageCopyWithImpl(this._self, this._then);

  final _CompletedTripsPage _self;
  final $Res Function(_CompletedTripsPage) _then;

  /// Create a copy of CompletedTripsPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? hasMore = null,
  }) {
    return _then(_CompletedTripsPage(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CompletedTrip>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
