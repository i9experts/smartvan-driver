import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/fcm_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase has no config on platforms/builds that never ran the FlutterFire
  // CLI (e.g. web has no firebase_options.dart here), so initializeApp()
  // throws there. Push notifications are non-essential to app startup, so
  // failing to init shouldn't block the driver from using the rest of the app.
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FCMService.initialize();
  } catch (e) {
    debugPrint('Firebase init failed, continuing without push notifications: $e');
  }
  runApp(const ProviderScope(child: SmartVanDriverApp()));
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