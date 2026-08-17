import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/credit_card_form.dart';
import '../../../order/data/order_repository_impl.dart';
import '../../domain/payment_method_info.dart';
import '../providers/payment_provider.dart';
import '../widgets/bank_transfer_detail.dart';
import '../widgets/payment_countdown.dart';

class PaymentMethodDetailPage extends ConsumerStatefulWidget {
  final String orderId;
  final PaymentMethodInfo method;

  const PaymentMethodDetailPage({
    super.key,
    required this.orderId,
    required this.method,
  });

  @override
  ConsumerState<PaymentMethodDetailPage> createState() => _PaymentMethodDetailPageState();
}

class _PaymentMethodDetailPageState extends ConsumerState<PaymentMethodDetailPage> {
  Map<String, dynamic>? _order;
  bool _loading = true;
  bool _submitting = false;
  Map<String, dynamic>? _va;
  bool _vaLoading = false;
  Map<String, dynamic>? _qris;
  bool _qrisLoading = false;
  final _cardFormKey = GlobalKey<CreditCardFormState>();

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

  DateTime? get _deadline {
    final created = DateTime.tryParse('${_order?['created_at'] ?? ''}');
    if (created == null) return null;
    return created.add(const Duration(hours: 24));
  }

  Future<void> _confirm() async {
    final l = AppLocalizations.of(context)!;
    Map<String, dynamic>? cardDetails;
    if (widget.method.type == 'credit_card') {
      if (_cardFormKey.currentState == null || !_cardFormKey.currentState!.validate()) return;
      cardDetails = _cardFormKey.currentState!.cardDetails;
    }

    setState(() => _submitting = true);
    try {
      final ok = await ref.read(paymentProvider.notifier)
          .confirmPayment(widget.orderId, widget.method.id, cardDetails: cardDetails);
      if (!mounted) return;
      if (ok) {
        AppSnackBar.show(context, l.paymentSubmitted, type: SnackBarType.success);
        context.pop(true);
      } else {
        AppSnackBar.show(context, ref.read(paymentProvider).error ?? l.failedProcessPayment, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _createVirtualAccount() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _vaLoading = true);
    try {
      final va = await ref.read(paymentProvider.notifier).createVirtualAccount(widget.orderId);
      if (!mounted) return;
      setState(() => _va = va);
      if (va == null) {
        AppSnackBar.show(context, ref.read(paymentProvider).error ?? l.failedProcessPayment, type: SnackBarType.error);
      } else {
        await _loadOrder();
      }
    } finally {
      if (mounted) setState(() => _vaLoading = false);
    }
  }

  Future<void> _createQris() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _qrisLoading = true);
    try {
      final qr = await ref.read(paymentProvider.notifier).createQris(widget.orderId);
      if (!mounted) return;
      setState(() => _qris = qr);
      if (qr == null) {
        AppSnackBar.show(context, ref.read(paymentProvider).error ?? l.failedProcessPayment, type: SnackBarType.error);
      } else {
        await _loadOrder();
      }
    } finally {
      if (mounted) setState(() => _qrisLoading = false);
    }
  }

