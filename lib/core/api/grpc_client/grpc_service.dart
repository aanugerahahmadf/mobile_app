import 'package:grpc/grpc.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/app_config/app_config.dart';

/// Comprehensive gRPC Service for Wedding Flower Decoration App
///
/// This helper owns the shared channel/auth/error plumbing only. Per-domain
/// clients live in their own files (`auth_grpc_service.dart`,
/// `catalog_grpc_service.dart`, `cart_grpc_service.dart`, ...) and are
/// exposed through `GrpcClient`.
class GrpcService {
  GrpcService._();

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Get gRPC server address
  static String get serverAddress {
    final baseUrl = AppConfig.apiBaseUrl;
    final host = baseUrl
        .replaceFirst('http://', '')
        .replaceFirst('https://', '')
        .split('/')
        .first;
    final secure = baseUrl.toLowerCase().startsWith('https://');
    return '$host:${secure ? 443 : 50051}';
  }

  /// Create gRPC channel with auth interceptor
  static ClientChannel createChannel() {
    final host = serverAddress.split(':')[0];
    final port = int.parse(serverAddress.split(':')[1]);

    return ClientChannel(
      host,
      port: port,
      options: ChannelOptions(
        credentials: AppConfig.apiBaseUrl.toLowerCase().startsWith('https://')
            ? const ChannelCredentials.secure()
            : (kReleaseMode
                ? throw StateError('Release gRPC wajib menggunakan TLS.')
                : const ChannelCredentials.insecure()),
        codecRegistry: CodecRegistry(
          codecs: const [GzipCodec(), IdentityCodec()],
        ),
      ),
    );
  }

  /// Get auth metadata for gRPC requests
  static Future<Map<String, String>> getAuthMetadata() async {
    final metadata = <String, String>{'content-type': 'application/grpc'};

    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        metadata['authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Continue without token
    }

    return metadata;
  }

  /// Get auth metadata synchronously (when token is already known)
  static Map<String, String> getAuthMetadataSync(String? token) {
    final metadata = <String, String>{'content-type': 'application/grpc'};

    if (token != null && token.isNotEmpty) {
      metadata['authorization'] = 'Bearer $token';
    }

    return metadata;
  }

  /// Create call options with auth
  static Future<CallOptions> createCallOptions() async {
    final metadata = await getAuthMetadata();
    return CallOptions(metadata: metadata);
  }

  /// Create call options with specific token
  static CallOptions createCallOptionsWithToken(String? token) {
    final metadata = getAuthMetadataSync(token);
    return CallOptions(metadata: metadata);
  }

  /// Handle gRPC errors
  static String handleError(dynamic error) {
    if (error is GrpcError) {
      switch (error.code) {
        case StatusCode.unauthenticated:
          return 'Unauthorized: Please login again';
        case StatusCode.permissionDenied:
          return 'Permission denied';
        case StatusCode.notFound:
          return 'Resource not found';
        case StatusCode.alreadyExists:
          return 'Resource already exists';
        case StatusCode.invalidArgument:
          return 'Invalid argument: ${error.message}';
        case StatusCode.unavailable:
          return 'Service unavailable. Please try again later';
        case StatusCode.deadlineExceeded:
          return 'Request timeout. Please try again';
        default:
          return error.message ?? 'An error occurred';
      }
    }
    return error.toString();
  }
}
