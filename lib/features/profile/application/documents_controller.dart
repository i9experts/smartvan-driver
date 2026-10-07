import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/driver_document_type.dart';
import '../data/profile_repository.dart';
import 'driver_profile_provider.dart';

part 'documents_controller.g.dart';

/// Uploads a driver document. State is the status of the last upload.
@riverpod
class DocumentsController extends _$DocumentsController {
  @override
  FutureOr<void> build() {}

  /// Uploads [image], attaches it to [type] and refreshes the profile (which
  /// holds the document URLs). Returns true on success.
  Future<bool> upload(DriverDocumentType type, File image) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      final url = await repo.uploadImage(image);
      await repo.uploadDocument(type, url);
      ref.invalidate(driverProfileProvider);
    });
    return !state.hasError;
  }
}
