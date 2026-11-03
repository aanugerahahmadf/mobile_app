part of 'generated.dart';

class UpdateArrangementVariablesBuilder {
  String id;
  Optional<double> _actualCost = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  UpdateArrangementVariablesBuilder actualCost(double? t) {
    _actualCost.value = t;
    return this;
  }

  UpdateArrangementVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<UpdateArrangementData> dataDeserializer = (dynamic json) =>
      UpdateArrangementData.fromJson(jsonDecode(json));
  Serializer<UpdateArrangementVariables> varsSerializer =
      (UpdateArrangementVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateArrangementData, UpdateArrangementVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateArrangementData, UpdateArrangementVariables> ref() {
    UpdateArrangementVariables vars = UpdateArrangementVariables(
      id: id,
      actualCost: _actualCost,
    );
    return _dataConnect.mutation(
      "UpdateArrangement",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateArrangementArrangementUpdate {
  final String id;
  UpdateArrangementArrangementUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateArrangementArrangementUpdate otherTyped =
        other as UpdateArrangementArrangementUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateArrangementArrangementUpdate({required this.id});
}

@immutable
class UpdateArrangementData {
  final UpdateArrangementArrangementUpdate? arrangement_update;
  UpdateArrangementData.fromJson(dynamic json)
    : arrangement_update = json['arrangement_update'] == null
          ? null
          : UpdateArrangementArrangementUpdate.fromJson(
              json['arrangement_update'],
            );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateArrangementData otherTyped = other as UpdateArrangementData;
    return arrangement_update == otherTyped.arrangement_update;
  }

  @override
  int get hashCode => arrangement_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (arrangement_update != null) {
      json['arrangement_update'] = arrangement_update!.toJson();
    }
    return json;
  }

  UpdateArrangementData({this.arrangement_update});
}

@immutable
class UpdateArrangementVariables {
  final String id;
  late final Optional<double> actualCost;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateArrangementVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']) {
    actualCost = Optional.optional(nativeFromJson, nativeToJson);
    actualCost.value = json['actualCost'] == null
        ? null
        : nativeFromJson<double>(json['actualCost']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateArrangementVariables otherTyped =
        other as UpdateArrangementVariables;
    return id == otherTyped.id && actualCost == otherTyped.actualCost;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, actualCost.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (actualCost.state == OptionalState.set) {
      json['actualCost'] = actualCost.toJson();
    }
    return json;
  }

  UpdateArrangementVariables({required this.id, required this.actualCost});
}
