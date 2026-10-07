import 'package:json_annotation/json_annotation.dart';

enum TripStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('ongoing')
  ongoing,
  @JsonValue('completed')
  completed,

  /// Anything the backend adds later.
  unknown,
}

/// Trip documents say `active`, `ongoing` or `start` for a running trip and
/// `end` or `completed` for a finished one. Normalised to the enum's values.
Object? readTripDocumentStatus(Map<dynamic, dynamic> m, String _) {
  final raw = m['status'];
  if (raw is! String) return raw;
  switch (raw.trim().toLowerCase()) {
    case 'active':
    case 'ongoing':
    case 'start':
      return 'ongoing';
    case 'end':
    case 'completed':
      return 'completed';
    case 'pending':
      return 'pending';
    default:
      return raw;
  }
}
