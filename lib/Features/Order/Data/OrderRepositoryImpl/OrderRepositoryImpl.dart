import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../Domain/OrderRepository/OrderRepository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final Dio _dio;

  OrderRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Map<String, dynamic> _data(Map<String, dynamic>? resp) {
    final d = resp?['data'];
    if (d is Map<String, dynamic>) return d;
    if (d is List) return {'items': d, 'data': resp};
    return resp ?? {};
  }

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.bookings, data: data);
    return _data(response.data as Map<String, dynamic>?);
  }

  @override
  Future<List<Map<String, dynamic>>> getOrders({
    String? status,
    String? paymentType,
    int page = 1,
    int perPage = 10,
  }) async {
    final query = <String, dynamic>{'page': page, 'per_page': perPage};
    if (status != null) query['status'] = status;
    if (paymentType != null) query['payment_type'] = paymentType;
    final response = await _dio.get(
      ApiEndpoints.bookings,
      queryParameters: query,
    );
    final resp = response.data as Map<String, dynamic>?;
    final list = resp?['data'];
    if (list is List) return list.cast<Map<String, dynamic>>();
    return [];
  }

  @override
  Future<Map<String, dynamic>> getOrderDetail(String id) async {
    final response = await _dio.get(ApiEndpoints.bookingDetail(id));
    return _data(response.data as Map<String, dynamic>?);
  }

  @override
  Future<Map<String, dynamic>> updateOrder(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(ApiEndpoints.bookingDetail(id), data: data);
    return _data(response.data as Map<String, dynamic>?);
  }

  @override
  Future<void> deleteOrder(String id) async {
    await _dio.delete(ApiEndpoints.bookingDetail(id));
  }

  @override
  Future<Map<String, dynamic>> payOrder(String id) async {
    final response = await _dio.post(ApiEndpoints.bookingPay(id));
    return _data(response.data as Map<String, dynamic>?);
  }

  @override
  Future<void> cancelOrder(String id) async {
    await _dio.post(ApiEndpoints.bookingCancel(id));
  }

  @override
  Future<String> downloadInvoice(String id) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/invoice_$id.pdf';
    await _dio.download(
      ApiEndpoints.invoiceDownload(id),
      filePath,
      options: Options(responseType: ResponseType.bytes),
    );
    return filePath;
  }

  @override
  Future<void> sendInvoiceEmail(String id) async {
    await _dio.post(ApiEndpoints.invoiceEmail(id));
  }
}
