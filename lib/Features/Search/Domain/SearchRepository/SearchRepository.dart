import '../../Data/Models/SearchResult/SearchResult.dart';

abstract class SearchRepository {
  Future<SearchResult> search(String query, {int page = 1});
}
