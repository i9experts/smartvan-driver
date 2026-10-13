import 'package:json_annotation/json_annotation.dart';

/// A stop's state in `GET /trips/:tripId/route-plan`.
enum StopStatus {
  @JsonValue('waiting')
  waiting,
  @JsonValue('picked')
  picked,
  @JsonValue('dropped')
  dropped,
  @JsonValue('absent')
  absent,
  @JsonValue('no_show')
  noShow,

  /// Anything the backend adds later.
  unknown,
}
