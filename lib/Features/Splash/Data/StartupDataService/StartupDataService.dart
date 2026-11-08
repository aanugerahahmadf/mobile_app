import '../../../../Core/Api/ApiEndpoints/ApiEndpoints.dart';
import '../../../../Core/Api/DioClient/DioClient.dart';

enum StartupPhase {
  preparing,
  downloading,
  ready,
}

/// Performs the small, safe set of requests needed to warm up the app after
/// installation. A failed request is intentionally non-blocking: the user
/// can still open the app and retry data loading from the relevant page.
class StartupDataService {
  Future<void> prepare({
    required void Function(double progress, StartupPhase phase) onProgress,
  }) async {
    final tasks = <Future<void> Function()>[
      () => _download(ApiEndpoints.categories),
      () => _download(ApiEndpoints.catalog, queryParameters: {'per_page': 20}),
    ];

    onProgress(0.15, StartupPhase.preparing);

    for (var i = 0; i < tasks.length; i++) {
      try {
        await tasks[i]().timeout(const Duration(seconds: 5));
      } catch (_) {
        // Startup optimization must never trap a user behind a network error.
      }
      final phase = i == 0 ? StartupPhase.downloading : StartupPhase.ready;
      final progress = 0.15 + ((i + 1) / tasks.length) * 0.85;
      onProgress(progress, phase);
    }
  }

  Future<void> _download(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    await DioClient.instance.get(path, queryParameters: queryParameters);
  }
}
