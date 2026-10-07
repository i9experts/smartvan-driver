import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'payment_status.dart';

part 'fee_student.freezed.dart';
part 'fee_student.g.dart';

/// One row of `GET /fees/driver-students`.
@freezed
abstract class FeeStudent with _$FeeStudent {
  const factory FeeStudent({
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String kidId,

    /// `YYYY-MM`.
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String month,
    @JsonKey(readValue: readFullname, fromJson: looseStringOrEmpty)
    @Default('')
    String fullname,
    @JsonKey(fromJson: looseString) String? image,
    @JsonKey(fromJson: looseString) String? grade,
    @JsonKey(
      readValue: readStatusLower,
      unknownEnumValue: PaymentStatus.unknown,
    )
    @Default(PaymentStatus.unknown)
    PaymentStatus status,

    /// Arrives as a number or a numeric string.
    @JsonKey(fromJson: looseDouble) double? amount,
    @JsonKey(fromJson: looseString) String? currency,
    @JsonKey(fromJson: looseString) String? paymentId,
  }) = _FeeStudent;

  factory FeeStudent.fromJson(Map<String, dynamic> json) =>
      _$FeeStudentFromJson(json);
}
