import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';
import 'issue_type.dart';

part 'issue_report.freezed.dart';
part 'issue_report.g.dart';

/// Body of `POST /report/addReportByDriver`.
@freezed
abstract class IssueReport with _$IssueReport {
  const factory IssueReport({
    @JsonKey(unknownEnumValue: IssueType.unknown)
    @Default(IssueType.other)
    IssueType issueType,
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String description,

    /// Always `driverReport` for this app.
    @Default('driverReport') String type,

    /// Hosted URL from `/upload/image`; left out of the body when null.
    @JsonKey(includeIfNull: false, fromJson: looseString) String? image,
  }) = _IssueReport;

  factory IssueReport.fromJson(Map<String, dynamic> json) =>
      _$IssueReportFromJson(json);
}