  Future<void> _openApp() async {
    final l = AppLocalizations.of(context)!;
    final link = widget.method.deeplink;
    if (link == null || link.isEmpty) return;
    final ok = await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalApplication,
    );
    if (!mounted) return;
    if (!ok) {
      AppSnackBar.show(context, '${l.failedProcessPayment}: $link', type: SnackBarType.error);
    }
  }

  Future<void> _payWithGateway() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _submitting = true);
    try {
      final redirectUrl = await ref.read(paymentProvider.notifier)
          .payWithGateway(widget.orderId, widget.method.id);
      if (!mounted) return;
      if (redirectUrl == null || redirectUrl.isEmpty) {
        AppSnackBar.show(context, ref.read(paymentProvider).error ?? l.failedProcessPayment, type: SnackBarType.error);
        return;
      }
      // Buka halaman Midtrans Snap di WebView in-app. Snap akan mengarahkan
      // ke aplikasi e-wallet (DANA/OVO/GoPay/ShopeePay) via intent://, lalu
      // kembali ke halaman Snap setelah pembayaran selesai.
      await context.push('/payment-webview', extra: {
        'url': redirectUrl,
        'title': widget.method.name,
      });
      if (!mounted) return;

      await _loadOrder();
      if (!mounted) return;
      final status = _order?['payment_status'];
      if (status == 'paid' || status == 'success' || status == 'completed' || status == 'PAID') {
        AppSnackBar.show(context, l.paymentSubmitted, type: SnackBarType.success);
        context.pop(true);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final amount = Formatters.parsePrice(_order?['total_price']);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.method.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadOrder,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(l),
                    const SizedBox(height: AppSizes.md),
                    PaymentCountdown(deadline: _deadline),
                    const SizedBox(height: AppSizes.md),
                    if (widget.method.deeplink != null && widget.method.deeplink!.isNotEmpty) ...[
                      AppButton(
                        label: '${l.openPaymentApp} ${widget.method.name}',
                        icon: Icons.open_in_new,
                        onPressed: _openApp,
                        type: ButtonType.outline,
                      ),
                      const SizedBox(height: AppSizes.md),
                    ],
                    if (widget.method.type == 'virtual_account')
                      _buildVirtualAccountPayung(l, amount)
                    else if (widget.method.type == 'bank_transfer') ...[
                      BankTransferDetail(method: widget.method, amount: amount),
                      const SizedBox(height: AppSizes.md),
                      _buildVirtualAccountCard(l),
                    ]
                    else if (widget.method.type == 'qris')
                      _buildQrisContent(l, amount)
                    else if (widget.method.type == 'e_wallet')
                      _buildEWalletContent(l, amount)
                    else if (widget.method.type == 'credit_card')
                      _buildCreditCardContent(l, amount)
                    else
                      _buildGenericContent(l, amount),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: AppButton(
              label: widget.method.gatewayEnabled
                  ? l.payNow
                  : (widget.method.type == 'credit_card' ? l.confirmPayment : l.iHaveTransferred),
              loading: _submitting,
              onPressed: _submitting ? null : (widget.method.gatewayEnabled ? _payWithGateway : _confirm),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l) {
    final item = _order!['package'] as Map<String, dynamic>? ?? _order!['product'] as Map<String, dynamic>?;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withAlpha(12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_methodIcon(), size: 22, color: AppColors.primaryColor),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Text(widget.method.name,
                    style: AppTextStyles.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text('${l.order} #${_order!['order_number'] ?? widget.orderId}', style: AppTextStyles.bodySmall),
            if (item != null) ...[
              const SizedBox(height: 2),
              Text(item['name'] as String? ?? '', style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: AppSizes.sm),
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

  IconData _methodIcon() {
    switch (widget.method.type) {
      case 'bank_transfer': return Icons.account_balance;
      case 'e_wallet': return Icons.account_balance_wallet;
      case 'qris': return Icons.qr_code_2;
      case 'credit_card': return Icons.credit_card;
      default: return Icons.payments;
    }
  }

  Widget _buildQrisContent(AppLocalizations l, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAmountCard(l, amount),
        const SizedBox(height: AppSizes.md),
        if (widget.method.imageUrl != null)
          _buildQrisImage(widget.method.imageUrl!)
        else
          _buildQrisPlaceholder(l),
        const SizedBox(height: AppSizes.md),
        Text(l.paymentInstructions, style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSizes.sm),
        _buildSteps(l, widget.method.instructions ?? l.uploadProofDesc),
      ],
    );
  }

  Widget _buildQrisPlaceholder(AppLocalizations l) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code, size: 56, color: AppColors.primaryColor),
          const SizedBox(height: AppSizes.sm),
          Text(l.qrisImageNotAvailable, style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(l.qrScanInstruction, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildQrisImage(String imageUrl) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 280,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 280,
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => _buildQrisPlaceholder(AppLocalizations.of(context)!),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(l.qrScanInstruction,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEWalletContent(AppLocalizations l, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAmountCard(l, amount),
        const SizedBox(height: AppSizes.md),
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_methodIcon(), size: 26, color: AppColors.primaryColor),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.method.name, style: AppTextStyles.titleSmall),
                    const SizedBox(height: 2),
                    Text(l.payWithEWallet(widget.method.name), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Text(l.paymentInstructions, style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSizes.sm),
        _buildSteps(l, widget.method.instructions ?? l.uploadProofDesc),
      ],
    );
  }

  Widget _buildCreditCardContent(AppLocalizations l, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAmountCard(l, amount),
        const SizedBox(height: AppSizes.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.creditCard, style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSizes.sm),
                CreditCardForm(formKey: _cardFormKey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenericContent(AppLocalizations l, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAmountCard(l, amount),
        const SizedBox(height: AppSizes.md),
        if (widget.method.accountNumber != null)
          _buildInfoRow(l.accountNumber, widget.method.accountNumber!),
        if (widget.method.accountHolder != null)
          _buildInfoRow(l.accountHolder, widget.method.accountHolder!),
        if (widget.method.instructions != null) ...[
          const SizedBox(height: AppSizes.md),
          Text(l.paymentInstructions, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSizes.sm),
          _buildSteps(l, widget.method.instructions!),
        ],
      ],
    );
  }

  Widget _buildAmountCard(AppLocalizations l, int amount) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.totalPayment.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white70, fontWeight: FontWeight.w700, letterSpacing: 0.6),
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.currency(amount),
            style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(AppLocalizations l, String raw) {
    final steps = raw.split('\n').where((s) => s.trim().isNotEmpty).toList();
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) const Divider(height: AppSizes.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(steps[i], style: AppTextStyles.bodyMedium),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(value, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildVirtualAccountPayung(AppLocalizations l, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAmountCard(l, amount),
        const SizedBox(height: AppSizes.md),
        Text(l.paymentInstructions, style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSizes.sm),
        _buildSteps(l, widget.method.instructions ?? l.vaDescription),
        const SizedBox(height: AppSizes.md),
        _buildVirtualAccountCard(l),
        const SizedBox(height: AppSizes.md),
        _buildQrisCard(l),
        const SizedBox(height: AppSizes.md),
        _buildCreditCardNote(l),
      ],
    );
  }

  Widget _buildQrisCard(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.qr_code_2, size: 20, color: AppColors.primaryColor),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  'QRIS (Semua Bank & E-Wallet)',
                  style: AppTextStyles.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            l.qrisDynamicDescription,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.md),
          if (_qris == null)
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: l.createQris,
                icon: Icons.qr_code_2,
                loading: _qrisLoading,
                onPressed: _qrisLoading ? null : _createQris,
                type: ButtonType.outline,
              ),
            )
          else ...[
            Center(
              child: Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dividerColor),
                ),
                child: QrImageView(
                  data: (_qris!['qr_content'] ?? '').toString(),
                  size: 220,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            if (_qris!['qr_expiry'] != null)
              _buildInfoRow(l.vaExpiredAt, _formatDate(_qris!['qr_expiry'] as String)),
          ],
        ],
      ),
    );
  }

  Widget _buildCreditCardNote(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.credit_card, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              l.creditCardNote,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVirtualAccountCard(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, size: 20, color: AppColors.primaryColor),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  'Virtual Account BRI (BRIVA)',
                  style: AppTextStyles.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            l.vaDescription,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.md),
          if (_va == null)
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: l.createVirtualAccount,
                icon: Icons.pin,
                loading: _vaLoading,
                onPressed: _vaLoading ? null : _createVirtualAccount,
                type: ButtonType.outline,
              ),
            )
          else ...[
            _buildVaNumber(l),
            const SizedBox(height: AppSizes.sm),
            if (_va!['virtual_account_expiry'] != null)
              _buildInfoRow(l.vaExpiredAt, _formatDate(_va!['virtual_account_expiry'] as String)),
            if (_va!['account_holder'] != null)
              _buildInfoRow(l.accountHolder, _va!['account_holder'] as String),
          ],
        ],
      ),
    );
  }

  Widget _buildVaNumber(AppLocalizations l) {
    final vaNumber = _va?['virtual_account_no']?.toString() ?? '';
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.virtualAccountNo,
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white70, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  vaNumber,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: vaNumber));
              if (!mounted) return;
              AppSnackBar.show(context, l.copied, type: SnackBarType.success);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l.copy,
                style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final local = dt.toLocal();
    String pad(int v) => v.toString().padLeft(2, '0');
    return '${local.day}-${pad(local.month)}-${local.year} ${pad(local.hour)}:${pad(local.minute)}';
  }
}
