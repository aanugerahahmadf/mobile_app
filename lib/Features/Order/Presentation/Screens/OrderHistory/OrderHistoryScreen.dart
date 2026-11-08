import '../../../../../Core/Widgets/AppBlurBackdrop/AppBlurBackdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Errors/AppErrorCodes/AppErrorCodes.dart';
import '../../../../../Core/Widgets/AppActionSheet/AppActionSheet.dart';
import '../../../../../Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';
import '../../../../../Core/Widgets/AppBottomSheet/AppBottomSheet.dart';
import '../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../../../../Core/Widgets/AppEmptyState/AppEmptyState.dart';
import '../../../../../Core/Errors/LocalizedError/LocalizedError.dart';
import '../../../../../Core/Widgets/AppShimmer/AppShimmer.dart';
import '../../../../../Core/Widgets/AppSnackbar/AppSnackbar.dart';
import '../../../../../Core/Utils/Formatters/Formatters.dart';
import '../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import '../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import '../../../../Payment/Presentation/Widgets/UploadPaymentProof/UploadPaymentProof.dart';
import '../../Providers/OrderProvider/OrderProvider.dart';
import '../../Widgets/OrderEditSheet/OrderEditSheet.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends ConsumerState<OrderHistoryScreen> {
  String? _activeStatus;
  String? _activePaymentType;

  final _tabStatuses = [
    null,
    'pending',
    'confirmed',
    'preparing',
    'completed',
    'cancelled',
  ];

  final _paymentTypes = [null, 'virtual_account', 'qris'];

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider) is AuthAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
    }
  }

  String _statusLabel(String? status) {
    final l = AppLocalizations.of(context)!;
    switch (status) {
      case 'pending':
        return l.pending;
      case 'confirmed':
        return l.confirmed;
      case 'preparing':
        return l.processed;
      case 'event_day':
        return l.eventDay;
      case 'completed':
        return l.completed;
      case 'cancelled':
        return l.cancelled;
      default:
        return status ?? '-';
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
      case 'pending':
        return AppColors.warningColor;
      case 'confirmed':
      case 'preparing':
        return AppColors.primaryColor;
      case 'event_day':
        return AppColors.eventDayColor;
      case 'completed':
        return AppColors.successColor;
      case 'cancelled':
        return AppColors.errorColor;
      default:
        return AppColors.textSecondary;
    }
  }

  Future<void> _refresh() async {
    await ref
        .read(orderProvider.notifier)
        .fetchOrders(
          status: _activeStatus,
          paymentType: _activePaymentType,
          refresh: true,
        );
  }

  Map<String, dynamic>? _paymentOf(Map<String, dynamic> order) =>
      order['payment'] as Map<String, dynamic>?;

  int _payableAmount(Map<String, dynamic> order) {
    final amount = _paymentOf(order)?['amount'];
    return _parsePrice(amount ?? order['total_price'] ?? order['total']);
  }

  bool _isExpired(Map<String, dynamic> order) =>
      _paymentOf(order)?['is_expired'] == true;

  Future<void> _editOrder(Map<String, dynamic> order) async {
    final l = AppLocalizations.of(context)!;
    final saved = await AppBottomSheet.show<bool>(
      context,
      OrderEditSheet(order: order),
      title: l.editOrder,
      initial: 0.8,
      min: 0.5,
      max: 0.95,
    );
    if (saved != true || !mounted) return;
    AppSnackBar.show(context, l.orderUpdated, type: SnackBarType.success);
    context.push('/payment/${order['id']}');
  }

  Future<bool> _confirm(String message) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              l.yes,
              style: const TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _deleteOrder(Map<String, dynamic> order) async {
    final l = AppLocalizations.of(context)!;
    if (!await _confirm(l.confirmDeleteOrder)) return;
    if (!mounted) return;
    final ok = await ref
        .read(orderProvider.notifier)
        .deleteOrder('${order['id']}');
    if (!mounted) return;
    final error = ref.read(orderProvider).error;
    AppSnackBar.show(
      context,
      ok
          ? l.orderDeleted
          : LocalizedError.of(l, error ?? AppErrorCodes.failedDeleteOrder),
      type: ok ? SnackBarType.success : SnackBarType.error,
    );
  }

  Future<void> _openOrderActions(Map<String, dynamic> order) async {
    final l = AppLocalizations.of(context)!;
    final canEdit = order['can_edit'] == true;
    final canDelete = order['can_delete'] == true;
    final isPending = order['status'] == 'pending';

    final action = await showAppActionSheet<String>(
      context,
      title: '${l.order} #${order['order_number'] ?? order['id']}',
      actions: [
        if (canEdit)
          AppSheetAction(
            value: 'edit',
            label: l.editOrder,
            icon: Icons.edit_outlined,
          ),
        if (isPending)
          AppSheetAction(
            value: 'cancel',
            label: l.cancelOrder,
            icon: Icons.cancel_outlined,
            destructive: true,
          ),
        if (canDelete)
          AppSheetAction(
            value: 'delete',
            label: l.delete,
            icon: Icons.delete_outline,
            destructive: true,
          ),
      ],
    );
    if (action == null || !mounted) return;
    switch (action) {
      case 'edit':
        await _editOrder(order);
      case 'cancel':
        if (await _confirm(l.confirmCancelOrder)) {
          await ref.read(orderProvider.notifier).cancelOrder('${order['id']}');
        }
      case 'delete':
        await _deleteOrder(order);
    }
  }

  Future<void> _uploadPaymentProof(String orderId) async {
    if (ref.read(authProvider) is! AuthAuthenticated) return;
    await uploadPaymentProof(context, ref, orderId, onUploaded: _refresh);
  }

  Widget _buildChipRow({
    required List<String> labels,
    required List<String?> values,
    required String? selected,
    required ValueChanged<String?> onSelect,
  }) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.xs),
        itemBuilder: (_, i) {
          final isSelected = values[i] == selected;
          return Center(
            child: FilterChip(
              label: Text(
                labels[i],
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textSecondary,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onSelect(values[i]),
              selectedColor: AppColors.secondaryColor,
              checkmarkColor: AppColors.primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentStrip(Map<String, dynamic> order) {
    final l = AppLocalizations.of(context)!;
    final type = order['payment_type'] as String?;
    final label =
        (order['payment_type_label'] as String?) ??
        switch (type) {
          'virtual_account' => l.virtualAccount,
          'qris' => l.qris,
          _ => l.paymentMethod,
        };
    final payment = _paymentOf(order);
    final paid = payment?['status'] == 'paid';
    final deadline = payment?['deadline'] as String?;
    final vaNumber = order['va_number'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              type == 'qris' ? Icons.qr_code : Icons.account_balance_wallet,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.bodySmall),
            if (vaNumber != null) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$l.virtualAccountNo: $vaNumber',
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        if (!paid && deadline != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                _isExpired(order) ? Icons.error_outline : Icons.schedule,
                size: 16,
                color: _isExpired(order)
                    ? AppColors.errorColor
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                _isExpired(order)
                    ? l.expired
                    : '${l.paymentDeadline} ${Formatters.date(deadline)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _isExpired(order)
                      ? AppColors.errorColor
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isAuthenticated = ref.watch(authProvider) is AuthAuthenticated;
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l.myOrders),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(38),
            child: const AppBreadcrumbs.global(),
          ),
        ),
        body: const GuestAuthPrompt(icon: Icons.receipt_long_outlined),
      );
    }
    final state = ref.watch(orderProvider);
    final notifier = ref.read(orderProvider.notifier);

    final tabLabels = [
      l.all,
      l.pending,
      l.confirmed,
      l.processed,
      l.completed,
      l.cancelled,
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l.myOrders),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38),
          child: const AppBreadcrumbs.global(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.sm,
              AppSizes.md,
              0,
            ),
            child: AppBlurBackdrop(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildChipRow(
                    labels: tabLabels,
                    values: _tabStatuses,
                    selected: _activeStatus,
                    onSelect: (value) {
                      setState(() => _activeStatus = value);
                      _refresh();
                    },
                  ),
                  _buildChipRow(
                    labels: [l.all, l.virtualAccount, l.qris],
                    values: _paymentTypes,
                    selected: _activePaymentType,
                    onSelect: (value) {
                      setState(() => _activePaymentType = value);
                      _refresh();
                    },
                  ),
                ],
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
                : state.error != null && state.orders.isEmpty
                ? Center(
                    child: Text(
                      LocalizedError.of(l, state.error ?? ''),
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                : state.orders.isEmpty
                ? AppEmptyState(
                    title: l.noOrders,
                    subtitle: l.noOrdersDesc,
                    icon: Icons.receipt_long_outlined,
                  )
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSizes.md),
                      itemCount: state.orders.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.orders.length) {
                          notifier.loadMore(
                            status: _activeStatus,
                            paymentType: _activePaymentType,
                          );
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final order = state.orders[index];
                        final status = order['status'] as String?;
                        final firstItem =
                            order['item'] as Map<String, dynamic>?;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                                        child: Text(
                                          '${l.order} #${order['order_number'] ?? order['id']}',
                                          style: AppTextStyles.bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _statusColor(
                                            status,
                                          ).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          _statusLabel(status),
                                          style: AppTextStyles.labelSmall
                                              .copyWith(
                                                color: _statusColor(status),
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      if (firstItem != null)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            color: AppColors.secondaryColor,
                                            child: Icon(
                                              Icons.image,
                                              color: AppColors.textTertiary,
                                            ),
                                          ),
                                        ),
                                      if (firstItem != null)
                                        const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              firstItem?['name'] as String? ??
                                                  l.order,
                                              style: AppTextStyles.bodyMedium,
                                            ),
                                            Text(
                                              l.itemCount,
                                              style: AppTextStyles.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            Formatters.currency(
                                              _payableAmount(order),
                                            ),
                                            style: AppTextStyles.titleMedium
                                                .copyWith(
                                                  color: AppColors.primaryColor,
                                                ),
                                          ),
                                          Text(
                                            Formatters.date(
                                              order['created_at'] as String? ??
                                                  '',
                                            ),
                                            style: AppTextStyles.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPaymentStrip(order),
                                  if (status == 'pending' ||
                                      order['payment_status'] == 'unpaid' ||
                                      order['can_pay'] == true) ...[
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        if (order['can_pay'] == true) ...[
                                          Expanded(
                                            child: AppButton(
                                              label: l.pay,
                                              onPressed: () => context.push(
                                                '/payment/${order['id']}',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                        Expanded(
                                          child: AppButton(
                                            label: l.editOrder,
                                            onPressed: order['can_edit'] == true
                                                ? () => _editOrder(order)
                                                : null,
                                            type: ButtonType.outline,
                                          ),
                                        ),
                                        if (order['can_edit'] == true ||
                                            order['can_delete'] == true ||
                                            status == 'pending')
                                          IconButton(
                                            onPressed: () =>
                                                _openOrderActions(order),
                                            icon:
                                                state.actionOrderId ==
                                                    '${order['id']}'
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : const Icon(Icons.more_vert),
                                            tooltip: l.actions,
                                          ),
                                      ],
                                    ),
                                  ],
                                  if (order['payment_status'] == 'pending') ...[
                                    const SizedBox(height: 12),
                                    AppButton(
                                      label: l.uploadProof,
                                      onPressed: () =>
                                          _uploadPaymentProof('${order['id']}'),
                                      type: ButtonType.outline,
                                    ),
                                  ],
                                  if (status == 'completed') ...[
                                    const SizedBox(height: 12),
                                    AppButton(
                                      label: l.writeRatingComment,
                                      icon: Icons.rate_review_outlined,
                                      onPressed: () => context.push(
                                        '/write-review',
                                        extra: {
                                          'package_id':
                                              '${order['package_id'] ?? ''}',
                                          'catalog_id':
                                              '${order['catalog_id'] ?? ''}',
                                          'name':
                                              (order['item']
                                                  as Map<
                                                    String,
                                                    dynamic
                                                  >?)?['name'] ??
                                              '',
                                        },
                                      ),
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
