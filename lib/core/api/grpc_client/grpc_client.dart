import 'package:grpc/grpc.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/app_config/app_config.dart';
import 'grpc_service.dart';
import 'auth_grpc_service.dart';
import 'catalog_grpc_service.dart';
import 'package_grpc_service.dart';
import 'order_grpc_service.dart';
import 'cart_grpc_service.dart';
import 'wishlist_grpc_service.dart';
import 'review_grpc_service.dart';
import 'voucher_grpc_service.dart';
import 'cbir_grpc_service.dart';
import 'home_grpc_service.dart';
import 'search_grpc_service.dart';

/// Main gRPC Client for Wedding Flower Decoration App
///
/// This is the main entry point for all gRPC operations.
/// It provides access to all services: Auth, Catalog, Order,
/// Cart, Wishlist, Review, Voucher, CBIR, Home, and Search.
///
/// Usage:
/// ```dart
/// final grpcClient = GrpcClient();
/// final authClient = grpcClient.auth;
/// final response = await authClient.login(email: 'user@example.com', password: 'password');
/// ```
class GrpcClient {
  GrpcClient._();

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static ClientChannel? _channel;

  /// Get or create the gRPC channel
  static ClientChannel get channel {
    if (_channel == null) {
      final baseUrl = AppConfig.apiBaseUrl;
      final host = baseUrl
          .replaceFirst('http://', '')
          .replaceFirst('https://', '')
          .split('/')
          .first;
       final parts = host.split(':');
       final hostname = parts[0];
       final secure = baseUrl.toLowerCase().startsWith('https://');
       final port = parts.length > 1 ? int.parse(parts[1]) : (secure ? 443 : 50051);

      _channel = ClientChannel(
        hostname,
        port: port,
        options: ChannelOptions(
           credentials: secure
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
    return _channel!;
  }

  /// Auth gRPC Client
  AuthGrpcClient get auth => AuthGrpcClient(channel);

  /// Catalog gRPC Client
  CatalogGrpcClient get catalog => CatalogGrpcClient(channel);

  /// Package gRPC Client
  PackageGrpcClient get package => PackageGrpcClient(channel);

  /// Order gRPC Client
  OrderGrpcClient get order => OrderGrpcClient(channel);

  /// Cart gRPC Client
  CartGrpcClient get cart => CartGrpcClient(channel);

  /// Wishlist gRPC Client
  WishlistGrpcClient get wishlist => WishlistGrpcClient(channel);

  /// Review gRPC Client
  ReviewGrpcClient get review => ReviewGrpcClient(channel);

  /// Voucher gRPC Client
  VoucherGrpcClient get voucher => VoucherGrpcClient(channel);

  /// CBIR gRPC Client
  CbirGrpcClient get cbir => CbirGrpcClient(channel);

  /// Home gRPC Client
  HomeGrpcClient get home => HomeGrpcClient(channel);

  /// Search gRPC Client
  SearchGrpcClient get search => SearchGrpcClient(channel);

  /// Get auth token from secure storage
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'auth_token');
    } catch (_) {
      return null;
    }
  }

  /// Save auth token to secure storage
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  /// Delete auth token from secure storage
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Get auth metadata for gRPC requests
  static Future<Map<String, String>> getAuthMetadata() async {
    final metadata = <String, String>{'content-type': 'application/grpc'};

    try {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        metadata['authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Continue without token
    }

    return metadata;
  }

  /// Create call options with auth
  static Future<CallOptions> createCallOptions() async {
    final metadata = await getAuthMetadata();
    return CallOptions(metadata: metadata);
  }

  /// Close the gRPC channel
  static void close() {
    _channel?.shutdown();
    _channel = null;
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
