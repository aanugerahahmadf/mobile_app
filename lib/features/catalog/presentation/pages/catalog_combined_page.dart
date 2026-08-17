import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_filter_widgets.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/utils/number_utils.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../data/models/item_model.dart';
import '../widgets/combined_card.dart';
import '../providers/catalog_provider.dart';

class CatalogCombinedPage extends ConsumerStatefulWidget {
  const CatalogCombinedPage({super.key});

  @override
  ConsumerState<CatalogCombinedPage> createState() => _CatalogCombinedPageState();
}

class _CatalogCombinedPageState extends ConsumerState<CatalogCombinedPage> {
  bool _loading = true;
  String? _error;
  final List<_CatalogItem> _items = [];
  String? _selectedSort;
  String? _selectedCategoryId;
  String? _selectedType;
  List<Map<String, dynamic>> _packageCategories = [];
  List<Map<String, dynamic>> _productCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchAll();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final results = await Future.wait([
        DioClient.instance.get('${ApiEndpoints.categories}?type=package'),
        DioClient.instance.get('${ApiEndpoints.categories}?type=product'),
      ]);
      if (mounted) {
        setState(() {
          _packageCategories = _extractCategoryList(results[0]);
          _productCategories = _extractCategoryList(results[1]);
        });
      }
    } catch (_) {}
  }

  List<Map<String, dynamic>> _extractCategoryList(dynamic res) {
    final data = res.data['data'];
    if (data is List) return data.cast<Map<String, dynamic>>();
    return [];
  }

  List<Map<String, dynamic>> get _currentCategories {
    if (_selectedType == 'packages') return _packageCategories;
    if (_selectedType == 'products') return _productCategories;
    final all = <String, Map<String, dynamic>>{};
    for (final c in _packageCategories) { all['${c['id']}'] = c; }
    for (final c in _productCategories) { all['${c['id']}'] = c; }
    return all.values.toList();
  }

  List<_CatalogItem> get _filteredItems {
    var items = List<_CatalogItem>.from(_items);

    if (_selectedType != null) {
      items = items.where((e) => e.type == _selectedType).toList();
    }

    if (_selectedCategoryId != null) {
      items = items.where((e) => '${e.data['category_id']}' == _selectedCategoryId).toList();
    }

    switch (_selectedSort) {
      case 'price_asc':
        items.sort((a, b) => parseDouble(a.data['price']).compareTo(parseDouble(b.data['price'])));
      case 'price_desc':
        items.sort((a, b) => parseDouble(b.data['price']).compareTo(parseDouble(a.data['price'])));
      case 'newest':
        items.sort((a, b) => parseInt(b.data['id']).compareTo(parseInt(a.data['id'])));
      case 'rating_desc':
        items.sort((a, b) => parseDouble(b.data['average_rating']).compareTo(parseDouble(a.data['average_rating'])));
      case 'rating_asc':
        items.sort((a, b) => parseDouble(a.data['average_rating']).compareTo(parseDouble(b.data['average_rating'])));
    }

    return items;
  }

  Future<void> _fetchAll() async {
    setState(() { _loading = true; _error = null; _items.clear(); });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final results = await Future.wait([
        repo.getPackages(),
        repo.getProducts(),
      ]);
      final packages = _extractList(results[0]).map((e) => _CatalogItem(e, 'packages')).toList();
      final products = _extractList(results[1]).map((e) => _CatalogItem(e, 'products')).toList();
      _items.addAll(packages);
      _items.addAll(products);
      _items.shuffle();
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map) {
      if (data['data'] is List) return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text('${l.all} ${l.catalog}'), centerTitle: true, backgroundColor: Colors.transparent, elevation: 0),
      body: Column(
        children: [
          _buildFilterChips(l),
          Expanded(child: _buildBody(l)),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AppLocalizations l) {
    final sortOptions = [
      (l.cheapest, 'price_asc'),
      (l.mostExpensive, 'price_desc'),
      (l.newest, 'newest'),
      (l.highestRating, 'rating_desc'),
      (l.lowestRating, 'rating_asc'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_currentCategories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: StyledCategoryDropdown(
                      value: _selectedCategoryId,
                      hint: l.category,
                      categories: _currentCategories,
                      onChanged: (v) => setState(() => _selectedCategoryId = v),
                    ),
                  ),
                StyledSortChips(
                  options: sortOptions,
                  selectedValue: _selectedSort,
                  onChanged: (v) => setState(() => _selectedSort = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return AppErrorState(message: LocalizedError.of(l, _error!), onRetry: _fetchAll);
    }
    if (_filteredItems.isEmpty) {
      return AppEmptyState(title: l.catalogEmpty, subtitle: l.catalogEmptyDesc);
    }
    return RefreshIndicator(
      onRefresh: _fetchAll,
      child: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.61,
          crossAxisSpacing: AppSizes.xs,
          mainAxisSpacing: AppSizes.xs,
        ),
        itemCount: _filteredItems.length,
        itemBuilder: (_, i) {
          final ci = _filteredItems[i];
          return CombinedCard(
            item: ItemModel.fromJson(ci.data),
            type: ci.type,
            onTap: () => context.push('/catalog/${ci.type}/${ci.data['id']}'),
          );
        },
      ),
    );
  }
}

class _CatalogItem {
  final Map<String, dynamic> data;
  final String type;
  const _CatalogItem(this.data, this.type);
}
