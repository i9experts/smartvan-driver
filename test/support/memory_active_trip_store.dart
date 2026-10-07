import 'package:smartvan_driver/features/trip/data/active_trip_store.dart';
import 'package:smartvan_driver/features/trip/data/models/active_trip.dart';

class MemoryActiveTripStore implements ActiveTripStore {
  ActiveTrip? saved;
  int clears = 0;

  @override
  ActiveTrip? read() => saved;

  @override
  Future<void> save(ActiveTrip trip) async => saved = trip;

  @override
  Future<void> clear() async {
    saved = null;
    clears++;
  }
}
