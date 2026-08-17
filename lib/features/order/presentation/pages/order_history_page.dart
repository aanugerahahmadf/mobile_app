import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/utils/formatters.dart';
import '../../../payment/presentation/widgets/upload_payment_proof.dart';
import '../providers/order_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class OrderHistoryPage extends ConsumerStatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  ConsumerState<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends ConsumerState<OrderHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _activeStatus;

  final _tabStatuses = [null, 'pending', 'confirmed', 'preparing', 'completed', 'cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabStatuses.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).fetchOrders(refresh: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _statusLabel(String? status) {
    final l = AppLocalizations.of(context)!;
    switch (status) {
      case 'pending': return l.pending;
      case 'confirmed': return l.confirmed;
      case 'preparing': return l.processed;
      case 'event_day': return l.eventDay;
      case 'completed': return l.completed;
      case 'cancelled': return l.cancelled;
      default: return status ?? '-';
    }
  }

  int _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is num) return price.toInt();
    if (price is String) return (double.tryParse(price) ?? 0).toInt();
    return 0;
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'pending': return AppColors.warningColor;
      case 'confirmed': case 'preparing': return AppColors.primaryColor;
      case 'event_day': return AppColors.eventDayColor;
      case 'completed': return AppColors.successColor;
      case 'cancelled': return AppColors.errorColor;
      default: return AppColors.textSecondary;
    }
  }

  Future<void> _uploadPaymentProof(String orderId) async {
    await uploadPaymentProof(context, ref, orderId, onUploaded: () {
      ref.read(orderProvider.notifier).fetchOrders(status: _activeStatus, refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderProvider);
    final notifier = ref.read(orderProvider.notifier);

    final l = AppLocalizations.of(context)!;
    final tabLabels = [l.all, l.pending, l.confirmed, l.processed, l.completed, l.cancelled];
    return Scaffold(
      appBar: AppBar(title: Text(l.myOrders), backgroundColor: Colors.transparent, elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.centerLeft,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                    itemCount: tabLabels.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppSizes.xs),
                    itemBuilder: (_, i) {
                      final isSelected = _tabController.index == i;
                      return Center(
                        child: FilterChip(
                          label: Text(
                            tabLabels[i],
                            style: TextStyle(
                              color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _activeStatus = _tabStatuses[i]);
                            _tabController.animateTo(i);
                            ref.read(orderProvider.notifier).fetchOrders(status: _activeStatus, refresh: true);
                          },
                          selectedColor: AppColors.secondaryColor,
                          checkmarkColor: AppColors.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: state.loading
                ? ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.md),
                    itemCount: 3,
                    itemBuilder: (_, _) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppShimmer(height: 140),
                    ),
                  )
                : state.error != null
                    ? Center(child: Text(LocalizedError.of(l, state.error ?? ''), style: AppTextStyles.bodyMedium))
                    : state.orders.isEmpty
                        ? AppEmptyState(title: l.noOrders, subtitle: l.noOrdersDesc, icon: Icons.receipt_long_outlined)
                        : RefreshIndicator(
                            onRefresh: () => notifier.fetchOrders(status: _activeStatus, refresh: true),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(AppSizes.md),
                              itemCount: state.orders.length + (state.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.orders.length) {
                                  notifier.loadMore(status: _activeStatus);
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }

                                final order = state.orders[index];
                                final status = order['status'] as String?;
                                final firstItem = order['item'] as Map<String, dynamic>?;

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: InkWell(
                                    onTap: () => context.push('/order/${order['id']}'),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(AppSizes.md),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text('${l.order} #${order['order_number'] ?? order['id']}', style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _statusColor(status).withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  _statusLabel(status),
                                                  style: AppTextStyles.labelSmall.copyWith(color: _statusColor(status), fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              if (firstItem != null)
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Container(
                                                    width: 60, height: 60,
                                                    color: AppColors.secondaryColor,
                                                    child: Icon(Icons.image, color: AppColors.textTertiary),
                                                  ),
                                                ),
                                              if (firstItem != null) const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(firstItem?['name'] as String? ?? l.order, style: AppTextStyles.bodyMedium),
                                                    Text(l.itemCount, style: AppTextStyles.bodySmall),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(Formatters.currency(_parsePrice(order['total_price'] ?? order['total'])), style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryColor)),
                                                  Text(Formatters.date(order['created_at'] as String? ?? ''), style: AppTextStyles.bodySmall),
                                                ],
                                              ),
                                            ],
                                          ),
                                          if (status == 'pending' || order['payment_status'] == 'unpaid') ...[
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: AppButton(
                                                    label: l.pay,
                                                    onPressed: () => context.push('/payment/${order['id']}'),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                    child: AppButton(
                                                    label: l.cancel,
                                                    onPressed: () => notifier.cancelOrder('${order['id']}'),
                                                    type: ButtonType.outline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if (order['payment_status'] == 'pending') ...[
                                            const SizedBox(height: 12),
                                            AppButton(
                                              label: l.uploadProof,
                                              onPressed: () => _uploadPaymentProof('${order['id']}'),
                                              type: ButtonType.outline,
                                            ),
                                          ],
                                          if (status == 'completed') ...[
                                            const SizedBox(height: 12),
                                            AppButton(
                                              label: l.writeReview,
                                              icon: Icons.rate_review_outlined,
                                              onPressed: () => context.push('/write-review', extra: {
                                                'package_id': '${order['package_id'] ?? ''}',
                                                'product_id': '${order['product_id'] ?? ''}',
                                                'name': (order['item'] as Map<String, dynamic>?)?['name'] ?? '',
                                              }),
                                              type: ButtonType.outline,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
