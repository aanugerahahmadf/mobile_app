import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final cartState = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.cart),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: cartState.items.isNotEmpty
            ? [
                TextButton(
                  onPressed: () => notifier.toggleSelectAll(),
                  child: Text(
                    cartState.selectedIds.length == cartState.items.length
                        ? l.deselectAll
                        : l.selectAll,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryColor),
                  ),
                ),
              ]
            : null,
      ),
      body: cartState.loading
          ? const _CartShimmer()
          : cartState.error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(cartState.error ?? '', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 16),
                      AppButton(label: l.tryAgain, onPressed: () => notifier.fetchCart(), type: ButtonType.outline),
                    ],
                  ),
                )
              : cartState.items.isEmpty
                  ? AppEmptyState(title: l.cartEmpty, subtitle: l.cartEmptyDesc, icon: Icons.shopping_cart_outlined)
                  : Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => notifier.fetchCart(),
                            child: ListView.separated(
                              padding: const EdgeInsets.all(AppSizes.md),
                              itemCount: cartState.items.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = cartState.items[index];
                                final itemData = (item['package'] ?? item['product']) as Map<String, dynamic>? ?? {};
                                final qty = item['quantity'] as int? ?? 1;
                                final stock = Formatters.parsePrice(itemData['stock']);
                                final price = Formatters.parsePrice(itemData['final_price'] ?? itemData['price']);
                                final imageUrl = (itemData['image_url'] as String?) ?? '';
                                final name = itemData['name'] as String? ?? 'Item';
                                final cartId = '${item['id']}';
                                final isSelected = cartState.selectedIds[cartId] == true;
                                final isOutOfStock = stock < 1 || qty > stock;

                                return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => notifier.toggleSelect(cartId),
                                          child: Container(
                                            width: 22, height: 22,
                                            margin: const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected ? AppColors.primaryColor : Colors.transparent,
                                              border: Border.all(color: isSelected ? AppColors.primaryColor : AppColors.textTertiary),
                                            ),
                                            child: isSelected
                                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                                : null,
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            width: 80, height: 80,
                                            fit: BoxFit.cover,
                                            placeholder: (_, _) => Shimmer.fromColors(
                                              baseColor: AppColors.shimmerBase,
                                              highlightColor: AppColors.shimmerHighlight,
                                              child: Container(color: AppColors.surfaceColor),
                                            ),
                                            errorWidget: (_, _, _) => Container(
                                              color: AppColors.shimmerBase,
                                              child: Icon(Icons.broken_image, color: AppColors.textTertiary),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(name, style: AppTextStyles.bodyLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
                                              const SizedBox(height: 4),
                                              Text(Formatters.currency(price), style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryColor)),
                                              const SizedBox(height: 4),
                                              if (isOutOfStock)
                                                Text(l.outOfStock, style: AppTextStyles.labelSmall.copyWith(color: AppColors.errorColor))
                                              else if (stock <= 3 && stock > 0)
                                                Text(l.remainingStock(stock.toString()), style: AppTextStyles.labelSmall.copyWith(color: AppColors.warningColor)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.primaryColor),
                                                  iconSize: 20,
                                                  constraints: const BoxConstraints(),
                                                  padding: const EdgeInsets.all(4),
                                                  onPressed: qty > 1 ? () => notifier.updateQty(cartId, qty - 1) : null,
                                                ),
                                                Text('$qty', style: AppTextStyles.titleMedium),
                                                IconButton(
                                                  icon: const Icon(Icons.add_circle, color: AppColors.primaryColor),
                                                  iconSize: 20,
                                                  constraints: const BoxConstraints(),
                                                  padding: const EdgeInsets.all(4),
                                                  onPressed: qty < stock ? () => notifier.updateQty(cartId, qty + 1) : null,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            PopupMenuButton<String>(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              icon: Icon(Icons.more_vert, size: 18, color: AppColors.textSecondary),
                                              onSelected: (v) async {
                                                if (v == 'save') {
                                                  await notifier.saveForLater(cartId);
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text(l.itemMovedToWishlist), backgroundColor: AppColors.successColor),
                                                    );
                                                  }
                                                } else if (v == 'delete') {
                                                  final removed = await notifier.removeItem(cartId);
                                                  if (removed != null && context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(l.itemDeleted),
                                                        action: SnackBarAction(label: l.undo, onPressed: () => notifier.restoreItem(removed)),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                              itemBuilder: (_) => [
                                                PopupMenuItem(value: 'save', child: Row(children: [Icon(Icons.bookmark_border, size: 18), SizedBox(width: 8), Text(l.saveForLater)])),
                                                PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18), SizedBox(width: 8), Text(l.delete)])),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            boxShadow: [BoxShadow(color: AppColors.textTertiary.withValues(alpha: 0.15), blurRadius: 10, offset: const Offset(0, -2))],
                          ),
                          child: SafeArea(
                            child: Column(
                              children: [
                                if (cartState.selectedItems.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(l.itemsSelected(cartState.selectedItems.length.toString()), style: AppTextStyles.bodySmall),
                                      GestureDetector(
                                        onTap: () => notifier.deleteSelected(),
                                        child: Text(l.deleteAll, style: AppTextStyles.bodySmall.copyWith(color: AppColors.errorColor)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(l.subtotal, style: AppTextStyles.bodyMedium),
                                    Text(Formatters.currency(cartState.subtotal), style: AppTextStyles.titleMedium),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                AppButton(
                                  label: l.proceedToCheckout,
                                  onPressed: cartState.items.isEmpty ? null : () => context.push('/checkout'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}

class _CartShimmer extends StatelessWidget {
  const _CartShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: 3,
      itemBuilder: (_, _) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: AppColors.shimmerBase,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              height: 100,
              decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(12)),
            ),
          ),
      ),
    );
  }
}
