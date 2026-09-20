import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Single source of truth for environment-driven configuration.
///
/// All consumers (Dio client, image URL builders, etc.) must read base URLs
/// from here instead of calling [dotenv.get] with a hardcoded fallback, so
/// an emulator-only host like `10.0.2.2` never silently leaks into a
/// release build when the environment file is incomplete.
class AppConfig {
  AppConfig._();

  /// The emulator-only fallback host that used to be hardcoded.
  static const String _emulatorFallback = 'http://10.0.2.2:8000/api';

  /// Placeholder domain that must be replaced before a real deployment.
  static const String _placeholderHost = 'yourdomain.com';

  /// Whether the environment was resolved from a placeholder / emulator
  /// fallback rather than a real value. Used to surface loud warnings in
  /// debug and to keep invalid hosts out of release behavior.
  static bool get isUsingFallback {
    final raw = dotenv.get('API_BASE_URL', fallback: _emulatorFallback);
    final lower = raw.toLowerCase();
    return lower.contains('10.0.2.2') ||
        lower.contains(_placeholderHost) ||
        lower.contains('localhost') ||
        lower.contains('127.0.0.1');
  }

  /// The API base URL (without trailing slash) used by the Dio client.
  static String get apiBaseUrl {
    final raw = dotenv.get('API_BASE_URL', fallback: _emulatorFallback);
    final trimmed = raw.replaceAll(RegExp(r'/+$'), '');
    if (trimmed.isEmpty) {
      _warnPlaceholder('API_BASE_URL');
      return _emulatorFallback;
    }
    final lower = trimmed.toLowerCase();
    if (lower.contains(_placeholderHost)) {
      _warnPlaceholder('API_BASE_URL');
      return trimmed; // keep user's intent, but they will see the warning
    }
    return trimmed;
  }

  /// Scheme + host + port extracted from [apiBaseUrl], used to build
  /// absolute URLs for relative image paths.
  static String get storageBaseHost {
    final raw = apiBaseUrl;
    try {
      final uri = Uri.parse(raw);
      final port = uri.hasPort ? ':${uri.port}' : '';
      return '${uri.scheme}://${uri.host}$port';
    } catch (_) {
      return raw;
    }
  }

  /// True when [host] should be treated as a loopback-only address that is
  /// meaningless on a physical device. URL rewriting for images should only
  /// happen for these — never for arbitrary private IP ranges.
  static bool isLoopbackHost(String host) {
    final h = host.toLowerCase();
    return h == 'localhost' || h == '127.0.0.1' || h == '::1';
  }

  static void _warnPlaceholder(String key) {
    debugPrint(
      '⚠️ [AppConfig] $key resolved to a placeholder/emulator host. '
      'Set a real API_BASE_URL in .env / .env.production before releasing.',
    );
  }
}
