import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import 'models/pending_ratee.dart';
import 'models/rating_summary.dart';

/// The two-way trip rating, driver side: the driver's own rating and rating
/// the parents of a finished trip.
class RatingRepository {
  const RatingRepository(this._api);

  final ApiClient _api;

  /// `GET /rating/myRatingSummary`.
  Future<RatingSummary> mySummary() => _api.get(
        '/rating/myRatingSummary',
        (json) => RatingSummary.fromJson(asJsonMap(json ?? const {})),
      );

  /// `GET /rating/pendingRatings`, keeping only the rows of [tripId] — the
  /// parents on that trip the driver has not rated yet.
  Future<List<PendingRatee>> pendingForTrip(String tripId) => _api.get(
        '/rating/pendingRatings',
        (json) => asJsonList(json)
            .map(PendingRatee.fromJson)
            .where((r) => r.tripId == tripId)
            .toList(),
      );

  /// `POST /rating/rateTrip` — 1–5 [stars] and an optional [comment] for one
  /// parent of the trip (left out when null or empty).
  Future<void> rateTrip({
    required String tripId,
    required String rateeUserId,
    required int stars,
    String? comment,
  }) {
    return _api.post<void>(
      '/rating/rateTrip',
      (_) {},
      body: {
        'tripId': tripId,
        'rateeUserId': rateeUserId,
        'stars': stars,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
  }
}

final ratingRepositoryProvider = Provider<RatingRepository>(
    (ref) => RatingRepository(ref.watch(apiClientProvider)));
