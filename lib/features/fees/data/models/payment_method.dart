import 'package:json_annotation/json_annotation.dart';

enum PaymentMethod {
  @JsonValue('cash')
  cash,
  @JsonValue('jazzcash')
  jazzcash,
  @JsonValue('easypaisa')
  easypaisa,
  @JsonValue('raast')
  raast,
  @JsonValue('bank_transfer')
  bankTransfer,
  @JsonValue('card')
  card,

  /// Anything the backend adds later.
  unknown,
}
