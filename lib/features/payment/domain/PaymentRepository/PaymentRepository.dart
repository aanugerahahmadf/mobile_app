abstract class PaymentRepository {
  Future<Map<String, dynamic>> confirmPayment(
    String orderId,
    int paymentMethodId, {
    Map<String, dynamic>? cardDetails,
  });
  Future<Map<String, dynamic>> payWithGateway(
    String orderId,
    int paymentMethodId,
  );
  Future<Map<String, dynamic>> createVirtualAccount(String orderId);
  Future<Map<String, dynamic>> createQris(String orderId);
  Future<List<Map<String, dynamic>>> getPaymentMethods(String orderId);
  Future<Map<String, dynamic>> uploadProof(String orderId, List<String> paths);
}
