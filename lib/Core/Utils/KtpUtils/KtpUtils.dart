import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> extractKtpNumberFromKtp(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    final text = recognizedText.text;
    final ktpRegex = RegExp(r'\b\d{16}\b');
    final match = ktpRegex.firstMatch(text);
    if (match != null) {
      return match.group(0)!;
    }

    final possibleKtpRegex = RegExp(r'\d{16}');
    final possibleMatch = possibleKtpRegex.firstMatch(
      text.replaceAll(RegExp(r'\s+'), ''),
    );
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

    final match = RegExp(
      r'Nama\s*:?\s*\n?\s*([A-Za-z\s]+?)(?:\n|$)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final name = match.group(1)!.trim();
      if (name.length > 2 &&
          !RegExp(
            r'^(tempat|jenis|gol|alamat|rt|rw|kel|kec|agama|status|pekerjaan|kewarganegaraan|berlaku)',
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

/// Hasil OCR lengkap dokumen KTP.
///
/// Dipakai untuk sinkronisasi otomatis ke form profil (nomor, nama,
/// tempat/tanggal lahir, jenis kelamin, alamat, agama, status perkawinan,
/// dan pekerjaan) setelah pengguna memotret KTP.
class KtpOcrData {
  final String number;
  final String name;
  final String birthPlace;
  final String birthDate;
  final String gender;
  final String bloodType;
  final String address;
  final String rtRw;
  final String village;
  final String district;
  final String religion;
  final String maritalStatus;
  final String occupation;
  final String nationality;
  final String validUntil;

  const KtpOcrData({
    this.number = '',
    this.name = '',
    this.birthPlace = '',
    this.birthDate = '',
    this.gender = '',
    this.bloodType = '',
    this.address = '',
    this.rtRw = '',
    this.village = '',
    this.district = '',
    this.religion = '',
    this.maritalStatus = '',
    this.occupation = '',
    this.nationality = '',
    this.validUntil = '',
  });

  /// "Tempat Lahir, dd/mm/yyyy" — format gabungan yang dipakai form profil.
  String get birthPlaceCombo => [
    if (birthPlace.isNotEmpty) birthPlace,
    if (birthDate.isNotEmpty) birthDate,
  ].join(', ');
}

/// Mengekstrak SEMUA field KTP dalam satu kali OCR.
///
/// Menghindari beberapa TextRecognizer terpisah seperti fungsi ekstraktor
/// per-field lama. Mengembalikan string kosong untuk field yang tidak terbaca.
Future<KtpOcrData> extractKtpData(File imageFile) async {
  try {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    return _parseKtpText(recognizedText.text);
  } catch (_) {
    return const KtpOcrData();
  }
}

KtpOcrData _parseKtpText(String text) {
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

  // ── Nomor NIK ────────────────────────────────────────────────────────────
  var number = '';
  final numLine = indexOf(RegExp(r'^NIK'));
  final numVal = after(numLine);
  final numMatch = RegExp(r'\d{16}').firstMatch(numVal);
  if (numMatch != null) number = numMatch.group(0)!;
  if (number.isEmpty) {
    final fallback = RegExp(r'\b\d{16}\b').firstMatch(text);
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

  // ── Jenis Kelamin / Golongan Darah ───────────────────────────────────────
  final gender = after(
    indexOf(RegExp(r'Jenis\s*Kelamin', caseSensitive: false)),
  ).toUpperCase();
  final bloodType = after(
    indexOf(RegExp(r'Gol\s*\.?\s*Darah', caseSensitive: false)),
  );

  // ── Alamat / RT/RW / Kelurahan / Kecamatan ───────────────────────────────
  final address = after(indexOf(RegExp(r'^Alamat', caseSensitive: false)));
  final rtRw = after(indexOf(RegExp(r'^RT\s*/\s*RW', caseSensitive: false)));
  final village = after(
    indexOf(RegExp(r'Kel\s*/\s*Desa', caseSensitive: false)),
  );
  final district = after(indexOf(RegExp(r'Kecamatan', caseSensitive: false)));

  // ── Agama / Status Perkawinan / Pekerjaan ────────────────────────────────
  final religion = after(
    indexOf(RegExp(r'^Agama', caseSensitive: false)),
  ).toUpperCase();
  final maritalStatus = after(
    indexOf(RegExp(r'Status\s*Perkawinan', caseSensitive: false)),
  ).toUpperCase();
  final occupation = after(
    indexOf(RegExp(r'Pekerjaan', caseSensitive: false)),
  ).toUpperCase();

  // ── Kewarganegaraan / Berlaku Hingga ─────────────────────────────────────
  final nationality = after(
    indexOf(RegExp(r'Kewarganegaraan', caseSensitive: false)),
  );
  final validUntil = after(indexOf(RegExp(r'Berlaku', caseSensitive: false)));

  return KtpOcrData(
    number: number,
    name: name,
    birthPlace: birthPlace,
    birthDate: birthDate,
    gender: gender,
    bloodType: bloodType,
    address: address,
    rtRw: rtRw,
    village: village,
    district: district,
    religion: religion,
    maritalStatus: maritalStatus,
    occupation: occupation,
    nationality: nationality,
    validUntil: validUntil,
  );
}
