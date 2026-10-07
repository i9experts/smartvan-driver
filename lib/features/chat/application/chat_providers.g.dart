// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conversationsHash() => r'4c45d66477e1135774e77235cdce7fa0cb7d793c';

/// The driver's conversations, newest activity first. Invalidate to reload;
/// the old list stays visible while it reloads.
///
/// Copied from [conversations].
@ProviderFor(conversations)
final conversationsProvider =
    AutoDisposeFutureProvider<List<Conversation>>.internal(
  conversations,
  name: r'conversationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conversationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConversationsRef = AutoDisposeFutureProviderRef<List<Conversation>>;
String _$conversationByIdHash() => r'bc5f43bfd6690e109f76c3801538b5bcf3926ec0';

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

/// One conversation by id, from the loaded list (null when it is not there).
///
/// Copied from [conversationById].
@ProviderFor(conversationById)
const conversationByIdProvider = ConversationByIdFamily();

/// One conversation by id, from the loaded list (null when it is not there).
///
/// Copied from [conversationById].
class ConversationByIdFamily extends Family<AsyncValue<Conversation?>> {
  /// One conversation by id, from the loaded list (null when it is not there).
  ///
  /// Copied from [conversationById].
  const ConversationByIdFamily();

  /// One conversation by id, from the loaded list (null when it is not there).
  ///
  /// Copied from [conversationById].
  ConversationByIdProvider call(
    String conversationId,
  ) {
    return ConversationByIdProvider(
      conversationId,
    );
  }

  @override
  ConversationByIdProvider getProviderOverride(
    covariant ConversationByIdProvider provider,
  ) {
    return call(
      provider.conversationId,
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
  String? get name => r'conversationByIdProvider';
}

/// One conversation by id, from the loaded list (null when it is not there).
///
/// Copied from [conversationById].
class ConversationByIdProvider
    extends AutoDisposeFutureProvider<Conversation?> {
  /// One conversation by id, from the loaded list (null when it is not there).
  ///
  /// Copied from [conversationById].
  ConversationByIdProvider(
    String conversationId,
  ) : this._internal(
          (ref) => conversationById(
            ref as ConversationByIdRef,
            conversationId,
          ),
          from: conversationByIdProvider,
          name: r'conversationByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationByIdHash,
          dependencies: ConversationByIdFamily._dependencies,
          allTransitiveDependencies:
              ConversationByIdFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  ConversationByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  Override overrideWith(
    FutureOr<Conversation?> Function(ConversationByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationByIdProvider._internal(
        (ref) => create(ref as ConversationByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Conversation?> createElement() {
    return _ConversationByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationByIdProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationByIdRef on AutoDisposeFutureProviderRef<Conversation?> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _ConversationByIdProviderElement
    extends AutoDisposeFutureProviderElement<Conversation?>
    with ConversationByIdRef {
  _ConversationByIdProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as ConversationByIdProvider).conversationId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
