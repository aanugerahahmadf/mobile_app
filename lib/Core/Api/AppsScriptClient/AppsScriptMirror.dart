import 'package:mobile_app/Core/Api/AppsScriptClient/AppsScriptClient.dart';
import 'package:mobile_app/Features/Order/Data/Models/OrderModel/OrderModel.dart';
import 'package:mobile_app/Features/Review/Data/Models/ReviewModel/ReviewModel.dart';

/// Pembentuk baris registry Apps Script dari model yang sudah ada di aplikasi.
///
/// Kontraknya sama dengan `AppsScriptMirror` di Kotlin dan `AppsScriptMirror.php`
/// di Laravel: nama kunci snake_case ASCII, uang sebagai string, dan kolom yang
/// nilainya null dibuang (bukan dikirim sebagai kosong) supaya sheet tidak berisi
/// tembok nol. Kunci yang dipakai `upsert` adalah `keyColumn` bawaan Apps Script
/// (`order_number` untuk order, `review_id` untuk komentar), jadi baris ganda dari
/// perangkat yang sama tidak menambah record baru.
///
/// Kenapa fungsi ini ada di klien padahal Laravel sudah mem-mirror hal yang sama:
/// order yang dibuat saat HP offline dan review yang terkirim dari perangkat bisa
/// jadi tidak pernah lewat jalur tulis Laravel. Baris dari perangkat ditandai
/// `source: 'flutter'` supaya bisa diaudit per kanal.
///
/// Yang SENGAJA tidak dikirim dari perangkat: `va_number`, `qris_payload`, dan
/// `payment_deadline`. Kredensial pembayaran adalah urusan server (AGENTS.md §7),
/// dan APK tidak boleh jadi saluran yang menyalin nomor VA ke spreadsheet.
class AppsScriptMirror {
  static const String tabOrders = 'orders.rows';
  static const String tabReviews = 'reviews.rows';

  static const String _source = 'flutter';

  /// Batas teks kolom komentar; sama seperti mirror Laravel dan Kotlin.
  static const int _maxComment = 4000;

  /// Satu baris `Orders Sync` tanpa kolom pembayaran.
  ///
  /// Telepon pelanggan tidak ada di [OrderModel] (yang ada `adminPhone`, nomor
  /// panitia), jadi kolom `customer_phone` sengaja dibiarkan kosong daripada
  /// salah isi.
  static Map<String, Object?> orderRow(OrderModel order) {
    return <String, Object?>{
      'order_id': order.id,
      'order_number': _text(order.orderNumber),
      'user_id': order.userId == 0 ? null : order.userId,
      'customer_name': _text(order.userName),
      'package_name': _text(order.title),
      'quantity': order.quantity,
      'unit_price': _money(order.subtotal ?? order.totalPrice),
      'total_amount': _money(order.totalPrice),
      'status': _text(_lower(order.status)),
      'payment_status': _text(_lower(order.paymentStatus)),
      'event_date': _text(order.eventDate ?? order.bookingDate),
      'event_time': _text(order.bookingTime),
      'event_location': _text(order.locationAddress),
      'notes': _text(order.notes),
      'source': _source,
    }._dropNulls();
  }

  /// Satu baris `Reviews Sync`. Foto/video tidak ikut: yang ditulis hanya flag
  /// bahwa media ada, sama seperti kolom `has_media` di panel.
  static Map<String, Object?> reviewRow(
    ReviewModel review, {
    String? locale,
    bool verified = false,
  }) {
    return <String, Object?>{
      'review_id': review.id,
      'catalog_id': review.catalogId,
      'user_id': review.userId == 0 ? null : review.userId,
      'rating': review.rating,
      'title': _text(review.title),
      'comment': _text(review.comment, max: _maxComment),
      'is_verified_purchase': verified,
      'locale': _text(locale),
      'source': _source,
    }._dropNulls();
  }

  /// Kirim satu order ke `Orders Sync`. No-op (`not_configured`) kalau integrasi
  /// belum dinyalakan di `.env`, jadi aman dipanggil dari jalur apa pun.
  static Future<AppsScriptResult> pushOrder(
    AppsScriptClient client,
    OrderModel order,
  ) {
    return client.append('$tabOrders.append', orderRow(order));
  }

  /// Kirim satu komentar ke `Reviews Sync`. Lihat [pushOrder] soal no-op.
  static Future<AppsScriptResult> pushReview(
    AppsScriptClient client,
    ReviewModel review, {
    String? locale,
    bool verified = false,
  }) {
    return client.append(
      '$tabReviews.append',
      reviewRow(review, locale: locale, verified: verified),
    );
  }

  // ------------------------------------------------------------- pembantu nilai

  /// Uang selalu string: Apps Script membaca angka apa adanya dan `150000.0`
  /// akan tampil berbeda dari `150000` di sheet lintas klien.
  static String? _money(num? value) {
    if (value == null) return null;
    return value.round().toString();
  }

  /// String kosong dianggap tidak ada, supaya kolomnya dibuang, bukan diisi "".
  static String? _text(String? value, {int? max}) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    if (max != null && trimmed.length > max) return trimmed.substring(0, max);
    return trimmed;
  }

  static String? _lower(String? value) => value?.trim().toLowerCase();
}

extension _DropNulls on Map<String, Object?> {
  Map<String, Object?> _dropNulls() {
    return <String, Object?>{
      for (final entry in entries)
        if (entry.value != null) entry.key: entry.value,
    };
  }
}
