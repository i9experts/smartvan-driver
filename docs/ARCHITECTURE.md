# SmartVan app architecture (driver app first, parent app after)

v2 — adds Urdu localization (§12) and driver voice prompts (§13).

This is the contract for the refactor. Every refactor commit must follow it.
If something here doesn't fit the real code, stop and ask; don't improvise.

## 0. Ground rules

1. **No behaviour changes.** Same screens, same flows, same API calls, same
   texts. Only structure changes. Bug fixes go in separate `fix:` commits.
2. **One feature per commit** (or smaller). After every commit:
   `dart run build_runner build -d`, `flutter analyze` (0 issues),
   `flutter test` (all green). Never commit red.
3. Migrate incrementally. Old and new code may live side by side until a
   feature is fully moved; then delete the old path in the same PR.
4. Generated files (`*.g.dart`, `*.freezed.dart`) are committed.

## 1. Packages

- State: `flutter_riverpod`, `riverpod_annotation`, dev: `riverpod_generator`,
  `custom_lint`, `riverpod_lint`
- Models: `freezed_annotation`, `json_annotation`, dev: `freezed`,
  `json_serializable`, `build_runner`
- Tests: `mocktail`, `http_mock_adapter` (Dio)
- Pick the newest versions that resolve with the current Flutter SDK and
  record them in this file. If freezed 3.x: models are
  `@freezed abstract class X with _$X`.
- Localization: `flutter_localizations` (SDK) and `intl` — see §12.

**Resolved versions** (Flutter 3.35.6 / Dart 3.9.2, recorded 2026-10-07 at R.1;
`pubspec.lock` is the source of truth):

| Package | Version | Notes |
|---|---|---|
| flutter_riverpod / riverpod | 2.6.1 | |
| riverpod_annotation | 2.6.1 | |
| riverpod_generator (dev) | 2.6.5 | newest line that works with Riverpod 2.x |
| custom_lint (dev) | 0.7.6 | |
| riverpod_lint (dev) | 2.6.5 | |
| freezed_annotation / freezed (dev) | 3.1.0 | freezed 3 → `@freezed abstract class X with _$X` |
| json_annotation | 4.9.0 | |
| json_serializable (dev) | 6.9.5 | |
| build_runner (dev) | 2.5.4 | |
| mocktail (dev) | 1.0.5 | |
| http_mock_adapter (dev) | 0.6.1 | |
| dio | 5.9.2 | already a dependency |
| intl | 0.20.2 | bumped from 0.19.0, required by `flutter_localizations` |
| flutter_lints (dev) | 4.0.0 | unchanged |

## 2. Folder structure

```
lib/
  app/                 app.dart (MaterialApp.router), bootstrap.dart (init order)
  core/
    config/            AppConfig (API_BASE_URL, SOCKET_URL via --dart-define), flavors
    network/           ApiClient, AppException, interceptors, json helpers
    storage/           TokenStorage, Hive boxes (SyncQueue, ActiveTripStore)
    router/            routes + typed route helpers
    theme/  widgets/   shared UI: AppSnack, AppErrorView, AppEmptyView,
                       AppLoading, GradientHeader, date/money formatters
  features/<feature>/
    data/
      models/          freezed models + fromJson
      <feature>_repository.dart
    application/       Riverpod controllers / providers
    presentation/
      screens/         one screen per file, thin
      widgets/         pieces of the screen
```

**`core/` must never import `features/`.** Cross-cutting events (sign-out,
"trip ended") go through providers/listeners, not direct imports.

## 3. Dependency injection

Everything that touches the outside world is a provider, so tests can
override it:

| Provider | Replaces |
|---|---|
| `appConfigProvider` | hardcoded `AppConstants.baseUrl` |
| `dioProvider`, `apiClientProvider` | static `ApiService` |
| `tokenStorageProvider` | static `TokenStorage` |
| `syncQueueProvider` | `SyncQueue.instance` |
| `locationServiceProvider` | `Location()` created inside `TripTrackingNotifier` |
| `socketFactoryProvider` | `io.io(...)` created inline |
| `routerProvider` | global `appRouter` |

`appContainer` stays only in `bootstrap.dart`, for code that runs outside the
widget tree (FCM background handler).

