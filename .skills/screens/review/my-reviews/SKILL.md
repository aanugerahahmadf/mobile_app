---
name: review-my-reviews
description: Implementasi layar Ulasan Saya (MyReviewsScreen) pada fitur Ulasan; route /my-reviews, 4 endpoint, 5 tabel, state, guardrail, dan definition of done.
---

# Skill: Ulasan Saya

> **Tipe:** Formulir · **Route:** `/my-reviews` · **Akses:** Sanctum · **State:** State management terpusat + state lokal

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Ulasan Saya di fitur Ulasan.
Referensi implementasi saat ini: MyReviewsScreen. Route: /my-reviews (Sanctum).
Tujuan: Menampilkan ulasan milik pengguna dan memungkinkan edit/hapus.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/review/my-reviews.md
- State management: State management terpusat + state lokal; pola data: request-response.
- Endpoint: GET /reviews/user; PUT /reviews/{id}; DELETE /reviews/{id}; GET /catalog/{id}.
- Tabel: reviews, catalogs, packages, media, categories.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Ulasan yang dihapus hilang dari daftar.
- Edit mempertahankan rating dan komentar.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: kirim ulasan bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Ulasan Saya** (referensi implementasi: `MyReviewsScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `MyReviewsScreen` |
| Route | `/my-reviews` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Dari `ProfileScreen` atau tautan di voucher. |
| State/dependency | `authProvider`, `myReviewsProvider` |
| Model | `MyReviewModel` |
| Endpoint | 4 |
| Tabel | 5 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | Konfigurasi router aplikasi |
| Endpoint client | Definisi endpoint API klien |
| HTTP client | HTTP client/data source bersama |
| Desain | Token desain/tema aplikasi |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/review/my-reviews.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `MyReviewsScreen` | UI, state, interaksi |
| State/dependency | `authProvider` | State/aksi domain |
| State/dependency | `myReviewsProvider` | State/aksi domain |
| Model | implementasi referensi aplikasi | Parsing/serialisasi bila kontrak berubah |
| Test | Test otomatis (platform target) di area Ulasan/` | Test happy path + error path |
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
2. Tinjau implementasi referensi `MyReviewsScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/my-reviews`.
4. Verifikasi endpoint ke backend: GET /reviews/user; PUT /reviews/{id}; DELETE /reviews/{id}; GET /catalog/{id}.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di konfigurasi router.
2. Terapkan guard: Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan komponen UI yang sudah ada bila cocok.
2. Gunakan token desain (warna, tipografi, spacing) dan lokalisasi yang konsisten.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `pagination`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
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
- Jangan membuat HTTP client baru di komponen UI; gunakan data source/repository bersama.
- Jangan memanggil API di `build()` atau setiap rebuild.
- Jangan menyimpan token/password/PIN di penyimpanan lokal atau log.
- Jangan menampilkan stack trace/pesan database ke pengguna.
- Jangan menambah dependensi baru tanpa alasan dan persetujuan.
- Jangan mengubah route/parameter tanpa memperbarui konfigurasi router dan dokumen.
- Jangan menghapus test yang ada untuk membuat build lulus.

## 11. Definition of Done

- [ ] Semua elemen UI di §5.2 tampil dan berfungsi.
- [ ] Semua state di §5.3/§9 tertangani, termasuk error dan offline.
- [ ] Kontrak endpoint dan tabel tidak berubah tanpa update PRD/peta endpoint.
- [ ] Tidak ada panggilan API langsung dari siklus render UI atau pembuatan HTTP client baru di komponen UI.
- [ ] Nominal/stok/status berasal dari backend.
- [ ] 401 membersihkan token dan mengarahkan ke Landing/login.
- [ ] Tidak ada overflow di 320 px, landscape, dan text scale 200%.
- [ ] Mode terang/gelap terbaca dan target sentuh ≥48 dp.
- [ ] Analisis statis/lint sesuai toolchain target bersih.
- [ ] Test happy path + minimal satu error path lulus.
- [ ] PRD dan SKILL diperbarui bila ada perubahan.

## 12. Verifikasi

```text
# verifikasi implementasi
- Pastikan komponen/layar referensi `MyReviewsScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target

# verifikasi backend (opsional)
- Cek route API: /reviews/user

# verifikasi database (opsional)
- Cek tabel: reviews
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
