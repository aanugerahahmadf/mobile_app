---
name: home
description: Implementasi layar Home (HomeScreen) pada fitur Home; route /home, 3 endpoint, 6 tabel, state, guardrail, dan definition of done.
---

# Skill: Home

> **Tipe:** Konten / navigasi · **Route:** `/home` · **Akses:** Guest + Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Home (HomeScreen) di fitur Home.
File utama: lib/Features/Home/Presentation/Screens/Home/HomeScreen.dart. Route: /home (Guest + Sanctum).
Tujuan: Beranda dengan banner, kategori, katalog unggulan, dan pintu masuk pencarian/CBIR.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/home/home.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /home; GET /catalog; GET /categories.
- Tabel: hero_banners, promotions, categories, catalogs, packages, media.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Data muncul untuk pengguna login.
- Guest melihat prompt login pada aksi yang membutuhkan akun.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: tampilkan sapaan pengguna/guest bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `HomeScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Home/Presentation/Screens/Home/HomeScreen.dart` |
| Route | `/home` |
| Akses | Guest + Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Tab Home setelah startup/landing. |
| Provider | `authProvider`, `notificationListProvider`, `guestModeProvider` |
| Model | `ItemModel` |
| Endpoint | 3 |
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
| PRD | `.docs/screens/home/home.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Home/Presentation/Screens/Home/HomeScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Notification/Presentation/Providers/NotificationProvider/NotificationProvider.dart` | State/aksi domain |
| Provider | `lib/Core/Utils/GuestMode/GuestMode.dart` | State/aksi domain |
| Model | `lib/Features/Catalog/Data/Models/ItemModel/ItemModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Home/` | Test happy path + error path |
| PRD | `.docs/screens/home/home.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/home/home/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Beranda dengan banner, kategori, katalog unggulan, dan pintu masuk pencarian/CBIR.

1. Muat data home, katalog, dan kategori.
2. Tampilkan banner dan kategori.
3. Buka katalog, detail, pencarian, atau CBIR.
4. Tampilkan sapaan pengguna/guest.

### 5.2 Elemen UI wajib

- Banner carousel
- Chip kategori
- Kartu katalog
- Search bar
- Sapaan pengguna

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
| `refreshing` | Spinner di atas konten | Selesai; reset halaman |
| `guest` | `GuestAuthPrompt` | Login |
| `error 401` | Pesan ramah, tombol coba lagi, pertahankan data lama bila ada. | Ikuti aksi pemulihan pada pesan |
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `gambar gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Data muncul untuk pengguna login.
- Guest melihat prompt login pada aksi yang membutuhkan akun.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/home/home.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Home/Presentation/Screens/Home/HomeScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/home`.
4. Verifikasi endpoint ke backend: GET /home; GET /catalog; GET /categories.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `refreshing`, `guest`, `error 401`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Tampilkan sapaan pengguna/guest.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/home` | `HomeController@index` | Sanctum | Data beranda |
| `GET` | `/catalog` | `CatalogController@index` | Sanctum | Daftar katalog dengan filter/paginasi |
| `GET` | `/categories` | `CategoryController@index` | Sanctum | Daftar kategori |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `hero_banners` | `id`, `title`, `subtitle`, `image_url`, `link_url`, `link_type`, `link_id`, `position` … |
| `promotions` | `id`, `title`, `description`, `image_url`, `discount_percent`, `code`, `valid_from`, `valid_until` … |
| `categories` | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at` … |
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `media` | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type` … |

| Model | Field kunci |
|---|---|
| `ItemModel` | `id`, `categoryId`, `name`, `slug`, `description`, `stock`, `isActive`, `isFeatured` |

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
| `refreshing` | Ya |
| `guest` | Ya |
| `error 401` | Ya |
| `kosong` | Ya |
| `gambar gagal` | Ya |

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
rg "HomeScreen" lib
flutter analyze
flutter test test/Features/Home

# dari root backend
php artisan route:list --path=api | Select-String "/home"

# dari PostgreSQL
\d+ hero_banners
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Guest tidak dapat memuat `/home`, `/catalog`, `/categories` karena Sanctum (GAP-02).
- Startup juga memanggil endpoint privat (GAP-14).
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
