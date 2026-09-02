abstract class ChatRepository {
  Future<Map<String, dynamic>> getConversations();
  Future<List<Map<String, dynamic>>> getCustomersForChat();
  Future<Map<String, dynamic>> getMessages(String inboxId);
  Future<int> getUnreadCount();
  Future<Map<String, dynamic>> sendMessage({
    required int inboxId,
    required String message,
    String? filePath,
    Map<String, dynamic>? itemContext,
    Map<String, dynamic>? extraData,
  });
  Future<Map<String, dynamic>> startConversation({
    Map<String, dynamic>? itemContext,
  });
  Future<void> deleteMessage(String messageId, {required String deleteType});
  Future<void> toggleStarMessage(String messageId);
  Future<void> forwardMessage(String messageId, {required int targetInboxId});
  Future<void> addReaction(String messageId, {required String emoji});
  Future<void> markAsRead(String inboxId);
  Future<void> rateExperience(String inboxId, {required int rating, String? comment});
}
