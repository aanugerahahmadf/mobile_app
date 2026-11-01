part of 'generated.dart';

class UpdateReferenceImageVariablesBuilder {
  String id;
  Optional<String> _description = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  UpdateReferenceImageVariablesBuilder description(String? t) {
    _description.value = t;
    return this;
  }

  UpdateReferenceImageVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<UpdateReferenceImageData> dataDeserializer = (dynamic json) =>
      UpdateReferenceImageData.fromJson(jsonDecode(json));
  Serializer<UpdateReferenceImageVariables> varsSerializer =
      (UpdateReferenceImageVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<UpdateReferenceImageData, UpdateReferenceImageVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateReferenceImageData, UpdateReferenceImageVariables> ref() {
    UpdateReferenceImageVariables vars = UpdateReferenceImageVariables(
      id: id,
      description: _description,
    );
    return _dataConnect.mutation(
      "UpdateReferenceImage",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateReferenceImageReferenceImageUpdate {
  final String id;
  UpdateReferenceImageReferenceImageUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateReferenceImageReferenceImageUpdate otherTyped =
        other as UpdateReferenceImageReferenceImageUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateReferenceImageReferenceImageUpdate({required this.id});
}

@immutable
class UpdateReferenceImageData {
  final UpdateReferenceImageReferenceImageUpdate? referenceImage_update;
  UpdateReferenceImageData.fromJson(dynamic json)
    : referenceImage_update = json['referenceImage_update'] == null
          ? null
          : UpdateReferenceImageReferenceImageUpdate.fromJson(
              json['referenceImage_update'],
            );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateReferenceImageData otherTyped =
        other as UpdateReferenceImageData;
    return referenceImage_update == otherTyped.referenceImage_update;
  }

  @override
  int get hashCode => referenceImage_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (referenceImage_update != null) {
      json['referenceImage_update'] = referenceImage_update!.toJson();
    }
    return json;
  }

  UpdateReferenceImageData({this.referenceImage_update});
}

@immutable
class UpdateReferenceImageVariables {
  final String id;
  late final Optional<String> description;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateReferenceImageVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']) {
    description = Optional.optional(nativeFromJson, nativeToJson);
    description.value = json['description'] == null
        ? null
        : nativeFromJson<String>(json['description']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateReferenceImageVariables otherTyped =
        other as UpdateReferenceImageVariables;
    return id == otherTyped.id && description == otherTyped.description;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, description.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    return json;
  }

  UpdateReferenceImageVariables({required this.id, required this.description});
}
