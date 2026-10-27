import '../../../../../core/widgets/app_blur_backdrop/app_blur_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/widgets/app_filter_widgets/app_filter_widgets.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/widgets/app_empty_state/app_empty_state.dart';
import '../../../../../core/widgets/app_error_state/app_error_state.dart';
import '../../../../../core/widgets/app_shimmer/app_shimmer.dart';
import '../../../data/models/item_model/item_model.dart';
import '../../widgets/combined_card/combined_card.dart';
import '../../providers/catalog_provider.dart';

/// Halaman grid katalog. Paket dan produk kini satu entitas `catalog`,
/// jadi tidak ada lagi pemisahan tipe saat menelusuri.
class CatalogGridPage extends ConsumerStatefulWidget {
  final String? initialCategoryId;

  const CatalogGridPage({super.key, this.initialCategoryId});

  @override
  ConsumerState<CatalogGridPage> createState() => _CatalogGridPageState();
}

class _CatalogGridPageState extends ConsumerState<CatalogGridPage> {
  bool _loading = true;
  String? _error;
  final List<Map<String, dynamic>> _items = [];
  String? _selectedSort;
  String? _selectedCategoryId;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
    _fetchData();
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

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
      _items.clear();
    });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final res = await repo.getCatalog(
        categoryId: _selectedCategoryId,
        sort: _selectedSort,
      );
      _items.addAll(_extractList(res));
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.catalog),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        0,
      ),
      child: AppBlurBackdrop(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: 6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_categories.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: StyledCategoryDropdown(
                  value: _selectedCategoryId,
                  hint: '${l.all} ${l.category}',
                  categories: _categories,
                  onChanged: (v) {
                    setState(() => _selectedCategoryId = v);
                    _fetchData();
                  },
                ),
              ),
            StyledSortChips(
              options: sortOptions,
              selectedValue: _selectedSort,
              onChanged: (v) {
                setState(() => _selectedSort = v);
                _fetchData();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l) {
    if (_loading) {
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.md),
            sliver: const AppShimmerGrid(itemCount: 6, crossAxisCount: 2),
          ),
        ],
      );
    }
    if (_error != null) {
      return AppErrorState(
        message: LocalizedError.of(l, _error!),
        onRetry: _fetchData,
      );
    }
    if (_items.isEmpty) {
      return AppEmptyState(title: l.catalogEmpty, subtitle: l.catalogEmptyDesc);
    }
    return RefreshIndicator(
      onRefresh: _fetchData,
      child: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.61,
          crossAxisSpacing: AppSizes.xs,
          mainAxisSpacing: AppSizes.xs,
        ),
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final item = _items[i];
          return CombinedCard(
            item: ItemModel.fromJson(item),
            onTap: () => context.push('/catalog/${item['id']}'),
          );
        },
      ),
    );
  }
}
