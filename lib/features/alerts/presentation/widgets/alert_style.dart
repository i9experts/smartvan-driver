import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/alert_type.dart';

/// Icon and colour of an alert type.
class AlertStyle {
  const AlertStyle(this.color, this.icon);

  final Color color;
  final IconData icon;

  /// List cards: SOS/emergency red, payment green, trip navy, profile green,
  /// everything else (including document expiry) amber.
  factory AlertStyle.forList(AlertType type) => switch (type) {
        AlertType.sos ||
        AlertType.emergency =>
          const AlertStyle(Color(0xFFFF4B4B), Icons.emergency_outlined),
        AlertType.payment =>
          const AlertStyle(Color(0xFF27AE60), Icons.payment_outlined),
        AlertType.trip ||
        AlertType.newTrip =>
          const AlertStyle(Color(0xFF1B2B6B), Icons.directions_bus_outlined),
        AlertType.profile =>
          const AlertStyle(Color(0xFF27AE60), Icons.verified_outlined),
        _ => const AlertStyle(Color(0xFFFFB800), Icons.notifications_outlined),
      };

  /// Detail screen: like the list, except `new_trip` and `profile` use the
  /// default style (it has always been that way).
  factory AlertStyle.forDetail(AlertType type) => switch (type) {
        AlertType.sos ||
        AlertType.emergency =>
          const AlertStyle(Color(0xFFFF4B4B), Icons.emergency_outlined),
        AlertType.payment =>
          const AlertStyle(Color(0xFF27AE60), Icons.payment_outlined),
        AlertType.trip =>
          const AlertStyle(Color(0xFF1B2B6B), Icons.directions_bus_outlined),
        _ => const AlertStyle(Color(0xFFFFB800), Icons.notifications_outlined),
      };
}

extension AlertTypeTitle on AlertType {
  /// Heading used when the alert has no title of its own.
  String defaultTitle(AppLocalizations l10n) => switch (this) {
        AlertType.sos || AlertType.emergency => l10n.alertTitleEmergency,
        AlertType.payment => l10n.alertTitlePayment,
        AlertType.trip || AlertType.newTrip => l10n.alertTitleTrip,
        AlertType.profile => l10n.alertTitleProfile,
        _ => l10n.alertsDefaultTitle,
      };
}
