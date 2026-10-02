# SmartVan Driver

Flutter app for school-van drivers: assigned routes, live trip tracking,
pickup/drop of students, alerts, fee collection and profile/documents.

Stack: Flutter 3.5+, Riverpod, go_router, Dio, Socket.IO, Google Maps,
Firebase Messaging, Hive (offline storage), flutter_secure_storage.

## Setup

1. `flutter pub get`
2. **Google Maps key** (no longer in source code):
   - Android: add to `android/local.properties` (gitignored)
     ```
     MAPS_API_KEY=your_android_maps_key
     ```
     or set the `MAPS_API_KEY` environment variable on CI.
   - iOS: copy `ios/Flutter/Secrets.xcconfig.example` to
     `ios/Flutter/Secrets.xcconfig` and fill in the key.
3. `flutter run`

## How trip tracking works

- `TripTrackingNotifier` (`lib/features/trip/services/`) owns the GPS
  stream, Android foreground service and Socket.IO connection for the whole
  trip. It is independent of which screen is open and stops only when the
  trip is ended or the driver signs out.
- Socket `updateLocation` gets every GPS fix (live map for parents);
  `POST /trips/updateLocation/:tripId` (geofence alerts) at most every 5 s.
- The active trip is saved locally (`ActiveTripStore`); after the app is
  killed, Splash reopens it and Home reconciles with the server.

## Offline mode

`SyncQueue` (`lib/core/sync/`) stores pick/drop/location requests in Hive
when there is no internet and replays them in order when connectivity
returns. Drivers see a cloud badge on unsynced kids and a banner on the trip
screen. A trip can't be ended until the queue is empty.
