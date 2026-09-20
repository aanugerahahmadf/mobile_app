import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/widgets/app_filter_widgets/app_filter_widgets.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/widgets/app_shimmer/app_shimmer.dart';
import '../../../../../core/widgets/app_empty_state/app_empty_state.dart';
import '../../../../../core/widgets/app_error_state/app_error_state.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../search/presentation/widgets/global_search_bar/global_search_bar.dart';
import '../../../../catalog/presentation/widgets/combined_card/combined_card.dart';
import '../../../data/models/cbir_result_model/cbir_result_model.dart';
import '../../providers/cbir_provider/cbir_provider.dart';

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
        if (mounted) {
          setState(() => _categories = data.cast<Map<String, dynamic>>());
        }
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
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.sm,
                AppSizes.md,
                AppSizes.md,
              ),
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
      return AppErrorState(message: LocalizedError.of(l, state.error ?? ''));
    }

    if (state.results.isEmpty && state.uploadedImagePath == null) {
      return AppEmptyState(
        title: l.searchByImage,
        subtitle: l.uploadImageToSearch,
      );
    }

    if (state.results.isEmpty) {
      return AppEmptyState(title: l.noResults, subtitle: l.tryDifferentImage);
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
                StyledSortChips(
                  options: _sortOptions(l),
                  selectedValue: state.sortBy,
                  onChanged: (v) => notifier.setSortBy(v),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    if (_categories.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: StyledCategoryDropdown(
                            value: state.categoryId,
                            hint: l.allCategories,
                            categories: _categories,
                            onChanged: (v) => notifier.setCategoryId(v),
                          ),
                        ),
                      ),
                    StyledChoiceChip(
                      label: l.discount,
                      selected: state.hasDiscount == true,
                      onSelected: () =>
                          notifier.setHasDiscount(state.hasDiscount != true),
                      icon: Icons.discount_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsGrid(BuildContext context, CbirState state) {
    final items = state.filteredResults;
    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.61,
        crossAxisSpacing: AppSizes.xs,
        mainAxisSpacing: AppSizes.xs,
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
      onTap: () =>
          context.go('/catalog/${_routeType(item.type)}/${item.data.id}'),
    );
  }
}
