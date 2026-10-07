import '../../l10n/l10n.dart';

/// A one-tap reply: [key] is what the backend records as `templateKey`.
class QuickReply {
  const QuickReply(this.key, this.text);

  final String key;
  final String text;
}

/// Quick replies for drivers (one tap while stopped).
List<QuickReply> driverQuickReplies(AppLocalizations l10n) => [
      QuickReply('arriving_5', l10n.chatQuickArriving5),
      QuickReply('at_pickup', l10n.chatQuickAtPickup),
      QuickReply('send_out', l10n.chatQuickSendOut),
      QuickReply('running_late', l10n.chatQuickRunningLate),
      QuickReply('traffic', l10n.chatQuickTraffic),
      QuickReply('not_at_stop', l10n.chatQuickNotAtStop),
    ];

/// The role this app sends as.
const myChatRole = 'driver';
