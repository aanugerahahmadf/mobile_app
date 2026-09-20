import 'package:dio/dio.dart';
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
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
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
  static Dio get instance {
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
      PrettyDioLogger(requestBody: true, responseBody: true),
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
