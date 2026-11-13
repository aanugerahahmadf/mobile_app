import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../../../../Core/Widgets/AppBottomSheet/AppBottomSheet.dart';
import '../../Providers/OrderProvider/OrderProvider.dart';
import '../../Widgets/OrderEditSheet/OrderEditSheet.dart';
import '../../../../../Core/Widgets/AppSnackbar/AppSnackbar.dart';
import '../../../../../Core/Errors/LocalizedError/LocalizedError.dart';
import '../../../../../Core/Utils/Formatters/Formatters.dart';
import '../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import '../../../Data/OrderRepositoryImpl/OrderRepositoryImpl.dart';
import '../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import '../../../../Chat/Presentation/Providers/ChatProvider.dart';
import '../../../../Chat/Presentation/Utils/CsChatLauncher/CsChatLauncher.dart';
import '../../../../Payment/Presentation/Widgets/UploadPaymentProof/UploadPaymentProof.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const OrderDetailScreen({super.key, required this.id});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailScreen> {
  Map<String, dynamic>? _order;
  bool _loading = true;
  bool _pdfLoading = false;
  bool _emailLoading = false;
  bool _cancelLoading = false;
  bool _deleteLoading = false;
  bool _trackingSyncLoading = false;
  bool _confirmReceivedLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;
    setState(() => _loading = true);
    try {
      final repo = OrderRepositoryImpl();
      final order = await repo.getOrderDetail(widget.id);
      if (mounted) {
        setState(() {
          _order = order;
          _loading = false;
        });
        AppNavigationTrail.instance.setCurrentLabel(
          '/order/${widget.id}',
          '${AppLocalizations.of(context)!.order} #${order['order_number'] ?? widget.id}',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  String _statusLabel(String? status) {
    final l = AppLocalizations.of(context)!;
    switch (status) {
      case 'pending':
        return l.awaitingConfirmation;
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

  String _payStatusLabel(String? status) {
    final l = AppLocalizations.of(context)!;
    switch (status) {
      case 'unpaid':
        return l.unpaid;
      case 'pending':
        return l.awaitingPayment;
      case 'partial':
        return l.partiallyPaid;
      case 'paid':
        return l.paidInFull;
      case 'failed':
        return l.failed;
      case 'refunded':
        return l.refunded;
      case 'cancelled':
        return l.cancelled;
      default:
        return status ?? '-';
    }
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
      case 'failed':
      case 'refunded':
        return AppColors.errorColor;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _statusIcon(String? status) {
    switch (status) {
      case 'pending':
        return Icons.access_time;
      case 'confirmed':
        return Icons.check_circle;
      case 'preparing':
        return Icons.build;
      case 'event_day':
        return Icons.celebration;
      case 'completed':
        return Icons.verified;
      case 'cancelled':
        return Icons.cancel;
      case 'failed':
      case 'refunded':
        return Icons.error;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _downloadPdf() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _pdfLoading = true);
    try {
      final repo = OrderRepositoryImpl();
      final path = await repo.downloadInvoice(widget.id);
      if (mounted) {
        AppSnackBar.show(
          context,
          l.invoiceDownloaded,
          type: SnackBarType.success,
        );
        OpenFile.open(path);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          l.failedDownloadInvoice,
          type: SnackBarType.error,
        );
      }
    }
    if (mounted) setState(() => _pdfLoading = false);
  }

  Future<void> _sendEmail() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _emailLoading = true);
    try {
      final repo = OrderRepositoryImpl();
      await repo.sendInvoiceEmail(widget.id);
      if (mounted) {
        AppSnackBar.show(
          context,
          l.invoiceSentToEmail,
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, l.failedSendEmail, type: SnackBarType.error);
      }
    }
    if (mounted) setState(() => _emailLoading = false);
  }

  Future<void> _sendWhatsapp() async {
    final l = AppLocalizations.of(context)!;
    final orderNumber = _order?['order_number'] ?? widget.id;
    final total = Formatters.currency(
      Formatters.parsePrice(_order?['total_price'] ?? _order?['total']),
    );
    final statusLabel = _statusLabel(_order?['status'] as String? ?? '');
    final message = l.whatsappOrderTemplate('$orderNumber', statusLabel, total);

    final phone = _order?['admin_phone'] as String?;
    final uri = phone != null
        ? Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}')
        : Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        AppSnackBar.show(
          context,
          l.failedOpenWhatsApp,
          type: SnackBarType.error,
        );
      }
    }
  }

  void _cancelOrder() async {
    final l = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.cancelOrder),
        content: Text(l.confirmCancelOrder),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: Text(l.no)),
          AppButton(
            label: l.yesCancel,
            onPressed: () => context.pop(true),
            type: ButtonType.text,
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _cancelLoading = true);
    try {
      final repo = OrderRepositoryImpl();
      await repo.cancelOrder(widget.id);
      if (mounted) {
        AppSnackBar.show(context, l.orderCancelled, type: SnackBarType.success);
        _loadOrder();
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          l.failedCancelOrder,
          type: SnackBarType.error,
        );
      }
    }
    if (mounted) setState(() => _cancelLoading = false);
  }

  Future<void> _editOrder() async {
    final l = AppLocalizations.of(context)!;
    final saved = await AppBottomSheet.show<bool>(
      context,
      OrderEditSheet(order: _order!),
      title: l.editOrder,
      initial: 0.8,
      min: 0.5,
      max: 0.95,
    );
    if (saved != true || !mounted) return;
    AppSnackBar.show(context, l.orderUpdated, type: SnackBarType.success);
    _loadOrder();
  }

  Future<void> _deleteOrder() async {
    final l = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.delete),
        content: Text(l.confirmDeleteOrder),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: Text(l.no)),
          AppButton(
            label: l.delete,
            onPressed: () => ctx.pop(true),
            type: ButtonType.text,
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _deleteLoading = true);
    final ok = await ref.read(orderProvider.notifier).deleteOrder(widget.id);
    if (!mounted) return;
    setState(() => _deleteLoading = false);
    if (ok) {
      AppSnackBar.show(context, l.orderDeleted, type: SnackBarType.success);
      context.pop();
      return;
    }
    final error = ref.read(orderProvider).error;
    AppSnackBar.show(
      context,
      error == null ? l.failedDeleteOrder : LocalizedError.of(l, error),
      type: SnackBarType.error,
    );
  }

  Future<void> _syncTracking() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _trackingSyncLoading = true);
    try {
      final repo = OrderRepositoryImpl();
      final data = await repo.syncTracking(widget.id);
      if (!mounted) return;
      setState(() {
        _order = data.isNotEmpty ? data : _order;
        _trackingSyncLoading = false;
      });
      final msg = data['_sync_message'] as String?;
      AppSnackBar.show(
        context,
        msg ?? l.trackingSynced,
        type: SnackBarType.success,
      );
      if (data.isEmpty) await _loadOrder();
    } catch (e) {
      if (!mounted) return;
      setState(() => _trackingSyncLoading = false);
      AppSnackBar.show(
        context,
        LocalizedError.of(l, e.toString()),
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _confirmReceived() async {
    final l = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.confirmReceived),
        content: Text(l.confirmReceivedDesc),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: Text(l.no)),
          AppButton(
            label: l.yes,
            onPressed: () => ctx.pop(true),
            type: ButtonType.text,
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => _confirmReceivedLoading = true);
    try {
      final repo = OrderRepositoryImpl();
      final data = await repo.confirmReceived(widget.id);
      if (!mounted) return;
      setState(() {
        if (data.isNotEmpty) _order = data;
        _confirmReceivedLoading = false;
      });
      AppSnackBar.show(context, l.confirmReceived, type: SnackBarType.success);
      if (data.isEmpty) await _loadOrder();
    } catch (e) {
      if (!mounted) return;
      setState(() => _confirmReceivedLoading = false);
      AppSnackBar.show(
        context,
        LocalizedError.of(l, e.toString()),
        type: SnackBarType.error,
      );
    }
  }

  void _buyAgain() {
    final order = _order;
    if (order == null) return;
    final catalogId = '${order['catalog_id'] ?? (order['catalog'] as Map?)?['id'] ?? ''}';
    final packageId = '${order['package_id'] ?? (order['package'] as Map?)?['id'] ?? ''}';
    if (catalogId.isNotEmpty && catalogId != 'null') {
      context.push('/catalog/$catalogId');
      return;
    }
    if (packageId.isNotEmpty && packageId != 'null') {
      context.push('/catalog/$packageId');
    }
  }

  /// Ringkasan checkout: metode bayar, nomor VA / payload QRIS, nominal, dan
  /// deadline semuanya berasal dari server.
  Widget _buildPaymentSummary(AppLocalizations l) {
    final order = _order!;
    final payment = order['payment'] as Map<String, dynamic>?;
    final type = order['payment_type'] as String?;
    final vaNumber = order['va_number'] as String?;
    final deadline = payment?['deadline'] as String?;
    if (type == null && payment == null) return const SizedBox.shrink();

    final rows = <Widget>[
      _buildInfoRow(
        l.paymentMethod,
        (order['payment_type_label'] as String?) ??
            switch (type) {
              'virtual_account' => l.virtualAccount,
              'qris' => l.qris,
              _ => '-',
            },
      ),
      if (vaNumber != null) _buildInfoRow(l.virtualAccountNo, vaNumber),
      if (order['qris_payload'] != null)
        _buildInfoRow(l.qris, order['qris_payload'].toString()),
      _buildInfoRow(
        l.total,
        Formatters.currency(
          Formatters.parsePrice(
            payment?['amount'] ?? order['total_price'] ?? order['total'],
          ),
        ),
      ),
      if (deadline != null && payment?['status'] != 'paid')
        _buildInfoRow(
          payment?['is_expired'] == true ? l.expired : l.paymentDeadline,
          Formatters.dateTime(deadline),
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(children: rows),
      ),
    );
  }

  Widget _buildShippingTracking(AppLocalizations l) {
    final shipping = _order?['shipping'] as Map<String, dynamic>?;
    final hasInfo = shipping?['has_info'] == true;
    final courierName =
        (shipping?['courier_name'] ?? shipping?['courier']) as String?;
    final trackingNumber = shipping?['tracking_number'] as String?;
    final trackingUrl = shipping?['tracking_url'] as String?;
    final statusLabel = shipping?['status_label'] as String?;
    final statusCode = shipping?['status'] as String?;
    final shippedAt = shipping?['shipped_at'] as String?;
    final deliveredAt = shipping?['delivered_at'] as String?;
    final notes = shipping?['notes'] as String?;
    final events = (shipping?['events'] as List?)?.cast<Map<String, dynamic>>() ?? const <Map<String, dynamic>>[];
    final destination = (_order?['location_address'] ?? _order?['notes']) as String?;

    final steps = const [
      ('packed', 'Dikemas'),
      ('picked_up', 'Diambil Kurir'),
      ('in_transit', 'Dalam Perjalanan'),
      ('out_for_delivery', 'Sedang Diantar'),
      ('delivered', 'Terkirim'),
    ];
    const rank = {
      'pending': 0,
      'packed': 1,
      'picked_up': 2,
      'in_transit': 3,
      'out_for_delivery': 4,
      'delivered': 5,
      'returned': 5,
      'failed': 0,
    };
    final currentRank = rank[statusCode] ?? 0;
    final showProgress = hasInfo && statusCode != 'failed';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined,
                    color: AppColors.primaryColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.shippingTracking,
                    style: AppTextStyles.titleMedium,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (statusLabel != null
                            ? AppColors.primaryColor
                            : AppColors.textSecondary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    statusLabel ?? l.noTrackingYet,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: statusLabel != null
                          ? AppColors.primaryColor
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l.waitingTrackingInfo,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            if (showProgress) ...[
              const SizedBox(height: 12),
              Row(
                children: steps.map((s) {
                  final stepRank = rank[s.$1] ?? 0;
                  final active = currentRank >= stepRank && currentRank > 0;
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primaryColor
                                : AppColors.textTertiary.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.$2,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 10,
                            color: active
                                ? AppColors.primaryColor
                                : AppColors.textSecondary,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            _buildInfoRow(l.courier, (courierName != null && courierName.isNotEmpty) ? courierName : '-'),
            _buildInfoRow(
              l.trackingNumber,
              (trackingNumber != null && trackingNumber.isNotEmpty)
                  ? trackingNumber
                  : l.noTrackingYet,
            ),
            if (shippedAt != null) _buildInfoRow(l.shippedAt, Formatters.dateTime(shippedAt)),
            if (deliveredAt != null) _buildInfoRow(l.deliveredAt, Formatters.dateTime(deliveredAt)),
            if (notes != null && notes.isNotEmpty) _buildInfoRow(l.shippingNotes, notes),
            Row(
              children: [
                if (trackingUrl != null && trackingUrl.isNotEmpty)
                  Expanded(
                    child: AppButton(
                      label: l.trackPackage,
                      icon: Icons.open_in_new,
                      type: ButtonType.outline,
                      onPressed: () async {
                        final uri = Uri.tryParse(trackingUrl);
                        if (uri == null) return;
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                    ),
                  ),
                if (trackingNumber != null && trackingNumber.isNotEmpty) ...[
                  if (trackingUrl != null && trackingUrl.isNotEmpty)
                    const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      label: _trackingSyncLoading ? '...' : l.syncTracking,
                      icon: Icons.sync,
                      type: ButtonType.primary,
                      onPressed: _trackingSyncLoading ? null : _syncTracking,
                    ),
                  ),
                ],
              ],
            ),
            if (events.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(l.trackingHistory, style: AppTextStyles.titleSmall),
              const SizedBox(height: 8),
              ...events.take(12).map((e) {
                final desc = (e['description'] ?? '-') as String;
                final time = (e['time'] ?? '') as String;
                final loc = e['location'] as String?;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(desc, style: AppTextStyles.bodySmall),
                            if (time.isNotEmpty || (loc != null && loc.isNotEmpty))
                              Text(
                                [if (time.isNotEmpty) time, if (loc != null && loc.isNotEmpty) loc].join(' • '),
                                style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ] else if (trackingNumber != null && trackingNumber.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                l.waitingTrackingInfo,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.primaryColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l.deliveryLocationMap, style: AppTextStyles.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l.liveCourierLocationNote,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              l.destinationLocation,
              (destination != null && destination.trim().isNotEmpty) ? destination : '-',
            ),
            const SizedBox(height: 8),
            Text(
              (trackingNumber != null && trackingNumber.isNotEmpty)
                  ? '${l.shippingStatus}: ${statusLabel ?? l.noTrackingYet} • ${l.trackingNumber}: $trackingNumber'
                  : l.noTrackingYet,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    if (authState is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l.orderDetail),
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l.orderDetail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38),
          child: const AppBreadcrumbs.global(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: l.report,
            onPressed: () => openReportChat(
              context,
              ref,
              category: 'order',
              itemName: '${l.order} #${_order?['order_number'] ?? widget.id}',
              details: l.orderNumber,
              itemContext: {
                'is_order': true,
                'order_id': _order?['id'] ?? widget.id,
                'order_number': _order?['order_number'] ?? widget.id,
                'order_status': _order?['status'],
                'payment_status': _order?['payment_status'],
              },
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(LocalizedError.of(l, _error!)))
          : RefreshIndicator(
              onRefresh: _loadOrder,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${l.order} #${_order!['order_number'] ?? widget.id}',
                                    style: AppTextStyles.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor(
                                      _order!['status'] as String?,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _statusIcon(
                                          _order!['status'] as String?,
                                        ),
                                        size: 14,
                                        color: _statusColor(
                                          _order!['status'] as String?,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _statusLabel(
                                          _order!['status'] as String?,
                                        ),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: _statusColor(
                                            _order!['status'] as String?,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              l.date,
                              Formatters.date(
                                _order!['created_at'] as String? ?? '',
                              ),
                            ),
                            _buildInfoRow(
                              l.location,
                              _order!['location_address'] as String? ??
                                  _order!['notes'] as String? ??
                                  '-',
                            ),
                            if (_order!['event_date'] != null)
                              _buildInfoRow(
                                l.eventDate,
                                Formatters.date(
                                  _order!['event_date'] as String,
                                ),
                              ),
                            if (_order!['booking_date'] != null)
                              _buildInfoRow(
                                l.bookingDate,
                                Formatters.date(
                                  _order!['booking_date'] as String,
                                ),
                              ),
                            _buildInfoRow(
                              l.payment,
                              _payStatusLabel(
                                _order!['payment_status'] as String?,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(l.orderItems, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    () {
                      final pkg = _order!['package'] as Map<String, dynamic>?;
                      final prod = _order!['catalog'] as Map<String, dynamic>?;
                      final item = pkg ?? prod;
                      if (item == null) return const SizedBox.shrink();
                      final imageUrl = item['image_url'] as String? ?? '';
                      final name = item['name'] as String? ?? l.orderItems;
                      final rawPrice =
                          item['final_price'] ??
                          item['finalPrice'] ??
                          item['discount_price'] ??
                          item['discountPrice'] ??
                          item['price'];
                      final price = Formatters.parsePrice(rawPrice);
                      return Card(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (_, _) => Shimmer.fromColors(
                                baseColor: AppColors.shimmerBase,
                                highlightColor: AppColors.shimmerHighlight,
                                child: Container(color: AppColors.surfaceColor),
                              ),
                              errorWidget: (_, _, _) => Container(
                                color: AppColors.secondaryColor,
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          ),
                          title: Text(name, style: AppTextStyles.bodyMedium),
                          subtitle: Text(
                            '1x ${Formatters.currency(price)}',
                            style: AppTextStyles.bodySmall,
                          ),
                          trailing: Text(
                            Formatters.currency(price),
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      );
                    }(),
                    const SizedBox(height: 12),
                    _buildPaymentSummary(l),
                    const SizedBox(height: 12),
                    _buildShippingTracking(l),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.md),
                        child: Column(
                          children: [
                            _buildPriceRow(
                              l.subtotal,
                              Formatters.parsePrice(_order!['total_price']),
                            ),
                            const Divider(),
                            _buildPriceRow(
                              l.total,
                              Formatters.parsePrice(
                                (_order!['payment']
                                        as Map<String, dynamic>?)?['amount'] ??
                                    _order!['total_price'],
                              ),
                              bold: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l.actions, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      Icons.picture_as_pdf,
                      l.downloadPdf,
                      _downloadPdf,
                      loading: _pdfLoading,
                    ),
                    _buildActionButton(
                      Icons.email_outlined,
                      l.sendViaGmail,
                      _sendEmail,
                      loading: _emailLoading,
                    ),
                    _buildActionButton(
                      Icons.chat_outlined,
                      l.sendToWhatsapp,
                      _sendWhatsapp,
                    ),

                    if (_order!['can_confirm_received'] == true) ...[
                      const SizedBox(height: 8),
                      AppButton(
                        label: _confirmReceivedLoading ? '...' : l.confirmReceived,
                        icon: Icons.check_circle_outline,
                        onPressed: _confirmReceivedLoading ? null : _confirmReceived,
                      ),
                    ],
                    if ((_order!['catalog_id'] ?? (_order!['catalog'] as Map?)?['id']) != null) ...[
                      const SizedBox(height: 8),
                      AppButton(
                        label: l.buyAgain,
                        icon: Icons.shopping_bag_outlined,
                        onPressed: _buyAgain,
                        type: ButtonType.outline,
                      ),
                    ],
                    if (_order!['status'] == 'pending' ||
                        _order!['status'] == 'confirmed') ...[
                      const SizedBox(height: 8),
                      AppButton(
                        label: l.payNow,
                        onPressed: () => context.push('/payment/${widget.id}'),
                      ),
                    ],
                    if (_order!['payment_status'] == 'pending') ...[
                      const SizedBox(height: 8),
                      AppButton(
                        label: l.uploadProof,
                        onPressed: () => uploadPaymentProof(
                          context,
                          ref,
                          widget.id,
                          onUploaded: _loadOrder,
                        ),
                        type: ButtonType.outline,
                      ),
                    ],
                    if (_order!['can_edit'] == true) ...[
                      const SizedBox(height: 8),
                      AppButton(
                        label: l.editOrder,
                        icon: Icons.edit_outlined,
                        onPressed: _editOrder,
                        type: ButtonType.outline,
                      ),
                    ],
                    if (_order!['status'] == 'pending') ...[
                      const SizedBox(height: 8),
                      AppButton(
                        label: l.cancelOrder,
                        onPressed: _cancelLoading ? null : _cancelOrder,
                        type: ButtonType.outline,
                      ),
                    ],
                    if (_order!['can_delete'] == true) ...[
                      const SizedBox(height: 8),
                      AppButton(
                        label: l.delete,
                        icon: Icons.delete_outline,
                        onPressed: _deleteLoading ? null : _deleteOrder,
                        type: ButtonType.outline,
                      ),
                    ],
                    const SizedBox(height: 8),
                    AppButton(
                      label: l.chatWithAdmin,
                      onPressed: () async {
                        try {
                          final notifier = ref.read(chatProvider.notifier);
                          final inboxId = await notifier.startConversation(
                            itemContext: {'order_id': widget.id},
                          );
                          if (context.mounted) {
                            context.push('/chat/$inboxId');
                          }
                        } catch (_) {
                          if (context.mounted) {
                            final l = AppLocalizations.of(context)!;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l.failedStartConversation),
                              ),
                            );
                          }
                        }
                      },
                      type: ButtonType.text,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool loading = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, color: AppColors.primaryColor),
        title: Text(label, style: AppTextStyles.bodyMedium),
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: loading ? null : onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: bold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium,
        ),
        Text(
          Formatters.currency(amount),
          style: bold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
