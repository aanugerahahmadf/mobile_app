import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Errors/LocalizedError/LocalizedError.dart';
import '../../../../../Core/Widgets/AppEmptyState/AppEmptyState.dart';
import '../../../../../Core/Widgets/AppErrorState/AppErrorState.dart';
import '../../../../../Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import '../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import '../../../../Catalog/Presentation/Widgets/CombinedCard/CombinedCard.dart';
import '../../../../Catalog/Data/Models/ItemModel/ItemModel.dart';
import '../../Providers/FavoriteProvider/FavoriteProvider.dart';

class Favoritescreen extends ConsumerStatefulWidget {
  const Favoritescreen({super.key});

  @override
  ConsumerState<Favoritescreen> createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<Favoritescreen> {
  Future<void> _fetchFavoriteIfAuthenticated() async {
    if (ref.read(authProvider) is! AuthAuthenticated) return;
    await ref.read(favoriteProvider.notifier).fetchFavorite();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchFavoriteIfAuthenticated);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isAuthenticated = ref.watch(authProvider) is AuthAuthenticated;
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.favorites),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const GuestAuthPrompt(icon: Icons.favorite_border),
      );
    }
    final state = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.favorites),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? AppErrorState(
              message: LocalizedError.of(l, state.error!),
              onRetry: _fetchFavoriteIfAuthenticated,
            )
          : state.items.isEmpty
          ? AppEmptyState(
              icon: Icons.favorite_border,
              title: l.noFavorites,
              subtitle: l.exploreCatalog,
            )
          : RefreshIndicator(
              onRefresh: _fetchFavoriteIfAuthenticated,
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
                  // Favorite lama masih menyimpan `id` baris, bukan id katalog;
                  // fallback ke `catalog_id` supaya kartu tetap bisa dibuka.
                  final catalogId =
                      item['catalog_id'] ?? item['id'];
                  if (item['id'] == null && catalogId != null) {
                    item['id'] = catalogId;
                  }

                  return CombinedCard(
                    item: ItemModel.fromJson(item),
                    type: 'catalog',
                    onTap: () => context.go('/catalog/$catalogId'),
                  );
                },
              ),
            ),
    );
  }
}

typedef FavoriteScreen = Favoritescreen;
