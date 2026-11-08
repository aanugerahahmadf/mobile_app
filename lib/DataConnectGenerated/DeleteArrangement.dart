part of 'generated.dart';

class DeleteArrangementVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteArrangementVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<DeleteArrangementData> dataDeserializer = (dynamic json) =>
      DeleteArrangementData.fromJson(jsonDecode(json));
  Serializer<DeleteArrangementVariables> varsSerializer =
      (DeleteArrangementVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteArrangementData, DeleteArrangementVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<DeleteArrangementData, DeleteArrangementVariables> ref() {
    DeleteArrangementVariables vars = DeleteArrangementVariables(id: id);
    return _dataConnect.mutation(
      "DeleteArrangement",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteArrangementArrangementDelete {
  final String id;
  DeleteArrangementArrangementDelete.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteArrangementArrangementDelete otherTyped =
        other as DeleteArrangementArrangementDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteArrangementArrangementDelete({required this.id});
}

@immutable
class DeleteArrangementData {
  final DeleteArrangementArrangementDelete? arrangement_delete;
  DeleteArrangementData.fromJson(dynamic json)
    : arrangement_delete = json['arrangement_delete'] == null
          ? null
          : DeleteArrangementArrangementDelete.fromJson(
              json['arrangement_delete'],
            );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteArrangementData otherTyped = other as DeleteArrangementData;
    return arrangement_delete == otherTyped.arrangement_delete;
  }

  @override
  int get hashCode => arrangement_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (arrangement_delete != null) {
      json['arrangement_delete'] = arrangement_delete!.toJson();
    }
    return json;
  }

  DeleteArrangementData({this.arrangement_delete});
}

@immutable
class DeleteArrangementVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteArrangementVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteArrangementVariables otherTyped =
        other as DeleteArrangementVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteArrangementVariables({required this.id});
}
