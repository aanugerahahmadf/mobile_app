import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> extractPassportNumber(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final lines = recognizedText.text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

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
      if (clean.length >= 6 && clean.length <= 9 && RegExp(r'^[A-Z0-9]+$').hasMatch(clean)) {
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

    final mrzMatch = RegExp(r'P<[A-Z]{3}<([A-Z<]+)<<([A-Z<]+)').firstMatch(text);
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
