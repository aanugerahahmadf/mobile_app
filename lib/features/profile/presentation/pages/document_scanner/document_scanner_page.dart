import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/utils/ktp_utils/ktp_utils.dart';
import '../../../../../core/utils/npwp_utils/npwp_utils.dart';
import '../../../../../core/utils/passport_utils/passport_utils.dart';
import '../../../../../core/utils/sim_utils/sim_utils.dart';
import '../../../../../core/utils/identity_document_utils/identity_document_utils.dart';

/// Scanner kamera otomatis untuk dokumen identitas.
///
/// Menjalankan text recognition (OCR) pada frame kamera, mendeteksi dokumen
/// (KTP/SIM/NPWP/Paspor) secara otomatis, lalu mengambil foto ketika dokumen
/// terdeteksi stabil. Hasil diformat ulang sebagai `File` yang dikembalikan
/// ke pemanggil ketika pengguna menekan "Gunakan".
class DocumentScannerPage extends StatefulWidget {
  /// Jenis dokumen: 'ktp' | 'sim' | 'npwp' | 'passport'
  final String docType;

  const DocumentScannerPage({super.key, required this.docType});

  @override
  State<DocumentScannerPage> createState() => _DocumentScannerPageState();
}

class _DocumentScannerPageState extends State<DocumentScannerPage>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  TextRecognizer? _textRecognizer;
  bool _isProcessing = false;
  bool _detected = false;
  bool _captured = false;
  bool _cameraReady = false;
  bool _tooFar = false;
  bool _validationFailed = false;
  File? _capturedImage;
  int _stableCounter = 0;
  DateTime _lastProcessAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
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
    final back = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(
      back,
      ResolutionPreset.high,
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
    if (_isProcessing || _captured) return;
    final now = DateTime.now();
    if (now.difference(_lastProcessAt).inMilliseconds < 200) return;
    _lastProcessAt = now;
    _isProcessing = true;

    _detectDocument(image).then((score) {
      if (!mounted) return;
      if (!_captured) {
        if (score >= 3) {
          _stableCounter++;
          setState(() => _detected = true);
          if (_stableCounter >= 6) {
            _capturePhoto();
          }
        } else {
          _stableCounter = 0;
          setState(() => _detected = false);
        }
      }
      _isProcessing = false;
    });
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

  /// Skor deteksi dokumen berdasarkan teks yang dikenali. Semakin tinggi skor,
  /// semakin yakin dokumen identitas yang dimaksud ada di dalam frame.
  Future<int> _detectDocument(CameraImage image) async {
    final inputImage = _inputImageFromCamera(image);
    if (inputImage == null) return 0;
    try {
      final recognized = await _textRecognizer!.processImage(inputImage);
      final text = recognized.text.toUpperCase().replaceAll('\n', ' ');
      final score = scoreDocumentText(widget.docType, text);
      if (mounted) {
        setState(() {
          _tooFar = score > 0 && score < 3 && text.trim().length < 25;
        });
      }
      return score;
    } catch (_) {
      return 0;
    }
  }

  Future<void> _capturePhoto() async {
    try {
      final photo = await _cameraController!.takePicture();
      if (!mounted) return;
      final file = File(photo.path);

      final valid = await _validateDocument(file);
      if (!mounted) return;
      if (valid) {
        setState(() {
          _captured = true;
          _capturedImage = file;
          _cameraController!.stopImageStream();
        });
      } else {
        _stableCounter = 0;
        setState(() {
          _detected = false;
          _validationFailed = true;
        });
        Timer(const Duration(seconds: 2), () {
          if (mounted) setState(() => _validationFailed = false);
        });
      }
    } catch (_) {
      _stableCounter = 0;
      if (mounted) setState(() => _detected = false);
    }
  }

  Future<bool> _validateDocument(File file) async {
    switch (widget.docType) {
      case 'ktp':
        return await extractKtpNumberFromKtp(file) != '' ||
            await extractNameFromKtp(file) != '';
      case 'sim':
        return await extractSimNumber(file) != '';
      case 'npwp':
        return await extractNpwpNumber(file) != '';
      case 'passport':
        return await extractPassportNumber(file) != '';
    }
    return false;
  }

  void _retry() {
    setState(() {
      _captured = false;
      _capturedImage = null;
      _detected = false;
      _stableCounter = 0;
      _validationFailed = false;
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(_captured ? l.confirmDocument : l.scanDocument),
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Stack(
      children: [
        CameraPreview(_cameraController!),
        _buildOverlay(),
        Positioned(
          left: 0,
          right: 0,
          bottom: bottomPadding + 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _validationFailed
                      ? AppColors.errorColor.withAlpha(200)
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _validationFailed
                      ? l.documentValidationFailed
                      : _detected
                      ? l.readyToCapture
                      : _tooFar
                      ? l.documentTooFar
                      : l.documentScanInstruction,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: bottomPadding + 30,
          child: Center(
            child: GestureDetector(
              onTap: _isProcessing ? null : _capturePhoto,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                child: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlay() {
    final size = MediaQuery.of(context).size;
    final frameW = size.width * 0.86;
    final frameH = frameW * 0.63;
    final left = (size.width - frameW) / 2;
    final top =
        (size.height - frameH) / 2 -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;

    return CustomPaint(
      size: Size.infinite,
      painter: _DocumentOverlayPainter(
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
              SizedBox(width: AppSizes.md),
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

class _DocumentOverlayPainter extends CustomPainter {
  final Rect frameRect;
  final bool detected;

  _DocumentOverlayPainter({required this.frameRect, required this.detected});

  @override
  void paint(Canvas canvas, Size size) {
    final full = Path()..addRect(Offset.zero & size);
    final hole = Path()
      ..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(12)));
    final mask = Path.combine(PathOperation.difference, full, hole);

    canvas.drawPath(
      mask,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    final borderPaint = Paint()
      ..color = detected ? AppColors.successColor : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(12)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(_DocumentOverlayPainter oldDelegate) {
    return oldDelegate.detected != detected ||
        oldDelegate.frameRect != frameRect;
  }
}
