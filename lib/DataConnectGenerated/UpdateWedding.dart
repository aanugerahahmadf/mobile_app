part of 'generated.dart';

class UpdateWeddingVariablesBuilder {
  String id;
  Optional<String> _title = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  UpdateWeddingVariablesBuilder title(String? t) {
    _title.value = t;
    return this;
  }

  UpdateWeddingVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<UpdateWeddingData> dataDeserializer = (dynamic json) =>
      UpdateWeddingData.fromJson(jsonDecode(json));
  Serializer<UpdateWeddingVariables> varsSerializer =
      (UpdateWeddingVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateWeddingData, UpdateWeddingVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateWeddingData, UpdateWeddingVariables> ref() {
    UpdateWeddingVariables vars = UpdateWeddingVariables(id: id, title: _title);
    return _dataConnect.mutation(
      "UpdateWedding",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateWeddingWeddingUpdate {
  final String id;
  UpdateWeddingWeddingUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateWeddingWeddingUpdate otherTyped =
        other as UpdateWeddingWeddingUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateWeddingWeddingUpdate({required this.id});
}

@immutable
class UpdateWeddingData {
  final UpdateWeddingWeddingUpdate? wedding_update;
  UpdateWeddingData.fromJson(dynamic json)
    : wedding_update = json['wedding_update'] == null
          ? null
          : UpdateWeddingWeddingUpdate.fromJson(json['wedding_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateWeddingData otherTyped = other as UpdateWeddingData;
    return wedding_update == otherTyped.wedding_update;
  }

  @override
  int get hashCode => wedding_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (wedding_update != null) {
      json['wedding_update'] = wedding_update!.toJson();
    }
    return json;
  }

  UpdateWeddingData({this.wedding_update});
}

@immutable
class UpdateWeddingVariables {
  final String id;
  late final Optional<String> title;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateWeddingVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']) {
    title = Optional.optional(nativeFromJson, nativeToJson);
    title.value = json['title'] == null
        ? null
        : nativeFromJson<String>(json['title']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateWeddingVariables otherTyped = other as UpdateWeddingVariables;
    return id == otherTyped.id && title == otherTyped.title;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (title.state == OptionalState.set) {
      json['title'] = title.toJson();
    }
    return json;
  }

  UpdateWeddingVariables({required this.id, required this.title});
}
