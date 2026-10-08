// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fee_student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeeStudent {
  @JsonKey(fromJson: looseStringOrEmpty)
  String get kidId;

  /// `YYYY-MM`.
  @JsonKey(fromJson: looseStringOrEmpty)
  String get month;
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  String get fullname;
  @JsonKey(fromJson: looseString)
  String? get image;
  @JsonKey(fromJson: looseString)
  String? get grade;
  @JsonKey(readValue: readStatusLower, unknownEnumValue: PaymentStatus.unknown)
  PaymentStatus get status;

  /// Arrives as a number or a numeric string.
  @JsonKey(fromJson: looseDouble)
  double? get amount;
  @JsonKey(fromJson: looseString)
  String? get currency;
  @JsonKey(fromJson: looseString)
  String? get paymentId;

  /// False for a student who is no longer on the van (no fee is made for
  /// them). Older answers have no such key: those students are active.
  @JsonKey(fromJson: _activeFrom)
  bool get active;

  /// Create a copy of FeeStudent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeeStudentCopyWith<FeeStudent> get copyWith =>
      _$FeeStudentCopyWithImpl<FeeStudent>(this as FeeStudent, _$identity);

  /// Serializes this FeeStudent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeeStudent &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, month, fullname, image,
      grade, status, amount, currency, paymentId, active);

  @override
  String toString() {
    return 'FeeStudent(kidId: $kidId, month: $month, fullname: $fullname, image: $image, grade: $grade, status: $status, amount: $amount, currency: $currency, paymentId: $paymentId, active: $active)';
  }
}

/// @nodoc
abstract mixin class $FeeStudentCopyWith<$Res> {
  factory $FeeStudentCopyWith(
          FeeStudent value, $Res Function(FeeStudent) _then) =
      _$FeeStudentCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String kidId,
      @JsonKey(fromJson: looseStringOrEmpty) String month,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(fromJson: looseString) String? image,
      @JsonKey(fromJson: looseString) String? grade,
      @JsonKey(
          readValue: readStatusLower, unknownEnumValue: PaymentStatus.unknown)
      PaymentStatus status,
      @JsonKey(fromJson: looseDouble) double? amount,
      @JsonKey(fromJson: looseString) String? currency,
      @JsonKey(fromJson: looseString) String? paymentId,
      @JsonKey(fromJson: _activeFrom) bool active});
}

/// @nodoc
class _$FeeStudentCopyWithImpl<$Res> implements $FeeStudentCopyWith<$Res> {
  _$FeeStudentCopyWithImpl(this._self, this._then);

  final FeeStudent _self;
  final $Res Function(FeeStudent) _then;

