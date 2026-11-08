part of 'generated.dart';

class GetReferenceImageVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetReferenceImageVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetReferenceImageData> dataDeserializer = (dynamic json) =>
      GetReferenceImageData.fromJson(jsonDecode(json));
  Serializer<GetReferenceImageVariables> varsSerializer =
      (GetReferenceImageVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetReferenceImageData, GetReferenceImageVariables>>
  execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetReferenceImageData, GetReferenceImageVariables> ref() {
    GetReferenceImageVariables vars = GetReferenceImageVariables(id: id);
    return _dataConnect.query(
      "GetReferenceImage",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetReferenceImageReferenceImage {
  final String imageUrl;
  final String description;
  GetReferenceImageReferenceImage.fromJson(dynamic json)
    : imageUrl = nativeFromJson<String>(json['imageUrl']),
      description = nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetReferenceImageReferenceImage otherTyped =
        other as GetReferenceImageReferenceImage;
    return imageUrl == otherTyped.imageUrl &&
        description == otherTyped.description;
  }

  @override
  int get hashCode => Object.hashAll([imageUrl.hashCode, description.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['description'] = nativeToJson<String>(description);
    return json;
  }

  GetReferenceImageReferenceImage({
    required this.imageUrl,
    required this.description,
  });
}

@immutable
class GetReferenceImageData {
  final GetReferenceImageReferenceImage? referenceImage;
  GetReferenceImageData.fromJson(dynamic json)
    : referenceImage = json['referenceImage'] == null
          ? null
          : GetReferenceImageReferenceImage.fromJson(json['referenceImage']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetReferenceImageData otherTyped = other as GetReferenceImageData;
    return referenceImage == otherTyped.referenceImage;
  }

  @override
  int get hashCode => referenceImage.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (referenceImage != null) {
      json['referenceImage'] = referenceImage!.toJson();
    }
    return json;
  }

  GetReferenceImageData({this.referenceImage});
}

@immutable
class GetReferenceImageVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetReferenceImageVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetReferenceImageVariables otherTyped =
        other as GetReferenceImageVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetReferenceImageVariables({required this.id});
}
