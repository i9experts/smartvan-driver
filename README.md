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

## Phase 2 — safety features

Backend contract: `docs/PHASE2_API.md` in the `smartvan` repo.

- **SOS** (`lib/features/safety/`): hold the red button on the trip screen
  for 1.5 s → `POST /alert/sos` with GPS. Result sheet always offers calls
  to Police 15, Rescue 1122 and Edhi 115.
- **Students still in van** (`lib/features/trip/widgets/`): ending a drop
  trip that answers 409 `KIDS_NOT_DROPPED` shows who is still marked in the
  van; the driver drops them or confirms + writes a note (`forceEnd`).
- **QR scan** (`lib/features/scan/`): continuous scanner →
  `POST /trips/scanStudent`; the server decides pick vs drop. Needs internet
  (the Passengers list still works offline).
- **Daily van check** (`lib/features/checklist/`): checklist screen, home
  status card, and automatic hand-off when `startTrip` answers
  409 `CHECKLIST_REQUIRED`.

## Phase 3

Backend contract: `docs/PHASE3_API.md` in the `smartvan` repo.

- Location updates send GPS speed (overspeed monitoring); tracking stops
  if the server reports the trip is over.
- **My Driving Stats** (`lib/features/stats/`): safety score, distance,
  on-time starts, top speed (7/30 days).
- **Fees**: monthly summary card and shareable receipts
  (`lib/features/fees/widgets/receipt_sheet.dart`).
- **Chat** (`lib/features/chat/`): parent ↔ driver messages with quick
  replies; entry from the home header and each passenger card.

## Phase 4

Backend contract: `docs/PHASE4_API.md` in the `smartvan` repo.

- Passengers: parent-marked absences (dimmed, moved down, confirm before
  pick), "At stop / At home — tell parent" with a waiting timer, and
  "Not here — move on" (no-show) after 2 minutes on pick trips.
- Home: licence / vehicle card expiry banner.
- Firebase Crashlytics (release builds).
