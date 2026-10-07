// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$driverStatsHash() => r'42d04408340b8c852830d53088e847b4edb0ec32';

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

/// The driver's own performance over the last [days] days (the app asks for
/// 7 or 30).
///
/// Copied from [driverStats].
@ProviderFor(driverStats)
const driverStatsProvider = DriverStatsFamily();

/// The driver's own performance over the last [days] days (the app asks for
/// 7 or 30).
///
/// Copied from [driverStats].
class DriverStatsFamily extends Family<AsyncValue<DriverStats>> {
  /// The driver's own performance over the last [days] days (the app asks for
  /// 7 or 30).
  ///
  /// Copied from [driverStats].
  const DriverStatsFamily();

  /// The driver's own performance over the last [days] days (the app asks for
  /// 7 or 30).
  ///
  /// Copied from [driverStats].
  DriverStatsProvider call(
    int days,
  ) {
    return DriverStatsProvider(
      days,
    );
  }

  @override
  DriverStatsProvider getProviderOverride(
    covariant DriverStatsProvider provider,
  ) {
    return call(
      provider.days,
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
  String? get name => r'driverStatsProvider';
}

/// The driver's own performance over the last [days] days (the app asks for
/// 7 or 30).
///
/// Copied from [driverStats].
class DriverStatsProvider extends AutoDisposeFutureProvider<DriverStats> {
  /// The driver's own performance over the last [days] days (the app asks for
  /// 7 or 30).
  ///
  /// Copied from [driverStats].
  DriverStatsProvider(
    int days,
  ) : this._internal(
          (ref) => driverStats(
            ref as DriverStatsRef,
            days,
          ),
          from: driverStatsProvider,
          name: r'driverStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$driverStatsHash,
          dependencies: DriverStatsFamily._dependencies,
          allTransitiveDependencies:
              DriverStatsFamily._allTransitiveDependencies,
          days: days,
        );

  DriverStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    FutureOr<DriverStats> Function(DriverStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DriverStatsProvider._internal(
        (ref) => create(ref as DriverStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DriverStats> createElement() {
    return _DriverStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DriverStatsProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DriverStatsRef on AutoDisposeFutureProviderRef<DriverStats> {
  /// The parameter `days` of this provider.
  int get days;
}

class _DriverStatsProviderElement
    extends AutoDisposeFutureProviderElement<DriverStats> with DriverStatsRef {
  _DriverStatsProviderElement(super.provider);

  @override
  int get days => (origin as DriverStatsProvider).days;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
