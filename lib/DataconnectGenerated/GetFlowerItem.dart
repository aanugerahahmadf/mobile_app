part of 'generated.dart';

class GetFlowerItemVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetFlowerItemVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetFlowerItemData> dataDeserializer = (dynamic json) =>
      GetFlowerItemData.fromJson(jsonDecode(json));
  Serializer<GetFlowerItemVariables> varsSerializer =
      (GetFlowerItemVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetFlowerItemData, GetFlowerItemVariables>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetFlowerItemData, GetFlowerItemVariables> ref() {
    GetFlowerItemVariables vars = GetFlowerItemVariables(id: id);
    return _dataConnect.query(
      "GetFlowerItem",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetFlowerItemFlowerItem {
  final String name;
  final String color;
  final double? costPerStem;
  GetFlowerItemFlowerItem.fromJson(dynamic json)
    : name = nativeFromJson<String>(json['name']),
      color = nativeFromJson<String>(json['color']),
      costPerStem = json['costPerStem'] == null
          ? null
          : nativeFromJson<double>(json['costPerStem']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetFlowerItemFlowerItem otherTyped = other as GetFlowerItemFlowerItem;
    return name == otherTyped.name &&
        color == otherTyped.color &&
        costPerStem == otherTyped.costPerStem;
  }

  @override
  int get hashCode =>
      Object.hashAll([name.hashCode, color.hashCode, costPerStem.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['color'] = nativeToJson<String>(color);
    if (costPerStem != null) {
      json['costPerStem'] = nativeToJson<double?>(costPerStem);
    }
    return json;
  }

  GetFlowerItemFlowerItem({
    required this.name,
    required this.color,
    this.costPerStem,
  });
}

@immutable
class GetFlowerItemData {
  final GetFlowerItemFlowerItem? flowerItem;
  GetFlowerItemData.fromJson(dynamic json)
    : flowerItem = json['flowerItem'] == null
          ? null
          : GetFlowerItemFlowerItem.fromJson(json['flowerItem']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetFlowerItemData otherTyped = other as GetFlowerItemData;
    return flowerItem == otherTyped.flowerItem;
  }

  @override
  int get hashCode => flowerItem.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (flowerItem != null) {
      json['flowerItem'] = flowerItem!.toJson();
    }
    return json;
  }

  GetFlowerItemData({this.flowerItem});
}

@immutable
class GetFlowerItemVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetFlowerItemVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetFlowerItemVariables otherTyped = other as GetFlowerItemVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetFlowerItemVariables({required this.id});
}
