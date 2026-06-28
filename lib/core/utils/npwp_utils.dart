import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickNpwpPhoto(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    ),
  );
  if (source == null) return null;
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: source, maxWidth: 1200, maxHeight: 800);
  if (picked == null) return null;
  return File(picked.path);
}

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
    final possibleMatch = possibleNpwpRegex.firstMatch(text.replaceAll(RegExp(r'[^0-9]'), ''));
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

    final match = RegExp(r'Nama\s*(?:Wajib\s*Pajak)?\s*:?\s*\n?\s*([A-Za-z\s]+?)(?:\n|$)', caseSensitive: false).firstMatch(text);
    if (match != null) {
      final name = match.group(1)!.trim();
      if (name.length > 2 && !RegExp(r'^(npwp|nama|alamat|no|telp|tempat|tanggal|lahir|masa|berlaku)', caseSensitive: false).hasMatch(name)) {
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
