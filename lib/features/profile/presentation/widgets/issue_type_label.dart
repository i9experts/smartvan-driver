import '../../../../l10n/l10n.dart';
import '../../data/models/issue_type.dart';

/// The issue types the driver can pick from (the backend's `unknown` is not
/// one of them).
const selectableIssueTypes = <IssueType>[
  IssueType.vehicleIssue,
  IssueType.runningLate,
  IssueType.passengerNoShow,
  IssueType.emergency,
  IssueType.trackingNotWorking,
  IssueType.other,
];

extension IssueTypeLabel on IssueType {
  /// Localized display label.
  String label(AppLocalizations l10n) => switch (this) {
        IssueType.vehicleIssue => l10n.reportIssueVehicle,
        IssueType.runningLate => l10n.reportIssueRunningLate,
        IssueType.passengerNoShow => l10n.reportIssuePassengerNoShow,
        IssueType.emergency => l10n.reportIssueEmergency,
        IssueType.trackingNotWorking => l10n.reportIssueTrackingNotWorking,
        IssueType.other => l10n.reportIssueOther,
        IssueType.unknown => l10n.reportIssueOther,
      };
}
