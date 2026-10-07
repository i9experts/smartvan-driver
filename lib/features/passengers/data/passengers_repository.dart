import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/sync/sync_queue.dart';
import '../../trip/data/models/geo_point.dart';
import 'models/absence.dart';
import 'models/arrived_at_stop.dart';
import 'models/kid_trip_status.dart';
import 'models/passenger.dart';

/// Backend codes of the stop actions (`ApiError.code`).
class StopErrorCodes {
  StopErrorCodes._();
  static const tripNotFound = 'TRIP_NOT_FOUND';
  static const tripNotOngoing = 'TRIP_NOT_ONGOING';
  static const tripNotYours = 'TRIP_NOT_YOURS';
  static const kidNotOnTrip = 'KID_NOT_ON_TRIP';
  static const notPickTrip = 'NOT_PICK_TRIP';
  static const alreadyPicked = 'ALREADY_PICKED';
}

/// Passengers of the running trip, pick/drop, at-stop / no-show and the
/// day's absences.
///
/// Pick and drop go through the offline [SyncQueue]: they are sent now if
/// possible, otherwise saved on the phone and replayed in order — exactly
/// as the screens did before.
class PassengersRepository {
  const PassengersRepository(this._api, this._queue);

  final ApiClient _api;
  final SyncQueue _queue;

  /// `GET /Route/getMergedActivePassengers` (capital `R`) — the kids of the
  /// running trip with their pick state.
  Future<List<Passenger>> activePassengers() => _api.get(
        '/Route/getMergedActivePassengers',
        (json) => asJsonList(json).map(Passenger.fromJson).toList(),
      );

  /// `POST /trips/pickStudent` through the queue.
  /// [SubmitOutcome.queued] means saved offline. Throws an [AppException]
  /// only when the server rejects the request.
  Future<SubmitOutcome> pick({required String tripId, required String kidId}) =>
      guardAppException(() => _queue.submit(
            kind: SyncKind.pick,
            path: '/trips/pickStudent',
            body: {'tripId': tripId, 'kidId': kidId},
            tripId: tripId,
            kidId: kidId,
          ));

  /// `POST /trips/dropStudentForHome` through the queue. The backend wants
  /// the longitude as `long` here.
  Future<SubmitOutcome> drop({
    required String tripId,
    required String kidId,
    required GeoPoint position,
  }) =>
      guardAppException(() => _queue.submit(
            kind: SyncKind.drop,
            path: '/trips/dropStudentForHome',
            body: {
              'tripId': tripId,
              'kidId': kidId,
              'lat': position.lat,
              'long': position.lng,
            },
            tripId: tripId,
            kidId: kidId,
          ));

  /// Kid states saved on the phone but not on the server yet, for [tripId],
  /// to overlay on [activePassengers].
  Map<String, KidTripStatus> pendingStatuses(String? tripId) => {
        for (final e in _queue.pendingKidStatuses(tripId).entries)
          e.key: e.value == 'dropped'
              ? KidTripStatus.dropped
              : KidTripStatus.picked,
      };

  /// `POST /trips/arrivedAtStop` — tells the parent the van is at the stop.
  /// Once per kid per trip; parent gets a push.
  Future<ArrivedAtStop> arrivedAtStop({
    required String tripId,
    required String kidId,
  }) =>
      _api.post(
        '/trips/arrivedAtStop',
        (json) => ArrivedAtStop.fromJson(asJsonMap(json)),
        body: {'tripId': tripId, 'kidId': kidId},
      );

  /// `POST /trips/noShow` — pick trips only, kid not picked.
  Future<void> markNoShow({
    required String tripId,
    required String kidId,
    String? note,
  }) {
    final text = note?.trim();
    return _api.post<void>(
      '/trips/noShow',
      (_) {},
      body: {
        'tripId': tripId,
        'kidId': kidId,
        if (text != null && text.isNotEmpty) 'note': text,
      },
    );
  }

  /// `GET /kid/absence/today` — absences for kids on the driver's van.
  Future<List<Absence>> todayAbsences() => _api.get(
        '/kid/absence/today',
        (json) => asJsonList(json).map(Absence.fromJson).toList(),
      );
}

final passengersRepositoryProvider = Provider<PassengersRepository>(
  (ref) => PassengersRepository(
    ref.watch(apiClientProvider),
    ref.watch(syncQueueProvider),
  ),
);
