// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ratingSummaryHash() => r'a2b5e7e6b888cb8913f5c59bb1062d92cd4c991e';

/// The driver's own rating for the Home card. Non-fatal: when it can't be
/// loaded the card just shows "No ratings yet".
///
/// Copied from [ratingSummary].
@ProviderFor(ratingSummary)
final ratingSummaryProvider = AutoDisposeFutureProvider<RatingSummary>.internal(
  ratingSummary,
  name: r'ratingSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ratingSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RatingSummaryRef = AutoDisposeFutureProviderRef<RatingSummary>;
String _$pendingRateesHash() => r'fe5be45db00fccd624639e64b6804c2b50fd6512';

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

/// The parents of the just-ended [tripId] still to be rated. Best-effort: a
/// failed load is an empty list, so ending a trip is never blocked by it.
///
/// Kept alive so the answer fetched when the trip ends is the one the rating
/// screen shows; invalidate it before asking again.
///
/// Copied from [pendingRatees].
@ProviderFor(pendingRatees)
const pendingRateesProvider = PendingRateesFamily();

/// The parents of the just-ended [tripId] still to be rated. Best-effort: a
/// failed load is an empty list, so ending a trip is never blocked by it.
///
/// Kept alive so the answer fetched when the trip ends is the one the rating
/// screen shows; invalidate it before asking again.
///
/// Copied from [pendingRatees].
class PendingRateesFamily extends Family<AsyncValue<List<PendingRatee>>> {
  /// The parents of the just-ended [tripId] still to be rated. Best-effort: a
  /// failed load is an empty list, so ending a trip is never blocked by it.
  ///
  /// Kept alive so the answer fetched when the trip ends is the one the rating
  /// screen shows; invalidate it before asking again.
  ///
  /// Copied from [pendingRatees].
  const PendingRateesFamily();

  /// The parents of the just-ended [tripId] still to be rated. Best-effort: a
  /// failed load is an empty list, so ending a trip is never blocked by it.
  ///
  /// Kept alive so the answer fetched when the trip ends is the one the rating
  /// screen shows; invalidate it before asking again.
  ///
  /// Copied from [pendingRatees].
  PendingRateesProvider call(
    String tripId,
  ) {
    return PendingRateesProvider(
      tripId,
    );
  }

  @override
  PendingRateesProvider getProviderOverride(
    covariant PendingRateesProvider provider,
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
  String? get name => r'pendingRateesProvider';
}

/// The parents of the just-ended [tripId] still to be rated. Best-effort: a
/// failed load is an empty list, so ending a trip is never blocked by it.
///
/// Kept alive so the answer fetched when the trip ends is the one the rating
/// screen shows; invalidate it before asking again.
///
/// Copied from [pendingRatees].
class PendingRateesProvider extends FutureProvider<List<PendingRatee>> {
  /// The parents of the just-ended [tripId] still to be rated. Best-effort: a
  /// failed load is an empty list, so ending a trip is never blocked by it.
  ///
  /// Kept alive so the answer fetched when the trip ends is the one the rating
  /// screen shows; invalidate it before asking again.
  ///
  /// Copied from [pendingRatees].
  PendingRateesProvider(
    String tripId,
  ) : this._internal(
          (ref) => pendingRatees(
            ref as PendingRateesRef,
            tripId,
          ),
          from: pendingRateesProvider,
          name: r'pendingRateesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pendingRateesHash,
          dependencies: PendingRateesFamily._dependencies,
          allTransitiveDependencies:
              PendingRateesFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  PendingRateesProvider._internal(
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
    FutureOr<List<PendingRatee>> Function(PendingRateesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PendingRateesProvider._internal(
        (ref) => create(ref as PendingRateesRef),
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
  FutureProviderElement<List<PendingRatee>> createElement() {
    return _PendingRateesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingRateesProvider && other.tripId == tripId;
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
mixin PendingRateesRef on FutureProviderRef<List<PendingRatee>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _PendingRateesProviderElement
    extends FutureProviderElement<List<PendingRatee>> with PendingRateesRef {
  _PendingRateesProviderElement(super.provider);

  @override
  String get tripId => (origin as PendingRateesProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
