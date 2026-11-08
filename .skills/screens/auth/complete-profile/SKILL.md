---
name: auth-complete-profile
description: Implementasi layar Lengkapi Profil & Verifikasi Identitas (CompleteProfileScreen) pada fitur Auth & Keamanan; route /complete-profile, 14 endpoint, 9 tabel, state, guardrail, dan definition of done.
---

# Skill: Lengkapi Profil & Verifikasi Identitas

> **Tipe:** Formulir · **Route:** `/complete-profile` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Lengkapi Profil & Verifikasi Identitas (CompleteProfileScreen) di fitur Auth & Keamanan.
File utama: lib/Features/Auth/Presentation/Screens/CompleteProfile/CompleteProfileScreen.dart. Route: /complete-profile (Sanctum).
Tujuan: Melengkapi data pribadi, alamat, dokumen identitas, selfie, dan face scan sebelum akun dianggap siap.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/auth/complete-profile.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /profile; POST /profile; PUT /profile; GET /profile/completion; POST /profile/avatar; PUT /profile/{documentType} …
- Tabel: users, identity_documents, user_addresses, media, reference_options, indonesia_provinces, indonesia_cities, indonesia_districts, indonesia_villages.
- Parameter/extra: `extra: {section: string}` menggulir ke bagian tertentu.

