part of 'generated.dart';

class ListVenueAreasVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListVenueAreasVariablesBuilder(this._dataConnect);
  Deserializer<ListVenueAreasData> dataDeserializer = (dynamic json) =>
      ListVenueAreasData.fromJson(jsonDecode(json));

  Future<QueryResult<ListVenueAreasData, void>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListVenueAreasData, void> ref() {
    return _dataConnect.query(
      "ListVenueAreas",
      dataDeserializer,
      emptySerializer,
      null,
    );
  }
}

@immutable
class ListVenueAreasVenueAreas {
  final String name;
  ListVenueAreasVenueAreas.fromJson(dynamic json)
    : name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListVenueAreasVenueAreas otherTyped =
        other as ListVenueAreasVenueAreas;
    return name == otherTyped.name;
  }

  @override
  int get hashCode => name.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  ListVenueAreasVenueAreas({required this.name});
}

@immutable
class ListVenueAreasData {
  final List<ListVenueAreasVenueAreas> venueAreas;
  ListVenueAreasData.fromJson(dynamic json)
    : venueAreas = (json['venueAreas'] as List<dynamic>)
          .map((e) => ListVenueAreasVenueAreas.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListVenueAreasData otherTyped = other as ListVenueAreasData;
    return venueAreas == otherTyped.venueAreas;
  }

  @override
  int get hashCode => venueAreas.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['venueAreas'] = venueAreas.map((e) => e.toJson()).toList();
    return json;
  }

  ListVenueAreasData({required this.venueAreas});
}
