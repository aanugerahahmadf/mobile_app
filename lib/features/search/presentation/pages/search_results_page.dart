import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../providers/search_provider.dart';
import '../../data/models/search_suggestion.dart';

class SearchResultsPage extends ConsumerStatefulWidget {
  final String query;
  const SearchResultsPage({super.key, required this.query});

  @override
  ConsumerState<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends ConsumerState<SearchResultsPage> {
  late String _query;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProvider.notifier).search(_query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pencarian'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: TextEditingController.fromValue(TextEditingValue(text: _query)),
              decoration: InputDecoration(
                hintText: 'Cari apa saja...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () {
                    setState(() => _query = '');
                  },
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                final q = value.trim();
                if (q.isNotEmpty) {
                  setState(() => _query = q);
                  ref.read(searchProvider.notifier).search(q);
                }
              },
            ),
          ),
        ),
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: AppSizes.md),
                        Text(state.error!, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                        const SizedBox(height: AppSizes.md),
                        ElevatedButton.icon(
                          onPressed: () => ref.read(searchProvider.notifier).search(_query),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : state.results == null || state.results!.items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: AppSizes.md),
                            Text('Hasil tidak ditemukan untuk "$_query"',
                              style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(searchProvider.notifier).search(_query),
                      child: _buildGroupedResults(state.results!.items),
                    ),
    );
  }

  Widget _buildGroupedResults(List<SearchSuggestion> items) {
    final grouped = <String, List<SearchSuggestion>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.type.badgeLabel, () => []).add(item);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => grouped[b]!.length.compareTo(grouped[a]!.length));

    return ListView(
      padding: const EdgeInsets.all(AppSizes.md),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: Text('${items.length} hasil untuk "$_query"',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ),
        ...sortedKeys.map((key) => _buildSection(key, grouped[key]!, items.firstWhere((i) => i.type.badgeLabel == key).type)),
      ],
    );
  }

  Widget _buildSection(String label, List<SearchSuggestion> sectionItems, SuggestionType type) {
    final displayItems = sectionItems.take(5).toList();
    final hasMore = sectionItems.length > 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSizes.md, bottom: AppSizes.sm),
          child: Row(
            children: [
              Text(label, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${sectionItems.length}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        ...displayItems.map((item) => _buildResultItem(item)),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: TextButton(
              onPressed: () => _navigateToType(type),
              child: Text('Lihat semua ${sectionItems.length} $label'),
            ),
          ),
        const Divider(height: 24),
      ],
    );
  }

  Widget _buildResultItem(SearchSuggestion item) {
    final hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        dense: true,
        leading: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 40, height: 40,
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl!, fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Container(color: const Color(0xFFF5F5F5), child: const Icon(Icons.image_outlined, size: 20, color: Color(0xFFD0D0D0))),
                  ),
                ),
              )
            : _iconBox(item.type),
        title: Text(item.name ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: item.subtitle != null ? Text(item.subtitle!, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis) : null,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
          child: Text(item.type.badgeLabel, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
        ),
        onTap: () => _navigateToItem(item),
      ),
    );
  }

  Widget _iconBox(SuggestionType type) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(8)),
      child: Icon(_iconForType(type), size: 20, color: AppColors.primaryColor),
    );
  }

  IconData _iconForType(SuggestionType type) {
    switch (type) {
      case SuggestionType.categories: return Icons.category_rounded;
      case SuggestionType.vouchers: return Icons.discount_rounded;
      case SuggestionType.orders: return Icons.receipt_long;
      case SuggestionType.reviews: return Icons.star_rounded;
      case SuggestionType.terms: case SuggestionType.privacy: case SuggestionType.weddingPolicy: return Icons.description_rounded;
      case SuggestionType.helps: return Icons.help_outline_rounded;
      case SuggestionType.histories: return Icons.history_rounded;
      case SuggestionType.packages: case SuggestionType.products: return Icons.image_outlined;
    }
  }

  void _navigateToType(SuggestionType type) {
    switch (type) {
      case SuggestionType.packages:
      case SuggestionType.products:
        context.push('/catalog');
      case SuggestionType.categories:
        context.push('/catalog');
      case SuggestionType.vouchers:
        context.push('/vouchers');
      case SuggestionType.orders:
        context.push('/orders');
      case SuggestionType.reviews:
        context.push('/my-reviews');
      case SuggestionType.histories:
        context.push('/history');
      case SuggestionType.terms:
        context.push('/terms-of-service');
      case SuggestionType.privacy:
        context.push('/privacy-policy');
      case SuggestionType.helps:
        context.push('/help-center');
      case SuggestionType.weddingPolicy:
        context.push('/wedding-policy');
    }
  }

  void _navigateToItem(SearchSuggestion item) {
    if (item.routeExtra != null) {
      context.push(item.routePath, extra: item.routeExtra);
    } else {
      context.push(item.routePath);
    }
  }
}
