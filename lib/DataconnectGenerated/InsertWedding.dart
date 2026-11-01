part of 'generated.dart';

class InsertWeddingVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  InsertWeddingVariablesBuilder(this._dataConnect);
  Deserializer<InsertWeddingData> dataDeserializer = (dynamic json) =>
      InsertWeddingData.fromJson(jsonDecode(json));

  Future<OperationResult<InsertWeddingData, void>> execute() {
    return ref().execute();
  }

  MutationRef<InsertWeddingData, void> ref() {
    return _dataConnect.mutation(
      "InsertWedding",
      dataDeserializer,
      emptySerializer,
      null,
    );
  }
}

@immutable
class InsertWeddingWeddingInsert {
  final String id;
  InsertWeddingWeddingInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertWeddingWeddingInsert otherTyped =
        other as InsertWeddingWeddingInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  InsertWeddingWeddingInsert({required this.id});
}

@immutable
class InsertWeddingData {
  final InsertWeddingWeddingInsert wedding_insert;
  InsertWeddingData.fromJson(dynamic json)
    : wedding_insert = InsertWeddingWeddingInsert.fromJson(
        json['wedding_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final InsertWeddingData otherTyped = other as InsertWeddingData;
    return wedding_insert == otherTyped.wedding_insert;
  }

  @override
  int get hashCode => wedding_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['wedding_insert'] = wedding_insert.toJson();
    return json;
  }

  InsertWeddingData({required this.wedding_insert});
}
