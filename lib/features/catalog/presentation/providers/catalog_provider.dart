import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/catalog_repository_impl/catalog_repository_impl.dart';
import '../../domain/catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepositoryImpl();
});

final catalogPackageListProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repo = ref.watch(catalogRepositoryProvider);
      return repo.getPackages(
        categoryId: params['category_id']?.toString(),
        search: params['search']?.toString(),
        sort: params['sort']?.toString(),
      );
    });

final catalogProductListProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repo = ref.watch(catalogRepositoryProvider);
      return repo.getProducts(
        categoryId: params['category_id']?.toString(),
        search: params['search']?.toString(),
        sort: params['sort']?.toString(),
      );
    });

final catalogDetailProvider =
    FutureProvider.family<Map<String, dynamic>, ({String type, String id})>((
      ref,
      params,
    ) async {
      final repo = ref.watch(catalogRepositoryProvider);
      if (params.type == 'packages') {
        return repo.getPackageDetail(params.id);
      }
      return repo.getProductDetail(params.id);
    });
