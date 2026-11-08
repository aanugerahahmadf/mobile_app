import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../Domain/VoucherRepository/VoucherRepository.dart';
import '../Models/VoucherModel/VoucherModel.dart';

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
