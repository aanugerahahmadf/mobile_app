import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

/// Returns the total size (in bytes) of the app's cache:
/// temp dir + app cache dir (deduplicated).
Future<int> getAppCacheSize() async {
  int total = 0;
  final seen = <String>{};

  final tempDir = await _safeTemp();
  final cacheDir = await _safeAppCache();
  for (final dir in [tempDir, cacheDir]) {
    if (dir == null) continue;
    if (!seen.add(_normPath(dir.path))) continue;
    total += await _dirSize(dir);
  }
  return total;
}

/// Deletes the app's cache contents and returns the number of bytes freed.
Future<int> clearAppCache() async {
  int total = 0;
  final seen = <String>{};

  final tempDir = await _safeTemp();
  final cacheDir = await _safeAppCache();

  Future<void> process(Directory? dir) async {
    try {
      if (dir == null || !await dir.exists()) return;
      if (!seen.add(_normPath(dir.path))) return;
      total += await _dirSize(dir);
      await _deleteContents(dir);
    } catch (_) {}
  }

  await process(tempDir);
  await process(cacheDir);

  // Clear flutter_cache_manager (cached_network_image) bookkeeping.
  // Its files normally live inside the temp dir so they're already freed;
  // emptyCache also removes stale DB entries.
  try {
    await DefaultCacheManager().emptyCache();
  } catch (_) {}

  return total;
}

Future<Directory?> _safeTemp() async {
  try {
    return await getTemporaryDirectory();
  } catch (_) {
    return null;
  }
}

Future<Directory?> _safeAppCache() async {
  try {
    return await getApplicationCacheDirectory();
  } catch (_) {
    return null;
  }
}

String _normPath(String path) {
  var p = path.replaceAll('\\', '/');
  if (!p.endsWith('/')) p = '$p/';
  return p.toLowerCase();
}

Future<int> _dirSize(Directory dir) async {
  int bytes = 0;
  try {
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        try {
          bytes += await entity.length();
        } catch (_) {}
      }
    }
  } catch (_) {}
  return bytes;
}

Future<void> _deleteContents(Directory dir) async {
  try {
    await for (final entity in dir.list(recursive: false, followLinks: false)) {
      try {
        if (entity is Directory) {
          await _deleteContents(entity);
          await entity.delete(recursive: true);
        } else {
          await entity.delete();
        }
      } catch (_) {}
    }
  } catch (_) {}
}

String formatCacheSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}