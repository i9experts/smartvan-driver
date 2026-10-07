# smartvan-driver — Architecture Audit

Read-only audit; no source changed. Generated 2026-10-02; counts refreshed 2026-10-07 on phase4.

> **Baseline:** counts re-run on branch `refactor/architecture`, cut from `phase4` (`225572e`) with a clean working tree. The findings in sections 2–5 were written against `phase3`; the line / `setState` counts, totals and the `.github` / `withOpacity` figures below are re-measured on phase4. Narrative items were not re-audited.

Totals: 10,634 lines of Dart in `lib/` + `test/`; 109 `setState` calls across 19 files (plus 2 `setSheetState`); `flutter analyze`: **No issues found**; 1 test.

---

## 1. File inventory

`ApiService` = direct call. "via Sync" = goes through `SyncQueue.submit`.

### Screens / widgets

| File | Lines | setState | Direct API | State held |
|---|---:|---:|---|---|
| home/screens/home_screen.dart | 1508 | 10 | GET `/route/getAssignedTripByDriver`, GET `/auth/getProfile`, GET `/trips/getDriverTrips`, POST `/trips/startTrip` (+`ChatApi.unread`) | `_currentIndex`, `_profile` (Map), `_trips`, `_myRoutes` (List<dynamic>), `_isLoading`, `_chatUnread`, `_startingRouteId` (bool, misnamed), `_startingRoute` |
| trip/screens/trip_screen.dart | 693 | 6 | GET `/auth/getProfile`, GET `/Route/getMergedActivePassengers` | `_mapController`, `_isEndingTrip`, `_passengers`, `_pickedCount`, `_totalPassengers`, `_profile`, `_syncedSub`; dead `_isTripStarted`/`_isStartingTrip`; widget `trip` Map |
| passengers/screens/passengers_screen.dart | 841 | 17 | GET `/Route/getMergedActivePassengers`; via Sync: POST `/trips/pickStudent`, `/trips/dropStudentForHome` (+`ChatApi.start`) | `_passengers`, `_isLoading`, `_hasError`, `_pickedCount`, `_pendingSync` (Map), `_busyKidIds`, `_syncedSub`; widget `trip` Map |
| profile/screens/report_issue_screen.dart | 526 | 5 | `uploadImage`, POST `/report/addReportByDriver` | description ctrl, `_selectedIssueType`, `_selectedImage`, `_isSaving`, `_showSuccess` |
| alerts/screens/alerts_screen.dart | 513 | 4 (+2 sheet) | GET `/alert/getNotificationForDriver`, POST `/alert/sendAlertByDriver` | `_alerts`, `_isLoading`, `_hasError`; sheet: message ctrl (never disposed), `isSending` |
| profile/screens/profile_screen.dart | 473 | 2 | GET `/auth/getProfile` | `_profile`, `_isLoading` |
| profile/screens/documents_screen.dart | 421 | 2 | GET `/auth/getProfile`, `uploadImage`, POST `/van/uploadDocuments` | `_documents` (= whole profile), `_isLoading` |
| profile/screens/edit_profile_screen.dart | 413 | 8 | GET `/auth/getProfile`, `uploadImage`, POST `/van/update-profile` | 5 text ctrls, `_isLoading`, `_isSaving`, `_hasError`, `_selectedImage`, `_profile` |
| passengers/screens/kid_profile_screen.dart | 405 | 0 | none (Stateless, kid Map via router extra) | — |
| fees/screens/fee_collection_screen.dart | 350 | 8 | GET `/fees/driver-students`, GET `/fees/driver-summary`, POST `/fees/record-payment` | `_students`, `_isLoading`, `_error`, `_payingKidId`, `_summary` |
| trip/services/trip_tracking_service.dart | 355 | 0 | POST `/trips/endTrip`; via Sync POST `/trips/updateLocation/{id}`; socket.io | `TripTrackingState{trip, isTracking, socketConnected, lastPosition, lastSpeed}`; `_location`, `_socket`, `_positionSub`, `_lastHttpUpdate` |
| profile/screens/change_password_screen.dart | 337 | 5 | POST `/auth/change-password` | 3 ctrls, 3 obscure flags, `_isSaving` |
| auth/screens/login_screen.dart | 312 | 3 | POST `/auth/login` (+SharedPreferences, FCM register) | 2 ctrls, `_obscurePassword`, `_isLoading` |
| alerts/screens/alert_detail_screen.dart | 309 | 0 | none (alert Map via extra) | — |
| chat/screens/chat_screen.dart | 280 | 10 | via `ChatApi`: messages/markRead/send | `_messages`, `_input`, `_socket`, `_subs`, `_loading`, `_loadingMore`, `_hasMore`, `_sending` |
| checklist/screens/checklist_screen.dart | 274 | 9 | via `ChecklistApi`; `uploadImage` | `_items`, `_answers`, `_notes` ctrls, `_photo`, `_existingPhotoUrl`, `_loading`, `_saving`, `_error` |
| scan/screens/scan_screen.dart | 269 | 4 | none direct (`ScanService`) | `_controller`, `_busy`, `_lastPayload`, `_lastAt`, `_result`, `_resultTimer`, `_session` |
| safety/widgets/sos_button.dart | 210 | 2 | none direct (`SosService`) | `_hold` AnimationController, `_sending` |
| stats/screens/driver_stats_screen.dart | 198 | 5 | GET `/trips/driver-stats?days=` | `_days`, `_data` (Map), `_error`, `_loading` |
| auth/screens/splash_screen.dart | 173 | 0 | none | animation controller; routing decision (token + `ActiveTripStore`) |
| trip/widgets/kids_not_dropped_sheet.dart | 150 | 3 | none | `_confirming`, `_checkedVan`, `_note` |
| fees/widgets/receipt_sheet.dart | 150 | 2 | GET `/fees/receipt/{id}` | `_r` (Map), `_error` |
| chat/screens/conversations_screen.dart | 144 | 4 | via `ChatApi.conversations` | `_items`, `_loading`, `_error`, `_socket`, `_sub` |

