import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../catalog/presentation/widgets/product_card.dart';
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
    final state = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Favorit')),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? AppErrorState(message: state.error!, onRetry: () => ref.read(wishlistProvider.notifier).fetchWishlist())
              : state.items.isEmpty
                  ? AppEmptyState(
                      icon: Icons.favorite_border,
                      title: 'Belum ada favorit',
                      subtitle: 'Tambahkan paket atau bunga favorit Anda',
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(wishlistProvider.notifier).fetchWishlist(),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(AppSizes.md),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.61,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: state.items.length,
                        itemBuilder: (_, i) {
                          final item = state.items[i];
                          final isPackage = item['package'] != null;
                          final type = isPackage ? 'packages' : 'products';
                          final pkg = (item['package'] ?? item['product']) as Map<String, dynamic>? ?? {};

                          return Stack(
                            children: [
                              Positioned.fill(
                                child: ProductCard(
                                  item: pkg,
                                  type: type,
                                  onTap: () => context.go('/catalog/$type/${pkg['id']}'),
                                ),
                              ),
                              Positioned(
                                top: 6, right: 6,
                                child: GestureDetector(
                                  onTap: () => ref.read(wishlistProvider.notifier).remove(item),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
                                      ],
                                    ),
                                    child: const Icon(Icons.close, size: 16, color: AppColors.errorColor),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
    );
  }
}
