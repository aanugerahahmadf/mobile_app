import '../../../../../core/utils/number_utils/number_utils.dart';
import '../../../../../core/utils/formatters/formatters.dart';

/// Varian/tier dari satu entitas katalog.
///
/// Backend mengirim tier di dalam `tiers` pada respons detail catalog
/// (`GET /api/catalog/{id}`) maupun dedicated `GET /api/catalog/{id}/tiers`.
class TierModel {
  final int id;
  final int? catalogId;
  final String name;
  final String? description;
  final double price;
  final double? discountPrice;
  final double finalPrice;
  final int stock;
  final List<String>? features;
  final int sortOrder;
  final String? imageUrl;

  const TierModel({
    required this.id,
    this.catalogId,
    required this.name,
    this.description,
    required this.price,
    this.discountPrice,
    this.finalPrice = 0,
    this.stock = 0,
    this.features,
    this.sortOrder = 0,
    this.imageUrl,
  });

  bool get hasDiscount =>
      discountPrice != null && discountPrice! > 0 && discountPrice! < price;

  /// The amount the customer actually pays. APIs may omit `final_price`; in
  /// that case derive it from the tier's sale price, then its regular price.
  double get effectiveFinalPrice =>
      finalPrice > 0 ? finalPrice : (hasDiscount ? discountPrice! : price);

  factory TierModel.fromJson(Map<String, dynamic> json) {
    final rawFeatures = json['features'];
    return TierModel(
      id: parseInt(json['id']),
      catalogId: parseIntNullable(json['catalog_id'] ?? json['catalogId']),
      name: (json['name'] ?? '') as String,
      description: json['description'] as String?,
      price: parseDouble(json['price']),
      discountPrice: (json['discount_price'] ?? json['discountPrice']) != null
          ? parseDouble(json['discount_price'] ?? json['discountPrice'])
          : null,
      finalPrice: parseDouble(
        json['final_price'] ?? json['finalPrice'] ?? json['discount_price'] ??
            json['discountPrice'] ?? json['price'],
      ),
      stock: parseInt(json['stock'] ?? 0),
      features: rawFeatures is List
          ? rawFeatures.map((e) => '$e').toList()
          : null,
      sortOrder: parseInt(json['sort_order'] ?? json['sortOrder'] ?? 0),
      imageUrl: (json['image_url'] ?? json['imageUrl']) != null
          ? Formatters.imageUrl(
              (json['image_url'] ?? json['imageUrl']) as String?,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'catalog_id': catalogId,
    'name': name,
    'description': description,
    'price': price,
    'discount_price': discountPrice,
    'final_price': finalPrice,
    'stock': stock,
    'features': features,
    'sort_order': sortOrder,
    'image_url': imageUrl,
  };
}
