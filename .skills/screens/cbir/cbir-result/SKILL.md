---
name: cbir-result
description: Implementasi layar Hasil Pencarian Gambar (CbirResultScreen) pada fitur Pencarian Gambar; route /cbir-result, 4 endpoint, 6 tabel, state, guardrail, dan definition of done.
---

# Skill: Hasil Pencarian Gambar

> **Tipe:** Konten / navigasi · **Route:** `/cbir-result` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Hasil Pencarian Gambar (CbirResultScreen) di fitur Pencarian Gambar.
File utama: lib/Features/Cbir/Presentation/Screens/CbirResult/CbirResultScreen.dart. Route: /cbir-result (Sanctum).
Tujuan: Menampilkan hasil pencarian visual (CBIR) berupa katalog/paket yang mirip.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/cbir/cbir-result.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: POST /search/image; POST /cbir/search; POST /cbir/arithmetic; GET /categories.
- Tabel: search_logs, cbir_searches, cbir_search_results, catalogs, packages, categories.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Hasil menampilkan minimal gambar, nama, dan harga.
- Kegagalan AI menampilkan opsi coba lagi.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: ulangi pencarian atau kembali bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `CbirResultScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Cbir/Presentation/Screens/CbirResult/CbirResultScreen.dart` |
| Route | `/cbir-result` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Setelah pengguna memilih/merekam gambar dari `SearchScreen`. |
| Provider | `cbirProvider` |
| Model | `CbirResultItem` |
| Endpoint | 4 |
| Tabel | 6 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/cbir/cbir-result.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Cbir/Presentation/Screens/CbirResult/CbirResultScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Cbir/Presentation/Providers/CbirProvider/CbirProvider.dart` | State/aksi domain |
| Model | `lib/Features/Cbir/Data/Models/CbirResultModel/CbirResultModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Pencarian/` | Test happy path + error path |
| PRD | `.docs/screens/cbir/cbir-result.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/cbir/cbir-result/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan hasil pencarian visual (CBIR) berupa katalog/paket yang mirip.

1. Terima hasil dari `CbirProvider` atau jalankan pencarian.
2. Tampilkan grid hasil dengan skor kemiripan.
3. Buka detail item.
4. Ulangi pencarian atau kembali.

### 5.2 Elemen UI wajib

- Grid hasil
- Skor kemiripan
- Tombol ulangi
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
| `tidak ada hasil` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `gambar terlalu besar` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `error AI` | Pesan ramah, tombol coba lagi, pertahankan data lama bila ada. | Ikuti aksi pemulihan pada pesan |
| `video tidak didukung` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Hasil menampilkan minimal gambar, nama, dan harga.
- Kegagalan AI menampilkan opsi coba lagi.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/cbir/cbir-result.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Cbir/Presentation/Screens/CbirResult/CbirResultScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/cbir-result`.
4. Verifikasi endpoint ke backend: POST /search/image; POST /cbir/search; POST /cbir/arithmetic; GET /categories.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di `AppRouter`.
2. Terapkan guard: Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan widget yang sudah ada bila cocok.
2. Gunakan `AppColors`, `AppTextStyles`, `AppSizes`, `AppLocalizations`.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `tidak ada hasil`, `gambar terlalu besar`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Ulangi pencarian atau kembali.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `POST` | `/search/image` | `SearchController@byImage` | Sanctum | Pencarian gambar/video |
| `POST` | `/cbir/search` | `CBIRController@searchSimilar` | Sanctum | Pencarian kemiripan CBIR |
| `POST` | `/cbir/arithmetic` | `CBIRController@arithmeticSearch` | Sanctum | Operasi aritmetika vektor CBIR |
| `GET` | `/categories` | `CategoryController@index` | Sanctum | Daftar kategori |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `image` | `required|file|mimes:jpeg,png,jpg,bmp,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/search/image` |
| `image` | `required|file|mimes:jpeg,png,jpg,bmp,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/cbir/search` |
| `image_1` | `required|image|max:10240` | `/cbir/arithmetic` |
| `image_2` | `required|image|max:10240` | `/cbir/arithmetic` |
| `operation` | `required|string|in:add,average,subtract,multiply,divide` | `/cbir/arithmetic` |
| `weights` | `nullable|array` | `/cbir/arithmetic` |
| `weights.*` | `numeric|min:0|max:1` | `/cbir/arithmetic` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `search_logs` | `id`, `query`, `user_id`, `ip_address`, `user_agent`, `created_at`, `updated_at` |
| `cbir_searches` | `id`, `user_id`, `query_image_url`, `results_count`, `top_similarity`, `created_at`, `updated_at` |
| `cbir_search_results` | `id`, `search_id`, `type`, `item_id`, `similarity`, `score`, `created_at`, `updated_at` |
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `categories` | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at` … |

| Model | Field kunci |
|---|---|
| `CbirResultItem` | `type`, `similarity`, `sCore`, `catalogId`, `data` |

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
| `tidak ada hasil` | Ya |
| `gambar terlalu besar` | Ya |
| `error AI` | Ya |
| `video tidak didukung` | Ya |

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
rg "CbirResultScreen" lib
flutter analyze
flutter test test/Features/Pencarian

# dari root backend
php artisan route:list --path=api | Select-String "/search/image"

# dari PostgreSQL
\d+ search_logs
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Layar menerima state lewat provider; tidak ada parameter route.
- Pencarian suara tidak boleh diarahkan ke layar ini sebelum endpoint transkripsi tersedia.
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
