import '../../../../core/utils/formatters.dart';

enum SuggestionType {
  packages,
  products,
  categories,
  vouchers,
  orders,
  reviews,
  terms,
  privacy,
  helps,
  histories,
  weddingPolicy;

  String get badgeLabel {
    switch (this) {
      case SuggestionType.packages:
        return 'paket';
      case SuggestionType.products:
        return 'bunga';
      case SuggestionType.categories:
        return 'kategori';
      case SuggestionType.vouchers:
        return 'voucher';
      case SuggestionType.orders:
        return 'pesanan';
      case SuggestionType.reviews:
        return 'ulasan';
      case SuggestionType.terms:
        return 'syarat';
      case SuggestionType.privacy:
        return 'privasi';
      case SuggestionType.helps:
        return 'bantuan';
      case SuggestionType.histories:
        return 'riwayat';
      case SuggestionType.weddingPolicy:
        return 'kebijakan';
    }
  }
}

class SearchSuggestion {
  final SuggestionType type;
  final int id;
  final String? name;
  final String? subtitle;
  final String? subtitle2;
  final String? imageUrl;
  final String routePath;
  final Map<String, dynamic>? routeExtra;

  const SearchSuggestion({
    required this.type,
    required this.id,
    this.name,
    this.subtitle,
    this.subtitle2,
    this.imageUrl,
    required this.routePath,
    this.routeExtra,
  });

  factory SearchSuggestion.fromJson(SuggestionType type, Map<String, dynamic> json) {
    final id = int.tryParse('${json['id']}') ?? 0;
    final imageUrl = _extractImage(json);

    switch (type) {
      case SuggestionType.categories:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          routePath: '/catalog',
          routeExtra: {'category_id': '$id', 'category_name': json['name']},
        );

      case SuggestionType.vouchers:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['code'] as String?,
          subtitle: json['description'] as String?,
          routePath: '/vouchers/$id',
          routeExtra: json,
        );

      case SuggestionType.orders:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['order_number'] as String?,
          subtitle: json['status'] as String?,
          routePath: '/order/$id',
        );

      case SuggestionType.reviews:
        final package = json['package'] as Map<String, dynamic>?;
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['comment'] as String?,
          subtitle: package?['name'] as String?,
          routePath: '/my-reviews',
        );

      case SuggestionType.terms:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          subtitle: json['title'] as String?,
          routePath: '/terms-of-service',
        );

      case SuggestionType.privacy:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          subtitle: json['title'] as String?,
          routePath: '/privacy-policy',
        );

      case SuggestionType.helps:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          subtitle: json['title'] as String?,
          routePath: '/help-center',
        );

      case SuggestionType.weddingPolicy:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          subtitle: json['title'] as String?,
          routePath: '/wedding-policy',
        );

      case SuggestionType.histories:
        final refNumber = json['reference_number'] as String?;
        final typeLabel = json['type'] as String? ?? '';
        final status = json['status'] as String? ?? '';
        final info = json['info'] as String? ?? '';
        final subtitle = [
          if (info.isNotEmpty) info,
          typeLabel,
          if (status.isNotEmpty) status,
        ].join(' · ');
        return SearchSuggestion(
          type: type,
          id: id,
          name: refNumber,
          subtitle: subtitle.isNotEmpty ? subtitle : null,
          routePath: '/history',
        );

      case SuggestionType.packages:
      case SuggestionType.products:
        final price = (json['price'] as num?)?.toInt() ?? 0;
        final name = json['name'] as String? ?? '';
        final subtitle = price > 0 ? _formatCurrency(price) : null;
        return SearchSuggestion(
          type: type,
          id: id,
          name: name,
          subtitle: subtitle,
          imageUrl: imageUrl,
          routePath: '/catalog/${type.name}/$id',
        );
    }
  }

  static String? _extractImage(Map<String, dynamic> json) {
    final media = json['media'] as List? ?? [];
    if (media.isNotEmpty && media[0] is Map) {
      final url = (media[0] as Map)['url'];
      if (url is String && url.isNotEmpty) return Formatters.imageUrl(url);
    }
    final image = json['image'] as String?;
    if (image != null && image.isNotEmpty) return Formatters.imageUrl(image);
    return null;
  }

  static String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }
}
