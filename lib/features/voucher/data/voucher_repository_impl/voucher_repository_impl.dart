import '../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../core/api/dio_client/dio_client.dart';
import '../../domain/voucher_repository/voucher_repository.dart';
import '../models/voucher_model/voucher_model.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final _dio = DioClient.instance;

  @override
  Future<List<VoucherModel>> getVouchers() async {
    return DioClient.safeCall(() async {
      final response = await _dio.get(ApiEndpoints.vouchers);
      final data = response.data['data'] as List? ?? [];
      return data
          .map((e) => VoucherModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<bool> claimVoucher(String id) async {
    return DioClient.safeCall(() async {
      final response = await _dio.post(ApiEndpoints.voucherClaim(id));
      return response.statusCode == 200;
    });
  }
}
