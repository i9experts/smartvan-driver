import 'dart:async';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/interceptors.dart';
import '../../../core/storage/token_store.dart';
import '../../../core/tracking/location_buffer.dart';
import '../../../core/tracking/tracked_point.dart';
import '../../../core/tracking/tracking_engine.dart';
import '../../../core/tracking/tracking_session.dart';
import '../../../core/tracking/tracking_uploader.dart';

/// The Android foreground service that tracks the trip: it has its own Dart
/// isolate, so it keeps running (and uploading) after the app is swiped out
/// of the recent apps. The app talks to it with a few messages:
///
/// - app → service: [stopEvent]
/// - service → app: [fixEvent] (a point, for the live relay and the screen),
///   [tripOverEvent] (the server says the trip is not ongoing)
///
/// What the service needs to run on its own — which trip, who is logged in —
/// it reads from secure storage ([tripIdKey] and the login token), so it also
/// works when Android restarts it without the app.
abstract final class TrackingService {
  static const tripIdKey = 'tracking_trip_id';
  static const sessionIdKey = 'tracking_session_id';
  static const deviceIdKey = 'tracking_device_id';
  static const sessionClaimedKey = 'tracking_session_claimed';
  static const stableDeviceIdKey = 'tracking_device_stable_id';
  static const sessionReplacedEvent = 'tracking.sessionReplaced';
  static const stopEvent = 'tracking.stop';
  static const fixEvent = 'tracking.fix';
  static const tripOverEvent = 'tracking.tripOver';

  static const channelId = 'smartvan_trip';
  static const notificationId = 4242;

  static const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Once, from `bootstrap` on Android: creates the notification channel the
  /// service needs and registers its entry point. The service does not start
  /// until a trip does.
  static Future<void> configure() async {
    final channel = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await channel?.createNotificationChannel(const AndroidNotificationChannel(
      channelId,
      'Trip in progress',
      description: 'Shown while SmartVan shares the van\'s location.',
      importance: Importance.low,
    ));
    await FlutterBackgroundService().configure(
      androidConfiguration: AndroidConfiguration(
        onStart: trackingServiceMain,
        autoStart: false,
        autoStartOnBoot: false,
        isForegroundMode: true,
        notificationChannelId: channelId,
        initialNotificationTitle: 'SmartVan — Trip in progress',
        initialNotificationContent:
            'Sharing your location with parents and school',
        foregroundServiceNotificationId: notificationId,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(autoStart: false),
    );
  }
}

/// Reads the token on every request (the service lives a long time, and the
/// driver may log in again meanwhile) — [TokenStorage] caches it for ever.
class _FreshTokenStore implements TokenStore {
  @override
  Future<String?> read() =>
      TrackingService.storage.read(key: AppConstants.tokenKey);

  @override
  Future<void> save(String token) async {}

  @override
  Future<void> clear() async {}

  @override
  Future<bool> hasToken() async => (await read())?.isNotEmpty ?? false;
}

/// Entry point of the service isolate.
@pragma('vm:entry-point')
Future<void> trackingServiceMain(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final tripId =
      await TrackingService.storage.read(key: TrackingService.tripIdKey);
  if (tripId == null || tripId.isEmpty) {
    // Restarted by Android after the trip was over.
    await service.stopSelf();
    return;
  }

  await Hive.initFlutter();
  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.current.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ))
    ..interceptors.addAll([
      AuthInterceptor(_FreshTokenStore()),
      ErrorInterceptor(onUnauthorized: () async {}),
    ]);

  late final TrackingEngine engine;
  var stopping = false;
  Future<void> shutDown() async {
    if (stopping) return;
    stopping = true;
    await engine.stop();
    await service.stopSelf();
  }

  // The session this trip is tracked under (written by the app at start); a
  // service Android restarts keeps it, and does not claim the trip again.
  const storage = TrackingService.storage;
  final sessionId = await storage.read(key: TrackingService.sessionIdKey);
  final deviceId = await storage.read(key: TrackingService.deviceIdKey);
  final session = sessionId == null || sessionId.isEmpty || deviceId == null
      ? null
      : TrackingSession(
          sessionId: sessionId,
          deviceId: deviceId,
          claimed:
              await storage.read(key: TrackingService.sessionClaimedKey) == '1');

  final uploader = TrackingUploader(
    tripId: tripId,
    api: ApiClient(dio),
    buffer: await HiveLocationBuffer.open(),
    onTripOver: () {
      service.invoke(TrackingService.tripOverEvent);
      unawaited(shutDown());
    },
    session: session,
    onSessionClaimed: () => unawaited(
        storage.write(key: TrackingService.sessionClaimedKey, value: '1')),
    onSessionReplaced: () {
      service.invoke(TrackingService.sessionReplacedEvent);
      unawaited(shutDown());
    },
  );
  engine = TrackingEngine(
    positions: Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 3,
        intervalDuration: const Duration(seconds: 2),
      ),
    ).map(_toPoint),
    sink: uploader,
    seed: () async => _toPoint(await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
    ).timeout(const Duration(seconds: 8))),
    onFix: (p) => service.invoke(TrackingService.fixEvent, p.toMap()),
  );

  service.on(TrackingService.stopEvent).listen((_) => unawaited(shutDown()));
  await engine.start();
  debugPrint('[TrackingService] tracking trip $tripId');
}

TrackedPoint _toPoint(Position p) => TrackedPoint(
      lat: p.latitude,
      lng: p.longitude,
      time: p.timestamp,
      speed: p.speed,
      heading: p.heading,
      accuracy: p.accuracy,
    );
