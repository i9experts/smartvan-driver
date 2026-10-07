import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/providers/app_container.dart';
import '../core/providers/core_providers.dart';
import '../features/auth/data/fcm_service.dart';
import '../features/trip/services/active_trip_store.dart';
import 'app.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// App start-up, in order. `main()` only calls this.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Local storage (Hive): offline queue + active trip. Must be ready before
  // any screen can record a pickup/drop or resume a trip.
  await Hive.initFlutter();
  await appContainer.read(syncQueueProvider).init();
  await ActiveTripStore.init();
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      _setUpCrashReporting();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      // Push setup (permission prompt, APNs/FCM token) can stall for a long
      // time - e.g. on the iOS simulator there is no APNs token - so never
      // block the first frame on it.
      unawaited(FCMService.initialize()
          .timeout(const Duration(seconds: 20))
          .catchError((Object e) {
        debugPrint('FCM init failed, continuing without push: $e');
      }));
    } catch (e) {
      debugPrint(
          'Firebase init failed, continuing without push notifications: $e');
    }
  }
  runApp(UncontrolledProviderScope(
    container: appContainer,
    child: const SmartVanDriverApp(),
  ));
}

/// Sends crashes (Flutter framework + uncaught async errors) to Firebase
/// Crashlytics in release builds. Debug builds keep the normal red screen.
void _setUpCrashReporting() {
  final crashlytics = FirebaseCrashlytics.instance;
  crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    crashlytics.recordFlutterFatalError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    crashlytics.recordError(error, stack, fatal: true);
    return true;
  };
}
