part of 'generated.dart';

class ListFlowerItemsVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListFlowerItemsVariablesBuilder(this._dataConnect);
  Deserializer<ListFlowerItemsData> dataDeserializer = (dynamic json) =>
      ListFlowerItemsData.fromJson(jsonDecode(json));

  Future<QueryResult<ListFlowerItemsData, void>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListFlowerItemsData, void> ref() {
    return _dataConnect.query(
      "ListFlowerItems",
      dataDeserializer,
      emptySerializer,
      null,
    );
  }
}

@immutable
class ListFlowerItemsFlowerItems {
  final String name;
  final String color;
  ListFlowerItemsFlowerItems.fromJson(dynamic json)
    : name = nativeFromJson<String>(json['name']),
      color = nativeFromJson<String>(json['color']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListFlowerItemsFlowerItems otherTyped =
        other as ListFlowerItemsFlowerItems;
    return name == otherTyped.name && color == otherTyped.color;
  }

  @override
  int get hashCode => Object.hashAll([name.hashCode, color.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['color'] = nativeToJson<String>(color);
    return json;
  }

  ListFlowerItemsFlowerItems({required this.name, required this.color});
}

@immutable
class ListFlowerItemsData {
  final List<ListFlowerItemsFlowerItems> flowerItems;
  ListFlowerItemsData.fromJson(dynamic json)
    : flowerItems = (json['flowerItems'] as List<dynamic>)
          .map((e) => ListFlowerItemsFlowerItems.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListFlowerItemsData otherTyped = other as ListFlowerItemsData;
    return flowerItems == otherTyped.flowerItems;
  }

  @override
  int get hashCode => flowerItems.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['flowerItems'] = flowerItems.map((e) => e.toJson()).toList();
    return json;
  }

  ListFlowerItemsData({required this.flowerItems});
}
