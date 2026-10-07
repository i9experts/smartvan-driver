// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeeStudent _$FeeStudentFromJson(Map<String, dynamic> json) => _FeeStudent(
      kidId: json['kidId'] == null ? '' : looseStringOrEmpty(json['kidId']),
      month: json['month'] == null ? '' : looseStringOrEmpty(json['month']),
      fullname: readFullname(json, 'fullname') == null
          ? ''
          : looseStringOrEmpty(readFullname(json, 'fullname')),
      image: looseString(json['image']),
      grade: looseString(json['grade']),
      status: $enumDecodeNullable(
              _$PaymentStatusEnumMap, readStatusLower(json, 'status'),
              unknownValue: PaymentStatus.unknown) ??
          PaymentStatus.notGenerated,
      amount: looseDouble(json['amount']),
      currency: looseString(json['currency']),
      paymentId: looseString(json['paymentId']),
    );

Map<String, dynamic> _$FeeStudentToJson(_FeeStudent instance) =>
    <String, dynamic>{
      'kidId': instance.kidId,
      'month': instance.month,
      'fullname': instance.fullname,
      'image': instance.image,
      'grade': instance.grade,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'paymentId': instance.paymentId,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.paid: 'paid',
  PaymentStatus.overdue: 'overdue',
  PaymentStatus.pending: 'pending',
  PaymentStatus.notGenerated: 'not_generated',
  PaymentStatus.unknown: 'unknown',
};
