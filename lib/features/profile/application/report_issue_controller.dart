import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/issue_report.dart';
import '../data/models/issue_type.dart';
import '../data/profile_repository.dart';

part 'report_issue_controller.g.dart';

/// Sends an issue report. State is the status of the last submission.
@riverpod
class ReportIssueController extends _$ReportIssueController {
  @override
  FutureOr<void> build() {}

  /// Uploads [photo] first (if any) — a report is never sent without a photo
  /// the driver attached. Returns true when the report was sent.
  Future<bool> submit({
    required IssueType issueType,
    required String description,
    File? photo,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      final imageUrl = photo == null ? null : await repo.uploadImage(photo);
      await repo.submitReport(IssueReport(
        issueType: issueType,
        description: description.trim(),
        image: imageUrl,
      ));
    });
    return !state.hasError;
  }
}
