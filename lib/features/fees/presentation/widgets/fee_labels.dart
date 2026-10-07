import '../../../../l10n/l10n.dart';
import '../../data/models/payment_method.dart';

extension PaymentMethodLabel on PaymentMethod {
  String label(AppLocalizations l10n) => switch (this) {
        PaymentMethod.cash => l10n.paymentMethodCash,
        PaymentMethod.jazzcash => l10n.paymentMethodJazzcash,
        PaymentMethod.easypaisa => l10n.paymentMethodEasypaisa,
        PaymentMethod.raast => l10n.paymentMethodRaast,
        PaymentMethod.bankTransfer => l10n.paymentMethodBankTransfer,
        PaymentMethod.card => l10n.paymentMethodCard,
        PaymentMethod.unknown => l10n.paymentMethodOther,
      };
}
