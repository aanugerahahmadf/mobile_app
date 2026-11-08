---
name: api-integration
description: Menghubungkan layar Flutter ke REST Laravel (base URL, header, token, envelope, error, pagination, upload, retry, dan verifikasi kontrak).
---

# Skill: Integrasi API Mobile → Laravel

## 1. Base URL dan header

`DioClient` memakai `API_BASE_URL` yang sudah berakhiran `/api`.

| Header | Nilai |
|---|---|
| `Accept` | `application/json` |
| `Content-Type` | `application/json` atau `multipart/form-data` |
| `Authorization` | `Bearer <token>` (endpoint privat) |
| `Accept-Language` | `id`/`en` dari `localeProvider` |

Jangan menambahkan `/api` di path endpoint.

## 2. Alur request yang benar

```text
Widget → Provider/Notifier → Repository → DioClient → Laravel → PostgreSQL
```

- Widget tidak memanggil Dio.
- Repository mengubah JSON menjadi model/Map yang stabil.
- Provider menyimpan state dan error.
- `DioClient` menangani token, locale, timeout, dan mapping error.

## 3. Envelope

Variasi yang ada:

```json
{"status":"success","message":"...","data":{...}}
```

```json
{"data":[...]}
```

```json
[...]
```

Baca repository masing-masing; jangan mengasumsikan satu bentuk di semua endpoint. Jika menambah endpoint baru, gunakan envelope pertama.

## 4. Error handling

| Status | Aksi |
|---|---|
| 401 | Hapus `auth_token`, reset state auth, `context.go('/landing')` |
| 403 | Tampilkan pesan akses, jangan retry otomatis |
| 404 | Tampilkan not found/empty |
| 422 | Map `errors` ke field form |
| 429 | Tampilkan cooldown, nonaktifkan tombol |
| 5xx/timeout | Tampilkan retry, pertahankan data lama |

## 5. Pagination

- Kirim `page` dan `per_page`.
- Baca `meta.current_page`, `meta.last_page`, atau `next_page_url` sesuai respons.
- Hentikan load more bila `current_page >= last_page`.
- Jangan menduplikasi item saat refresh; reset list sebelum halaman 1.

## 6. Upload

```dart
final form = FormData.fromMap({
  'photo': await MultipartFile.fromFile(path, filename: 'photo.jpg'),
});
await dio.post(ApiEndpoints.profileAvatar, data: form);
```

- Kompres gambar terlebih dahulu.
- Tampilkan progres untuk file besar.
- Tangani 413 (file terlalu besar) dan 422 (tipe salah).
- Jangan mengirim audio ke endpoint gambar (lihat GAP-08).

## 7. Retry dan idempotensi

- Hanya retry request idempoten (GET) atau request yang aman diulang.
- Untuk POST checkout/payment, gunakan tombol disabled + idempotency key bila backend mendukung.
- Jangan retry otomatis 401/403/422.

## 8. Verifikasi kontrak

Sebelum implementasi:

1. Cari konstanta di `ApiEndpoints`.
2. Cocokkan method + path dengan `php artisan route:list --path=api`.
3. Baca controller untuk validation/response.
4. Cek tabel di `\d+ <tabel>`.
5. Catat perbedaan casing/parameter di PRD layar.

## 9. Casing dan parameter

- Backend `/Favorite` case-sensitive; client memakai `/favorite`.
- Perbedaan nama parameter (`{id}` vs `{report}`) tidak masalah bila posisi sama.
- Perbedaan jumlah segmen/metode adalah breaking.
- Route dinamis harus diuji dengan ID nyata.

## 10. Checklist

- [ ] Endpoint ada di route list.
- [ ] Token dikirim hanya ke endpoint privat.
- [ ] `Accept-Language` aktif.
- [ ] Error 401/403/404/422/429/5xx ditangani.
- [ ] Pagination tidak menduplikasi data.
- [ ] Upload memakai field name yang benar.
- [ ] Tidak ada secret di log.
- [ ] PRD + endpoint map diperbarui bila kontrak berubah.
