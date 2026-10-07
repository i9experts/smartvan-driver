import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/app_exception.dart';
import '../../profile/data/profile_repository.dart';
import '../data/checklist_repository.dart';
import '../data/models/checklist_answer.dart';
import 'checklist_providers.dart';

part 'submit_checklist_controller.g.dart';

/// Submits the van check. State is the status of the last submit.
@riverpod
class SubmitChecklistController extends _$SubmitChecklistController {
  @override
  FutureOr<void> build() {}

  /// [photo] is a new picture; [existingPhotoUrl] is the one already saved
  /// today (kept when no new one is taken). A photo that cannot be uploaded
  /// is skipped — the check itself still goes through, as it always has.
  /// Returns true when the checklist was saved.
  Future<bool> submit({
    String? routeId,
    required List<ChecklistAnswer> answers,
    File? photo,
    String? existingPhotoUrl,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      var photoUrl = existingPhotoUrl;
      if (photo != null) {
        try {
          photoUrl =
              await ref.read(profileRepositoryProvider).uploadImage(photo);
        } on ApiError catch (e) {
          if (e.code != 'UPLOAD_FAILED') rethrow;
        }
      }
      await ref.read(checklistRepositoryProvider).submit(
            routeId: routeId,
            answers: answers,
            photoUrl: photoUrl,
          );
      ref.invalidate(todayChecklistProvider);
    });
    return !state.hasError;
  }
}
