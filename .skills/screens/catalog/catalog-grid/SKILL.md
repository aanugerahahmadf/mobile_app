---
name: catalog-grid
description: Implementasi layar Grid Katalog (CatalogGridScreen) pada fitur Katalog; route /catalog, 3 endpoint, 5 tabel, state, guardrail, dan definition of done.
---

# Skill: Grid Katalog

> **Tipe:** Daftar / koleksi · **Route:** `/catalog` · **Akses:** Guest + Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Grid Katalog (CatalogGridScreen) di fitur Katalog.
File utama: lib/Features/Catalog/Presentation/Screens/CatalogGrid/CatalogGridScreen.dart. Route: /catalog (Guest + Sanctum).
Tujuan: Menampilkan katalog dengan filter kategori, pencarian, dan paginasi.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/catalog/catalog-grid.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /catalog; GET /categories; POST /Favorite/toggle.
- Tabel: catalogs, categories, packages, media, favorites.
- Parameter/extra: `extra: {category_id: string}` opsional untuk filter awal.

Wajib dipertahankan:
- Filter kategori mengulang paginasi dari halaman 1.
- Tidak ada duplikasi item saat memuat halaman berikutnya.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: lihat detail bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `CatalogGridScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Catalog/Presentation/Screens/CatalogGrid/CatalogGridScreen.dart` |
| Route | `/catalog` |
| Akses | Guest + Sanctum |
| Parameter | `extra: {category_id: string}` opsional untuk filter awal. |
| Masuk dari | Dari Home (tombol lihat semua) atau `extra.category_id`. |
| Provider | `catalogRepositoryProvider` |
| Model | `ItemModel` |
| Endpoint | 3 |
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
| PRD | `.docs/screens/catalog/catalog-grid.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Catalog/Presentation/Screens/CatalogGrid/CatalogGridScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Catalog/Presentation/Providers/CatalogProvider.dart` | State/aksi domain |
| Model | `lib/Features/Catalog/Data/Models/ItemModel/ItemModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Katalog/` | Test happy path + error path |
| PRD | `.docs/screens/catalog/catalog-grid.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/catalog/catalog-grid/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan katalog dengan filter kategori, pencarian, dan paginasi.

1. Muat kategori dan halaman pertama katalog.
2. Filter berdasarkan kategori.
3. Scroll untuk memuat halaman berikutnya.
4. Buka detail katalog.

### 5.2 Elemen UI wajib

- Grid kartu
- Chip kategori
- Search bar
- Indikator loading bawah
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
| `guest` | `GuestAuthPrompt` | Login |
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `guest 401` | Tampilkan `GuestAuthPrompt`; jangan panggil endpoint privat. | Ikuti aksi pemulihan pada pesan |
| `habis halaman` | Tampilkan penanda akhir daftar atau status kedaluwarsa. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Filter kategori mengulang paginasi dari halaman 1.
- Tidak ada duplikasi item saat memuat halaman berikutnya.
- Pagination tidak boleh meminta halaman yang sama berulang.
- Refresh mereset halaman dan daftar.
- Hapus item secara optimistis hanya bila aksi reversibel; jika tidak, tunggu respons.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/catalog/catalog-grid.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Catalog/Presentation/Screens/CatalogGrid/CatalogGridScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/catalog`.
4. Verifikasi endpoint ke backend: GET /catalog; GET /categories; POST /Favorite/toggle.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `guest`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Lihat Detail.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/catalog` | `CatalogController@index` | Sanctum | Daftar katalog dengan filter/paginasi |
| `GET` | `/categories` | `CategoryController@index` | Sanctum | Daftar kategori |
| `POST` | `/Favorite/toggle` | `FavoriteController@toggle` | Sanctum | Menambah/menghapus favorit |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `package_id` | `nullable|exists:packages,id` | `/Favorite/toggle` |
| `catalog_id` | `nullable|exists:catalogs,id` | `/Favorite/toggle` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `categories` | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at` … |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `media` | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type` … |
| `favorites` | `id`, `user_id`, `package_id`, `catalog_id`, `created_at`, `updated_at` |

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
| `submitting` | Ya |
| `refreshing` | Ya |
| `guest` | Ya |
| `kosong` | Ya |
| `guest 401` | Ya |
| `habis halaman` | Ya |

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
rg "CatalogGridScreen" lib
flutter analyze
flutter test test/Features/Katalog

# dari root backend
php artisan route:list --path=api | Select-String "/catalog"

# dari PostgreSQL
\d+ catalogs
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- `/catalog` dan `/categories` memerlukan Sanctum; guest gagal memuat (GAP-02).
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
