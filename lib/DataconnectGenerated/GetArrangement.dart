part of 'generated.dart';

class GetArrangementVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetArrangementVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetArrangementData> dataDeserializer = (dynamic json) =>
      GetArrangementData.fromJson(jsonDecode(json));
  Serializer<GetArrangementVariables> varsSerializer =
      (GetArrangementVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetArrangementData, GetArrangementVariables>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetArrangementData, GetArrangementVariables> ref() {
    GetArrangementVariables vars = GetArrangementVariables(id: id);
    return _dataConnect.query(
      "GetArrangement",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetArrangementArrangement {
  final String name;
  final String type;
  final double? actualCost;
  GetArrangementArrangement.fromJson(dynamic json)
    : name = nativeFromJson<String>(json['name']),
      type = nativeFromJson<String>(json['type']),
      actualCost = json['actualCost'] == null
          ? null
          : nativeFromJson<double>(json['actualCost']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetArrangementArrangement otherTyped =
        other as GetArrangementArrangement;
    return name == otherTyped.name &&
        type == otherTyped.type &&
        actualCost == otherTyped.actualCost;
  }

  @override
  int get hashCode =>
      Object.hashAll([name.hashCode, type.hashCode, actualCost.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['type'] = nativeToJson<String>(type);
    if (actualCost != null) {
      json['actualCost'] = nativeToJson<double?>(actualCost);
    }
    return json;
  }

  GetArrangementArrangement({
    required this.name,
    required this.type,
    this.actualCost,
  });
}

@immutable
class GetArrangementData {
  final GetArrangementArrangement? arrangement;
  GetArrangementData.fromJson(dynamic json)
    : arrangement = json['arrangement'] == null
          ? null
          : GetArrangementArrangement.fromJson(json['arrangement']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetArrangementData otherTyped = other as GetArrangementData;
    return arrangement == otherTyped.arrangement;
  }

  @override
  int get hashCode => arrangement.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (arrangement != null) {
      json['arrangement'] = arrangement!.toJson();
    }
    return json;
  }

  GetArrangementData({this.arrangement});
}

@immutable
class GetArrangementVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetArrangementVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetArrangementVariables otherTyped = other as GetArrangementVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetArrangementVariables({required this.id});
}