### Non-UI / core

| File | Lines | Notes |
|---|---:|---|
| core/sync/sync_queue.dart | 221 | Hive singleton; submit/flush/pending/onSynced/pendingKidStatuses; retry timer + connectivity listener |
| chat/chat_api.dart | 138 | static `ChatApi` + models `ChatUser`, `Conversation`, `ChatMessage` (the only typed models in the app) |
| core/router/app_router.dart | 119 | global `appRouter`; passes `Map<String,dynamic>` / `Conversation` via `extra` |
| core/network/api_service.dart | 115 | static Dio wrapper returning raw `Response`; `uploadImage` uses a separate un-intercepted `Dio()` |
| core/services/fcm_service.dart | 100 | static; POST `/van/update-profile {fcmToken,userType}` |
| main.dart | 80 | |
| core/storage/token_storage.dart | 67 | static, secure storage + in-memory cache + SharedPreferences migration |
| core/network/api_errors.dart | 62 | `isNetworkError`, `isServerError`, `code`, `status`, `message` |
| scan/scan_service.dart | 61 | static; POST `/trips/scanStudent`; typed `ScanResult`/`ScanException` (cleanest API wrapper) |
| checklist/checklist_api.dart | 60 | static `ChecklistApi`, `ChecklistItemDef`, `TodayChecklist`, `todayChecklistProvider` |
| chat/chat_socket.dart | 48 | socket per screen instance |
| core/session/app_session.dart | 42 | static; reaches `appContainer`, `appRouter`, and a feature (`tripTrackingProvider`) from core |
| trip/services/active_trip_store.dart | 38 | static Hive box `session`, key `active_trip` |
| safety/sos_service.dart | 38 | static; POST `/alert/sos`; hard-coded PK emergency numbers |
| passengers/kid_status.dart | 27 | pure static mapper (good shape to copy) |
| core/theme/app_theme.dart | 70 | |
| chat/chat_templates.dart | 12 | quick replies + `myChatRole` |
| core/providers/app_container.dart, core/constants/app_constants.dart | 5 / 5 | global `ProviderContainer`; `baseUrl = https://api.smartvan.pk` |
| test/widget_test.dart | 15 | |

Riverpod providers in the whole app: `tripTrackingProvider` (NotifierProvider), `todayChecklistProvider` (autoDispose FutureProvider). Most screens are `ConsumerStatefulWidget` but never use `ref`.

