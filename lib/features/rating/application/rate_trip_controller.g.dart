// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_trip_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rateTripControllerHash() =>
    r'51cfb16be623e3838717fb7f4db79212d3dc414d';

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

abstract class _$RateTripController
    extends BuildlessAutoDisposeAsyncNotifier<RateTripState> {
  late final String tripId;

  FutureOr<RateTripState> build(
    String tripId,
  );
}

/// Steps through the parents of one ended trip: rate and go on, or skip.
///
/// Copied from [RateTripController].
@ProviderFor(RateTripController)
const rateTripControllerProvider = RateTripControllerFamily();

/// Steps through the parents of one ended trip: rate and go on, or skip.
///
/// Copied from [RateTripController].
class RateTripControllerFamily extends Family<AsyncValue<RateTripState>> {
  /// Steps through the parents of one ended trip: rate and go on, or skip.
  ///
  /// Copied from [RateTripController].
  const RateTripControllerFamily();

  /// Steps through the parents of one ended trip: rate and go on, or skip.
  ///
  /// Copied from [RateTripController].
  RateTripControllerProvider call(
    String tripId,
  ) {
    return RateTripControllerProvider(
      tripId,
    );
  }

  @override
  RateTripControllerProvider getProviderOverride(
    covariant RateTripControllerProvider provider,
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
  String? get name => r'rateTripControllerProvider';
}

/// Steps through the parents of one ended trip: rate and go on, or skip.
///
/// Copied from [RateTripController].
class RateTripControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    RateTripController, RateTripState> {
  /// Steps through the parents of one ended trip: rate and go on, or skip.
  ///
  /// Copied from [RateTripController].
  RateTripControllerProvider(
    String tripId,
  ) : this._internal(
          () => RateTripController()..tripId = tripId,
          from: rateTripControllerProvider,
          name: r'rateTripControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rateTripControllerHash,
          dependencies: RateTripControllerFamily._dependencies,
          allTransitiveDependencies:
              RateTripControllerFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  RateTripControllerProvider._internal(
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
  FutureOr<RateTripState> runNotifierBuild(
    covariant RateTripController notifier,
  ) {
    return notifier.build(
      tripId,
    );
  }

  @override
  Override overrideWith(RateTripController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RateTripControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<RateTripController, RateTripState>
      createElement() {
    return _RateTripControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RateTripControllerProvider && other.tripId == tripId;
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
mixin RateTripControllerRef
    on AutoDisposeAsyncNotifierProviderRef<RateTripState> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _RateTripControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RateTripController,
        RateTripState> with RateTripControllerRef {
  _RateTripControllerProviderElement(super.provider);

  @override
  String get tripId => (origin as RateTripControllerProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
