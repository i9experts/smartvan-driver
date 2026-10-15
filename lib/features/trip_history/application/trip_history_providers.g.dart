// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayCompletedTripsHash() =>
    r'706f9367a9510a4bde87544b4b8e04efe530d65b';

/// Today's (PKT) completed trips for Home: at most [homeTodayTripLimit],
/// newest first. The server already limits to today; the PKT-day check
/// guards against a trip of another day slipping in.
///
/// Copied from [todayCompletedTrips].
@ProviderFor(todayCompletedTrips)
final todayCompletedTripsProvider =
    AutoDisposeFutureProvider<List<CompletedTrip>>.internal(
  todayCompletedTrips,
  name: r'todayCompletedTripsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayCompletedTripsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayCompletedTripsRef
    = AutoDisposeFutureProviderRef<List<CompletedTrip>>;
String _$tripDetailsHash() => r'441c1a4b49fc7751dcb1e68ab7d586efeec4a129';

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

/// One finished trip with its stops, students, alerts and school.
///
/// Copied from [tripDetails].
@ProviderFor(tripDetails)
const tripDetailsProvider = TripDetailsFamily();

/// One finished trip with its stops, students, alerts and school.
///
/// Copied from [tripDetails].
class TripDetailsFamily extends Family<AsyncValue<TripDetails>> {
  /// One finished trip with its stops, students, alerts and school.
  ///
  /// Copied from [tripDetails].
  const TripDetailsFamily();

  /// One finished trip with its stops, students, alerts and school.
  ///
  /// Copied from [tripDetails].
  TripDetailsProvider call(
    String tripId,
  ) {
    return TripDetailsProvider(
      tripId,
    );
  }

  @override
  TripDetailsProvider getProviderOverride(
    covariant TripDetailsProvider provider,
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
  String? get name => r'tripDetailsProvider';
}

/// One finished trip with its stops, students, alerts and school.
///
/// Copied from [tripDetails].
class TripDetailsProvider extends AutoDisposeFutureProvider<TripDetails> {
  /// One finished trip with its stops, students, alerts and school.
  ///
  /// Copied from [tripDetails].
  TripDetailsProvider(
    String tripId,
  ) : this._internal(
          (ref) => tripDetails(
            ref as TripDetailsRef,
            tripId,
          ),
          from: tripDetailsProvider,
          name: r'tripDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripDetailsHash,
          dependencies: TripDetailsFamily._dependencies,
          allTransitiveDependencies:
              TripDetailsFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripDetailsProvider._internal(
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
    FutureOr<TripDetails> Function(TripDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripDetailsProvider._internal(
        (ref) => create(ref as TripDetailsRef),
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
  AutoDisposeFutureProviderElement<TripDetails> createElement() {
    return _TripDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripDetailsProvider && other.tripId == tripId;
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
mixin TripDetailsRef on AutoDisposeFutureProviderRef<TripDetails> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripDetailsProviderElement
    extends AutoDisposeFutureProviderElement<TripDetails> with TripDetailsRef {
  _TripDetailsProviderElement(super.provider);

  @override
  String get tripId => (origin as TripDetailsProvider).tripId;
}

String _$historyTrailHash() => r'40225c29882a920d5aea5188be7dfc9d64a67dd9';

/// The saved driven path of a finished trip. A trail that cannot be loaded
/// is an empty one: the screen says the route is not available.
///
/// Copied from [historyTrail].
@ProviderFor(historyTrail)
const historyTrailProvider = HistoryTrailFamily();

/// The saved driven path of a finished trip. A trail that cannot be loaded
/// is an empty one: the screen says the route is not available.
///
/// Copied from [historyTrail].
class HistoryTrailFamily extends Family<AsyncValue<TripTrail>> {
  /// The saved driven path of a finished trip. A trail that cannot be loaded
  /// is an empty one: the screen says the route is not available.
  ///
  /// Copied from [historyTrail].
  const HistoryTrailFamily();

  /// The saved driven path of a finished trip. A trail that cannot be loaded
  /// is an empty one: the screen says the route is not available.
  ///
  /// Copied from [historyTrail].
  HistoryTrailProvider call(
    String tripId,
  ) {
    return HistoryTrailProvider(
      tripId,
    );
  }

  @override
  HistoryTrailProvider getProviderOverride(
    covariant HistoryTrailProvider provider,
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
  String? get name => r'historyTrailProvider';
}

/// The saved driven path of a finished trip. A trail that cannot be loaded
/// is an empty one: the screen says the route is not available.
///
/// Copied from [historyTrail].
class HistoryTrailProvider extends AutoDisposeFutureProvider<TripTrail> {
  /// The saved driven path of a finished trip. A trail that cannot be loaded
  /// is an empty one: the screen says the route is not available.
  ///
  /// Copied from [historyTrail].
  HistoryTrailProvider(
    String tripId,
  ) : this._internal(
          (ref) => historyTrail(
            ref as HistoryTrailRef,
            tripId,
          ),
          from: historyTrailProvider,
          name: r'historyTrailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$historyTrailHash,
          dependencies: HistoryTrailFamily._dependencies,
          allTransitiveDependencies:
              HistoryTrailFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  HistoryTrailProvider._internal(
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
    FutureOr<TripTrail> Function(HistoryTrailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HistoryTrailProvider._internal(
        (ref) => create(ref as HistoryTrailRef),
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
  AutoDisposeFutureProviderElement<TripTrail> createElement() {
    return _HistoryTrailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HistoryTrailProvider && other.tripId == tripId;
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
mixin HistoryTrailRef on AutoDisposeFutureProviderRef<TripTrail> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _HistoryTrailProviderElement
    extends AutoDisposeFutureProviderElement<TripTrail> with HistoryTrailRef {
  _HistoryTrailProviderElement(super.provider);

  @override
  String get tripId => (origin as HistoryTrailProvider).tripId;
}

String _$tripHistoryHash() => r'08d109c38560aea6cc6c12ed2c372607dc25710e';

/// The paginated History list (infinite scroll, pull-to-refresh, filter).
///
/// Copied from [TripHistory].
@ProviderFor(TripHistory)
final tripHistoryProvider =
    AutoDisposeAsyncNotifierProvider<TripHistory, TripHistoryState>.internal(
  TripHistory.new,
  name: r'tripHistoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tripHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TripHistory = AutoDisposeAsyncNotifier<TripHistoryState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
