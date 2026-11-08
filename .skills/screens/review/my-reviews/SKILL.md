---
name: review-my-reviews
description: Implementasi layar Ulasan Saya (MyReviewsScreen) pada fitur Ulasan; route /my-reviews, 4 endpoint, 5 tabel, state, guardrail, dan definition of done.
---

# Skill: Ulasan Saya

> **Tipe:** Formulir · **Route:** `/my-reviews` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Ulasan Saya (MyReviewsScreen) di fitur Ulasan.
File utama: lib/Features/Review/Presentation/Screens/MyReviews/MyReviewsScreen.dart. Route: /my-reviews (Sanctum).
Tujuan: Menampilkan ulasan milik pengguna dan memungkinkan edit/hapus.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/review/my-reviews.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /reviews/user; PUT /reviews/{id}; DELETE /reviews/{id}; GET /catalog/{id}.
- Tabel: reviews, catalogs, packages, media, categories.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Ulasan yang dihapus hilang dari daftar.
- Edit mempertahankan rating dan komentar.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: kirim ulasan bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `MyReviewsScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Review/Presentation/Screens/MyReviews/MyReviewsScreen.dart` |
| Route | `/my-reviews` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Dari `ProfileScreen` atau tautan di voucher. |
| Provider | `authProvider`, `myReviewsProvider` |
| Model | `MyReviewModel` |
| Endpoint | 4 |
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
| PRD | `.docs/screens/review/my-reviews.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Review/Presentation/Screens/MyReviews/MyReviewsScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Review/Presentation/Providers/MyReviewsProvider/MyReviewsProvider.dart` | State/aksi domain |
| Model | `lib/Features/Review/Data/Models/MyReviewModel/MyReviewModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Ulasan/` | Test happy path + error path |
| PRD | `.docs/screens/review/my-reviews.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/review/my-reviews/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan ulasan milik pengguna dan memungkinkan edit/hapus.

1. Muat `reviews/user`.
2. Tampilkan rating, komentar, foto.
3. Edit atau hapus ulasan.
4. Buka katalog terkait.

### 5.2 Elemen UI wajib

- Daftar ulasan
- Rating bintang
- Foto
- Menu edit/hapus
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
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `hapus gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Ulasan yang dihapus hilang dari daftar.
- Edit mempertahankan rating dan komentar.
- Validasi client untuk UX; validasi final di backend.
- Pertahankan input saat 422/network error.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/review/my-reviews.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Review/Presentation/Screens/MyReviews/MyReviewsScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/my-reviews`.
4. Verifikasi endpoint ke backend: GET /reviews/user; PUT /reviews/{id}; DELETE /reviews/{id}; GET /catalog/{id}.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `pagination`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.
4. Implementasikan pagination: simpan `currentPage`/`hasMore`, reset saat refresh.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Kirim Ulasan.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/reviews/user` | `ReviewController@getUserReviews` | Sanctum | Ulasan milik pengguna |
| `PUT` | `/reviews/{id}` | `ReviewController@update` | Sanctum | Memperbarui/menghapus ulasan |
| `DELETE` | `/reviews/{id}` | `ReviewController@destroy` | Sanctum | Memperbarui/menghapus ulasan |
| `GET` | `/catalog/{id}` | `CatalogController@show` | Sanctum | Detail katalog |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `rating` | `sometimes|required|integer|min:1|max:5` | `/reviews/{id}` |
| `comment` | `sometimes|nullable|string|max:1000` | `/reviews/{id}` |
| `title` | `sometimes|nullable|string|max:255` | `/reviews/{id}` |
| `is_anonymous` | `sometimes|boolean` | `/reviews/{id}` |
| `photo` | `nullable|file|mimes:jpeg,png,jpg,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/reviews/{id}` |
| `photos` | `nullable|array|max:6` | `/reviews/{id}` |
| `photos.*` | `file|mimes:jpeg,png,jpg,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/reviews/{id}` |
| `removed_photo_urls` | `nullable|array` | `/reviews/{id}` |
| `removed_photo_urls.*` | `string` | `/reviews/{id}` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `reviews` | `id`, `user_id`, `package_id`, `catalog_id`, `rating`, `comment`, `created_at`, `updated_at` … |
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `media` | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type` … |
| `categories` | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at` … |

| Model | Field kunci |
|---|---|
| `MyReviewModel` | `id`, `userId`, `catalogId`, `packageId`, `orderId`, `rating`, `title`, `comment` |

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
| `kosong` | Ya |
| `hapus gagal` | Ya |

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
rg "MyReviewsScreen" lib
flutter analyze
flutter test test/Features/Ulasan

# dari root backend
php artisan route:list --path=api | Select-String "/reviews/user"

# dari PostgreSQL
\d+ reviews
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Tidak ada gap khusus; tetap hormati kontrak backend.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
