import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../core/api/dio_client/dio_client.dart';
import '../../domain/chat_repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio _dio;

  ChatRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<Map<String, dynamic>> getConversations() async {
    final response = await _dio.get(ApiEndpoints.conversations);
    final data =
        (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ??
        <Map<String, dynamic>>[];
    return {'conversations': data};
  }

  @override
  Future<Map<String, dynamic>> getMessages(String inboxId) async {
    final response = await _dio.get(ApiEndpoints.conversationMessages(inboxId));
    final data = response.data['data'];
    final otherUser = response.data['other_user'] as Map<String, dynamic>?;
    return {
      'messages': (data is List)
          ? data.cast<Map<String, dynamic>>()
          : <Map<String, dynamic>>[],
      'other_user': otherUser,
    };
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
    Map<String, dynamic>? extraData,
  }) async {
    final data = <String, dynamic>{'inbox_id': inboxId, 'message': message};
    if (itemContext != null) {
      data.addAll(itemContext);
    }
    if (extraData != null) {
      data.addAll(extraData);
    }
    if (filePath != null) {
      final formData = FormData.fromMap({
        ...data,
        'attachment': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(
        ApiEndpoints.messagesSend,
        data: formData,
      );
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

  @override
  Future<Map<String, dynamic>> startGuestConversation({
    required String guestId,
    String? csCategory,
  }) async {
    final data = <String, dynamic>{'guest_id': guestId};
    if (csCategory != null && csCategory.isNotEmpty) {
      data['cs_category'] = csCategory;
    }
    final response = await _dio.post(ApiEndpoints.guestChatStart, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getGuestMessages(
    String inboxId, {
    required String guestId,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.guestChatMessages(inboxId),
      queryParameters: {'guest_id': guestId},
    );
    return {
      'messages':
          (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ??
          <Map<String, dynamic>>[],
      'other_user': response.data['other_user'] as Map<String, dynamic>?,
    };
  }

  @override
  Future<Map<String, dynamic>> sendGuestMessage({
    required int inboxId,
    required String message,
    required String guestId,
    String? csCategory,
  }) async {
    final data = <String, dynamic>{
      'guest_id': guestId,
      'inbox_id': inboxId,
      'message': message,
    };
    if (csCategory != null && csCategory.isNotEmpty) {
      data['cs_category'] = csCategory;
    }
    final response = await _dio.post(ApiEndpoints.guestChatSend, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<void> deleteMessage(
    String messageId, {
    required String deleteType,
  }) async {
    await _dio.delete(
      ApiEndpoints.messageDelete(messageId),
      data: {'delete_type': deleteType},
    );
  }

  @override
  Future<void> toggleStarMessage(String messageId) async {
    await _dio.post(ApiEndpoints.messageStar(messageId));
  }

  @override
  Future<void> forwardMessage(
    String messageId, {
    required int targetInboxId,
  }) async {
    await _dio.post(
      ApiEndpoints.messageForward(messageId),
      data: {'target_inbox_id': targetInboxId},
    );
  }

  @override
  Future<void> addReaction(String messageId, {required String emoji}) async {
    await _dio.post(
      ApiEndpoints.messageReact(messageId),
      data: {'emoji': emoji},
    );
  }

  @override
  Future<void> markAsRead(String inboxId) async {
    await _dio.post(ApiEndpoints.messageRead(inboxId));
  }

  @override
  Future<void> rateExperience(
    String inboxId, {
    required int rating,
    String? comment,
  }) async {
    await _dio.post(
      ApiEndpoints.messageRate(inboxId),
      data: {'rating': rating, 'comment': ?comment},
    );
  }
}
