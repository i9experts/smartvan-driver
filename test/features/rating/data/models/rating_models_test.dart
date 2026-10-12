import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';
import 'package:smartvan_driver/features/rating/data/models/pending_ratee.dart';
import 'package:smartvan_driver/features/rating/data/models/rating_summary.dart';

import '../../../../support/fixture.dart';

void main() {
  test('parses a pending ratee, with and without name and image', () {
    final rows = asJsonList(unwrapData(fixture('rating/pending_ratings.json')))
        .map(PendingRatee.fromJson)
        .toList();
    expect(rows[0].tripId, 'trip-001');
    expect(rows[0].parentId, 'p-1');
    expect(rows[0].parentName, 'Test Parent One');
    expect(rows[0].parentImage, 'https://img.test/p1.jpg');
    expect(rows[1].parentName, isNull);
    expect(rows[1].parentImage, isNull);
  });

  test('parses the rating summary', () {
    final s = RatingSummary.fromJson(
        asJsonMap(unwrapData(fixture('rating/my_rating_summary.json'))));
    expect(s.avgRating, 4.6);
    expect(s.ratingCount, 12);
    expect(s.completedTripCount, 87);
  });

  test('summary: numbers as strings, whole numbers, empty object', () {
    final s = RatingSummary.fromJson(
        {'avgRating': '4', 'ratingCount': 3.0, 'completedTripCount': '9'});
    expect(s.avgRating, 4.0);
    expect(s.ratingCount, 3);
    expect(s.completedTripCount, 9);
    expect(RatingSummary.fromJson({}), const RatingSummary());
  });
}
