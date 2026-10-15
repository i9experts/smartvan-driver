import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import 'models/completed_trips_page.dart';
import 'models/trip_details.dart';

/// Which completed trips to list.
enum HistoryScope { today, all }

/// The driver's finished trips (docs: PHASE4_API.md §7).
///
/// Errors: `TRIP_NOT_FOUND` (404) and `TRIP_NOT_YOURS` (403) from [details].
class TripHistoryRepository {
  const TripHistoryRepository(this._api);

  final ApiClient _api;

  /// `GET /driver/trips/completed?scope=&page=&limit=` — newest first.
  Future<CompletedTripsPage> completed({
    HistoryScope scope = HistoryScope.all,
    int page = 1,
    int limit = 20,
  }) =>
      _api.get(
        '/driver/trips/completed',
        (json) => CompletedTripsPage.fromJson(asJsonMap(json)),
        query: {'scope': scope.name, 'page': page, 'limit': limit},
      );

  /// `GET /driver/trips/:id/details`.
  Future<TripDetails> details(String tripId) => _api.get(
        '/driver/trips/${Uri.encodeComponent(tripId)}/details',
        (json) => TripDetails.fromJson(asJsonMap(json)),
      );
}

final tripHistoryRepositoryProvider = Provider<TripHistoryRepository>(
  (ref) => TripHistoryRepository(ref.watch(apiClientProvider)),
);
