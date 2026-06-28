import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/payment_provider.dart';

class MidtransWebviewPage extends ConsumerStatefulWidget {
  final String orderId;
  final String? initialSnapToken;

  const MidtransWebviewPage({super.key, required this.orderId, this.initialSnapToken});

  @override
  ConsumerState<MidtransWebviewPage> createState() => _MidtransWebviewPageState();
}

class _MidtransWebviewPageState extends ConsumerState<MidtransWebviewPage> {
  WebViewController? _controller;
  bool _loading = true;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _initPayment();
  }

  @override
  void dispose() {
    _handled = true;
    super.dispose();
  }

  Future<void> _initPayment() async {
    String? url;

    if (widget.initialSnapToken != null && widget.initialSnapToken!.isNotEmpty) {
      url = widget.initialSnapToken;
    } else {
      final ok = await ref.read(paymentProvider.notifier).initiatePayment(widget.orderId);
      if (!mounted) return;
      if (ok) {
        final state = ref.read(paymentProvider);
        url = state.paymentUrl ?? state.snapToken;
      }
    }

    if (url != null) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => _loading = true),
            onPageFinished: (_) => setState(() => _loading = false),
            onUrlChange: (change) {
              if (_handled) return;
              final currentUrl = change.url ?? '';
              if (currentUrl.contains('finish') || currentUrl.contains('success')) {
                _handled = true;
                _showResultDialog('Pembayaran Berhasil', 'Terima kasih! Pembayaran Anda telah diterima. Pesanan sedang diproses.', Icons.check_circle, AppColors.successColor, true);
              } else if (currentUrl.contains('unfinish') || currentUrl.contains('pending')) {
                _handled = true;
                _showResultDialog('Pembayaran Belum Selesai', 'Pembayaran Anda masih menunggu konfirmasi. Silakan hubungi admin jika perlu bantuan.', Icons.access_time, AppColors.warningColor, false);
              } else if (currentUrl.contains('cancel')) {
                _handled = true;
                _showResultDialog('Pembayaran Dibatalkan', 'Anda membatalkan pembayaran. Anda dapat melakukan pembayaran kapan saja.', Icons.cancel, AppColors.errorColor, false);
              } else if (currentUrl.contains('error') || currentUrl.contains('failed')) {
                _handled = true;
                _showResultDialog('Pembayaran Gagal', 'Terjadi kesalahan saat memproses pembayaran. Silakan coba lagi.', Icons.error, AppColors.errorColor, false);
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
      setState(() {});
    } else {
      _showError();
    }
  }

  void _showResultDialog(String title, String message, IconData icon, Color color, bool success) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            AppButton(
              label: success ? 'Lihat Pesanan' : 'Kembali',
              onPressed: () {
                context.pop();
                context.pop();
                if (success) context.push('/orders');
              },
            ),
            if (!success) ...[
              const SizedBox(height: 8),
              AppButton(
                label: 'Coba Lagi',
                onPressed: () {
                  context.pop();
                  _handled = false;
                  _initPayment();
                },
                type: ButtonType.text,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showError() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.errorColor),
            const SizedBox(height: 16),
            Text('Pembayaran Gagal', style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(ref.read(paymentProvider).error ?? 'Terjadi kesalahan. Silakan coba lagi.', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            AppButton(label: 'Coba Lagi', onPressed: () { context.pop(); _initPayment(); }),
            const SizedBox(height: 8),
            AppButton(label: 'Kembali', onPressed: () { context.pop(); context.pop(); }, type: ButtonType.text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Batalkan Pembayaran?'),
                content: Text('Apakah Anda yakin ingin meninggalkan halaman pembayaran?'),
                actions: [
                  TextButton(onPressed: () => context.pop(), child: Text('Lanjutkan Bayar')),
                  TextButton(onPressed: () { context.pop(); context.pop(); }, child: Text('Ya, Batalkan')),
                ],
              ),
            );
          },
        ),
      ),
      body: paymentState.loading || _loading
          ? const Center(child: CircularProgressIndicator())
          : paymentState.error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: AppColors.errorColor),
                      const SizedBox(height: 16),
                      Text(paymentState.error!, style: const TextStyle(color: AppColors.errorColor), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      AppButton(label: 'Coba Lagi', onPressed: _initPayment, type: ButtonType.outline),
                    ],
                  ),
                )
              : _controller != null
                  ? WebViewWidget(controller: _controller!)
                  : const SizedBox.shrink(),
    );
  }
}
