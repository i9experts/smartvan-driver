import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/features/alerts/data/models/alert.dart';
import 'package:smartvan_driver/features/alerts/data/models/alert_type.dart';

import '../../../../support/fixture.dart';

void main() {
  final shapes = fixtureMap('alerts/alerts_shapes.json');

  test('raw list', () {
    final alerts = Alert.listFrom(shapes['rawList']);
    expect(alerts, hasLength(1));
    expect(alerts[0].type, AlertType.sos);
    expect(alerts[0].title, 'SOS');
    expect(alerts[0].message, 'Driver pressed SOS');
    expect(alerts[0].createdAt, DateTime.utc(2026, 10, 6, 9));
    expect(alerts[0].tripId, 'trip-001');
  });

  test(
      '{data: [...]} with type/alertType, message/description/body, createdAt/date',
      () {
    final alerts = Alert.listFrom(shapes['dataList']);
    expect(alerts, hasLength(5));
    expect(alerts[0].type, AlertType.payment); // `type`
    expect(alerts[0].title, isNull);
    expect(alerts[0].message, 'Fee received');
    expect(alerts[1].type, AlertType.newTrip); // "NEW_TRIP" lower-cased
    expect(alerts[1].message, 'A trip was assigned'); // `description`
    expect(alerts[1].createdAt, DateTime.utc(2026, 10, 6, 6)); // `date`
    expect(alerts[1].startTime, DateTime.utc(2026, 10, 6, 8));
    expect(alerts[2].type, AlertType.documentExpiry);
    expect(alerts[2].message, 'Driving licence expires in 7 days'); // `body`
  });

  test('unknown type and empty object', () {
    final alerts = Alert.listFrom(shapes['dataList']);
    expect(alerts[3].type, AlertType.unknown); // "weather"
    expect(alerts[4].type, AlertType.unknown);
    expect(alerts[4].message, isNull);
  });

  test('{data: {notifications: [...]}}', () {
    final alerts = Alert.listFrom(shapes['dataNotifications']);
    expect(alerts.single.type, AlertType.profile);
    expect(alerts.single.message, 'Profile updated');
  });

  test('nothing usable gives an empty list', () {
    expect(Alert.listFrom(shapes['empty']), isEmpty);
    expect(Alert.listFrom(shapes['garbage']), isEmpty);
    expect(Alert.listFrom(null), isEmpty);
  });
}
