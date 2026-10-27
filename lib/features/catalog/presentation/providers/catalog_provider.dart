import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/catalog_repository_impl/catalog_repository_impl.dart';
import '../../domain/catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepositoryImpl();
});

final catalogListProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repo = ref.watch(catalogRepositoryProvider);
      return repo.getCatalog(
        categoryId: params['category_id']?.toString(),
        search: params['search']?.toString(),
        sort: params['sort']?.toString(),
        perPage: int.tryParse('${params['per_page'] ?? ''}'),
      );
    });

final catalogDetailProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
      final repo = ref.watch(catalogRepositoryProvider);
      return repo.getCatalogDetail(id);
    });

final catalogTiersProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
      final repo = ref.watch(catalogRepositoryProvider);
      return repo.getCatalogTiers(id);
    });
