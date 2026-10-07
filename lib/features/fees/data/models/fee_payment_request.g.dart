// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeePaymentRequest _$FeePaymentRequestFromJson(Map<String, dynamic> json) =>
    _FeePaymentRequest(
      kidId: json['kidId'] as String,
      month: json['month'] as String,
      paymentMethod: $enumDecodeNullable(
              _$PaymentMethodEnumMap, json['paymentMethod'],
              unknownValue: PaymentMethod.unknown) ??
          PaymentMethod.cash,
    );

Map<String, dynamic> _$FeePaymentRequestToJson(_FeePaymentRequest instance) =>
    <String, dynamic>{
      'kidId': instance.kidId,
      'month': instance.month,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.jazzcash: 'jazzcash',
  PaymentMethod.easypaisa: 'easypaisa',
  PaymentMethod.raast: 'raast',
  PaymentMethod.bankTransfer: 'bank_transfer',
  PaymentMethod.card: 'card',
  PaymentMethod.unknown: 'unknown',
};
