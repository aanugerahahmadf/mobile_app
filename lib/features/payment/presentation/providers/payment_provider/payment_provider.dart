import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/payment_repository_impl/payment_repository_impl.dart';
import '../../../domain/payment_repository/payment_repository.dart';

class PaymentState {
  final bool loading;
  final String? error;
  final Map<String, dynamic>? transaction;
  final Map<String, dynamic>? virtualAccount;
  final bool proofUploaded;

  const PaymentState({
    this.loading = false,
    this.error,
    this.transaction,
    this.virtualAccount,
    this.proofUploaded = false,
  });

  PaymentState copyWith({
    bool? loading,
    String? error,
    Map<String, dynamic>? transaction,
    Map<String, dynamic>? virtualAccount,
    bool? proofUploaded,
  }) {
    return PaymentState(
      loading: loading ?? this.loading,
      error: error,
      transaction: transaction ?? this.transaction,
      virtualAccount: virtualAccount ?? this.virtualAccount,
      proofUploaded: proofUploaded ?? this.proofUploaded,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository _repository;

  PaymentNotifier(this._repository) : super(const PaymentState());

  Future<bool> confirmPayment(
    String orderId,
    int paymentMethodId, {
    Map<String, dynamic>? cardDetails,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await _repository.confirmPayment(
        orderId,
        paymentMethodId,
        cardDetails: cardDetails,
      );
      state = PaymentState(loading: false, transaction: data);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error:
            e.response?.data?['message']?.toString() ??
            e.error?.toString() ??
            'Gagal konfirmasi pembayaran',
      );
      return false;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  Future<String?> payWithGateway(String orderId, int paymentMethodId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await _repository.payWithGateway(orderId, paymentMethodId);
      state = state.copyWith(loading: false, transaction: data);
      return data['redirect_url'] as String? ?? data['snap_token'] as String?;
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error:
            e.response?.data?['message']?.toString() ??
            e.error?.toString() ??
            'Gagal memproses pembayaran',
      );
      return null;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return null;
    }
  }

  Future<bool> uploadProof(String orderId, List<String> paths) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await _repository.uploadProof(orderId, paths);
      state = PaymentState(
        loading: false,
        transaction: data,
        proofUploaded: true,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error:
            e.response?.data?['message']?.toString() ??
            e.error?.toString() ??
            'Gagal upload bukti pembayaran',
      );
      return false;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>?> createVirtualAccount(String orderId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await _repository.createVirtualAccount(orderId);
      state = state.copyWith(loading: false, virtualAccount: data);
      return data;
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error:
            e.response?.data?['message']?.toString() ??
            e.error?.toString() ??
            'Gagal membuat Virtual Account',
      );
      return null;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> createQris(String orderId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await _repository.createQris(orderId);
      state = state.copyWith(loading: false, virtualAccount: data);
      return data;
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error:
            e.response?.data?['message']?.toString() ??
            e.error?.toString() ??
            'Gagal membuat QRIS',
      );
      return null;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return null;
    }
  }

  void reset() {
    state = const PaymentState();
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((
  ref,
) {
  return PaymentNotifier(PaymentRepositoryImpl());
});
