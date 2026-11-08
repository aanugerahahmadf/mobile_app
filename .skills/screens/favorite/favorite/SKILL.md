---
name: favorite
description: Implementasi layar Favorit (Favoritescreen) pada fitur Favorit; route /favorite dan /Favorite, 3 endpoint, 3 tabel, state, guardrail, dan definition of done.
---

# Skill: Favorit

> **Tipe:** Daftar / koleksi · **Route:** `/favorite dan /Favorite` · **Akses:** Sanctum · **State:** Tidak terdeteksi

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Favorit (Favoritescreen) di fitur Favorit.
File utama: lib/Features/Favorite/Presentation/Screens/Favorite/Favoritescreen.dart. Route: /favorite dan /Favorite (Sanctum).
Tujuan: Menampilkan item favorit (paket/katalog) dan memungkinkan membuka detail atau menghapusnya.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/favorite/favorite.md
- State management: Tidak terdeteksi; pola data: request-response.
- Endpoint: GET /Favorite; DELETE /Favorite/{packageId}; POST /Favorite/toggle.
- Tabel: favorites, packages, catalogs.
- Parameter/extra: Dua route (`/favorite`, `/Favorite`) menuju layar yang sama.

Wajib dipertahankan:
- Item katalog dan paket tampil dengan tipe yang benar.
- Hapus langsung menghilangkan item dari daftar.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: lihat detail bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `Favoritescreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Favorite/Presentation/Screens/Favorite/Favoritescreen.dart` |
| Route | `/favorite dan /Favorite` |
| Akses | Sanctum |
| Parameter | Dua route (`/favorite`, `/Favorite`) menuju layar yang sama. |
| Masuk dari | Dari `ProfileScreen`, `SettingsScreen`, atau tombol favorit. |
| Provider | `authProvider`, `favoriteProvider` |
| Model | `ItemModel` |
| Endpoint | 3 |
| Tabel | 3 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/favorite/favorite.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Favorite/Presentation/Screens/Favorite/Favoritescreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Favorite/Presentation/Providers/FavoriteProvider/FavoriteProvider.dart` | State/aksi domain |
| Model | `lib/Features/Catalog/Data/Models/ItemModel/ItemModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Favorit/` | Test happy path + error path |
| PRD | `.docs/screens/favorite/favorite.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/favorite/favorite/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan item favorit (paket/katalog) dan memungkinkan membuka detail atau menghapusnya.

1. Muat daftar favorit.
2. Tampilkan resource_type dan data paket/katalog.
3. Buka detail item.
4. Hapus favorit dengan tipe resource yang benar.

### 5.2 Elemen UI wajib

- Grid/list favorit
- Badge tipe
- Tombol hapus
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
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `hapus gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Item katalog dan paket tampil dengan tipe yang benar.
- Hapus langsung menghilangkan item dari daftar.
- Pagination tidak boleh meminta halaman yang sama berulang.
- Refresh mereset halaman dan daftar.
- Hapus item secara optimistis hanya bila aksi reversibel; jika tidak, tunggu respons.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/favorite/favorite.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Favorite/Presentation/Screens/Favorite/Favoritescreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/favorite dan /Favorite`.
4. Verifikasi endpoint ke backend: GET /Favorite; DELETE /Favorite/{packageId}; POST /Favorite/toggle.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `kosong`.
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
| `GET` | `/Favorite` | `FavoriteController@index` | Sanctum | Daftar favorit |
| `DELETE` | `/Favorite/{packageId}` | `FavoriteController@removeFromFavorite` | Sanctum | Menghapus favorit |
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
| `favorites` | `id`, `user_id`, `package_id`, `catalog_id`, `created_at`, `updated_at` |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |

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
rg "Favoritescreen" lib
flutter analyze
flutter test test/Features/Favorit

# dari root backend
php artisan route:list --path=api | Select-String "/Favorite"

# dari PostgreSQL
\d+ favorites
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Casing client `/favorite` vs backend `/Favorite` (GAP-03).
- `removeFromFavorite` tidak menerima `isCatalog` dari provider (GAP-04).
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
