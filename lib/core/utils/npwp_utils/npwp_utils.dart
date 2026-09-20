import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mobile_app/core/utils/ktp_utils/ktp_utils.dart';

Future<String> extractNpwpNumber(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final text = recognizedText.text;

    final npwpRegex = RegExp(r'\b\d{15}\b');
    final match = npwpRegex.firstMatch(text);
    if (match != null) {
      return match.group(0)!;
    }

    final possibleNpwpRegex = RegExp(r'\d{15}');
    final possibleMatch = possibleNpwpRegex.firstMatch(
      text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (possibleMatch != null) {
      return possibleMatch.group(0)!;
    }

    return '';
  } catch (_) {
    return '';
  }
}

Future<String> extractNameFromNpwp(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final text = recognizedText.text;

    final match = RegExp(
      r'Nama\s*(?:Wajib\s*Pajak)?\s*:?\s*\n?\s*([A-Za-z\s]+?)(?:\n|$)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final name = match.group(1)!.trim();
      if (name.length > 2 &&
          !RegExp(
            r'^(npwp|nama|alamat|no|telp|tempat|tanggal|lahir|masa|berlaku)',
            caseSensitive: false,
          ).hasMatch(name)) {
        return name.toUpperCase();
      }
    }

    return '';
  } catch (_) {
    return '';
  }
}

bool isValidNpwpNumber(String number) {
  final clean = number.replaceAll(RegExp(r'[^0-9]'), '');
  if (clean.length != 15) return false;
  return RegExp(r'^\d{15}$').hasMatch(clean);
}

String formatNpwpNumber(String number) {
  final clean = number.replaceAll(RegExp(r'[^0-9]'), '');
  if (clean.length != 15) return number;
  return '${clean.substring(0, 2)}.${clean.substring(2, 5)}.${clean.substring(5, 8)}.${clean.substring(8, 9)}-${clean.substring(9, 12)}.${clean.substring(12, 15)}';
}

/// Mengekstrak field NPWP yang tersedia dalam satu kali OCR untuk sinkronisasi
/// otomatis ke form (nomor, nama, alamat).
Future<KtpOcrData> extractNpwpData(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    return _parseNpwpText(recognizedText.text);
  } catch (_) {
    return const KtpOcrData();
  }
}

KtpOcrData _parseNpwpText(String text) {
  final lines = text
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  int indexOf(RegExp re) {
    for (var i = 0; i < lines.length; i++) {
      if (re.hasMatch(lines[i])) return i;
    }
    return -1;
  }

  String after(int idx) {
    if (idx < 0 || idx >= lines.length) return '';
    final line = lines[idx];
    final sep = line.indexOf(RegExp(r'[:|]'));
    if (sep >= 0) {
      final rest = line.substring(sep + 1).trim();
      if (rest.isNotEmpty) return rest;
    }
    if (idx + 1 < lines.length) return lines[idx + 1].trim();
    return '';
  }

  // ── Nomor NPWP ───────────────────────────────────────────────────────────
  var number = '';
  final numVal = after(indexOf(RegExp(r'^NPWP', caseSensitive: false)));
  final numDigits = numVal.replaceAll(RegExp(r'[^0-9]'), '');
  if (numDigits.length == 15) number = numDigits;
  if (number.isEmpty) {
    final fallback = RegExp(r'\b\d{15}\b').firstMatch(text);
    if (fallback != null) number = fallback.group(0)!;
  }

  // ── Nama ─────────────────────────────────────────────────────────────────
  final name = after(indexOf(RegExp(r'^Nama', caseSensitive: false)));

  // ── Alamat ───────────────────────────────────────────────────────────────
  final address = after(indexOf(RegExp(r'^Alamat', caseSensitive: false)));

  return KtpOcrData(number: number, name: name, address: address);
}
