class AdminCategoryModel {
  final int id;
  final String name;
  final String? slug;
  final String? icon;
  final String? color;
  final String? description;
  final String? type;
  final int packagesCount;
  final int productsCount;
  final String? createdAt;

  const AdminCategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.icon,
    this.color,
    this.description,
    this.type,
    this.packagesCount = 0,
    this.productsCount = 0,
    this.createdAt,
  });

  factory AdminCategoryModel.fromJson(Map<String, dynamic> json) {
    return AdminCategoryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: '${json['name'] ?? ''}',
      slug: json['slug'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      packagesCount: json['category_packages_count'] is int ? json['category_packages_count'] as int : int.tryParse('${json['category_packages_count'] ?? '0'}') ?? 0,
      productsCount: json['category_products_count'] is int ? json['category_products_count'] as int : int.tryParse('${json['category_products_count'] ?? '0'}') ?? 0,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'icon': icon,
    'color': color,
    'description': description,
    'type': type,
    'category_packages_count': packagesCount,
    'category_products_count': productsCount,
    'created_at': createdAt,
  };

  AdminCategoryModel copyWith({
    int? id, String? name, String? slug, String? icon, String? color,
    String? description, String? type, int? packagesCount, int? productsCount, String? createdAt,
  }) => AdminCategoryModel(
    id: id ?? this.id, name: name ?? this.name, slug: slug ?? this.slug,
    icon: icon ?? this.icon, color: color ?? this.color,
    description: description ?? this.description,
    type: type ?? this.type,
    packagesCount: packagesCount ?? this.packagesCount,
    productsCount: productsCount ?? this.productsCount,
    createdAt: createdAt ?? this.createdAt,
  );
}
