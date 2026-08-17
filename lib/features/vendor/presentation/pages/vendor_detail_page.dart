import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/api/api_endpoints.dart';
import 'package:mobile_app/core/api/dio_client.dart';
import 'package:mobile_app/core/constants/app_colors.dart';
import 'package:mobile_app/core/constants/app_sizes.dart';
import 'package:mobile_app/core/widgets/app_filter_widgets.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../catalog/data/models/item_model.dart';
import '../../../catalog/presentation/widgets/combined_card.dart';

class VendorDetailPage extends StatefulWidget {
  final String id;

  const VendorDetailPage({super.key, required this.id});

  @override
  State<VendorDetailPage> createState() => _VendorDetailPageState();
}

class _VendorDetailPageState extends State<VendorDetailPage> {
  Map<String, dynamic>? _vendor;
  final List<_VendorItem> _allItems = [];
  bool _loading = true;
  String? _error;
  String? _selectedCategoryId;
  String? _selectedSort;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final res = await DioClient.instance.get(ApiEndpoints.vendorDetail(widget.id));
      final data = res.data['data'] as Map<String, dynamic>;

      if (mounted) {
        final pkgRaw = data['packages'] as List? ?? [];
        final prdRaw = data['products'] as List? ?? [];

        final items = <_VendorItem>[
          ...pkgRaw.map((e) => _VendorItem(ItemModel.fromJson(e as Map<String, dynamic>), 'packages')),
          ...prdRaw.map((e) => _VendorItem(ItemModel.fromJson(e as Map<String, dynamic>), 'products')),
        ]..shuffle();

        final catMap = <String, Map<String, dynamic>>{};
        for (final vi in items) {
          final cat = vi.data.category;
          if (cat != null) catMap['${cat.id}'] = {'id': '${cat.id}', 'name': cat.name};
        }

        setState(() {
          _vendor = data;
          _allItems
            ..clear()
            ..addAll(items);
          _categories = catMap.values.toList();
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  List<_VendorItem> get _filteredItems {
    var items = List<_VendorItem>.from(_allItems);
    if (_selectedCategoryId != null) {
      items = items.where((e) => '${e.data.categoryId}' == _selectedCategoryId).toList();
    }
    switch (_selectedSort) {
      case 'price_asc':
        items.sort((a, b) => a.data.finalPrice.compareTo(b.data.finalPrice));
      case 'price_desc':
        items.sort((a, b) => b.data.finalPrice.compareTo(a.data.finalPrice));
      case 'newest':
        items.sort((a, b) => (b.data.createdAt ?? '').compareTo(a.data.createdAt ?? ''));
      case 'rating_desc':
        items.sort((a, b) => b.data.averageRating.compareTo(a.data.averageRating));
      case 'rating_asc':
        items.sort((a, b) => a.data.averageRating.compareTo(b.data.averageRating));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_vendor?['store_name'] as String? ?? l.vendor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: $_error', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton.tonalIcon(
                        onPressed: _fetch,
                        icon: const Icon(Icons.refresh),
                        label: Text(l.retry),
                      ),
                    ],
                  ),
                )
              : _allItems.isEmpty
                  ? Center(child: Text(l.noData, style: TextStyle(color: AppColors.textSecondary)))
                  : RefreshIndicator(
                      onRefresh: _fetch,
                      child: CustomScrollView(
                        slivers: [
                          _buildVendorHeader(),
                          SliverToBoxAdapter(child: _buildFilterBar(l)),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            sliver: _buildGrid(),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildFilterBar(AppLocalizations l) {
    final sortOptions = [
      (l.priceLowToHigh, 'price_asc'),
      (l.priceHighToLow, 'price_desc'),
      (l.newest, 'newest'),
      (l.highestRating, 'rating_desc'),
      (l.lowestRating, 'rating_asc'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                if (_categories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: StyledCategoryDropdown(
                      value: _selectedCategoryId,
                      hint: l.allCategories,
                      categories: _categories,
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

  Widget _buildGrid() {
    final items = _filteredItems;
    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(AppLocalizations.of(context)!.noMatchingItems,
                style: TextStyle(color: AppColors.textSecondary)),
          ),
        ),
      );
    }
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.61,
        crossAxisSpacing: AppSizes.xs,
        mainAxisSpacing: AppSizes.xs,
      ),
      delegate: SliverChildBuilderDelegate(
        (_, i) {
          final vi = items[i];
          return CombinedCard(
            item: vi.data,
            type: vi.type,
            onTap: () => context.push('/catalog/${vi.type}/${vi.data.id}'),
          );
        },
        childCount: items.length,
      ),
    );
  }

  Widget _buildVendorHeader() {
    final logo = _vendor?['logo'] as String?;
    final desc = _vendor?['store_description'] as String?;
    final contact = _vendor?['contact_person'] as String?;
    final phone = _vendor?['no_telp'] as String?;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryColor, Color(0xFF7C4DFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: logo != null && logo.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: logo,
                        width: 80, height: 80,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const SizedBox(
                          width: 80, height: 80,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (_, _, _) => const Icon(Icons.store, size: 48, color: Colors.white),
                      )
                    : const Icon(Icons.store, size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _vendor?['store_name'] as String? ?? '',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            if (desc != null && desc.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  desc,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
                ),
              ),
            if (contact != null && contact.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(contact, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            if (phone != null && phone.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(phone, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VendorItem {
  final ItemModel data;
  final String type;
  const _VendorItem(this.data, this.type);
}
