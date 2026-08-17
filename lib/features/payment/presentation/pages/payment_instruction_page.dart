import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../order/data/order_repository_impl.dart';
import '../../domain/payment_method_info.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/upload_payment_proof.dart';

class PaymentInstructionPage extends ConsumerStatefulWidget {
  final String orderId;

  const PaymentInstructionPage({super.key, required this.orderId});

  @override
  ConsumerState<PaymentInstructionPage> createState() => _PaymentInstructionPageState();
}

class _PaymentInstructionPageState extends ConsumerState<PaymentInstructionPage> {
  Map<String, dynamic>? _order;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    setState(() => _loading = true);
    try {
      final order = await OrderRepositoryImpl().getOrderDetail(widget.orderId);
      if (mounted) setState(() { _order = order; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openMethod(PaymentMethodInfo method) async {
    final reload = await context.push<bool>('/payment-method/${widget.orderId}', extra: method);
    if (reload == true && mounted) {
      _loadOrder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final payStatus = '${_order?['payment_status'] ?? 'unpaid'}';
    final isPaid = payStatus == 'paid' || payStatus == 'success' || payStatus == 'completed';
    final isPending = payStatus == 'pending';
    final paymentMethods = (_order?['payment_methods'] as List?)
            ?.cast<Map<String, dynamic>>()
            .map((m) => PaymentMethodInfo.fromJson(m))
            .toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(isPaid ? l.paymentSuccess : l.payment),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                        if (isPaid) ...[
                          _buildPaymentSuccess(l),
                        ] else if (isPending) ...[
                          _buildPendingVerification(l),
                        ] else ...[
                          Text(l.paymentMethod, style: AppTextStyles.titleMedium),
                          const SizedBox(height: AppSizes.sm),
                          Text(l.selectPaymentMethod, style: AppTextStyles.bodySmall),
                          const SizedBox(height: AppSizes.md),
                          PaymentMethodSelector(
                            methods: paymentMethods,
                            selectedId: null,
                            onSelect: (id) {
                              PaymentMethodInfo? method;
                              for (final m in paymentMethods) {
                                if (m.id == id) { method = m; break; }
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
    final item = _order!['package'] as Map<String, dynamic>? ?? _order!['product'] as Map<String, dynamic>?;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('${l.order} #${_order!['order_number'] ?? widget.orderId}',
                    style: AppTextStyles.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (item != null) ...[
              Text(item['name'] as String? ?? '', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
            ],
            Row(
              children: [
                Text(l.total, style: AppTextStyles.bodySmall),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(Formatters.currency(Formatters.parsePrice(_order!['total_price'])),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryColor),
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
            Text(l.paymentSuccessDesc, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
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
            Text(l.waitingVerificationDesc, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: l.uploadProof,
                onPressed: () => uploadPaymentProof(context, ref, widget.orderId, onUploaded: _loadOrder),
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
