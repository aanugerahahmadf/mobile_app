import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../Errors/Failures/Failures.dart';
import 'GraphqlClient.dart';

/// Titik masuk tunggal screen → GraphQL, dan tempat keputusan fallback ke REST.
///
/// Repository memanggil [run]: dokumen GraphQL diurai lewat [decode], dan kalau
/// operasi tidak bisa dijalankan sama sekali request diulang lewat endpoint Dio
/// lama ([restFallback]). Kunci respons Lighthouse camelCase dikonversi ke
/// snake_case ([snakeKeys]) sehingga model `fromJson` yang sudah ada dipakai
/// apa adanya.
class GraphqlTransport {
  GraphqlTransport._();

  static Future<Map<String, dynamic>> query(
    String document, {
    Map<String, dynamic>? variables,
  }) =>
      _execute(document, variables, mutate: false);

  static Future<Map<String, dynamic>> mutate(
    String document, {
    Map<String, dynamic>? variables,
  }) =>
      _execute(document, variables, mutate: true);

  /// Jalankan [document] lewat GraphQL, lalu ubah hasilnya dengan [decode].
  ///
  /// [restFallback] hanya dipakai untuk kegagalan yang terbukti tidak
  /// menghasilkan efek samping di server — lihat [_shouldFallback].
  static Future<T> run<T>(
    String document, {
    Map<String, dynamic>? variables,
    required T Function(Map<String, dynamic> data) decode,
    required Future<T> Function() restFallback,
    bool mutate = false,
  }) async {
    try {
      return decode(await _execute(document, variables, mutate: mutate));
    } on Failure catch (failure) {
      if (!_shouldFallback(failure, mutate: mutate)) rethrow;
      debugPrint(
        'GraphQL ${mutate ? 'mutation' : 'query'} gagal ($failure), '
        'lanjut ke REST.',
      );
      return restFallback();
    }
  }

  static Future<Map<String, dynamic>> _execute(
    String document,
    Map<String, dynamic>? variables, {
    required bool mutate,
  }) async {
    final client = GraphQLClientHelper.client;
    // graphql 5.2.4 tidak melempar dari client.query/mutate: tautan gagal
    // maupun error GraphQL semuanya muncul sebagai `result.exception`.
    final QueryResult result;
    try {
      result = mutate
          ? await client.mutate(
              MutationOptions(
                document: gql(document),
                variables: variables ?? const {},
              ),
            )
          : await client.query(
              QueryOptions(
                document: gql(document),
                variables: variables ?? const {},
              ),
            );
    } on OperationException catch (error) {
      throw _failureFor(error);
    } on Exception catch (error) {
      throw NetworkFailure('GraphQL: $error');
    }

    final exception = result.exception;
    if (exception != null) throw _failureFor(exception);

    final data = result.data;
    if (data == null) return <String, dynamic>{};
    return Map<String, dynamic>.from(snakeKeys(data) as Map);
  }

  /// `{ data: [...], paginator_info: {...} }` dari Lighthouse menjadi envelope
  /// yang selama ini dibaca repository dari REST.
  static Map<String, dynamic> page(Map<String, dynamic> data, String rootKey) {
    final payload = _sub(data, rootKey);
    final rows = payload?['data'];
    return {
      'status': 'success',
      'data': rows is List ? rows : const <dynamic>[],
      'pagination': _pagination(payload?['paginator_info']),
    };
  }

  /// Satu entitas pada root key, mis. `catalog` atau `conversation`.
  static Map<String, dynamic> entity(
    Map<String, dynamic> data,
    String rootKey,
  ) {
    final payload = _sub(data, rootKey);
    return {'status': payload == null ? 'error' : 'success', 'data': payload};
  }

  /// Daftar pada root key, baik bentuk `[{...}]` maupun `{ data: [...] }`.
  static Map<String, dynamic> list(
    Map<String, dynamic> data,
    String rootKey,
  ) {
    final Object? value = data[rootKey];
    if (value is List) {
      return {'status': 'success', 'data': value, 'pagination': null};
    }
    if (value is Map) {
      return {
        'status': 'success',
        'data': value['data'] is List ? value['data'] : const <dynamic>[],
        'pagination': _pagination(value['paginator_info']),
      };
    }
    return {'status': 'success', 'data': const <dynamic>[], 'pagination': null};
  }

  /// Akar operasi yang berisi daftar, mis. `search` mengembalikan array langsung.
  static List<dynamic> rows(Map<String, dynamic> data, String rootKey) {
    final value = data[rootKey];
    if (value is List) return value;
    if (value is Map && value['data'] is List) return value['data'] as List;
    return const [];
  }

