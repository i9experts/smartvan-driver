import 'dart:async';
import 'package:location/location.dart' as loc;
import 'package:mocktail/mocktail.dart';

/// A scripted GPS: permission answers are fields, fixes are pushed with [emit].
class FakeLocation extends Mock implements loc.Location {
  FakeLocation({
    this.serviceEnabledAnswer = true,
    this.requestServiceAnswer = true,
    this.permission = loc.PermissionStatus.granted,
    this.permissionAfterRequest = loc.PermissionStatus.granted,
  }) {
    when(() => serviceEnabled()).thenAnswer((_) async => serviceEnabledAnswer);
    when(() => requestService()).thenAnswer((_) async => requestServiceAnswer);
    when(() => hasPermission()).thenAnswer((_) async => permission);
    when(() => requestPermission())
        .thenAnswer((_) async => permissionAfterRequest);
    when(() => changeSettings(
          accuracy: any(named: 'accuracy'),
          interval: any(named: 'interval'),
          distanceFilter: any(named: 'distanceFilter'),
        )).thenAnswer((_) async => true);
    when(() => changeNotificationOptions(
          title: any(named: 'title'),
          subtitle: any(named: 'subtitle'),
          onTapBringToFront: any(named: 'onTapBringToFront'),
        )).thenAnswer((_) async => null);
    when(() => enableBackgroundMode(enable: any(named: 'enable')))
        .thenAnswer((_) async => true);
    when(() => onLocationChanged).thenAnswer((_) => _fixes.stream);
  }

  bool serviceEnabledAnswer;
  bool requestServiceAnswer;
  loc.PermissionStatus permission;
  loc.PermissionStatus permissionAfterRequest;
  final _fixes = StreamController<loc.LocationData>.broadcast();

  /// Pushes a GPS fix (speed in m/s).
  void emit(double lat, double lng, {double? speed}) =>
      _fixes.add(loc.LocationData.fromMap({
        'latitude': lat,
        'longitude': lng,
        if (speed != null) 'speed': speed,
      }));

  bool get hasListener => _fixes.hasListener;

  Future<void> close() => _fixes.close();
}
