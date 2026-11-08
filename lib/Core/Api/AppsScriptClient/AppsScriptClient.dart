import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'
    show debugPrint, kDebugMode, visibleForTesting;

import 'package:mobile_app/core/api/AppsScriptClient/AppsScriptSignature.dart';
import 'package:mobile_app/core/config/AppConfig/AppConfig.dart';

/// Hasil panggilan Apps Script.
///
/// Apps Script SELALU menjawab HTTP 200; keberhasilan ada di field `ok`. Karena
/// itu kelas ini tidak pernah menjadikan kode status HTTP sebagai ukuran sukses,
/// dan pemanggil cukup membaca [ok] / [code].
class AppsScriptResult {
  AppsScriptResult({
    required this.ok,
    required this.action,
    this.data = const <String, Object?>{},
    this.code,
    this.message,
    this.requestId,
  });

  factory AppsScriptResult.fromJson(Map<String, dynamic> json) {
    final error = json['error'];

    return AppsScriptResult(
      ok: json['ok'] == true,
      action: (json['action'] ?? '').toString(),
      data: Map<String, Object?>.from(
        (json['data'] as Map?) ?? const <String, dynamic>{},
      ),
      code: error is Map ? error['code']?.toString() : null,
      message: error is Map ? error['message']?.toString() : null,
      requestId: json['requestId']?.toString(),
    );
  }

  /// Gagal sebelum sampai ke server (URL kosong, jaringan putus, timeout).
  factory AppsScriptResult.transportFailure(String code, String message) =>
      AppsScriptResult(ok: false, action: '', code: code, message: message);

  final bool ok;
  final String action;
  final Map<String, Object?> data;
  final String? code;
  final String? message;
  final String? requestId;

  /// Integrasi memang belum dipasang: perlakukan sebagai no-op, bukan error UI.
  bool get isNotConfigured => code == 'not_configured';

  Object? operator [](String key) => data[key];

  @override
  String toString() =>
      'AppsScriptResult(ok: $ok, action: $action, code: ${code ?? '-'}, requestId: ${requestId ?? '-'})';
}

/// Klien Google Apps Script untuk aplikasi Flutter.
///
/// Ini tujuan TERPISAH dari Laravel dan sengaja tidak memakai `DioClient`:
/// token Sanctum tidak boleh sampai ke server Google, dan interceptor
/// Bearer/Accept-Language milik Laravel hanya menambah header yang percuma
/// (Apps Script tidak membaca header sama sekali).
///
/// Semua method aman dipanggil ketika integrasi mati: mereka mengembalikan
/// [AppsScriptResult.transportFailure] berkode `not_configured` tanpa menyentuh
/// jaringan, jadi layar yang memakai fitur ini tidak perlu percabangan guard.
class AppsScriptClient {
  /// Nilai `source` yang terdaftar di `WFD_ALLOWED_SOURCES` Apps Script.
  static const String kAppsScriptSource = 'flutter';

  AppsScriptClient({
    Dio? dio,
    String? execUrl,
    String? secret,
    String? readKey,
    String? source,
  }) : _dio = dio ?? _defaultDio(),
       _execUrl = execUrl ?? AppConfig.appsScriptExecUrl,
       _secret = secret ?? AppConfig.appsScriptSecret,
       _readKey = readKey ?? AppConfig.appsScriptReadKey,
       _source = source ?? kAppsScriptSource;

  /// Dio terpisah dari `DioClient`: tidak ada interceptor Bearer/locale di sini.
  /// Untuk test, kirim [dio] berisi `DioAdapter` sendiri.
  final Dio _dio;

  /// URL deploy Web App; wajib https dan berakhir `/exec`.
  final String _execUrl;
  final String _secret;
  final String _readKey;
  final String _source;

  bool get isConfigured =>
      _execUrl.isNotEmpty &&
      _secret.isNotEmpty &&
      _execUrl.startsWith('https://') &&
      _execUrl.endsWith('/exec');

