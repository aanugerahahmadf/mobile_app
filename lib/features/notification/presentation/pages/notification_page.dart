import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(notificationListProvider.notifier);
      notifier.fetchNotifications();
      notifier.fetchUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationListProvider);
    final notifier = ref.read(notificationListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
        actions: [
          if (state.notifications.any((n) => n.isUnread))
            TextButton(
              onPressed: () => notifier.markAllAsRead(),
              child: Text('Tandai Dibaca'),
            ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
                        SizedBox(height: AppSizes.md),
                        Text(state.error!, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                        SizedBox(height: AppSizes.md),
                        ElevatedButton.icon(
                          onPressed: () => notifier.fetchNotifications(),
                          icon: Icon(Icons.refresh),
                          label: Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : state.notifications.isEmpty
                  ? AppEmptyState(
                      title: 'Belum ada notifikasi',
                      subtitle: 'Belum ada notifikasi saat ini',
                      icon: Icons.notifications_outlined,
                    )
                  : RefreshIndicator(
                      onRefresh: () => notifier.fetchNotifications(),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppSizes.sm),
                        itemCount: state.notifications.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final notif = state.notifications[index];
                          final isRead = !notif.isUnread;
                          final title = notif.title ?? 'Notifikasi';
                          final body = notif.body ?? '';
                          final time = notif.createdAt ?? '';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isRead ? Colors.grey[200] : AppColors.secondaryColor,
                              child: Icon(
                                _getNotificationIcon(notif.type),
                                color: isRead ? AppColors.textSecondary : AppColors.primaryColor,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              title,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              body,
                              style: AppTextStyles.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              Formatters.timeAgo(time),
                              style: AppTextStyles.labelSmall,
                            ),
                            onTap: () {
                              if (notif.isUnread) notifier.markAsRead(notif.id.toString());
                              _navigateToNotification(notif);
                            },
                          );
                        },
                      ),
                    ),
    );
  }

  void _navigateToNotification(NotificationModel notif) {
    final type = notif.type;
    final data = notif.data;
    final id = data?['id']?.toString() ?? data?['order_id']?.toString() ?? data?['package_id']?.toString();
    final route = data?['route'] as String?;

    if (route != null && route.isNotEmpty) {
      context.push(route);
      return;
    }

    switch (type) {
      case 'order':
      case 'payment':
        if (id != null) context.push('/order/$id');
        break;
      case 'chat':
        if (id != null) context.push('/chat/$id');
        break;
      case 'promo':
        context.push('/vouchers');
        break;
      case 'package':
        if (id != null) context.push('/catalog/packages/$id');
        break;
      case 'product':
        if (id != null) context.push('/catalog/products/$id');
        break;
      default:
        break;
    }
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'order': return Icons.receipt_long;
      case 'payment': return Icons.payment;
      case 'chat': return Icons.chat;
      case 'promo': return Icons.local_offer;
      default: return Icons.notifications;
    }
  }
}
