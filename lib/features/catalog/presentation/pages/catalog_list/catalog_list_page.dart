import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/widgets/app_filter_widgets/app_filter_widgets.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../widgets/combined_card/combined_card.dart';
import '../../../data/models/item_model/item_model.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/widgets/app_shimmer/app_shimmer.dart';
import '../../../../../core/widgets/app_empty_state/app_empty_state.dart';
import '../../../../../core/widgets/app_error_state/app_error_state.dart';
import '../../providers/catalog_provider.dart';

class CatalogListPage extends ConsumerStatefulWidget {
  final String type;
  const CatalogListPage({super.key, required this.type});

  @override
  ConsumerState<CatalogListPage> createState() => _CatalogListPageState();
}

class _CatalogListPageState extends ConsumerState<CatalogListPage> {
  final List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;
  String? _selectedSort;
  String? _selectedCategoryId;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final typeParam = widget.type == 'packages' ? 'package' : 'product';
      final res = await DioClient.instance.get(
        '${ApiEndpoints.categories}?type=$typeParam',
      );
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
      final res = widget.type == 'packages'
          ? await repo.getPackages(
              sort: _selectedSort,
              categoryId: _selectedCategoryId,
            )
          : await repo.getProducts(
              sort: _selectedSort,
              categoryId: _selectedCategoryId,
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
        title: Text(
          widget.type == 'packages'
              ? '${l.catalog} ${l.flowerPackages}'
              : '${l.catalog} ${l.flowers}',
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterChips(l),
          Expanded(child: _buildBody(l)),
          const SizedBox(height: 1),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
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
          return CombinedCard(
            item: ItemModel.fromJson(_items[i]),
            type: widget.type,
            onTap: () =>
                context.push('/catalog/${widget.type}/${_items[i]['id']}'),
          );
        },
      ),
    );
  }
}
