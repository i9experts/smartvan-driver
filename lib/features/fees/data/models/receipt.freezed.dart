// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Receipt {
  @JsonKey(fromJson: looseString)
  String? get schoolName;
  @JsonKey(fromJson: looseString)
  String? get currency;
  @JsonKey(fromJson: looseDouble)
  double? get amount;
  @JsonKey(fromJson: looseString)
  String? get receiptNumber;
  @JsonKey(fromJson: looseString)
  String? get studentName;
  @JsonKey(fromJson: looseString)
  String? get grade;

  /// `YYYY-MM`.
  @JsonKey(fromJson: looseString)
  String? get month;
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  PaymentMethod get paymentMethod;
  @JsonKey(fromJson: looseDateTime)
  DateTime? get paidAt;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReceiptCopyWith<Receipt> get copyWith =>
      _$ReceiptCopyWithImpl<Receipt>(this as Receipt, _$identity);

  /// Serializes this Receipt to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Receipt &&
            (identical(other.schoolName, schoolName) ||
                other.schoolName == schoolName) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.receiptNumber, receiptNumber) ||
                other.receiptNumber == receiptNumber) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, schoolName, currency, amount,
      receiptNumber, studentName, grade, month, paymentMethod, paidAt);

  @override
  String toString() {
    return 'Receipt(schoolName: $schoolName, currency: $currency, amount: $amount, receiptNumber: $receiptNumber, studentName: $studentName, grade: $grade, month: $month, paymentMethod: $paymentMethod, paidAt: $paidAt)';
  }
}

/// @nodoc
abstract mixin class $ReceiptCopyWith<$Res> {
  factory $ReceiptCopyWith(Receipt value, $Res Function(Receipt) _then) =
      _$ReceiptCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? schoolName,
      @JsonKey(fromJson: looseString) String? currency,
      @JsonKey(fromJson: looseDouble) double? amount,
      @JsonKey(fromJson: looseString) String? receiptNumber,
      @JsonKey(fromJson: looseString) String? studentName,
      @JsonKey(fromJson: looseString) String? grade,
      @JsonKey(fromJson: looseString) String? month,
      @JsonKey(unknownEnumValue: PaymentMethod.unknown)
      PaymentMethod paymentMethod,
      @JsonKey(fromJson: looseDateTime) DateTime? paidAt});
}

/// @nodoc
class _$ReceiptCopyWithImpl<$Res> implements $ReceiptCopyWith<$Res> {
  _$ReceiptCopyWithImpl(this._self, this._then);

