import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickKtpPhoto(BuildContext context) async {
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

Future<String> extractNikFromKtp(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final text = recognizedText.text;
    final nikRegex = RegExp(r'\b\d{16}\b');
    final match = nikRegex.firstMatch(text);
    if (match != null) {
      return match.group(0)!;
    }

    final possibleNikRegex = RegExp(r'\d{16}');
    final possibleMatch = possibleNikRegex.firstMatch(text.replaceAll(RegExp(r'\s+'), ''));
    if (possibleMatch != null) {
      return possibleMatch.group(0)!;
    }

    return '';
  } catch (_) {
    return '';
  }
}

Future<String> extractNameFromKtp(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final text = recognizedText.text;

    final match = RegExp(r'Nama\s*:?\s*\n?\s*([A-Za-z\s]+?)(?:\n|$)', caseSensitive: false).firstMatch(text);
    if (match != null) {
      final name = match.group(1)!.trim();
      if (name.length > 2 && !RegExp(r'^(tempat|jenis|gol|alamat|rt|rw|kel|kec|agama|status|pekerjaan|kewarganegaraan|berlaku)', caseSensitive: false).hasMatch(name)) {
        return name.toUpperCase();
      }
    }

    return '';
  } catch (_) {
    return '';
  }
}

List<String> splitKtpName(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return [parts[0], '', ''];
  } else if (parts.length == 2) {
    return [parts[0], '', parts[1]];
  } else {
    return [parts[0], parts.sublist(1, parts.length - 1).join(' '), parts.last];
  }
}


