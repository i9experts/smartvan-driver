import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'alert_type.dart';

part 'alert.freezed.dart';
part 'alert.g.dart';

/// A notification from `GET /alert/getNotificationForDriver`. The backend
/// sends no id or read flag for these.
@freezed
abstract class Alert with _$Alert {
  const factory Alert({
    /// Mongo `_id` (the list used to ignore it; it is what the detail route
    /// carries).
    @JsonKey(readValue: readId, fromJson: looseString) String? id,

    /// `alertType` | `type`.
    @JsonKey(readValue: readAlertType, unknownEnumValue: AlertType.unknown)
    @Default(AlertType.unknown)
    AlertType type,
    @JsonKey(fromJson: looseString) String? title,

    /// `message` | `description` | `body`.
    @JsonKey(readValue: readAlertMessage, fromJson: looseString)
    String? message,

    /// `createdAt` | `date`.
    @JsonKey(readValue: readAlertDate, fromJson: looseDateTime)
    DateTime? createdAt,
    @JsonKey(fromJson: looseString) String? tripId,
    @JsonKey(fromJson: looseDateTime) DateTime? startTime,

    /// Read by the detail screen's "Trip Details" card; the backend does not
    /// send these today.
    @JsonKey(fromJson: looseDateTime) DateTime? date,
    @JsonKey(fromJson: looseString) String? shift,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  /// Parses the notification list in any of the shapes the endpoint has
  /// used: a raw list, `{data: [...]}` or `{data: {notifications: [...]}}`.
  static List<Alert> listFrom(Object? responseBody) {
    var node = responseBody is Map ? responseBody['data'] : responseBody;
    if (node is Map) node = node['notifications'];
    if (node is! List) return const [];
    return node
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => Alert.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }
}
