import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartvan_driver/l10n/l10n.dart';

/// Wraps [child] in a MaterialApp with the app's localizations (English),
/// inside a ProviderScope with [overrides].
Widget l10nHost(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

/// English strings without a widget tree.
Future<AppLocalizations> loadL10n() =>
    AppLocalizations.delegate.load(const Locale('en'));

/// Like [l10nHost] but with a GoRouter, for screens that navigate. [routes]
/// maps a path to its page; the app starts on [initial].
Widget routerHost(
  Map<String, Widget Function(GoRouterState state)> routes, {
  required String initial,
  List<Override> overrides = const [],
}) {
  final router = GoRouter(
    initialLocation: initial,
    routes: [
      for (final e in routes.entries)
        GoRoute(path: e.key, builder: (_, state) => e.value(state)),
    ],
  );
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}
