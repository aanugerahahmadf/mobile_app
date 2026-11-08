import '../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../Core/Api/DioClient/DioClient.dart';
import '../Domain/HistoryRepository.dart';
import 'Models/HistoryModel.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final _dio = DioClient.instance;

  @override
  Future<List<HistoryModel>> getHistory() async {
    return DioClient.safeCall(() async {
      final response = await _dio.get(ApiEndpoints.walletHistory);
      final data = response.data['data'] as List? ?? [];
      return data
          .map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}
