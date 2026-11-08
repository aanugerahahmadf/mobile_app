---
name: catalog-detail
description: Implementasi layar Detail Katalog (CatalogDetailScreen) pada fitur Katalog; route /catalog/:id, 9 endpoint, 11 tabel, state, guardrail, dan definition of done.
---

# Skill: Detail Katalog

> **Tipe:** Formulir · **Route:** `/catalog/:id` · **Akses:** Guest + Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Detail Katalog (CatalogDetailScreen) di fitur Katalog.
File utama: lib/Features/Catalog/Presentation/Screens/CatalogDetail/CatalogDetailScreen.dart. Route: /catalog/:id (Guest + Sanctum).
Tujuan: Menampilkan detail katalog/paket, tier, harga, stok, ulasan, favorit, dan aksi tambah ke keranjang.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/catalog/catalog-detail.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /catalog/{id}; GET /catalog/{id}/tiers; POST /Favorite/toggle; POST /cart/add; GET /reviews/catalog/{catalogId}; GET /reviews/catalog/{id}/summary …
- Tabel: catalogs, categories, packages, reviews, media, favorites, carts, review_replies, review_votes, users, orders.
- Parameter/extra: Path parameter `id` wajib. Tidak ada `extra`.

Wajib dipertahankan:
- Tier wajib dipilih sebelum menambah keranjang.
- Harga yang ditampilkan mengikuti tier aktif.
- Favorit memperbarui ikon tanpa reload penuh.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: lihat detail bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `CatalogDetailScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Catalog/Presentation/Screens/CatalogDetail/CatalogDetailScreen.dart` |
| Route | `/catalog/:id` |
| Akses | Guest + Sanctum |
| Parameter | Path parameter `id` wajib. Tidak ada `extra`. |
| Masuk dari | Dari `HomeScreen`, `CatalogGridScreen`, `Favoritescreen`, atau deep link. |
| Provider | `catalogRepositoryProvider`, `authProvider`, `chatProvider`, `reviewProvider` |
| Model | `TierModel` |
| Endpoint | 9 |
| Tabel | 11 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/catalog/catalog-detail.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Catalog/Presentation/Screens/CatalogDetail/CatalogDetailScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Catalog/Presentation/Providers/CatalogProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Chat/Presentation/Providers/ChatProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Review/Presentation/Providers/ReviewProvider/ReviewProvider.dart` | State/aksi domain |
| Model | `lib/Features/Catalog/Data/Models/TierModel/TierModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Katalog/` | Test happy path + error path |
| PRD | `.docs/screens/catalog/catalog-detail.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/catalog/catalog-detail/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan detail katalog/paket, tier, harga, stok, ulasan, favorit, dan aksi tambah ke keranjang.

1. Muat detail katalog dan tier.
2. Pilih tier dan kuantitas.
3. Tambah ke keranjang atau favorit.
4. Baca ulasan dan ringkasan rating.
5. Buka laporan atau tulis ulasan.

### 5.2 Elemen UI wajib

