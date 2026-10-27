import '../../../../catalog/data/models/item_model/item_model.dart';

class CartModel {
  final int id;
  final int userId;
  final int? catalogId;
  final int? packageId;
  final int quantity;
  final Map<String, dynamic>? meta;
  final ItemModel? item;
  final String? createdAt;
  final String? updatedAt;

  const CartModel({
    required this.id,
    required this.userId,
    this.catalogId,
    this.packageId,
    this.quantity = 1,
    this.meta,
    this.item,
    this.createdAt,
    this.updatedAt,
  });

  double get subtotal => (item?.displayPrice ?? 0) * quantity;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int,
      userId: (json['user_id'] ?? 0) as int,
      catalogId: json['catalog_id'] as int?,
      packageId: json['package_id'] as int?,
      quantity: (json['quantity'] ?? 1) as int,
      meta: json['meta'] as Map<String, dynamic>?,
      item: json['package'] != null
          ? ItemModel.fromJson(json['package'] as Map<String, dynamic>)
          : (json['catalog'] != null
              ? ItemModel.fromJson(json['catalog'] as Map<String, dynamic>)
              : (json['item'] != null
                  ? ItemModel.fromJson(json['item'] as Map<String, dynamic>)
                  : null)),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'catalog_id': catalogId,
    'package_id': packageId,
    'quantity': quantity,
    'meta': meta,
  };
}