  /// Create a copy of FeeStudent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kidId = null,
    Object? month = null,
    Object? fullname = null,
    Object? image = freezed,
    Object? grade = freezed,
    Object? status = null,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? paymentId = freezed,
    Object? active = null,
  }) {
    return _then(_self.copyWith(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: freezed == paymentId
          ? _self.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeeStudent].
extension FeeStudentPatterns on FeeStudent {
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
    TResult Function(_FeeStudent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeeStudent() when $default != null:
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
    TResult Function(_FeeStudent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeeStudent():
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
    TResult? Function(_FeeStudent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeeStudent() when $default != null:
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
            @JsonKey(fromJson: looseStringOrEmpty) String month,
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname,
            @JsonKey(fromJson: looseString) String? image,
            @JsonKey(fromJson: looseString) String? grade,
            @JsonKey(
                readValue: readStatusLower,
                unknownEnumValue: PaymentStatus.unknown)
            PaymentStatus status,
            @JsonKey(fromJson: looseDouble) double? amount,
            @JsonKey(fromJson: looseString) String? currency,
            @JsonKey(fromJson: looseString) String? paymentId,
            @JsonKey(fromJson: _activeFrom) bool active)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeeStudent() when $default != null:
        return $default(
            _that.kidId,
            _that.month,
            _that.fullname,
            _that.image,
            _that.grade,
            _that.status,
            _that.amount,
            _that.currency,
            _that.paymentId,
            _that.active);
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
            @JsonKey(fromJson: looseStringOrEmpty) String month,
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname,
            @JsonKey(fromJson: looseString) String? image,
            @JsonKey(fromJson: looseString) String? grade,
            @JsonKey(
                readValue: readStatusLower,
                unknownEnumValue: PaymentStatus.unknown)
            PaymentStatus status,
            @JsonKey(fromJson: looseDouble) double? amount,
            @JsonKey(fromJson: looseString) String? currency,
            @JsonKey(fromJson: looseString) String? paymentId,
            @JsonKey(fromJson: _activeFrom) bool active)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeeStudent():
        return $default(
            _that.kidId,
            _that.month,
            _that.fullname,
            _that.image,
            _that.grade,
            _that.status,
            _that.amount,
            _that.currency,
            _that.paymentId,
            _that.active);
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
            @JsonKey(fromJson: looseStringOrEmpty) String month,
            @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
            String fullname,
            @JsonKey(fromJson: looseString) String? image,
            @JsonKey(fromJson: looseString) String? grade,
            @JsonKey(
                readValue: readStatusLower,
                unknownEnumValue: PaymentStatus.unknown)
            PaymentStatus status,
            @JsonKey(fromJson: looseDouble) double? amount,
            @JsonKey(fromJson: looseString) String? currency,
            @JsonKey(fromJson: looseString) String? paymentId,
            @JsonKey(fromJson: _activeFrom) bool active)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeeStudent() when $default != null:
        return $default(
            _that.kidId,
            _that.month,
            _that.fullname,
            _that.image,
            _that.grade,
            _that.status,
            _that.amount,
            _that.currency,
            _that.paymentId,
            _that.active);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FeeStudent implements FeeStudent {
  const _FeeStudent(
      {@JsonKey(fromJson: looseStringOrEmpty) this.kidId = '',
      @JsonKey(fromJson: looseStringOrEmpty) this.month = '',
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      this.fullname = '',
      @JsonKey(fromJson: looseString) this.image,
      @JsonKey(fromJson: looseString) this.grade,
      @JsonKey(
          readValue: readStatusLower, unknownEnumValue: PaymentStatus.unknown)
      this.status = PaymentStatus.unknown,
      @JsonKey(fromJson: looseDouble) this.amount,
      @JsonKey(fromJson: looseString) this.currency,
      @JsonKey(fromJson: looseString) this.paymentId,
      @JsonKey(fromJson: _activeFrom) this.active = true});
  factory _FeeStudent.fromJson(Map<String, dynamic> json) =>
      _$FeeStudentFromJson(json);

  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String kidId;

  /// `YYYY-MM`.
  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String month;
  @override
  @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
  final String fullname;
  @override
  @JsonKey(fromJson: looseString)
  final String? image;
  @override
  @JsonKey(fromJson: looseString)
  final String? grade;
  @override
  @JsonKey(readValue: readStatusLower, unknownEnumValue: PaymentStatus.unknown)
  final PaymentStatus status;

  /// Arrives as a number or a numeric string.
  @override
  @JsonKey(fromJson: looseDouble)
  final double? amount;
  @override
  @JsonKey(fromJson: looseString)
  final String? currency;
  @override
  @JsonKey(fromJson: looseString)
  final String? paymentId;

  /// False for a student who is no longer on the van (no fee is made for
  /// them). Older answers have no such key: those students are active.
  @override
  @JsonKey(fromJson: _activeFrom)
  final bool active;

  /// Create a copy of FeeStudent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeeStudentCopyWith<_FeeStudent> get copyWith =>
      __$FeeStudentCopyWithImpl<_FeeStudent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FeeStudentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeeStudent &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, month, fullname, image,
      grade, status, amount, currency, paymentId, active);

  @override
  String toString() {
    return 'FeeStudent(kidId: $kidId, month: $month, fullname: $fullname, image: $image, grade: $grade, status: $status, amount: $amount, currency: $currency, paymentId: $paymentId, active: $active)';
  }
}

/// @nodoc
abstract mixin class _$FeeStudentCopyWith<$Res>
    implements $FeeStudentCopyWith<$Res> {
  factory _$FeeStudentCopyWith(
          _FeeStudent value, $Res Function(_FeeStudent) _then) =
      __$FeeStudentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseStringOrEmpty) String kidId,
      @JsonKey(fromJson: looseStringOrEmpty) String month,
      @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
      String fullname,
      @JsonKey(fromJson: looseString) String? image,
      @JsonKey(fromJson: looseString) String? grade,
      @JsonKey(
          readValue: readStatusLower, unknownEnumValue: PaymentStatus.unknown)
      PaymentStatus status,
      @JsonKey(fromJson: looseDouble) double? amount,
      @JsonKey(fromJson: looseString) String? currency,
      @JsonKey(fromJson: looseString) String? paymentId,
      @JsonKey(fromJson: _activeFrom) bool active});
}

/// @nodoc
class __$FeeStudentCopyWithImpl<$Res> implements _$FeeStudentCopyWith<$Res> {
  __$FeeStudentCopyWithImpl(this._self, this._then);

  final _FeeStudent _self;
  final $Res Function(_FeeStudent) _then;

  /// Create a copy of FeeStudent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kidId = null,
    Object? month = null,
    Object? fullname = null,
    Object? image = freezed,
    Object? grade = freezed,
    Object? status = null,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? paymentId = freezed,
    Object? active = null,
  }) {
    return _then(_FeeStudent(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      fullname: null == fullname
          ? _self.fullname
          : fullname // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: freezed == paymentId
          ? _self.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
