import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The app's single Riverpod container. Exposed so non-widget code (the
/// API 401 handler, AppSession) can reach providers such as trip tracking.
final ProviderContainer appContainer = ProviderContainer();
