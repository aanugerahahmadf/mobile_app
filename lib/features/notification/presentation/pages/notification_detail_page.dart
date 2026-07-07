import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/notification_model.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final notif = notification;
    final isRead = !notif.isUnread;

    return Scaffold(
      appBar: AppBar(
        title: Text(notif.title ?? l.notifications),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, notif, isRead),
            const SizedBox(height: AppSizes.lg),
            if (notif.body != null && notif.body!.isNotEmpty) ...[
              Text(
                notif.body!,
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: AppSizes.lg),
            ],
            _buildMeta(context, notif),
            if (notif.data != null && notif.data!.isNotEmpty) ...[
              const Divider(height: AppSizes.lg * 2),
              Text(l.content, style: AppTextStyles.titleMedium),
              const SizedBox(height: AppSizes.sm),
              ...notif.data!.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${e.key}: ',
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(
                        '${e.value}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NotificationModel notif, bool isRead) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: isRead ? AppColors.secondaryColor : AppColors.primaryColor.withAlpha(30),
          child: Icon(
            _getNotificationIcon(notif.type),
            color: isRead ? AppColors.textSecondary : AppColors.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notif.title ?? '',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              if (notif.createdAt != null)
                Text(
                  Formatters.timeAgo(notif.createdAt!),
                  style: AppTextStyles.labelSmall,
                ),
            ],
          ),
        ),
        if (!isRead)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  Widget _buildMeta(BuildContext context, NotificationModel notif) {
    final l = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(200),
        borderRadius: BorderRadius.circular(AppSizes.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notif.type != null)
            _metaRow(l.type, notif.type!),
          if (notif.createdAt != null)
            _metaRow(l.time, Formatters.timeAgo(notif.createdAt!)),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodySmall),
          ),
        ],
      ),
    );
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
