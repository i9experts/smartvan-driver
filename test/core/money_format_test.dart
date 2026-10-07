import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/formatting/money_format.dart';

void main() {
  test('whole numbers have no decimals', () {
    expect(formatAmount(4500), '4500');
    expect(formatAmount(4500.0), '4500');
    expect(formatAmount(0), '0');
  });

  test('fractions are kept', () {
    expect(formatAmount(4500.5), '4500.5');
    expect(formatAmount(22500.25), '22500.25');
  });

  test('formatMoney prefixes the currency', () {
    expect(formatMoney('PKR', 31500.0), 'PKR 31500');
  });
}
