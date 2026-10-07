import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/driver_stats.dart';
import '../data/stats_repository.dart';

part 'driver_stats_provider.g.dart';

/// The driver's own performance over the last [days] days (the app asks for
/// 7 or 30).
@riverpod
Future<DriverStats> driverStats(Ref ref, int days) =>
    ref.watch(statsRepositoryProvider).driverStats(days: days);
