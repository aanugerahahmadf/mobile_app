part of 'generated.dart';

class UpdateFlowerItemVariablesBuilder {
  String id;
  Optional<double> _costPerStem = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  UpdateFlowerItemVariablesBuilder costPerStem(double? t) {
    _costPerStem.value = t;
    return this;
  }

  UpdateFlowerItemVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<UpdateFlowerItemData> dataDeserializer = (dynamic json) =>
      UpdateFlowerItemData.fromJson(jsonDecode(json));
  Serializer<UpdateFlowerItemVariables> varsSerializer =
      (UpdateFlowerItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateFlowerItemData, UpdateFlowerItemVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateFlowerItemData, UpdateFlowerItemVariables> ref() {
    UpdateFlowerItemVariables vars = UpdateFlowerItemVariables(
      id: id,
      costPerStem: _costPerStem,
    );
    return _dataConnect.mutation(
      "UpdateFlowerItem",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateFlowerItemFlowerItemUpdate {
  final String id;
  UpdateFlowerItemFlowerItemUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateFlowerItemFlowerItemUpdate otherTyped =
        other as UpdateFlowerItemFlowerItemUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateFlowerItemFlowerItemUpdate({required this.id});
}

@immutable
class UpdateFlowerItemData {
  final UpdateFlowerItemFlowerItemUpdate? flowerItem_update;
  UpdateFlowerItemData.fromJson(dynamic json)
    : flowerItem_update = json['flowerItem_update'] == null
          ? null
          : UpdateFlowerItemFlowerItemUpdate.fromJson(
              json['flowerItem_update'],
            );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateFlowerItemData otherTyped = other as UpdateFlowerItemData;
    return flowerItem_update == otherTyped.flowerItem_update;
  }

  @override
  int get hashCode => flowerItem_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (flowerItem_update != null) {
      json['flowerItem_update'] = flowerItem_update!.toJson();
    }
    return json;
  }

  UpdateFlowerItemData({this.flowerItem_update});
}

@immutable
class UpdateFlowerItemVariables {
  final String id;
  late final Optional<double> costPerStem;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateFlowerItemVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']) {
    costPerStem = Optional.optional(nativeFromJson, nativeToJson);
    costPerStem.value = json['costPerStem'] == null
        ? null
        : nativeFromJson<double>(json['costPerStem']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateFlowerItemVariables otherTyped =
        other as UpdateFlowerItemVariables;
    return id == otherTyped.id && costPerStem == otherTyped.costPerStem;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, costPerStem.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (costPerStem.state == OptionalState.set) {
      json['costPerStem'] = costPerStem.toJson();
    }
    return json;
  }

  UpdateFlowerItemVariables({required this.id, required this.costPerStem});
}
