import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Kanonisasi payload + HMAC untuk Google Apps Script.
///
/// Aturan di file ini HARUS identik dengan `apps_script/Auth.gs`,
/// `AppsScriptSignature.php` (Laravel), `AppsScriptSignature.kt` (Kotlin), dan
/// `apps_script.py` (AI Core). Kelima implementasi diuji terhadap golden vector
/// yang sama, jadi kalau salah satu lari, test-nya yang berbunyi — bukan
/// aplikasi pengguna.
///
/// ```
/// canonical = timestamp . "." . nonce . "." . action . "." . canonicalJson(payload)
/// signature = lowercaseHex( HmacSHA256(canonical, secret) )
/// ```
///
/// Kenapa harus di body dan tidak bisa di header: Web App Apps Script tidak
/// menerima custom HTTP header sama sekali.
///
/// Konvensi payload:
///  - nominal dan id besar dikirim sebagai [String] (`'150000'`), bukan double;
///  - `double` integral dinormalisasi ke bentuk integer supaya `150000.0` tidak
///    menghasilkan teks berbeda dengan JS;
///  - `Map` kosong menjadi `{}`; daftar kosong `[].joined` — kirim `null` bila
///    memang tidak ada, agar tidak salah tipe;
///  - kunci objek sebaiknya ASCII snake_case (urutan dihitung per byte).
class AppsScriptSignature {
  AppsScriptSignature._();

  /// Ubah payload menjadi JSON kanonis: kunci terurut naik, tanpa spasi.
  static String canonicalJson(Object? value) {
    if (value == null) return 'null';
    if (value is bool) return value ? 'true' : 'false';
    if (value is String) return jsonEncode(value);

    if (value is num) {
      if (value is double && value == value.roundToDouble() && value.isFinite) {
        return value.toInt().toString();
      }
      return value.toString();
    }

    if (value is List) {
      return '[${value.map(canonicalJson).join(',')}]';
    }

    if (value is Map) {
      final keys = value.keys.map((k) => k.toString()).toList()..sort();
      final parts = keys
          // Key bernilai `null` TETAP dihitung: pengirim dan penerima harus
          // sepakat soal field mana yang ada.
          .map((key) => '${jsonEncode(key)}:${canonicalJson(value[key])}')
          .join(',');
      return '{$parts}';
    }

    throw ArgumentError(
      'Tipe ${value.runtimeType} tidak bisa dikanonisasi ke JSON. '
      'Pakai Map/List/String/num/bool/null.',
    );
  }

  /// String yang ditandatangani. Berguna untuk `--dry-run` dan debugging:
  /// bandingkan byte demi byte dengan hasil `auth.sampleSignature` di Apps Script.
  static String canonicalString({
    required int timestamp,
    required String nonce,
    required String action,
    Object? payload,
  }) => _canonical(timestamp, nonce, action, payload);

  /// HMAC-SHA256 hex lowercase atas payload.
  static String sign({
    required int timestamp,
    required String nonce,
    required String action,
    required String secret,
    Object? payload,
  }) {
    final digest = Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode(_canonical(timestamp, nonce, action, payload)));
    return digest.toString();
  }

  static String _canonical(
    int timestamp,
    String nonce,
    String action,
    Object? payload,
  ) =>
      '$timestamp.$nonce.$action.${canonicalJson(payload ?? <String, Object?>{})}';
}
