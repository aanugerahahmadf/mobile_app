import '../../../../core/utils/formatters/formatters.dart';

class PaymentMethodInfo {
  final int id;
  final String name;
  final String type;
  final String? code;
  final String? deeplink;
  final String? accountNumber;
  final String? accountHolder;
  final String? bankName;
  final String? imageUrl;
  final String? instructions;
  final double fee;
  final int sortOrder;
  final bool isActive;
  final bool gatewayEnabled;

  /// URL gambar QRIS merchant.
  ///
  /// Backend mengirim `qris_image_url` (lihat
  /// `App\Models\PaymentMethod\PaymentMethod::getQrisImageUrlAttribute()`),
  /// yang menunjuk berkas statis `public/images/qris/qris.jpg`. Kalau server
  /// lama belum mengirim field itu, [qrisImage] tetap menampilkan berkas yang
  /// sama lewat [fallbackQrisPath] -- QRIS tidak boleh hilang hanya karena
  /// respons API belum diperbarui.
  final String? qrisImageUrl;

  /// Path statis gambar QRIS di server (sumber yang sama dengan panel web).
  static const String fallbackQrisPath = '/images/qris/qris.jpg';

  const PaymentMethodInfo({
    required this.id,
    required this.name,
    required this.type,
    this.code,
    this.deeplink,
    this.accountNumber,
    this.accountHolder,
    this.bankName,
    this.imageUrl,
    this.instructions,
    this.fee = 0,
    this.sortOrder = 0,
    this.isActive = true,
    this.gatewayEnabled = false,
    this.qrisImageUrl,
  });

  factory PaymentMethodInfo.fromJson(Map<String, dynamic> json) {
    return PaymentMethodInfo(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      code: json['code'] as String?,
      deeplink: json['deeplink'] as String?,
      accountNumber: json['account_number'] as String?,
      accountHolder: json['account_holder'] as String?,
      bankName: json['bank_name'] as String?,
      imageUrl: json['image_url'] as String?,
      instructions: json['instructions'] as String?,
      fee: json['fee'] is num
          ? (json['fee'] as num).toDouble()
          : (double.tryParse(json['fee']?.toString() ?? '') ?? 0),
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      gatewayEnabled: json['gateway_enabled'] as bool? ?? false,
      qrisImageUrl: json['qris_image_url'] as String?,
    );
  }

  /// Metode ini QRIS?
  bool get isQris => type == 'qris';

  /// URL gambar QRIS yang siap dipakai `Image.network`.
  ///
  /// Urutannya: `qris_image_url` dari server -> berkas statis `/images/qris/qris.jpg`.
  /// [Formatters.imageUrl] mengubah path relatif menjadi absolut terhadap host
  /// API, jadi gambarnya tetap tampil di perangkat fisik (bukan localhost).
  String get qrisImage =>
      Formatters.imageUrl(qrisImageUrl ?? fallbackQrisPath);
}
