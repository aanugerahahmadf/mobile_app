import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../search/presentation/widgets/global_search_bar.dart';
import '../../../catalog/presentation/widgets/combined_card.dart';
import '../../data/models/cbir_result_model.dart';
import '../providers/cbir_provider.dart';

class CbirResultPage extends ConsumerStatefulWidget {
  const CbirResultPage({super.key});

  @override
  ConsumerState<CbirResultPage> createState() => _CbirResultPageState();
}

class _CbirResultPageState extends ConsumerState<CbirResultPage> {
  List<(String, String?)> _sortOptions(AppLocalizations l) => [
    (l.similarity, null),
    (l.lowestPrice, 'price_asc'),
    (l.highestPrice, 'price_desc'),
    (l.newest, 'newest'),
    (l.rating, 'rating_desc'),
  ];

  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is File) {
        ref.read(cbirProvider.notifier).search(extra);
      }
    });
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final res = await DioClient.instance.get(ApiEndpoints.categories);
      final data = res.data['data'];
      if (data is List) {
        if (mounted) setState(() => _categories = data.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
  }

  String _routeType(String cbirType) {
    return cbirType == 'package' ? 'packages' : 'products';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(cbirProvider);
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
            padding: const EdgeInsets.fromLTRB(0, AppSizes.sm, 0, AppSizes.md),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                  onPressed: () {
                    ref.read(cbirProvider.notifier).reset();
                    context.pop();
                  },
                ),
                const Expanded(child: GlobalSearchBar(showChat: false)),
              ],
            ),
            ),
          ),
          Expanded(child: _buildBody(context, state, l)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CbirState state, AppLocalizations l) {
    if (state.loading && state.results.isEmpty) {
      return const CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.md),
            sliver: AppShimmerGrid(itemCount: 6, crossAxisCount: 2),
          ),
        ],
      );
    }

    if (state.error != null && state.results.isEmpty) {
      return AppErrorState(
        message: state.error ?? l.errorOccurred,
      );
    }

    if (state.results.isEmpty && state.uploadedImagePath == null) {
      return AppEmptyState(
        title: l.searchByImage,
        subtitle: l.uploadImageToSearch,
      );
    }

    if (state.results.isEmpty) {
      return AppEmptyState(
        title: l.noResults,
        subtitle: l.tryDifferentImage,
      );
    }

    return Column(
      children: [
        _buildFilters(state, l),
        Expanded(child: _buildResultsGrid(context, state)),
      ],
    );
  }

  Widget _buildFilters(CbirState state, AppLocalizations l) {
    final notifier = ref.read(cbirProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _sortOptions(l).length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final entry = _sortOptions(l)[i];
                final label = entry.$1;
                final value = entry.$2;
                final selected = state.sortBy == value;
                return ChoiceChip(
                  label: Text(label, style: TextStyle(
                    fontSize: 12,
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  )),
                  selected: selected,
                  onSelected: (_) => notifier.setSortBy(value),
                  selectedColor: AppColors.primaryColor,
                  backgroundColor: AppColors.secondaryColor,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                );
              },
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Row(
            children: [
              if (_categories.isNotEmpty)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: state.categoryId,
                        isExpanded: true,
                        hint: const Text('Semua Kategori', style: TextStyle(fontSize: 12)),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Semua Kategori', style: TextStyle(fontSize: 12))),
                          ..._categories.map((c) => DropdownMenuItem(
                            value: '${c['id']}',
                            child: Text(c['name'] as String? ?? '', style: const TextStyle(fontSize: 12)),
                          )),
                        ],
                        onChanged: (v) => notifier.setCategoryId(v),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: AppSizes.sm),
              ChoiceChip(
                label: Text(l.discount, style: TextStyle(
                  fontSize: 12,
                  color: state.hasDiscount == true ? Colors.white : AppColors.textPrimary,
                  fontWeight: state.hasDiscount == true ? FontWeight.w600 : FontWeight.normal,
                )),
                selected: state.hasDiscount == true,
                onSelected: (v) => notifier.setHasDiscount(v),
                selectedColor: AppColors.primaryColor,
                backgroundColor: AppColors.secondaryColor,
                visualDensity: VisualDensity.compact,
                side: BorderSide.none,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsGrid(BuildContext context, CbirState state) {
    final items = state.filteredResults;
    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.63,
        crossAxisSpacing: AppSizes.md,
        mainAxisSpacing: AppSizes.md,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildGridItem(items[i]),
    );
  }

  Widget _buildGridItem(CbirResultItem item) {
    return CombinedCard(
      item: item.data,
      type: item.type,
      similarity: item.similarity,
      onTap: () => context.go('/catalog/${_routeType(item.type)}/${item.data.id}'),
    );
  }
}
