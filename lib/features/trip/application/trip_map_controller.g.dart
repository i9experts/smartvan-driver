// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_map_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routePlanControllerHash() =>
    r'e65700c45cf5dfca33c87db0185ccf15cdf0ac47';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$RoutePlanController
    extends BuildlessAutoDisposeAsyncNotifier<RoutePlan> {
  late final String tripId;

  FutureOr<RoutePlan> build(
    String tripId,
  );
}

/// The trip's planned route: stops, school and the road ahead. Reloaded
/// every 60 s and whenever a kid's pick / drop / absent / no-show state
/// changes. A failed reload keeps the last plan.
///
/// Copied from [RoutePlanController].
@ProviderFor(RoutePlanController)
const routePlanControllerProvider = RoutePlanControllerFamily();

/// The trip's planned route: stops, school and the road ahead. Reloaded
/// every 60 s and whenever a kid's pick / drop / absent / no-show state
/// changes. A failed reload keeps the last plan.
///
/// Copied from [RoutePlanController].
class RoutePlanControllerFamily extends Family<AsyncValue<RoutePlan>> {
  /// The trip's planned route: stops, school and the road ahead. Reloaded
  /// every 60 s and whenever a kid's pick / drop / absent / no-show state
  /// changes. A failed reload keeps the last plan.
  ///
  /// Copied from [RoutePlanController].
  const RoutePlanControllerFamily();

  /// The trip's planned route: stops, school and the road ahead. Reloaded
  /// every 60 s and whenever a kid's pick / drop / absent / no-show state
  /// changes. A failed reload keeps the last plan.
  ///
  /// Copied from [RoutePlanController].
  RoutePlanControllerProvider call(
    String tripId,
  ) {
    return RoutePlanControllerProvider(
      tripId,
    );
  }

  @override
  RoutePlanControllerProvider getProviderOverride(
    covariant RoutePlanControllerProvider provider,
  ) {
    return call(
      provider.tripId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'routePlanControllerProvider';
}

/// The trip's planned route: stops, school and the road ahead. Reloaded
/// every 60 s and whenever a kid's pick / drop / absent / no-show state
/// changes. A failed reload keeps the last plan.
///
/// Copied from [RoutePlanController].
class RoutePlanControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    RoutePlanController, RoutePlan> {
  /// The trip's planned route: stops, school and the road ahead. Reloaded
  /// every 60 s and whenever a kid's pick / drop / absent / no-show state
  /// changes. A failed reload keeps the last plan.
  ///
  /// Copied from [RoutePlanController].
  RoutePlanControllerProvider(
    String tripId,
  ) : this._internal(
          () => RoutePlanController()..tripId = tripId,
          from: routePlanControllerProvider,
          name: r'routePlanControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$routePlanControllerHash,
          dependencies: RoutePlanControllerFamily._dependencies,
          allTransitiveDependencies:
              RoutePlanControllerFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  RoutePlanControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tripId,
  }) : super.internal();

  final String tripId;

  @override
  FutureOr<RoutePlan> runNotifierBuild(
    covariant RoutePlanController notifier,
  ) {
    return notifier.build(
      tripId,
    );
  }

  @override
  Override overrideWith(RoutePlanController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RoutePlanControllerProvider._internal(
        () => create()..tripId = tripId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tripId: tripId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RoutePlanController, RoutePlan>
      createElement() {
    return _RoutePlanControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutePlanControllerProvider && other.tripId == tripId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tripId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoutePlanControllerRef on AutoDisposeAsyncNotifierProviderRef<RoutePlan> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _RoutePlanControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RoutePlanController,
        RoutePlan> with RoutePlanControllerRef {
  _RoutePlanControllerProviderElement(super.provider);

  @override
  String get tripId => (origin as RoutePlanControllerProvider).tripId;
}

String _$tripTrailControllerHash() =>
    r'aa77cb563d9fc3bf42ed30d0ff917685d7d5c6fb';

abstract class _$TripTrailController
    extends BuildlessAutoDisposeAsyncNotifier<List<LatLng>> {
  late final String tripId;

  FutureOr<List<LatLng>> build(
    String tripId,
  );
}

/// Where the van has been: the server's trail, then every live fix.
///
/// Copied from [TripTrailController].
@ProviderFor(TripTrailController)
const tripTrailControllerProvider = TripTrailControllerFamily();

/// Where the van has been: the server's trail, then every live fix.
///
/// Copied from [TripTrailController].
class TripTrailControllerFamily extends Family<AsyncValue<List<LatLng>>> {
  /// Where the van has been: the server's trail, then every live fix.
  ///
  /// Copied from [TripTrailController].
  const TripTrailControllerFamily();

  /// Where the van has been: the server's trail, then every live fix.
  ///
  /// Copied from [TripTrailController].
  TripTrailControllerProvider call(
    String tripId,
  ) {
    return TripTrailControllerProvider(
      tripId,
    );
  }

  @override
  TripTrailControllerProvider getProviderOverride(
    covariant TripTrailControllerProvider provider,
  ) {
    return call(
      provider.tripId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tripTrailControllerProvider';
}

/// Where the van has been: the server's trail, then every live fix.
///
/// Copied from [TripTrailController].
class TripTrailControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TripTrailController, List<LatLng>> {
  /// Where the van has been: the server's trail, then every live fix.
  ///
  /// Copied from [TripTrailController].
  TripTrailControllerProvider(
    String tripId,
  ) : this._internal(
          () => TripTrailController()..tripId = tripId,
          from: tripTrailControllerProvider,
          name: r'tripTrailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripTrailControllerHash,
          dependencies: TripTrailControllerFamily._dependencies,
          allTransitiveDependencies:
              TripTrailControllerFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripTrailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tripId,
  }) : super.internal();

  final String tripId;

  @override
  FutureOr<List<LatLng>> runNotifierBuild(
    covariant TripTrailController notifier,
  ) {
    return notifier.build(
      tripId,
    );
  }

  @override
  Override overrideWith(TripTrailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: TripTrailControllerProvider._internal(
        () => create()..tripId = tripId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tripId: tripId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TripTrailController, List<LatLng>>
      createElement() {
    return _TripTrailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripTrailControllerProvider && other.tripId == tripId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tripId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TripTrailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<LatLng>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripTrailControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TripTrailController,
        List<LatLng>> with TripTrailControllerRef {
  _TripTrailControllerProviderElement(super.provider);

  @override
  String get tripId => (origin as TripTrailControllerProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
