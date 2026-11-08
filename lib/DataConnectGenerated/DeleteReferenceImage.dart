part of 'generated.dart';

class DeleteReferenceImageVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteReferenceImageVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<DeleteReferenceImageData> dataDeserializer = (dynamic json) =>
      DeleteReferenceImageData.fromJson(jsonDecode(json));
  Serializer<DeleteReferenceImageVariables> varsSerializer =
      (DeleteReferenceImageVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<DeleteReferenceImageData, DeleteReferenceImageVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<DeleteReferenceImageData, DeleteReferenceImageVariables> ref() {
    DeleteReferenceImageVariables vars = DeleteReferenceImageVariables(id: id);
    return _dataConnect.mutation(
      "DeleteReferenceImage",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteReferenceImageReferenceImageDelete {
  final String id;
  DeleteReferenceImageReferenceImageDelete.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteReferenceImageReferenceImageDelete otherTyped =
        other as DeleteReferenceImageReferenceImageDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteReferenceImageReferenceImageDelete({required this.id});
}

@immutable
class DeleteReferenceImageData {
  final DeleteReferenceImageReferenceImageDelete? referenceImage_delete;
  DeleteReferenceImageData.fromJson(dynamic json)
    : referenceImage_delete = json['referenceImage_delete'] == null
          ? null
          : DeleteReferenceImageReferenceImageDelete.fromJson(
              json['referenceImage_delete'],
            );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteReferenceImageData otherTyped =
        other as DeleteReferenceImageData;
    return referenceImage_delete == otherTyped.referenceImage_delete;
  }

  @override
  int get hashCode => referenceImage_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (referenceImage_delete != null) {
      json['referenceImage_delete'] = referenceImage_delete!.toJson();
    }
    return json;
  }

  DeleteReferenceImageData({this.referenceImage_delete});
}

@immutable
class DeleteReferenceImageVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteReferenceImageVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteReferenceImageVariables otherTyped =
        other as DeleteReferenceImageVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteReferenceImageVariables({required this.id});
}
