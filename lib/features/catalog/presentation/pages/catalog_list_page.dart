import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../widgets/product_card.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../providers/catalog_provider.dart';

class CatalogListPage extends ConsumerStatefulWidget {
  final String type;
  const CatalogListPage({super.key, required this.type});

  @override
  ConsumerState<CatalogListPage> createState() => _CatalogListPageState();
}

class _CatalogListPageState extends ConsumerState<CatalogListPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _items = [];
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;
  bool _loading = true;
  String? _error;
  String? _selectedSort;
  String? _selectedCategoryId;
  List<Map<String, dynamic>> _categories = [];



  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final typeParam = widget.type == 'packages' ? 'package' : 'product';
      final res = await DioClient.instance.get('${ApiEndpoints.categories}?type=$typeParam');
      final data = res.data['data'];
      if (data is List && mounted) {
        setState(() => _categories = data.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _hasMore &&
        !_loadingMore) {
      _fetchMore();
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
      _page = 1;
      _items.clear();
    });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final res = widget.type == 'packages'
          ? await repo.getPackages(sort: _selectedSort, page: 1, categoryId: _selectedCategoryId)
          : await repo.getProducts(sort: _selectedSort, page: 1, categoryId: _selectedCategoryId);
      final data = res['data'];
      final list = _extractList(data);
      _items.addAll(list);
      _hasMore = list.length >= 10;
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _fetchMore() async {
    setState(() => _loadingMore = true);
    _page++;
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final res = widget.type == 'packages'
          ? await repo.getPackages(sort: _selectedSort, page: _page, categoryId: _selectedCategoryId)
          : await repo.getProducts(sort: _selectedSort, page: _page, categoryId: _selectedCategoryId);
      final data = res['data'];
      final list = _extractList(data);
      _items.addAll(list);
      _hasMore = list.length >= 10;
    } catch (_) {}
    if (mounted) setState(() => _loadingMore = false);
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
        title: Text(widget.type == 'packages' ? l.flowerPackages : l.flowers),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
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
      (l.all, null),
      (l.cheapest, 'price_asc'),
      (l.mostExpensive, 'price_desc'),
      (l.newest, 'newest'),
    ];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        itemCount: sortOptions.length + (_categories.isNotEmpty ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(width: AppSizes.sm),
        itemBuilder: (_, i) {
          if (_categories.isNotEmpty && i == 0) {
            return Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withAlpha(30),
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
                  onChanged: (v) {
                    setState(() => _selectedCategoryId = v);
                    _fetchData();
                  },
                ),
              ),
            );
          }
          final chipIdx = _categories.isNotEmpty ? i - 1 : i;
          final (label, value) = sortOptions[chipIdx];
          final isSelected = _selectedSort == value;
          return FilterChip(
            label: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
              ),
            ),
            selected: isSelected,
            onSelected: (_) {
              setState(() => _selectedSort = value);
              _fetchData();
            },
            selectedColor: AppColors.secondaryColor,
            checkmarkColor: AppColors.primaryColor,
          );
        },
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
      return AppErrorState(message: _error!, onRetry: _fetchData);
    }

    if (_items.isEmpty) {
      return AppEmptyState(
        title: l.catalogEmpty,
        subtitle: l.catalogEmptyDesc,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.61,
                crossAxisSpacing: AppSizes.md,
                mainAxisSpacing: AppSizes.md,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  return ProductCard(
                    item: _items[i],
                    type: widget.type,
                    onTap: () =>
                        context.go('/catalog/${widget.type}/${_items[i]['id']}'),
                  );
                },
                childCount: _items.length,
              ),
            ),
          ),
          if (_loadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.md),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