---

## 2. API endpoints

Envelope is usually `{data, message?, code?}`; errors `{message|error, code, kids?}`. Bearer token added by the Dio interceptor (401 → `AppSession.signOut`, except `/auth/login`). Location longitude key is **inconsistent** (`lng` vs `long`, marked below).

### Auth
| Endpoint | Request | Response fields read |
|---|---|---|
| POST `/auth/login` | `loginId` (trimmed), `password`, `userType:'driver'` | status 200/201; token = `data['data']?['token'] ?? data['token']`; error `message` |
| GET `/auth/getProfile` (home, trip, profile, documents, edit_profile) | — | unwrap `raw['data'] ?? raw`. See Profile entity |
| POST `/auth/change-password` | `oldPassword`, `newPassword`, `userType:'driver'` | none; error `message` |
| POST `/van/update-profile` (edit profile **and** FCM) | edit: `fullname, phoneNo, alternatePhoneNo, address, NIC, userType, image?`; FCM: `fcmToken, userType` | none |

### Profile / documents / uploads / reports
| Endpoint | Request | Response |
|---|---|---|
| POST `/upload/image` (multipart `file`) | via `ApiService.uploadImage` (raw Dio, no interceptors → no 401 handling) | `data['url']` String; null if status not 200/201 |
| POST `/van/uploadDocuments` | `title: 'vehicle_card'\|'driving_license'` + `vehicleCardImageFront` or `licenceImageFront` (URL) | none (reloads profile) |
| POST `/report/addReportByDriver` | `issueType` (display label), `description`, `type:'driverReport'`, `image?` | none |

### Home / trips
| Endpoint | Request | Response fields read |
|---|---|---|
| GET `/route/getAssignedTripByDriver` (lowercase `route`) | — | `data` List of route: `routeId`, `routeTitle`, `vehicleNumber`, `startTime` (UTC ISO; only h:m used), `tripType`, **`TripStarted`** (PascalCase bool), `tripDetails` (Map), `passengers[] {kidId, fullname, image, grade}` |
| GET `/trips/getDriverTrips` | — | `raw['data'] ?? raw`; per trip: `tripName ?? name ?? schoolRoute`, `createdAt`, `tripStart.startTime`, `type`, `status`, `_id\|id` |
| POST `/trips/startTrip` | `routeId`, `type` | `data` Map (trip doc: `_id\|id`, bare `routeId`); error code `CHECKLIST_REQUIRED`, `message` |
| POST `/trips/endTrip` | `tripId`, `lat?`, **`long`?**, `forceEnd?`, `confirmationNote?` | none; 409 `KIDS_NOT_DROPPED` → `data['kids'][] {kidId, fullname}` |
| POST `/trips/updateLocation/{tripId}` (via Sync) | `lat`, **`lng`**, `speed?` | none; `TRIP_NOT_ONGOING` stops tracking |
| Socket.IO (auth `{token}`) | emit `startTrip {tripId}`; emit `updateLocation {tripId, location:{lat, **long**}}` | — |
| GET `/trips/driver-stats?days=7\|30` | — | `data`: `safetyScore, onTimePercent?, overspeedCount, speedLimitKmh, trips, distanceKm, drivingMinutes, kidsDropped, maxSpeedKmh` |

### Passengers / scan / safety / checklist
| Endpoint | Request | Response fields read |
|---|---|---|
| GET `/Route/getMergedActivePassengers` (capital `R`; trip + passengers screens) | — | `raw['data'] ?? raw`; per kid: id `kidId\|_id\|id`; status `tripStatus\|status`; `tripId`; `fullname\|name`; `image\|profileImage`; `school.schoolName\|schoolName`; `grade`; `distance`; parent `parent.phoneNo\|parentPhone\|phoneNo`, `parent.alternatePhoneNo\|alternatePhone`, `parent.address\|address` |
| POST `/trips/pickStudent` (via Sync) | `tripId`, `kidId` (no GPS) | none |
| POST `/trips/dropStudentForHome` (via Sync) | `tripId`, `kidId`, `lat`, **`long`** | none |
| POST `/trips/scanStudent` | `tripId`, `qrPayload`, `lat?`, **`lng`?** | `data {action:'picked'\|'dropped', kidId, fullname}`; codes `INVALID_QR, KID_NOT_ON_TRIP, ALREADY_PICKED, ALREADY_DROPPED, LOCATION_REQUIRED, TRIP_NOT_ONGOING` |
| POST `/alert/sos` | `tripId?`, `lat`, **`lng`**, `message?` | `data.parentsNotified` int; `SOS_RATE_LIMITED` (429) treated as ok |
| GET `/trips/checklist/items` | — | `data` List of `{key, label}` |
| GET `/trips/checklist/today` | — | `data` Map\|null (`allOk`, `items[] {key, ok, note}`, `photoUrl`); sibling `required: bool` |
| POST `/trips/checklist` | `routeId?`, `items[] {key, ok, note?}`, `photoUrl?` | none |

