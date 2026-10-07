import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/app_container.dart';
import '../../../core/storage/token_store.dart';
import 'auth_repository.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'smartvan_driver_alerts',
    'SmartVan Alerts',
    description: 'Trip, route, and emergency alerts for drivers',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    final token = await _messaging.getToken();
    if (token != null) {
      await _saveFCMToken(token);
    }

    _messaging.onTokenRefresh.listen(_saveFCMToken);

    // Foreground messages don't show a system notification by default on
    // either platform — without this, any alert sent while the driver has
    // the app open would be completely invisible to them.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );
      }
    });
  }

  static Future<void> _saveFCMToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (await appContainer.read(tokenStorageProvider).hasToken()) {
        await appContainer.read(authRepositoryProvider).registerFcmToken(token);
      }
      await prefs.setString('fcm_token', token);
    } catch (e) {
      debugPrint('FCM token save error: $e');
    }
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Call this right after a successful login — if FCM already fetched a
  /// token at app startup (before the user was authenticated), it would
  /// never get associated with their account until Firebase happened to
  /// refresh it on its own, which can take an unpredictable amount of time.
  static Future<void> registerTokenWithBackend() async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveFCMToken(token);
    }
  }
}
