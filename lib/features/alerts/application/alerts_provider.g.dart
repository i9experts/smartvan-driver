// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alerts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$alertsHash() => r'4bfe25bb876630bc5670be4b28794f75f36197b9';

/// The driver's notifications, newest first as the server sends them.
/// Reloaded each time a screen starts watching it; refresh with
/// `ref.refresh(alertsProvider.future)`.
///
/// Copied from [alerts].
@ProviderFor(alerts)
final alertsProvider = AutoDisposeFutureProvider<List<Alert>>.internal(
  alerts,
  name: r'alertsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$alertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlertsRef = AutoDisposeFutureProviderRef<List<Alert>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
