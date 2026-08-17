import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_filter_widgets.dart';
import '../../../../core/utils/number_utils.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../search/presentation/widgets/global_search_bar.dart';
import '../../../../features/catalog/data/models/item_model.dart';
import '../../../../features/catalog/presentation/widgets/combined_card.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../notification/presentation/providers/notification_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../widgets/menu_card.dart';
import '../widgets/voucher_card.dart';
import '../../../admin/presentation/pages/admin_dashboard.dart';
import '../../../admin/data/repositories/admin_repository.dart';
import '../../../admin/presentation/pages/base/base_form.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _AdminHome extends ConsumerStatefulWidget {
  const _AdminHome();

  @override
  ConsumerState<_AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<_AdminHome> {
  List<Map<String, dynamic>> _combinedItems = [];
  bool _catalogLoading = false;
  late final AdminRepository _repo;
  List<Map<String, dynamic>> _packageCategories = [];
  List<Map<String, dynamic>> _productCategories = [];

  @override
  void initState() {
    super.initState();
    _repo = ref.read(adminRepositoryProvider);
    _fetchCatalog();
    _fetchPackageCategories();
    _fetchProductCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationListProvider.notifier).fetchUnreadCount();
    });
  }

  Future<void> _fetchPackageCategories() async {
    try {
      final res = await DioClient.instance.get('${ApiEndpoints.categories}?type=package');
      final data = res.data['data'];
      if (data is List && mounted) {
        setState(() => _packageCategories = data.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
  }

  Future<void> _fetchProductCategories() async {
    try {
      final res = await DioClient.instance.get('${ApiEndpoints.categories}?type=product');
      final data = res.data['data'];
      if (data is List && mounted) {
        setState(() => _productCategories = data.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
  }

  Future<void> _fetchCatalog() async {
    setState(() => _catalogLoading = true);
    try {
      final results = await Future.wait([
        DioClient.instance.get('${ApiEndpoints.packages}?per_page=all'),
        DioClient.instance.get('${ApiEndpoints.products}?per_page=all'),
      ]);
      final packages = _extractList(results[0].data).map((e) => e..['_type'] = 'packages').toList();
      final products = _extractList(results[1].data).map((e) => e..['_type'] = 'products').toList();
      _combinedItems = [...packages, ...products]..shuffle();
    } catch (_) {}
    if (mounted) setState(() => _catalogLoading = false);
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data['data'] is List) return (data['data'] as List).cast<Map<String, dynamic>>();
    return [];
  }

  Future<void> _editItem(Map<String, dynamic> item, String type, AppLocalizations l) async {
    final isPackage = type == 'packages';
    final cats = isPackage ? _packageCategories : _productCategories;
    final catOptions = cats.map((c) => '${c['id']}|${c['name']}').toList();
    final fields = [
      FormFieldConfig(key: 'image_url', label: l.imageLabel, type: FormFieldType.image),
      FormFieldConfig(key: 'name', label: l.fullName, required: true),
      FormFieldConfig(key: 'slug', label: l.slug),
      FormFieldConfig(key: 'price', label: l.price, type: FormFieldType.number),
      FormFieldConfig(key: 'discount_price', label: l.discountPrice, type: FormFieldType.number),
      FormFieldConfig(key: 'stock', label: l.stock, type: FormFieldType.number),
      FormFieldConfig(key: 'is_active', label: l.isActive, type: FormFieldType.toggle),
      FormFieldConfig(key: 'is_featured', label: l.isFeatured, type: FormFieldType.toggle),
      FormFieldConfig(key: 'features', label: l.features),
      FormFieldConfig(key: 'theme', label: l.theme),
      FormFieldConfig(key: 'color', label: l.color),
      FormFieldConfig(key: 'min_capacity', label: l.minCapacity, type: FormFieldType.number),
      FormFieldConfig(key: 'max_capacity', label: l.maxCapacity, type: FormFieldType.number),
      if (catOptions.isNotEmpty)
        FormFieldConfig(key: 'category_id', label: l.adminCategories, type: FormFieldType.dropdown, options: catOptions),
      FormFieldConfig(key: 'description', label: l.description, type: FormFieldType.multiline),
    ];
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdminFormDialog(
        title: '${l.edit} ${item['name'] ?? ''}',
        fields: fields,
        initialData: item,
      ),
    );
    if (result != null) {
      try {
        final cleaned = <String, dynamic>{};
        String? imagePath;
        result.forEach((key, value) {
          if (key == 'image_url' && value is String && (value.startsWith('/') || value.contains(':\\'))) {
            imagePath = value;
          } else if (key == 'category_id' && value is String && value.contains('|')) {
            cleaned[key] = value.split('|')[0];
          } else if (value is! String || !value.startsWith('/')) {
            cleaned[key] = value;
          }
        });
        final id = item['id'] as int;
        if (imagePath != null) {
          final uploadEndpoint = isPackage ? ApiEndpoints.adminPackageUpload : ApiEndpoints.adminProductUpload;
          await _repo.uploadImage(uploadEndpoint, id, imagePath!);
        }
        final updateEndpoint = isPackage ? ApiEndpoints.adminPackage : ApiEndpoints.adminProduct;
        await _repo.update(updateEndpoint, id, cleaned);
        _fetchCatalog();
      } catch (_) {}
    }
  }

  Future<void> _createItem(AppLocalizations l) async {
    final isPackage = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.selectType),
        content: Text(l.whatToAdd),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.adminPackages, style: TextStyle(color: Theme.of(ctx).brightness == Brightness.dark ? Colors.white70 : null)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.adminProducts, style: TextStyle(color: Theme.of(ctx).brightness == Brightness.dark ? Colors.white70 : null)),
          ),
        ],
      ),
    );
    if (isPackage == null) return;
    if (!mounted) return;
    final cats = isPackage ? _packageCategories : _productCategories;
    final catOptions = cats.map((c) => '${c['id']}|${c['name']}').toList();
    final fields = [
      FormFieldConfig(key: 'image_url', label: l.imageLabel, type: FormFieldType.image),
      FormFieldConfig(key: 'name', label: l.fullName, required: true),
      FormFieldConfig(key: 'slug', label: l.slug),
      FormFieldConfig(key: 'price', label: l.price, type: FormFieldType.number),
      FormFieldConfig(key: 'discount_price', label: l.discountPrice, type: FormFieldType.number),
      FormFieldConfig(key: 'stock', label: l.stock, type: FormFieldType.number),
      FormFieldConfig(key: 'is_active', label: l.isActive, type: FormFieldType.toggle),
      FormFieldConfig(key: 'is_featured', label: l.isFeatured, type: FormFieldType.toggle),
      FormFieldConfig(key: 'features', label: l.features),
      FormFieldConfig(key: 'theme', label: l.theme),
      FormFieldConfig(key: 'color', label: l.color),
      FormFieldConfig(key: 'min_capacity', label: l.minCapacity, type: FormFieldType.number),
      FormFieldConfig(key: 'max_capacity', label: l.maxCapacity, type: FormFieldType.number),
      if (catOptions.isNotEmpty)
        FormFieldConfig(key: 'category_id', label: l.adminCategories, type: FormFieldType.dropdown, options: catOptions),
      FormFieldConfig(key: 'description', label: l.description, type: FormFieldType.multiline),
    ];
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdminFormDialog(
        title: '${l.add} ${isPackage ? l.adminPackages : l.adminProducts}',
        fields: fields,
        initialData: {},
      ),
    );
    if (result != null) {
      try {
        final cleaned = <String, dynamic>{};
        String? imagePath;
        result.forEach((key, value) {
          if (key == 'image_url' && value is String && (value.startsWith('/') || value.contains(':\\'))) {
            imagePath = value;
          } else if (key == 'category_id' && value is String && value.contains('|')) {
            cleaned[key] = value.split('|')[0];
          } else if (value is! String || !value.startsWith('/')) {
            cleaned[key] = value;
          }
        });
        final endpoint = isPackage ? ApiEndpoints.adminPackages : ApiEndpoints.adminProducts;
        final created = await _repo.create(endpoint, cleaned);
        if (created != null && imagePath != null) {
          final uploadEndpoint = isPackage ? ApiEndpoints.adminPackageUpload : ApiEndpoints.adminProductUpload;
          await _repo.uploadImage(uploadEndpoint, created['id'] as int, imagePath!);
        }
        _fetchCatalog();
      } catch (_) {}
    }
  }

  Future<void> _deleteItem(Map<String, dynamic> item, String type, AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.confirm),
        content: Text(l.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel, style: TextStyle(color: Theme.of(ctx).brightness == Brightness.dark ? Colors.white70 : null)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        final endpoint = type == 'packages' ? ApiEndpoints.adminPackage : ApiEndpoints.adminProduct;
        await _repo.delete(endpoint, item['id'] as int);
        _fetchCatalog();
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAdminSearchBar(l),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchCatalog,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildAdminWelcomeRow(context, l)),
                  SliverToBoxAdapter(child: const AdminDashboard(embedded: true)),
                  if (_catalogLoading && _combinedItems.isEmpty)
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
                      sliver: AppShimmerGrid(),
                    )
                  else ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(AppSizes.md),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(l.adminCatalogTitle, style: AppTextStyles.titleLarge),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    color: AppColors.primaryColor,
                                    onPressed: () => _createItem(l),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_combinedItems.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text(l.noProductsFound, style: AppTextStyles.bodyMedium)),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.xxl),
                        sliver: SliverToBoxAdapter(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.55,
          crossAxisSpacing: AppSizes.xs,
          mainAxisSpacing: AppSizes.xs,
                        ),
                        itemCount: _combinedItems.length,
                        itemBuilder: (_, i) {
                          final item = _combinedItems[i];
                          final type = item['_type'] as String? ?? 'packages';
                          return Stack(
                            children: [
                              CombinedCard(
                                item: ItemModel.fromJson(item),
                                type: type,
                                onTap: () => context.push('/catalog/$type/${item['id']}'),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _editItem(item, type, l),
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.15),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryColor),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        GestureDetector(
                                          onTap: () => _deleteItem(item, type, l),
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.15),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(Icons.delete_outline, size: 14, color: AppColors.errorColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildAdminSearchBar(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.md),
      child: const GlobalSearchBar(),
    );
  }

  Widget _buildAdminWelcomeRow(BuildContext context, AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
          padding: const EdgeInsets.fromLTRB(AppSizes.sm, AppSizes.sm, AppSizes.sm, AppSizes.sm),
          child: Row(
            children: [
              Consumer(builder: (_, ref, _) {
                final authState = ref.watch(authProvider);
                if (authState is AuthAuthenticated) {
                  final u = authState.user;
                  final avatarUrl = u.avatarUrl;
                  final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
                  return CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primaryColor.withAlpha(25),
                    backgroundImage: hasAvatar ? CachedNetworkImageProvider(avatarUrl) : null,
                    child: !hasAvatar
                        ? Icon(Icons.person, color: AppColors.primaryColor, size: 22)
                        : null,
                  );
                }
                return CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryColor.withAlpha(25),
                  child: Icon(Icons.person, color: AppColors.primaryColor, size: 22),
                );
              }),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l.welcome},',
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    Consumer(builder: (_, ref, _) {
                      final authState = ref.watch(authProvider);
                      final name = authState is AuthAuthenticated ? authState.user.fullName : '';
                      return Text(
                        name,
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
                      );
                    }),
                  ],
                ),
              ),
              Consumer(builder: (_, ref, _) {
                final unread = ref.watch(notificationListProvider).unreadCount;
                return IconButton(
                  icon: unread > 0
                      ? Badge(
                          label: Text(unread > 99 ? '99+' : '$unread'),
                          child: const Icon(Icons.notifications_outlined),
                        )
                      : const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push('/notifications'),
                );
              }),
            ],
          ),
        );
  }
}

