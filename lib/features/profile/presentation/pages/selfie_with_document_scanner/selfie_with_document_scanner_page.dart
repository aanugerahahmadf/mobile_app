import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/utils/identity_document_utils/identity_document_utils.dart';
import '../../../../../core/widgets/face_score_ring/face_score_ring.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Scanner kamera depan untuk foto **Selfie + Dokumen Identitas**.
///
/// Menampilkan dua panduan sekaligus di atas preview kamera:
/// - **Oval** di bagian atas sebagai panduan posisi wajah (hijau saat wajah
///   sudah berada di dalam oval, putih saat belum).
/// - **Bingkai kartu** di bagian bawah sebagai panduan posisi dokumen
///   identitas (KTP / SIM / NPWP / Paspor), hijau saat kartu terdeteksi.
///
/// Foto diambil secara otomatis hanya ketika wajah stabil di dalam oval
/// **dan kartu identitas ikut terdeteksi** (via text recognition), atau lewat
/// tombol rana manual. Setelah itu layar konfirmasi (Retake / Use) ditampilkan
/// dan path foto dikembalikan ke pemanggil saat pengguna menekan "Gunakan".
class SelfieWithDocumentScannerPage extends StatefulWidget {
  /// Jenis dokumen: 'ktp' | 'sim' | 'npwp' | 'passport'
  final String docType;

  const SelfieWithDocumentScannerPage({super.key, required this.docType});

  @override
  State<SelfieWithDocumentScannerPage> createState() =>
      _SelfieWithDocumentScannerPageState();
}

