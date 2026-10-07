// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fee_payment_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeePaymentRequest {
  String get kidId;

  /// `YYYY-MM`.
  String get month;
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  PaymentMethod get paymentMethod;

  /// Create a copy of FeePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeePaymentRequestCopyWith<FeePaymentRequest> get copyWith =>
      _$FeePaymentRequestCopyWithImpl<FeePaymentRequest>(
          this as FeePaymentRequest, _$identity);

  /// Serializes this FeePaymentRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeePaymentRequest &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, month, paymentMethod);

  @override
  String toString() {
    return 'FeePaymentRequest(kidId: $kidId, month: $month, paymentMethod: $paymentMethod)';
  }
}

/// @nodoc
abstract mixin class $FeePaymentRequestCopyWith<$Res> {
  factory $FeePaymentRequestCopyWith(
          FeePaymentRequest value, $Res Function(FeePaymentRequest) _then) =
      _$FeePaymentRequestCopyWithImpl;
  @useResult
  $Res call(
      {String kidId,
      String month,
      @JsonKey(unknownEnumValue: PaymentMethod.unknown)
      PaymentMethod paymentMethod});
}

/// @nodoc
class _$FeePaymentRequestCopyWithImpl<$Res>
    implements $FeePaymentRequestCopyWith<$Res> {
  _$FeePaymentRequestCopyWithImpl(this._self, this._then);

  final FeePaymentRequest _self;
  final $Res Function(FeePaymentRequest) _then;

  /// Create a copy of FeePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kidId = null,
    Object? month = null,
    Object? paymentMethod = null,
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
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeePaymentRequest].
extension FeePaymentRequestPatterns on FeePaymentRequest {
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
    TResult Function(_FeePaymentRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeePaymentRequest() when $default != null:
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
    TResult Function(_FeePaymentRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeePaymentRequest():
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
    TResult? Function(_FeePaymentRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeePaymentRequest() when $default != null:
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
            String kidId,
            String month,
            @JsonKey(unknownEnumValue: PaymentMethod.unknown)
            PaymentMethod paymentMethod)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeePaymentRequest() when $default != null:
        return $default(_that.kidId, _that.month, _that.paymentMethod);
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
            String kidId,
            String month,
            @JsonKey(unknownEnumValue: PaymentMethod.unknown)
            PaymentMethod paymentMethod)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeePaymentRequest():
        return $default(_that.kidId, _that.month, _that.paymentMethod);
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
            String kidId,
            String month,
            @JsonKey(unknownEnumValue: PaymentMethod.unknown)
            PaymentMethod paymentMethod)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeePaymentRequest() when $default != null:
        return $default(_that.kidId, _that.month, _that.paymentMethod);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FeePaymentRequest implements FeePaymentRequest {
  const _FeePaymentRequest(
      {required this.kidId,
      required this.month,
      @JsonKey(unknownEnumValue: PaymentMethod.unknown)
      this.paymentMethod = PaymentMethod.cash});
  factory _FeePaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$FeePaymentRequestFromJson(json);

  @override
  final String kidId;

  /// `YYYY-MM`.
  @override
  final String month;
  @override
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  final PaymentMethod paymentMethod;

  /// Create a copy of FeePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeePaymentRequestCopyWith<_FeePaymentRequest> get copyWith =>
      __$FeePaymentRequestCopyWithImpl<_FeePaymentRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FeePaymentRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeePaymentRequest &&
            (identical(other.kidId, kidId) || other.kidId == kidId) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kidId, month, paymentMethod);

  @override
  String toString() {
    return 'FeePaymentRequest(kidId: $kidId, month: $month, paymentMethod: $paymentMethod)';
  }
}

/// @nodoc
abstract mixin class _$FeePaymentRequestCopyWith<$Res>
    implements $FeePaymentRequestCopyWith<$Res> {
  factory _$FeePaymentRequestCopyWith(
          _FeePaymentRequest value, $Res Function(_FeePaymentRequest) _then) =
      __$FeePaymentRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String kidId,
      String month,
      @JsonKey(unknownEnumValue: PaymentMethod.unknown)
      PaymentMethod paymentMethod});
}

/// @nodoc
class __$FeePaymentRequestCopyWithImpl<$Res>
    implements _$FeePaymentRequestCopyWith<$Res> {
  __$FeePaymentRequestCopyWithImpl(this._self, this._then);

  final _FeePaymentRequest _self;
  final $Res Function(_FeePaymentRequest) _then;

  /// Create a copy of FeePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kidId = null,
    Object? month = null,
    Object? paymentMethod = null,
  }) {
    return _then(_FeePaymentRequest(
      kidId: null == kidId
          ? _self.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
    ));
  }
}

// dart format on
