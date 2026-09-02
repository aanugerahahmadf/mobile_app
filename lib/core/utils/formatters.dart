import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Formatters {
  /// Parse price from dynamic (String or num) to int
  static int parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is num) return price.toInt();
    if (price is String) return (double.tryParse(price) ?? 0).toInt();
    return 0;
  }

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

  static String chatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('HH:mm', 'id').format(date);
    } catch (_) {
      return '';
    }
  }

  /// Extract avatar URL from raw user data map with fallback to [avatar] field.
  static String? avatarUrl(Map<String, dynamic>? data) {
    if (data == null) return null;
    final url = data['avatar_url'] as String?;
    if (url != null && url.isNotEmpty) return imageUrl(url);
    final avatar = data['avatar'] as String?;
    if (avatar != null && avatar.isNotEmpty && avatar != 'avatar.png') {
      return imageUrl('media/$avatar');
    }
    return null;
  }

  /// Ekstrak semua URL gambar dari raw item map (response API package/product).
  ///
  /// Menangani berbagai bentuk yang dikirim backend/Filament:
  ///   1. `media`  — array object ({`original_url`/`url`}) ATAU array string URL
  ///   2. `images` — array object/string (nama field alternatif)
  ///   3. `image_url` / `image` — single URL (fallback)
  ///
  /// Return list URL penuh (sudah dinormalisasi via [imageUrl]).
  static List<String> itemMediaUrls(Map<String, dynamic>? data) {
    if (data == null) return const [];
    final urls = <String>[];

    void addUrl(String? url) {
      final normalized = imageUrl(url);
      if (normalized.isNotEmpty && !urls.contains(normalized)) {
        urls.add(normalized);
      }
    }

    void addFromList(dynamic raw) {
      if (raw is! List) return;
      for (final entry in raw) {
        if (entry is String) {
          addUrl(entry);
        } else if (entry is Map) {
          final map = Map<String, dynamic>.from(entry);
          final src = (map['original_url'] as String?)?.isNotEmpty == true
              ? map['original_url'] as String
              : (map['url'] as String? ?? '');
          addUrl(src);
        }
      }
    }

    addFromList(data['media']);
    if (urls.isEmpty) addFromList(data['images']);
    if (urls.isEmpty) {
      addUrl(data['image_url'] as String?);
      if (urls.isEmpty) addUrl(data['image'] as String?);
    }
    return urls;
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
