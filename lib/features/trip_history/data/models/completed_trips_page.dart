import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'completed_trip.dart';

part 'completed_trips_page.freezed.dart';

/// `GET /driver/trips/completed` → `data`: one page, newest first.
@freezed
abstract class CompletedTripsPage with _$CompletedTripsPage {
  const CompletedTripsPage._();

  const factory CompletedTripsPage({
    @Default(<CompletedTrip>[]) List<CompletedTrip> items,
    @Default(0) int total,
    @Default(1) int page,
    @Default(20) int limit,
    @Default(false) bool hasMore,
  }) = _CompletedTripsPage;

  factory CompletedTripsPage.fromJson(Map<String, dynamic> json) {
    final items =
        asJsonList(json['items']).map(CompletedTrip.fromJson).toList();
    return CompletedTripsPage(
      items: items,
      total: looseInt(json['total']) ?? items.length,
      page: looseInt(json['page']) ?? 1,
      limit: looseInt(json['limit']) ?? 20,
      hasMore: looseBool(json['hasMore']),
    );
  }
}
