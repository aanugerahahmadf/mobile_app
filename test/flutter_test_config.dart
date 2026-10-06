// Berkas ini otomatis dijalankan Flutter SEBELUM setiap berkas test.
//
// Dua inisialisasi global yang tadinya harus diulang manual di tiap test:
//   1. dotenv  — AppConfig/DioClient membaca API_BASE_URL saat repository
//                dibuat, jadi tanpa ini test gagal dengan
//                "NotInitializedError: DotEnv has not been initialized".
//   2. intl    — Formatters memakai DateFormat(..., 'id'); tanpa
//                initializeDateFormatting() locale 'id' tidak ada sehingga
//                DateFormat melempar dan kode jatuh ke fallback string ISO.
//
// PENTING: .env dibaca langsung dari disk, BUKAN lewat `dotenv.load()`.
// `load()` internally memakai `rootBundle`, dan menyentuh rootBundle akan
// meng-initialize WidgetsFlutterBinding. Test yang memanggil
// `TestWidgetsFlutterBinding.ensureInitialized()` di main() lalu meledak dengan
// "Binding is already initialized to WidgetsFlutterBinding".
//
// CATATAN API: flutter_dotenv 6.x memakai named parameter —
// `loadFromString({envString})`. Paket `dotenv` versi 5.x yang memakai
// `load(fileInput:)` tidak dipakai di proyek ini.

import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

const String _fallbackEnv = '''
API_BASE_URL=http://127.0.0.1:8000/api
PUSHER_APP_KEY=test
PUSHER_APP_CLUSTER=mt1
GOOGLE_CLIENT_ID=test-client
FIREBASE_API_KEY=test-key
''';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (!dotenv.isInitialized) {
    final envFile = File('.env');
    dotenv.loadFromString(
      envString: envFile.existsSync() ? envFile.readAsStringSync() : _fallbackEnv,
    );
  }

  await initializeDateFormatting();

  await testMain();
}
