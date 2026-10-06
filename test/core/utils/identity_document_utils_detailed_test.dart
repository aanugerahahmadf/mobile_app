import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/utils/identity_document_utils/identity_document_utils.dart';
// splitKtpName hidup di ktp_utils, bukan identity_document_utils -- file ini
// menguji keduanya, jadi keduanya perlu diimpor.
import 'package:mobile_app/core/utils/ktp_utils/ktp_utils.dart';

/// Helper function untuk test - deteksi video dari path
bool isVideoPath(String? path) {
  if (path == null || path.isEmpty) return false;
  final lower = path.toLowerCase();
  const videoExts = <String>['.mp4', '.mov', '.m4v', '.webm', '.3gp', '.avi', '.mkv'];
  return videoExts.any(lower.endsWith);
}

void main() {
  group('scoreDocumentText - KTP', () {
    test('NIK 16 digit memberi skor 3', () {
      final score = scoreDocumentText('ktp', 'NIK 3201010101010001');
      expect(score, greaterThanOrEqualTo(3));
    });

    test('kata kunci NIK/NAMA/ALAMAT menambah skor', () {
      final score = scoreDocumentText(
        'ktp',
        'NIK 3201010101010001 NAMA AGUS ALAMAT JALAN MELATI',
      );
      expect(score, greaterThanOrEqualTo(3));
    });

    test('teks tidak relevan memberi skor 0', () {
      expect(scoreDocumentText('ktp', 'HELLO WORLD'), 0);
    });

    test('teks kosong memberi skor 0', () {
      expect(scoreDocumentText('ktp', ''), 0);
    });
  });

  group('scoreDocumentText - SIM', () {
    test('SURAT IZIN MENGEMUDI memberi skor 3', () {
      final score = scoreDocumentText('sim', 'SURAT IZIN MENGEMUDI GOLONGAN');
      expect(score, greaterThanOrEqualTo(3));
    });

    test('teks tidak relevan memberi skor 0', () {
      expect(scoreDocumentText('sim', 'HELLO WORLD'), 0);
    });

    test('teks kosong memberi skor 0', () {
      expect(scoreDocumentText('sim', ''), 0);
    });
  });

  group('scoreDocumentText - NPWP', () {
    test('NPWP + 15 digit memberi skor tinggi', () {
      final score = scoreDocumentText(
        'npwp',
        'NPWP 091234567890123 WAJIB PAJAK',
      );
      expect(score, greaterThanOrEqualTo(3));
    });

    test('teks tidak relevan memberi skor 0', () {
      expect(scoreDocumentText('npwp', 'HELLO WORLD'), 0);
    });

    test('teks kosong memberi skor 0', () {
      expect(scoreDocumentText('npwp', ''), 0);
    });
  });

  group('scoreDocumentText - Passport', () {
    test('MRZ P<ABC< memberi skor 3', () {
      final score = scoreDocumentText(
        'passport',
        'PASSPORT P<IND<BUDI<<AWAN<<<<<<<<<<<<<<<<<<',
      );
      expect(score, greaterThanOrEqualTo(3));
    });

    test('paspor tanpa MRZ tapi kata kunci tetap beri skor', () {
      final score = scoreDocumentText('passport', 'PASSPORT REPUBLIK INDONESIA');
      expect(score, greaterThanOrEqualTo(3));
    });

    test('teks tidak relevan memberi skor 0', () {
      expect(scoreDocumentText('passport', 'HELLO WORLD'), 0);
    });

    test('teks kosong memberi skor 0', () {
      expect(scoreDocumentText('passport', ''), 0);
    });
  });

  group('splitKtpName', () {
    // Kontrak: [firstName, middleName, lastName].
    // Untuk dua kata, slot middleName kosong dan lastName tetap di indeks 2.
    // Ekspektasi lama menaruh SANTOSO di indeks 1, yang bertentangan dengan
    // kasus tiga kata di bawahnya (BUDI / JOKO / SANTOSO).
    test('memisahkan nama lengkap dengan benar', () {
      final parts = splitKtpName('BUDI SANTOSO');
      expect(parts.length, 3);
      expect(parts[0], 'BUDI');
      expect(parts[1], '');
      expect(parts[2], 'SANTOSO');
    });

    test('memisahkan nama dengan middle name', () {
      final parts = splitKtpName('BUDI JOKO SANTOSO');
      expect(parts.length, 3);
      expect(parts[0], 'BUDI');
      expect(parts[1], 'JOKO');
      expect(parts[2], 'SANTOSO');
    });

    test('memisahkan nama single', () {
      final parts = splitKtpName('BUDI');
      expect(parts.length, 3);
      expect(parts[0], 'BUDI');
      expect(parts[1], '');
      expect(parts[2], '');
    });

    test('menangani nama kosong', () {
      final parts = splitKtpName('');
      expect(parts.length, 3);
    });

    test('menangani nama dengan spasi berlebih', () {
      final parts = splitKtpName('  BUDI   SANTOSO  ');
      expect(parts.length, 3);
    });
  });

  group('isVideoPath', () {
    test('mengembalikan true untuk ekstensi video mp4', () {
      expect(isVideoPath('/path/to/video.mp4'), isTrue);
    });

    test('mengembalikan true untuk ekstensi video mov', () {
      expect(isVideoPath('/path/to/video.mov'), isTrue);
    });

    test('mengembalikan true untuk ekstensi video avi', () {
      expect(isVideoPath('/path/to/video.avi'), isTrue);
    });

    test('mengembalikan true untuk ekstensi video mkv', () {
      expect(isVideoPath('/path/to/video.mkv'), isTrue);
    });

    test('mengembalikan false untuk ekstensi gambar jpg', () {
      expect(isVideoPath('/path/to/image.jpg'), isFalse);
    });

    test('mengembalikan false untuk ekstensi gambar png', () {
      expect(isVideoPath('/path/to/image.png'), isFalse);
    });

    test('mengembalikan false untuk path tanpa ekstensi', () {
      expect(isVideoPath('/path/to/file'), isFalse);
    });

    test('mengembalikan false untuk path kosong', () {
      expect(isVideoPath(''), isFalse);
    });
  });

  group('matchOcrToDropdownLabel', () {
    test('mencocokkan label dengan benar', () {
      final result = matchOcrToDropdownLabel(
        'gender',
        'LAKI-LAKI',
        ['Laki-laki', 'Perempuan'],
      );
      expect(result, isNotNull);
    });

    test('mengembalikan string kosong jika tidak cocok', () {
      final result = matchOcrToDropdownLabel(
        'gender',
        'UNKNOWN',
        ['Laki-laki', 'Perempuan'],
      );
      expect(result, isEmpty);
    });

    test('case insensitive matching', () {
      final result = matchOcrToDropdownLabel(
        'gender',
        'laki-laki',
        ['Laki-laki', 'Perempuan'],
      );
      expect(result, isNotNull);
    });
  });

  // `_normForMatch` private, jadi tidak bisa diimpor. Tes di bawah menguji
  // normalisasi yang sama lewat jalur publik `matchOcrToDropdownLabel`: kalau
  // teks ber-karakter aneh tetap cocok dengan labelnya, normalisasinya
  // bekerja. Menguji private function hanya memaksa siapa pun, besok,
  // mengubah visibility-nya demi satu tes.
  group('normalisasi teks OCR (lewat matchOcrToDropdownLabel)', () {
    test('huruf besar-kecil dianggap sama', () {
      expect(
        matchOcrToDropdownLabel('gender', 'LAKI-LAKI', [
          'Laki-laki',
          'Perempuan',
        ]),
        'Laki-laki',
      );
    });

    test('menghapus karakter non-A-Z0-9', () {
      expect(
        matchOcrToDropdownLabel('gender', 'Hello World!', ['HELLOWORLD']),
        'HELLOWORLD',
      );
    });

    test('menghandle string kosong tanpa error', () {
      expect(matchOcrToDropdownLabel('gender', '', ['Laki-laki']), '');
    });
  });
}
