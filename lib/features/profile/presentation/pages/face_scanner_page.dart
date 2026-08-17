import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/face_score_ring.dart';

/// Verifikasi Wajah ala aplikasi bank/e-wallet (BRI, SeaBank, BCA, dll).
///
/// Kamera depan terbuka dengan **oval statis** di tengah layar (tidak ikut
/// bergerak mengikuti wajah): **hijau** saat langkah liveness terpenuhi,
/// **merah** saat wajah terdeteksi tapi belum pas di dalam oval, **putih** saat
/// wajah belum terdeteksi. Pengguna mengikuti instruksi di dalam oval.
///
/// Urutan perintah liveness **diacak (random)** setiap kali scanner dibuka:
/// hadap depan (selalu langkah pertama) → urutan acak dari lihat atas /
/// lihat bawah / belok kiri / belok kanan. Tanpa indikator titik step-by-step
/// di bagian atas. Setelah semua langkah selesai muncul notifikasi
/// **Terverifikasi**.
///
/// Halaman ini KHUSUS untuk Verifikasi Wajah (KYC) profil: menangkap foto
/// selfie terbaik lalu menutup dengan path berkas foto tersebut.
///
/// Berbeda dengan **App Lock Face ID** yang memakai biometrik PERANGKAT
/// (local_auth) — lihat [AppLockPage].
class FaceScannerPage extends StatefulWidget {
  const FaceScannerPage({super.key});

  @override
  State<FaceScannerPage> createState() => _FaceScannerPageState();
}

enum _LivenessAction { center, lookUp, lookDown, turnLeft, turnRight }

