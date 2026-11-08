part of 'generated.dart';

class ListReferenceImagesVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListReferenceImagesVariablesBuilder(this._dataConnect);
  Deserializer<ListReferenceImagesData> dataDeserializer = (dynamic json) =>
      ListReferenceImagesData.fromJson(jsonDecode(json));

  Future<QueryResult<ListReferenceImagesData, void>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListReferenceImagesData, void> ref() {
    return _dataConnect.query(
      "ListReferenceImages",
      dataDeserializer,
      emptySerializer,
      null,
    );
  }
}

@immutable
class ListReferenceImagesReferenceImages {
  final String imageUrl;
  final String description;
  ListReferenceImagesReferenceImages.fromJson(dynamic json)
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

    final ListReferenceImagesReferenceImages otherTyped =
        other as ListReferenceImagesReferenceImages;
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

  ListReferenceImagesReferenceImages({
    required this.imageUrl,
    required this.description,
  });
}

@immutable
class ListReferenceImagesData {
  final List<ListReferenceImagesReferenceImages> referenceImages;
  ListReferenceImagesData.fromJson(dynamic json)
    : referenceImages = (json['referenceImages'] as List<dynamic>)
          .map((e) => ListReferenceImagesReferenceImages.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListReferenceImagesData otherTyped = other as ListReferenceImagesData;
    return referenceImages == otherTyped.referenceImages;
  }

  @override
  int get hashCode => referenceImages.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['referenceImages'] = referenceImages.map((e) => e.toJson()).toList();
    return json;
  }

  ListReferenceImagesData({required this.referenceImages});
}
