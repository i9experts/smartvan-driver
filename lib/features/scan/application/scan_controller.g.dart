// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scanControllerHash() => r'1cb02908059992363943c49ae42b8fc26ca31e9c';

/// Reads QR cards continuously while the scan screen is open: filters
/// repeats, checks there is a trip, flushes the offline queue, scans, and
/// publishes an [ScanOutcome] that clears itself after a few seconds.
///
/// Copied from [ScanController].
@ProviderFor(ScanController)
final scanControllerProvider =
    AutoDisposeNotifierProvider<ScanController, ScanState>.internal(
  ScanController.new,
  name: r'scanControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scanControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScanController = AutoDisposeNotifier<ScanState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
