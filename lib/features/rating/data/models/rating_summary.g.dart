// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RatingSummary _$RatingSummaryFromJson(Map<String, dynamic> json) =>
    _RatingSummary(
      avgRating: json['avgRating'] == null ? 0 : _double(json['avgRating']),
      ratingCount: json['ratingCount'] == null ? 0 : _int(json['ratingCount']),
      completedTripCount: json['completedTripCount'] == null
          ? 0
          : _int(json['completedTripCount']),
    );

Map<String, dynamic> _$RatingSummaryToJson(_RatingSummary instance) =>
    <String, dynamic>{
      'avgRating': instance.avgRating,
      'ratingCount': instance.ratingCount,
      'completedTripCount': instance.completedTripCount,
    };