### Alerts
| Endpoint | Request | Response |
|---|---|---|
| GET `/alert/getNotificationForDriver` | — | shape-sniffed: raw List \| `data` List \| `data.notifications`; per alert (list) `alertType\|type`, `title\|message`, `message\|description\|body`, `createdAt`; (detail) `alertType\|type`, `message`, `title`, `date\|createdAt`, `tripId`, `date`, `shift`, `startTime` |
| POST `/alert/sendAlertByDriver` | `message` | none |

### Fees
| Endpoint | Request | Response |
|---|---|---|
| GET `/fees/driver-students` | — | `data` List: `kidId, month('YYYY-MM'), fullname, image, grade, status(paid\|overdue\|pending\|not_generated), amount, currency, paymentId` |
| GET `/fees/driver-summary` | — | `data`: `currency, paid, students, collectedByYou, collectedOnline, totalPending` |
| POST `/fees/record-payment` | `kidId`, `month`, `paymentMethod:'cash'` | none (receipt id found by re-fetching list) |
| GET `/fees/receipt/{paymentId}` | — | `data`: `schoolName, currency, amount, receiptNumber, studentName, grade, month, paymentMethod, paidAt` |

### Chat (typed in `chat_api.dart`)
| Endpoint | Request | Response |
|---|---|---|
| GET `/chat/conversations` | — | `data[]`: `conversationId, otherUser{id,type,name,image}, kids[{fullname}], lastMessage{text,senderType,at}, unread` |
| GET `/chat/unread` | — | `data.unread` |
| POST `/chat/start` | `kidId` | `data` → Conversation |
| GET `/chat/{cid}/messages[?before=ISO]` | — | `data[]` messages (newest first) + sibling `hasMore` |
| POST `/chat/{cid}/messages` | `text`, `templateKey?` | `data` → ChatMessage |
| POST `/chat/{cid}/read` | `{}` | ignored |
| Socket in | `chatMessage` (ChatMessage JSON), `chatRead {conversationId}` | no outbound events; no connect_error/disconnect handling |

---

## 3. Entities needing models

Key variants must be normalised in `fromJson`. IDs: `_id|id|kidId` etc.

