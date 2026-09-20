import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../constants/app_colors/app_colors.dart';

/// True jika [mime] merupakan tipe video.
bool isVideoMime(String? mime) {
  if (mime == null || mime.isEmpty) return false;
  return mime.toLowerCase().startsWith('video/');
}

/// Deteksi video dari ekstensi URL/path (fallback saat mime tidak tersedia).
bool isVideoUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  final lower = url.toLowerCase();
  const videoExts = <String>['.mp4', '.mov', '.m4v', '.webm', '.3gp', '.avi', '.mkv'];
  return videoExts.any(lower.endsWith);
}

/// Deteksi video dari path file lokal.
bool isVideoPath(String? path) => isVideoUrl(path);

/// Preview media full-screen: gambar tampil biasa, video diputar inline
/// dengan tombol buka eksternal.
Future<void> showMediaPreview(
  BuildContext context, {
  required String url,
  bool? isVideo,
}) async {
  final video = isVideo ?? isVideoUrl(url);
  if (video) {
    await showDialog<void>(
      context: context,
      builder: (_) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: _InlineVideoPlayer(url: url),
      ),
    );
    return;
  }
  showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(url, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    ),
  );
}

class _InlineVideoPlayer extends StatefulWidget {
  final String url;

  const _InlineVideoPlayer({required this.url});

  @override
  State<_InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<_InlineVideoPlayer> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller.initialize().then((_) {
      if (mounted) {
        setState(() => _ready = true);
        _controller.play();
      }
    }).catchError((Object e) {
      if (mounted) setState(() => _error = e.toString());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openExternal() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Open externally',
            icon: const Icon(Icons.open_in_new),
            onPressed: _openExternal,
          ),
        ],
      ),
      body: Center(
        child: _error != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.white54, size: 48),
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: Colors.white54), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _openExternal,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open externally'),
                  ),
                ],
              )
            : !_ready
                ? const CircularProgressIndicator(color: Colors.white)
                : GestureDetector(
                    onTap: () => setState(() {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    }),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_controller),
                          if (!_controller.value.isPlaying)
                            const Icon(Icons.play_circle_fill, color: Colors.white70, size: 72),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

/// Tile media (gambar/video) yang dipakai di chat & grid ulasan.
/// Video ditampilkan sebagai kotak dengan ikon play; tap membuka preview.
class MediaTile extends StatelessWidget {
  final String url;
  final bool isVideo;
  final double? width;
  final double? height;
  final BoxFit fit;

  const MediaTile({
    super.key,
    required this.url,
    this.isVideo = false,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showMediaPreview(context, url: url, isVideo: isVideo),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isVideo
            ? Container(
                width: width,
                height: height,
                color: Colors.black,
                alignment: Alignment.center,
                child: const Icon(Icons.play_circle_fill, color: Colors.white70, size: 40),
              )
            : CachedNetworkImage(
                imageUrl: url,
                width: width,
                height: height,
                fit: fit,
                placeholder: (_, _) => Container(width: width, height: height, color: AppColors.secondaryColor),
                errorWidget: (_, _, _) => Container(
                  width: width,
                  height: height,
                  color: AppColors.secondaryColor,
                  child: Icon(Icons.broken_image, color: AppColors.textTertiary),
                ),
              ),
      ),
    );
  }
}

/// Preview file lokal (belum di-upload) saat dipilih pengguna.
class LocalMediaThumb extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;

  const LocalMediaThumb({super.key, required this.path, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final isVideo = isVideoPath(path);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: isVideo
          ? Container(
              width: width,
              height: height,
              color: Colors.black,
              alignment: Alignment.center,
              child: const Icon(Icons.play_circle_fill, color: Colors.white70, size: 28),
            )
          : Image.file(File(path), width: width, height: height, fit: BoxFit.cover),
    );
  }
}
