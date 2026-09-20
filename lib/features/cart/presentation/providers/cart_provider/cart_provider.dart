import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/errors/app_error_codes/app_error_codes.dart';
import '../../../data/cart_repository_impl/cart_repository_impl.dart';
import '../../../domain/cart_repository/cart_repository.dart';
import '../../../../wishlist/presentation/providers/wishlist_provider/wishlist_provider.dart';
import '../../../../../core/providers/locale_provider/locale_provider.dart';
import '../../../../../core/utils/guest_mode/guest_mode.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';

const _cartCacheKey = 'cart_cache';

class CartState {
  final List<Map<String, dynamic>> items;
  final bool loading;
  final String? error;
  final Map<String, bool> selectedIds;

  CartState({
    this.items = const [],
    this.loading = false,
    this.error,
    this.selectedIds = const {},
  });

  CartState copyWith({
    List<Map<String, dynamic>>? items,
    bool? loading,
    String? error,
    Map<String, bool>? selectedIds,
  }) {
    return CartState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      error: error,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  List<Map<String, dynamic>> get selectedItems =>
      items.where((i) => selectedIds['${i['id']}'] == true).toList();

  int get subtotal {
    int total = 0;
    for (final item in items) {
      final qty = item['quantity'] as int? ?? 1;
      final itemData =
          (item['package'] ?? item['product']) as Map<String, dynamic>?;
      final rawPrice = itemData?['final_price'] ?? itemData?['price'];
      final price = (rawPrice is num ? rawPrice.toInt() : 0);
      total += price * qty;
    }
    return total;
  }

  int get selectedSubtotal {
    int total = 0;
    for (final item in selectedItems) {
      final qty = item['quantity'] as int? ?? 1;
      final itemData =
          (item['package'] ?? item['product']) as Map<String, dynamic>?;
      final rawPrice = itemData?['final_price'] ?? itemData?['price'];
      final price = (rawPrice is num ? rawPrice.toInt() : 0);
      total += price * qty;
    }
    return total;
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _repository;
  final Ref _ref;

  CartNotifier(this._repository, this._ref) : super(CartState());

  bool get _isGuest =>
      _ref.read(guestModeProvider).isGuest ||
      _ref.read(authProvider) is! AuthAuthenticated;

  Future<void> _cacheToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartCacheKey, jsonEncode(state.items));
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cartCacheKey);
    if (cached != null) {
      final items = List<Map<String, dynamic>>.from(jsonDecode(cached));
      if (items.isNotEmpty) {
        state = CartState(items: items);
      }
    }
  }

  Future<void> fetchCart() async {
    if (_isGuest) return;
    state = state.copyWith(loading: true, error: null);
    try {
      final items = await _repository.getCart();
      state = CartState(items: items, loading: false);
      _cacheToDisk();
    } on DioException catch (e) {
      await _loadFromCache();
      state = state.copyWith(
        loading: false,
        error: state.items.isEmpty
            ? (e.error?.toString() ?? AppErrorCodes.failedLoadCart)
            : null,
      );
    } catch (e) {
      await _loadFromCache();
      state = state.copyWith(
        loading: false,
        error: state.items.isEmpty ? e.toString() : null,
      );
    }
  }

  Future<bool> addItem({
    String? productId,
    String? packageId,
    int quantity = 1,
  }) async {
    if (_isGuest) return false;
    try {
      await _repository.addToCart(
        productId: productId,
        packageId: packageId,
        quantity: quantity,
      );
      await fetchCart();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateQty(String cartId, int quantity) async {
    if (_isGuest) return false;
    if (quantity < 1) {
      await removeItem(cartId);
      return true;
    }
    try {
      final updated = await _repository.updateQuantity(cartId, quantity);
      state = state.copyWith(
        items: state.items.map((item) {
          if ('${item['id']}' == cartId) return updated;
          return item;
        }).toList(),
      );
      _cacheToDisk();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> removeItem(String cartId) async {
    if (_isGuest) return null;
    final removedItem = state.items
        .where((item) => '${item['id']}' == cartId)
        .firstOrNull;
    try {
      await _repository.removeFromCart(cartId);
      state = state.copyWith(
        items: state.items.where((item) => '${item['id']}' != cartId).toList(),
        selectedIds: Map.from(state.selectedIds)..remove(cartId),
      );
      _cacheToDisk();
      return removedItem;
    } catch (e) {
      state = state.copyWith(error: AppErrorCodes.failedRemoveCartItem);
      return null;
    }
  }

  Future<void> restoreItem(Map<String, dynamic> item) async {
    if (_isGuest) return;
    final productId = item['product_id']?.toString();
    final packageId = item['package_id']?.toString();
    if (productId != null) {
      await addItem(
        productId: productId,
        quantity: item['quantity'] as int? ?? 1,
      );
    } else if (packageId != null) {
      await addItem(
        packageId: packageId,
        quantity: item['quantity'] as int? ?? 1,
      );
    }
  }

  Future<void> saveForLater(String cartId) async {
    if (_isGuest) return;
    final item = state.items.where((i) => '${i['id']}' == cartId).firstOrNull;
    if (item == null) return;
    final itemData =
        (item['package'] ?? item['product']) as Map<String, dynamic>?;
    if (itemData == null) return;
    final type = item['package'] != null ? 'packages' : 'products';
    final id = itemData['id']?.toString();
    if (id == null) return;
    _ref
        .read(wishlistProvider.notifier)
        .toggle(
          packageId: type == 'packages' ? id : null,
          productId: type == 'products' ? id : null,
        );
    await removeItem(cartId);
  }

  void toggleSelect(String cartId) {
    if (_isGuest) return;
    final current = Map<String, bool>.from(state.selectedIds);
    if (current[cartId] == true) {
      current.remove(cartId);
    } else {
      current[cartId] = true;
    }
    state = state.copyWith(selectedIds: current);
  }

  void toggleSelectAll() {
    if (_isGuest) return;
    if (state.selectedIds.length == state.items.length &&
        state.items.isNotEmpty) {
      state = state.copyWith(selectedIds: {});
    } else {
      final all = <String, bool>{};
      for (final item in state.items) {
        all['${item['id']}'] = true;
      }
      state = state.copyWith(selectedIds: all);
    }
  }

  Future<void> deleteSelected() async {
    if (_isGuest) return;
    for (final item in state.selectedItems) {
      await _repository.removeFromCart('${item['id']}');
    }
    state = state.copyWith(
      items: state.items
          .where((i) => state.selectedIds['${i['id']}'] != true)
          .toList(),
      selectedIds: {},
    );
    _cacheToDisk();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final notifier = CartNotifier(CartRepositoryImpl(), ref);
  ref.listen(localeProvider, (previous, next) => notifier.fetchCart());
  return notifier;
});
