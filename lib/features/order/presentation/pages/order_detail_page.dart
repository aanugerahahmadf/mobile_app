import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/order_repository_impl.dart';
import '../../../chat/presentation/providers/chat_provider.dart';

class OrderDetailPage extends ConsumerStatefulWidget {
  final String id;

  const OrderDetailPage({super.key, required this.id});

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  Map<String, dynamic>? _order;
  bool _loading = true;
  bool _pdfLoading = false;
  bool _emailLoading = false;
  bool _cancelLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    setState(() => _loading = true);
    try {
      final repo = OrderRepositoryImpl();
      final order = await repo.getOrderDetail(widget.id);
      if (mounted) setState(() { _order = order; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'pending': return 'Menunggu Konfirmasi';
      case 'confirmed': return 'Dikonfirmasi';
      case 'preparing': return 'Diproses';
      case 'event_day': return 'Hari-H';
      case 'completed': return 'Selesai';
      case 'cancelled': return 'Dibatalkan';
      default: return status ?? '-';
    }
  }

  String _payStatusLabel(String? status) {
    switch (status) {
      case 'unpaid': return 'Belum Dibayar';
      case 'pending': return 'Menunggu Pembayaran';
      case 'partial': return 'Dibayar Sebagian';
      case 'paid': return 'Lunas';
      case 'failed': return 'Gagal';
      case 'refunded': return 'Dikembalikan';
      case 'cancelled': return 'Dibatalkan';
      default: return status ?? '-';
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'pending': return AppColors.warningColor;
      case 'confirmed': case 'preparing': return AppColors.primaryColor;
      case 'event_day': return const Color(0xFF9C27B0);
      case 'completed': return AppColors.successColor;
      case 'cancelled': case 'failed': case 'refunded': return AppColors.errorColor;
      default: return AppColors.textSecondary;
    }
  }

  IconData _statusIcon(String? status) {
    switch (status) {
      case 'pending': return Icons.access_time;
      case 'confirmed': return Icons.check_circle;
      case 'preparing': return Icons.build;
      case 'event_day': return Icons.celebration;
      case 'completed': return Icons.verified;
      case 'cancelled': return Icons.cancel;
      case 'failed': case 'refunded': return Icons.error;
      default: return Icons.help_outline;
    }
  }

  Future<void> _downloadPdf() async {
    setState(() => _pdfLoading = true);
    try {
      final repo = OrderRepositoryImpl();
      final path = await repo.downloadInvoice(widget.id);
      if (mounted) {
        AppSnackBar.show(context, 'Invoice berhasil diunduh', type: SnackBarType.success);
        OpenFile.open(path);
      }
    } catch (e) {
      if (mounted) AppSnackBar.show(context, 'Gagal mengunduh invoice', type: SnackBarType.error);
    }
    if (mounted) setState(() => _pdfLoading = false);
  }

  Future<void> _sendEmail() async {
    setState(() => _emailLoading = true);
    try {
      final repo = OrderRepositoryImpl();
      await repo.sendInvoiceEmail(widget.id);
      if (mounted) AppSnackBar.show(context, 'Invoice dikirim ke email Anda', type: SnackBarType.success);
    } catch (e) {
      if (mounted) AppSnackBar.show(context, 'Gagal mengirim email', type: SnackBarType.error);
    }
    if (mounted) setState(() => _emailLoading = false);
  }

  Future<void> _sendWhatsapp() async {
    final orderNumber = _order?['order_number'] ?? widget.id;
    final total = Formatters.currency(_order?['total'] as int? ?? 0);
    final status = _order?['status'] as String? ?? '';
    final message = 'Halo Admin, saya ingin menanyakan pesanan #$orderNumber. Status: ${_statusLabel(status)}. Total: $total.';

    final phone = _order?['admin_phone'] as String?;
    final uri = phone != null
        ? Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}')
        : Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) AppSnackBar.show(context, 'Gagal membuka WhatsApp', type: SnackBarType.error);
    }
  }

  void _cancelOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Batalkan Pesanan'),
        content: Text('Yakin ingin membatalkan pesanan ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: Text('Tidak')),
          AppButton(label: 'Ya, Batalkan', onPressed: () => context.pop(true), type: ButtonType.text),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _cancelLoading = true);
    try {
      final repo = OrderRepositoryImpl();
      await repo.cancelOrder(widget.id);
      if (mounted) {
        AppSnackBar.show(context, 'Pesanan dibatalkan', type: SnackBarType.success);
        _loadOrder();
      }
    } catch (e) {
      if (mounted) AppSnackBar.show(context, 'Gagal membatalkan', type: SnackBarType.error);
    }
    if (mounted) setState(() => _cancelLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Pesanan')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${'Pesanan'} #${_order!['order_number'] ?? widget.id}', style: AppTextStyles.titleMedium),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _statusColor(_order!['status'] as String?).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(_statusIcon(_order!['status'] as String?), size: 14, color: _statusColor(_order!['status'] as String?)),
                                          const SizedBox(width: 4),
                                          Text(
                                            _statusLabel(_order!['status'] as String?),
                                            style: AppTextStyles.bodySmall.copyWith(color: _statusColor(_order!['status'] as String?)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow('Tanggal', Formatters.date(_order!['created_at'] as String? ?? '')),
                                _buildInfoRow('Lokasi', _order!['location_address'] as String? ?? _order!['notes'] as String? ?? '-'),
                                if (_order!['event_date'] != null)
                                  _buildInfoRow('Tanggal Acara', Formatters.date(_order!['event_date'] as String)),
                                if (_order!['booking_date'] != null)
                                  _buildInfoRow('Tanggal Booking', Formatters.date(_order!['booking_date'] as String)),
                                _buildInfoRow('Pembayaran', _payStatusLabel(_order!['payment_status'] as String?)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('Item', style: AppTextStyles.titleMedium),
                        const SizedBox(height: 8),
                        () {
                          final pkg = _order!['package'] as Map<String, dynamic>?;
                          final prod = _order!['product'] as Map<String, dynamic>?;
                          final item = pkg ?? prod;
                          if (item == null) return const SizedBox.shrink();
                          final imageUrl = item['image_url'] as String? ?? '';
                          final name = item['name'] as String? ?? 'Item';
                          final price = (item['price'] as num?)?.toDouble() ?? 0;
                          return Card(
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: 60, height: 60, fit: BoxFit.cover,
                                  placeholder: (_, _) => Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!,
                                    child: Container(color: Colors.white),
                                  ),
                                  errorWidget: (_, _, _) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image, color: Colors.grey),
                                  ),
                                ),
                              ),
                              title: Text(name, style: AppTextStyles.bodyMedium),
                              subtitle: Text('1x ${Formatters.currency(price.toInt())}', style: AppTextStyles.bodySmall),
                              trailing: Text(Formatters.currency(price.toInt()), style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryColor)),
                            ),
                          );
                        }(),
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.md),
                            child: Column(
                              children: [
                                _buildPriceRow('Subtotal', (_order!['total_price'] as num?)?.toInt() ?? 0),
                                const Divider(),
                                _buildPriceRow('Total', (_order!['total_price'] as num?)?.toInt() ?? 0, bold: true),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Aksi', style: AppTextStyles.titleMedium),
                        const SizedBox(height: 8),
                        _buildActionButton(Icons.picture_as_pdf, 'Download Invoice PDF', _downloadPdf, loading: _pdfLoading),
                        _buildActionButton(Icons.email_outlined, 'Kirim ke Email (Gmail)', _sendEmail, loading: _emailLoading),
                        _buildActionButton(Icons.chat_outlined, 'Kirim ke WhatsApp', _sendWhatsapp),

                        if (_order!['status'] == 'pending') ...[
                          const SizedBox(height: 8),
                          AppButton(
                            label: 'Bayar Sekarang',
                            onPressed: () => context.push('/payment/${widget.id}'),
                          ),
                          const SizedBox(height: 8),
                          AppButton(
                            label: 'Batalkan Pesanan',
                            onPressed: _cancelLoading ? null : _cancelOrder,
                            type: ButtonType.outline,
                          ),
                        ],
                        const SizedBox(height: 8),
                        AppButton(
                          label: 'Chat Admin',
                          onPressed: () async {
                            try {
                              final notifier = ref.read(chatProvider.notifier);
                              final inboxId = await notifier.startConversation(itemContext: {
                                'order_id': widget.id,
                              });
                              if (context.mounted) context.push('/chat/$inboxId');
                            } catch (_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal memulai percakapan')),
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

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed, {bool loading = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: loading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(icon, color: AppColors.primaryColor),
        title: Text(label, style: AppTextStyles.bodyMedium),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
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
          SizedBox(width: 120, child: Text(label, style: AppTextStyles.bodySmall)),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: bold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium),
        Text(Formatters.currency(amount), style: bold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium),
      ],
    );
  }
}
