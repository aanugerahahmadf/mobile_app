import 'dart:io';

import 'package:mobile_app/core/utils/ktp_utils.dart';
import 'package:mobile_app/core/utils/npwp_utils.dart';
import 'package:mobile_app/core/utils/passport_utils.dart';
import 'package:mobile_app/core/utils/sim_utils.dart';

/// Skor kecocokan teks OCR dengan dokumen identitas tertentu.
///
/// Digunakan bersama oleh [DocumentScannerPage]
/// untuk menilai apakah hasil OCR benar-benar milik dokumen [docType]
/// ('ktp' | 'sim' | 'npwp' | 'passport'). Ambang batas umum: ≥ 3.
int scoreDocumentText(String docType, String text) {
  var score = 0;
  switch (docType) {
    case 'ktp':
      if (RegExp(r'\d{16}').hasMatch(text.replaceAll(' ', ''))) score += 3;
      for (final kw in const [
        'NIK', 'NAMA', 'ALAMAT', 'PENDIDIKAN', 'KEWARGANEGARAAN',
        'PROVINSI', 'BERLAKU HINGGA', 'GOLONGAN DARAH', 'TEMPAT/TGL LAHIR',
        'AGAMA', 'STATUS PERKAWINAN', 'PEKERJAAN', 'KECAMATAN', 'KELURAHAN',
      ]) {
        if (text.contains(kw)) score += 1;
      }
      break;
    case 'sim':
      if (text.contains('SURAT IZIN MENGEMUDI')) score += 3;
      if (text.contains('GOLONGAN')) score += 1;
      if (RegExp(r'\d{6,12}').hasMatch(text.replaceAll(' ', ''))) score += 1;
      break;
    case 'npwp':
      if (text.contains('NPWP')) score += 3;
      if (text.contains('WAJIB PAJAK')) score += 1;
      if (RegExp(r'\d{15}').hasMatch(text.replaceAll(' ', ''))) score += 1;
      break;
    case 'passport':
      if (text.contains('PASSPORT')) score += 2;
      if (text.contains('REPUBLIK INDONESIA')) score += 1;
      if (RegExp(r'P<[A-Z]{3}<').hasMatch(text)) score += 3;
      break;
  }
  return score;
}

/// Skor maksimum yang bisa dihasilkan [scoreDocumentText] untuk [docType].
///
/// Dipakai untuk menormalkan skor OCR menjadi persentase pada tampilan
/// indikator di dalam scanner kamera.
int maxDocumentTextScore(String docType) {
  switch (docType) {
    case 'ktp':
      return 17; // NIK (3) + 14 kata kunci.
    case 'sim':
      return 5;
    case 'npwp':
      return 5;
    case 'passport':
      return 6;
  }
  return 17;
}

/// Mengekstrak nomor identitas dari hasil scan/foto [file] sesuai [docType]
/// ('ktp' | 'sim' | 'npwp' | 'passport').
///
/// Mengembalikan string kosong bila nomor tidak terbaca.
Future<String> extractIdentityNumber(File file, String docType) async {
  switch (docType) {
    case 'sim':
      return extractSimNumber(file);
    case 'npwp':
      return extractNpwpNumber(file);
    case 'passport':
      return extractPassportNumber(file);
    default:
      return extractKtpNumberFromKtp(file);
  }
}

/// Mengekstrak SEMUA field yang tersedia dari dokumen identitas apa pun
/// ('ktp' | 'sim' | 'npwp' | 'passport') dalam satu kali OCR.
///
/// KTP → lengkap (nomor, nama, TTL, gender, agama, status, pekerjaan, alamat).
/// SIM → nomor, nama, TTL, alamat.
/// NPWP → nomor, nama, alamat.
/// Paspor → nomor, nama, tanggal lahir (dari MRZ).
Future<KtpOcrData> extractIdentityData(File file, String docType) async {
  switch (docType) {
    case 'sim':
      return extractSimData(file);
    case 'npwp':
      return extractNpwpData(file);
    case 'passport':
      return extractPassportData(file);
    default:
      return extractKtpData(file);
  }
}