- Galeri gambar
- Nama & harga
- Pemilih tier
- Stok
- Tombol favorit
- Tombol tambah keranjang
- Daftar ulasan

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
| `guest` | `GuestAuthPrompt` | Login |
| `tidak ditemukan` | Tampilkan halaman not found dengan tombol kembali. | Ikuti aksi pemulihan pada pesan |
| `stok habis` | Tampilkan badge stok habis dan nonaktifkan aksi beli. | Ikuti aksi pemulihan pada pesan |
| `guest mencoba favorit` | Tampilkan `GuestAuthPrompt`; jangan panggil endpoint privat. | Ikuti aksi pemulihan pada pesan |
| `review kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Tier wajib dipilih sebelum menambah keranjang.
- Harga yang ditampilkan mengikuti tier aktif.
- Favorit memperbarui ikon tanpa reload penuh.
- Validasi client untuk UX; validasi final di backend.
- Pertahankan input saat 422/network error.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/catalog/catalog-detail.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Catalog/Presentation/Screens/CatalogDetail/CatalogDetailScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/catalog/:id`.
4. Verifikasi endpoint ke backend: GET /catalog/{id}; GET /catalog/{id}/tiers; POST /Favorite/toggle; POST /cart/add; GET /reviews/catalog/{catalogId}; GET /reviews/catalog/{id}/summary …
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `guest`, `tidak ditemukan`.
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
| `GET` | `/catalog/{id}` | `CatalogController@show` | Sanctum | Detail katalog |
| `GET` | `/catalog/{id}/tiers` | `CatalogController@tiers` | Publik | Tier/paket dari katalog |
| `POST` | `/Favorite/toggle` | `FavoriteController@toggle` | Sanctum | Menambah/menghapus favorit |
| `POST` | `/cart/add` | `CartController@store` | Sanctum | Menambah item ke keranjang |
| `GET` | `/reviews/catalog/{catalogId}` | `ReviewController@getCatalogReviews` | Sanctum | Ulasan sebuah katalog |
| `GET` | `/reviews/catalog/{id}/summary` | `ReviewController@getCatalogRatingSummary` | Sanctum | Ringkasan rating katalog |
| `POST` | `/reviews/{id}/vote` | `ReviewController@voteHelpful` | Sanctum | Vote ulasan membantu |
| `GET` | `/reviews` | `ReviewController@getAllReviews` | Sanctum | Membuat/membaca ulasan |
| `POST` | `/reviews` | `ReviewController@store` | Sanctum | Membuat/membaca ulasan |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `package_id` | `nullable|exists:packages,id` | `/Favorite/toggle` |
| `catalog_id` | `nullable|exists:catalogs,id` | `/Favorite/toggle` |
| `catalog_id` | `required|exists:catalogs,id` | `/cart/add` |
| `package_id` | `required|exists:packages,id` | `/cart/add` |
| `quantity` | `required|integer|min:1` | `/cart/add` |
| `package_id` | `nullable|exists:packages,id` | `/reviews` |
| `catalog_id` | `nullable|exists:catalogs,id` | `/reviews` |
| `order_id` | `nullable|exists:orders,id` | `/reviews` |
| `variation` | `nullable|string|max:255` | `/reviews` |
| `specifications` | `nullable|array` | `/reviews` |
| `is_anonymous` | `nullable|boolean` | `/reviews` |
| `rating` | `required|integer|min:1|max:5` | `/reviews` |
| `comment` | `nullable|string|max:1000` | `/reviews` |
| `title` | `nullable|string|max:255` | `/reviews` |
| `photo` | `nullable|file|mimes:jpeg,png,jpg,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/reviews` |
| `photos` | `nullable|array|max:6` | `/reviews` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `categories` | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at` … |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `reviews` | `id`, `user_id`, `package_id`, `catalog_id`, `rating`, `comment`, `created_at`, `updated_at` … |
| `media` | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type` … |
| `favorites` | `id`, `user_id`, `package_id`, `catalog_id`, `created_at`, `updated_at` |
| `carts` | `id`, `user_id`, `catalog_id`, `package_id`, `quantity`, `meta`, `created_at`, `updated_at` |
| `review_replies` | `id`, `review_id`, `user_id`, `comment`, `created_at`, `updated_at` |
| `review_votes` | `id`, `user_id`, `review_id`, `created_at`, `updated_at` |
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |
| `orders` | `id`, `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status` … |

| Model | Field kunci |
|---|---|
| `TierModel` | `id`, `catalogId`, `name`, `description`, `price`, `discountPrice`, `finalPrice`, `stock` |

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
| `guest` | Ya |
| `tidak ditemukan` | Ya |
| `stok habis` | Ya |
| `guest mencoba favorit` | Ya |
| `review kosong` | Ya |

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
rg "CatalogDetailScreen" lib
flutter analyze
flutter test test/Features/Katalog

# dari root backend
php artisan route:list --path=api | Select-String "/catalog/"

# dari PostgreSQL
\d+ catalogs
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Guest dapat melihat detail hanya jika endpoint katalog publik tersedia; saat ini `/catalog/{id}` privat.
- Laporan memakai `openReportChat`, bukan `ReportSubmitScreen`.
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
