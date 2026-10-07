// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_payment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feePaymentControllerHash() =>
    r'79f9a82ed48465c200ea99c2ccb8ea7dc4dc45c1';

/// Records cash payments. State is the kidId being paid right now (null when
/// idle), so the list can show a spinner on that row only.
///
/// Copied from [FeePaymentController].
@ProviderFor(FeePaymentController)
final feePaymentControllerProvider =
    AutoDisposeNotifierProvider<FeePaymentController, String?>.internal(
  FeePaymentController.new,
  name: r'feePaymentControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feePaymentControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FeePaymentController = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
