// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_tracking.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tripTrackingHash() => r'6339989986fdd27251027cceb7dd3e7f40651d73';

/// Owns everything that must keep running for the whole trip — GPS stream,
/// Android foreground service, Socket.IO connection — independent of which
/// screen is open.
///
/// Copied from [TripTracking].
@ProviderFor(TripTracking)
final tripTrackingProvider =
    NotifierProvider<TripTracking, TripTrackingState>.internal(
  TripTracking.new,
  name: r'tripTrackingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tripTrackingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TripTracking = Notifier<TripTrackingState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
