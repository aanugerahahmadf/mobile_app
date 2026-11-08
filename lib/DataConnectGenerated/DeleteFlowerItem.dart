part of 'generated.dart';

class DeleteFlowerItemVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteFlowerItemVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<DeleteFlowerItemData> dataDeserializer = (dynamic json) =>
      DeleteFlowerItemData.fromJson(jsonDecode(json));
  Serializer<DeleteFlowerItemVariables> varsSerializer =
      (DeleteFlowerItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteFlowerItemData, DeleteFlowerItemVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<DeleteFlowerItemData, DeleteFlowerItemVariables> ref() {
    DeleteFlowerItemVariables vars = DeleteFlowerItemVariables(id: id);
    return _dataConnect.mutation(
      "DeleteFlowerItem",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteFlowerItemFlowerItemDelete {
  final String id;
  DeleteFlowerItemFlowerItemDelete.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteFlowerItemFlowerItemDelete otherTyped =
        other as DeleteFlowerItemFlowerItemDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteFlowerItemFlowerItemDelete({required this.id});
}

@immutable
class DeleteFlowerItemData {
  final DeleteFlowerItemFlowerItemDelete? flowerItem_delete;
  DeleteFlowerItemData.fromJson(dynamic json)
    : flowerItem_delete = json['flowerItem_delete'] == null
          ? null
          : DeleteFlowerItemFlowerItemDelete.fromJson(
              json['flowerItem_delete'],
            );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteFlowerItemData otherTyped = other as DeleteFlowerItemData;
    return flowerItem_delete == otherTyped.flowerItem_delete;
  }

  @override
  int get hashCode => flowerItem_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (flowerItem_delete != null) {
      json['flowerItem_delete'] = flowerItem_delete!.toJson();
    }
    return json;
  }

  DeleteFlowerItemData({this.flowerItem_delete});
}

@immutable
class DeleteFlowerItemVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteFlowerItemVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteFlowerItemVariables otherTyped =
        other as DeleteFlowerItemVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteFlowerItemVariables({required this.id});
}
