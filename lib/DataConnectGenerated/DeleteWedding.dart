part of 'generated.dart';

class DeleteWeddingVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteWeddingVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<DeleteWeddingData> dataDeserializer = (dynamic json) =>
      DeleteWeddingData.fromJson(jsonDecode(json));
  Serializer<DeleteWeddingVariables> varsSerializer =
      (DeleteWeddingVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteWeddingData, DeleteWeddingVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteWeddingData, DeleteWeddingVariables> ref() {
    DeleteWeddingVariables vars = DeleteWeddingVariables(id: id);
    return _dataConnect.mutation(
      "DeleteWedding",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteWeddingWeddingDelete {
  final String id;
  DeleteWeddingWeddingDelete.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteWeddingWeddingDelete otherTyped =
        other as DeleteWeddingWeddingDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteWeddingWeddingDelete({required this.id});
}

@immutable
class DeleteWeddingData {
  final DeleteWeddingWeddingDelete? wedding_delete;
  DeleteWeddingData.fromJson(dynamic json)
    : wedding_delete = json['wedding_delete'] == null
          ? null
          : DeleteWeddingWeddingDelete.fromJson(json['wedding_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteWeddingData otherTyped = other as DeleteWeddingData;
    return wedding_delete == otherTyped.wedding_delete;
  }

  @override
  int get hashCode => wedding_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (wedding_delete != null) {
      json['wedding_delete'] = wedding_delete!.toJson();
    }
    return json;
  }

  DeleteWeddingData({this.wedding_delete});
}

@immutable
class DeleteWeddingVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteWeddingVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteWeddingVariables otherTyped = other as DeleteWeddingVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteWeddingVariables({required this.id});
}
