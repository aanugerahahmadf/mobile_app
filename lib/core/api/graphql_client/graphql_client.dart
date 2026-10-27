import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../config/app_config/app_config.dart';

class GraphQLClientHelper {
  static const String _endpoint = '/graphql';

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Build GraphQL client instance
  static GraphQLClient buildClient() {
    final httpLink = HttpLink('${AppConfig.apiBaseUrl}$_endpoint');

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  /// Get auth header for GraphQL requests
  static Future<Map<String, String>> authHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Continue without token
    }

    return headers;
  }
}
