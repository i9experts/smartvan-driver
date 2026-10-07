import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'arrived_at_stop.freezed.dart';
part 'arrived_at_stop.g.dart';

/// `POST /trips/arrivedAtStop` → `data: { kidId, waitingSince }`.
@freezed
abstract class ArrivedAtStop with _$ArrivedAtStop {
  const factory ArrivedAtStop({
    @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
    @Default('')
    String kidId,
    @JsonKey(fromJson: looseDateTime) DateTime? waitingSince,
  }) = _ArrivedAtStop;

  factory ArrivedAtStop.fromJson(Map<String, dynamic> json) =>
      _$ArrivedAtStopFromJson(json);
}
