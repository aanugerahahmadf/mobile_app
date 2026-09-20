import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/chat/domain/chat_repository/chat_repository.dart';
import 'package:mobile_app/features/chat/presentation/providers/chat_provider.dart';

class _FakeChatRepository implements ChatRepository {
  int conversationsCalls = 0;
  int guestStartCalls = 0;
  int guestMessageCalls = 0;

  @override
  Future<Map<String, dynamic>> getConversations() async {
    conversationsCalls++;
    return {'conversations': <Map<String, dynamic>>[]};
  }

  @override
  Future<Map<String, dynamic>> startGuestConversation({
    required String guestId,
    String? csCategory,
  }) async {
    guestStartCalls++;
    return {'id': 17};
  }

  @override
  Future<Map<String, dynamic>> sendGuestMessage({
    required int inboxId,
    required String message,
    required String guestId,
    String? csCategory,
  }) async {
    guestMessageCalls++;
    return {
      'id': 1,
      'user_id': null,
      'attachments': <dynamic>[],
      'meta': <String, dynamic>{},
    };
  }

  @override
  Future<Map<String, dynamic>> getGuestMessages(
    String inboxId, {
    required String guestId,
  }) async => {'messages': <Map<String, dynamic>>[]};

  @override
  Future<Map<String, dynamic>> getMessages(String inboxId) async => {
    'messages': <Map<String, dynamic>>[],
  };

  @override
  Future<int> getUnreadCount() async => 0;

  @override
  Future<Map<String, dynamic>> sendMessage({
    required int inboxId,
    required String message,
    String? filePath,
    Map<String, dynamic>? itemContext,
    Map<String, dynamic>? extraData,
  }) async => {'id': 1};

  @override
  Future<Map<String, dynamic>> startConversation({
    Map<String, dynamic>? itemContext,
  }) async => {'id': 1};

  @override
  Future<void> deleteMessage(
    String messageId, {
    required String deleteType,
  }) async {}

  @override
  Future<void> toggleStarMessage(String messageId) async {}

  @override
  Future<void> forwardMessage(
    String messageId, {
    required int targetInboxId,
  }) async {}

  @override
  Future<void> addReaction(String messageId, {required String emoji}) async {}

  @override
  Future<void> markAsRead(String inboxId) async {}

  @override
  Future<void> rateExperience(
    String inboxId, {
    required int rating,
    String? comment,
  }) async {}
}

void main() {
  test(
    'guest chat uses guest endpoints and does not load private conversations',
    () async {
      final repository = _FakeChatRepository();
      final notifier = ChatNotifier(repository);

      await notifier.startGuestConversation(guestId: 'guest-device');
      await notifier.sendGuestMessage(
        inboxId: 17,
        message: 'Halo',
        guestId: 'guest-device',
        senderName: 'Tamu',
      );

      expect(repository.guestStartCalls, 1);
      expect(repository.guestMessageCalls, 1);
      expect(repository.conversationsCalls, 0);
    },
  );
}
