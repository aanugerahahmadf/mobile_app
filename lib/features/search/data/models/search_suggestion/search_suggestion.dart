import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/utils/formatters/formatters.dart';

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
  weddingPolicy,
  vendors;

  String get badgeLabel {
    switch (this) {
      case SuggestionType.packages:
        return 'Packages';
      case SuggestionType.products:
        return 'Products';
      case SuggestionType.categories:
        return 'Categories';
      case SuggestionType.vouchers:
        return 'Vouchers';
      case SuggestionType.orders:
        return 'Orders';
      case SuggestionType.reviews:
        return 'Reviews';
      case SuggestionType.terms:
        return 'Terms';
      case SuggestionType.privacy:
        return 'Privacy';
      case SuggestionType.helps:
        return 'Help';
      case SuggestionType.histories:
        return 'History';
      case SuggestionType.weddingPolicy:
        return 'Policy';
      case SuggestionType.vendors:
        return 'Vendors';
    }
  }

  String localizedLabel(AppLocalizations l) {
    switch (this) {
      case SuggestionType.packages:
        return l.packages;
      case SuggestionType.products:
        return l.products;
      case SuggestionType.categories:
        return l.categories;
      case SuggestionType.vouchers:
        return l.vouchers;
      case SuggestionType.orders:
        return l.order;
      case SuggestionType.reviews:
        return l.reviews;
      case SuggestionType.terms:
        return l.termsAndConditions;
      case SuggestionType.privacy:
        return l.privacyPolicy;
      case SuggestionType.helps:
        return l.helpCenter;
      case SuggestionType.histories:
        return l.history;
      case SuggestionType.weddingPolicy:
        return l.weddingPolicy;
      case SuggestionType.vendors:
        return l.vendors;
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
  final Map<String, dynamic>? rawData;

  const SearchSuggestion({
    required this.type,
    required this.id,
    this.name,
    this.subtitle,
    this.subtitle2,
    this.imageUrl,
    required this.routePath,
    this.routeExtra,
    this.rawData,
  });

  factory SearchSuggestion.fromJson(
    SuggestionType type,
    Map<String, dynamic> json,
  ) {
    final id = int.tryParse('${json['id']}') ?? 0;
    final imageUrl = _extractImage(json);

    switch (type) {
      case SuggestionType.categories:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          subtitle2: json['description'] as String?,
          routePath: '/catalog',
          routeExtra: {'category_id': '$id', 'category_name': json['name']},
          rawData: json,
        );

      case SuggestionType.vouchers:
        final discount =
            json['discount'] ?? json['discount_value'] ?? json['amount'] ?? '';
        final validUntil =
            json['valid_until'] as String? ??
            json['expired_at'] as String? ??
            '';
        final sub2 = [
          if (discount.toString().isNotEmpty) 'Diskon: $discount',
          if (validUntil.isNotEmpty) 'Sampai: $validUntil',
        ].join(' • ');
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['code'] as String?,
          subtitle: json['description'] as String?,
          subtitle2: sub2.isNotEmpty ? sub2 : null,
          routePath: '/vouchers/$id',
          routeExtra: {...json, 'id': id},
          rawData: json,
        );

      case SuggestionType.orders:
        final total =
            json['total'] ?? json['grand_total'] ?? json['amount'] ?? '';
        final customer = json['user'] is Map
            ? (json['user'] as Map)['name'] as String?
            : json['customer_name'] as String?;
        final sub2 = [
          if (total.toString().isNotEmpty) _formatCurrency(_parsePrice(total)),
          if (customer != null && customer.isNotEmpty) customer,
        ].join(' • ');
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['order_number'] as String?,
          subtitle: json['status'] as String?,
          subtitle2: sub2.isNotEmpty ? sub2 : null,
          routePath: '/order/$id',
          rawData: json,
        );

      case SuggestionType.reviews:
        final package = json['package'] as Map<String, dynamic>?;
        final rating = json['rating'] as num?;
        final user = json['user'] is Map
            ? (json['user'] as Map)['name'] as String?
            : json['customer_name'] as String?;
        final sub2 = [
          if (rating != null) '★ $rating',
          if (user != null && user.isNotEmpty) user,
        ].join(' • ');
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['comment'] as String?,
          subtitle: package?['name'] as String?,
          subtitle2: sub2.isNotEmpty ? sub2 : null,
          routePath: '/my-reviews',
          rawData: json,
        );

      case SuggestionType.terms:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          subtitle: json['title'] as String?,
          subtitle2:
              json['description'] as String? ?? json['content'] as String?,
          routePath: '/terms-of-service',
          rawData: json,
        );

      case SuggestionType.privacy:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          subtitle: json['title'] as String?,
          subtitle2:
              json['description'] as String? ?? json['content'] as String?,
          routePath: '/privacy-policy',
          rawData: json,
        );

      case SuggestionType.helps:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          subtitle: json['title'] as String?,
          subtitle2:
              json['description'] as String? ?? json['content'] as String?,
          routePath: '/help-center',
          rawData: json,
        );

      case SuggestionType.weddingPolicy:
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['name'] as String?,
          subtitle: json['title'] as String?,
          subtitle2:
              json['description'] as String? ?? json['content'] as String?,
          routePath: '/wedding-policy',
          rawData: json,
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
          rawData: json,
          routePath: '/history',
        );

      case SuggestionType.vendors:
        final logo = json['logo'] as String?;
        final desc = json['store_description'] as String?;
        final contact = json['contact_person'] as String?;
        final sub2 = [
          if (desc != null && desc.isNotEmpty) desc,
          if (contact != null && contact.isNotEmpty) contact,
        ].join(' • ');
        return SearchSuggestion(
          type: type,
          id: id,
          name: json['store_name'] as String?,
          subtitle: sub2.isNotEmpty ? sub2 : null,
          subtitle2:
              '${json['packages_count'] ?? 0} packages, ${json['products_count'] ?? 0} products',
          imageUrl: logo != null && logo.isNotEmpty
              ? Formatters.imageUrl(logo)
              : null,
          routePath: '/vendor/$id',
          rawData: json,
        );

      case SuggestionType.packages:
      case SuggestionType.products:
        final price = _pickPrice(json);
        final name = json['name'] as String? ?? '';
        final subtitle = price > 0 ? _formatCurrency(price) : null;
        final desc = json['description'] as String? ?? '';
        final category = json['category'] is Map
            ? (json['category'] as Map)['name'] as String?
            : json['category_name'] as String?;
        final sub2 = [
          if (desc.isNotEmpty) desc,
          if (category != null && category.isNotEmpty) category,
        ].join(' • ');
        return SearchSuggestion(
          type: type,
          id: id,
          name: name,
          subtitle: subtitle,
          subtitle2: sub2.isNotEmpty ? sub2 : null,
          imageUrl: imageUrl,
          routePath: '/catalog/${type.name}/$id',
          rawData: json,
        );
    }
  }

  static String? _extractImage(Map<String, dynamic> json) {
    final imageUrl = json['image_url'] as String?;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Formatters.imageUrl(imageUrl);
    }
    final media = json['media'] as List? ?? [];
    if (media.isNotEmpty && media[0] is Map) {
      final m = media[0] as Map;
      final originalUrl = m['original_url'] as String?;
      if (originalUrl != null && originalUrl.isNotEmpty) {
        return Formatters.imageUrl(originalUrl);
      }
      final previewUrl = m['preview_url'] as String?;
      if (previewUrl != null && previewUrl.isNotEmpty) {
        return Formatters.imageUrl(previewUrl);
      }
    }
    final image = json['image'] as String?;
    if (image != null && image.isNotEmpty) return Formatters.imageUrl(image);
    return null;
  }

  static int _pickPrice(Map<String, dynamic> json) {
    final price = _parsePrice(json['price']);
    if (price > 0) return price;
    return _parsePrice(json['final_price']);
  }

  static int _parsePrice(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return double.tryParse(v)?.toInt() ?? 0;
    return 0;
  }

  static String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }
}
