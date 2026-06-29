import '../../../../core/utils/number_utils.dart';
import '../../../../core/utils/formatters.dart';
import 'category_model.dart';
import 'review_model.dart';

class ItemModel {
  final int id;
  final int? categoryId;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? discountPrice;
  final int stock;
  final bool isActive;
  final bool isFeatured;
  final List<String>? features;
  final String? theme;
  final String? color;
  final int? minCapacity;
  final int? maxCapacity;
  final String? imageUrl;
  final String? videoUrl;
  final List<dynamic>? media;
  final double finalPrice;
  final double averageRating;
  final bool isWishlisted;
  final CategoryModel? category;
  final List<ReviewModel>? reviews;
  final String? weddingFlowersDecorasiId;
  final Map<String, dynamic>? weddingFlowersDecorasi;
  final String? createdAt;
  final String? updatedAt;

  const ItemModel({
    required this.id,
    this.categoryId,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.discountPrice,
    this.stock = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.features,
    this.theme,
    this.color,
    this.minCapacity,
    this.maxCapacity,
    this.imageUrl,
    this.videoUrl,
    this.media,
    this.finalPrice = 0,
    this.averageRating = 0,
    this.isWishlisted = false,
    this.category,
    this.reviews,
    this.weddingFlowersDecorasiId,
    this.weddingFlowersDecorasi,
    this.createdAt,
    this.updatedAt,
  });

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  String? get categoryName => category?.name;

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: parseInt(json['id']),
      categoryId: parseIntNullable(json['category_id']),
      name: (json['name'] ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      description: json['description'] as String?,
      price: parseDouble(json['price']),
      discountPrice: json['discount_price'] != null ? parseDouble(json['discount_price']) : null,
      stock: parseInt(json['stock'] ?? json['stock_count'] ?? 0),
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      features: json['features'] != null ? (json['features'] as List).cast<String>() : null,
      theme: json['theme'] as String?,
      color: json['color'] as String?,
      minCapacity: parseIntNullable(json['min_capacity']),
      maxCapacity: parseIntNullable(json['max_capacity']),
      imageUrl: (json['image'] ?? json['image_url']) != null ? Formatters.imageUrl((json['image'] ?? json['image_url']) as String) : null,
      videoUrl: json['video_url'] as String?,
      media: json['media'] != null
          ? (json['media'] as List).map((m) {
              if (m is Map) {
                final map = Map<String, dynamic>.from(m);
                // API returns original_url, not url
                final src = (map['original_url'] as String?)?.isNotEmpty == true
                    ? map['original_url'] as String
                    : (map['url'] as String? ?? '');
                map['url'] = Formatters.imageUrl(src);
                return map;
              }
              return m;
            }).toList()
          : null,
      finalPrice: parseDouble(json['final_price'] ?? json['price']),
      averageRating: parseDouble(json['average_rating']),
      isWishlisted: json['is_wishlisted'] as bool? ?? false,
      category: json['category'] != null ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>) : null,
      reviews: json['reviews'] != null ? (json['reviews'] as List).map((e) => ReviewModel.fromJson(e as Map<String, dynamic>)).toList() : null,
      weddingFlowersDecorasiId: json['wedding_flowers_decorasi_id'] as String?,
      weddingFlowersDecorasi: json['wedding_flowers_decorasi'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'category_id': categoryId, 'name': name, 'slug': slug,
    'description': description, 'price': price, 'discount_price': discountPrice,
    'stock': stock, 'is_active': isActive, 'is_featured': isFeatured,
    'features': features, 'theme': theme, 'color': color,
    'min_capacity': minCapacity, 'max_capacity': maxCapacity,
    'image_url': imageUrl, 'video_url': videoUrl, 'final_price': finalPrice,
    'is_wishlisted': isWishlisted,
    'category': category?.toJson(),
    'wedding_flowers_decorasi_id': weddingFlowersDecorasiId,
    'wedding_flowers_decorasi': weddingFlowersDecorasi,
    'created_at': createdAt, 'updated_at': updatedAt,
  };
}
