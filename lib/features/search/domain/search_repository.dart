import '../data/models/search_result.dart';

abstract class SearchRepository {
  Future<SearchResult> search(String query, {int page = 1});
}
