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
import '../../../../core/utils/number_utils.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../search/presentation/widgets/global_search_bar.dart';
import '../../../../features/catalog/data/catalog_repository_impl.dart';
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
      final repo = CatalogRepositoryImpl();
      final results = await Future.wait([
        repo.getPackages(page: 1),
        repo.getProducts(page: 1),
      ]);
      final packages = _extractList(results[0]).map((e) => e..['_type'] = 'packages').toList();
      final products = _extractList(results[1]).map((e) => e..['_type'] = 'products').toList();
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
        title: const Text('Pilih Tipe'),
        content: const Text('Apa yang ingin ditambahkan?'),
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
      body: Column(
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
                  else if (_combinedItems.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text(l.noProductsFound, style: AppTextStyles.bodyMedium)),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.xxl),
                      sliver: SliverToBoxAdapter(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(AppSizes.md),
                              child: Column(
                                children: [
                                  Row(
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
                                  const SizedBox(height: AppSizes.sm),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.55,
                                      crossAxisSpacing: AppSizes.md,
                                      mainAxisSpacing: AppSizes.sm,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSearchBar(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.xxl, AppSizes.md, AppSizes.sm),
      child: const GlobalSearchBar(),
    );
  }

  Widget _buildAdminWelcomeRow(BuildContext context, AppLocalizations l) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
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
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final unread = ref.watch(notificationListProvider).unreadCount;
                final notifColor = isDark ? Colors.white70 : AppColors.primaryColor;
                return Container(
                  decoration: BoxDecoration(
                    color: notifColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: unread > 0
                        ? Badge(
                            label: Text(unread > 99 ? '99+' : '$unread'),
                            child: Icon(Icons.notifications_outlined, color: notifColor),
                          )
                        : Icon(Icons.notifications_outlined, color: notifColor),
                    onPressed: () => context.push('/notifications'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomePageState extends ConsumerState<HomePage> {
  Map<String, dynamic>? _homeData;
  bool _loading = true;
  final _pageController = PageController();
  List<Map<String, dynamic>> _combinedItems = [];
  bool _catalogLoading = false;
  List<Map<String, dynamic>> _categories = [];
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
    _startAutoScroll();
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
      final repo = CatalogRepositoryImpl();
      final results = await Future.wait([
        repo.getPackages(page: 1),
        repo.getProducts(page: 1),
      ]);
      final packages = _extractList(results[0]).map((e) => e..['_type'] = 'packages').toList();
      final products = _extractList(results[1]).map((e) => e..['_type'] = 'products').toList();
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
      final res = await DioClient.instance.get(ApiEndpoints.categories);
      final data = res.data['data'];
      if (data is List && mounted) {
        setState(() => _categories = data.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final vouchers = _homeData?['vouchers'] as List? ?? [];
      if (vouchers.isEmpty) return;
      final next = (_pageController.page?.toInt() ?? 0) + 1;
      if (next < vouchers.length) {
        _pageController.animateToPage(next, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        _pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
      _startAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(authProvider) is AuthAuthenticated && (ref.watch(authProvider) as AuthAuthenticated).user.isAdmin) {
      return _AdminHome();
    }

    final l = AppLocalizations.of(context)!;
    final vouchers = (_homeData?['vouchers'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      body: _loading
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
                        else if (_filteredItems.isEmpty)
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.xxl),
                            sliver: SliverToBoxAdapter(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.all(AppSizes.md),
                                    child: Column(
                                      children: [
                                        _buildCatalogHeader(l),
                                        const SizedBox(height: AppSizes.sm),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.61,
                                            crossAxisSpacing: AppSizes.md,
                                            mainAxisSpacing: AppSizes.md,
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.xxl),
                            sliver: SliverToBoxAdapter(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.all(AppSizes.md),
                                    child: Column(
                                      children: [
                                        _buildCatalogHeader(l),
                                        const SizedBox(height: AppSizes.sm),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.61,
                                            crossAxisSpacing: AppSizes.md,
                                            mainAxisSpacing: AppSizes.md,
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.xxl, AppSizes.md, AppSizes.sm),
      child: const GlobalSearchBar(),
    );
  }

  Widget _buildWelcomeRow(AppLocalizations l) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
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
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final unread = ref.watch(notificationListProvider).unreadCount;
                final notifColor = isDark ? Colors.white70 : AppColors.primaryColor;
                return Container(
                  decoration: BoxDecoration(
                    color: notifColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: unread > 0
                        ? Badge(
                            label: Text(unread > 99 ? '99+' : '$unread'),
                            child: Icon(Icons.notifications_outlined, color: notifColor),
                          )
                        : Icon(Icons.notifications_outlined, color: notifColor),
                    onPressed: () => context.push('/notifications'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(AppLocalizations l) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
          padding: const EdgeInsets.fromLTRB(AppSizes.sm, AppSizes.md, AppSizes.sm, AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor.withAlpha(60),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: AppSizes.sm, bottom: AppSizes.sm),
                child: Text(l.services, style: AppTextStyles.titleLarge),
              ),
              Center(
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
                      icon: Icons.star,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherSection(List<Map<String, dynamic>> vouchers, AppLocalizations l) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
          padding: const EdgeInsets.fromLTRB(AppSizes.sm, AppSizes.md, AppSizes.sm, AppSizes.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
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
                  itemCount: vouchers.length,
                  itemBuilder: (context, index) => VoucherCard(
                    voucher: vouchers[index],
                    onTap: () => context.push('/vouchers/${vouchers[index]['id']}', extra: vouchers[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogHeader(AppLocalizations l) {
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
                        : AppColors.primaryColor,
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
                if (_categories.isNotEmpty)
                  Container(
                    height: 38,
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
                          const DropdownMenuItem(value: null, child: Text('Semua', style: TextStyle(fontSize: 12))),
                          ..._categories.map((c) {
                            final name = '${c['name']}'.replaceAll(RegExp(r'^(Paket |Produk )'), '');
                            return DropdownMenuItem(
                              value: '${c['id']}',
                              child: Text(name, style: const TextStyle(fontSize: 12)),
                            );
                          }),
                        ],
                        onChanged: (v) => setState(() => _selectedCategoryId = v),
                      ),
                    ),
                  ),
                const SizedBox(width: 6),
                FilterChip(
                  label: Text(l.discount, style: TextStyle(fontSize: 11, color: _hasDiscountOnly ? Colors.white : AppColors.textSecondary)),
                  selected: _hasDiscountOnly,
                  selectedColor: AppColors.primaryColor,
                  visualDensity: VisualDensity.compact,
                  onSelected: (v) => setState(() => _hasDiscountOnly = v),
                ),
                const SizedBox(width: 6),
                _buildRatingChip(l),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _sortChip('latest', l.newest),
                const SizedBox(width: 6),
                _sortChip('price_asc', l.priceAsc),
                const SizedBox(width: 6),
                _sortChip('price_desc', l.priceDesc),
                const SizedBox(width: 6),
                _sortChip('rating_desc', l.highestRating),
                const SizedBox(width: 6),
                _sortChip('rating_asc', l.lowestRating),
              ],
            ),
          ),
        ],
      );
  }

  Future<void> _showRatingFilterDialog() async {
    final l = AppLocalizations.of(context)!;
    final result = await showModalBottomSheet<double>(
      context: context,
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
          ? Text(l.allRatings, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primaryColor : AppColors.textPrimary))
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

  Widget _buildRatingChip(AppLocalizations l) {
    final hasFilter = _minRating > 0;
    return FilterChip(
      avatar: Icon(Icons.star_rounded, size: 16, color: hasFilter ? Colors.white : AppColors.textSecondary),
      label: Text(l.rating, style: TextStyle(fontSize: 11, color: hasFilter ? Colors.white : AppColors.textSecondary)),
      selected: hasFilter,
      selectedColor: AppColors.primaryColor,
      visualDensity: VisualDensity.compact,
      onSelected: (_) => _showRatingFilterDialog(),
    );
  }

  Widget _sortChip(String value, String label) {
    final selected = _sortBy == value;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 11, color: selected ? Colors.white : AppColors.textSecondary)),
      selected: selected,
      selectedColor: AppColors.primaryColor,
      visualDensity: VisualDensity.compact,
      onSelected: (_) => setState(() => _sortBy = value),
    );
  }
}
