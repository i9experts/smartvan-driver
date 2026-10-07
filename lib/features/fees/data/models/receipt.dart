import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'payment_method.dart';

part 'receipt.freezed.dart';
part 'receipt.g.dart';

/// `GET /fees/receipt/{paymentId}` → `data`.
@freezed
abstract class Receipt with _$Receipt {
  const factory Receipt({
    @JsonKey(fromJson: looseString) String? schoolName,
    @JsonKey(fromJson: looseString) String? currency,
    @JsonKey(fromJson: looseDouble) double? amount,
    @JsonKey(fromJson: looseString) String? receiptNumber,
    @JsonKey(fromJson: looseString) String? studentName,
    @JsonKey(fromJson: looseString) String? grade,

    /// `YYYY-MM`.
    @JsonKey(fromJson: looseString) String? month,
    @JsonKey(unknownEnumValue: PaymentMethod.unknown)
    @Default(PaymentMethod.unknown)
    PaymentMethod paymentMethod,
    @JsonKey(fromJson: looseDateTime) DateTime? paidAt,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
}
