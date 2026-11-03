import 'package:dio/dio.dart';
import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';
import '../../Domain/CartRepository/CartRepository.dart';

class CartRepositoryImpl implements CartRepository {
  final Dio _dio;

  CartRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<List<Map<String, dynamic>>> getCart() async {
    final response = await _dio.get(ApiEndpoints.cart);
    return (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  @override
  Future<Map<String, dynamic>> addToCart({
    String? catalogId,
    String? packageId,
    int quantity = 1,
  }) async {
    if (catalogId == null || packageId == null) {
      throw ArgumentError('catalogId dan packageId/Tier wajib diisi');
    }
    final body = <String, dynamic>{'quantity': quantity};
    body['catalog_id'] = catalogId;
    body['package_id'] = packageId;
    final response = await _dio.post(ApiEndpoints.cartAdd, data: body);
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateQuantity(
    String cartId,
    int quantity,
  ) async {
    final response = await _dio.put(
      ApiEndpoints.cartItem(cartId),
      data: {'quantity': quantity},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<void> removeFromCart(String cartId) async {
    await _dio.delete(ApiEndpoints.cartItem(cartId));
  }
}