class _SelfieWithDocumentScannerPageState
    extends State<SelfieWithDocumentScannerPage>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  TextRecognizer? _textRecognizer;
  bool _isDetecting = false;
  bool _cameraReady = false;
  bool _captured = false;
  bool _faceInPlace = false;
  bool _cardDetected = false;
  File? _capturedImage;
  int _stableCounter = 0;
  DateTime _lastProcessAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: false,
        enableLandmarks: false,
        enableContours: false,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _faceDetector?.close();
    _textRecognizer?.close();
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
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    // Format NV21 (Android) / BGRA8888 (iOS) agar ML Kit mengenali byte kamera.
    _cameraController = CameraController(
      front,
      ResolutionPreset.high,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
      enableAudio: false,
    );
    await _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await _cameraController!.initialize();
      if (mounted) {
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
    if (_isDetecting || _captured) return;
    final now = DateTime.now();
    if (now.difference(_lastProcessAt).inMilliseconds < 150) return;
    _lastProcessAt = now;
    _isDetecting = true;

    Future.wait([_detectFace(image), _detectCard(image)]).then((results) {
      if (!mounted || _captured) return;
      _updateFrameState(results[0] as _FaceDetection, results[1] as bool);
      _isDetecting = false;
    });
  }

  void _updateFrameState(_FaceDetection r, bool cardDetected) {
    final faceOk = r.found && !r.multipleFaces && !r.tooSmall;
    var centered = false;
    if (faceOk) {
      final target = MediaQuery.of(context).size;
      final guide = _guideRects(target);
      final faceRect = faceBoxToScreen(
        box: r.box!,
        frameSize: r.frameSize,
        target: target,
        mirrorX: true,
      );
      centered =
          faceRect != null &&
          guide.ovalRect.inflate(24).contains(faceRect.center);
    }
    setState(() {
      _faceInPlace = centered;
      _cardDetected = cardDetected;
    });

    if (centered && cardDetected) {
      _stableCounter++;
      if (_stableCounter >= 12) {
        _capturePhoto();
      }
    } else {
      _stableCounter = 0;
    }
  }

  InputImage? _inputImageFromCamera(CameraImage image) {
    final camera = _cameraController?.description;
    if (camera == null) return null;

    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isAndroid) {
      rotation = InputImageRotation.values.firstWhere(
        (r) => r.rawValue == sensorOrientation,
        orElse: () => InputImageRotation.rotation0deg,
      );
    } else {
      rotation = InputImageRotation.rotation0deg;
    }

    final format = InputImageFormat.values.firstWhere(
      (f) => f.rawValue == image.format.raw,
      orElse: () => InputImageFormat.nv21,
    );

    final allBytes = BytesBuilder();
    for (final plane in image.planes) {
      allBytes.add(plane.bytes);
    }
    final bytes = allBytes.toBytes();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Future<_FaceDetection> _detectFace(CameraImage image) async {
    final inputImage = _inputImageFromCamera(image);
    if (inputImage == null) return _FaceDetection.empty;

    final camera = _cameraController?.description;
    final sensorOrientation = camera?.sensorOrientation ?? 90;
    final rotated =
        Platform.isAndroid &&
        (sensorOrientation == 90 || sensorOrientation == 270);
    final uprightW = rotated ? image.height.toDouble() : image.width.toDouble();
    final uprightH = rotated ? image.width.toDouble() : image.height.toDouble();

    try {
      final faces = await _faceDetector!.processImage(inputImage);
      if (faces.isEmpty) return _FaceDetection.empty;
      if (faces.length > 1) {
        return _FaceDetection.empty.copyWith(multipleFaces: true);
      }

      final face = faces.first;
      final box = face.boundingBox;

      final minFaceSize = uprightW * 0.16;
      final tooSmall = box.width < minFaceSize || box.height < minFaceSize;

      return _FaceDetection(
        found: true,
        multipleFaces: false,
        tooSmall: tooSmall,
        box: box,
        frameSize: Size(uprightW, uprightH),
      );
    } catch (_) {
      return _FaceDetection.empty;
    }
  }

  /// Mendeteksi apakah kartu identitas ([widget.docType]) ikut terlihat di
  /// dalam frame via text recognition, dengan skor ambang sama seperti
  /// [DocumentScannerPage].
  Future<bool> _detectCard(CameraImage image) async {
    final inputImage = _inputImageFromCamera(image);
    if (inputImage == null) return false;
    try {
      final recognized = await _textRecognizer!.processImage(inputImage);
      final text = recognized.text.toUpperCase().replaceAll('\n', ' ');
      return scoreDocumentText(widget.docType, text) >= 3;
    } catch (_) {
      return false;
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
      if (mounted) setState(() => _faceInPlace = false);
    }
  }

  void _retry() {
    setState(() {
      _captured = false;
      _capturedImage = null;
      _faceInPlace = false;
      _cardDetected = false;
      _stableCounter = 0;
    });
    _cameraController!.startImageStream(_processImage);
  }

  void _accept() {
    if (_capturedImage != null) {
      Navigator.pop(context, _capturedImage!.path);
    }
  }

  _SelfieIdGuides _guideRects(Size size) {
    final w = size.width;
    final h = size.height;
    final bottomReserve = MediaQuery.of(context).padding.bottom + 120;
    final usableH =
        h - bottomReserve - kToolbarHeight - MediaQuery.of(context).padding.top;
    final ovalW = w * 0.38;
    final ovalH = ovalW * 1.24;
    final ovalRect = Rect.fromCenter(
      center: Offset(
        w * 0.50,
        usableH * 0.20 + kToolbarHeight + MediaQuery.of(context).padding.top,
      ),
      width: ovalW,
      height: ovalH,
    );
    final cardW = w * 0.72;
    final cardH = cardW * 0.63;
    final cardRect = Rect.fromCenter(
      center: Offset(
        w * 0.50,
        usableH * 0.62 + kToolbarHeight + MediaQuery.of(context).padding.top,
      ),
      width: cardW,
      height: cardH,
    );
    return _SelfieIdGuides(ovalRect: ovalRect, cardRect: cardRect);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(_captured ? l.confirmDocument : l.selfieWithCard),
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
    final guides = _guideRects(MediaQuery.of(context).size);
    final instruction = !_faceInPlace
        ? l.selfieCardInstruction
        : _cardDetected
        ? l.readyToCapture
        : l.selfieCardHoldCard;
    return Stack(
      children: [
        CameraPreview(_cameraController!),
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _SelfieIdOverlayPainter(
            ovalRect: guides.ovalRect,
            cardRect: guides.cardRect,
            faceInPlace: _faceInPlace,
            cardDetected: _cardDetected,
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom + 104,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              instruction,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).padding.bottom + 24,
          child: Center(
            child: GestureDetector(
              onTap: _capturePhoto,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white70, width: 4),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.black87,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
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
          padding: EdgeInsets.fromLTRB(
            24,
            0,
            24,
            MediaQuery.of(context).padding.bottom + 32,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _retry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: Text(l.retake),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _accept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

class _SelfieIdGuides {
  final Rect ovalRect;
  final Rect cardRect;

  const _SelfieIdGuides({required this.ovalRect, required this.cardRect});
}

/// Overlay scanner selfie + identitas: meredupkan area di luar panduan,
/// menggambar oval wajah (hijau saat wajah pas, putih saat belum) dan
/// bingkai kartu identitas (hijau saat kartu terdeteksi, putih saat belum).
class _SelfieIdOverlayPainter extends CustomPainter {
  final Rect ovalRect;
  final Rect cardRect;
  final bool faceInPlace;
  final bool cardDetected;

  _SelfieIdOverlayPainter({
    required this.ovalRect,
    required this.cardRect,
    required this.faceInPlace,
    required this.cardDetected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final full = Path()..addRect(Offset.zero & size);
    final hole = Path()
      ..addOval(ovalRect)
      ..addRRect(RRect.fromRectAndRadius(cardRect, const Radius.circular(10)));
    final mask = Path.combine(PathOperation.difference, full, hole);

    canvas.drawPath(
      mask,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    final ovalColor = faceInPlace ? AppColors.successColor : Colors.white;
    canvas.drawOval(
      ovalRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = ovalColor,
    );

    final cardColor = cardDetected ? AppColors.successColor : Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(cardRect, const Radius.circular(10)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = cardColor,
    );
  }

  @override
  bool shouldRepaint(_SelfieIdOverlayPainter oldDelegate) {
    return oldDelegate.ovalRect != ovalRect ||
        oldDelegate.cardRect != cardRect ||
        oldDelegate.faceInPlace != faceInPlace ||
        oldDelegate.cardDetected != cardDetected;
  }
}

class _FaceDetection {
  const _FaceDetection({
    required this.found,
    required this.multipleFaces,
    required this.tooSmall,
    required this.box,
    required this.frameSize,
  });

  final bool found;
  final bool multipleFaces;
  final bool tooSmall;
  final Rect? box;
  final Size frameSize;

  _FaceDetection copyWith({bool? multipleFaces}) => _FaceDetection(
    found: found,
    multipleFaces: multipleFaces ?? this.multipleFaces,
    tooSmall: tooSmall,
    box: box,
    frameSize: frameSize,
  );

  static const empty = _FaceDetection(
    found: false,
    multipleFaces: false,
    tooSmall: false,
    box: null,
    frameSize: Size.zero,
  );
}
