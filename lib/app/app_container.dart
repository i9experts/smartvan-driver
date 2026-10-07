import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/network_providers.dart';
import '../core/router/router_provider.dart';
import '../features/auth/application/session_controller.dart';
import 'router.dart';

/// The app's single Riverpod container. Exposed so code that runs outside the
/// widget tree (start-up, the FCM handlers) can reach providers.
///
/// This is where the app wires what core cannot know: the router, and what a
/// 401 answer does.
final ProviderContainer appContainer = ProviderContainer(overrides: [
  routerProvider.overrideWith((ref) {
    final router = buildRouter();
    ref.onDispose(router.dispose);
    return router;
  }),
  unauthorizedHandlerProvider.overrideWith((ref) => () =>
      ref.read(sessionProvider).signOut(reason: SignOutReason.sessionExpired)),
]);
