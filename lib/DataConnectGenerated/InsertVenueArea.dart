part of 'generated.dart';

class InsertVenueAreaVariablesBuilder {
  String name;
  String weddingId;

  final FirebaseDataConnect _dataConnect;
  InsertVenueAreaVariablesBuilder(
    this._dataConnect, {
    required this.name,
    required this.weddingId,
  });
  Deserializer<InsertVenueAreaData> dataDeserializer = (dynamic json) =>
      InsertVenueAreaData.fromJson(jsonDecode(json));
  Serializer<InsertVenueAreaVariables> varsSerializer =
      (InsertVenueAreaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<InsertVenueAreaData, InsertVenueAreaVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<InsertVenueAreaData, InsertVenueAreaVariables> ref() {
    InsertVenueAreaVariables vars = InsertVenueAreaVariables(
      name: name,
      weddingId: weddingId,
    );
    return _dataConnect.mutation(
      "InsertVenueArea",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class InsertVenueAreaVenueAreaInsert {
  final String id;
  InsertVenueAreaVenueAreaInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertVenueAreaVenueAreaInsert otherTyped =
        other as InsertVenueAreaVenueAreaInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  InsertVenueAreaVenueAreaInsert({required this.id});
}

@immutable
class InsertVenueAreaData {
  final InsertVenueAreaVenueAreaInsert venueArea_insert;
  InsertVenueAreaData.fromJson(dynamic json)
    : venueArea_insert = InsertVenueAreaVenueAreaInsert.fromJson(
        json['venueArea_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertVenueAreaData otherTyped = other as InsertVenueAreaData;
    return venueArea_insert == otherTyped.venueArea_insert;
  }

  @override
  int get hashCode => venueArea_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['venueArea_insert'] = venueArea_insert.toJson();
    return json;
  }

  InsertVenueAreaData({required this.venueArea_insert});
}

@immutable
class InsertVenueAreaVariables {
  final String name;
  final String weddingId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  InsertVenueAreaVariables.fromJson(Map<String, dynamic> json)
    : name = nativeFromJson<String>(json['name']),
      weddingId = nativeFromJson<String>(json['weddingId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertVenueAreaVariables otherTyped =
        other as InsertVenueAreaVariables;
    return name == otherTyped.name && weddingId == otherTyped.weddingId;
  }

  @override
  int get hashCode => Object.hashAll([name.hashCode, weddingId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['weddingId'] = nativeToJson<String>(weddingId);
    return json;
  }

  InsertVenueAreaVariables({required this.name, required this.weddingId});
}
