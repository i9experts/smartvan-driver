// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatThreadHash() => r'f935c842bbc4bcb2498550a7375830b077440240';

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

abstract class _$ChatThread
    extends BuildlessAutoDisposeAsyncNotifier<ChatThreadState> {
  late final String conversationId;

  FutureOr<ChatThreadState> build(
    String conversationId,
  );
}

/// One open conversation: loads the newest page, pages back, sends, and
/// applies live socket events (new messages, read receipts).
///
/// Copied from [ChatThread].
@ProviderFor(ChatThread)
const chatThreadProvider = ChatThreadFamily();

/// One open conversation: loads the newest page, pages back, sends, and
/// applies live socket events (new messages, read receipts).
///
/// Copied from [ChatThread].
class ChatThreadFamily extends Family<AsyncValue<ChatThreadState>> {
  /// One open conversation: loads the newest page, pages back, sends, and
  /// applies live socket events (new messages, read receipts).
  ///
  /// Copied from [ChatThread].
  const ChatThreadFamily();

  /// One open conversation: loads the newest page, pages back, sends, and
  /// applies live socket events (new messages, read receipts).
  ///
  /// Copied from [ChatThread].
  ChatThreadProvider call(
    String conversationId,
  ) {
    return ChatThreadProvider(
      conversationId,
    );
  }

  @override
  ChatThreadProvider getProviderOverride(
    covariant ChatThreadProvider provider,
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
  String? get name => r'chatThreadProvider';
}

/// One open conversation: loads the newest page, pages back, sends, and
/// applies live socket events (new messages, read receipts).
///
/// Copied from [ChatThread].
class ChatThreadProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChatThread, ChatThreadState> {
  /// One open conversation: loads the newest page, pages back, sends, and
  /// applies live socket events (new messages, read receipts).
  ///
  /// Copied from [ChatThread].
  ChatThreadProvider(
    String conversationId,
  ) : this._internal(
          () => ChatThread()..conversationId = conversationId,
          from: chatThreadProvider,
          name: r'chatThreadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatThreadHash,
          dependencies: ChatThreadFamily._dependencies,
          allTransitiveDependencies:
              ChatThreadFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  ChatThreadProvider._internal(
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
  FutureOr<ChatThreadState> runNotifierBuild(
    covariant ChatThread notifier,
  ) {
    return notifier.build(
      conversationId,
    );
  }

  @override
  Override overrideWith(ChatThread Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatThreadProvider._internal(
        () => create()..conversationId = conversationId,
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
  AutoDisposeAsyncNotifierProviderElement<ChatThread, ChatThreadState>
      createElement() {
    return _ChatThreadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatThreadProvider &&
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
mixin ChatThreadRef on AutoDisposeAsyncNotifierProviderRef<ChatThreadState> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _ChatThreadProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatThread, ChatThreadState>
    with ChatThreadRef {
  _ChatThreadProviderElement(super.provider);

  @override
  String get conversationId => (origin as ChatThreadProvider).conversationId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
