import 'package:flutter/material.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../../../core/widgets/media_viewer/media_viewer.dart';

/// Ekstrak daftar URL foto dari satu map ulasan (raw API response).
///
/// Urutan prioritas:
///   1. `photo_urls`  — array URL penuh (result PHP `getPhotoUrlsAttribute`)
///   2. `photos`      — array path relatif / object media
///   3. `photo_url` / `photo` — single foto (backward compatibility)
List<String> reviewPhotoUrls(Map<String, dynamic> review) {
  final urls = <String>[];
  final appended = review['photo_urls'];
  if (appended is List) {
    for (final u in appended) {
      if (u is String && u.isNotEmpty) urls.add(Formatters.imageUrl(u));
    }
  }
  final photos = review['photos'];
  if (photos is List && photos.isNotEmpty) {
    for (final p in photos) {
      if (p is String && p.isNotEmpty) {
        urls.add(Formatters.imageUrl(p));
      } else if (p is Map) {
        final src = (p['url'] as String?)?.isNotEmpty == true
            ? p['url'] as String
            : (p['original_url'] as String? ?? '');
        if (src.isNotEmpty) urls.add(Formatters.imageUrl(src));
      }
    }
  }
  if (urls.isEmpty) {
    final single =
        (review['photo_url'] as String?) ?? (review['photo'] as String?);
    if (single != null && single.isNotEmpty) {
      urls.add(Formatters.imageUrl(single));
    }
  }
  return urls;
}

/// Menampilkan grid foto ulasan (1 kolom jika 1 foto, wrap untuk banyak foto).
class ReviewPhotosGrid extends StatelessWidget {
  final List<String> urls;
  final double? itemHeight;

  const ReviewPhotosGrid({super.key, required this.urls, this.itemHeight});

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    if (urls.length == 1) {
      return MediaTile(
        url: urls.first,
        isVideo: isVideoUrl(urls.first),
        width: double.infinity,
        height: itemHeight ?? 160,
      );
    }

    final size = (MediaQuery.of(context).size.width - 32) / 3;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: urls.take(6).map((u) {
        return MediaTile(
          url: u,
          isVideo: isVideoUrl(u),
          width: size,
          height: size,
        );
      }).toList(),
    );
  }
}
