import '../../../../../core/widgets/app_blur_backdrop/app_blur_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/utils/guest_mode/guest_mode.dart';
import '../../../../../core/widgets/app_filter_widgets/app_filter_widgets.dart';
import '../../../../../core/utils/number_utils/number_utils.dart';
import '../../../../../core/widgets/app_shimmer/app_shimmer.dart';
import '../../../../search/presentation/widgets/global_search_bar/global_search_bar.dart';
import '../../../../catalog/data/models/item_model/item_model.dart';
import '../../../../catalog/presentation/widgets/combined_card/combined_card.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../auth/presentation/widgets/auth_modals/auth_modals.dart';
import '../../../../notification/presentation/providers/notification_provider/notification_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../widgets/menu_card/menu_card.dart';
import '../../widgets/voucher_card/voucher_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Map<String, dynamic>? _homeData;
  bool _loading = true;
  final _pageController = PageController(initialPage: 0x3FFFFFFF ~/ 2);
  List<Map<String, dynamic>> _combinedItems = [];
  bool _catalogLoading = false;
  List<Map<String, dynamic>> _catalogCategories = [];
  String? _selectedCategoryId;
  bool _hasDiscountOnly = false;
  double _minRating = 0;
  String _sortBy = 'latest';

  double _effectiveItemPrice(Map<String, dynamic> json) {
    final item = ItemModel.fromJson(json);
    return item.displayPrice;
  }

  bool _itemHasTierDiscount(Map<String, dynamic> json) {
    final item = ItemModel.fromJson(json);
    return item.startingTier?.hasDiscount == true || item.hasDiscount;
  }

  List<Map<String, dynamic>> get _filteredItems {
    var items = List<Map<String, dynamic>>.from(_combinedItems);

    if (_selectedCategoryId != null) {
      items = items
          .where((e) => '${e['category_id']}' == _selectedCategoryId)
          .toList();
    }
    if (_hasDiscountOnly) {
      items = items
          .where(
            (e) =>
                _itemHasTierDiscount(e),
          )
          .toList();
    }
    if (_minRating > 0) {
      items = items.where((e) {
        final rating = (e['average_rating'] ?? e['rating'] as dynamic) is num
            ? ((e['average_rating'] ?? e['rating']) as num).toDouble()
            : null;
        return rating != null && rating.round() == _minRating.toInt();
      }).toList();
    }

    switch (_sortBy) {
      case 'price_asc':
        items.sort(
          (a, b) => _effectiveItemPrice(a).compareTo(_effectiveItemPrice(b)),
        );
      case 'price_desc':
        items.sort(
          (a, b) => _effectiveItemPrice(b).compareTo(_effectiveItemPrice(a)),
        );
      case 'rating_desc':
        items.sort((a, b) {
          final ra = (a['average_rating'] ?? a['rating'] as dynamic) is num
              ? ((a['average_rating'] ?? a['rating']) as num).toDouble()
              : 0;
          final rb = (b['average_rating'] ?? b['rating'] as dynamic) is num
              ? ((b['average_rating'] ?? b['rating']) as num).toDouble()
              : 0;
          return rb.compareTo(ra);
        });
      case 'rating_asc':
        items.sort((a, b) {
          final ra = (a['average_rating'] ?? a['rating'] as dynamic) is num
              ? ((a['average_rating'] ?? a['rating']) as num).toDouble()
              : 0;
          final rb = (b['average_rating'] ?? b['rating'] as dynamic) is num
              ? ((b['average_rating'] ?? b['rating']) as num).toDouble()
              : 0;
          return ra.compareTo(rb);
        });
      case 'most_ordered':
        items.sort(
          (a, b) => parseInt(
            b['ordered_count'],
          ).compareTo(parseInt(a['ordered_count'])),
        );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _fetchHome();
    _fetchCatalog();
    _fetchCategories();
    if (ref.read(authProvider) is AuthAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(notificationListProvider.notifier).fetchUnreadCount();
      });
    }
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
      final res = await DioClient.instance.get(
        ApiEndpoints.catalog,
        queryParameters: {'per_page': 'all'},
      );
      _combinedItems = _extractList(res.data)..shuffle();
    } catch (_) {}
    if (mounted) setState(() => _catalogLoading = false);
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> _fetchCategories() async {
    try {
      final res = await DioClient.instance.get(ApiEndpoints.categories);
      final data = res.data['data'];
      if (data is List && mounted) {
        setState(() => _catalogCategories = data.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
  }

  List<Map<String, dynamic>> get _allCategories => _catalogCategories;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final vouchers =
        (_homeData?['vouchers'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? const [Color(0xFF0F2440), Color(0xFF1A1A2E)]
                : const [Color(0xFFEEF2FF), Color(0xFFF8F6F7)],
          ),
        ),
        child: SafeArea(
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
                          if (vouchers.isNotEmpty)
                            SliverToBoxAdapter(
                              child: _buildVoucherSection(vouchers, l),
                            ),
                          if (_catalogLoading && _combinedItems.isEmpty)
                            const SliverPadding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.md,
                              ),
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
                                child: AppBlurBackdrop(
                                  borderRadius: 16,
                                  padding: const EdgeInsets.all(AppSizes.md),
                                  child: _buildCatalogHeader(l),
                                ),
                              ),
                            ),
                            if (_filteredItems.isEmpty)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text(
                                    l.noCatalogsFound,
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                              )
                            else
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSizes.md,
                                  0,
                                  AppSizes.md,
                                  AppSizes.xxl,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.61,
                                          crossAxisSpacing: AppSizes.xs,
                                          mainAxisSpacing: AppSizes.xs,
                                        ),
                                    itemCount: _filteredItems.length,
                                    itemBuilder: (_, i) {
                                      final item = _filteredItems[i];
                                      return CombinedCard(
                                        item: ItemModel.fromJson(item),
                                        onTap: () => context.push(
                                          '/catalog/${item['id']}',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 32),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.md,
      ),
      child: const GlobalSearchBar(),
    );
  }

  Widget _buildWelcomeRow(AppLocalizations l) {
    return AppBlurBackdrop(
      margin: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, 0),
      borderRadius: 16,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.sm,
        AppSizes.sm,
        AppSizes.sm,
        AppSizes.sm,
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final guestFlag = ref.watch(guestModeProvider).isGuest;
          final isGuest =
              guestFlag && ref.read(authProvider) is! AuthAuthenticated;
          if (!isGuest) {
            return Row(
              children: [
                Consumer(
                  builder: (_, ref, _) {
                    final authState = ref.watch(authProvider);
                    if (authState is AuthAuthenticated) {
                      final u = authState.user;
                      final avatarUrl = u.avatarUrl;
                      final hasAvatar =
                          avatarUrl != null && avatarUrl.isNotEmpty;
                      return GestureDetector(
                        onTap: () => context.push('/edit-profile'),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryColor.withAlpha(25),
                          backgroundImage: hasAvatar
                              ? CachedNetworkImageProvider(avatarUrl)
                              : null,
                          child: !hasAvatar
                              ? Icon(
                                  Icons.person,
                                  color: AppColors.primaryColor,
                                  size: 22,
                                )
                              : null,
                        ),
                      );
                    }
                    return CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primaryColor.withAlpha(25),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                        size: 22,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l.welcome},',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Consumer(
                        builder: (_, ref, _) {
                          final authState = ref.watch(authProvider);
                          final name = authState is AuthAuthenticated
                              ? authState.user.fullName
                              : '';
                          return Text(
                            name,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Consumer(
                  builder: (_, ref, _) {
                    final unread = ref
                        .watch(notificationListProvider)
                        .unreadCount;
                    return IconButton(
                      icon: unread > 0
                          ? Badge(
                              label: Text(unread > 99 ? '99+' : '$unread'),
                              child: const Icon(Icons.notifications_outlined),
                            )
                          : const Icon(Icons.notifications_outlined),
                      onPressed: () => context.push('/notifications'),
                    );
                  },
                ),
              ],
            );
          }
          // â”€â”€ Mode tamu: welcome "Tamu" + tombol Sign In / Sign Up â”€â”€
          return Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryColor.withAlpha(25),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l.welcome},',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      l.guestName,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => showSignInSheet(context),
                    child: Text(
                      l.signIn,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  FilledButton(
                    onPressed: () => showSignUpSheet(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    child: Text(l.signUp),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(AppLocalizations l) {
    return AppBlurBackdrop(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.xs,
      ),
      borderRadius: 16,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.sm,
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.sm,
              bottom: AppSizes.sm,
            ),
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
                  onTap: () => context.push('/catalog'),
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

  Widget _buildVoucherSection(
    List<Map<String, dynamic>> vouchers,
    AppLocalizations l,
  ) {
    return AppBlurBackdrop(
      borderRadius: 16,
      margin: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.xs,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSizes.sm,
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
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
                  onTap: () => context.push(
                    '/vouchers/${vouchers[i]['id']}',
                    extra: vouchers[i],
                  ),
                );
              },
            ),
          ),
        ],
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
                onSelected: () =>
                    setState(() => _hasDiscountOnly = !_hasDiscountOnly),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
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
      setState(() {
        _minRating = result;
      });
    }
  }

  Widget _buildRatingOption(
    double val,
    BuildContext sheetContext,
    double current,
  ) {
    final l = AppLocalizations.of(context)!;
    final isSelected = current == val;

    return ListTile(
      dense: true,
      title: val == 0
          ? Text(
              l.allRatings,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppColors.primaryTextColor
                    : AppColors.textPrimary,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (i) {
                final starIdx = i + 1;
                return Icon(
                  starIdx <= val
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  size: 22,
                  color: starIdx <= val ? Colors.amber : AppColors.dividerColor,
                );
              }),
            ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: AppColors.primaryColor,
              size: 20,
            )
          : null,
      onTap: () => Navigator.pop(sheetContext, val),
    );
  }
}
