---
name: search
description: Implementasi layar Pencarian (SearchScreen) pada fitur Pencarian; route /search, 2 endpoint, 5 tabel, state, guardrail, dan definition of done.
---

# Skill: Pencarian

> **Tipe:** Konten / navigasi · **Route:** `/search` · **Akses:** Guest + Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Pencarian (SearchScreen) di fitur Pencarian.
File utama: lib/Features/Search/Presentation/Screens/Search/SearchScreen.dart. Route: /search (Guest + Sanctum).
Tujuan: Pencarian teks, saran, pencarian gambar, dan (rencana) pencarian suara.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/search/search.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /search; POST /search/image.
- Tabel: search_logs, catalogs, packages, cbir_searches, cbir_search_results.
- Parameter/extra: `extra: {query}` opsional untuk mengisi search bar.

Wajib dipertahankan:
- Query kosong tidak memanggil API.
- Gambar dikompres sebelum upload.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: cari bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `SearchScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Search/Presentation/Screens/Search/SearchScreen.dart` |
| Route | `/search` |
| Akses | Guest + Sanctum |
| Parameter | `extra: {query}` opsional untuk mengisi search bar. |
| Masuk dari | Dari Home atau deep link dengan `extra.query`. |
| Provider | `searchProvider`, `cbirProvider` |
| Model | `SearchSuggestion` |
| Endpoint | 2 |
| Tabel | 5 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/search/search.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Search/Presentation/Screens/Search/SearchScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Search/Presentation/Providers/SearchProvider/SearchProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Cbir/Presentation/Providers/CbirProvider/CbirProvider.dart` | State/aksi domain |
| Model | `lib/Features/Search/Data/Models/SearchSuggestion/SearchSuggestion.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Pencarian/` | Test happy path + error path |
| PRD | `.docs/screens/search/search.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/search/search/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Pencarian teks, saran, pencarian gambar, dan (rencana) pencarian suara.

1. Tampilkan saran saat mengetik.
2. Cari teks ke `/search`.
3. Ambil gambar dari kamera/galeri untuk CBIR.
4. Buka detail hasil.

### 5.2 Elemen UI wajib

- Search bar
- Saran
- Riwayat
- Tombol kamera/galeri
- Tombol mikrofon
- Empty state

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `initial` | Kerangka/placeholder awal | Muat data |
| `loading` | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Render konten utama | — |
| `empty` | Empty state dengan penjelasan + CTA | Refresh atau aksi lanjutan |
| `error` | Pesan ramah + tombol coba lagi | Retry |
| `unauthorized` | Sesi berakhir; arahkan login/Landing | Login ulang |
| `offline` | Banner/empty offline | Coba lagi saat online |
| `submitting` | Tombol disabled + progress | Selesai atau tampilkan error |
| `refreshing` | Spinner di atas konten | Selesai; reset halaman |
| `pagination` | Loader footer | Muat halaman berikutnya |
| `guest` | `GuestAuthPrompt` | Login |
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `izin kamera ditolak` | Tampilkan penjelasan izin dan tombol buka pengaturan. | Ikuti aksi pemulihan pada pesan |
| `audio ditolak` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Query kosong tidak memanggil API.
- Gambar dikompres sebelum upload.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/search/search.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Search/Presentation/Screens/Search/SearchScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/search`.
4. Verifikasi endpoint ke backend: GET /search; POST /search/image.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di `AppRouter`.
2. Terapkan guard: Guest boleh membuka layar, tetapi aksi privat harus memunculkan `GuestAuthPrompt` dan tidak mengirim Bearer token kosong.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan widget yang sudah ada bila cocok.
2. Gunakan `AppColors`, `AppTextStyles`, `AppSizes`, `AppLocalizations`.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `pagination`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.
4. Implementasikan pagination: simpan `currentPage`/`hasMore`, reset saat refresh.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Cari.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/search` | `SearchController@byText` | Sanctum | Pencarian teks |
| `POST` | `/search/image` | `SearchController@byImage` | Sanctum | Pencarian gambar/video |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `query` | `required|string|min:1` | `/search` |
| `image` | `required|file|mimes:jpeg,png,jpg,bmp,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/search/image` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `search_logs` | `id`, `query`, `user_id`, `ip_address`, `user_agent`, `created_at`, `updated_at` |
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `cbir_searches` | `id`, `user_id`, `query_image_url`, `results_count`, `top_similarity`, `created_at`, `updated_at` |
| `cbir_search_results` | `id`, `search_id`, `type`, `item_id`, `similarity`, `score`, `created_at`, `updated_at` |

| Model | Field kunci |
|---|---|
| `SearchSuggestion` | `type`, `id`, `name`, `subtitle`, `subtitle2`, `imageUrl`, `routePath`, `routeExtra` |

## 9. State minimum

| State | Harus ada |
|---|---|
| `initial` | Ya |
| `loading` | Ya |
| `content` | Ya |
| `empty` | Ya |
| `error` | Ya |
| `unauthorized` | Ya |
| `offline` | Ya |
| `submitting` | Ya |
| `refreshing` | Ya |
| `pagination` | Ya |
| `guest` | Ya |
| `kosong` | Ya |
| `izin kamera ditolak` | Ya |
| `audio ditolak` | Ya |

## 10. Guardrail

- Jangan mengarang endpoint, parameter, atau kolom database.
- Jangan membuat instance `Dio` baru di widget; gunakan `DioClient`/repository.
- Jangan memanggil API di `build()` atau setiap rebuild.
- Jangan menyimpan token/password/PIN di `SharedPreferences` atau log.
- Jangan menampilkan stack trace/pesan database ke pengguna.
- Jangan menambah dependensi baru tanpa alasan dan persetujuan.
- Jangan mengubah route/parameter tanpa memperbarui `AppRouter` dan dokumen.
- Jangan menghapus test yang ada untuk membuat build lulus.

## 11. Definition of Done

- [ ] Semua elemen UI di §5.2 tampil dan berfungsi.
- [ ] Semua state di §5.3/§9 tertangani, termasuk error dan offline.
- [ ] Kontrak endpoint dan tabel tidak berubah tanpa update PRD/peta endpoint.
- [ ] Tidak ada panggilan API langsung dari `build()` atau instance Dio baru.
- [ ] Nominal/stok/status berasal dari backend.
- [ ] 401 membersihkan token dan mengarahkan ke Landing/login.
- [ ] Tidak ada overflow di 320 px, landscape, dan text scale 200%.
- [ ] Mode terang/gelap terbaca dan target sentuh ≥48 dp.
- [ ] `flutter analyze` bersih.
- [ ] Test happy path + minimal satu error path lulus.
- [ ] PRD dan SKILL diperbarui bila ada perubahan.

## 12. Verifikasi

```powershell
# dari root mobile_app
rg "SearchScreen" lib
flutter analyze
flutter test test/Features/Pencarian

# dari root backend
php artisan route:list --path=api | Select-String "/search"

# dari PostgreSQL
\d+ search_logs
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Tombol mikrofon merekam `.m4a` lalu mengirim ke `/search/image` yang hanya menerima gambar/video (GAP-08).
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
