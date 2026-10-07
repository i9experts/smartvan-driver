import '../../../core/formatting/date_formats.dart';
import '../../profile/data/models/driver_profile.dart';

enum ExpiringDocument { licence, vehicleCard }

/// A document that expires within [docExpiryWarningDays] (or already has).
class DocExpiry {
  const DocExpiry(this.document, this.days);

  final ExpiringDocument document;

  /// Days left; negative when expired, 0 when it expires today.
  final int days;

  bool get expired => days < 0;
}

const docExpiryWarningDays = 30;

/// The driving licence / vehicle card of [profile] that need renewing soon.
List<DocExpiry> expiringDocuments(DriverProfile? profile, DateTime now) {
  if (profile == null) return const [];
  final dates = {
    ExpiringDocument.licence: profile.expiryDateLicense,
    ExpiringDocument.vehicleCard: profile.expiryDateVehicleCard,
  };
  return [
    for (final e in dates.entries)
      if (e.value != null &&
          daysUntil(e.value!.toLocal(), now) <= docExpiryWarningDays)
        DocExpiry(e.key, daysUntil(e.value!.toLocal(), now)),
  ];
}
