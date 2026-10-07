// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeeSummary _$FeeSummaryFromJson(Map<String, dynamic> json) => _FeeSummary(
      currency: looseString(json['currency']),
      paid: json['paid'] == null ? 0 : _int(json['paid']),
      students: json['students'] == null ? 0 : _int(json['students']),
      collectedByYou:
          json['collectedByYou'] == null ? 0 : _double(json['collectedByYou']),
      collectedOnline: json['collectedOnline'] == null
          ? 0
          : _double(json['collectedOnline']),
      totalPending:
          json['totalPending'] == null ? 0 : _double(json['totalPending']),
    );

Map<String, dynamic> _$FeeSummaryToJson(_FeeSummary instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'paid': instance.paid,
      'students': instance.students,
      'collectedByYou': instance.collectedByYou,
      'collectedOnline': instance.collectedOnline,
      'totalPending': instance.totalPending,
    };
