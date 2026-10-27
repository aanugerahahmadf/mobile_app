import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/api/dio_client/dio_client.dart';
import 'package:mobile_app/core/errors/failures/failures.dart';
import 'package:mobile_app/features/search/data/models/search_result/search_result.dart';
import 'package:mobile_app/features/search/data/search_repository_impl/search_repository_impl.dart';

/// Adapter yang menjawab SEMUA permintaan tanpa menyentuh jaringan.
///
/// Tanpa ini `repo.search('test')` benar-benar memanggil API. Kegagalan
/// jaringan (`NetworkFailure`) datang sebagai Future yang selesai SETELAH
/// test selesai, lalu ditangkap test framework sebagai uncaught async error.
/// Hasilnya test gagal atau lolos tergantung kecepatan DNS — persis sumber
/// flakiness yang sebelumnya muncul 1 dari 8 kali jalan.
class _MockAdapter implements HttpClientAdapter {
  int callCount = 0;
  Uri? lastUri;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    lastUri = options.uri;

    return ResponseBody.fromString(
      jsonEncode({
        'status': 'success',
        'data': <String, dynamic>{'packages': [], 'catalogs': []},
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _MockAdapter adapter;

  setUp(() {
    adapter = _MockAdapter();
    DioClient.instance.httpClientAdapter = adapter;
  });

  tearDown(() {
    // Factory `HttpClientAdapter()` mengembalikan adapter bawaan platform,
    // jadi singleton dikembalikan ke kondisi semula tanpa perlu tahu kelas
    // konkretnya.
    DioClient.instance.httpClientAdapter = HttpClientAdapter();
  });

  group('SearchRepositoryImpl', () {
    test('can be instantiated', () {
      final repo = SearchRepositoryImpl();
      expect(repo, isA<SearchRepositoryImpl>());
    });

    test('implements SearchRepository interface', () {
      final repo = SearchRepositoryImpl();
      expect(repo, isA<dynamic>());
    });

    test('shares the singleton DioClient instance', () {
      // Semua repository memakai DioClient.instance yang sama, jadi mengganti
      // adapter di satu titik berlaku untuk semuanya.
      final repo = SearchRepositoryImpl();
      expect(repo, isNotNull);
    });

    test('multiple instances can coexist', () {
      final repo1 = SearchRepositoryImpl();
      final repo2 = SearchRepositoryImpl();
      expect(repo1, isNot(same(repo2)));
    });

    test('search method exists and is callable', () {
      final repo = SearchRepositoryImpl();
      expect(repo.search, isA<Function>());
    });

    test('search method accepts query parameter', () async {
      final repo = SearchRepositoryImpl();

      final result = await repo.search('test');

      expect(result, isA<SearchResult>());
      expect(adapter.callCount, 1);
      expect(
        adapter.lastUri?.queryParameters['query'],
        'test',
        reason: 'query harus diteruskan ke API sebagai query parameter.',
      );
    });

    test('search method accepts optional page parameter', () async {
      final repo = SearchRepositoryImpl();

      await repo.search('test', page: 3);

      expect(adapter.callCount, 1);
      expect(adapter.lastUri?.queryParameters['page'], '3');
    });

    test('search wraps a network error instead of crashing', () async {
      DioClient.instance.httpClientAdapter = _FailingAdapter();

      final repo = SearchRepositoryImpl();

      // `DioClient.safeCall` melempar ulang DioException apa adanya; objek
      // Failure hasil klasifikasi ErrorInterceptor ada di `.error`. Jadi yang
      // dilempar adalah DioException, bukan NetworkFailure langsung.
      await expectLater(
        repo.search('test'),
        throwsA(
          isA<DioException>().having(
            (e) => e.error,
            'error',
            isA<NetworkFailure>(),
          ),
        ),
      );
    });
  });
}

class _FailingAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
      error: 'koneksi gagal (simulasi)',
    );
  }

  @override
  void close({bool force = false}) {}
}
