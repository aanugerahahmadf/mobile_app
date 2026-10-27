import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../core/api/dio_client/dio_client.dart';

/// Performs the small, safe set of requests needed to warm up the app after
/// installation. A failed request is intentionally non-blocking: the user
/// can still open the app and retry data loading from the relevant page.
class StartupDataService {
  Future<void> prepare({required void Function(double progress) onProgress}) async {
    final tasks = <Future<void> Function()>[
      () => _download(ApiEndpoints.categories),
      () => _download(ApiEndpoints.catalog, queryParameters: {'per_page': 20}),
    ];

    for (var i = 0; i < tasks.length; i++) {
      try {
        await tasks[i]();
      } on DioException {
        // Startup optimization must never trap a user behind a network error.
      } catch (_) {}
      onProgress((i + 1) / tasks.length);
    }
  }

  Future<void> _download(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    await DioClient.instance.get(path, queryParameters: queryParameters);
  }
}
