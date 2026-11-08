import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/api/AppsScriptClient/AppsScriptClient.dart';
import 'package:mobile_app/core/api/AppsScriptClient/AppsScriptSignature.dart';

/// Kontrak Flutter <-> Google Apps Script.
///
/// Golden vector di bawah TIDAK dihasilkan kode Dart. Angka-angkanya datang dari
/// `canonicalJson_()`/`sign_()` di `apps_script/Auth.gs` dan dicocokkan lewat
/// `node apps_script/tests/contract.test.js` serta pembanding lintas bahasa
/// PHP vs JS. Jadi test ini benar-benar membuktikan "Dart dan Apps Script
/// menghitung hal yang sama", bukan menguji fungsi terhadap dirinya sendiri.
///
/// Kalau test ini merah sementara Apps Script tetap menolak permintaan HP dengan
/// `bad_signature`, selisihnya selalu di kanonisasi: urutan kunci, nominal
/// number-vs-string, atau tipe kosong (`{}` vs `[]`).
void main() {
  const secret = 'cross-language-secret';
  const timestamp = 1700000000;
  const action = 'orders.rows.append';

  group('AppsScriptSignature — vector lintas bahasa', () {
    const vectors = <String, Map<String, Object?>>{
      'a': {
        'payload': {
          'order_id': 42,
          'total_amount': '150000',
          'status': 'pending',
        },
        'canonical':
            '{"order_id":42,"status":"pending","total_amount":"150000"}',
        'signature':
            'ac7e1adfde11e8d189a68582c28c130750cef4c01ab26584d7b02332f8815b85',
      },
      'b': {
        'payload': {
          'records': [
            {'z': 1, 'a': 2},
            {'y': true, 'x': null},
          ],
          'keyColumn': 'order_number',
        },
        'canonical':
            '{"keyColumn":"order_number","records":[{"a":2,"z":1},{"x":null,"y":true}]}',
        'signature':
            'ff3b9ed08a9cfa439aebba8845c65b973878f8666fbb1c96b91321df4a29fc27',
      },
      'c': {
        'payload': <String, Object?>{},
        'canonical': '{}',
        'signature':
            '191cee0bb3119774a7aeb0c51b44467db353c1f5871ba816b8203eaeb19b27b2',
      },
      'd': {
        'payload': {
          'nama': 'Bunga Mawar & Melati',
          'note': 'baris\nbaru',
          'path': '/storage/a/b.jpg',
        },
        'canonical':
            '{"nama":"Bunga Mawar & Melati","note":"baris\\nbaru","path":"/storage/a/b.jpg"}',
        'signature':
            '431213a5d61d633d851a8cc9d6a6e5a50a71d6a0a4d3bcd0ec8beb0adf478d59',
      },
      'e': {
        'payload': {
          'amount': 150000.0,
          'rate': 4.5,
          'nested': {
            'deep': {'b': 1, 'a': 2},
          },
        },
        'canonical':
            '{"amount":150000,"nested":{"deep":{"a":2,"b":1}},"rate":4.5}',
        'signature':
            'e86cc15ceb3f07a000de0e2c0f4f982307cc9bb58dea62536addb53e70b4c3da',
      },
      'f': {
        'payload': {
          'id': '0012345678',
          'tags': ['b', 'a'],
        },
        'canonical': '{"id":"0012345678","tags":["b","a"]}',
        'signature':
            '57415996e05359963847149aa2041cb3f2f6cb0f637893e79db0af507ee36c7a',
      },
      // Bentuk payload yang benar-benar dikirim mirror order saat runtime.
      'h': {
        'payload': {
          'records': [
            {'order_number': 'INV-1', 'total_amount': '150000'},
          ],
          'keyColumn': 'order_number',
        },
        'canonical':
            '{"keyColumn":"order_number","records":[{"order_number":"INV-1","total_amount":"150000"}]}',
        'signature':
            '714efab14a0e2de847d83d51fc143b97cbab65bc080d8fcc58b2da8dec5d552c',
      },
    };

    vectors.forEach((nonce, vector) {
      test('vektor $nonce: kanonis dan HMAC sama dengan Apps Script', () {
        final payload = vector['payload'];

        expect(AppsScriptSignature.canonicalJson(payload), vector['canonical']);
        expect(
          AppsScriptSignature.sign(
            timestamp: timestamp,
            nonce: nonce,
            action: action,
            secret: secret,
            payload: payload,
          ),
          vector['signature'],
        );
      });
    });

    test('nominal double integral dinormalisasi agar tidak jadi 150000.0', () {
      expect(
        AppsScriptSignature.canonicalJson({'total': 150000.0}),
        '{"total":150000}',
      );
    });

    test('urutan kunci tidak memengaruhi hasil', () {
      final left = AppsScriptSignature.canonicalJson({
        'b': 1,
        'a': {
          'z': 1,
          'y': [
            {'q': 1, 'p': 2},
          ],
        },
      });
      final right = AppsScriptSignature.canonicalJson({
        'a': {
          'y': [
            {'p': 2, 'q': 1},
          ],
          'z': 1,
        },
        'b': 1,
      });

      expect(left, right);
      expect(left, '{"a":{"y":[{"p":2,"q":1}],"z":1},"b":1}');
    });
  });

  group('AppsScriptClient — integrasi belum dipasang', () {
    test(
      'URL kosong membuat semua panggilan jadi no-op tanpa jaringan',
      () async {
        final client = AppsScriptClient(execUrl: '', secret: '', readKey: '');

        expect(client.isConfigured, isFalse);

        final pushed = await client.push('orders.rows.append', {
          'order_number': 'INV-1',
        });
        expect(pushed.isNotConfigured, isTrue);
        expect(pushed.ok, isFalse);

        // flags() sengaja null, bukan exception, agar layar tetap memakai default.
        expect(await client.flags(), isNull);
      },
    );

    test('URL /dev ditolak karena selalu membalas HTML login', () {
      // AppConfig.appsScriptExecUrl menormalkan /dev menjadi string kosong,
      // dan klien memperlakukan string kosong sebagai belum terpasang.
      final client = AppsScriptClient(execUrl: '', secret: 'x');
      expect(client.isConfigured, isFalse);
    });

    test('URL http biasa ditolak', () {
      final client = AppsScriptClient(
        execUrl: 'http://script.google.com/macros/s/ID/exec',
        secret: 'x',
      );
      expect(client.isConfigured, isFalse);
    });

    test('nonce berbeda tiap panggilan (anti-replay Apps Script)', () {
      final seen = <String>{
        for (var i = 0; i < 200; i++) AppsScriptClient.newNonceStatic(),
      };
      expect(seen.length, 200);
    });
  });

  group('decodeEnvelope', () {
    test('membaca keberhasilan dari field ok, bukan status HTTP', () {
      final ok = decodeEnvelope(
        '{"ok":true,"action":"x","data":{"written":1}}',
      );
      expect(ok, isNotNull);
      expect(AppsScriptResult.fromJson(ok!).ok, isTrue);
      expect(AppsScriptResult.fromJson(ok).data['written'], 1);
    });

    test('penolakan signature terbaca sebagai kegagalan', () {
      final json = decodeEnvelope(
        '{"ok":false,"error":{"code":"bad_signature","message":"HMAC tidak cocok"}}',
      );
      final result = AppsScriptResult.fromJson(json!);

      expect(result.ok, isFalse);
      expect(result.code, 'bad_signature');
      expect(result.isNotConfigured, isFalse);
    });

    test('HTML login Google terbaca sebagai bad_envelope, bukan exception', () {
      expect(decodeEnvelope('<html><body>Sign in</body></html>'), isNull);
      expect(decodeEnvelope(''), isNull);
      expect(decodeEnvelope(null), isNull);
    });
  });
}