- **DriverProfile** (flat driver+van): `fullname|name` String, `email?`, `phoneNo`, `alternatePhoneNo?`, `address?`, `NIC?` (uppercase key), `image?` URL, `vanModel?`, `plateNumber?`, `seats` int|String, plus **Documents**: `licenceImageFront/Back`, `vehicleCardImageFront/Back` (URLs; Back never used).
- **Trip**: `_id|id`, `status` (active/ongoing/start | end/completed | pending), `type` pick|drop, `createdAt`, `tripStart.startTime`, `tripName|name|schoolRoute|route`, `routeId`. `shift`/`date` are read but don't exist server-side. **Client-injected keys** (`schoolRoute`, `passengers`) are mixed into the same Map, persisted to Hive and passed via router extra.
- **AssignedRoute**: `routeId, routeTitle, vehicleNumber, startTime(UTC), tripType, TripStarted(bool), tripDetails: Trip?, passengers: List<RoutePassenger>`.
- **RoutePassenger**: `kidId, fullname, image?, grade`.
- **Kid / Passenger** (merged-active-passengers): `id, fullname, image?, tripStatus (picked|dropped|pending), tripId?, grade, schoolName, distance(String), parent{phoneNo, alternatePhoneNo, address}`. Overlaid with SyncQueue pending status (`Map<kidId,'picked'|'dropped'>`).
- **ScanResult** `{action, kidId, fullname}`; **KidNotDropped** `{kidId, fullname}`.
- **Checklist**: `ChecklistItemDef{key,label}`, `ChecklistAnswer{key, ok, note?}`, `TodayChecklist{allOk?, items, photoUrl?, required}`.
- **Alert**: `alertType|type`, `message`, `title?`, `createdAt`, `date?`, `tripId?`, `shift?`, `startTime?`; no id / read flag used.
- **FeeStudent**, **FeeSummary**, **Receipt**, **FeePaymentRequest** — fields in section 2. `FeeStatus` enum (paid, overdue, pending, not_generated); `PaymentMethod` enum (cash, jazzcash, easypaisa, raast, bank_transfer, card).
- **DriverStats**: section 2.
- **IssueReport**: `issueType` (6 labels), `description`, `type`, `image?`.
- **Chat**: `ChatUser`, `Conversation`, `ChatMessage` already exist (manual `fromJson`; `pending` field unused).
- **Location payload**: one `{lat, lng}` value type to end `lng`/`long` drift.
- **TripTrackingState** exists (holds a raw Map trip).

---

## 4. Duplicated logic

1. `GET /auth/getProfile` + `raw['data'] ?? raw` in 5 places (home, trip, profile, documents, edit_profile); no cache.
2. `GET /Route/getMergedActivePassengers` + picked-count with `KidStatus` + pending overlay: trip_screen and passengers_screen (`_recount`).
3. Envelope unwrapping (`raw['data'] ?? raw ?? []`, `is List ? x : []`, `is Map ? Map.from(...)`) ~12 variants; `ChatApi._data` is a separate one; alerts shape-sniffs.
4. Error-message extraction: `ApiErrors.message` vs hand-rolled `e.response?.data?['message']` (login, change_password, home) vs fixed generic strings (profile, edit_profile, fees, alerts load).
5. Snackbars: hand-built red/green SnackBars in ~10 files; `_showSnack` defined twice.
6. Image pick + `uploadImage` (documents, edit_profile, report_issue, checklist) with different quality and failure handling; null URL silently dropped in edit_profile/report_issue.
7. Alert type→colour/icon/title switch in alerts_screen and alert_detail (already diverged: `new_trip`, `profile`).
8. Date/time formatting: 5 independent implementations (home `_formatTime12Hour`, alerts relative, alert_detail manual, chat `intl`, receipt `intl`).
9. Trip enrichment `{...trip, 'schoolRoute': ...}` ×3 in home, `{...trip,'passengers':...}` ×2 in trip_screen.
10. Trip status string interpretation (home), kid status (`KidStatus`), scan `action`.
11. Trip-id derivation (`tripIdOf`, `kid['tripId'] ?? _tripId`, `tracking.tripId`) in passengers, scan, sos, trip.
12. Avatar-initial fallback ×5, gradient header ×8, `InputDecoration` copies, loading/error/empty UI, hard-coded colours (`0xFF1B2B6B`, `0xFF27AE60`, `0xFFFF4B4B`…, 'Poppins') with `_navy` redeclared per class; `withOpacity` 87 uses.
13. Reload-after-pop (`await push(...); _load()`) ×6.
14. `statusCode == 200` checks (dead; Dio throws on non-2xx).
15. Phone launching (`EmergencyNumbers.call`, `_callPhone`).
16. Two sockets: tracking socket and chat socket (one per screen) with separate token handling.

---

## 5. Lints, tests, blockers

**Analysis:** `include: package:flutter_lints/flutter.yaml` (^4.0.0), no custom rules, `deprecated_member_use: ignore` (hides the 87 `withOpacity` uses). `flutter analyze`: clean. No `strict-casts/inference/raw-types`, no `prefer_final_*`, no `avoid_dynamic_calls`, no import-order rules — so the ~60 `Map<String,dynamic>` uses and implicit dynamic casts are invisible to the analyzer. `print` used in `uploadImage`.

