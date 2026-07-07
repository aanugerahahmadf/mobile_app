import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/utils/number_utils.dart';
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
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchAll();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final res = await DioClient.instance.get(ApiEndpoints.categories);
      final data = res.data['data'];
      if (data is List && mounted) {
        setState(() => _categories = data.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
  }

  List<_CatalogItem> get _filteredItems {
    var items = List<_CatalogItem>.from(_items);

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
        repo.getPackages(page: 1),
        repo.getProducts(page: 1),
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
      appBar: AppBar(title: Text('${l.all} ${l.catalog}'), centerTitle: true),
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
      (l.all, null),
      (l.cheapest, 'price_asc'),
      (l.mostExpensive, 'price_desc'),
      (l.newest, 'newest'),
      ('Rating Tertinggi', 'rating_desc'),
      ('Rating Terendah', 'rating_asc'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.centerLeft,
            child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
        itemCount: sortOptions.length + (_categories.isNotEmpty ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.xs),
        itemBuilder: (_, i) {
          if (_categories.isNotEmpty && i == 0) {
            return Center(
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategoryId,
                    hint: Text(l.category, style: const TextStyle(fontSize: 12)),
                    isDense: true,
                    items: [
                      DropdownMenuItem(value: null, child: Text(l.all, style: const TextStyle(fontSize: 12))),
                      ..._categories.map((c) {
                        return DropdownMenuItem(
                          value: '${c['id']}',
                          child: Text('${c['name']}', style: const TextStyle(fontSize: 12)),
                        );
                      }),
                    ],
                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                  ),
                ),
              ),
            );
          }
          final chipIdx = _categories.isNotEmpty ? i - 1 : i;
          final (label, value) = sortOptions[chipIdx];
          final isSelected = _selectedSort == value;
          return Center(
            child: FilterChip(
              label: Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedSort = value),
              selectedColor: AppColors.secondaryColor,
              checkmarkColor: AppColors.primaryColor,
            ),
          );
        },
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
      return AppErrorState(message: _error!, onRetry: _fetchAll);
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