/// Menormalisasi teks OCR untuk perbandingan label yang toleran.
String _normForMatch(String s) => s.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]+'), '');

/// Mencocokkan nilai OCR (mis. "LAKI-LAKI", "BELUM KAWIN", "KARYAWAN SWASTA")
/// dengan label opsi dropdown yang terlihat oleh pengguna.
///
/// Mengembalikan label terbaik, atau string kosong bila tidak ada kecocokan.
/// Prioritas: cocok persis → pemetaan kata kunci semantik per kategori →
/// pencarian substring.
String matchOcrToDropdownLabel(String category, String value, List<String> labels) {
  final norm = _normForMatch(value);
  if (norm.isEmpty || labels.isEmpty) return '';

  for (final label in labels) {
    if (_normForMatch(label) == norm) return label;
  }

  final key = _semanticKey(category, norm);
  if (key != null) {
    for (final label in labels) {
      if (_semanticKey(category, _normForMatch(label)) == key) return label;
    }
  }

  for (final label in labels) {
    final ln = _normForMatch(label);
    if (ln.isNotEmpty && (ln.contains(norm) || norm.contains(ln))) return label;
  }

  return '';
}

String? _semanticKey(String category, String norm) {
  switch (category) {
    case 'gender':
      if (norm.contains('LAKI') || norm.contains('PRIA') || norm.contains('MALE') || norm == 'MAN') return 'male';
      if (norm.contains('PEREMPUAN') || norm.contains('WANITA') || norm.contains('FEMALE') || norm == 'WOMAN') return 'female';
      return null;
    case 'religion':
      if (norm.contains('ISLAM') || norm.contains('MUSLIM')) return 'islam';
      if (norm.contains('KRISTEN') || norm.contains('PROTESTAN') || norm.contains('CHRISTIAN')) return 'christian';
      if (norm.contains('KATOLIK') || norm.contains('CATHOLIC')) return 'catholic';
      if (norm.contains('HINDU')) return 'hindu';
      if (norm.contains('BUDHA') || norm.contains('BUDDHA') || norm.contains('BUDDH')) return 'buddhist';
      if (norm.contains('KONGHUCU') || norm.contains('KHONGHUCU') || norm.contains('CONFUCIAN')) return 'confucian';
      return null;
    case 'marital_status':
      if (norm.contains('BELUM') || norm.contains('LAJANG') || norm.contains('SINGLE') || norm.contains('UNMARRIED') || norm.contains('NOTMARRIED')) return 'single';
      if (norm.contains('CERAI') || norm.contains('DIVORC') || norm.contains('JANDA') || norm.contains('DUDA')) return 'divorced';
      if (norm.contains('KAWIN') || norm.contains('MENIKAH') || norm.contains('MARRIED')) return 'married';
      return null;
    case 'occupation':
      if (norm.contains('PELAJAR') || norm.contains('MAHASISWA') || norm.contains('STUDENT')) return 'student';
      if (norm.contains('RUMAH') || norm.contains('HOUSEWIFE') || norm == 'IRT') return 'housewife';
      if (norm.contains('WIRASWASTA') || norm.contains('WIRAUSAHA') || norm.contains('PENGUSAHA') || norm.contains('ENTREPRENEUR') || norm.contains('BUSINESS')) return 'entrepreneur';
      if (norm.contains('PROFESIONAL') || norm.contains('PROFESSIONAL') || norm.contains('DOKTER') || norm.contains('AKUNTAN') || norm.contains('LAWYER')) return 'professional';
      if (norm.contains('KARYAWAN') || norm.contains('PEGAWAI') || norm.contains('EMPLOYEE') || norm.contains('BURUH')) return 'employee';
      return null;
  }
  return null;
}
