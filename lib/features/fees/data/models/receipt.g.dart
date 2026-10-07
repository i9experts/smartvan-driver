// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Receipt _$ReceiptFromJson(Map<String, dynamic> json) => _Receipt(
      schoolName: looseString(json['schoolName']),
      currency: looseString(json['currency']),
      amount: looseDouble(json['amount']),
      receiptNumber: looseString(json['receiptNumber']),
      studentName: looseString(json['studentName']),
      grade: looseString(json['grade']),
      month: looseString(json['month']),
      paymentMethod: $enumDecodeNullable(
              _$PaymentMethodEnumMap, json['paymentMethod'],
              unknownValue: PaymentMethod.unknown) ??
          PaymentMethod.unknown,
      paidAt: looseDateTime(json['paidAt']),
    );

Map<String, dynamic> _$ReceiptToJson(_Receipt instance) => <String, dynamic>{
      'schoolName': instance.schoolName,
      'currency': instance.currency,
      'amount': instance.amount,
      'receiptNumber': instance.receiptNumber,
      'studentName': instance.studentName,
      'grade': instance.grade,
      'month': instance.month,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'paidAt': instance.paidAt?.toIso8601String(),
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
