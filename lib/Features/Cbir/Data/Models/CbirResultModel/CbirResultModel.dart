import '../../../../../Core/Utils/NumberUtils/NumberUtils.dart';
import '../../../../Catalog/Data/Models/ItemModel/ItemModel.dart';

class CbirResultItem {
  final String type;
  final double similarity;
  final double sCore;
  final int? catalogId;
  final ItemModel data;

  const CbirResultItem({
    required this.type,
    required this.similarity,
    required this.sCore,
    this.catalogId,
    required this.data,
  });

  factory CbirResultItem.fromJson(Map<String, dynamic> json) {
    var sim = parseDouble(json['similarity']);
    if (sim > 1) sim /= 100;
    return CbirResultItem(
      type: (json['type'] ?? 'package') as String,
      similarity: sim,
      sCore: parseDouble(json['sCore']),
      catalogId: (json['data'] as Map<String, dynamic>?)?['catalog_id'] as int?,
      data: ItemModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class CbirResult {
  final bool success;
  final List<CbirResultItem> results;
  final int totalResults;
  final double queryTimeSeconds;
  final String? message;

  const CbirResult({
    required this.success,
    this.results = const [],
    this.totalResults = 0,
    this.queryTimeSeconds = 0,
    this.message,
  });

  factory CbirResult.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List? ?? [];
    return CbirResult(
      success: json['success'] as bool? ?? false,
      results: resultsList
          .map((e) => CbirResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: (json['total_results'] ?? resultsList.length) as int,
      queryTimeSeconds: parseDouble(json['query_time_seconds']),
      message: json['message'] as String?,
    );
  }
}
