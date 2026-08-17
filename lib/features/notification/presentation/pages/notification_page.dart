import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/notification_model.dart';
import '../providers/notification_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

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
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(notificationListProvider);
    final notifier = ref.read(notificationListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.notifications),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (state.notifications.any((n) => n.isUnread))
            TextButton(
              onPressed: () => notifier.markAllAsRead(),
              child: Text(l.markAsRead),
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
                        Icon(Icons.cloud_off, size: 64, color: AppColors.textTertiary),
                        SizedBox(height: AppSizes.md),
                        Text(LocalizedError.of(l, state.error!), style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                        SizedBox(height: AppSizes.md),
                        ElevatedButton.icon(
                          onPressed: () => notifier.fetchNotifications(),
                          icon: Icon(Icons.refresh),
                          label: Text(l.tryAgain),
                        ),
                      ],
                    ),
                  ),
                )
              : state.notifications.isEmpty
                  ? AppEmptyState(
                      title: l.noNotifications,
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
                          final title = notif.title ?? l.notifications;
                          final body = notif.body ?? '';
                          final time = notif.createdAt ?? '';

                          return Dismissible(
                            key: ValueKey(notif.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: AppSizes.md),
                              color: Colors.red,
                              child: const Icon(Icons.delete_outline, color: Colors.white),
                            ),
                            confirmDismiss: (_) async {
                              return await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(l.deleteNotification),
                                  content: Text(l.deleteNotificationConfirm),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text(l.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text(l.delete, style: const TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (_) => notifier.deleteNotification(notif.id),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.secondaryColor,
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
                                if (notif.isUnread) notifier.markAsRead(notif.id);
                                _navigateToNotification(notif);
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  void _navigateToNotification(NotificationModel notif) {
    final type = notif.type;
    final data = notif.data;
    final authState = ref.read(authProvider);
    final isAdmin = authState is AuthAuthenticated && authState.user.isAdmin;

    final id = _extractId(data);
    final route = data?['route'] as String?;
    if (route != null && route.isNotEmpty) {
      context.push(route);
      return;
    }

    String? targetRoute;

    switch (type) {
      case 'order':
      case 'payment':
        if (isAdmin) {
          targetRoute = '/admin/orders';
        } else if (id != null) {
          targetRoute = '/order/$id';
        }
        break;
      case 'chat':
        if (id != null) targetRoute = '/chat/$id';
        break;
      case 'message':
        if (isAdmin) {
          targetRoute = '/admin/inboxes';
        } else if (id != null) {
          targetRoute = '/chat/$id';
        }
        break;
      case 'promo':
        targetRoute = '/vouchers';
        break;
      case 'package':
        if (isAdmin) {
          targetRoute = '/admin/packages';
        } else if (id != null) {
          targetRoute = '/catalog/packages/$id';
        }
        break;
      case 'product':
        if (isAdmin) {
          targetRoute = '/admin/products';
        } else if (id != null) {
          targetRoute = '/catalog/products/$id';
        }
        break;
      case 'review':
        if (isAdmin) {
          targetRoute = '/admin/reviews';
        } else if (id != null) {
          targetRoute = '/my-reviews';
        }
        break;
      case 'new_user':
      case 'admin_user':
        if (isAdmin) targetRoute = '/admin/users';
        break;
      case 'new_order':
      case 'admin_order':
        if (isAdmin) targetRoute = '/admin/orders';
        break;
      case 'new_help':
      case 'admin_help':
        if (isAdmin) targetRoute = '/admin/helps';
        break;
      case 'new_review':
      case 'admin_review':
        if (isAdmin) targetRoute = '/admin/reviews';
        break;
      case 'new_voucher':
      case 'admin_voucher':
        if (isAdmin) targetRoute = '/admin/vouchers';
        break;
      case 'new_transaction':
      case 'admin_transaction':
        if (isAdmin) targetRoute = '/admin/transactions';
        break;
      case 'new_category':
      case 'admin_category':
        if (isAdmin) targetRoute = '/admin/categories';
        break;
      default:
        break;
    }

    if (targetRoute != null) {
      if (context.mounted) context.push(targetRoute);
    } else {
      if (context.mounted) context.push('/notification/${notif.id}', extra: notif);
    }
  }

  String? _extractId(Map<String, dynamic>? data) {
    if (data == null) return null;
    const keys = [
      'id', 'order_id', 'package_id', 'product_id', 'user_id',
      'voucher_id', 'review_id', 'transaction_id', 'category_id',
      'help_id', 'chat_id', 'target_id', 'notification_id',
    ];
    for (final key in keys) {
      final val = data[key];
      if (val != null) return val.toString();
    }
    return null;
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'order':
      case 'new_order':
      case 'admin_order':
        return Icons.receipt_long;
      case 'payment':
        return Icons.payment;
      case 'chat':
      case 'message':
      case 'new_message':
        return Icons.chat;
      case 'promo':
        return Icons.local_offer;
      case 'package':
      case 'new_package':
      case 'admin_package':
        return Icons.inventory_2;
      case 'product':
      case 'new_product':
      case 'admin_product':
        return Icons.shopping_bag;
      case 'review':
      case 'new_review':
      case 'admin_review':
        return Icons.rate_review;
      case 'new_user':
      case 'admin_user':
        return Icons.person_add;
      case 'new_help':
      case 'admin_help':
        return Icons.help_outline;
      case 'new_voucher':
      case 'admin_voucher':
        return Icons.card_giftcard;
      case 'new_transaction':
      case 'admin_transaction':
        return Icons.account_balance;
      case 'new_category':
      case 'admin_category':
        return Icons.category;
      default:
        return Icons.notifications;
    }
  }
}
