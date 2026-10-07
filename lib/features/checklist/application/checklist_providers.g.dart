// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayChecklistHash() => r'7d8fc83b5207e5df9fe14008acd40bc5e05d0cac';

/// Today's van check status (done? all ok? required by the school?). The
/// home screen's card watches it; invalidate after a submit.
///
/// Copied from [todayChecklist].
@ProviderFor(todayChecklist)
final todayChecklistProvider =
    AutoDisposeFutureProvider<TodayChecklist>.internal(
  todayChecklist,
  name: r'todayChecklistProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayChecklistHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayChecklistRef = AutoDisposeFutureProviderRef<TodayChecklist>;
String _$checklistFormDataHash() => r'9f7ae1b6074606f904438de14eaff02722864adb';

/// See also [checklistFormData].
@ProviderFor(checklistFormData)
final checklistFormDataProvider =
    AutoDisposeFutureProvider<ChecklistFormData>.internal(
  checklistFormData,
  name: r'checklistFormDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checklistFormDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChecklistFormDataRef = AutoDisposeFutureProviderRef<ChecklistFormData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
