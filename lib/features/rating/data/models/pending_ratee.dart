import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'pending_ratee.freezed.dart';
part 'pending_ratee.g.dart';

/// One parent the driver can still rate for a finished trip — a row of
/// `GET /rating/pendingRatings` (driver role) → `data`.
@freezed
abstract class PendingRatee with _$PendingRatee {
  const factory PendingRatee({
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String tripId,

    /// Sent as `rateeUserId` when rating.
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String parentId,
    @JsonKey(fromJson: looseString) String? parentName,
    @JsonKey(fromJson: looseString) String? parentImage,
  }) = _PendingRatee;

  factory PendingRatee.fromJson(Map<String, dynamic> json) =>
      _$PendingRateeFromJson(json);
}
