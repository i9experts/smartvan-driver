import '../../../core/formatting/date_formats.dart';
import '../../home/application/doc_expiry.dart';

/// How a document's expiry date should be shown.
enum ExpiryStatus {
  /// Nothing to warn about.
  ok,

  /// Expires within [docExpiryWarningDays] (today included).
  soon,

  /// Already past.
  expired,
}

ExpiryStatus expiryStatus(DateTime expiry, DateTime now) {
  final days = daysUntil(expiry.toLocal(), now);
  if (days < 0) return ExpiryStatus.expired;
  if (days <= docExpiryWarningDays) return ExpiryStatus.soon;
  return ExpiryStatus.ok;
}
