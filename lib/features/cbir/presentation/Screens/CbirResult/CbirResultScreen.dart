import 'dart:io';
import '../../../../../Core/Widgets/AppBlurBackdrop/AppBlurBackdrop.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Widgets/AppFilterWidgets/AppFilterWidgets.dart';
import '../../../../../Core/Errors/LocalizedError/LocalizedError.dart';
import '../../../../../Core/Widgets/AppShimmer/AppShimmer.dart';
import '../../../../../Core/Widgets/AppEmptyState/AppEmptyState.dart';
import '../../../../../Core/Widgets/AppErrorState/AppErrorState.dart';
import '../../../../../Core/Api/DioClient/DioClient.dart';
import '../../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Search/Presentation/Widgets/GlobalSearchBar/GlobalSearchBar.dart';
import '../../../../Catalog/Presentation/Widgets/CombinedCard/CombinedCard.dart';
import '../../../Data/Models/CbirResultModel/CbirResultModel.dart';
import '../../Providers/CbirProvider/CbirProvider.dart';

class CbirResultScreen extends ConsumerStatefulWidget {
  const CbirResultScreen({super.key});

  @override
  ConsumerState<CbirResultScreen> createState() => _CbirResultPageState();
}

class _CbirResultPageState extends ConsumerState<CbirResultScreen> {
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

  // Katalog kini satu entitas, jadi tipe CBIR tidak lagi memengaruhi rute.
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
                  const AppBreadcrumbs.global(),
                  IconButton(icon: Icon(Icons.arrow_back, color: AppColors.primaryColor), onPressed: () { ref.read(cbirProvider.notifier).reset(); context.pop(); }),
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
      child: AppBlurBackdrop(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: 6,
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
      // A Tier/Package is data inside its parent Catalog, never a page.
      onTap: () => context.go('/catalog/${item.catalogId ?? item.data.id}'),
    );
  }
}



