import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/AppConfig/AppConfig.dart';

/// Membangun [GraphQLClient] yang benar-benar bisa dipakai screen.
///
/// Dua hal yang membuat lapisan GraphQL ini mati sebelumnya:
///   * endpoint dibentuk dari [AppConfig.apiBaseUrl] yang berakhir `/api`,
///     sehingga request pergi ke `/api/graphql` padahal Lighthouse mendaftarkan
///     `/graphql` di root (lihat `config/lighthouse.php` `route.uri`). Setiap
///     screen mendapat 404 dan diam-diam jatuh ke jalur lain;
///   * [authHeaders] tidak pernah dipasang ke link, jadi operasi privat
///     (`myOrders`, `myCart`, profil) selalu balikin "Authentication required"
///     dari `GraphQLMiddleware` meskipun pengguna sudah login.
class GraphQLClientHelper {
  GraphQLClientHelper._();

  static const String _endpoint = '/graphql';

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Origin + `/graphql`. Diambil dari origin API, bukan dari `apiBaseUrl`,
  /// supaya prefix `/api` tidak ikut menempel di path Lighthouse.
  static String get endpointUrl => '${AppConfig.storageBaseHost}$_endpoint';

  static GraphQLClient? _cached;

  /// Instance tunggal: cache, connection pool, dan link dipakai ulang.
  static GraphQLClient get client => _cached ??= buildClient();

  /// Buang instance tersimpan — untuk test dan setelah konfigurasi berubah.
  @visibleForTesting
  static void reset() => _cached = null;

  static GraphQLClient buildClient() {
    final httpLink = HttpLink(
      endpointUrl,
      defaultHeaders: const {'Content-Type': 'application/json'},
    );

    return GraphQLClient(
      link: GraphqlHeaderLink(inner: httpLink),
      cache: GraphQLCache(),
      // Server adalah sumber kebenaran harga/status order (AGENTS.md §2).
      // Cache normalisasi butuh `__typename`+id yang tidak selalu kita minta,
      // jadi baca selalu lewat jaringan.
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
        mutate: Policies(fetch: FetchPolicy.noCache),
      ),
      queryRequestTimeout: const Duration(seconds: 30),
    );
  }

  /// Token Sanctum yang sama dengan yang dipakai `AuthInterceptor` di Dio.
  static Future<String?> readToken() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      return (token == null || token.isEmpty) ? null : token;
    } catch (_) {
      return null;
    }
  }

  /// Header untuk setiap operasi GraphQL.
  ///
  /// Lokal mengikuti `LocaleInterceptor` di `DioClient`: label server
  /// (`payment_type_label`, pesan error) harus berbahasa yang sama dengan sisa
  /// screen, dan itu hanya terjadi kalau `Accept-Language` ikut terkirim.
  static Future<Map<String, String>> requestHeaders() async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final token = await readToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    try {
      final prefs = await SharedPreferences.getInstance();
      headers['Accept-Language'] = prefs.getString('app_locale') ?? 'id';
    } catch (_) {
      headers['Accept-Language'] = 'id';
    }
    return headers;
  }

  /// Dipertahankan untuk kompatibilitas; [requestHeaders] adalah satu-satunya
  /// sumber header yang benar-benar dipasang ke link.
  static Future<Map<String, String>> authHeaders() async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final token = await readToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }
}

/// Menyisipkan header async (token + lokalisasi) ke setiap request.
class GraphqlHeaderLink extends Link {
  final Link inner;

  const GraphqlHeaderLink({required this.inner});

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final headers = await GraphQLClientHelper.requestHeaders();
    final withHeaders = request.updateContextEntry<HttpLinkHeaders>(
      (previous) => HttpLinkHeaders(
        headers: <String, String>{...?previous?.headers, ...headers},
      ),
    );
    yield* inner.request(withHeaders, forward);
  }
}
