import '../../../../Catalog/Data/Models/ItemModel/ItemModel.dart';

class FavoriteModel {
  final int id;
  final String? resourceType;
  final int? catalogId;
  final ItemModel? item;
  final String? createdAt;

  const FavoriteModel({
    required this.id,
    this.resourceType,
    this.catalogId,
    this.item,
    this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    ItemModel? parseItem(Map<String, dynamic> j) {
      if (j.containsKey('name') || j.containsKey('price')) {
        return ItemModel.fromJson(j);
      }
      return null;
    }

    final itemData =
        json['item'] as Map<String, dynamic>? ??
        (json.containsKey('name') ? json : null);

    return FavoriteModel(
      id: json['id'] as int,
      resourceType: json['resource_type'] as String?,
      catalogId: json['catalog_id'] as int?,
      item: itemData != null ? parseItem(itemData) : null,
      createdAt: json['created_at'] as String?,
    );
  }
}
