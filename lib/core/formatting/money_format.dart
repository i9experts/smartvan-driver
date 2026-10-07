/// An amount as the backend shows it: whole numbers without decimals
/// (`4500`), others as they are (`4500.5`).
String formatAmount(num amount) {
  final d = amount.toDouble();
  return d == d.roundToDouble() ? d.toInt().toString() : d.toString();
}

/// "PKR 4500".
String formatMoney(String currency, num amount) =>
    '$currency ${formatAmount(amount)}';
