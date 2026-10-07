import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'scan_result.freezed.dart';
part 'scan_result.g.dart';

enum ScanAction {
  @JsonValue('picked')
  picked,
  @JsonValue('dropped')
  dropped,

  /// Anything the backend adds later.
  unknown,
}

/// `POST /trips/scanStudent` → `data`.
@freezed
abstract class ScanResult with _$ScanResult {
  const factory ScanResult({
    @JsonKey(unknownEnumValue: ScanAction.unknown)
    @Default(ScanAction.unknown)
    ScanAction action,
    @JsonKey(readValue: readKidId, fromJson: looseStringOrEmpty)
    @Default('')
    String kidId,
    @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
    @Default('')
    String fullname,
  }) = _ScanResult;

  factory ScanResult.fromJson(Map<String, dynamic> json) =>
      _$ScanResultFromJson(json);
}
