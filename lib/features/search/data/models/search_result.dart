import 'search_suggestion.dart';

class SearchResult {
  final List<SearchSuggestion> items;

  const SearchResult({this.items = const []});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final items = <SearchSuggestion>[];

    for (final entry in _typeKeys.entries) {
      final list = (data[entry.key] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      items.addAll(list.map((e) => SearchSuggestion.fromJson(entry.value, e)));
    }

    return SearchResult(items: items);
  }

  static const Map<String, SuggestionType> _typeKeys = {
    'packages': SuggestionType.packages,
    'products': SuggestionType.products,
    'categories': SuggestionType.categories,
    'vouchers': SuggestionType.vouchers,
    'orders': SuggestionType.orders,
    'reviews': SuggestionType.reviews,
    'terms': SuggestionType.terms,
    'privacy': SuggestionType.privacy,
    'helps': SuggestionType.helps,
    'histories': SuggestionType.histories,
    'wedding_policy': SuggestionType.weddingPolicy,
  };
}
