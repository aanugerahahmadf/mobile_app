import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_error_codes.dart';
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
  final bool isTyping;
  const ChatMessagesLoaded(this.conversation, this.messages, {this.otherUser, this.isTyping = false});
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
      state = ChatError(e.error?.toString() ?? AppErrorCodes.failedLoadConversations);
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
      state = ChatError(e.error?.toString() ?? AppErrorCodes.failedLoadMessages);
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
        state = ChatMessagesLoaded(
          current.conversation,
          messages,
          otherUser: otherUser ?? current.otherUser,
          isTyping: current.isTyping,
        );
      }
    } catch (_) {}
  }

  void setTyping(bool typing) {
    if (state is ChatMessagesLoaded) {
      final current = state as ChatMessagesLoaded;
      if (current.isTyping != typing) {
        state = ChatMessagesLoaded(
          current.conversation,
          current.messages,
          otherUser: current.otherUser,
          isTyping: typing,
        );
      }
    }
  }

  Future<void> sendMessage({
    required int inboxId,
    required String message,
    required String senderName,
    String? filePath,
    Map<String, dynamic>? itemContext,
    String? csCategory,
    int? replyToId,
    String? replyToName,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (csCategory != null && csCategory.isNotEmpty) {
        data['cs_category'] = csCategory;
      }
      if (replyToId != null) {
        data['reply_to_id'] = replyToId;
      }
      final sent = await _repository.sendMessage(
        inboxId: inboxId,
        message: message,
        filePath: filePath,
        itemContext: itemContext,
        extraData: data.isNotEmpty ? data : null,
      );
      final constructed = <String, dynamic>{
        'id': sent['id'],
        'message': message,
        'sender_id': sent['user_id'],
        'sender_name': senderName,
        'is_me': true,
        'read_by': <String>[],
        'attachments': sent['attachments'] as List<dynamic>? ?? <String>[],
        'meta': sent['meta'],
        'created_at': sent['created_at'] ?? DateTime.now().toIso8601String(),
      };
      if (state is ChatMessagesLoaded) {
        final current = state as ChatMessagesLoaded;
        final updatedMessages = [...current.messages, constructed];
        state = ChatMessagesLoaded(current.conversation, updatedMessages, otherUser: current.otherUser);
      }
      setTyping(true);
    } on DioException catch (e) {
      setTyping(false);
      throw Exception(e.error?.toString() ?? AppErrorCodes.failedSendMessage);
    }
  }

  Future<void> deleteMessage(String messageId, {required String deleteType}) async {
    try {
      await _repository.deleteMessage(messageId, deleteType: deleteType);
      if (state is ChatMessagesLoaded) {
        final current = state as ChatMessagesLoaded;
        final updatedMessages = <Map<String, dynamic>>[];
        for (final msg in current.messages) {
          if (msg['id'].toString() == messageId) {
            if (deleteType == 'everyone') {
              continue;
            } else {
              updatedMessages.add({
                ...msg,
                'message': '',
                'is_deleted': true,
                'attachments': <dynamic>[],
              });
            }
          } else {
            updatedMessages.add(msg);
          }
        }
        state = ChatMessagesLoaded(current.conversation, updatedMessages, otherUser: current.otherUser);
      }
    } on DioException catch (e) {
      throw Exception(e.error?.toString() ?? AppErrorCodes.failedSendMessage);
    }
  }

  Future<void> toggleStarMessage(String messageId) async {
    try {
      await _repository.toggleStarMessage(messageId);
      if (state is ChatMessagesLoaded) {
        final current = state as ChatMessagesLoaded;
        final updatedMessages = current.messages.map((msg) {
          if (msg['id'].toString() == messageId) {
            final meta = Map<String, dynamic>.from(msg['meta'] as Map<String, dynamic>? ?? {});
            final starredBy = List<String>.from(meta['starred_by'] as List<dynamic>? ?? []);
            final currentUserId = ''; // Will be updated from UI
            if (starredBy.contains(currentUserId)) {
              starredBy.remove(currentUserId);
            } else {
              starredBy.add(currentUserId);
            }
            meta['starred_by'] = starredBy;
            return {...msg, 'meta': meta};
          }
          return msg;
        }).toList();
        state = ChatMessagesLoaded(current.conversation, updatedMessages, otherUser: current.otherUser);
      }
    } on DioException catch (_) {}
  }

  void updateMessageMeta(String messageId, Map<String, dynamic> newMeta) {
    if (state is ChatMessagesLoaded) {
      final current = state as ChatMessagesLoaded;
      final updatedMessages = current.messages.map((msg) {
        if (msg['id'].toString() == messageId) {
          final meta = Map<String, dynamic>.from(msg['meta'] as Map<String, dynamic>? ?? {});
          meta.addAll(newMeta);
          return {...msg, 'meta': meta};
        }
        return msg;
      }).toList();
      state = ChatMessagesLoaded(current.conversation, updatedMessages, otherUser: current.otherUser);
    }
  }

  Future<void> addReaction(String messageId, String emoji) async {
    try {
      await _repository.addReaction(messageId, emoji: emoji);
    } on DioException catch (_) {}
  }

  Future<void> markAsRead(String inboxId) async {
    try {
      await _repository.markAsRead(inboxId);
    } on DioException catch (_) {}
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
