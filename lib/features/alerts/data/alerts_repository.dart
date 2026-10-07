import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_providers.dart';
import 'models/alert.dart';

class AlertsRepository {
  const AlertsRepository(this._api);

  final ApiClient _api;

  /// `GET /alert/getNotificationForDriver` — newest first as the server
  /// sends them. Copes with every response shape the endpoint has used.
  Future<List<Alert>> alerts() => _api.getEnvelope(
        '/alert/getNotificationForDriver',
        (e) => Alert.listFrom(e.raw),
      );

  /// `POST /alert/sendAlertByDriver` — a free-text message to the school.
  Future<void> sendAlert(String message) => _api.post<void>(
        '/alert/sendAlertByDriver',
        (_) {},
        body: {'message': message},
      );
}

final alertsRepositoryProvider = Provider<AlertsRepository>(
    (ref) => AlertsRepository(ref.watch(apiClientProvider)));
