import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const PaymentWebViewPage({super.key, required this.url, required this.title});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() => _loading = progress < 100);
          },
          onNavigationRequest: (request) => _handleNavigation(request.url),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// Teruskan http(s) ke WebView; skema lain (dana://, ovopay://, intent://, dst)
  /// diluncurkan ke aplikasi e-wallet di luar app.
  NavigationDecision _handleNavigation(String url) {
    final scheme = Uri.tryParse(url)?.scheme;
    if (scheme == 'http' || scheme == 'https') {
      return NavigationDecision.navigate;
    }
    _launchExternal(url);
    return NavigationDecision.prevent;
  }

  Future<void> _launchExternal(String url) async {
    final uri = _resolveIntentUrl(url);
    if (uri == null) return;

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka aplikasi e-wallet')),
      );
    }
  }

  /// Ubah `intent://...#Intent;scheme=xxx;package=yyy;end` menjadi `xxx://...`
  /// agar bisa dibuka via url_launcher pada perangkat Android/iOS.
  Uri? _resolveIntentUrl(String url) {
    if (!url.startsWith('intent://')) {
      final parsed = Uri.tryParse(url);
      if (parsed == null || parsed.scheme.isEmpty) return null;
      return parsed;
    }

    final schemeMatch = RegExp(r'scheme=([^;]+)').firstMatch(url);
    if (schemeMatch == null) return null;

    final intentMarker = url.indexOf('#Intent;');
    final path = intentMarker > 0
        ? url.substring('intent://'.length, intentMarker)
        : url.substring('intent://'.length);

    return Uri.tryParse('${schemeMatch.group(1)}://$path');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 16)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
