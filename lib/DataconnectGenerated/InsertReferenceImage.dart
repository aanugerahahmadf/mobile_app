part of 'generated.dart';

class InsertReferenceImageVariablesBuilder {
  String imageUrl;
  String description;
  String weddingId;

  final FirebaseDataConnect _dataConnect;
  InsertReferenceImageVariablesBuilder(
    this._dataConnect, {
    required this.imageUrl,
    required this.description,
    required this.weddingId,
  });
  Deserializer<InsertReferenceImageData> dataDeserializer = (dynamic json) =>
      InsertReferenceImageData.fromJson(jsonDecode(json));
  Serializer<InsertReferenceImageVariables> varsSerializer =
      (InsertReferenceImageVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<InsertReferenceImageData, InsertReferenceImageVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<InsertReferenceImageData, InsertReferenceImageVariables> ref() {
    InsertReferenceImageVariables vars = InsertReferenceImageVariables(
      imageUrl: imageUrl,
      description: description,
      weddingId: weddingId,
    );
    return _dataConnect.mutation(
      "InsertReferenceImage",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class InsertReferenceImageReferenceImageInsert {
  final String id;
  InsertReferenceImageReferenceImageInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertReferenceImageReferenceImageInsert otherTyped =
        other as InsertReferenceImageReferenceImageInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  InsertReferenceImageReferenceImageInsert({required this.id});
}

@immutable
class InsertReferenceImageData {
  final InsertReferenceImageReferenceImageInsert referenceImage_insert;
  InsertReferenceImageData.fromJson(dynamic json)
    : referenceImage_insert = InsertReferenceImageReferenceImageInsert.fromJson(
        json['referenceImage_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertReferenceImageData otherTyped =
        other as InsertReferenceImageData;
    return referenceImage_insert == otherTyped.referenceImage_insert;
  }

  @override
  int get hashCode => referenceImage_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['referenceImage_insert'] = referenceImage_insert.toJson();
    return json;
  }

  InsertReferenceImageData({required this.referenceImage_insert});
}

@immutable
class InsertReferenceImageVariables {
  final String imageUrl;
  final String description;
  final String weddingId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  InsertReferenceImageVariables.fromJson(Map<String, dynamic> json)
    : imageUrl = nativeFromJson<String>(json['imageUrl']),
      description = nativeFromJson<String>(json['description']),
      weddingId = nativeFromJson<String>(json['weddingId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertReferenceImageVariables otherTyped =
        other as InsertReferenceImageVariables;
    return imageUrl == otherTyped.imageUrl &&
        description == otherTyped.description &&
        weddingId == otherTyped.weddingId;
  }

  @override
  int get hashCode => Object.hashAll([
    imageUrl.hashCode,
    description.hashCode,
    weddingId.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['description'] = nativeToJson<String>(description);
    json['weddingId'] = nativeToJson<String>(weddingId);
    return json;
  }

  InsertReferenceImageVariables({
    required this.imageUrl,
    required this.description,
    required this.weddingId,
  });
}
