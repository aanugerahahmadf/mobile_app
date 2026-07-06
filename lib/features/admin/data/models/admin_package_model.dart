class AdminPackageModel {
  final int id;
  final int? categoryId;
  final String? categoryName;
  final String name;
  final String? description;
  final double price;
  final double? discountPrice;
  final int stock;
  final bool isActive;
  final String? imageUrl;
  final String? createdAt;

  const AdminPackageModel({
    required this.id,
    this.categoryId,
    this.categoryName,
    required this.name,
    this.description,
    required this.price,
    this.discountPrice,
    this.stock = 0,
    this.isActive = true,
    this.imageUrl,
    this.createdAt,
  });

  factory AdminPackageModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }
    bool toBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v == 1;
      return false;
    }
    return AdminPackageModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      categoryId: json['category_id'] is int ? json['category_id'] as int : int.tryParse('${json['category_id'] ?? ''}'),
      categoryName: json['category'] is Map ? '${json['category']['name']}' : json['category_name'] as String?,
      name: '${json['name'] ?? ''}',
      description: json['description'] as String?,
      price: toDouble(json['price']),
      discountPrice: json['discount_price'] != null ? toDouble(json['discount_price']) : null,
      stock: json['stock'] is int ? json['stock'] as int : int.tryParse('${json['stock'] ?? '0'}') ?? 0,
      isActive: toBool(json['is_active']),
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_id': categoryId,
    'name': name,
    'description': description,
    'price': price,
    'discount_price': discountPrice,
    'stock': stock,
    'is_active': isActive,
    'image_url': imageUrl,
    'created_at': createdAt,
  };

  AdminPackageModel copyWith({
    int? id,
    int? categoryId,
    String? categoryName,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    int? stock,
    bool? isActive,
    String? imageUrl,
    String? createdAt,
  }) => AdminPackageModel(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    discountPrice: discountPrice ?? this.discountPrice,
    stock: stock ?? this.stock,
    isActive: isActive ?? this.isActive,
    imageUrl: imageUrl ?? this.imageUrl,
    createdAt: createdAt ?? this.createdAt,
  );
}
