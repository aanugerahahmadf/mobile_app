class MyReviewModel {
  final int id;
  final int userId;
  final int? catalogId;
  final int? packageId;
  final int? orderId;
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
  final String? updatedAt;
  final Map<String, dynamic>? catalog;
  final Map<String, dynamic>? package;
  final String? reviewerName;
  final bool isAnonymous;
  final bool isVerifiedPurchase;
  final String itemName;
  final String? itemImageUrl;
  final List<Map<String, dynamic>> replies;

  const MyReviewModel({
    required this.id,
    required this.userId,
    this.catalogId,
    this.packageId,
    this.orderId,
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
    this.updatedAt,
    this.catalog,
    this.package,
    this.reviewerName,
    this.isAnonymous = false,
    this.isVerifiedPurchase = false,
    this.itemName = '',
    this.itemImageUrl,
    this.replies = const [],
  });

  String? get catalogName =>
      catalog?['name'] as String? ?? catalog?['title'] as String?;

  String? get catalogImage {
    final media = catalog?['media'];
    if (media is List && media.isNotEmpty) {
      final first = media.first;
      if (first is Map<String, dynamic>) {
        return first['url'] as String? ?? first['original_url'] as String?;
      }
    }
    return catalog?['image_url'] as String? ?? catalog?['image'] as String?;
  }

  String get displayItemName {
    if (itemName.trim().isNotEmpty) return itemName;
    return (catalog?['name'] as String?) ?? (package?['name'] as String?) ?? '';
  }

  String? get displayItemImage {
    if (itemImageUrl != null && itemImageUrl!.isNotEmpty) return itemImageUrl;
    final media = catalog?['media'];
    if (media is List && media.isNotEmpty && media.first is Map) {
      final first = media.first as Map;
      return (first['url'] ?? first['original_url']) as String?;
    }
    return (catalog?['image_url'] as String?) ??
        (package?['image_url'] as String?);
  }

  bool get hasReply => replies.isNotEmpty;

  String? get sellerReply {
    if (replies.isEmpty) return null;
    return replies.first['comment'] as String?;
  }

  List<String> get photoUrls {
    if (photos.isNotEmpty) return photos;
    if (photo != null && photo!.isNotEmpty) return [photo!];
    return const [];
  }

  factory MyReviewModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedPhotos = [];
    if (json['photo_urls'] is List) {
      parsedPhotos = (json['photo_urls'] as List)
          .map((e) => e.toString())
          .toList();
    } else if (json['photos'] is List) {
      parsedPhotos = (json['photos'] as List).map((e) => e.toString()).toList();
    }

    List<Map<String, dynamic>> parsedReplies = [];
    if (json['replies'] is List) {
      parsedReplies = (json['replies'] as List)
          .whereType<Map<String, dynamic>>()
          .toList();
    }

    return MyReviewModel(
      id: (json['id'] ?? 0) as int,
      userId: (json['user_id'] ?? 0) as int,
      catalogId: json['catalog_id'] as int?,
      packageId: (json['package_id'] ?? json['tier_id']) as int?,
      orderId: json['order_id'] as int?,
      rating: (json['rating'] ?? 5) as int,
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      variation: json['variation'] as String?,
      specifications: json['specifications'] as Map<String, dynamic>?,
      photo: json['photo_url'] as String? ?? json['photo'] as String?,
      photos: parsedPhotos,
      helpfulCount: (json['helpful_count'] as num?)?.toInt() ?? 0,
      isVoted: json['is_voted'] == true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      catalog: json['catalog'] is Map
          ? Map<String, dynamic>.from(json['catalog'] as Map)
          : null,
      package: json['package'] is Map
          ? Map<String, dynamic>.from(json['package'] as Map)
          : null,
      reviewerName: json['reviewer_name'] as String?,
      isAnonymous: json['is_anonymous'] == true,
      isVerifiedPurchase:
          json['is_verified_purchase'] == true || json['order_id'] != null,
      itemName: (json['item_name'] as String?) ?? '',
      itemImageUrl: json['item_image_url'] as String?,
      replies: parsedReplies,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'catalog_id': catalogId,
    'package_id': packageId,
    'order_id': orderId,
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
    'updated_at': updatedAt,
    'reviewer_name': reviewerName,
    'is_anonymous': isAnonymous,
    'is_verified_purchase': isVerifiedPurchase,
    'item_name': itemName,
    'item_image_url': itemImageUrl,
  };
}
