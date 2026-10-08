import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'trip.dart';
import 'trip_type.dart';

part 'active_trip.freezed.dart';
part 'active_trip.g.dart';

/// The trip that is running on this phone: what tracking needs and what the
/// trip screen shows. Saved to disk so tracking can resume if the OS kills
/// the app; the JSON keys match what older builds stored.
@freezed
abstract class ActiveTrip with _$ActiveTrip {
  const factory ActiveTrip({
    @JsonKey(readValue: readId, fromJson: looseStringOrEmpty)
    @Default('')
    String id,
    @JsonKey(fromJson: looseString) String? routeId,

    /// The route's title (stored as `schoolRoute`).
    @JsonKey(
        name: 'schoolRoute', readValue: _readRouteTitle, fromJson: looseString)
    String? routeTitle,

    /// The trip document's own name (`tripName` | `name`).
    @JsonKey(name: 'tripName', readValue: _readName, fromJson: looseString)
    String? name,
    @JsonKey(readValue: readTypeLower, unknownEnumValue: TripType.unknown)
    @Default(TripType.unknown)
    TripType type,

    /// When the trip started (`tripStart.startTime`); null if unknown.
    @JsonKey(readValue: readTripStartTime, fromJson: looseDateTime)
    DateTime? startTime,
  }) = _ActiveTrip;

  factory ActiveTrip.fromJson(Map<String, dynamic> json) =>
      _$ActiveTripFromJson(json);

  /// A freshly started [trip]; [routeTitle] comes from the route it was
  /// started from (the trip document has only a bare route id).
  factory ActiveTrip.fromTrip(Trip trip, {String? routeTitle}) => ActiveTrip(
        id: trip.id ?? '',
        routeId: trip.routeId,
        routeTitle: routeTitle,
        name: trip.name,
        type: trip.type,
        startTime: trip.startTime,
      );
}

Object? _readRouteTitle(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['schoolRoute', 'routeTitle', 'route']);

Object? _readName(Map<dynamic, dynamic> m, String _) =>
    firstOf(m, ['tripName', 'name']);