**Tests:** one smoke test (`test/widget_test.dart`) that renders a `Text` in a themed `MaterialApp`; effectively zero coverage. No CI config found (`.github` absent). Deps missing for tests: no `mocktail`/`mockito`, no `integration_test`.

**Dependencies:** `flutter_riverpod`, `go_router`, `dio`, `hive`, etc. No `freezed`/`json_serializable`, no `equatable`, no code generation.

**Blockers to a clean architecture**
1. **No data layer**: ~25 direct `ApiService` calls in widgets; only chat/scan/checklist/sos have wrappers, all static.
2. **Untyped JSON**: all entities are `Map`/`List<dynamic>`; casts like `String x = map['k'] ?? ''` throw on wrong types; some values print `null` (`amount`, `paid/students`).
3. **Static singletons everywhere** (`ApiService`, `TokenStorage`, `SyncQueue.instance`, `ActiveTripStore`, `FCMService`, `AppSession`, `ChatApi`, `ScanService`, `SosService`) and globals (`appRouter`, `appContainer`); no DI seam, un-fakeable.
4. **Inverted dependency**: `core/session/app_session.dart` imports a feature; `splash` (auth) depends on trip store.
5. **Router `extra` as Map/model**: `/trip`, `/passengers` (hybrid trip+passengers), `/kid-profile`, `/alert-detail`, `/checklist`, `/chat` (`as Conversation`) — crashes on missing extra, no deep link / state restoration.
6. **Huge widgets with embedded business rules**: home (1441 lines: tracking reconciliation, start-trip + checklist retry recursion, 1-hour start window, status mapping), trip (end-trip orchestration), passengers (pick/drop queueing), scan (debounce, error map), sos, fees (status→action, receipt discovery via re-fetch), checklist, chat (dedupe, read approximation).
7. **`TripTrackingNotifier` not injectable**: constructs/uses `Location`, `io.Socket`, `TokenStorage`, `ActiveTripStore`, `SyncQueue.instance`, `ApiService` directly; `DateTime.now()` unabstracted.
8. **Mixed state management**: `setState` + Maps in most screens, Riverpod only for tracking + checklist status; checklist screen and home card load the same data two ways; Home embeds Alerts/Profile as tabs outside go_router; `go` vs `push` mix on profile.
9. **API contract inconsistencies** that the model layer must absorb: `/route/` vs `/Route/`, `TripStarted`, `lng` vs `long`, `_id|id|kidId`, `fullname|name`, `NIC`, `licence`/`license`, `/van/update-profile` used for driver edit + FCM, `/trips/driver-stats`.
10. **Infra bypasses**: `uploadImage` uses separate Dio (no 401 handling/logging); `SyncQueue` posts straight via `ApiService`; two socket clients.
11. **Lifecycle/robustness**: missing `mounted` guards (home ×3, profile, stats, receipt, fees catch, alerts); undisposed controller in alerts sheet; FCM listeners never cancelled; chat socket has no reconnect resync and reads token once.
12. **Known functional defects found (not fixed)**: alert_detail `13:05 PM` time bug; "Upload New Document" picks an image then discards it; alert "View Trip" ignores `tripId`; edit_profile/report_issue silently post without image if upload returns null; Back documents never shown/uploaded; no password-differs check in change_password; report-issue helper text copied from parent app; `trip_screen` reads `shift`/`date` that don't exist; `TripTrackingNotifier.start` returns `permissionDenied` for a null trip id; dead `_isTripStarted`/`_isStartingTrip`; hard-coded Karachi fallbacks and PK emergency numbers; hard-coded 4 s splash delay; `ActiveTripStore` resume depends on splash only.
13. **No localisation/theming layer**: colours, fonts, strings inline.

**Suggested extraction order (for the refactor plan):** typed `ApiClient` with injectable `Dio` and one envelope/error mapper → models (`DriverProfile`, `Trip`, `AssignedRoute`, `Kid`, `Alert`, `Fee*`, `Receipt`, `DriverStats`, `Checklist*`, existing chat) → repositories behind Riverpod providers (profile cached once) → `TripController` taking over home's start/reconcile logic and trip's end flow → shared UI kit (snackbar, header, avatar, states, formatters, theme tokens) → typed route params → tighten `analysis_options` and add repository/controller tests.
