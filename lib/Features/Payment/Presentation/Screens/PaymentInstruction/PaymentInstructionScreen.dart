import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Utils/Formatters/Formatters.dart';
import '../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import '../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import '../../../../Order/Data/OrderRepositoryImpl/OrderRepositoryImpl.dart';
import '../../../Domain/PaymentMethodInfo/PaymentMethodInfo.dart';
import '../../Widgets/PaymentCountdown/PaymentCountdown.dart';
import '../../Widgets/PaymentMethodSelector/PaymentMethodSelector.dart';
import '../../Widgets/UploadPaymentProof/UploadPaymentProof.dart';

class PaymentInstructionScreen extends ConsumerStatefulWidget {
  final String orderId;

  const PaymentInstructionScreen({super.key, required this.orderId});

  @override
  ConsumerState<PaymentInstructionScreen> createState() =>
      _PaymentInstructionPageState();
}

class _PaymentInstructionPageState
    extends ConsumerState<PaymentInstructionScreen> {
  Map<String, dynamic>? _order;
  bool _loading = true;

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
      final order = await OrderRepositoryImpl().getOrderDetail(widget.orderId);
      if (mounted) {
        setState(() {
          _order = order;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openMethod(PaymentMethodInfo method) async {
    final reload = await context.push<bool>(
      '/payment-method/${widget.orderId}',
      extra: method,
    );
    if (reload == true && mounted) {
      _loadOrder();
    }
  }

  int _paymentAmount() {
    final transaction = _order?['latest_transaction'];
    final raw = transaction is Map
        ? (transaction['total_amount'] ?? transaction['amount'])
        : null;
    final amount = Formatters.parsePrice(raw);
    return amount > 0 ? amount : Formatters.parsePrice(_order?['total_price']);
  }

  DateTime? _paymentDeadline() {
    final transaction = _order?['latest_transaction'];
    final expiry = transaction is Map ? transaction['virtual_account_expiry'] : null;
    final explicit = DateTime.tryParse('$expiry');
    if (explicit != null) return explicit.toLocal();
    final created = DateTime.tryParse('${_order?['created_at'] ?? ''}');
    return created?.add(const Duration(hours: 24));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    if (authState is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l.payment),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(38),
            child: const AppBreadcrumbs.global(),
          ),
        ),
        body: const GuestAuthPrompt(icon: Icons.payment_outlined),
      );
    }
    final payStatus = '${_order?['payment_status'] ?? 'unpaid'}';
    final isPaid =
        payStatus == 'paid' ||
        payStatus == 'success' ||
        payStatus == 'completed';
    final isPending = payStatus == 'pending';
    final paymentMethods =
        (_order?['payment_methods'] as List?)
            ?.cast<Map<String, dynamic>>()
            .map((m) => PaymentMethodInfo.fromJson(m))
            .toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(isPaid ? l.paymentSuccess : l.payment),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38),
          child: const AppBreadcrumbs.global(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _order == null
          ? Center(child: Text(l.orderFailed, style: AppTextStyles.bodyMedium))
          : RefreshIndicator(
              onRefresh: _loadOrder,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     _buildOrderSummary(l),
                     const SizedBox(height: AppSizes.lg),
                     PaymentCountdown(deadline: _paymentDeadline()),
                     const SizedBox(height: AppSizes.lg),
                    if (isPaid) ...[
                      _buildPaymentSuccess(l),
                    ] else if (isPending) ...[
                      _buildPendingVerification(l),
                    ] else ...[
                      Text(l.paymentMethod, style: AppTextStyles.titleMedium),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        l.selectPaymentMethod,
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: AppSizes.md),
                      PaymentMethodSelector(
                        methods: paymentMethods,
                        selectedId: null,
                        onSelect: (id) {
                          PaymentMethodInfo? method;
                          for (final m in paymentMethods) {
                            if (m.id == id) {
                              method = m;
                              break;
                            }
                          }
                          if (method != null) _openMethod(method);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOrderSummary(AppLocalizations l) {
    final item =
        _order!['package'] as Map<String, dynamic>? ??
        _order!['catalog'] as Map<String, dynamic>?;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l.order} #${_order!['order_number'] ?? widget.orderId}',
                    style: AppTextStyles.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (item != null) ...[
              Text(
                item['name'] as String? ?? '',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 4),
            ],
            Row(
              children: [
                Text(l.total, style: AppTextStyles.bodySmall),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    Formatters.currency(
                       _paymentAmount(),
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSuccess(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 64, color: AppColors.successColor),
            const SizedBox(height: 16),
            Text(l.paymentSuccess, style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              l.paymentSuccessDesc,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: l.viewOrder,
                onPressed: () {
                  context.pop();
                  context.push('/order/${widget.orderId}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingVerification(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Icon(Icons.access_time, size: 64, color: AppColors.warningColor),
            const SizedBox(height: 16),
            Text(l.waitingVerification, style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              l.waitingVerificationDesc,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: l.uploadProof,
                onPressed: () => uploadPaymentProof(
                  context,
                  ref,
                  widget.orderId,
                  onUploaded: _loadOrder,
                ),
                type: ButtonType.outline,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: l.viewOrder,
                onPressed: () {
                  context.pop();
                  context.push('/order/${widget.orderId}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
