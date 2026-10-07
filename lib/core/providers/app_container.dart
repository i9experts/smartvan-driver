import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/network_providers.dart';
import '../session/app_session.dart';

/// The app's single Riverpod container. Exposed so non-widget code (the
/// API 401 handler, AppSession, the FCM background handler) can reach
/// providers such as trip tracking.
///
/// Transition: this moves into app/bootstrap.dart once AppSession stops being
/// a static (docs/ARCHITECTURE.md §3).
final ProviderContainer appContainer = ProviderContainer(overrides: [
  unauthorizedHandlerProvider
      .overrideWithValue(() => AppSession.signOut(reason: '401')),
]);