class _FaceScannerPageState extends State<FaceScannerPage>
    with WidgetsBindingObserver {
  static const _actionPool = <_LivenessAction>[
    _LivenessAction.lookUp,
    _LivenessAction.lookDown,
    _LivenessAction.turnLeft,
    _LivenessAction.turnRight,
  ];

  /// Urutan liveness yang diacak; `center` (hadap depan) selalu pertama.
  late final List<_LivenessAction> _sequence;

  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  bool _isDetecting = false;
  bool _cameraReady = false;
  bool _faceDetected = false;
  bool _stepSatisfied = false;
  bool _faceTooSmall = false;
  bool _eyesClosed = false;
  bool _multipleFaces = false;
  bool _isFrontCamera = true;
  int _livenessIndex = 0;
  int _stepStableCounter = 0;
  bool _verified = false;
  DateTime _lastProcessAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// Kamera depan portrait (sensor 270) membalik tanda sudut Euler X & Y
  /// terhadap konvensi dokumentasi ML Kit. (Pola sama seperti vivd liveness.)
  bool get _mirrorEulerAngles {
    final sensor = _cameraController?.description.sensorOrientation ?? 0;
    return sensor == 270;
  }

  @override
  void initState() {
    super.initState();
    _buildRandomSequence();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: false,
        enableContours: false,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  /// Menyusun urutan liveness acak: hadap depan selalu pertama, sisanya
  /// (lihat atas / bawah, belok kiri / kanan, putar) diacak setiap buka scanner.
  void _buildRandomSequence() {
    final rest = List<_LivenessAction>.of(_actionPool)..shuffle(Random());
    _sequence = <_LivenessAction>[_LivenessAction.center, ...rest];
  }

  /// Ukuran area scanner (area body) — dipakai agar oval statis konsisten
  /// antara perhitungan deteksi dan gambar overlay.
  Size _bodySize() {
    final size = MediaQuery.of(context).size;
    return Size(
      size.width,
      size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
    );
  }

  /// Oval statis di tengah layar — tidak mengikuti gerakan wajah.
  Rect _staticOvalRect(Size body) {
    final w = body.width;
    final ovalW = w * 0.58;
    final ovalH = ovalW * 1.25;
    return Rect.fromCenter(
      center: Offset(w / 2, body.height * 0.48),
      width: ovalW,
      height: ovalH,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _faceDetector?.close();
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
    _isFrontCamera = front.lensDirection == CameraLensDirection.front;
    // Format NV21 (Android) / BGRA8888 (iOS) wajib agar `InputImage.fromBytes`
    // dari ML Kit mengenali layout byte kamera — sama seperti paket face_verify.
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
    if (_isDetecting || _verified) return;
    final now = DateTime.now();
    if (now.difference(_lastProcessAt).inMilliseconds < 100) return;
    _lastProcessAt = now;
    _isDetecting = true;

    _detectFace(image).then((result) {
      if (!mounted || _verified) return;
      _processLiveness(result);
      _isDetecting = false;
    });
  }

  void _processLiveness(_FaceDetection r) {
    final m = _mirrorEulerAngles;
    final x = m ? -r.eulerX : r.eulerX;
    final y = m ? -r.eulerY : r.eulerY;

    final faceOk = r.found && !r.multipleFaces && !r.tooSmall && r.eyesOpen;
    setState(() {
      _faceDetected = faceOk;
      _multipleFaces = r.multipleFaces;
      _faceTooSmall = r.tooSmall;
      _eyesClosed = !r.eyesOpen;
    });

    if (!faceOk) {
      _stepStableCounter = 0;
      if (_stepSatisfied) setState(() => _stepSatisfied = false);
      return;
    }

    // Oval statis: wajah harus berada di dalamnya agar langkah bisa terpenuhi.
    // Oval tidak bergerak — user yang menyesuaikan posisi wajah di dalamnya.
    final bodySize = _bodySize();
    final faceScreen = faceBoxToScreen(
      box: r.box!,
      frameSize: r.frameSize,
      target: bodySize,
      mirrorX: _isFrontCamera,
    );
    final faceInOval = faceScreen != null &&
        _staticOvalRect(bodySize).inflate(24).contains(faceScreen.center);

    final action = _sequence[_livenessIndex];
    var satisfied = false;
    switch (action) {
      case _LivenessAction.center:
        satisfied = y.abs() < 20 && x.abs() < 15 && r.eulerZ.abs() < 20;
      case _LivenessAction.lookUp:
        satisfied = x < -15;
      case _LivenessAction.lookDown:
        satisfied = x > 15;
      case _LivenessAction.turnLeft:
        satisfied = y < -20;
      case _LivenessAction.turnRight:
        satisfied = y > 20;
    }

    satisfied = satisfied && faceInOval;

    setState(() => _stepSatisfied = satisfied);

    if (satisfied) {
      _stepStableCounter++;
      final required = action == _LivenessAction.center ? 8 : 5;
      if (_stepStableCounter >= required) {
        _stepStableCounter = 0;
        _advanceStep();
      }
    } else {
      _stepStableCounter = 0;
    }
  }

  void _advanceStep() {
    if (_livenessIndex >= _sequence.length - 1) {
      _cameraController?.stopImageStream();
      setState(() {
        _verified = true;
      });
      // Seluruh langkah liveness selesai (100%). Beri jeda singkat agar overlay
      // sukses terlihat, lalu munculkan MODAL notifikasi "Wajah Terverifikasi".
      Timer(const Duration(milliseconds: 1200), _showVerifiedModal);
      return;
    }
    setState(() {
      _livenessIndex++;
      _stepStableCounter = 0;
      _stepSatisfied = false;
    });
  }

  /// Setelah seluruh langkah liveness terpenuhi: ambil foto terbaik lalu
  /// tampilkan modal notifikasi "Wajah Terverifikasi". Scanner baru ditutup
  /// setelah pengguna menekan "Lanjut", membawa path foto hasil verifikasi.
  Future<void> _showVerifiedModal() async {
    if (!mounted) return;
    String? photoPath;
    try {
      final photo = await _cameraController!.takePicture();
      photoPath = photo.path;
    } catch (_) {
      photoPath = null;
    }
    if (!mounted) return;

    final l = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.surfaceColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: AppColors.successColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 20),
                Text(
                  l.faceVerified,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  l.faceVerifiedMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(l.proceed),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, photoPath);
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
        Platform.isAndroid && (sensorOrientation == 90 || sensorOrientation == 270);
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

      final minFaceSize = uprightW * 0.18;
      final tooSmall = box.width < minFaceSize || box.height < minFaceSize;

      final leftEye = face.leftEyeOpenProbability;
      final rightEye = face.rightEyeOpenProbability;
      final eyesOpen = (leftEye == null || leftEye > 0.4) &&
          (rightEye == null || rightEye > 0.4);

      return _FaceDetection(
        found: true,
        multipleFaces: false,
        tooSmall: tooSmall,
        eyesClosed: !eyesOpen,
        eyesOpen: eyesOpen,
        eulerX: face.headEulerAngleX ?? 0,
        eulerY: face.headEulerAngleY ?? 0,
        eulerZ: face.headEulerAngleZ ?? 0,
        box: box,
        frameSize: Size(uprightW, uprightH),
      );
    } catch (_) {
      return _FaceDetection.empty;
    }
  }

  (String, IconData) _actionPresentation(
      _LivenessAction action, AppLocalizations l) {
    return switch (action) {
      _LivenessAction.center => (l.faceLookStraight, Icons.face),
      _LivenessAction.lookUp => (l.faceLookUp, Icons.arrow_upward),
      _LivenessAction.lookDown => (l.faceLookDown, Icons.arrow_downward),
      _LivenessAction.turnLeft => (l.faceTurnLeft, Icons.keyboard_arrow_left),
      _LivenessAction.turnRight =>
        (l.faceTurnRight, Icons.keyboard_arrow_right),
    };
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
        title: Text(l.faceVerification),
        centerTitle: true,
      ),
      body: _cameraReady
          ? Stack(
              children: [
                _buildScanner(),
                if (_verified) _buildVerifiedOverlay(l),
              ],
            )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget _buildScanner() {
    final l = AppLocalizations.of(context)!;
    final (instruction, icon) =
        _actionPresentation(_sequence[_livenessIndex], l);
    return LayoutBuilder(
      builder: (context, constraints) {
        final oval = _staticOvalRect(constraints.biggest);
        final ovalColor = _stepSatisfied
            ? AppColors.successColor
            : _faceDetected
                ? const Color(0xFFE53935)
                : Colors.white;
        return Stack(
          children: [
            CameraPreview(_cameraController!),
            CustomPaint(
              size: constraints.biggest,
              painter: _FaceOvalPainter(
                faceRect: oval,
                color: ovalColor,
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 40,
              child: _buildInstructionCard(l, instruction, icon),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstructionCard(
      AppLocalizations l, String instruction, IconData icon) {
    final hasProblem = _multipleFaces || _eyesClosed || _faceTooSmall;
    final problemText = _multipleFaces
        ? l.faceMultipleFacesLabel
        : _eyesClosed
            ? l.faceOpenEyesLabel
            : l.faceTooClose;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _stepSatisfied ? AppColors.successColor : Colors.white24,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _stepSatisfied ? AppColors.successColor : Colors.white12,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instruction,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                if (hasProblem) ...[
                  const SizedBox(height: 4),
                  Text(
                    problemText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFFFFC107),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (_stepSatisfied)
            const Icon(Icons.check_circle,
                color: AppColors.successColor, size: 24)
          else
            const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildVerifiedOverlay(AppLocalizations l) {
    return Container(
      color: Colors.black.withValues(alpha: 0.78),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: const BoxDecoration(
                color: AppColors.successColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 56),
            ),
            const SizedBox(height: 24),
            Text(
              l.faceVerified,
              style: AppTextStyles.headlineMedium
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l.faceVerifiedMessage,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Oval pembatas wajah ala aplikasi bank: **hijau** saat langkah liveness
/// terpenuhi, **merah** saat wajah terdeteksi tapi posisi belum benar,
/// **putih** saat wajah belum terdeteksi penuh.
class _FaceOvalPainter extends CustomPainter {
  final Rect faceRect;
  final Color color;

  _FaceOvalPainter({required this.faceRect, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: 0.12);
    canvas.drawOval(faceRect, fillPaint);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = color;
    canvas.drawOval(faceRect, strokePaint);
  }

  @override
  bool shouldRepaint(_FaceOvalPainter oldDelegate) {
    return oldDelegate.faceRect != faceRect || oldDelegate.color != color;
  }
}

class _FaceDetection {
  const _FaceDetection({
    required this.found,
    required this.multipleFaces,
    required this.tooSmall,
    required this.eyesClosed,
    required this.eyesOpen,
    required this.eulerX,
    required this.eulerY,
    required this.eulerZ,
    required this.box,
    required this.frameSize,
  });

  final bool found;
  final bool multipleFaces;
  final bool tooSmall;
  final bool eyesClosed;
  final bool eyesOpen;
  final double eulerX;
  final double eulerY;
  final double eulerZ;
  final Rect? box;
  final Size frameSize;

  _FaceDetection copyWith({bool? multipleFaces}) => _FaceDetection(
        found: found,
        multipleFaces: multipleFaces ?? this.multipleFaces,
        tooSmall: tooSmall,
        eyesClosed: eyesClosed,
        eyesOpen: eyesOpen,
        eulerX: eulerX,
        eulerY: eulerY,
        eulerZ: eulerZ,
        box: box,
        frameSize: frameSize,
      );

  static const empty = _FaceDetection(
    found: false,
    multipleFaces: false,
    tooSmall: false,
    eyesClosed: false,
    eyesOpen: false,
    eulerX: 0,
    eulerY: 0,
    eulerZ: 0,
    box: null,
    frameSize: Size.zero,
  );
}
