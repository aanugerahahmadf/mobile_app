import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/errors/app_error_codes/app_error_codes.dart';
import '../../../data/models/notification_model/notification_model.dart';
import '../../../data/notification_repository_impl/notification_repository_impl.dart';
import '../../../domain/notification_repository/notification_repository.dart';

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
    bool clearError = false,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const NotificationState());

  Future<void> fetchNotifications() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final notifications = await _repository.getNotifications();
      state = state.copyWith(
        notifications: notifications,
        loading: false,
        clearError: true,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error:
            e.response?.data?['message'] as String? ??
            AppErrorCodes.failedLoadNotifications,
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
    final previousUnread = state.unreadCount;
    try {
      state = state.copyWith(
        notifications: state.notifications.map((n) {
          if (n.id == id) {
            return n.copyWith(readAt: DateTime.now().toIso8601String());
          }
          return n;
        }).toList(),
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );
      await _repository.markAsRead(id);
    } catch (_) {
      state = state.copyWith(
        notifications: previous,
        unreadCount: previousUnread,
      );
    }
  }

  Future<void> markAllAsRead() async {
    final previous = state.notifications;
    final previousUnread = state.unreadCount;
    try {
      state = state.copyWith(
        notifications: state.notifications
            .map((n) => n.copyWith(readAt: DateTime.now().toIso8601String()))
            .toList(),
        unreadCount: 0,
      );
      await _repository.markAllAsRead();
    } catch (_) {
      state = state.copyWith(
        notifications: previous,
        unreadCount: previousUnread,
      );
    }
  }

  Future<void> deleteNotification(String id) async {
    final previous = state.notifications;
    final previousUnread = state.unreadCount;
    try {
      final target = state.notifications.where((n) => n.id == id);
      if (target.isEmpty) return;
      final wasUnread = target.first.isUnread;
      state = state.copyWith(
        notifications: state.notifications.where((n) => n.id != id).toList(),
        unreadCount: wasUnread && state.unreadCount > 0
            ? state.unreadCount - 1
            : state.unreadCount,
      );
      await _repository.deleteNotification(id);
    } catch (_) {
      state = state.copyWith(
        notifications: previous,
        unreadCount: previousUnread,
      );
    }
  }
}

final notificationListProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      return NotificationNotifier(NotificationRepositoryImpl());
    });
