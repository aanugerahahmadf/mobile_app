import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, visibleForTesting;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config/app_config.dart';
import '../../errors/failures/failures.dart';

class AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Dibungkus try/catch, sama seperti LocaleInterceptor di bawah.
    //
    // Sebelumnya `read()` dipanggil telanjang. Kalau secure storage gagal —
    // plugin tidak terdaftar di platform tertentu, keystore rusak, atau dalam
    // unit test yang tidak menyiapkan method channel — exception-nya membuat
    // SETIAP request gagal, bahkan yang tidak butuh autentikasi, dan
    // ErrorInterceptor mengubahnya jadi NetworkFailure yang menyesatkan.
    //
    // Menurunannya jadi request tanpa token lebih baik: server yang memutuskan
    // 401, dan itu ditangani sebagai AuthFailure.
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Lanjut tanpa token.
    }
    handler.next(options);
  }
}

class LocaleInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locale = prefs.getString('app_locale') ?? 'id';
      options.headers['Accept-Language'] = locale;
    } catch (_) {
      options.headers['Accept-Language'] = 'id';
    }
    handler.next(options);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Failure failure;
    switch (err.response?.statusCode) {
      case 401:
        failure = const AuthFailure();
        break;
      case 404:
        failure = const NotFoundFailure();
        break;
      case 422:
        final errors =
            err.response?.data?['errors'] as Map<String, dynamic>? ?? {};
        final mapped = errors.map(
          (k, v) => MapEntry(k, List<String>.from(v ?? [])),
        );
        failure = ValidationFailure(mapped);
        break;
      case 500:
        failure = const ServerFailure();
        break;
      case null:
        failure = const NetworkFailure();
        break;
      default:
        failure = UnknownFailure(
          err.response?.data?['message'] ?? 'Unknown error',
        );
    }
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: failure,
        type: err.type,
      ),
    );
  }
}

class DioClient {
  /// Instance tunggal yang benar-benar dipakai.
  ///
  /// Sebelumnya `instance` adalah getter yang membangun `Dio` BARU setiap kali
  /// diakses. Akibatnya setiap repository yang menyimpan `DioClient.instance`
  /// di field konstruktor mendapat objek dan interceptor sendiri: connection
  /// pool tidak pernah dipakai ulang, `AuthInterceptor` dipasang berulang
  /// kali, dan setiap repository memicu permintaan baru.
  ///
  /// Di test, ini muncul sebagai race: SearchRepositoryImpl memanggil
  /// AppConfig.apiBaseUrl (dan dengan itu membangun Dio) saat dikonstruksi,
  /// dan assertion bisa berjalan sebelum nilai itu siap.
  /// Akibatnya test/search_repository_test.dart gagal sekitar
  /// 1 dari 8 kali jalan, sulit direproduksi, dan membuat CI merah
  /// secara acak.
  static Dio? _cached;

  static Dio get instance => _cached ??= _build();

  /// Buang instance tersimpan. Dipakai test yang butuh `Dio` yang bersih,
  /// dan setelah `dotenv` dimuat ulang.
  @visibleForTesting
  static void reset() => _cached = null;

  static Dio _build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      LocaleInterceptor(),
      if (kDebugMode) PrettyDioLogger(requestBody: false, responseBody: false),
      ErrorInterceptor(),
    ]);

    return dio;
  }

  static Future<T> safeCall<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DioException {
      rethrow;
    }
  }
}
