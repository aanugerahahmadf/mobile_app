import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mobile_app/core/utils/ktp_utils/ktp_utils.dart';

Future<String> extractSimNumber(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final text = recognizedText.text;

    final simRegex = RegExp(r'\b\d{6,12}\b');
    final match = simRegex.firstMatch(text);
    if (match != null) {
      return match.group(0)!;
    }

    return '';
  } catch (_) {
    return '';
  }
}

Future<String> extractNameFromSim(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final text = recognizedText.text;

    final match = RegExp(
      r'Nama\s*:?\s*\n?\s*([A-Za-z\s]+?)(?:\n|$)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final name = match.group(1)!.trim();
      if (name.length > 2 &&
          !RegExp(
            r'^(tempat|jenis|gol|alamat|rt|rw|kel|kec|agama|status|pekerjaan|kewarganegaraan|berlaku|nomor)',
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

bool isValidSimNumber(String number) {
  final clean = number.replaceAll(RegExp(r'\s+'), '');
  if (clean.length < 6 || clean.length > 12) return false;
  return RegExp(r'^\d+$').hasMatch(clean);
}

/// Mengekstrak field SIM yang tersedia dalam satu kali OCR untuk sinkronisasi
/// otomatis ke form (nomor, nama, tempat/tgl lahir, alamat).
Future<KtpOcrData> extractSimData(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    return _parseSimText(recognizedText.text);
  } catch (_) {
    return const KtpOcrData();
  }
}

KtpOcrData _parseSimText(String text) {
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

  // ── Nomor SIM ────────────────────────────────────────────────────────────
  var number = '';
  final numVal = after(indexOf(RegExp(r'^Nomor', caseSensitive: false)));
  final numDigits = numVal.replaceAll(RegExp(r'[^0-9]'), '');
  if (numDigits.length >= 6 && numDigits.length <= 12) number = numDigits;
  if (number.isEmpty) {
    final fallback = RegExp(r'\b\d{6,12}\b').firstMatch(text);
    if (fallback != null) number = fallback.group(0)!;
  }

  // ── Nama ─────────────────────────────────────────────────────────────────
  final name = after(indexOf(RegExp(r'^Nama', caseSensitive: false)));

  // ── Tempat / Tanggal Lahir ───────────────────────────────────────────────
  var birthPlace = '';
  var birthDate = '';
  final ttlIdx = indexOf(RegExp(r'Tempat.*Lahir|TTL', caseSensitive: false));
  final ttl = after(ttlIdx);
  if (ttl.isNotEmpty) {
    final m = RegExp(r'(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{4})').firstMatch(ttl);
    if (m != null) {
      final day = int.tryParse(m.group(1) ?? '') ?? 0;
      final month = int.tryParse(m.group(2) ?? '') ?? 0;
      final year = m.group(3) ?? '';
      if (day > 0 && month > 0 && day <= 31 && month <= 12) {
        birthDate =
            '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
        birthPlace = ttl
            .substring(0, m.start)
            .replaceAll(RegExp(r'[,\s]+$'), '')
            .trim();
      } else {
        birthPlace = ttl;
      }
    } else {
      birthPlace = ttl;
    }
  }

  // ── Alamat ───────────────────────────────────────────────────────────────
  final address = after(indexOf(RegExp(r'^Alamat', caseSensitive: false)));

  return KtpOcrData(
    number: number,
    name: name,
    birthPlace: birthPlace,
    birthDate: birthDate,
    address: address,
  );
}
