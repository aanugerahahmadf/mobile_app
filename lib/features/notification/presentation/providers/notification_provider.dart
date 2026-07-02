import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_model.dart';
import '../../data/notification_repository_impl.dart';
import '../../domain/notification_repository.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool loading;
  final String? error;
  final int unreadCount;

  const NotificationState({
    this.notifications = const [],
    this.loading = false,
    this.error,
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? loading,
    String? error,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      loading: loading ?? this.loading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const NotificationState());

  Future<void> fetchNotifications() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final notifications = await _repository.getNotifications();
      state = state.copyWith(notifications: notifications, loading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.response?.data?['message'] as String? ?? 'Gagal memuat notifikasi',
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final count = await _repository.getUnreadCount();
      state = state.copyWith(unreadCount: count);
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    final previous = state.notifications;
    try {
      state = state.copyWith(
        notifications: state.notifications.map((n) {
          if (n.id.toString() == id) {
            return n.copyWith(readAt: DateTime.now().toIso8601String());
          }
          return n;
        }).toList(),
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );
      await _repository.markAsRead(id);
    } catch (_) {
      state = state.copyWith(notifications: previous);
    }
  }

  Future<void> markAllAsRead() async {
    final previous = state.notifications;
    try {
      state = state.copyWith(
        notifications: state.notifications.map((n) => n.copyWith(readAt: DateTime.now().toIso8601String())).toList(),
        unreadCount: 0,
      );
      await _repository.markAllAsRead();
    } catch (_) {
      state = state.copyWith(notifications: previous);
    }
  }
}

final notificationListProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(NotificationRepositoryImpl());
});