  final Receipt _self;
  final $Res Function(Receipt) _then;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schoolName = freezed,
    Object? currency = freezed,
    Object? amount = freezed,
    Object? receiptNumber = freezed,
    Object? studentName = freezed,
    Object? grade = freezed,
    Object? month = freezed,
    Object? paymentMethod = null,
    Object? paidAt = freezed,
  }) {
    return _then(_self.copyWith(
      schoolName: freezed == schoolName
          ? _self.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      receiptNumber: freezed == receiptNumber
          ? _self.receiptNumber
          : receiptNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      studentName: freezed == studentName
          ? _self.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      month: freezed == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      paidAt: freezed == paidAt
          ? _self.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Receipt].
extension ReceiptPatterns on Receipt {
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
    TResult Function(_Receipt value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Receipt() when $default != null:
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
    TResult Function(_Receipt value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Receipt():
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
    TResult? Function(_Receipt value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Receipt() when $default != null:
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
            @JsonKey(fromJson: looseString) String? schoolName,
            @JsonKey(fromJson: looseString) String? currency,
            @JsonKey(fromJson: looseDouble) double? amount,
            @JsonKey(fromJson: looseString) String? receiptNumber,
            @JsonKey(fromJson: looseString) String? studentName,
            @JsonKey(fromJson: looseString) String? grade,
            @JsonKey(fromJson: looseString) String? month,
            @JsonKey(unknownEnumValue: PaymentMethod.unknown)
            PaymentMethod paymentMethod,
            @JsonKey(fromJson: looseDateTime) DateTime? paidAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Receipt() when $default != null:
        return $default(
            _that.schoolName,
            _that.currency,
            _that.amount,
            _that.receiptNumber,
            _that.studentName,
            _that.grade,
            _that.month,
            _that.paymentMethod,
            _that.paidAt);
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
            @JsonKey(fromJson: looseString) String? schoolName,
            @JsonKey(fromJson: looseString) String? currency,
            @JsonKey(fromJson: looseDouble) double? amount,
            @JsonKey(fromJson: looseString) String? receiptNumber,
            @JsonKey(fromJson: looseString) String? studentName,
            @JsonKey(fromJson: looseString) String? grade,
            @JsonKey(fromJson: looseString) String? month,
            @JsonKey(unknownEnumValue: PaymentMethod.unknown)
            PaymentMethod paymentMethod,
            @JsonKey(fromJson: looseDateTime) DateTime? paidAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Receipt():
        return $default(
            _that.schoolName,
            _that.currency,
            _that.amount,
            _that.receiptNumber,
            _that.studentName,
            _that.grade,
            _that.month,
            _that.paymentMethod,
            _that.paidAt);
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
            @JsonKey(fromJson: looseString) String? schoolName,
            @JsonKey(fromJson: looseString) String? currency,
            @JsonKey(fromJson: looseDouble) double? amount,
            @JsonKey(fromJson: looseString) String? receiptNumber,
            @JsonKey(fromJson: looseString) String? studentName,
            @JsonKey(fromJson: looseString) String? grade,
            @JsonKey(fromJson: looseString) String? month,
            @JsonKey(unknownEnumValue: PaymentMethod.unknown)
            PaymentMethod paymentMethod,
            @JsonKey(fromJson: looseDateTime) DateTime? paidAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Receipt() when $default != null:
        return $default(
            _that.schoolName,
            _that.currency,
            _that.amount,
            _that.receiptNumber,
            _that.studentName,
            _that.grade,
            _that.month,
            _that.paymentMethod,
            _that.paidAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Receipt implements Receipt {
  const _Receipt(
      {@JsonKey(fromJson: looseString) this.schoolName,
      @JsonKey(fromJson: looseString) this.currency,
      @JsonKey(fromJson: looseDouble) this.amount,
      @JsonKey(fromJson: looseString) this.receiptNumber,
      @JsonKey(fromJson: looseString) this.studentName,
      @JsonKey(fromJson: looseString) this.grade,
      @JsonKey(fromJson: looseString) this.month,
      @JsonKey(unknownEnumValue: PaymentMethod.unknown)
      this.paymentMethod = PaymentMethod.unknown,
      @JsonKey(fromJson: looseDateTime) this.paidAt});
  factory _Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);

  @override
  @JsonKey(fromJson: looseString)
  final String? schoolName;
  @override
  @JsonKey(fromJson: looseString)
  final String? currency;
  @override
  @JsonKey(fromJson: looseDouble)
  final double? amount;
  @override
  @JsonKey(fromJson: looseString)
  final String? receiptNumber;
  @override
  @JsonKey(fromJson: looseString)
  final String? studentName;
  @override
  @JsonKey(fromJson: looseString)
  final String? grade;

  /// `YYYY-MM`.
  @override
  @JsonKey(fromJson: looseString)
  final String? month;
  @override
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  final PaymentMethod paymentMethod;
  @override
  @JsonKey(fromJson: looseDateTime)
  final DateTime? paidAt;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReceiptCopyWith<_Receipt> get copyWith =>
      __$ReceiptCopyWithImpl<_Receipt>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReceiptToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Receipt &&
            (identical(other.schoolName, schoolName) ||
                other.schoolName == schoolName) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.receiptNumber, receiptNumber) ||
                other.receiptNumber == receiptNumber) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, schoolName, currency, amount,
      receiptNumber, studentName, grade, month, paymentMethod, paidAt);

  @override
  String toString() {
    return 'Receipt(schoolName: $schoolName, currency: $currency, amount: $amount, receiptNumber: $receiptNumber, studentName: $studentName, grade: $grade, month: $month, paymentMethod: $paymentMethod, paidAt: $paidAt)';
  }
}

/// @nodoc
abstract mixin class _$ReceiptCopyWith<$Res> implements $ReceiptCopyWith<$Res> {
  factory _$ReceiptCopyWith(_Receipt value, $Res Function(_Receipt) _then) =
      __$ReceiptCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? schoolName,
      @JsonKey(fromJson: looseString) String? currency,
      @JsonKey(fromJson: looseDouble) double? amount,
      @JsonKey(fromJson: looseString) String? receiptNumber,
      @JsonKey(fromJson: looseString) String? studentName,
      @JsonKey(fromJson: looseString) String? grade,
      @JsonKey(fromJson: looseString) String? month,
      @JsonKey(unknownEnumValue: PaymentMethod.unknown)
      PaymentMethod paymentMethod,
      @JsonKey(fromJson: looseDateTime) DateTime? paidAt});
}

/// @nodoc
class __$ReceiptCopyWithImpl<$Res> implements _$ReceiptCopyWith<$Res> {
  __$ReceiptCopyWithImpl(this._self, this._then);

  final _Receipt _self;
  final $Res Function(_Receipt) _then;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? schoolName = freezed,
    Object? currency = freezed,
    Object? amount = freezed,
    Object? receiptNumber = freezed,
    Object? studentName = freezed,
    Object? grade = freezed,
    Object? month = freezed,
    Object? paymentMethod = null,
    Object? paidAt = freezed,
  }) {
    return _then(_Receipt(
      schoolName: freezed == schoolName
          ? _self.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      receiptNumber: freezed == receiptNumber
          ? _self.receiptNumber
          : receiptNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      studentName: freezed == studentName
          ? _self.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      month: freezed == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      paidAt: freezed == paidAt
          ? _self.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