Transition: `ApiService` becomes a thin wrapper around `ApiClient` until the
last screen is migrated, then it's deleted.

## 4. Networking and errors

- `ApiClient` has typed helpers, e.g.
  `Future<T> get<T>(String path, T Function(Object? json) parse, {query})`,
  and the same for post/put/delete.
- **One** response unwrapper (`unwrapData`) handles every shape the backend
  uses (`{data: x}`, `{data: {data: x}}`, raw list, raw map). No screen or
  repository unwraps by hand.
- Errors: a sealed `AppException`:
  `NetworkException`, `UnauthorizedException`, `ServerException`,
  `ApiError(code, message, status)`, `UnknownException`.
  The Dio interceptor converts every failure into one of these.
  `ApiError.code` carries the backend codes (`KIDS_NOT_DROPPED`,
  `CHECKLIST_REQUIRED`, `INVALID_QR`, ...).
- Repositories return models or throw `AppException`. They never return raw
  `Response` or `Map`.
- User-facing text for an error comes from one function
  (`AppException.userMessage`).

## 5. Models

- Every entity in `docs/AUDIT.md` §3 gets a freezed model with `fromJson`.
- Backend inconsistencies are absorbed **only** in the model, never in
  screens: `@JsonKey(readValue: ...)` helpers for `_id|id|kidId`,
  `lng|long`, `TripStarted`, `tripStatus|status`, number-as-string, etc.
- Enums for fixed values (`TripType.pick/drop`, `KidTripStatus`,
  `PaymentStatus`, `PaymentMethod`) with `unknown` fallback.
- Each model has a test with a real JSON fixture (copy shapes from the audit).

## 6. State (Riverpod)

- Server data: `@riverpod` `AsyncNotifier` / `FutureProvider` per feature.
  Screens use `ref.watch(...)` and render `AsyncValue` via one shared
  `AsyncValueView` (loading / error-with-retry / data).
- Shared data is cached once: e.g. `driverProfileProvider` replaces the
  5 separate `/auth/getProfile` calls; `passengersProvider(tripId)` replaces
  the duplicated fetch+count in trip and passengers screens.
- Mutations are controller methods (`pick(kidId)`, `endTrip(...)`) that call
  the repository, then invalidate/refresh the affected providers.
- `setState` is allowed **only** for ephemeral UI state (text fields,
  toggles, animation, selected tab). Never for server data or loading flags
  of server calls.
- Every `await` in a widget followed by `context`/`setState` needs a
  `mounted` / `context.mounted` check.

## 7. Routing

- Routes take **ids in the path**, not raw Maps in `extra`:
  `/trip/:tripId`, `/passengers/:tripId`, `/chat/:conversationId`,
  `/kid/:kidId`. The screen loads what it needs through providers.
  `extra` may only carry an optional already-loaded model as a speed-up,
  never required.
- Route paths live in one place (`AppRoutes`), no string literals in screens.

## 8. Feature-specific notes (driver app)

- `TripTrackingNotifier` gets its dependencies from providers (location,
  socket factory, sync queue, repository) so it can be unit-tested with fakes.
- The start-trip flow from `home_screen.dart` (start-window rule, checklist
  retry, tracking reconciliation) moves into a `StartTripController`; the
  screen only reacts to its state.
- Large screens are split: no file over ~300 lines, no build method over
  ~80 lines.

## 9. Lints and quality

- `analysis_options.yaml`: `flutter_lints` (or `very_good_analysis`) plus
  ```
  analyzer:
    language: { strict-casts: true, strict-inference: true, strict-raw-types: true }
    plugins: [custom_lint]
  ```
  Remove the `deprecated_member_use` ignore and migrate
  `withOpacity(x)` → `withValues(alpha: x)`.
- CI (`.github/workflows/flutter.yml`): on push/PR run pub get,
  build_runner, `flutter analyze`, `flutter test`.

## 10. Tests (minimum)

(see also §12/§13 for l10n and voice tests: a golden/widget test per main screen in `ur` RTL, and VoiceService fakes.)


