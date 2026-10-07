import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The app's [GoRouter]. `lib/app` supplies it (app_container.dart); core and
/// features only read it, e.g. to go to the login screen on sign-out.
final routerProvider = Provider<GoRouter>(
  (ref) => throw UnimplementedError(
      'routerProvider must be overridden with the app router'),
);
