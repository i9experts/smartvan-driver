import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/chat_repository.dart';
import '../data/models/conversation.dart';

part 'chat_providers.g.dart';

/// The driver's conversations, newest activity first. Invalidate to reload;
/// the old list stays visible while it reloads.
@riverpod
Future<List<Conversation>> conversations(Ref ref) =>
    ref.watch(chatRepositoryProvider).conversations();

/// One conversation by id, from the loaded list (null when it is not there).
@riverpod
Future<Conversation?> conversationById(Ref ref, String conversationId) async {
  final all = await ref.watch(conversationsProvider.future);
  return all.where((c) => c.id == conversationId).firstOrNull;
}
