import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import 'models/assigned_route.dart';
import 'models/geo_point.dart';
import 'models/optimized_route.dart';
import 'models/route_plan.dart';
import 'models/trip.dart';
import 'models/trip_trail.dart';
import 'models/trip_type.dart';

/// Routes, starting / ending a trip and sending the van's location.
///
/// Errors: see `TripErrorCodes` (`CHECKLIST_REQUIRED` from [startTrip],
/// `KIDS_NOT_DROPPED` from [endTrip] — read the kids with
/// `ApiError.kidsNotDropped`).
class TripRepository {
  const TripRepository(this._api);

  final ApiClient _api;

  /// `GET /Route/getAssignedTripByDriver` (capital `R`, like every other
  /// route call; the server's case-insensitive matching used to hide the
  /// lower-case spelling). A driver
  /// without a van gets a 400 `ApiError` ("Van not found for this driver").
  Future<List<AssignedRoute>> assignedRoutes() => _api.get(
        '/Route/getAssignedTripByDriver',
        (json) => asJsonList(json).map(AssignedRoute.fromJson).toList(),
      );

  /// `GET /trips/getDriverTrips` — the driver's trips.
  Future<List<Trip>> driverTrips() => _api.get(
        '/trips/getDriverTrips',
        (json) => asJsonList(json).map(Trip.fromJson).toList(),
      );

  /// `GET /trips/:tripId/route-plan` — stops in visiting order with their
  /// state, the school and the planned road path ahead.
  Future<RoutePlan> routePlan(String tripId) => _api.get(
        '/trips/$tripId/route-plan',
        (json) => RoutePlan.fromJson(asJsonMap(json)),
      );

  /// `GET /trips/:tripId/trail` — the path the van has driven so far.
  Future<TripTrail> trail(String tripId) => _api.get(
        '/trips/$tripId/trail',
        (json) => TripTrail.fromJson(asJsonMap(json)),
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

  /// `POST /trips/optimizeRoute` — the stops still to visit in the best
  /// order from [position], and what that saves against the current order.
  /// The server saves the new order, so the route plan follows it. Without a
  /// [position] (no GPS fix yet) the server starts from the van's last
  /// recorded location. The backend wants `long`.
  Future<OptimizedRoute> optimizeRoute({
    required String tripId,
    GeoPoint? position,
  }) =>
      _api.post(
        '/trips/optimizeRoute',
        (json) => OptimizedRoute.fromJson(asJsonMap(json)),
        body: {
          'tripId': tripId,
          if (position != null) 'lat': position.lat,
          if (position != null) 'long': position.lng,
        },
      );

  /// Payload of the Socket.IO `updateLocation` event:
  /// `{tripId, location: {lat, lng}, speed?, heading?}` — speed in m/s,
  /// heading in degrees. Unknown (null) or negative values (the GPS's "no
  /// value") are left out.
  static Map<String, dynamic> socketLocationPayload(
    String tripId,
    GeoPoint position, {
    double? speedMetersPerSecond,
    double? heading,
  }) =>
      {
        'tripId': tripId,
        'location': {'lat': position.lat, 'lng': position.lng},
        if (speedMetersPerSecond != null && speedMetersPerSecond >= 0)
          'speed': speedMetersPerSecond,
        if (heading != null && heading >= 0) 'heading': heading,
      };
}

final tripRepositoryProvider = Provider<TripRepository>(
  (ref) => TripRepository(ref.watch(apiClientProvider)),
);
