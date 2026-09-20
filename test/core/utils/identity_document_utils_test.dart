import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/utils/identity_document_utils/identity_document_utils.dart';

void main() {
  group('scoreDocumentText', () {
    test('ktp: NIK 16 digit memberi skor 3', () {
      final score = scoreDocumentText('ktp', 'NIK 3201010101010001');
      expect(score, greaterThanOrEqualTo(3));
    });

    test('ktp: kata kunci NIK/NAMA/ALAMAT menambah skor', () {
      final score = scoreDocumentText(
        'ktp',
        'NIK 3201010101010001 NAMA AGUS ALAMAT JALAN MELATI',
      );
      expect(score, greaterThanOrEqualTo(3));
    });

    test('sim: SURAT IZIN MENGEMUDI memberi skor 3', () {
      final score = scoreDocumentText('sim', 'SURAT IZIN MENGEMUDI GOLONGAN');
      expect(score, greaterThanOrEqualTo(3));
    });

    test('npwp: NPWP + 15 digit memberi skor tinggi', () {
      final score = scoreDocumentText(
        'npwp',
        'NPWP 091234567890123 WAJIB PAJAK',
      );
      expect(score, greaterThanOrEqualTo(3));
    });

    test('passport: MRZ P<ABC< memberi skor 3', () {
      final score = scoreDocumentText(
        'passport',
        'PASSPORT P<IND<BUDI<<AWAN<<<<<<<<<<<<<<<<<<',
      );
      expect(score, greaterThanOrEqualTo(3));
    });

    test('teks tidak relevan memberi skor 0', () {
      expect(scoreDocumentText('ktp', 'HELLO WORLD'), 0);
      expect(scoreDocumentText('sim', 'HELLO WORLD'), 0);
      expect(scoreDocumentText('npwp', 'HELLO WORLD'), 0);
      expect(scoreDocumentText('passport', 'HELLO WORLD'), 0);
    });

    test('teks kosong memberi skor 0', () {
      expect(scoreDocumentText('ktp', ''), 0);
    });

    test('paspor tanpa MRZ tapi kata kunci tetap beri skor', () {
      final score = scoreDocumentText('passport', 'PASSPORT REPUBLIK INDONESIA');
      expect(score, greaterThanOrEqualTo(3));
    });
  });
}
