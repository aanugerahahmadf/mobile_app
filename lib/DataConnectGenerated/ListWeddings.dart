part of 'generated.dart';

class ListWeddingsVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListWeddingsVariablesBuilder(this._dataConnect);
  Deserializer<ListWeddingsData> dataDeserializer = (dynamic json) =>
      ListWeddingsData.fromJson(jsonDecode(json));

  Future<QueryResult<ListWeddingsData, void>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListWeddingsData, void> ref() {
    return _dataConnect.query(
      "ListWeddings",
      dataDeserializer,
      emptySerializer,
      null,
    );
  }
}

@immutable
class ListWeddingsWeddings {
  final String title;
  final DateTime weddingDate;
  ListWeddingsWeddings.fromJson(dynamic json)
    : title = nativeFromJson<String>(json['title']),
      weddingDate = nativeFromJson<DateTime>(json['weddingDate']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListWeddingsWeddings otherTyped = other as ListWeddingsWeddings;
    return title == otherTyped.title && weddingDate == otherTyped.weddingDate;
  }

  @override
  int get hashCode => Object.hashAll([title.hashCode, weddingDate.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    json['weddingDate'] = nativeToJson<DateTime>(weddingDate);
    return json;
  }

  ListWeddingsWeddings({required this.title, required this.weddingDate});
}

@immutable
class ListWeddingsData {
  final List<ListWeddingsWeddings> weddings;
  ListWeddingsData.fromJson(dynamic json)
    : weddings = (json['weddings'] as List<dynamic>)
          .map((e) => ListWeddingsWeddings.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListWeddingsData otherTyped = other as ListWeddingsData;
    return weddings == otherTyped.weddings;
  }

  @override
  int get hashCode => weddings.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['weddings'] = weddings.map((e) => e.toJson()).toList();
    return json;
  }

  ListWeddingsData({required this.weddings});
}
