import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/providers/app_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/fcm_service.dart';
import 'core/sync/sync_queue.dart';
import 'features/trip/services/active_trip_store.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Local storage (Hive): offline queue + active trip. Must be ready before
  // any screen can record a pickup/drop or resume a trip.
  await Hive.initFlutter();
  await SyncQueue.instance.init();
  await ActiveTripStore.init();
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
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

class SmartVanDriverApp extends StatelessWidget {
  const SmartVanDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SmartVan Driver',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}