  static Map<String, dynamic>? _sub(Map<String, dynamic> data, String key) {
    final value = data[key];
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  static Map<String, dynamic>? _pagination(Object? raw) {
    if (raw is! Map) return null;
    final info = Map<String, dynamic>.from(raw);
    final hasNext = info['has_next_page'];
    return {
      ...info,
      'current_page': info['current_page'] ?? 1,
      'last_page': info['last_page'] ?? 1,
      'per_page': info['per_page'] ?? 10,
      'total': info['total'] ?? 0,
      'has_more_pages': hasNext is bool
          ? hasNext
          : (info['has_more_pages'] ?? false),
    };
  }

  /// Hanya kegagalan yang terbukti tidak sampai/tersimpan di server yang boleh
  /// diulang lewat REST. Mengulang mutasi yang sudah dieksekusi server bisa
  /// melahirkan order, inbox, atau notifikasi ganda.
  static bool _shouldFallback(Failure failure, {required bool mutate}) {
    if (failure is NetworkFailure) return true;
    if (failure is NotFoundFailure) return true;
    if (failure is GraphqlSchemaFailure) return true;
    if (!mutate && failure is ServerFailure) return true;
    return false;
  }

  static Failure _failureFor(OperationException error) {
    final link = error.linkException;
    if (link is NetworkException) {
      return NetworkFailure(link.message ?? '${link.originalException}');
    }

    // `HttpLinkServerException` adalah subclass `ServerException`, dan keduanya
    // membawa `statusCode` hasil terjemahan tautan HTTP.
    final status = link is ServerException ? link.statusCode : null;

    final messages = error.graphqlErrors.map((e) => e.message).toList();
    final joined = messages.join(' | ');

    if (status == null && messages.isEmpty) return const NetworkFailure();

    switch (status) {
      case 401:
        return const AuthFailure();
      case 403:
        return UnknownFailure(
          messages.isNotEmpty ? joined : 'Tidak memiliki akses.',
        );
      case 404:
        return const NotFoundFailure('Endpoint GraphQL tidak tersedia');
      case 415:
        return const GraphqlSchemaFailure('Content-Type GraphQL ditolak');
      case 422:
        return ValidationFailure(_validationErrors(error));
      case 500:
      case 502:
      case 503:
        return ServerFailure(
          messages.isNotEmpty ? joined : 'Terjadi kesalahan server',
        );
    }

    // Validasi dokumen terjadi sebelum resolver jalan, jadi efek samping
    // dipastikan belum ada dan fallback tetap aman untuk mutasi.
    if (messages.any(_isSchemaMismatch)) return GraphqlSchemaFailure(joined);
    if (messages.any(_isAuthMessage)) return const AuthFailure();
    if (status == 400) return ValidationFailure(_validationErrors(error));
    if (messages.isEmpty) return const ServerFailure();
    return UnknownFailure(joined);
  }

  static bool _isSchemaMismatch(String message) {
    final m = message.toLowerCase();
    return m.contains('unknown type') ||
        m.contains('cannot query field') ||
        m.contains('undefined field') ||
        m.contains("doesn't exist") ||
        (m.contains('is not a valid') && m.contains('field'));
  }

  static bool _isAuthMessage(String message) {
    final m = message.toLowerCase();
    return m.contains('authentication required') ||
        m.contains('unauthenticated') ||
        m.contains('please login');
  }

  static Map<String, List<String>> _validationErrors(OperationException error) {
    final out = <String, List<String>>{};
    for (final item in error.graphqlErrors) {
      final path = (item.path ?? const []).join('.');
      final key = path.isEmpty ? 'graphql' : path;
      out[key] = [...?out[key], item.message];
    }
    return out;
  }

  /// Kunci respons Lighthouse memakai camelCase (`createdAt`, `imageUrl`)
  /// sementara model Dart membaca snake_case (`created_at`, `image_url`).
  static Object? snakeKeys(Object? value) {
    if (value is Map) {
      return <String, dynamic>{
        for (final entry in value.entries)
          camelToSnake(entry.key.toString()): snakeKeys(entry.value),
      };
    }
    if (value is List) return value.map(snakeKeys).toList();
    return value;
  }

  static final RegExp _camelBoundary = RegExp(
    r'(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])',
  );

  static String camelToSnake(String key) =>
      key.replaceAllMapped(_camelBoundary, (_) => '_').toLowerCase();
}

/// Operasi tidak dikenal oleh schema server — dokumen client lebih tua/lebih
/// baru daripada `graphql/schema.graphql`.
class GraphqlSchemaFailure extends Failure {
  const GraphqlSchemaFailure([
    super.message = 'Operasi GraphQL tidak dikenali server',
  ]);
}
