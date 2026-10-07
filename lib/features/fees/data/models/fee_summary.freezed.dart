// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fee_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeeSummary {
  @JsonKey(fromJson: looseString)
  String? get currency;

  /// Students who have paid.
  @JsonKey(fromJson: _int)
  int get paid;

  /// Students in total.
  @JsonKey(fromJson: _int)
  int get students;
  @JsonKey(fromJson: _double)
  double get collectedByYou;
  @JsonKey(fromJson: _double)
  double get collectedOnline;
  @JsonKey(fromJson: _double)
  double get totalPending;

  /// Create a copy of FeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeeSummaryCopyWith<FeeSummary> get copyWith =>
      _$FeeSummaryCopyWithImpl<FeeSummary>(this as FeeSummary, _$identity);

  /// Serializes this FeeSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeeSummary &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paid, paid) || other.paid == paid) &&
            (identical(other.students, students) ||
                other.students == students) &&
            (identical(other.collectedByYou, collectedByYou) ||
                other.collectedByYou == collectedByYou) &&
            (identical(other.collectedOnline, collectedOnline) ||
                other.collectedOnline == collectedOnline) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currency, paid, students,
      collectedByYou, collectedOnline, totalPending);

  @override
  String toString() {
    return 'FeeSummary(currency: $currency, paid: $paid, students: $students, collectedByYou: $collectedByYou, collectedOnline: $collectedOnline, totalPending: $totalPending)';
  }
}

/// @nodoc
abstract mixin class $FeeSummaryCopyWith<$Res> {
  factory $FeeSummaryCopyWith(
          FeeSummary value, $Res Function(FeeSummary) _then) =
      _$FeeSummaryCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? currency,
      @JsonKey(fromJson: _int) int paid,
      @JsonKey(fromJson: _int) int students,
      @JsonKey(fromJson: _double) double collectedByYou,
      @JsonKey(fromJson: _double) double collectedOnline,
      @JsonKey(fromJson: _double) double totalPending});
}

/// @nodoc
class _$FeeSummaryCopyWithImpl<$Res> implements $FeeSummaryCopyWith<$Res> {
  _$FeeSummaryCopyWithImpl(this._self, this._then);

  final FeeSummary _self;
  final $Res Function(FeeSummary) _then;

