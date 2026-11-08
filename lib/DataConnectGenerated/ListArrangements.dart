part of 'generated.dart';

class ListArrangementsVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListArrangementsVariablesBuilder(this._dataConnect);
  Deserializer<ListArrangementsData> dataDeserializer = (dynamic json) =>
      ListArrangementsData.fromJson(jsonDecode(json));

  Future<QueryResult<ListArrangementsData, void>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListArrangementsData, void> ref() {
    return _dataConnect.query(
      "ListArrangements",
      dataDeserializer,
      emptySerializer,
      null,
    );
  }
}

@immutable
class ListArrangementsArrangements {
  final String name;
  final String type;
  ListArrangementsArrangements.fromJson(dynamic json)
    : name = nativeFromJson<String>(json['name']),
      type = nativeFromJson<String>(json['type']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListArrangementsArrangements otherTyped =
        other as ListArrangementsArrangements;
    return name == otherTyped.name && type == otherTyped.type;
  }

  @override
  int get hashCode => Object.hashAll([name.hashCode, type.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['type'] = nativeToJson<String>(type);
    return json;
  }

  ListArrangementsArrangements({required this.name, required this.type});
}

@immutable
class ListArrangementsData {
  final List<ListArrangementsArrangements> arrangements;
  ListArrangementsData.fromJson(dynamic json)
    : arrangements = (json['arrangements'] as List<dynamic>)
          .map((e) => ListArrangementsArrangements.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListArrangementsData otherTyped = other as ListArrangementsData;
    return arrangements == otherTyped.arrangements;
  }

  @override
  int get hashCode => arrangements.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['arrangements'] = arrangements.map((e) => e.toJson()).toList();
    return json;
  }

  ListArrangementsData({required this.arrangements});
}
