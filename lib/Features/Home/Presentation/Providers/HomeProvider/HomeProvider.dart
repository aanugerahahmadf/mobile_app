import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Data/HomeRepositoryImpl/HomeRepositoryImpl.dart';
import '../../../Domain/HomeRepository/HomeRepository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl();
});

final homeDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getHomeData();
});
