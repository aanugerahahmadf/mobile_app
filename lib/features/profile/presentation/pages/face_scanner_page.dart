import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class FaceScannerPage extends StatefulWidget {
  const FaceScannerPage({super.key});

  @override
  State<FaceScannerPage> createState() => _FaceScannerPageState();
}

class _FaceScannerPageState extends State<FaceScannerPage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  bool _isDetecting = false;
  bool _faceDetected = false;
  bool _captured = false;
  bool _cameraReady = false;
  File? _capturedImage;
  int _stableCounter = 0;
  bool _faceTooSmall = false;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _cameraController != null && !_cameraController!.value.isInitialized) {
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
    _cameraController = CameraController(front, ResolutionPreset.medium, enableAudio: false);
    await _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _cameraReady = true);
        _cameraController!.startImageStream(_processImage);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _cameraReady = false);
      }
    }
  }

  void _processImage(CameraImage image) {
    if (_isDetecting || _captured) return;
    _isDetecting = true;

    _detectFace(image).then((detected) {
      if (!mounted) return;
      if (!_captured) {
        if (detected) {
          _stableCounter++;
          if (_stableCounter >= 8) {
            setState(() => _faceDetected = true);
            if (!_captured) {
              _capturePhoto();
            }
          }
        } else {
          _stableCounter = 0;
          if (_faceDetected) setState(() => _faceDetected = false);
        }
      }
      _isDetecting = false;
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

  Future<bool> _detectFace(CameraImage image) async {
    final inputImage = _inputImageFromCamera(image);
    if (inputImage == null) return false;
    try {
      final faces = await _faceDetector!.processImage(inputImage);
      if (faces.isEmpty) {
        if (mounted) setState(() => _faceTooSmall = false);
        return false;
      }

      final face = faces.first;
      final frameW = image.width.toDouble();
      final box = face.boundingBox;

      final faceWidth = box.width;
      final faceHeight = box.height;
      final minFaceSize = frameW * 0.25;

      final isLargeEnough = faceWidth >= minFaceSize && faceHeight >= minFaceSize;
      if (!isLargeEnough) {
        if (mounted) setState(() => _faceTooSmall = true);
        return false;
      }
      if (mounted) setState(() => _faceTooSmall = false);

      final eulerY = face.headEulerAngleY ?? 0;
      final eulerZ = face.headEulerAngleZ ?? 0;
      final isForward = eulerY.abs() < 25 && eulerZ.abs() < 20;

      return isForward && isLargeEnough;
    } catch (_) {
      return false;
    }
  }

  Future<void> _capturePhoto() async {
    try {
      final photo = await _cameraController!.takePicture();
      if (!mounted) return;

      final file = File(photo.path);

      final inputImage = InputImage.fromFilePath(photo.path);
      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isNotEmpty) {
        setState(() {
          _captured = true;
          _capturedImage = file;
          _cameraController!.stopImageStream();
        });
      } else {
        _stableCounter = 0;
        setState(() => _faceDetected = false);
      }
    } catch (_) {
      _stableCounter = 0;
      if (mounted) setState(() => _faceDetected = false);
    }
  }

  void _retry() {
    setState(() {
      _captured = false;
      _capturedImage = null;
      _faceDetected = false;
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(_captured ? 'Konfirmasi Selfie' : 'Scan Wajah'),
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
                  _faceTooSmall ? 'Dekatkan wajah ke kamera'
                      : _faceDetected ? 'Wajah terdeteksi'
                      : 'Arahkan wajah ke dalam bingkai oval',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppSizes.md),
              if (!_faceDetected)
                TextButton.icon(
                  onPressed: _capturePhoto,
                  icon: const Icon(Icons.camera_alt, color: Colors.white70),
                  label: Text('Ambil Manual', style: const TextStyle(color: Colors.white70)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.of(context).size;
        final ovalWidth = size.width * 0.7;
        final ovalHeight = ovalWidth * 1.2;
        final top = (size.height - ovalHeight) / 2 - kToolbarHeight - MediaQuery.of(context).padding.top;

        return CustomPaint(
          size: Size.infinite,
          painter: _ScannerOverlayPainter(
            ovalRect: Rect.fromLTWH(
              (size.width - ovalWidth) / 2,
              top,
              ovalWidth,
              ovalHeight,
            ),
            faceDetected: _faceDetected,
          ),
        );
      },
    );
  }

  Widget _buildConfirmation() {
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
                  label: Text('Ulangi'),
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
                  label: Text('Gunakan'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final Rect ovalRect;
  final bool faceDetected;

  _ScannerOverlayPainter({required this.ovalRect, required this.faceDetected});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black54;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    final clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawOval(ovalRect, clearPaint);

    final borderPaint = Paint()
      ..color = faceDetected ? Colors.green : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawOval(ovalRect, borderPaint);

    if (!faceDetected) {
      final dashPaint = Paint()
        ..color = Colors.white38
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawOval(ovalRect, dashPaint);
    }
  }

  @override
  bool shouldRepaint(_ScannerOverlayPainter oldDelegate) {
    return oldDelegate.faceDetected != faceDetected || oldDelegate.ovalRect != ovalRect;
  }
}
