part of 'generated.dart';

class GetVenueAreaVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetVenueAreaVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetVenueAreaData> dataDeserializer = (dynamic json) =>
      GetVenueAreaData.fromJson(jsonDecode(json));
  Serializer<GetVenueAreaVariables> varsSerializer =
      (GetVenueAreaVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetVenueAreaData, GetVenueAreaVariables>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetVenueAreaData, GetVenueAreaVariables> ref() {
    GetVenueAreaVariables vars = GetVenueAreaVariables(id: id);
    return _dataConnect.query(
      "GetVenueArea",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetVenueAreaVenueArea {
  final String name;
  GetVenueAreaVenueArea.fromJson(dynamic json)
    : name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetVenueAreaVenueArea otherTyped = other as GetVenueAreaVenueArea;
    return name == otherTyped.name;
  }

  @override
  int get hashCode => name.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetVenueAreaVenueArea({required this.name});
}

@immutable
class GetVenueAreaData {
  final GetVenueAreaVenueArea? venueArea;
  GetVenueAreaData.fromJson(dynamic json)
    : venueArea = json['venueArea'] == null
          ? null
          : GetVenueAreaVenueArea.fromJson(json['venueArea']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetVenueAreaData otherTyped = other as GetVenueAreaData;
    return venueArea == otherTyped.venueArea;
  }

  @override
  int get hashCode => venueArea.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (venueArea != null) {
      json['venueArea'] = venueArea!.toJson();
    }
    return json;
  }

  GetVenueAreaData({this.venueArea});
}

@immutable
class GetVenueAreaVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetVenueAreaVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetVenueAreaVariables otherTyped = other as GetVenueAreaVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetVenueAreaVariables({required this.id});
}
