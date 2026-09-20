import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mobile_app/core/utils/ktp_utils/ktp_utils.dart';

Future<String> extractPassportNumber(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final lines = recognizedText.text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    for (int i = 0; i < lines.length; i++) {
      if (RegExp(r'^P<[A-Z]{3}<').hasMatch(lines[i])) {
        if (i + 1 < lines.length) {
          final mrzLine2 = lines[i + 1].replaceAll(RegExp(r'\s+'), '');
          final match = RegExp(r'^([A-Z0-9]{6,9})').firstMatch(mrzLine2);
          if (match != null) return match.group(1)!;
        }
      }
    }

    for (final line in lines) {
      final clean = line.replaceAll(RegExp(r'\s+'), '');
      if (clean.length >= 6 &&
          clean.length <= 9 &&
          RegExp(r'^[A-Z0-9]+$').hasMatch(clean)) {
        return clean;
      }
    }

    return '';
  } catch (_) {
    return '';
  }
}

Future<String> extractNameFromPassport(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final text = recognizedText.text;

    final mrzMatch = RegExp(
      r'P<[A-Z]{3}<([A-Z<]+)<<([A-Z<]+)',
    ).firstMatch(text);
    if (mrzMatch != null) {
      final surname = mrzMatch.group(1)!.replaceAll('<', ' ').trim();
      final givenNames = mrzMatch.group(2)!.replaceAll('<', ' ').trim();
      final fullName = '$givenNames $surname'.trim();
      if (fullName.length > 2) return fullName.toUpperCase();
    }

    return '';
  } catch (_) {
    return '';
  }
}

/// Mengekstrak field paspor dari MRZ dalam satu kali OCR untuk sinkronisasi
/// otomatis ke form (nomor, nama, tanggal lahir).
Future<KtpOcrData> extractPassportData(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    return _parsePassportText(recognizedText.text);
  } catch (_) {
    return const KtpOcrData();
  }
}

KtpOcrData _parsePassportText(String text) {
  final lines = text
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  // ── Nomor ────────────────────────────────────────────────────────────────
  var number = '';
  for (var i = 0; i < lines.length; i++) {
    if (RegExp(r'^P<[A-Z]{3}<').hasMatch(lines[i])) {
      if (i + 1 < lines.length) {
        final mrzLine2 = lines[i + 1].replaceAll(RegExp(r'\s+'), '');
        final m = RegExp(r'^([A-Z0-9]{6,9})').firstMatch(mrzLine2);
        if (m != null) number = m.group(1)!;
      }
      break;
    }
  }
  if (number.isEmpty) {
    for (final line in lines) {
      final clean = line.replaceAll(RegExp(r'\s+'), '');
      if (clean.length >= 6 &&
          clean.length <= 9 &&
          RegExp(r'^[A-Z0-9]+$').hasMatch(clean)) {
        number = clean;
        break;
      }
    }
  }

  // ── Nama ─────────────────────────────────────────────────────────────────
  var name = '';
  final mrzMatch = RegExp(r'P<[A-Z]{3}<([A-Z<]+)<<([A-Z<]+)').firstMatch(text);
  if (mrzMatch != null) {
    final surname = mrzMatch.group(1)!.replaceAll('<', ' ').trim();
    final givenNames = mrzMatch.group(2)!.replaceAll('<', ' ').trim();
    final fullName = '$givenNames $surname'.trim();
    if (fullName.length > 2) name = fullName.toUpperCase();
  }

  // ── Tanggal Lahir dari MRZ baris kedua (YYMMDD) ──────────────────────────
  var birthDate = '';
  String? mrzLine;
  for (final l in lines) {
    final clean = l.replaceAll(RegExp(r'\s+'), '');
    if (clean.length > 20) {
      mrzLine = clean;
      break;
    }
  }
  final dobMatch = mrzLine == null
      ? null
      : RegExp(r'[A-Z]{3}(\d{6})').firstMatch(mrzLine);
  if (dobMatch != null) {
    final raw = dobMatch.group(1)!;
    final y = int.tryParse(raw.substring(0, 2));
    final m = int.tryParse(raw.substring(2, 4));
    final d = int.tryParse(raw.substring(4, 6));
    if (y != null &&
        m != null &&
        d != null &&
        m > 0 &&
        m <= 12 &&
        d > 0 &&
        d <= 31) {
      final year = y >= 70 ? 1900 + y : 2000 + y;
      birthDate =
          '${d.toString().padLeft(2, '0')}/${m.toString().padLeft(2, '0')}/$year';
    }
  }

  return KtpOcrData(number: number, name: name, birthDate: birthDate);
}
