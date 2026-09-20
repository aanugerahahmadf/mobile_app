import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:mobile_app/core/services/image_scan_analyzer/image_scan_analyzer.dart';

/// Membuat berkas gambar PNG sementara dengan satu warna merata.
Future<File> writeSolidFile(int r, int g, int b, int size) async {
  final image = img.Image(width: size, height: size);
  img.fill(image, color: img.ColorRgb8(r, g, b));
  final bytes = img.encodePng(image);
  final dir = await Directory.systemTemp.createTemp('scan_analyzer_');
  final file = File('${dir.path}/img.png');
  await file.writeAsBytes(bytes);
  return file;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final analyzer = ImageScanAnalyzer();

  group('ImageScanAnalyzer kvalitas (generic)', () {
    test('gambar hitam pekat ditolak (dark)', () async {
      final file = await writeSolidFile(0, 0, 0, 64);
      final result = await analyzer.analyze(file, type: ScanContentType.generic);
      expect(result.brightEnough, isFalse);
      expect(result.pass, isFalse);
      expect(result.issues, contains('dark'));
    });

    test('gambar terang diterima', () async {
      final file = await writeSolidFile(200, 200, 200, 64);
      final result = await analyzer.analyze(file, type: ScanContentType.generic);
      expect(result.brightEnough, isTrue);
      expect(result.pass, isTrue);
      expect(result.contentDetected, isTrue);
    });

    test('gambar semi-terang diterima (tanpa false-reject)', () async {
      final file = await writeSolidFile(90, 90, 90, 64);
      final result = await analyzer.analyze(file, type: ScanContentType.generic);
      // Kecerahan 90 >= 25 → lolos kualitas.
      expect(result.pass, isTrue);
    });

    test('gambar semi-terang detail rendah tetap diterima (soft sharpness)', () async {
      // Gambar flat (solid) memiliki sharpness ~0, tapi tetap lolos karena
      // ketajaman bersifat advisory — mencegah false-reject foto detail rendah.
      final file = await writeSolidFile(120, 120, 120, 64);
      final result = await analyzer.analyze(file, type: ScanContentType.generic);
      expect(result.inFocus, isFalse);
      expect(result.pass, isTrue);
    });
  });

  group('ImageScanAnalyzer jenis konten', () {
    test('dokumen kosong ditolak content (OCR tidak mengekstrak di test env)', () async {
      final file = await writeSolidFile(150, 150, 150, 64);
      final result = await analyzer.analyze(file, type: ScanContentType.ktp);
      expect(result.pass, isFalse);
    });
  });
}
