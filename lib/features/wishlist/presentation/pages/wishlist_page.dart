import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../catalog/presentation/widgets/combined_card.dart';
import '../../../catalog/data/models/item_model.dart';
import '../providers/wishlist_provider.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(wishlistProvider.notifier).fetchWishlist());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.favorites), backgroundColor: Colors.transparent, elevation: 0),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? AppErrorState(message: LocalizedError.of(l, state.error!), onRetry: () => ref.read(wishlistProvider.notifier).fetchWishlist())
              : state.items.isEmpty
                  ? AppEmptyState(
                      icon: Icons.favorite_border,
                      title: l.noFavorites,
                      subtitle: l.exploreCatalog,
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(wishlistProvider.notifier).fetchWishlist(),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(AppSizes.md),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.61,
                          crossAxisSpacing: AppSizes.xs,
                          mainAxisSpacing: AppSizes.xs,
                        ),
                        itemCount: state.items.length,
                        itemBuilder: (_, i) {
                          final item = Map<String, dynamic>.from(state.items[i]);
                          final resourceType = item['resource_type'] as String? ?? 'product';
                          final type = resourceType == 'package' ? 'packages' : 'products';
                          final itemId = item['product_id'] ?? item['package_id'] ?? item['id'];
                          if (item['id'] == null && itemId != null) {
                            item['id'] = itemId;
                          }

                          return CombinedCard(
                            item: ItemModel.fromJson(item),
                            type: type,
                            onTap: () => context.go('/catalog/$type/$itemId'),
                          );
                        },
                      ),
                    ),
    );
  }
}
