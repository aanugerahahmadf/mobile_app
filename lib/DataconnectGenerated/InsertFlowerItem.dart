part of 'generated.dart';

class InsertFlowerItemVariablesBuilder {
  String name;
  String color;
  String arrangementId;

  final FirebaseDataConnect _dataConnect;
  InsertFlowerItemVariablesBuilder(
    this._dataConnect, {
    required this.name,
    required this.color,
    required this.arrangementId,
  });
  Deserializer<InsertFlowerItemData> dataDeserializer = (dynamic json) =>
      InsertFlowerItemData.fromJson(jsonDecode(json));
  Serializer<InsertFlowerItemVariables> varsSerializer =
      (InsertFlowerItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<InsertFlowerItemData, InsertFlowerItemVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<InsertFlowerItemData, InsertFlowerItemVariables> ref() {
    InsertFlowerItemVariables vars = InsertFlowerItemVariables(
      name: name,
      color: color,
      arrangementId: arrangementId,
    );
    return _dataConnect.mutation(
      "InsertFlowerItem",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class InsertFlowerItemFlowerItemInsert {
  final String id;
  InsertFlowerItemFlowerItemInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertFlowerItemFlowerItemInsert otherTyped =
        other as InsertFlowerItemFlowerItemInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  InsertFlowerItemFlowerItemInsert({required this.id});
}

@immutable
class InsertFlowerItemData {
  final InsertFlowerItemFlowerItemInsert flowerItem_insert;
  InsertFlowerItemData.fromJson(dynamic json)
    : flowerItem_insert = InsertFlowerItemFlowerItemInsert.fromJson(
        json['flowerItem_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertFlowerItemData otherTyped = other as InsertFlowerItemData;
    return flowerItem_insert == otherTyped.flowerItem_insert;
  }

  @override
  int get hashCode => flowerItem_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['flowerItem_insert'] = flowerItem_insert.toJson();
    return json;
  }

  InsertFlowerItemData({required this.flowerItem_insert});
}

@immutable
class InsertFlowerItemVariables {
  final String name;
  final String color;
  final String arrangementId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  InsertFlowerItemVariables.fromJson(Map<String, dynamic> json)
    : name = nativeFromJson<String>(json['name']),
      color = nativeFromJson<String>(json['color']),
      arrangementId = nativeFromJson<String>(json['arrangementId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertFlowerItemVariables otherTyped =
        other as InsertFlowerItemVariables;
    return name == otherTyped.name &&
        color == otherTyped.color &&
        arrangementId == otherTyped.arrangementId;
  }

  @override
  int get hashCode =>
      Object.hashAll([name.hashCode, color.hashCode, arrangementId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['color'] = nativeToJson<String>(color);
    json['arrangementId'] = nativeToJson<String>(arrangementId);
    return json;
  }

  InsertFlowerItemVariables({
    required this.name,
    required this.color,
    required this.arrangementId,
  });
}
