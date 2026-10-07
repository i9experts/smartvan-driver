import '../../../core/network/app_exception.dart';
import 'models/kid_not_dropped.dart';

/// Backend codes of the trip endpoints (`ApiError.code`).
class TripErrorCodes {
  TripErrorCodes._();
  static const kidsNotDropped = 'KIDS_NOT_DROPPED';
  static const checklistRequired = 'CHECKLIST_REQUIRED';
  static const tripNotOngoing = 'TRIP_NOT_ONGOING';
}

/// The kids list of a 409 `KIDS_NOT_DROPPED` answer of `/trips/endTrip`.
extension KidsNotDroppedError on ApiError {
  bool get isKidsNotDropped => code == TripErrorCodes.kidsNotDropped;

  /// Kids still on the van; empty if the body has none (or this is another
  /// error).
  List<KidNotDropped> get kidsNotDropped {
    final body = data;
    if (!isKidsNotDropped || body is! Map) return const [];
    final kids = body['kids'];
    if (kids is! List) return const [];
    return kids
        .whereType<Map<dynamic, dynamic>>()
        .map((k) => KidNotDropped.fromJson(Map<String, dynamic>.from(k)))
        .toList();
  }
}
