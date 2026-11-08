part of 'generated.dart';

class GetWeddingVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetWeddingVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetWeddingData> dataDeserializer = (dynamic json) =>
      GetWeddingData.fromJson(jsonDecode(json));
  Serializer<GetWeddingVariables> varsSerializer = (GetWeddingVariables vars) =>
      jsonEncode(vars.toJson());
  Future<QueryResult<GetWeddingData, GetWeddingVariables>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetWeddingData, GetWeddingVariables> ref() {
    GetWeddingVariables vars = GetWeddingVariables(id: id);
    return _dataConnect.query(
      "GetWedding",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetWeddingWedding {
  final String title;
  final DateTime weddingDate;
  final double? budgetLimit;
  GetWeddingWedding.fromJson(dynamic json)
    : title = nativeFromJson<String>(json['title']),
      weddingDate = nativeFromJson<DateTime>(json['weddingDate']),
      budgetLimit = json['budgetLimit'] == null
          ? null
          : nativeFromJson<double>(json['budgetLimit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetWeddingWedding otherTyped = other as GetWeddingWedding;
    return title == otherTyped.title &&
        weddingDate == otherTyped.weddingDate &&
        budgetLimit == otherTyped.budgetLimit;
  }

  @override
  int get hashCode => Object.hashAll([
    title.hashCode,
    weddingDate.hashCode,
    budgetLimit.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    json['weddingDate'] = nativeToJson<DateTime>(weddingDate);
    if (budgetLimit != null) {
      json['budgetLimit'] = nativeToJson<double?>(budgetLimit);
    }
    return json;
  }

  GetWeddingWedding({
    required this.title,
    required this.weddingDate,
    this.budgetLimit,
  });
}

@immutable
class GetWeddingData {
  final GetWeddingWedding? wedding;
  GetWeddingData.fromJson(dynamic json)
    : wedding = json['wedding'] == null
          ? null
          : GetWeddingWedding.fromJson(json['wedding']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetWeddingData otherTyped = other as GetWeddingData;
    return wedding == otherTyped.wedding;
  }

  @override
  int get hashCode => wedding.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (wedding != null) {
      json['wedding'] = wedding!.toJson();
    }
    return json;
  }

  GetWeddingData({this.wedding});
}

@immutable
class GetWeddingVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetWeddingVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetWeddingVariables otherTyped = other as GetWeddingVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetWeddingVariables({required this.id});
}
