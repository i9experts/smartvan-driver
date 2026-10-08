import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/features/profile/application/document_expiry.dart';

void main() {
  final now = DateTime(2026, 10, 8, 15, 30);

  test('more than 30 days away is ok', () {
    expect(expiryStatus(DateTime(2026, 11, 8), now), ExpiryStatus.ok); // 31
    expect(expiryStatus(DateTime(2027, 3, 15), now), ExpiryStatus.ok);
  });

  test('30 days or fewer, today included, is soon', () {
    expect(expiryStatus(DateTime(2026, 11, 7), now), ExpiryStatus.soon); // 30
    expect(expiryStatus(DateTime(2026, 10, 9), now), ExpiryStatus.soon);
    expect(expiryStatus(DateTime(2026, 10, 8), now), ExpiryStatus.soon);
  });

  test('yesterday and before is expired', () {
    expect(expiryStatus(DateTime(2026, 10, 7), now), ExpiryStatus.expired);
    expect(expiryStatus(DateTime(2025, 1, 1), now), ExpiryStatus.expired);
  });
}