- Models: fromJson for every model incl. the backend variants.
- Repositories: request path/body + parsing + error mapping (http_mock_adapter).
- Controllers: with `ProviderContainer(overrides: ...)` and fake repositories.
- Tracking: `TripTrackingNotifier` with fake location/socket/queue.
- Widget tests: home, trip, passengers, scan result, kids-not-dropped sheet.

## 11. Order of work

| Step | Content |
|---|---|
| R.0 | Bug fixes from AUDIT §5 + parent hardcoded "Van is on the way — 12 minutes" banner (separate `fix:` commits, before anything else) |
| R.1 | Foundation: packages, lints (no withOpacity migration yet), AppConfig, ApiClient + AppException + unwrapData, providers for DI, shared UI widgets, **l10n setup (§12, English ARB only, no translations yet)**, CI |
| R.2 | All models + fixtures + tests |
| R.3 | Repositories per feature + tests |
| R.4 | Feature by feature to controllers + typed routes: auth → profile/documents → alerts → fees → stats → checklist → chat → scan → passengers → trip/tracking → home. **Every string the feature shows moves to `app_en.arb` in the same commit.** |
| R.5 | withOpacity migration, delete ApiService/old statics, file splits, remaining widget tests |
| R.6 | Urdu: `app_ur.arb` complete, RTL pass on every screen, language switch (§12) |
| R.7 | Driver voice prompts (§13) |

Parent app follows the same steps after the driver app (R.7 is driver-only).

## 12. Localization (English + Urdu)

- `flutter_localizations` + `intl` + gen-l10n (`l10n.yaml`, `lib/l10n/app_en.arb`,
  `lib/l10n/app_ur.arb`), `AppLocalizations.of(context)` via a short
  extension (`context.l10n`).
- **No user-visible string literals in widgets** after R.4 (lint/grep check in
  CI). Includes snackbars, dialogs, empty/error states, notification banners
  built in the app, and `AppException.userMessage`.
- Plurals and placeholders via ICU (`{count, plural, ...}`), never string
  concatenation. Dates/times/money via `intl` with the active locale.
- Backend messages: the app maps known `code`s (KIDS_NOT_DROPPED,
  INVALID_QR, ...) to localized text; unknown server messages are shown as-is.
- Urdu is **RTL**: test every screen with `Directionality.rtl`; use
  `EdgeInsetsDirectional`, `AlignmentDirectional`, `start/end` instead of
  `left/right`; icons that imply direction (back arrows, chevrons) flip.
- Font: an Urdu-capable font (e.g. Noto Nastaliq Urdu or Noto Naskh Arabic)
  bundled in `assets/fonts`, used for the `ur` locale; Poppins stays for `en`.
  Check line height — Nastaliq needs more.
- Language setting: Profile → Language (English / اردو), stored locally
  (shared prefs), applied at app start; default = device language if `ur`,
  otherwise English. A `localeProvider` drives `MaterialApp.locale`.
- Translations: natural, simple Urdu (as drivers/parents speak), not
  literal. Keep product names (SmartVan, SOS, QR) in English. A native
  speaker reviews `app_ur.arb` before release.

## 13. Driver voice prompts (driver app only)

- Package: `flutter_tts`. A `VoiceService` provider (overridable in tests)
  with `speak(VoicePrompt prompt)`; prompts are typed (`nextStop(name)`,
  `arrivedAtStop(name)`, `kidAbsent(name)`, `tripStarted`, `tripEnded`,
  `offline`, `backOnline`, `overspeedWarning`, `sosSent`), text comes from
  the l10n ARB files (so Urdu voice speaks Urdu).
- Language: `ur-PK` when the app language is Urdu and the device has an Urdu
  TTS voice (`isLanguageAvailable`), otherwise English, with a one-time
  hint that Urdu voice can be installed in the phone's TTS settings.
- Triggers (all from controllers/state changes, never from widgets):
  trip started/ended; approaching next pending stop (~200 m, once per stop);
  "At stop" pressed; parent marks a kid absent during the trip; going
  offline / back online; speed above the limit (client-side, once per
  minute max); SOS sent.
- Settings: Profile → Voice prompts on/off (default on) and a test button.
  Don't speak while a phone call is active (audio focus); duck other audio.
- Tests: VoiceService fake records prompts; controller tests assert which
  prompts fire for given state transitions.
