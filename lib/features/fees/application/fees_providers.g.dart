// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fees_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feeStudentsHash() => r'2782bec9aacc48a184afa02765d4add62a9ae4fc';

/// Every kid on the van with this month's fee status.
///
/// Copied from [feeStudents].
@ProviderFor(feeStudents)
final feeStudentsProvider =
    AutoDisposeFutureProvider<List<FeeStudent>>.internal(
  feeStudents,
  name: r'feeStudentsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$feeStudentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeeStudentsRef = AutoDisposeFutureProviderRef<List<FeeStudent>>;
String _$feeSummaryHash() => r'500268da7d2b8108aa93eedf4b51e1078aeda48d';

/// This month's totals. Null when the endpoint is unavailable — the card is
/// simply not shown then.
///
/// Copied from [feeSummary].
@ProviderFor(feeSummary)
final feeSummaryProvider = AutoDisposeFutureProvider<FeeSummary?>.internal(
  feeSummary,
  name: r'feeSummaryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$feeSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeeSummaryRef = AutoDisposeFutureProviderRef<FeeSummary?>;
String _$receiptHash() => r'c663db98ed89e5857a5c8b3ce9cedfb98e1aaa6c';

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

/// One payment receipt.
///
/// Copied from [receipt].
@ProviderFor(receipt)
const receiptProvider = ReceiptFamily();

/// One payment receipt.
///
/// Copied from [receipt].
class ReceiptFamily extends Family<AsyncValue<Receipt>> {
  /// One payment receipt.
  ///
  /// Copied from [receipt].
  const ReceiptFamily();

  /// One payment receipt.
  ///
  /// Copied from [receipt].
  ReceiptProvider call(
    String paymentId,
  ) {
    return ReceiptProvider(
      paymentId,
    );
  }

  @override
  ReceiptProvider getProviderOverride(
    covariant ReceiptProvider provider,
  ) {
    return call(
      provider.paymentId,
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
  String? get name => r'receiptProvider';
}

/// One payment receipt.
///
/// Copied from [receipt].
class ReceiptProvider extends AutoDisposeFutureProvider<Receipt> {
  /// One payment receipt.
  ///
  /// Copied from [receipt].
  ReceiptProvider(
    String paymentId,
  ) : this._internal(
          (ref) => receipt(
            ref as ReceiptRef,
            paymentId,
          ),
          from: receiptProvider,
          name: r'receiptProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$receiptHash,
          dependencies: ReceiptFamily._dependencies,
          allTransitiveDependencies: ReceiptFamily._allTransitiveDependencies,
          paymentId: paymentId,
        );

  ReceiptProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.paymentId,
  }) : super.internal();

  final String paymentId;

  @override
  Override overrideWith(
    FutureOr<Receipt> Function(ReceiptRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReceiptProvider._internal(
        (ref) => create(ref as ReceiptRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        paymentId: paymentId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Receipt> createElement() {
    return _ReceiptProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReceiptProvider && other.paymentId == paymentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, paymentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReceiptRef on AutoDisposeFutureProviderRef<Receipt> {
  /// The parameter `paymentId` of this provider.
  String get paymentId;
}

class _ReceiptProviderElement extends AutoDisposeFutureProviderElement<Receipt>
    with ReceiptRef {
  _ReceiptProviderElement(super.provider);

  @override
  String get paymentId => (origin as ReceiptProvider).paymentId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