  static Dio _defaultDio() => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      // Apps Script bisa butuh beberapa detik untuk cold start + Sheets.
      receiveTimeout: const Duration(seconds: 45),
      // Status tidak pernah dipakai untuk menilai keberhasilan (lihat atas).
      validateStatus: (status) => status != null && status >= 200,
    ),
  );

  /// Tulis satu record atau daftar record ke tab registry.
  ///
  /// [action] contoh: `'orders.rows.append'`; [payload] boleh satu `Map`
  /// (dibungkus jadi `records`) atau `{'records': [...]}` untuk batch.
  Future<AppsScriptResult> append(String action, Object payload) => push(
    action,
    payload is Map && payload.containsKey('records')
        ? Map<String, Object?>.from(payload)
        : <String, Object?>{
            'records': payload is List ? payload : [payload],
          },
  );

  /// Aksi bertanda tangan HMAC (semua aksi tulis wajib lewat sini).
  Future<AppsScriptResult> push(
    String action, [
    Map<String, Object?> payload = const <String, Object?>{},
  ]) async {
    if (!isConfigured) {
      return AppsScriptResult.transportFailure(
        'not_configured',
        'GOOGLE_APPS_SCRIPT_EXEC_URL / SECRET belum diisi di .env.',
      );
    }

    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final nonce = newNonce();

    // Kredensial masuk BODY. Apps Script tidak bisa membaca custom HTTP header,
    // jadi menaruh apa pun di `options.headers` akan berujung `missing_signature`.
    final body = <String, Object?>{
      'action': action,
      'source': _source,
      'timestamp': timestamp,
      'nonce': nonce,
      'signature': AppsScriptSignature.sign(
        timestamp: timestamp,
        nonce: nonce,
        action: action,
        secret: _secret,
        payload: payload,
      ),
      'payload': payload,
    };

    return _send(
      () => _dio.post<dynamic>(
        _execUrl,
        data: jsonEncode(body),
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.plain,
        ),
      ),
      action,
    );
  }

  /// Aksi baca dengan read key (tanpa HMAC): `health.ping`, `config.flags.get`,
  /// `records.list`.
  Future<AppsScriptResult> read(
    String action, [
    Map<String, dynamic> query = const <String, dynamic>{},
  ]) async {
    if (_execUrl.isEmpty || _readKey.isEmpty) {
      return AppsScriptResult.transportFailure(
        'not_configured',
        'GOOGLE_APPS_SCRIPT_READ_KEY belum diisi di .env.',
      );
    }

    return _send(
      () => _dio.get<dynamic>(
        _execUrl,
        queryParameters: <String, dynamic>{
          ...query,
          'action': action,
          'source': _source,
          'key': _readKey,
        },
        options: Options(responseType: ResponseType.plain),
      ),
      action,
    );
  }

  /// Remote config: maintenance banner dan feature flag dari Script Properties.
  /// `null` berarti integrasi mati atau gagal — pemanggil memakai nilai defaultnya.
  Future<Map<String, Object?>?> flags() async {
    final result = await read('config.flags.get');
    if (!result.ok) return null;

    return Map<String, Object?>.from(
      (result.data['flags'] as Map?) ?? const <String, dynamic>{},
    );
  }

  /// Cek deployment; dipakai layar Diagnostik.
  Future<AppsScriptResult> health() => read('health.ping');

  void close() => _dio.close(force: true);

  Future<AppsScriptResult> _send(
    Future<Response<dynamic>> Function() request,
    String action,
  ) async {
    try {
      final response = await request();
      final decoded = decodeEnvelope(response.data);

      if (decoded == null) {
        // Gejala khas deployment salah: akses "Only me" (Google membalas
        // halaman sign-in) atau URL memakai /dev, bukan /exec.
        return AppsScriptResult.transportFailure(
          'bad_envelope',
          'Respons Apps Script bukan JSON (HTTP ${response.statusCode}).',
        );
      }

      final result = AppsScriptResult.fromJson(decoded);

      if (kDebugMode && !result.ok) {
        // Kode & pesan saja: payload bisa berisi data pelanggan.
        debugPrint(
          '[apps-script] $action -> ${result.code}: ${result.message}',
        );
      }

      return result;
    } on DioException catch (error) {
      final isTimeout =
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout;

      return AppsScriptResult.transportFailure(
        isTimeout ? 'timeout' : 'network',
        isTimeout
            ? 'Apps Script tidak menjawab tepat waktu.'
            : 'Tidak dapat menghubungi Apps Script.',
      );
    } catch (error) {
      if (kDebugMode) debugPrint('[apps-script] $action gagal: $error');
      return AppsScriptResult.transportFailure(
        'client_error',
        'Permintaan Apps Script gagal.',
      );
    }
  }

  /// Nonce sekali pakai; anti-replay Apps Script jendela 5 menit.
  @visibleForTesting
  static String newNonceStatic() =>
      '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}-${_randomToken()}';

  String newNonce() => newNonceStatic();

  static String _randomToken() {
    try {
      return Random.secure().nextInt(0x7fffffff).toRadixString(36);
    } catch (_) {
      // Platform tanpa entropy (mis. beberapa environment test): masih unik
      // karena digabung timestamp mikrosekon di atas.
      return Random().nextInt(0x7fffffff).toRadixString(36);
    }
  }
}

/// Parse body mentah menjadi envelope. `null` kalau bukan JSON objek.
///
/// Dipisah dari kelas agar test bisa memakainya tanpa menyiapkan Dio.
@visibleForTesting
Map<String, dynamic>? decodeEnvelope(Object? raw) {
  if (raw is Map) return Map<String, dynamic>.from(raw);
  if (raw is! String || raw.trim().isEmpty) return null;

  try {
    final decoded = jsonDecode(raw);
    return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
  } catch (_) {
    return null;
  }
}
