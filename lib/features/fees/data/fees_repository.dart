import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/json_helpers.dart';
import '../../../core/network/network_providers.dart';
import 'models/fee_payment_request.dart';
import 'models/fee_student.dart';
import 'models/fee_summary.dart';
import 'models/receipt.dart';

class FeesRepository {
  const FeesRepository(this._api);

  final ApiClient _api;

  /// `GET /fees/driver-students` — every kid on the driver's van with this
  /// month's fee status.
  Future<List<FeeStudent>> students() => _api.get(
        '/fees/driver-students',
        (json) => asJsonList(json).map(FeeStudent.fromJson).toList(),
      );

  /// `GET /fees/driver-summary`.
  Future<FeeSummary> summary() => _api.get(
        '/fees/driver-summary',
        (json) => FeeSummary.fromJson(asJsonMap(json)),
      );

  /// `POST /fees/record-payment` — the driver collected cash.
  Future<void> recordPayment(FeePaymentRequest request) => _api.post<void>(
        '/fees/record-payment',
        (_) {},
        body: request.toJson(),
      );

  /// `GET /fees/receipt/{paymentId}`.
  Future<Receipt> receipt(String paymentId) => _api.get(
        '/fees/receipt/$paymentId',
        (json) => Receipt.fromJson(asJsonMap(json)),
      );
}

final feesRepositoryProvider = Provider<FeesRepository>(
    (ref) => FeesRepository(ref.watch(apiClientProvider)));
