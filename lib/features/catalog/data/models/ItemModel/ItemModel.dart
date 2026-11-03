import '../../../../../Core/Utils/NumberUtils/NumberUtils.dart';
import '../../../../../Core/Utils/Formatters/Formatters.dart';
import '../CategoryModel/CategoryModel.dart';
import '../ReviewModel/ReviewModel.dart';
import '../TierModel/TierModel.dart';

class ItemModel {
  final int id;
  final int? categoryId;
  final String name;
  final String slug;
  final String? description;
  final int stock;
  final bool isActive;
  final bool isFeatured;
  final List<String>? features;
  final String? theme;
  final String? color;
  final int? minCapacity;
  final int? maxCapacity;
  final String? imageUrl;
  final String? thumbnailUrl;
  final String? videoUrl;
  final List<dynamic>? media;
  final List<Map<String, dynamic>>? galleryUrls;
  final double averageRating;
  final bool isFavoriteed;
  final CategoryModel? category;
  final List<ReviewModel>? reviews;
  /// Package tiers belonging to this catalog. Customer-facing prices come from
  /// these tiers.
  final List<TierModel> tiers;
  final String? createdAt;
  final String? updatedAt;

  const ItemModel({
    required this.id,
    this.categoryId,
    required this.name,
    required this.slug,
    this.description,
    this.stock = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.features,
    this.theme,
    this.color,
    this.minCapacity,
    this.maxCapacity,
    this.imageUrl,
    this.thumbnailUrl,
    this.videoUrl,
    this.media,
    this.galleryUrls,
    this.averageRating = 0,
    this.isFavoriteed = false,
    this.category,
    this.reviews,
    this.tiers = const [],
    this.createdAt,
    this.updatedAt,
  });

  bool get hasDiscount => startingTier?.hasDiscount ?? false;

  TierModel? get startingTier {
    if (tiers.isEmpty) return null;
    final available = tiers.where((tier) => tier.stock > 0).toList();
    final source = available.isEmpty ? tiers : available;
    source.sort((a, b) => a.effectiveFinalPrice.compareTo(b.effectiveFinalPrice));
    return source.first;
  }

  double get displayPrice => startingTier?.effectiveFinalPrice ?? 0;

  double get finalPrice => displayPrice;

  double? get discountPrice => startingTier?.discountPrice;

  double? get price => startingTier?.price;

  double? get displayOriginalPrice => startingTier?.hasDiscount == true
      ? startingTier!.price
      : null;

  String? get categoryName => category?.name;

  /// Normalisasi daftar media dari API menjadi list map dengan key `url`.
  /// Menangani array object ({original_url/url}), array string URL, dan
  /// field `images` sebagai alternatif.
  static List<Map<String, dynamic>>? _normalizeMedia(
    Map<String, dynamic> json,
  ) {
    final urls = Formatters.itemMediaUrls(json);
    if (urls.isEmpty) return null;
    return urls.map((u) => {'url': u}).toList();
  }

  /// Normalisasi `gallery_urls` dari API. Backend mengirim
  /// `{id, url, thumb, collection, order}` per foto; `thumb` adalah varian
  /// WebP kecil (~320px) yang dipakai untuk strip thumbnail, sedangkan `url`
  /// (~1024px) untuk hero. Semua URL dinormalisasi lewat [Formatters.imageUrl].
  static List<Map<String, dynamic>>? _normalizeGallery(
    Map<String, dynamic> json,
  ) {
    final raw = json['gallery_urls'];
    if (raw is! List || raw.isEmpty) return null;
    final gallery = <Map<String, dynamic>>[];
    for (final entry in raw) {
      if (entry is! Map) continue;
      final map = Map<String, dynamic>.from(entry);
      final url = Formatters.imageUrl(map['url'] as String?);
      if (url.isEmpty) continue;
      final thumb = Formatters.imageUrl(map['thumb'] as String?);
      gallery.add({
        'id': map['id'],
        'url': url,
        'thumb': thumb.isNotEmpty ? thumb : url,
        'collection': map['collection'],
        'order': map['order'],
      });
    }
    if (gallery.isEmpty) return null;
    gallery.sort((a, b) {
      final ao = a['order'];
      final bo = b['order'];
      if (ao is num && bo is num) return ao.compareTo(bo);
      return 0;
    });
    return gallery;
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: parseInt(json['id']),
      categoryId: parseIntNullable(json['category_id']),
      name: (json['name'] ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      description: json['description'] as String?,
      stock: parseInt(json['stock'] ?? json['stock_count'] ?? 0),
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      features: json['features'] != null
          ? (json['features'] as List).cast<String>()
          : null,
      theme: json['theme'] as String?,
      color: json['color'] as String?,
      minCapacity: parseIntNullable(json['min_capacity']),
      maxCapacity: parseIntNullable(json['max_capacity']),
      imageUrl: (json['image'] ?? json['image_url']) != null
          ? Formatters.imageUrl((json['image'] ?? json['image_url']) as String)
          : null,
      // Thumbnail kecil (~320px WebP). Kalau backend belum mengirimnya,
      // fallback ke gambar utama supaya kartu grid tidak pernah kosong.
      thumbnailUrl: json['thumbnail_url'] != null
          ? Formatters.imageUrl(json['thumbnail_url'] as String?)
          : null,
      videoUrl: json['video_url'] as String?,
      media: _normalizeMedia(json),
      galleryUrls: _normalizeGallery(json),
      averageRating: parseDouble(json['average_rating']),
      isFavoriteed: json['is_Favoriteed'] as bool? ?? false,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
                .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      tiers: json['tiers'] is List
          ? (json['tiers'] as List)
                .whereType<Map>()
                .map((e) => TierModel.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : const [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_id': categoryId,
    'name': name,
    'slug': slug,
    'description': description,
    'stock': stock,
    'is_active': isActive,
    'is_featured': isFeatured,
    'features': features,
    'theme': theme,
    'color': color,
    'min_capacity': minCapacity,
    'max_capacity': maxCapacity,
    'image_url': imageUrl,
    'thumbnail_url': thumbnailUrl,
    'video_url': videoUrl,
    'is_Favoriteed': isFavoriteed,
    'category': category?.toJson(),
    'created_at': createdAt,
    'updated_at': updatedAt,
    'tiers': tiers.map((tier) => tier.toJson()).toList(),
  };
}
