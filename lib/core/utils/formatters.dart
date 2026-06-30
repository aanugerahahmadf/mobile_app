import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Formatters {
  static String currency(int amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  static String date(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy', 'id').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  static String dateTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy HH:mm', 'id').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  static String timeAgo(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return DateFormat('dd MMM', 'id').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  static String similarity(double score) {
    return '${(score * 100).toStringAsFixed(0)}%';
  }

  static String imageUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    String baseHost = 'http://10.0.2.2:8000';
    try {
      final apiBaseUrl = dotenv.get('API_BASE_URL', fallback: 'http://10.0.2.2:8000/api');
      final uri = Uri.parse(apiBaseUrl);
      baseHost = '${uri.scheme}://${uri.host}:${uri.port}';
    } catch (_) {}

    if (url.startsWith('http://') || url.startsWith('https://')) {
      try {
        final parsedUri = Uri.parse(url);
        final host = parsedUri.host.toLowerCase();
        
        final isLocalHost = host == 'localhost' ||
            host == '127.0.0.1' ||
            host.startsWith('192.168.') ||
            host.startsWith('172.') ||
            host.startsWith('10.');
            
        if (isLocalHost) {
          return '$baseHost${parsedUri.path}${parsedUri.hasQuery ? '?${parsedUri.query}' : ''}';
        }
      } catch (_) {}
      return url;
    }

    String cleanUrl = url;
    if (cleanUrl.startsWith('/')) {
      return '$baseHost$cleanUrl';
    }
    return '$baseHost/$cleanUrl';
  }
}
