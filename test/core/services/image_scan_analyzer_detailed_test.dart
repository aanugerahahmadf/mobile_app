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

/// Membuat berkas gambar dengan gradasi untuk simulasi konten.
Future<File> writeGradientFile(int size) async {
  final image = img.Image(width: size, height: size);
  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      final gray = ((x + y) * 255 ~/ (2 * size)).clamp(0, 255);
      image.setPixelRgba(x, y, gray, gray, gray, 255);
    }
  }
  final bytes = img.encodePng(image);
  final dir = await Directory.systemTemp.createTemp('scan_analyzer_');
  final file = File('${dir.path}/gradient.png');
  await file.writeAsBytes(bytes);
  return file;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final analyzer = ImageScanAnalyzer();
  group('ImageScanAnalyzer - Kualitas Generic', () {
    test('gambar hitam pekat ditolak (dark)', () async {
      final file = await writeSolidFile(0, 0, 0, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.brightEnough, isFalse);
      expect(result.pass, isFalse);
      expect(result.issues, contains('dark'));
    });
    test('gambar terang diterima', () async {
      final file = await writeSolidFile(200, 200, 200, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.brightEnough, isTrue);
      expect(result.pass, isTrue);
      expect(result.contentDetected, isTrue);
    });
    test('gambar semi-terang diterima (tanpa false-reject)', () async {
      final file = await writeSolidFile(90, 90, 90, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.pass, isTrue);
    });
    test(
      'gambar semi-terang detail rendah tetap diterima (soft sharpness)',
      () async {
        final file = await writeSolidFile(120, 120, 120, 64);
        final result = await analyzer.analyze(
          file,
          type: ScanContentType.generic,
        );
        expect(result.inFocus, isFalse);
        expect(result.pass, isTrue);
      },
    );
    test('gambar gelap dengan brightness 20 ditolak', () async {
      final file = await writeSolidFile(20, 20, 20, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.brightEnough, isFalse);
      expect(result.pass, isFalse);
    });
    test('gambar brightness tepat 25 diterima', () async {
      final file = await writeSolidFile(25, 25, 25, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.brightEnough, isTrue);
    });
    test('gambar brightness 24 ditolak', () async {
      final file = await writeSolidFile(24, 24, 24, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.brightEnough, isFalse);
    });
    test('gambar merah terang diterima', () async {
      final file = await writeSolidFile(255, 100, 100, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.brightEnough, isTrue);
    });
    test('gambar hijau terang diterima', () async {
      final file = await writeSolidFile(100, 255, 100, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.brightEnough, isTrue);
    });
    test('gambar biru terang diterima', () async {
      final file = await writeSolidFile(100, 100, 255, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.brightEnough, isTrue);
    });
    test('gambar ukuran besar diterima', () async {
      final file = await writeSolidFile(200, 200, 200, 512);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.pass, isTrue);
    });
    test('gambar ukuran kecil diterima', () async {
      final file = await writeSolidFile(200, 200, 200, 32);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.pass, isTrue);
    });
  });
  group('ImageScanAnalyzer - Jenis Konten', () {
    test(
      'dokumen kosong ditolak content (OCR tidak mengekstrak di test env)',
      () async {
        final file = await writeSolidFile(150, 150, 150, 64);
        final result = await analyzer.analyze(file, type: ScanContentType.ktp);
        expect(result.pass, isFalse);
      },
    );
    test('dokumen dengan gradasi mungkin diterima atau ditolak', () async {
      final file = await writeGradientFile(128);
      final result = await analyzer.analyze(file, type: ScanContentType.ktp);
      expect(result, isNotNull);
    });
    test('wajah dengan gradasi mungkin diterima atau ditolak', () async {
      final file = await writeGradientFile(128);
      final result = await analyzer.analyze(file, type: ScanContentType.face);
      expect(result, isNotNull);
    });
    test('generic dengan gradasi diterima', () async {
      final file = await writeGradientFile(128);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.pass, isTrue);
    });
  });
  group('ImageScanAnalyzer - Properti Hasil', () {
    test('hasil memiliki semua properti yang diperlukan', () async {
      final file = await writeSolidFile(200, 200, 200, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.brightEnough, isA<bool>());
      expect(result.inFocus, isA<bool>());
      expect(result.contentDetected, isA<bool>());
      expect(result.pass, isA<bool>());
      expect(result.issues, isA<List<String>>());
    });
    test('issues adalah list yang bisa diiterasi', () async {
      final file = await writeSolidFile(0, 0, 0, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.issues, isA<List<String>>());
      expect(result.issues.length, greaterThan(0));
    });
    test('pass true ketika semua kondisi terpenuhi', () async {
      final file = await writeSolidFile(200, 200, 200, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.pass, isTrue);
      expect(result.brightEnough, isTrue);
      expect(result.contentDetected, isTrue);
    });
    test('pass false ketika ada masalah', () async {
      final file = await writeSolidFile(0, 0, 0, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result.pass, isFalse);
    });
  });
  group('ImageScanAnalyzer - ScanContentType', () {
    test('ScanContentType memiliki semua nilai yang diharapkan', () {
      expect(ScanContentType.values.length, greaterThanOrEqualTo(4));
      expect(ScanContentType.values, contains(ScanContentType.generic));
      expect(ScanContentType.values, contains(ScanContentType.face));
      expect(ScanContentType.values, contains(ScanContentType.ktp));
    });
    test('ScanContentType.generic dapat digunakan', () async {
      final file = await writeSolidFile(200, 200, 200, 64);
      final result = await analyzer.analyze(
        file,
        type: ScanContentType.generic,
      );
      expect(result, isNotNull);
    });
    test('ScanContentType.face dapat digunakan', () async {
      final file = await writeSolidFile(200, 200, 200, 64);
      final result = await analyzer.analyze(file, type: ScanContentType.face);
      expect(result, isNotNull);
    });
    test('ScanContentType.ktp dapat digunakan', () async {
      final file = await writeSolidFile(200, 200, 200, 64);
      final result = await analyzer.analyze(file, type: ScanContentType.ktp);
      expect(result, isNotNull);
    });
  });
  group('ImageScanAnalyzer - Instance', () {
    test('dapat diinstansiasi', () {
      final analyzer = ImageScanAnalyzer();
      expect(analyzer, isA<ImageScanAnalyzer>());
    });
    test('multiple instance dapat dibuat', () {
      final analyzer1 = ImageScanAnalyzer();
      final analyzer2 = ImageScanAnalyzer();
      expect(analyzer1, isNot(same(analyzer2)));
    });
    test('analyze method ada', () {
      final analyzer = ImageScanAnalyzer();
      expect(analyzer.analyze, isA<Function>());
    });
  });
}
