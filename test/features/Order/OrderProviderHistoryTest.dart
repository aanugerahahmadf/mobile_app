import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Order/Domain/OrderRepository/OrderRepository.dart';
import 'package:mobile_app/Features/Order/Presentation/Providers/OrderProvider/OrderProvider.dart';

class _FakeOrderRepository implements OrderRepository {
  final List<Map<String, dynamic>> rows = [
    {
      'id': 1,
      'order_number': 'ORD-A',
      'status': 'pending',
      'payment_status': 'unpaid',
      'total_price': '1000000.00',
      'can_edit': true,
      'can_delete': true,
    },
    {
      'id': 2,
      'order_number': 'ORD-B',
      'status': 'completed',
      'payment_status': 'paid',
      'total_price': '2000000.00',
      'can_edit': false,
      'can_delete': false,
    },
  ];

  String? lastStatus;
  String? lastPaymentType;
  Map<String, dynamic>? lastUpdatePayload;
  String? deletedId;
  Object? failure;

  @override
  Future<List<Map<String, dynamic>>> getOrders({
    String? status,
    String? paymentType,
    int page = 1,
    int perPage = 10,
  }) async {
    lastStatus = status;
    lastPaymentType = paymentType;
    if (failure != null) throw failure!;
    return rows;
  }

  @override
  Future<Map<String, dynamic>> updateOrder(
    String id,
    Map<String, dynamic> data,
  ) async {
    lastUpdatePayload = data;
    if (failure != null) throw failure!;
    return {'id': int.parse(id), 'total_price': '3000000.00', 'quantity': 3};
  }

  @override
  Future<void> deleteOrder(String id) async {
    if (failure != null) throw failure!;
    deletedId = id;
    rows.removeWhere((o) => o['id'].toString() == id);
  }

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async =>
      rows.first;

  @override
  Future<Map<String, dynamic>> getOrderDetail(String id) async => rows.first;

  @override
  Future<Map<String, dynamic>> payOrder(String id) async => rows.first;

  @override
  Future<void> cancelOrder(String id) async {}

  @override
  Future<String> downloadInvoice(String id) async => '/tmp/invoice.pdf';

  @override
  Future<void> sendInvoiceEmail(String id) async {}
}

void main() {
  group('order history provider', () {
    late _FakeOrderRepository repo;
    late OrderNotifier notifier;

    setUp(() {
      repo = _FakeOrderRepository();
      notifier = OrderNotifier(repo);
    });

    test('fetch forwards status and payment type filters', () async {
      await notifier.fetchOrders(status: 'pending', paymentType: 'qris');

      expect(repo.lastStatus, 'pending');
      expect(repo.lastPaymentType, 'qris');
      expect(notifier.state.orders.length, 2);
      expect(notifier.state.loading, false);
    });

    test('update merges the server payload into its row', () async {
      await notifier.fetchOrders();

      final ok = await notifier.updateOrder('1', {'quantity': 3});

      expect(ok, true);
      expect(repo.lastUpdatePayload, {'quantity': 3});
      expect(notifier.state.orders.first['quantity'], 3);
      expect(notifier.state.orders.first['order_number'], 'ORD-A');
      expect(notifier.state.actionOrderId, null);
      expect(notifier.state.error, null);
    });

    test(
      'update keeps the row and surfaces the server message on failure',
      () async {
        await notifier.fetchOrders();
        repo.failure = DioException(
          requestOptions: RequestOptions(path: '/orders/1'),
          response: Response(
            requestOptions: RequestOptions(path: '/orders/1'),
            data: {'message': 'Stok tidak mencukupi'},
          ),
        );

        final ok = await notifier.updateOrder('1', {'quantity': 99});

        expect(ok, false);
        expect(notifier.state.error, 'Stok tidak mencukupi');
        expect(notifier.state.orders.length, 2);
        expect(notifier.state.actionOrderId, null);
      },
    );

    test('delete removes the row from history', () async {
      await notifier.fetchOrders();

      final ok = await notifier.deleteOrder('1');

      expect(ok, true);
      expect(repo.deletedId, '1');
      expect(notifier.state.orders.map((o) => o['id']), [2]);
    });

    test('a second action is ignored while one is in flight', () async {
      await notifier.fetchOrders();
      notifier.updateOrder('1', {'quantity': 2});

      expect(notifier.state.acting, true);
      expect(await notifier.deleteOrder('2'), false);
      expect(repo.deletedId, null);
    });
  });
}
