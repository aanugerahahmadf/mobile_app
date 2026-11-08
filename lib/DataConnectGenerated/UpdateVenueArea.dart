part of 'generated.dart';

class UpdateVenueAreaVariablesBuilder {
  String id;
  Optional<String> _name = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  UpdateVenueAreaVariablesBuilder name(String? t) {
    _name.value = t;
    return this;
  }

  UpdateVenueAreaVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<UpdateVenueAreaData> dataDeserializer = (dynamic json) =>
      UpdateVenueAreaData.fromJson(jsonDecode(json));
  Serializer<UpdateVenueAreaVariables> varsSerializer =
      (UpdateVenueAreaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateVenueAreaData, UpdateVenueAreaVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateVenueAreaData, UpdateVenueAreaVariables> ref() {
    UpdateVenueAreaVariables vars = UpdateVenueAreaVariables(
      id: id,
      name: _name,
    );
    return _dataConnect.mutation(
      "UpdateVenueArea",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateVenueAreaVenueAreaUpdate {
  final String id;
  UpdateVenueAreaVenueAreaUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateVenueAreaVenueAreaUpdate otherTyped =
        other as UpdateVenueAreaVenueAreaUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateVenueAreaVenueAreaUpdate({required this.id});
}

@immutable
class UpdateVenueAreaData {
  final UpdateVenueAreaVenueAreaUpdate? venueArea_update;
  UpdateVenueAreaData.fromJson(dynamic json)
    : venueArea_update = json['venueArea_update'] == null
          ? null
          : UpdateVenueAreaVenueAreaUpdate.fromJson(json['venueArea_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateVenueAreaData otherTyped = other as UpdateVenueAreaData;
    return venueArea_update == otherTyped.venueArea_update;
  }

  @override
  int get hashCode => venueArea_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (venueArea_update != null) {
      json['venueArea_update'] = venueArea_update!.toJson();
    }
    return json;
  }

  UpdateVenueAreaData({this.venueArea_update});
}

@immutable
class UpdateVenueAreaVariables {
  final String id;
  late final Optional<String> name;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateVenueAreaVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']) {
    name = Optional.optional(nativeFromJson, nativeToJson);
    name.value = json['name'] == null
        ? null
        : nativeFromJson<String>(json['name']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateVenueAreaVariables otherTyped =
        other as UpdateVenueAreaVariables;
    return id == otherTyped.id && name == otherTyped.name;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (name.state == OptionalState.set) {
      json['name'] = name.toJson();
    }
    return json;
  }

  UpdateVenueAreaVariables({required this.id, required this.name});
}
