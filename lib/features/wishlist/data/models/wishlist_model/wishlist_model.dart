import '../../../../catalog/data/models/item_model/item_model.dart';

class WishlistModel {
  final int id;
  final String? resourceType;
  final int? catalogId;
  final ItemModel? item;
  final String? createdAt;

  const WishlistModel({
    required this.id,
    this.resourceType,
    this.catalogId,
    this.item,
    this.createdAt,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    ItemModel? parseItem(Map<String, dynamic> j) {
      if (j.containsKey('name') || j.containsKey('price')) {
        return ItemModel.fromJson(j);
      }
      return null;
    }

    final itemData =
        json['item'] as Map<String, dynamic>? ??
        (json.containsKey('name') ? json : null);

    return WishlistModel(
      id: json['id'] as int,
      resourceType: json['resource_type'] as String?,
      catalogId: json['catalog_id'] as int?,
      item: itemData != null ? parseItem(itemData) : null,
      createdAt: json['created_at'] as String?,
    );
  }
}
