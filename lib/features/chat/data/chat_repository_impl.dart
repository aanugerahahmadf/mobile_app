import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../domain/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio _dio;

  ChatRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<List<Map<String, dynamic>>> getConversations() async {
    final response = await _dio.get(ApiEndpoints.conversations);
    return (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  @override
  Future<List<Map<String, dynamic>>> getMessages(String inboxId) async {
    final response = await _dio.get(ApiEndpoints.conversationMessages(inboxId));
    final data = response.data['data'];
    if (data is List) return data.cast<Map<String, dynamic>>();
    return [];
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _dio.get(ApiEndpoints.unreadCount);
    return (response.data['data']?['unread_count'] as int?) ?? 0;
  }

  @override
  Future<Map<String, dynamic>> sendMessage({
    required int inboxId,
    required String message,
    String? filePath,
    Map<String, dynamic>? itemContext,
  }) async {
    final data = <String, dynamic>{
      'inbox_id': inboxId,
      'message': message,
    };
    if (itemContext != null) {
      data.addAll(itemContext);
    }
    if (filePath != null) {
      final formData = FormData.fromMap({
        ...data,
        'attachment': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(ApiEndpoints.messagesSend, data: formData);
      return response.data['data'] as Map<String, dynamic>;
    }
    final response = await _dio.post(ApiEndpoints.messagesSend, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> startConversation({
    Map<String, dynamic>? itemContext,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.messagesStart,
      data: itemContext,
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