Wajib dipertahankan:
- Profil tersimpan sebagian tanpa kehilangan data lain.
- Dokumen yang ditolak menampilkan alasan dan dapat diunggah ulang.
- Persentase kelengkapan berubah setelah setiap upload.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: simpan profil bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `CompleteProfileScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Auth/Presentation/Screens/CompleteProfile/CompleteProfileScreen.dart` |
| Route | `/complete-profile` |
| Akses | Sanctum |
| Parameter | `extra: {section: string}` menggulir ke bagian tertentu. |
| Masuk dari | Setelah OTP/registrasi, dari `ProfileScreen`, atau deep link dengan `section`. |
| Provider | `authProvider`, `profileProvider`, `dropdownOptionsProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 14 |
| Tabel | 9 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/auth/complete-profile.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Auth/Presentation/Screens/CompleteProfile/CompleteProfileScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Profile/Presentation/Providers/ProfileProvider/ProfileProvider.dart` | State/aksi domain |
| Provider | `lib/Core/Reference/DropdownOptionsProvider/DropdownOptionsProvider.dart` | State/aksi domain |
| Test | `test/Features/Auth/` | Test happy path + error path |
| PRD | `.docs/screens/auth/complete-profile.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/auth/complete-profile/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Melengkapi data pribadi, alamat, dokumen identitas, selfie, dan face scan sebelum akun dianggap siap.

1. Muat profil, completion, dan opsi dropdown/wilayah.
2. Isi nama, username, WhatsApp, identitas, dan alamat.
3. Unggah avatar, dokumen identitas, selfie, dan face scan.
4. Tampilkan hasil verifikasi AI per dokumen.
5. Simpan dan arahkan ke Security Question/Home.

### 5.2 Elemen UI wajib

- Form multi-bagian
- Progress kelengkapan
- Upload avatar
- Kartu dokumen identitas
- Selfie & face scan
- Validasi WhatsApp

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
| `completion < 50%` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `dokumen ditolak AI` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `selfie tidak cocok` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `upload gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Profil tersimpan sebagian tanpa kehilangan data lain.
- Dokumen yang ditolak menampilkan alasan dan dapat diunggah ulang.
- Persentase kelengkapan berubah setelah setiap upload.
- Validasi client untuk UX; validasi final di backend.
- Pertahankan input saat 422/network error.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/auth/complete-profile.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Auth/Presentation/Screens/CompleteProfile/CompleteProfileScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/complete-profile`.
4. Verifikasi endpoint ke backend: GET /profile; POST /profile; PUT /profile; GET /profile/completion; POST /profile/avatar; PUT /profile/{documentType} …
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `completion < 50%`, `dokumen ditolak AI`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Simpan Profil.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/profile` | `ProfileController@show` | Sanctum | Membaca/memperbarui profil |
| `POST` | `/profile` | `AuthController@updateProfile` | Sanctum | Membaca/memperbarui profil |
| `PUT` | `/profile` | `ProfileController@update` | Sanctum | Membaca/memperbarui profil |
| `GET` | `/profile/completion` | `ProfileController@completion` | Sanctum | Menghitung kelengkapan profil |
| `POST` | `/profile/avatar` | `ProfileController@updateAvatar` | Sanctum | Mengunggah avatar |
| `PUT` | `/profile/{documentType}` | `ProfileController@updateDocument` | Sanctum | Menyimpan nomor dokumen identitas |
| `POST` | `/profile/{documentType}-photo` | `ProfileController@uploadDocument` | Sanctum | Mengunggah foto dokumen identitas |
| `POST` | `/profile/selfie` | `ProfileController@uploadSelfie` | Sanctum | Mengunggah selfie verifikasi |
| `POST` | `/profile/face-scan` | `ProfileController@uploadFaceScan` | Sanctum | Mengunggah face scan |
| `GET` | `/dropdown-options` | `DropdownOptionController@index` | Publik | Opsi dropdown profil |
| `GET` | `/regions/provinces` | `RegionController@provinces` | Publik | Daftar provinsi |
| `GET` | `/regions/cities/{provinceCode}` | `RegionController@cities` | Publik | Daftar kota dalam provinsi |
| `GET` | `/regions/districts/{cityCode}` | `RegionController@districts` | Publik | Daftar kecamatan dalam kota |
| `GET` | `/regions/villages/{districtCode}` | `RegionController@villages` | Publik | Daftar desa dalam kecamatan |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `full_name` | `nullable|string|max:255` | `/profile` |
| `first_name` | `nullable|string|max:255` | `/profile` |
| `mid_name` | `nullable|string|max:255` | `/profile` |
| `last_name` | `nullable|string|max:255` | `/profile` |
| `username` | `nullable|string|max:255|unique:users,username,` | `/profile` |
| `email` | `nullable|email|max:255|unique:users,email,` | `/profile` |
| `whatsapp` | `nullable|string|max:20` | `/profile` |
| `identity_type` | `nullable|string|in:ktp,passport,sim,npwp|max:20` | `/profile` |
| `ktp_number` | `nullable|string|max:20|unique:users,ktp_number,` | `/profile` |
| `passport_number` | `nullable|string|max:20|unique:users,passport_number,` | `/profile` |
| `sim_number` | `nullable|string|max:20|unique:users,sim_number,` | `/profile` |
| `npwp_number` | `nullable|string|max:20|unique:users,npwp_number,` | `/profile` |
| `gender` | `nullable|string|max:20` | `/profile` |
| `religion` | `nullable|string|max:50` | `/profile` |
| `marital_status` | `nullable|string|max:50` | `/profile` |
| `mother_name` | `nullable|string|max:255` | `/profile` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |
| `identity_documents` | `id`, `user_id`, `document_type`, `document_number`, `photo_path`, `ai_document_type`, `ai_document_number`, `ai_reason` … |
| `user_addresses` | `id`, `user_id`, `name`, `phone`, `address`, `city`, `province`, `postal_code` … |
| `media` | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type` … |
| `reference_options` | `id`, `type`, `key`, `label`, `sort_order`, `is_active`, `created_at`, `updated_at` |
| `indonesia_provinces` | `id`, `code`, `name`, `meta`, `created_at`, `updated_at` |
| `indonesia_cities` | `id`, `code`, `province_code`, `name`, `meta`, `created_at`, `updated_at` |
| `indonesia_districts` | `id`, `code`, `city_code`, `name`, `meta`, `created_at`, `updated_at` |
| `indonesia_villages` | `id`, `code`, `district_code`, `name`, `meta`, `created_at`, `updated_at` |

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
| `completion < 50%` | Ya |
| `dokumen ditolak AI` | Ya |
| `selfie tidak cocok` | Ya |
| `upload gagal` | Ya |

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
rg "CompleteProfileScreen" lib
flutter analyze
flutter test test/Features/Auth

# dari root backend
php artisan route:list --path=api | Select-String "/profile"

# dari PostgreSQL
\d+ users
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- `CompleteProfileScreen` sangat besar (2173 baris); pecah menjadi widget per bagian.
- Alamat yang disimpan di sini tidak otomatis dipakai checkout (lihat GAP-06).
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
