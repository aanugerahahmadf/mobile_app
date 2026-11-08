/// Satu komentar penilaian pada section/sheet "Komentar Penilaian Katalog".
///
/// `reviewerName` sudah dimasking oleh backend bila `is_anonymous` true,
/// jadi client TIDAK boleh memasking ulang nama semua pengguna.
class CatalogRatingCommentModel {
  final int id;
  final int? userId;
  final String reviewerName;
  final String? reviewerAvatar;
  final bool isAnonymous;
  final bool isVerifiedPurchase;
  final String itemName;
  final String? itemImageUrl;
  final int? catalogId;
  final int? packageId;
  final Map<String, dynamic>? catalog;
  final Map<String, dynamic>? package;
  final int rating;
  final String? title;
  final String? comment;
  final String? variation;
  final Map<String, dynamic>? specifications;
  final String? photo;
  final List<String> photos;
  final int helpfulCount;
  final bool isVoted;
  final String? createdAt;
  final String? sellerReply;
  final List<Map<String, dynamic>> replies;

  const CatalogRatingCommentModel({
    required this.id,
    this.userId,
    this.reviewerName = 'Pengguna',
    this.reviewerAvatar,
    this.isAnonymous = false,
    this.isVerifiedPurchase = false,
    this.itemName = '',
    this.itemImageUrl,
    this.catalogId,
    this.packageId,
    this.catalog,
    this.package,
    required this.rating,
    this.title,
    this.comment,
    this.variation,
    this.specifications,
    this.photo,
    this.photos = const [],
    this.helpfulCount = 0,
    this.isVoted = false,
    this.createdAt,
    this.sellerReply,
    this.replies = const [],
  });

  CatalogRatingCommentModel copyWith({int? helpfulCount, bool? isVoted}) {
    return CatalogRatingCommentModel(
      id: id,
      userId: userId,
      reviewerName: reviewerName,
      reviewerAvatar: reviewerAvatar,
      isAnonymous: isAnonymous,
      isVerifiedPurchase: isVerifiedPurchase,
      itemName: itemName,
      itemImageUrl: itemImageUrl,
      catalogId: catalogId,
      packageId: packageId,
      catalog: catalog,
      package: package,
      rating: rating,
      title: title,
      comment: comment,
      variation: variation,
      specifications: specifications,
      photo: photo,
      photos: photos,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isVoted: isVoted ?? this.isVoted,
      createdAt: createdAt,
      sellerReply: sellerReply,
      replies: replies,
    );
  }

  /// Nama yang sudah aman ditampilkan (dimasking backend untuk anonim).
  String get displayName {
    if (reviewerName.trim().isNotEmpty) return reviewerName;
    return isAnonymous ? 'Pengguna' : 'Pengguna';
  }

  String get displayItemName {
    if (itemName.trim().isNotEmpty) return itemName;
    return (catalog?['name'] as String?) ?? (package?['name'] as String?) ?? '';
  }

  String? get displayItemImage {
    if (itemImageUrl != null && itemImageUrl!.isNotEmpty) {
      return itemImageUrl;
    }
    return _firstMediaUrl(catalog) ?? _firstMediaUrl(package);
  }

  bool get hasPhotos => photoUrls.isNotEmpty;

  bool get hasSellerReply =>
      (sellerReply != null && sellerReply!.isNotEmpty) || replies.isNotEmpty;

  String? get activeSellerReply {
    if (sellerReply != null && sellerReply!.isNotEmpty) return sellerReply;
    if (replies.isNotEmpty) return replies.first['comment'] as String?;
    return null;
  }

  List<String> get photoUrls {
    if (photos.isNotEmpty) return photos;
    if (photo != null && photo!.isNotEmpty) return [photo!];
    return const [];
  }

  static String? _firstMediaUrl(Map<String, dynamic>? item) {
    if (item == null) return null;
    final media = item['media'];
    if (media is List && media.isNotEmpty) {
      final first = media.first;
      if (first is Map) {
        return (first['url'] ?? first['original_url']) as String?;
      }
    }
    return (item['image_url'] ?? item['image']) as String?;
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }

  static List<String> _asStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((e) => e.toString()).toList();
  }

  static List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  factory CatalogRatingCommentModel.fromJson(Map<String, dynamic> json) {
    final user = _asMap(json['user']);
    final reviewerName =
        (json['reviewer_name'] as String?)?.trim().isNotEmpty == true
        ? json['reviewer_name'] as String
        : ((user['full_name'] ??
                  user['name'] ??
                  json['user_name'] ??
                  'Pengguna')
              as String);

    return CatalogRatingCommentModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt(),
      reviewerName: reviewerName,
      reviewerAvatar:
          (json['reviewer_avatar'] as String?) ??
          (user['avatar_url'] as String?) ??
          (user['avatar'] as String?),
      isAnonymous: json['is_anonymous'] == true,
      isVerifiedPurchase:
          json['is_verified_purchase'] == true || json['order_id'] != null,
      itemName: (json['item_name'] as String?) ?? '',
      itemImageUrl: json['item_image_url'] as String?,
      catalogId: (json['catalog_id'] as num?)?.toInt(),
      packageId: ((json['package_id'] ?? json['tier_id']) as num?)?.toInt(),
      catalog: json['catalog'] is Map
          ? Map<String, dynamic>.from(json['catalog'] as Map)
          : null,
      package: json['package'] is Map
          ? Map<String, dynamic>.from(json['package'] as Map)
          : null,
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      variation: json['variation'] as String?,
      specifications: json['specifications'] is Map
          ? Map<String, dynamic>.from(json['specifications'] as Map)
          : null,
      photo: (json['photo_url'] ?? json['photo']) as String?,
      photos: json['photo_urls'] is List
          ? _asStringList(json['photo_urls'])
          : _asStringList(json['photos']),
      helpfulCount: (json['helpful_count'] as num?)?.toInt() ?? 0,
      isVoted: json['is_voted'] == true,
      createdAt: json['created_at'] as String?,
      sellerReply: json['seller_reply'] as String?,
      replies: _asMapList(json['replies']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'reviewer_name': reviewerName,
    'reviewer_avatar': reviewerAvatar,
    'is_anonymous': isAnonymous,
    'is_verified_purchase': isVerifiedPurchase,
    'item_name': itemName,
    'item_image_url': itemImageUrl,
    'catalog_id': catalogId,
    'package_id': packageId,
    'catalog': catalog,
    'package': package,
    'rating': rating,
    'title': title,
    'comment': comment,
    'variation': variation,
    'specifications': specifications,
    'photo': photo,
    'photos': photos,
    'helpful_count': helpfulCount,
    'is_voted': isVoted,
    'created_at': createdAt,
    'seller_reply': sellerReply,
    'replies': replies,
  };
}
