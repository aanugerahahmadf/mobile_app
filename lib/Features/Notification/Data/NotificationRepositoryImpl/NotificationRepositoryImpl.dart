import 'package:dio/dio.dart';
import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../Domain/NotificationRepository/NotificationRepository.dart';
import '../Models/NotificationModel/NotificationModel.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final Dio _dio;

  NotificationRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get(ApiEndpoints.notifications);
    final rawList = (response.data['data'] as List?) ?? [];
    return rawList
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _dio.get(ApiEndpoints.notificationUnreadCount);
    return ((response.data['data'] as Map<String, dynamic>?)?['count']
            as int?) ??
        0;
  }

  @override
  Future<void> markAsRead(String id) async {
    await _dio.post(ApiEndpoints.notificationRead(id));
  }

  @override
  Future<void> markAllAsRead() async {
    await _dio.post(ApiEndpoints.notificationReadAll);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await _dio.delete(ApiEndpoints.notificationDelete(id));
  }
}
