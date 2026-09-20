import 'dart:io';
import 'dart:ui' as ui;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mobile_app/core/utils/ktp_utils/ktp_utils.dart';
import 'package:mobile_app/core/utils/npwp_utils/npwp_utils.dart';
import 'package:mobile_app/core/utils/passport_utils/passport_utils.dart';
import 'package:mobile_app/core/utils/sim_utils/sim_utils.dart';

/// Jenis konten yang diharapkan pada hasil scan.
enum ScanContentType {
  /// Gambar biasa (avatar, chat, review, bukti pembayaran, CBIR).
  generic,

  /// Selfie / foto wajah.
  face,

  /// Dokumen identitas.
  ktp,
  sim,
  npwp,
  passport,
}

/// Hasil analisis AI / computer vision pada sebuah berkas gambar statis.
class ImageScanResult {
  /// Kecerahan rata-rata (0-255).
  final double brightness;

  /// Ketajaman normalisasi (semakin tinggi semakin tajam).
  final double sharpness;

  /// Gambar tidak buram.
  final bool inFocus;

  /// Kecerahan memadai.
  final bool brightEnough;

  /// Konten yang diharapkan terdeteksi (wajah / dokumen valid / kualitas OK).
  final bool contentDetected;

  /// Nilai yang diekstrak (contoh: Nomor KTP) bila relevan.
  final String? detectedValue;

  /// Alasan kegagalan (untuk UI).
  final List<String> issues;

  const ImageScanResult({
    required this.brightness,
    required this.sharpness,
    required this.inFocus,
    required this.brightEnough,
    required this.contentDetected,
    this.detectedValue,
    this.issues = const [],
  });

  /// Kualitas dasar: gambar tidak gelap total. Ketajaman bersifat advisory
  /// (bukan penghambat) karena gambar statis yang valid bisa berdetail rendah
  /// (mis. foto produk rata, tangkapan layar, dokumen bersih) sehingga tidak
  /// dapat diukur tajam/tidak-nya secara andal dari gradien piksel.
  bool get qualityPass => brightEnough;

  /// Buram apabila tajam/terlalu rendah. Dipakai sebagai sinyal advisory.
  bool get blurred => !inFocus;

  /// Keputusan akhir: konten terdeteksi DAN kualitas dasar lolos.
  bool get pass => contentDetected && qualityPass;
}

/// Analisis gambar statis berbasis computer vision (ML Kit + pixel analysis).
class ImageScanAnalyzer {
  static const int _brightnessThreshold = 25;
  static const double _sharpnessThreshold = 1.2;

  /// Menganalisis [file] dan memvalidasi konten sesuai [type].
  Future<ImageScanResult> analyze(File file, {required ScanContentType type}) async {
    final quality = await _analyzeQuality(file);

    bool contentDetected;
    String? detectedValue;
    final issues = <String>[...quality.issues];

    switch (type) {
      case ScanContentType.face:
        final faceOk = await _detectSingleFace(file);
        contentDetected = faceOk;
        if (!faceOk) issues.add('face');
        break;
      case ScanContentType.ktp:
      case ScanContentType.sim:
      case ScanContentType.npwp:
      case ScanContentType.passport:
        detectedValue = await _extractDocument(file, type);
        contentDetected = detectedValue != null && detectedValue.isNotEmpty;
        if (!contentDetected) issues.add('document');
        break;
      case ScanContentType.generic:
        // Gambar biasa: konten dianggap ada selama gambar tidak gelap total.
        // Ketajaman hanya bersifat advisory untuk menghindari false-reject
        // pada foto detail rendah (produk rata, tangkapan, dll).
        contentDetected = true;
        break;
    }

    return ImageScanResult(
      brightness: quality.brightness,
      sharpness: quality.sharpness,
      inFocus: quality.inFocus,
      brightEnough: quality.brightEnough,
      contentDetected: contentDetected,
      detectedValue: detectedValue,
      issues: issues,
    );
  }

  Future<({double brightness, double sharpness, bool inFocus, bool brightEnough, List<String> issues})>
      _analyzeQuality(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final width = image.width;
      final height = image.height;

      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      codec.dispose();
      if (data == null) {
        return _qualityResult(0, 0);
      }

      final pixels = data.buffer.asUint8List();
      final step = width ~/ 40 < 1 ? 1 : width ~/ 40;
      var sum = 0.0;
      var gradient = 0.0;
      var count = 0;

      for (var y = 0; y < height; y += step * 2) {
        for (var x = 0; x < width; x += step) {
          final i = (y * width + x) * 4;
          if (i + 3 >= pixels.length) continue;
          final r = pixels[i];
          final g = pixels[i + 1];
          final b = pixels[i + 2];
          final luma = 0.299 * r + 0.587 * g + 0.114 * b;
          sum += luma;

          final x2 = x + step;
          if (x2 < width) {
            final j = (y * width + x2) * 4;
            final luma2 = 0.299 * pixels[j] + 0.587 * pixels[j + 1] + 0.114 * pixels[j + 2];
            gradient += (luma2 - luma).abs();
          }
          count++;
        }
      }

      if (count == 0) return _qualityResult(0, 0);
      final brightness = sum / count;
      final sharpness = gradient / count;
      return _qualityResult(brightness, sharpness);
    } catch (_) {
      return _qualityResult(0, 0);
    }
  }

  ({double brightness, double sharpness, bool inFocus, bool brightEnough, List<String> issues})
      _qualityResult(double brightness, double sharpness) {
    final inFocus = sharpness >= _sharpnessThreshold;
    final brightEnough = brightness >= _brightnessThreshold;
    final issues = <String>[];
    if (!inFocus) issues.add('blur');
    if (!brightEnough) issues.add('dark');
    return (
      brightness: brightness,
      sharpness: sharpness,
      inFocus: inFocus,
      brightEnough: brightEnough,
      issues: issues,
    );
  }

  Future<bool> _detectSingleFace(File file) async {
    final detector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    try {
      final faces = await detector.processImage(InputImage.fromFile(file));
      return faces.length == 1;
    } catch (_) {
      return false;
    } finally {
      detector.close();
    }
  }

  Future<String?> _extractDocument(File file, ScanContentType type) async {
    try {
      switch (type) {
        case ScanContentType.ktp:
          final ktpNumber = await extractKtpNumberFromKtp(file);
          if (ktpNumber.isNotEmpty) return ktpNumber;
          return await extractNameFromKtp(file);
        case ScanContentType.sim:
          return await extractSimNumber(file);
        case ScanContentType.npwp:
          return await extractNpwpNumber(file);
        case ScanContentType.passport:
          return await extractPassportNumber(file);
        default:
          return null;
      }
    } catch (_) {
      return null;
    }
  }
}