  /// Create a copy of FeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = freezed,
    Object? paid = null,
    Object? students = null,
    Object? collectedByYou = null,
    Object? collectedOnline = null,
    Object? totalPending = null,
  }) {
    return _then(_self.copyWith(
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      paid: null == paid
          ? _self.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as int,
      students: null == students
          ? _self.students
          : students // ignore: cast_nullable_to_non_nullable
              as int,
      collectedByYou: null == collectedByYou
          ? _self.collectedByYou
          : collectedByYou // ignore: cast_nullable_to_non_nullable
              as double,
      collectedOnline: null == collectedOnline
          ? _self.collectedOnline
          : collectedOnline // ignore: cast_nullable_to_non_nullable
              as double,
      totalPending: null == totalPending
          ? _self.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeeSummary].
extension FeeSummaryPatterns on FeeSummary {
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
    TResult Function(_FeeSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeeSummary() when $default != null:
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
    TResult Function(_FeeSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeeSummary():
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
    TResult? Function(_FeeSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeeSummary() when $default != null:
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
            @JsonKey(fromJson: looseString) String? currency,
            @JsonKey(fromJson: _int) int paid,
            @JsonKey(fromJson: _int) int students,
            @JsonKey(fromJson: _double) double collectedByYou,
            @JsonKey(fromJson: _double) double collectedOnline,
            @JsonKey(fromJson: _double) double totalPending)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeeSummary() when $default != null:
        return $default(_that.currency, _that.paid, _that.students,
            _that.collectedByYou, _that.collectedOnline, _that.totalPending);
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
            @JsonKey(fromJson: looseString) String? currency,
            @JsonKey(fromJson: _int) int paid,
            @JsonKey(fromJson: _int) int students,
            @JsonKey(fromJson: _double) double collectedByYou,
            @JsonKey(fromJson: _double) double collectedOnline,
            @JsonKey(fromJson: _double) double totalPending)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeeSummary():
        return $default(_that.currency, _that.paid, _that.students,
            _that.collectedByYou, _that.collectedOnline, _that.totalPending);
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
            @JsonKey(fromJson: looseString) String? currency,
            @JsonKey(fromJson: _int) int paid,
            @JsonKey(fromJson: _int) int students,
            @JsonKey(fromJson: _double) double collectedByYou,
            @JsonKey(fromJson: _double) double collectedOnline,
            @JsonKey(fromJson: _double) double totalPending)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeeSummary() when $default != null:
        return $default(_that.currency, _that.paid, _that.students,
            _that.collectedByYou, _that.collectedOnline, _that.totalPending);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FeeSummary implements FeeSummary {
  const _FeeSummary(
      {@JsonKey(fromJson: looseString) this.currency,
      @JsonKey(fromJson: _int) this.paid = 0,
      @JsonKey(fromJson: _int) this.students = 0,
      @JsonKey(fromJson: _double) this.collectedByYou = 0,
      @JsonKey(fromJson: _double) this.collectedOnline = 0,
      @JsonKey(fromJson: _double) this.totalPending = 0});
  factory _FeeSummary.fromJson(Map<String, dynamic> json) =>
      _$FeeSummaryFromJson(json);

  @override
  @JsonKey(fromJson: looseString)
  final String? currency;

  /// Students who have paid.
  @override
  @JsonKey(fromJson: _int)
  final int paid;

  /// Students in total.
  @override
  @JsonKey(fromJson: _int)
  final int students;
  @override
  @JsonKey(fromJson: _double)
  final double collectedByYou;
  @override
  @JsonKey(fromJson: _double)
  final double collectedOnline;
  @override
  @JsonKey(fromJson: _double)
  final double totalPending;

  /// Create a copy of FeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeeSummaryCopyWith<_FeeSummary> get copyWith =>
      __$FeeSummaryCopyWithImpl<_FeeSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FeeSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeeSummary &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paid, paid) || other.paid == paid) &&
            (identical(other.students, students) ||
                other.students == students) &&
            (identical(other.collectedByYou, collectedByYou) ||
                other.collectedByYou == collectedByYou) &&
            (identical(other.collectedOnline, collectedOnline) ||
                other.collectedOnline == collectedOnline) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currency, paid, students,
      collectedByYou, collectedOnline, totalPending);

  @override
  String toString() {
    return 'FeeSummary(currency: $currency, paid: $paid, students: $students, collectedByYou: $collectedByYou, collectedOnline: $collectedOnline, totalPending: $totalPending)';
  }
}

/// @nodoc
abstract mixin class _$FeeSummaryCopyWith<$Res>
    implements $FeeSummaryCopyWith<$Res> {
  factory _$FeeSummaryCopyWith(
          _FeeSummary value, $Res Function(_FeeSummary) _then) =
      __$FeeSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? currency,
      @JsonKey(fromJson: _int) int paid,
      @JsonKey(fromJson: _int) int students,
      @JsonKey(fromJson: _double) double collectedByYou,
      @JsonKey(fromJson: _double) double collectedOnline,
      @JsonKey(fromJson: _double) double totalPending});
}

/// @nodoc
class __$FeeSummaryCopyWithImpl<$Res> implements _$FeeSummaryCopyWith<$Res> {
  __$FeeSummaryCopyWithImpl(this._self, this._then);

  final _FeeSummary _self;
  final $Res Function(_FeeSummary) _then;

  /// Create a copy of FeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currency = freezed,
    Object? paid = null,
    Object? students = null,
    Object? collectedByYou = null,
    Object? collectedOnline = null,
    Object? totalPending = null,
  }) {
    return _then(_FeeSummary(
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      paid: null == paid
          ? _self.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as int,
      students: null == students
          ? _self.students
          : students // ignore: cast_nullable_to_non_nullable
              as int,
      collectedByYou: null == collectedByYou
          ? _self.collectedByYou
          : collectedByYou // ignore: cast_nullable_to_non_nullable
              as double,
      collectedOnline: null == collectedOnline
          ? _self.collectedOnline
          : collectedOnline // ignore: cast_nullable_to_non_nullable
              as double,
      totalPending: null == totalPending
          ? _self.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
