// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_trip_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeTripForHash() => r'd1ef0472fbfe238bbdc4facc0bd0e3e58815feca';

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

/// The running trip with id [tripId]: what tracking holds, or — right after
/// the app was killed and reopened — what was saved on disk. Null when this
/// phone has no such trip.
///
/// Copied from [activeTripFor].
@ProviderFor(activeTripFor)
const activeTripForProvider = ActiveTripForFamily();

/// The running trip with id [tripId]: what tracking holds, or — right after
/// the app was killed and reopened — what was saved on disk. Null when this
/// phone has no such trip.
///
/// Copied from [activeTripFor].
class ActiveTripForFamily extends Family<ActiveTrip?> {
  /// The running trip with id [tripId]: what tracking holds, or — right after
  /// the app was killed and reopened — what was saved on disk. Null when this
  /// phone has no such trip.
  ///
  /// Copied from [activeTripFor].
  const ActiveTripForFamily();

  /// The running trip with id [tripId]: what tracking holds, or — right after
  /// the app was killed and reopened — what was saved on disk. Null when this
  /// phone has no such trip.
  ///
  /// Copied from [activeTripFor].
  ActiveTripForProvider call(
    String tripId,
  ) {
    return ActiveTripForProvider(
      tripId,
    );
  }

  @override
  ActiveTripForProvider getProviderOverride(
    covariant ActiveTripForProvider provider,
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
  String? get name => r'activeTripForProvider';
}

/// The running trip with id [tripId]: what tracking holds, or — right after
/// the app was killed and reopened — what was saved on disk. Null when this
/// phone has no such trip.
///
/// Copied from [activeTripFor].
class ActiveTripForProvider extends AutoDisposeProvider<ActiveTrip?> {
  /// The running trip with id [tripId]: what tracking holds, or — right after
  /// the app was killed and reopened — what was saved on disk. Null when this
  /// phone has no such trip.
  ///
  /// Copied from [activeTripFor].
  ActiveTripForProvider(
    String tripId,
  ) : this._internal(
          (ref) => activeTripFor(
            ref as ActiveTripForRef,
            tripId,
          ),
          from: activeTripForProvider,
          name: r'activeTripForProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activeTripForHash,
          dependencies: ActiveTripForFamily._dependencies,
          allTransitiveDependencies:
              ActiveTripForFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ActiveTripForProvider._internal(
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
  Override overrideWith(
    ActiveTrip? Function(ActiveTripForRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveTripForProvider._internal(
        (ref) => create(ref as ActiveTripForRef),
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
  AutoDisposeProviderElement<ActiveTrip?> createElement() {
    return _ActiveTripForProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveTripForProvider && other.tripId == tripId;
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
mixin ActiveTripForRef on AutoDisposeProviderRef<ActiveTrip?> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ActiveTripForProviderElement
    extends AutoDisposeProviderElement<ActiveTrip?> with ActiveTripForRef {
  _ActiveTripForProviderElement(super.provider);

  @override
  String get tripId => (origin as ActiveTripForProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
