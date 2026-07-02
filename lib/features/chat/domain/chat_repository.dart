abstract class ChatRepository {
  Future<List<Map<String, dynamic>>> getConversations();
  Future<List<Map<String, dynamic>>> getMessages(String inboxId);
  Future<int> getUnreadCount();
  Future<Map<String, dynamic>> sendMessage({
    required int inboxId,
    required String message,
    String? filePath,
    Map<String, dynamic>? itemContext,
  });
  Future<Map<String, dynamic>> startConversation({
    Map<String, dynamic>? itemContext,
  });
}
