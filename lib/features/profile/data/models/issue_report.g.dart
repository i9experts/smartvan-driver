// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IssueReport _$IssueReportFromJson(Map<String, dynamic> json) => _IssueReport(
      issueType: $enumDecodeNullable(_$IssueTypeEnumMap, json['issueType'],
              unknownValue: IssueType.unknown) ??
          IssueType.other,
      description: json['description'] == null
          ? ''
          : looseStringOrEmpty(json['description']),
      type: json['type'] as String? ?? 'driverReport',
      image: looseString(json['image']),
    );

Map<String, dynamic> _$IssueReportToJson(_IssueReport instance) =>
    <String, dynamic>{
      'issueType': _$IssueTypeEnumMap[instance.issueType]!,
      'description': instance.description,
      'type': instance.type,
      if (instance.image case final value?) 'image': value,
    };

const _$IssueTypeEnumMap = {
  IssueType.vehicleIssue: 'Vehicle Issue',
  IssueType.runningLate: 'Running Late',
  IssueType.passengerNoShow: 'Passenger No-Show',
  IssueType.emergency: 'Emergency',
  IssueType.trackingNotWorking: 'Tracking Not Working',
  IssueType.other: 'Other',
  IssueType.unknown: 'unknown',
};
