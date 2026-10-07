// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passengers_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passengersControllerHash() =>
    r'd520723bf83bd42e5e0baf051f249933a2121e3a';

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

abstract class _$PassengersController
    extends BuildlessAutoDisposeAsyncNotifier<PassengersState> {
  late final String tripId;

  FutureOr<PassengersState> build(
    String tripId,
  );
}

/// The kids of trip [tripId]: loading, counting, pick/drop (through the
/// offline queue), "at stop" and "no-show". One copy shared by the trip and
/// passengers screens.
///
/// Copied from [PassengersController].
@ProviderFor(PassengersController)
const passengersControllerProvider = PassengersControllerFamily();

/// The kids of trip [tripId]: loading, counting, pick/drop (through the
/// offline queue), "at stop" and "no-show". One copy shared by the trip and
/// passengers screens.
///
/// Copied from [PassengersController].
class PassengersControllerFamily extends Family<AsyncValue<PassengersState>> {
  /// The kids of trip [tripId]: loading, counting, pick/drop (through the
  /// offline queue), "at stop" and "no-show". One copy shared by the trip and
  /// passengers screens.
  ///
  /// Copied from [PassengersController].
  const PassengersControllerFamily();

  /// The kids of trip [tripId]: loading, counting, pick/drop (through the
  /// offline queue), "at stop" and "no-show". One copy shared by the trip and
  /// passengers screens.
  ///
  /// Copied from [PassengersController].
  PassengersControllerProvider call(
    String tripId,
  ) {
    return PassengersControllerProvider(
      tripId,
    );
  }

  @override
  PassengersControllerProvider getProviderOverride(
    covariant PassengersControllerProvider provider,
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
  String? get name => r'passengersControllerProvider';
}

/// The kids of trip [tripId]: loading, counting, pick/drop (through the
/// offline queue), "at stop" and "no-show". One copy shared by the trip and
/// passengers screens.
///
/// Copied from [PassengersController].
class PassengersControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PassengersController, PassengersState> {
  /// The kids of trip [tripId]: loading, counting, pick/drop (through the
  /// offline queue), "at stop" and "no-show". One copy shared by the trip and
  /// passengers screens.
  ///
  /// Copied from [PassengersController].
  PassengersControllerProvider(
    String tripId,
  ) : this._internal(
          () => PassengersController()..tripId = tripId,
          from: passengersControllerProvider,
          name: r'passengersControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$passengersControllerHash,
          dependencies: PassengersControllerFamily._dependencies,
          allTransitiveDependencies:
              PassengersControllerFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  PassengersControllerProvider._internal(
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
  FutureOr<PassengersState> runNotifierBuild(
    covariant PassengersController notifier,
  ) {
    return notifier.build(
      tripId,
    );
  }

  @override
  Override overrideWith(PassengersController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PassengersControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<PassengersController, PassengersState>
      createElement() {
    return _PassengersControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PassengersControllerProvider && other.tripId == tripId;
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
mixin PassengersControllerRef
    on AutoDisposeAsyncNotifierProviderRef<PassengersState> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _PassengersControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PassengersController,
        PassengersState> with PassengersControllerRef {
  _PassengersControllerProviderElement(super.provider);

  @override
  String get tripId => (origin as PassengersControllerProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
