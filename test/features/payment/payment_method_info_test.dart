import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/payment/domain/payment_method_info/payment_method_info.dart';

/// QRIS statis toko.
///
/// Backend mengirim `qris_image_url` (gambar `public/images/qris/qris.jpg`),
/// tetapi server lama / respons cache bisa saja belum membawa field itu.
/// Test ini mengunci dua jalur supaya QRIS tidak pernah hilang dari layar
/// checkout hanya karena payload API belum diperbarui:
///
///   1. `qris_image_url` dari server dipakai apa adanya kalau ada.
///   2. Kalau null, [PaymentMethodInfo.fallbackQrisPath] tetap menunjuk
///      berkas statis yang sama dengan panel web.
void main() {
  group('PaymentMethodInfo - QRIS', () {
    test('membaca qris_image_url dari payload API', () {
      final method = PaymentMethodInfo.fromJson({
        'id': 7,
        'name': 'QRIS',
        'type': 'qris',
        'qris_image_url': 'https://api.contoh.test/images/qris/qris.jpg',
      });

      expect(method.isQris, isTrue);
      expect(method.qrisImageUrl, 'https://api.contoh.test/images/qris/qris.jpg');
      expect(method.qrisImage, 'https://api.contoh.test/images/qris/qris.jpg');
    });

    test('jatuh ke berkas statis saat qris_image_url tidak dikirim', () {
      final method = PaymentMethodInfo.fromJson({
        'id': 8,
        'name': 'QRIS',
        'type': 'qris',
      });

      expect(method.qrisImageUrl, isNull);
      expect(method.qrisImage, endsWith(PaymentMethodInfo.fallbackQrisPath));
      expect(PaymentMethodInfo.fallbackQrisPath, '/images/qris/qris.jpg');
    });

    test('path qris_image_url relatif tetap dijadikan URL penuh', () {
      final method = PaymentMethodInfo.fromJson({
        'id': 9,
        'name': 'QRIS',
        'type': 'qris',
        'qris_image_url': '/images/qris/qris.jpg',
      });

      expect(method.qrisImage, endsWith('/images/qris/qris.jpg'));
      expect(method.qrisImage, startsWith('http'));
    });

    test('metode non-QRIS tidak dianggap QRIS', () {
      final method = PaymentMethodInfo.fromJson({
        'id': 10,
        'name': 'Transfer Bank Manual',
        'type': 'bank_transfer',
      });

      expect(method.isQris, isFalse);
    });

    test('fee berbentuk string desimal tetap terbaca', () {
      final method = PaymentMethodInfo.fromJson({
        'id': 11,
        'name': 'QRIS',
        'type': 'qris',
        'fee': '2500.50',
      });

      expect(method.fee, 2500.5);
    });
  });
}
