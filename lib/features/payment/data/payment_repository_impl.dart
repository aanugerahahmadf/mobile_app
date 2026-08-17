import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../domain/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final Dio _dio;

  PaymentRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<Map<String, dynamic>> confirmPayment(
    String orderId,
    int paymentMethodId, {
    Map<String, dynamic>? cardDetails,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.orderConfirmPayment(orderId),
      data: {
        'payment_method_id': paymentMethodId,
        ...?cardDetails,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> payWithGateway(String orderId, int paymentMethodId) async {
    final response = await _dio.post(
      ApiEndpoints.bookingPay(orderId),
      data: {'payment_method_id': paymentMethodId},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> createVirtualAccount(String orderId) async {
    final response = await _dio.post(
      ApiEndpoints.orderVirtualAccount(orderId),
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> createQris(String orderId) async {
    final response = await _dio.post(
      ApiEndpoints.orderQris(orderId),
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<List<Map<String, dynamic>>> getPaymentMethods(String orderId) async {
    final response = await _dio.get(ApiEndpoints.bookingDetail(orderId));
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final methods = data['payment_methods'] as List<dynamic>? ?? [];
    return methods.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> uploadProof(String orderId, List<String> paths) async {
    final formData = FormData.fromMap({
      'proof_images': [
        for (final path in paths) await MultipartFile.fromFile(path),
      ],
    });
    final response = await _dio.post(
      ApiEndpoints.bookingUploadProof(orderId),
      data: formData,
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
