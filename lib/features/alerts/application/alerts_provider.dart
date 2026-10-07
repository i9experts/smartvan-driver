import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/alerts_repository.dart';
import '../data/models/alert.dart';

part 'alerts_provider.g.dart';

/// The driver's notifications, newest first as the server sends them.
/// Reloaded each time a screen starts watching it; refresh with
/// `ref.refresh(alertsProvider.future)`.
@riverpod
Future<List<Alert>> alerts(Ref ref) =>
    ref.watch(alertsRepositoryProvider).alerts();
