import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/sync/sync_queue.dart';
import 'models/assigned_route.dart';
import 'models/geo_point.dart';
import 'models/trip.dart';
import 'models/trip_type.dart';

/// Routes, starting / ending a trip and sending the van's location.
///
/// Errors: see `TripErrorCodes` (`CHECKLIST_REQUIRED` from [startTrip],
/// `KIDS_NOT_DROPPED` from [endTrip] — read the kids with
/// `ApiError.kidsNotDropped`, `TRIP_NOT_ONGOING` from [sendLocation]).
class TripRepository {
  const TripRepository(this._api, this._queue);

  final ApiClient _api;
  final SyncQueue _queue;

  /// `GET /route/getAssignedTripByDriver` (lower-case `route`). A driver
  /// without a van gets a 400 `ApiError` ("Van not found for this driver").
  Future<List<AssignedRoute>> assignedRoutes() => _api.get(
        '/route/getAssignedTripByDriver',
        (json) => asJsonList(json).map(AssignedRoute.fromJson).toList(),
      );

  /// `GET /trips/getDriverTrips` — the driver's trips.
  Future<List<Trip>> driverTrips() => _api.get(
        '/trips/getDriverTrips',
        (json) => asJsonList(json).map(Trip.fromJson).toList(),
      );

  /// `POST /trips/startTrip`. [TripType.unknown] is sent as `pick`, which is
  /// what the app has always defaulted to.
  Future<Trip> startTrip({
    required String routeId,
    required TripType type,
  }) =>
      _api.post(
        '/trips/startTrip',
        (json) => Trip.fromJson(asJsonMap(json)),
        body: {
          'routeId': routeId,
          'type': type == TripType.drop ? 'drop' : 'pick',
        },
      );

  /// `POST /trips/endTrip`. The backend wants the longitude as `long`.
  ///
  /// [forceEnd] ends a drop trip although kids are still marked picked (the
  /// driver confirmed the van is empty); [confirmationNote] is then sent
  /// (empty if null).
  Future<void> endTrip({
    required String tripId,
    GeoPoint? position,
    bool forceEnd = false,
    String? confirmationNote,
  }) =>
      _api.post<void>(
        '/trips/endTrip',
        (_) {},
        body: {
          'tripId': tripId,
          if (position != null) 'lat': position.lat,
          if (position != null) 'long': position.lng,
          if (forceEnd) 'forceEnd': true,
          if (forceEnd) 'confirmationNote': confirmationNote ?? '',
        },
      );

  /// `POST /trips/updateLocation/{tripId}` through the offline queue.
  /// REST spells longitude `lng`; [speedMetersPerSecond] is only sent when it
  /// is known and not negative (the server records overspeed from it). The
  /// queue keeps only the newest queued point per trip and drops stale ones.
  Future<SubmitOutcome> sendLocation({
    required String tripId,
    required GeoPoint position,
    double? speedMetersPerSecond,
  }) {
    final speed = speedMetersPerSecond;
    return guardAppException(() => _queue.submit(
          kind: SyncKind.location,
          path: '/trips/updateLocation/$tripId',
          body: {
            'lat': position.lat,
            'lng': position.lng,
            if (speed != null && speed >= 0) 'speed': speed,
          },
          tripId: tripId,
        ));
  }

  /// Payload of the Socket.IO `updateLocation` event (the socket spells
  /// longitude `long`, nested under `location`).
  static Map<String, dynamic> socketLocationPayload(
          String tripId, GeoPoint position) =>
      {
        'tripId': tripId,
        'location': {'lat': position.lat, 'long': position.lng},
      };
}

final tripRepositoryProvider = Provider<TripRepository>(
  (ref) => TripRepository(
    ref.watch(apiClientProvider),
    ref.watch(syncQueueProvider),
  ),
);
