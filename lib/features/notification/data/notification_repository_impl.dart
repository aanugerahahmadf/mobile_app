import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../domain/notification_repository.dart';
import 'models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final Dio _dio;

  NotificationRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get(ApiEndpoints.notifications);
    final rawList = (response.data['data'] as List?) ?? [];
    return rawList.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _dio.get(ApiEndpoints.notificationUnreadCount);
    return (response.data['data']['count'] as int?) ?? 0;
  }

  @override
  Future<void> markAsRead(String id) async {
    await _dio.post(ApiEndpoints.notificationRead(id));
  }

  @override
  Future<void> markAllAsRead() async {
    await _dio.post(ApiEndpoints.notificationReadAll);
  }
}
