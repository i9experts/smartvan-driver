import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/driver_document_type.dart';
import '../data/profile_repository.dart';
import 'driver_profile_provider.dart';

part 'documents_controller.g.dart';

/// Uploads and removes driver documents. State is the document being worked
/// on (null when idle), so its card can show a spinner.
///
/// Both methods return the error, or null on success. A failed upload leaves
/// the saved document exactly as it was: the new image is attached only
/// after it has been uploaded.
@riverpod
class DocumentsController extends _$DocumentsController {
  @override
  DriverDocumentType? build() => null;

  /// Uploads [image], attaches it to [type] (with [expiry] when given) and
  /// refreshes the profile, which holds the document URLs and dates.
  Future<Object?> upload(
    DriverDocumentType type,
    File image, {
    DateTime? expiry,
  }) =>
      _run(type, () async {
        final repo = ref.read(profileRepositoryProvider);
        final url = await repo.uploadImage(image);
        await repo.uploadDocument(type, url, expiry: expiry);
      });

  /// Takes [type] off the profile.
  Future<Object?> remove(DriverDocumentType type) => _run(
        type,
        () => ref.read(profileRepositoryProvider).removeDocument(type),
      );

  Future<Object?> _run(
      DriverDocumentType type, Future<void> Function() action) async {
    if (state != null) return null;
    state = type;
    try {
      await action();
      ref.invalidate(driverProfileProvider);
      return null;
    } catch (e) {
      return e;
    } finally {
      state = null;
    }
  }
}
