part of 'generated.dart';

class InsertArrangementVariablesBuilder {
  String name;
  String type;
  String status;
  String weddingId;

  final FirebaseDataConnect _dataConnect;
  InsertArrangementVariablesBuilder(
    this._dataConnect, {
    required this.name,
    required this.type,
    required this.status,
    required this.weddingId,
  });
  Deserializer<InsertArrangementData> dataDeserializer = (dynamic json) =>
      InsertArrangementData.fromJson(jsonDecode(json));
  Serializer<InsertArrangementVariables> varsSerializer =
      (InsertArrangementVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<InsertArrangementData, InsertArrangementVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<InsertArrangementData, InsertArrangementVariables> ref() {
    InsertArrangementVariables vars = InsertArrangementVariables(
      name: name,
      type: type,
      status: status,
      weddingId: weddingId,
    );
    return _dataConnect.mutation(
      "InsertArrangement",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class InsertArrangementArrangementInsert {
  final String id;
  InsertArrangementArrangementInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertArrangementArrangementInsert otherTyped =
        other as InsertArrangementArrangementInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  InsertArrangementArrangementInsert({required this.id});
}

@immutable
class InsertArrangementData {
  final InsertArrangementArrangementInsert arrangement_insert;
  InsertArrangementData.fromJson(dynamic json)
    : arrangement_insert = InsertArrangementArrangementInsert.fromJson(
        json['arrangement_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertArrangementData otherTyped = other as InsertArrangementData;
    return arrangement_insert == otherTyped.arrangement_insert;
  }

  @override
  int get hashCode => arrangement_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['arrangement_insert'] = arrangement_insert.toJson();
    return json;
  }

  InsertArrangementData({required this.arrangement_insert});
}

@immutable
class InsertArrangementVariables {
  final String name;
  final String type;
  final String status;
  final String weddingId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  InsertArrangementVariables.fromJson(Map<String, dynamic> json)
    : name = nativeFromJson<String>(json['name']),
      type = nativeFromJson<String>(json['type']),
      status = nativeFromJson<String>(json['status']),
      weddingId = nativeFromJson<String>(json['weddingId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertArrangementVariables otherTyped =
        other as InsertArrangementVariables;
    return name == otherTyped.name &&
        type == otherTyped.type &&
        status == otherTyped.status &&
        weddingId == otherTyped.weddingId;
  }

  @override
  int get hashCode => Object.hashAll([
    name.hashCode,
    type.hashCode,
    status.hashCode,
    weddingId.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['type'] = nativeToJson<String>(type);
    json['status'] = nativeToJson<String>(status);
    json['weddingId'] = nativeToJson<String>(weddingId);
    return json;
  }

  InsertArrangementVariables({
    required this.name,
    required this.type,
    required this.status,
    required this.weddingId,
  });
}
