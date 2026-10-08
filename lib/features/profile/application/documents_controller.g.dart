// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$documentsControllerHash() =>
    r'46200c695a1c3caa102021a69c428e423704944c';

/// Uploads and removes driver documents. State is the document being worked
/// on (null when idle), so its card can show a spinner.
///
/// Both methods return the error, or null on success. A failed upload leaves
/// the saved document exactly as it was: the new image is attached only
/// after it has been uploaded.
///
/// Copied from [DocumentsController].
@ProviderFor(DocumentsController)
final documentsControllerProvider = AutoDisposeNotifierProvider<
    DocumentsController, DriverDocumentType?>.internal(
  DocumentsController.new,
  name: r'documentsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$documentsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DocumentsController = AutoDisposeNotifier<DriverDocumentType?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
