abstract class OrderRepository {
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getOrders({
    String? status,
    String? paymentType,
    String? reviewStatus,
    int page = 1,
    int perPage = 10,
  });
  Future<Map<String, dynamic>> getOrderDetail(String id);
  Future<Map<String, dynamic>> updateOrder(
    String id,
    Map<String, dynamic> data,
  );
  Future<void> deleteOrder(String id);
  Future<Map<String, dynamic>> payOrder(String id);
  Future<void> cancelOrder(String id);
  Future<String> downloadInvoice(String id);
  Future<void> sendInvoiceEmail(String id);
  Future<Map<String, dynamic>> syncTracking(String id);
  Future<Map<String, dynamic>> confirmReceived(String id);
}
