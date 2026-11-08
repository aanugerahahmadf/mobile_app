part of 'generated.dart';

class DeleteVenueAreaVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteVenueAreaVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<DeleteVenueAreaData> dataDeserializer = (dynamic json) =>
      DeleteVenueAreaData.fromJson(jsonDecode(json));
  Serializer<DeleteVenueAreaVariables> varsSerializer =
      (DeleteVenueAreaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteVenueAreaData, DeleteVenueAreaVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<DeleteVenueAreaData, DeleteVenueAreaVariables> ref() {
    DeleteVenueAreaVariables vars = DeleteVenueAreaVariables(id: id);
    return _dataConnect.mutation(
      "DeleteVenueArea",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteVenueAreaVenueAreaDelete {
  final String id;
  DeleteVenueAreaVenueAreaDelete.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteVenueAreaVenueAreaDelete otherTyped =
        other as DeleteVenueAreaVenueAreaDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteVenueAreaVenueAreaDelete({required this.id});
}

@immutable
class DeleteVenueAreaData {
  final DeleteVenueAreaVenueAreaDelete? venueArea_delete;
  DeleteVenueAreaData.fromJson(dynamic json)
    : venueArea_delete = json['venueArea_delete'] == null
          ? null
          : DeleteVenueAreaVenueAreaDelete.fromJson(json['venueArea_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteVenueAreaData otherTyped = other as DeleteVenueAreaData;
    return venueArea_delete == otherTyped.venueArea_delete;
  }

  @override
  int get hashCode => venueArea_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (venueArea_delete != null) {
      json['venueArea_delete'] = venueArea_delete!.toJson();
    }
    return json;
  }

  DeleteVenueAreaData({this.venueArea_delete});
}

@immutable
class DeleteVenueAreaVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteVenueAreaVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteVenueAreaVariables otherTyped =
        other as DeleteVenueAreaVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteVenueAreaVariables({required this.id});
}
