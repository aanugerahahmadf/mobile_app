import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/chat_repository_impl.dart';
import '../../domain/chat_repository.dart';

sealed class ChatState {
  const ChatState();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatConversationsLoaded extends ChatState {
  final List<Map<String, dynamic>> conversations;
  final int unreadCount;
  final bool isSuperAdmin;
  const ChatConversationsLoaded(this.conversations, {this.unreadCount = 0, this.isSuperAdmin = false});
}

class ChatMessagesLoaded extends ChatState {
  final Map<String, dynamic> conversation;
  final List<Map<String, dynamic>> messages;
  final Map<String, dynamic>? otherUser;
  const ChatMessagesLoaded(this.conversation, this.messages, {this.otherUser});
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super(const ChatLoading());

  Future<void> loadConversations() async {
    state = const ChatLoading();
    try {
      final result = await _repository.getConversations();
      final conversations = (result['conversations'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      final isAdmin = result['is_super_admin'] as bool? ?? false;
      state = ChatConversationsLoaded(conversations, unreadCount: 0, isSuperAdmin: isAdmin);
    } on DioException catch (e) {
      state = ChatError(e.error?.toString() ?? 'Gagal memuat percakapan');
    } catch (e) {
      state = ChatError(e.toString());
    }
  }

  Future<void> loadMessages(String conversationId) async {
    state = const ChatLoading();
    try {
      final result = await _repository.getMessages(conversationId);
      final messages = (result['messages'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      final otherUser = result['other_user'] as Map<String, dynamic>?;
      final conversation = <String, dynamic>{'id': conversationId};
      state = ChatMessagesLoaded(conversation, messages, otherUser: otherUser);
    } on DioException catch (e) {
      state = ChatError(e.error?.toString() ?? 'Gagal memuat pesan');
    } catch (e) {
      state = ChatError(e.toString());
    }
  }

  Future<void> refreshMessages(String conversationId) async {
    try {
      final result = await _repository.getMessages(conversationId);
      final messages = (result['messages'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      final otherUser = result['other_user'] as Map<String, dynamic>?;
      if (state is ChatMessagesLoaded) {
        final current = state as ChatMessagesLoaded;
        state = ChatMessagesLoaded(current.conversation, messages, otherUser: otherUser ?? current.otherUser);
      }
    } catch (_) {}
  }

  Future<void> sendMessage({
    required int inboxId,
    required String message,
    required String senderName,
    String? filePath,
    Map<String, dynamic>? itemContext,
  }) async {
    try {
      final sent = await _repository.sendMessage(inboxId: inboxId, message: message, filePath: filePath, itemContext: itemContext);
      final constructed = <String, dynamic>{
        'id': sent['id'],
        'message': message,
        'sender_id': sent['user_id'],
        'sender_name': senderName,
        'is_me': true,
        'read_by': <String>[],
        'attachments': <String>[],
        'meta': sent['meta'],
        'created_at': sent['created_at'] ?? DateTime.now().toIso8601String(),
      };
      if (state is ChatMessagesLoaded) {
        final current = state as ChatMessagesLoaded;
        final updatedMessages = [...current.messages, constructed];
        state = ChatMessagesLoaded(current.conversation, updatedMessages, otherUser: current.otherUser);
      }
    } on DioException catch (e) {
      throw Exception(e.error?.toString() ?? 'Gagal mengirim pesan');
    }
  }

  Future<int> startConversation({Map<String, dynamic>? itemContext}) async {
    final result = await _repository.startConversation(itemContext: itemContext);
    return result['id'] as int;
  }

  Future<List<Map<String, dynamic>>> getCustomersForChat() async {
    return await _repository.getCustomersForChat();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ChatRepositoryImpl());
});
