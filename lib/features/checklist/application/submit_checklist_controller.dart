import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/app_exception.dart';
import '../../profile/data/profile_repository.dart';
import '../data/checklist_repository.dart';
import '../data/models/checklist_answer.dart';
import 'checklist_providers.dart';

part 'submit_checklist_controller.g.dart';

enum ChecklistSubmitResult { saved, failed, photoUploadFailed }

/// Submits the van check. State is the status of the last submit.
@riverpod
class SubmitChecklistController extends _$SubmitChecklistController {
  @override
  FutureOr<void> build() {}

  /// [photo] is a new picture; [existingPhotoUrl] is the one already saved
  /// today (kept when no new one is taken). When the photo cannot be uploaded
  /// nothing is saved and [ChecklistSubmitResult.photoUploadFailed] comes back,
  /// so the screen can ask the driver; call again with [withoutPhoto] to
  /// submit anyway (the new photo is then left out).
  Future<ChecklistSubmitResult> submit({
    String? routeId,
    required List<ChecklistAnswer> answers,
    File? photo,
    String? existingPhotoUrl,
    bool withoutPhoto = false,
  }) async {
    state = const AsyncLoading();
    var photoFailed = false;
    state = await AsyncValue.guard(() async {
      var photoUrl = existingPhotoUrl;
      if (photo != null && !withoutPhoto) {
        try {
          photoUrl =
              await ref.read(profileRepositoryProvider).uploadImage(photo);
        } on AppException {
          photoFailed = true;
          return;
        }
      }
      await ref.read(checklistRepositoryProvider).submit(
            routeId: routeId,
            answers: answers,
            photoUrl: photoUrl,
          );
      ref.invalidate(todayChecklistProvider);
    });
    if (state.hasError) return ChecklistSubmitResult.failed;
    return photoFailed
        ? ChecklistSubmitResult.photoUploadFailed
        : ChecklistSubmitResult.saved;
  }
}