class _HomePageState extends ConsumerState<HomePage> {
  Map<String, dynamic>? _homeData;
  bool _loading = true;
  final _pageController = PageController(initialPage: 0x3FFFFFFF ~/ 2);
  List<Map<String, dynamic>> _combinedItems = [];
  bool _catalogLoading = false;
  List<Map<String, dynamic>> _packageCategories = [];
  List<Map<String, dynamic>> _productCategories = [];
  String? _selectedCategoryId;
  bool _hasDiscountOnly = false;
  double _minRating = 0;
  String _sortBy = 'latest';

  List<Map<String, dynamic>> get _filteredItems {
    var items = List<Map<String, dynamic>>.from(_combinedItems);

    if (_selectedCategoryId != null) {
      items = items.where((e) => '${e['category_id']}' == _selectedCategoryId).toList();
    }
    if (_hasDiscountOnly) {
      items = items.where((e) => e['discount_price'] != null && parseDouble(e['discount_price']) > 0).toList();
    }
    if (_minRating > 0) {
      items = items.where((e) {
        final rating = (e['average_rating'] ?? e['rating'] as dynamic) is num ? ((e['average_rating'] ?? e['rating']) as num).toDouble() : null;
        return rating != null && rating.round() == _minRating.toInt();
      }).toList();
    }

    switch (_sortBy) {
      case 'price_asc':
        items.sort((a, b) => parseDouble(a['price']).compareTo(parseDouble(b['price'])));
      case 'price_desc':
        items.sort((a, b) => parseDouble(b['price']).compareTo(parseDouble(a['price'])));
      case 'rating_desc':
        items.sort((a, b) {
          final ra = (a['average_rating'] ?? a['rating'] as dynamic) is num ? ((a['average_rating'] ?? a['rating']) as num).toDouble() : 0;
          final rb = (b['average_rating'] ?? b['rating'] as dynamic) is num ? ((b['average_rating'] ?? b['rating']) as num).toDouble() : 0;
          return rb.compareTo(ra);
        });
      case 'rating_asc':
        items.sort((a, b) {
          final ra = (a['average_rating'] ?? a['rating'] as dynamic) is num ? ((a['average_rating'] ?? a['rating']) as num).toDouble() : 0;
          final rb = (b['average_rating'] ?? b['rating'] as dynamic) is num ? ((b['average_rating'] ?? b['rating']) as num).toDouble() : 0;
          return ra.compareTo(rb);
        });
      case 'most_ordered':
        items.sort((a, b) => parseInt(b['ordered_count']).compareTo(parseInt(a['ordered_count'])));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _fetchHome();
    _fetchCatalog();
    _fetchCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationListProvider.notifier).fetchUnreadCount();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchHome() async {
    if (_homeData == null) setState(() => _loading = true);
    try {
      final dio = DioClient.instance;
      final response = await dio.get(ApiEndpoints.home);
      if (mounted) {
        setState(() {
          _homeData = response.data['data'] as Map<String, dynamic>?;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _fetchCatalog() async {
    setState(() => _catalogLoading = true);
    try {
      final results = await Future.wait([
        DioClient.instance.get('${ApiEndpoints.packages}?per_page=all'),
        DioClient.instance.get('${ApiEndpoints.products}?per_page=all'),
      ]);
      final packages = _extractList(results[0].data).map((e) => e..['_type'] = 'packages').toList();
      final products = _extractList(results[1].data).map((e) => e..['_type'] = 'products').toList();
      _combinedItems = [...packages, ...products]..shuffle();
    } catch (_) {}
    if (mounted) setState(() => _catalogLoading = false);
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data['data'] is List) return (data['data'] as List).cast<Map<String, dynamic>>();
    return [];
  }

  Future<void> _fetchCategories() async {
    try {
      final results = await Future.wait([
        DioClient.instance.get('${ApiEndpoints.categories}?type=package'),
        DioClient.instance.get('${ApiEndpoints.categories}?type=product'),
      ]);
      if (mounted) {
        setState(() {
          for (final res in results) {
            final data = res.data['data'];
            if (data is List) {
              final cats = data.cast<Map<String, dynamic>>();
              if (results.indexOf(res) == 0) {
                _packageCategories = cats;
              } else {
                _productCategories = cats;
              }
            }
          }
        });
      }
    } catch (_) {}
  }

  List<Map<String, dynamic>> get _allCategories {
    final all = <String, Map<String, dynamic>>{};
    for (final c in _packageCategories) { all['${c['id']}'] = c; }
    for (final c in _productCategories) { all['${c['id']}'] = c; }
    return all.values.toList();
  }



  @override
  Widget build(BuildContext context) {
    if (ref.watch(authProvider) is AuthAuthenticated && (ref.watch(authProvider) as AuthAuthenticated).user.isAdmin) {
      return _AdminHome();
    }

    final l = AppLocalizations.of(context)!;
    final vouchers = (_homeData?['vouchers'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildSearchBar(l),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.wait([_fetchHome(), _fetchCatalog()]);
                    },
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: _buildWelcomeRow(l)),
                        SliverToBoxAdapter(child: _buildMenuSection(l)),
                        if (vouchers.isNotEmpty) SliverToBoxAdapter(child: _buildVoucherSection(vouchers, l)),
                        if (_catalogLoading && _combinedItems.isEmpty)
                          const SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
                            sliver: AppShimmerGrid(),
                          )
                        else ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                AppSizes.md,
                                _filteredItems.isNotEmpty ? AppSizes.xs : 0,
                                AppSizes.md,
                                _filteredItems.isNotEmpty ? AppSizes.sm : 0,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.all(AppSizes.md),
                                    child: _buildCatalogHeader(l),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_filteredItems.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: Text(l.noProductsFound, style: AppTextStyles.bodyMedium),
                              ),
                            )
                          else
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.xxl),
                              sliver: SliverToBoxAdapter(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.61,
                                  crossAxisSpacing: AppSizes.xs,
                                  mainAxisSpacing: AppSizes.xs,
                                ),
                                itemCount: _filteredItems.length,
                                itemBuilder: (_, i) {
                                  final item = _filteredItems[i];
                                  final type = item['_type'] as String? ?? 'packages';
                                  return CombinedCard(
                                    item: ItemModel.fromJson(item),
                                    type: type,
                                    onTap: () => context.push('/catalog/$type/${item['id']}'),
                                    );
                                  },
                                ),
                              ),
                            ),
                          const SliverToBoxAdapter(child: SizedBox(height: 32)),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      );
  }

  Widget _buildSearchBar(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.md),
      child: const GlobalSearchBar(),
    );
  }

  Widget _buildWelcomeRow(AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
          padding: const EdgeInsets.fromLTRB(AppSizes.sm, AppSizes.sm, AppSizes.sm, AppSizes.sm),
          child: Row(
            children: [
              Consumer(builder: (_, ref, _) {
                final authState = ref.watch(authProvider);
                if (authState is AuthAuthenticated) {
                  final u = authState.user;
                  final avatarUrl = u.avatarUrl;
                  final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
                  return CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primaryColor.withAlpha(25),
                    backgroundImage: hasAvatar ? CachedNetworkImageProvider(avatarUrl) : null,
                    child: !hasAvatar
                        ? Icon(Icons.person, color: AppColors.primaryColor, size: 22)
                        : null,
                  );
                }
                return CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryColor.withAlpha(25),
                  child: Icon(Icons.person, color: AppColors.primaryColor, size: 22),
                );
              }),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l.welcome},',
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    Consumer(builder: (_, ref, _) {
                      final authState = ref.watch(authProvider);
                      final name = authState is AuthAuthenticated ? authState.user.fullName : '';
                      return Text(
                        name,
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
                      );
                    }),
                  ],
                ),
              ),
              Consumer(builder: (_, ref, _) {
                final unread = ref.watch(notificationListProvider).unreadCount;
                return IconButton(
                  icon: unread > 0
                      ? Badge(
                          label: Text(unread > 99 ? '99+' : '$unread'),
                          child: const Icon(Icons.notifications_outlined),
                        )
                      : const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push('/notifications'),
                );
              }),
            ],
          ),
        );
  }

  Widget _buildMenuSection(AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.xs),
      padding: const EdgeInsets.fromLTRB(AppSizes.sm, AppSizes.md, AppSizes.sm, AppSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.sm, bottom: AppSizes.sm),
            child: Text(l.services, style: AppTextStyles.titleLarge),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MenuCard(
                  icon: Icons.card_giftcard,
                  bgColor: const Color(0xFFE3F0FF),
                  iconColor: const Color(0xFF2B7BE4),
                  onTap: () => context.push('/catalog/packages'),
                ),
                MenuCard(
                  icon: Icons.local_florist,
                  bgColor: const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF43A047),
                  onTap: () => context.push('/catalog/products'),
                ),
                MenuCard(
                  icon: Icons.feedback_outlined,
                  bgColor: const Color(0xFFFFF3E0),
                  iconColor: const Color(0xFFFF8F00),
                  onTap: () => context.push('/my-reviews'),
                ),
                MenuCard(
                  icon: Icons.favorite,
                  bgColor: const Color(0xFFFCE4EC),
                  iconColor: const Color(0xFFE53935),
                  onTap: () => context.push('/wishlist'),
                ),
                MenuCard(
                  icon: Icons.local_activity,
                  bgColor: const Color(0xFFE0F7FA),
                  iconColor: const Color(0xFF00897B),
                  onTap: () => context.push('/vouchers'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection(List<Map<String, dynamic>> vouchers, AppLocalizations l) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.xs),
          padding: const EdgeInsets.fromLTRB(AppSizes.sm, AppSizes.md, AppSizes.sm, AppSizes.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.specialPromo, style: AppTextStyles.titleLarge),
              const SizedBox(height: AppSizes.sm),
              SizedBox(
                height: 140,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 0x3FFFFFFF,
                  itemBuilder: (context, index) {
                    final i = index % vouchers.length;
                    return VoucherCard(
                      voucher: vouchers[i],
                      onTap: () => context.push('/vouchers/${vouchers[i]['id']}', extra: vouchers[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogHeader(AppLocalizations l) {
    final sortOptions = [
      (l.newest, 'latest'),
      (l.priceAsc, 'price_asc'),
      (l.priceDesc, 'price_desc'),
      (l.highestRating, 'rating_desc'),
      (l.lowestRating, 'rating_asc'),
    ];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.recommendation, style: AppTextStyles.titleLarge),
              TextButton(
                onPressed: () => context.push('/catalog'),
                child: Text(
                  l.seeAll,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
: AppColors.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (_allCategories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: StyledCategoryDropdown(
                      value: _selectedCategoryId,
                      hint: '${l.all} ${l.category}',
                      categories: _allCategories,
                      onChanged: (v) => setState(() => _selectedCategoryId = v),
                    ),
                  ),
                StyledChoiceChip(
                  label: l.discount,
                  selected: _hasDiscountOnly,
                  onSelected: () => setState(() => _hasDiscountOnly = !_hasDiscountOnly),
                  icon: Icons.discount_outlined,
                ),
                const SizedBox(width: 6),
                StyledChoiceChip(
                  label: l.rating,
                  selected: _minRating > 0,
                  onSelected: _showRatingFilterDialog,
                  icon: Icons.star_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          StyledSortChips(
            options: sortOptions,
            selectedValue: _sortBy,
            onChanged: (v) => setState(() => _sortBy = v ?? 'latest'),
          ),
        ],
      );
  }

  Future<void> _showRatingFilterDialog() async {
    final l = AppLocalizations.of(context)!;
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final current = _minRating;
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    l.filterByRating,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                const Divider(height: 1),
                _buildRatingOption(0, ctx, current),
                _buildRatingOption(5.0, ctx, current),
                _buildRatingOption(4.0, ctx, current),
                _buildRatingOption(3.0, ctx, current),
                _buildRatingOption(2.0, ctx, current),
                _buildRatingOption(1.0, ctx, current),
              ],
            ),
          ),
        );
      },
    );
    if (result != null && mounted) {
      setState(() { _minRating = result; });
    }
  }

  Widget _buildRatingOption(double val, BuildContext sheetContext, double current) {
    final l = AppLocalizations.of(context)!;
    final isSelected = current == val;

    return ListTile(
      dense: true,
      title: val == 0
          ? Text(l.allRatings, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primaryTextColor : AppColors.textPrimary))
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (i) {
                final starIdx = i + 1;
                return Icon(
                  starIdx <= val ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 22,
                  color: starIdx <= val ? Colors.amber : AppColors.dividerColor,
                );
              }),
            ),
      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primaryColor, size: 20) : null,
      onTap: () => Navigator.pop(sheetContext, val),
    );
  }
}
