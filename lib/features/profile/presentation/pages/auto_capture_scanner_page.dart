import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

/// Scanner kamera otomatis generik.
///
/// Mengambil foto **secara otomatis** ketika frame kamera sudah fokus dan
/// stabil (deteksi ketajaman + kestabilan cahaya dari byte frame), lalu
/// menampilkan layar konfirmasi (Retake / Use). Tombol manual tetap tersedia.
///
/// Dipakai untuk semua alur kamera generik: avatar, chat, review, bukti
/// pembayaran, pencarian gambar (CBIR), dan lain-lain.
class AutoCaptureScannerPage extends StatefulWidget {
  /// Judul app bar / mode scanner.
  final String? title;

  /// Subtitle/instruksi yang tampil di bawah overlay.
  final String? instruction;

  /// Aktifkan auto-capture. Saat false, hanya tombol manual.
  final bool autoCapture;

  const AutoCaptureScannerPage({
    super.key,
    this.title,
    this.instruction,
    this.autoCapture = true,
  });

  @override
  State<AutoCaptureScannerPage> createState() => _AutoCaptureScannerPageState();
}

class _AutoCaptureScannerPageState extends State<AutoCaptureScannerPage>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _cameraReady = false;
  bool _captured = false;
  bool _detected = false;
  bool _tooDark = false;
  bool _blurry = false;
  File? _capturedImage;
  int _stableCounter = 0;
  bool _isProcessing = false;
  DateTime _lastProcessAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        !_cameraController!.value.isInitialized) {
      _initCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    final back = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(back, ResolutionPreset.high, enableAudio: false);
    await _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await _cameraController!.initialize();
      if (mounted) {
        await _cameraController!.setFocusMode(FocusMode.auto);
        setState(() => _cameraReady = true);
        _cameraController!.startImageStream(_processImage);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _cameraReady = false);
      }
    }
  }

  void _processImage(CameraImage image) {
    if (!widget.autoCapture || _isProcessing || _captured) return;
    final now = DateTime.now();
    if (now.difference(_lastProcessAt).inMilliseconds < 150) return;
    _lastProcessAt = now;
    _isProcessing = true;

    _analyzeFrame(image).then((quality) {
      if (!mounted) return;
      if (!_captured) {
        setState(() {
          _tooDark = quality.brightness < 60;
          _blurry = !quality.inFocus;
        });
        if (quality.inFocus && quality.brightness >= 60) {
          _stableCounter++;
          if (_stableCounter >= 5) {
            setState(() => _detected = true);
            _capturePhoto();
          }
        } else {
          _stableCounter = 0;
          _detected = false;
        }
      }
      _isProcessing = false;
    });
  }

  /// Analisis sederhana frame: kecerahan rata-rata & ketajaman (sharpness)
  /// berdasarkan selisih gradien piksel pada plane Y.
  Future<_FrameQuality> _analyzeFrame(CameraImage image) async {
    try {
      final plane = image.planes.first;
      final bytes = plane.bytes;
      final stride = plane.bytesPerRow;

      final width = image.width;
      final height = image.height;
      final step = max(1, width ~/ 40);

      var sum = 0;
      var gradient = 0;
      var count = 0;
      for (int y = 0; y < height; y += step * 2) {
        final row = y * stride;
        for (int x = 0; x < width; x += step) {
          final i = row + x;
          if (i + 1 >= bytes.length) continue;
          final v = bytes[i];
          sum += v;
          final g = (bytes[i + 1] - v).abs();
          gradient += g;
          count++;
        }
      }
      if (count == 0) return _FrameQuality(brightness: 0, inFocus: false);

      final brightness = sum / count;
      // Ketajaman normalisasi: gradien rata-rata yang tinggi = fokus tajam.
      final sharpness = gradient / count;
      final inFocus = sharpness >= 6;
      return _FrameQuality(brightness: brightness, inFocus: inFocus);
    } catch (_) {
      return _FrameQuality(brightness: 0, inFocus: false);
    }
  }

  Future<void> _capturePhoto() async {
    try {
      final photo = await _cameraController!.takePicture();
      if (!mounted) return;
      setState(() {
        _captured = true;
        _capturedImage = File(photo.path);
        _cameraController!.stopImageStream();
      });
    } catch (_) {
      _stableCounter = 0;
      if (mounted) setState(() => _detected = false);
    }
  }

  void _retry() {
    setState(() {
      _captured = false;
      _capturedImage = null;
      _detected = false;
      _stableCounter = 0;
    });
    _cameraController!.startImageStream(_processImage);
  }

  void _accept() {
    if (_capturedImage != null) {
      Navigator.pop(context, _capturedImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final title = widget.title ?? (_captured ? l.confirmDocument : l.scanDocument);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(_captured ? l.confirmDocument : title),
        centerTitle: true,
      ),
      body: _cameraReady
          ? _captured && _capturedImage != null
              ? _buildConfirmation()
              : _buildScanner()
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget _buildScanner() {
    final l = AppLocalizations.of(context)!;
    final instruction = widget.instruction ??
        (_tooDark ? l.needMoreLight : _blurry ? l.holdSteady : _detected ? l.readyToCapture : l.documentScanInstruction);
    return Stack(
      children: [
        CameraPreview(_cameraController!),
        _buildOverlay(),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).padding.bottom + 40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  instruction,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverlay() {
    final size = MediaQuery.of(context).size;
    final frameW = size.width * 0.9;
    final frameH = frameW * 0.85;
    final left = (size.width - frameW) / 2;
    final top = (size.height - frameH) / 2 - kToolbarHeight - MediaQuery.of(context).padding.top;

    return CustomPaint(
      size: Size.infinite,
      painter: _AutoScanOverlayPainter(
        frameRect: Rect.fromLTWH(left, top, frameW, frameH),
        detected: _detected,
      ),
    );
  }

  Widget _buildConfirmation() {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(_capturedImage!, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(24, 0, 24, MediaQuery.of(context).padding.bottom + 32),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _retry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: Text(l.retake),
                ),
              ),
              SizedBox(width: AppSizes.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _accept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.check),
                  label: Text(l.use),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameQuality {
  final double brightness;
  final bool inFocus;
  _FrameQuality({required this.brightness, required this.inFocus});
}

class _AutoScanOverlayPainter extends CustomPainter {
  final Rect frameRect;
  final bool detected;

  _AutoScanOverlayPainter({required this.frameRect, required this.detected});

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = detected ? Colors.green : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(12)),
      borderPaint,
    );

    if (!detected) {
      final dashPaint = Paint()
        ..color = Colors.white38
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(
        RRect.fromRectAndRadius(frameRect, const Radius.circular(12)),
        dashPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_AutoScanOverlayPainter oldDelegate) {
    return oldDelegate.detected != detected || oldDelegate.frameRect != frameRect;
  }
}
