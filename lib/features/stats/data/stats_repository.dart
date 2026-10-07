import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import 'models/driver_stats.dart';

class StatsRepository {
  const StatsRepository(this._api);

  final ApiClient _api;

  /// `GET /trips/driver-stats?days=` (the app asks for 7 or 30).
  Future<DriverStats> driverStats({required int days}) => _api.get(
        '/trips/driver-stats',
        (json) => DriverStats.fromJson(asJsonMap(json)),
        query: {'days': days},
      );
}

final statsRepositoryProvider = Provider<StatsRepository>(
    (ref) => StatsRepository(ref.watch(apiClientProvider)));
