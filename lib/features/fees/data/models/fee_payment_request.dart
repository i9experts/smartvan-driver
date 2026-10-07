import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment_method.dart';

part 'fee_payment_request.freezed.dart';
part 'fee_payment_request.g.dart';

/// Body of `POST /fees/record-payment` (the driver records cash).
@freezed
abstract class FeePaymentRequest with _$FeePaymentRequest {
  const factory FeePaymentRequest({
    required String kidId,

    /// `YYYY-MM`.
    required String month,
    @JsonKey(unknownEnumValue: PaymentMethod.unknown)
    @Default(PaymentMethod.cash)
    PaymentMethod paymentMethod,
  }) = _FeePaymentRequest;

  factory FeePaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$FeePaymentRequestFromJson(json);
}
