// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$driverProfileHash() => r'827905c70099321c7a58778dea4a0368825b86bc';

/// The signed-in driver's profile, fetched once and shared by every screen
/// (it used to be fetched separately by five). Invalidate after anything
/// that changes it (edit, document upload) and on sign-in / sign-out.
///
/// Copied from [driverProfile].
@ProviderFor(driverProfile)
final driverProfileProvider = FutureProvider<DriverProfile>.internal(
  driverProfile,
  name: r'driverProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$driverProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DriverProfileRef = FutureProviderRef<DriverProfile>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
