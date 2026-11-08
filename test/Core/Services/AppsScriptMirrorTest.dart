import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Core/Api/AppsScriptClient/AppsScriptClient.dart';
import 'package:mobile_app/Core/Api/AppsScriptClient/AppsScriptMirror.dart';
import 'package:mobile_app/Features/Order/Data/Models/OrderModel/OrderModel.dart';
import 'package:mobile_app/Features/Review/Data/Models/ReviewModel/ReviewModel.dart';

/// Pembentuk baris mirror Flutter harus tetap di dalam kolom registry
/// `apps_script/Config.gs`. Daftar di bawah disalin dari registry itu; kalau
/// kolomnya berubah di Apps Script dan tidak di sini, test ini yang berbunyi —
/// bukan sheet yang kebanjiran kolom asing yang diam-diam dibuang.
void main() {
  const orderColumns = <String>{
    'order_id',
    'order_number',
    'user_id',
    'customer_name',
    'customer_phone',
    'package_name',
    'quantity',
    'unit_price',
    'total_amount',
    'status',
    'payment_status',
    'payment_type',
    'va_number',
    'qris_payload',
    'payment_deadline',
    'event_date',
    'event_time',
    'event_location',
    'notes',
    'source',
    'observed_at',
  };

  const reviewColumns = <String>{
    'review_id',
    'catalog_id',
    'user_id',
    'rating',
    'title',
    'comment',
    'has_media',
    'media_paths',
    'is_verified_purchase',
    'locale',
    'source',
    'observed_at',
  };

  OrderModel order() {
    return const OrderModel(
      id: 77,
      userId: 12,
      userName: 'Rina',
      title: 'Paket Pelaminan White Rose',
      orderNumber: 'INV-77',
      totalPrice: 1500000,
      subtotal: 1500000,
      status: 'Pending',
      paymentStatus: 'unpaid',
      eventDate: '2026-12-20',
      bookingTime: '10:00:00',
      quantity: 2,
      locationAddress: 'Ballroom Hotel Indonesia',
      notes: '  ',
      vaNumber: '8801234567890',
      paymentMethod: 'virtual_account',
    );
  }

  ReviewModel review() {
    return const ReviewModel(
      id: 5,
      userId: 12,
      catalogId: 31,
      rating: 5,
      title: 'Suka hasilnya',
      comment: 'Bunga segar dan pemasangan tepat waktu.',
    );
  }

  group('AppsScriptMirror — kontrak kolom registry', () {
    test('baris order hanya memakai kolom yang punya tempat di sheet', () {
      final row = AppsScriptMirror.orderRow(order());
      expect(row.keys.toSet().difference(orderColumns), isEmpty);
      expect(row['order_number'], 'INV-77');
      expect(row['status'], 'pending', reason: 'status dinormalisasi lowercase');
      expect(row['event_date'], '2026-12-20');
      expect(row['source'], 'flutter');
    });

    test('nomor uang selalu string, bukan double', () {
      final row = AppsScriptMirror.orderRow(order());
      expect(row['total_amount'], '1500000');
      expect(row['total_amount'], isA<String>());
      expect(row['unit_price'], '1500000');
    });

    test(
      'kolom bernilai kosong dibuang, bukan dikirim sebagai string kosong',
      () {
        final row = AppsScriptMirror.orderRow(order());
        expect(
          row.containsKey('notes'),
          isFalse,
          reason: 'notes hanya spasi harus hilang',
        );
        expect(row.values.whereType<String>().where((v) => v.isEmpty), isEmpty);
      },
    );

    test('baris perangkat tidak memuat kredensial pembayaran', () {
      // AGENTS.md §7: nomor VA dan QRIS adalah urusan server. OrderModel
      // membawanya, mirror Flutter tidak.
      final row = AppsScriptMirror.orderRow(order());
      expect(row.containsKey('va_number'), isFalse);
      expect(row.containsKey('qris_payload'), isFalse);
      expect(row.containsKey('payment_deadline'), isFalse);
      expect(row.containsKey('payment_type'), isFalse);
      expect(
        row.values.map((v) => v.toString()),
        isNot(contains('8801234567890')),
      );
    });

    test('baris review memakai kolom registry dan sumber flutter', () {
      final row = AppsScriptMirror.reviewRow(review(), locale: 'id');
      expect(row.keys.toSet().difference(reviewColumns), isEmpty);
      expect(row['review_id'], 5);
      expect(row['catalog_id'], 31);
      expect(row['rating'], 5);
      expect(row['source'], 'flutter');
      expect(row['locale'], 'id');
    });

    test('komentar panjang dipotong sampai batas kolom', () {
      final long = ReviewModel(
        id: 6,
        userId: 12,
        catalogId: 31,
        rating: 4,
        comment: 'a' * 9000,
      );
      final row = AppsScriptMirror.reviewRow(long);
      expect((row['comment']! as String).length, 4000);
    });

    test('user_id nol dianggap tidak dikenal dan tidak dikirim', () {
      final anonymous = ReviewModel(id: 7, userId: 0, catalogId: 31, rating: 3);
      expect(
        AppsScriptMirror.reviewRow(anonymous).containsKey('user_id'),
        isFalse,
      );
    });
  });

  group('AppsScriptMirror — aman saat integrasi mati', () {
    test('pushOrder dan pushReview no-op tanpa jaringan', () async {
      final client = AppsScriptClient(execUrl: '', secret: '');
      final orderResult = await AppsScriptMirror.pushOrder(client, order());
      final reviewResult = await AppsScriptMirror.pushReview(client, review());

      for (final result in [orderResult, reviewResult]) {
        expect(result.ok, isFalse);
        expect(result.code, 'not_configured');
      }
    });
  });
}
