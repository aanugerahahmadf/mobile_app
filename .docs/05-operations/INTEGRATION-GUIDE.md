# Panduan Integrasi Mobile → Laravel → PostgreSQL

## 1. Alur kerja yang benar

```text
1. Baca PRD layar + skill layar.
2. Identifikasi endpoint dan tabel yang dipakai.
3. Verifikasi endpoint ada di `php artisan route:list`.
4. Verifikasi kontrak request/response dari controller.
5. Implementasikan repository/provider.
6. Implementasikan state UI (loading/empty/error/unauthorized).
7. Uji dengan data nyata di PostgreSQL lokal.
8. Perbarui PRD, skill, dan peta endpoint jika kontrak berubah.
```

## 2. Menambah endpoint baru

### 2.1 Backend

1. Tambahkan route di `routes/api/user/<Controller>/<Controller>/<Controller>.php`.
2. Pastikan prefix `api` dan middleware `auth:sanctum` untuk endpoint privat.
3. Tambahkan validasi `FormRequest` atau `$request->validate`.
4. Gunakan `$request->user()` untuk kepemilikan data.
5. Bungkus operasi multi-tabel dalam `DB::transaction`.
6. Kembalikan envelope konsisten:

```json
{"status":"success","message":"...","data":{}}
```

7. Tambahkan test Pest untuk happy path, validasi, dan unauthorized.

### 2.2 Mobile

1. Tambahkan konstanta di `ApiEndpoints` **hanya jika belum ada**.
2. Tambahkan method di repository domain.
3. Mapping response ke model typed.
4. Tambahkan provider/notifier.
5. Tambahkan state UI.
6. Tambahkan test unit untuk mapping/error.

## 3. Menambah layar

1. Buat folder `lib/Features/<Feature>/Presentation/Screens/<Screen>/`.
2. Buat screen + widget.
3. Daftarkan route di `AppRouter` jika layar adalah halaman.
4. Tambahkan entry point yang jelas.
5. Tambahkan PRD di `.docs/screens/<feature>/<Screen>.md`.
6. Tambahkan skill di `.skills/screens/<feature>/<Screen>/SKILL.md`.
7. Perbarui `SCREEN-INDEX.md`.
8. Uji back navigation dan deep link.

## 4. Standar repository

```dart
abstract class ExampleRepository {
  Future<ExampleModel> getExample(String id);
}

class ExampleRepositoryImpl implements ExampleRepository {
  ExampleRepositoryImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;
  final Dio _dio;

  @override
  Future<ExampleModel> getExample(String id) async {
    final response = await _dio.get(ApiEndpoints.example(id));
    return ExampleModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
```

Aturan:

- Constructor menerima `Dio?` untuk testability.
- Jangan membuat `Dio()` baru di method.
- Jangan menelan error tanpa rethrow/mapping.
- Gunakan `DioClient.safeCall` jika sudah menjadi pola fitur.

## 5. Standar provider

```dart
final exampleProvider =
    NotifierProvider<ExampleNotifier, ExampleState>(ExampleNotifier.new);

class ExampleNotifier extends Notifier<ExampleState> {
  @override
  ExampleState build() => const ExampleInitial();

  Future<void> load(String id) async {
    state = const ExampleLoading();
    try {
      final data = await ref.read(exampleRepositoryProvider).getExample(id);
      state = ExampleLoaded(data);
    } catch (e) {
      state = ExampleError(mapError(e));
    }
  }
}
```

## 6. Pemetaan error

Gunakan `Failure` dari `Core/Errors`. Jangan menampilkan `e.toString()` mentah.

```dart
String userMessage(Object error) {
  if (error is DioException) {
    final failure = error.error;
    if (failure is ValidationFailure) return 'Periksa kembali data Anda.';
    if (failure is NetworkFailure) return 'Periksa koneksi internet.';
    if (failure is AuthFailure) return 'Sesi berakhir. Silakan masuk lagi.';
  }
  return 'Terjadi kesalahan. Coba lagi.';
}
```

## 7. Upload

1. Gunakan `MultipartFile.fromFile`.
2. Batasi ukuran di client (mis. 5 MB untuk foto).
3. Tampilkan progress.
4. Tangani `413`/timeout.
5. Jangan mengirim file jika token tidak ada.

## 8. Pembayaran

- Jangan pernah menghitung total final di client.
- Jangan menandai `paid` berdasarkan respons UI.
- Setelah `POST /bookings`, simpan `orderId` dan navigasi ke pembayaran.
- Untuk VA/QRIS, tampilkan data dari respons backend (`virtual_account_no`, `qr_content`, `expiry`).
- Setelah upload bukti, status menjadi “menunggu verifikasi”, bukan “lunas”.
- Polling status harus dibatasi dan dihentikan saat layar dispose.

## 9. Chat

- Bedakan jalur login dan guest.
- Jangan mencampur `inboxId` guest dengan endpoint login.
- Tangani `403`/`404` jika inbox bukan milik pengguna.
- Untuk attachment, validasi tipe dan ukuran.
- Untuk panggilan, backend `ChatCallController` dan endpoint `/messages/calls*` sudah tersedia; uji izin mikrofon/kamera, lifecycle, dan fallback saat sinyal buruk.

## 10. Database

- Baca tabel yang benar, jangan menebak dari nama endpoint.
- `history` memakai `GET /wallet/history`, bukan `GET /histories`.
- Favorit memakai `favorites`.
- Ulasan katalog memakai `reviews.catalog_id`.
- Pesanan memakai `orders`, bukan `bookings` (nama tabel).
- Status pembayaran ada di `orders.payment_status` dan `transactions.status`.

## 11. Checklist PR

- [ ] Route terdaftar dan tidak duplikat.
- [ ] Endpoint ada di backend.
- [ ] Request/response sesuai controller.
- [ ] Auth dan kepemilikan data divalidasi.
- [ ] Loading/empty/error/unauthorized ada.
- [ ] Tidak ada token/PII di log.
- [ ] `flutter analyze` untuk file yang diubah.
- [ ] Test manual di emulator/perangkat.
- [ ] PRD + skill + index diperbarui.
- [ ] Tidak menambah dependency tanpa alasan.

## 12. Verifikasi cepat backend

```powershell
cd D:\WeddingFlowersDecorationApp\Mobile-And-Backend
php artisan route:list --path=api
php artisan test
```

## 13. Verifikasi cepat mobile

```powershell
cd D:\WeddingFlowersDecorationApp\mobile_app
flutter analyze
flutter test
```
