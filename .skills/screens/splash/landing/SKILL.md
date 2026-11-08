---
name: splash-landing
description: Implementasi layar Landing (LandingScreen) pada fitur Splash & Landing; route /landing, 8 endpoint, 4 tabel, state, guardrail, dan definition of done.
---

# Skill: Landing

> **Tipe:** Konten / navigasi · **Route:** `/landing` · **Akses:** Publik · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Landing (LandingScreen) di fitur Splash & Landing.
File utama: lib/Features/Splash/Presentation/Screens/Landing/LandingScreen.dart. Route: /landing (Publik).
Tujuan: Gerbang masuk: login, registrasi, login sosial, atau lanjut sebagai guest.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/splash/landing.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: ANY /login; ANY /register; POST /auth/google; POST /auth/facebook; POST /auth/apple; POST /auth/send-otp …
- Tabel: users, personal_access_tokens, whatsapp_otps, backup_codes.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Login sukses menyimpan token dan membuka Home/AppLock.
- Guest dapat masuk tanpa token.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: masuk sebagai guest bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `LandingScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Splash/Presentation/Screens/Landing/LandingScreen.dart` |
| Route | `/landing` |
| Akses | Publik |
| Parameter | Tidak ada |
| Masuk dari | Awal aplikasi setelah startup, atau setelah logout. |
| Provider | `authProvider`, `currentAccountEmailProvider`, `localeProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 8 |
| Tabel | 4 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/splash/landing.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Splash/Presentation/Screens/Landing/LandingScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart` | State/aksi domain |
| Provider | `lib/Core/Providers/LocaleProvider/LocaleProvider.dart` | State/aksi domain |
| Test | `test/Features/Splash/` | Test happy path + error path |
| PRD | `.docs/screens/splash/landing.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/splash/landing/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Gerbang masuk: login, registrasi, login sosial, atau lanjut sebagai guest.

1. Tampilkan branding dan tombol masuk.
2. Buka modal login/registrasi.
3. Login Google/Facebook/Apple.
4. Masuk sebagai guest.

### 5.2 Elemen UI wajib

- Logo
- Tombol masuk
- Tombol daftar
- Tombol sosial
- Tombol guest
- Modal auth

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `initial` | Kerangka/placeholder awal | Muat data |
| `loading` | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Render konten utama | — |
| `empty` | Empty state dengan penjelasan + CTA | Refresh atau aksi lanjutan |
| `error` | Pesan ramah + tombol coba lagi | Retry |
| `offline` | Banner/empty offline | Coba lagi saat online |
| `submitting` | Tombol disabled + progress | Selesai atau tampilkan error |
| `login gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `2FA diperlukan` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `akun terkunci` | Tampilkan countdown/instruksi pemulihan; jangan bocorkan detail. | Ikuti aksi pemulihan pada pesan |
| `guest` | Tampilkan `GuestAuthPrompt`; jangan panggil endpoint privat. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Login sukses menyimpan token dan membuka Home/AppLock.
- Guest dapat masuk tanpa token.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/splash/landing.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Splash/Presentation/Screens/Landing/LandingScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/landing`.
4. Verifikasi endpoint ke backend: ANY /login; ANY /register; POST /auth/google; POST /auth/facebook; POST /auth/apple; POST /auth/send-otp …
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di `AppRouter`.
2. Terapkan guard: Tidak membutuhkan token. Tetap tangani 401/403 bila endpoint berubah menjadi privat.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan widget yang sudah ada bila cocok.
2. Gunakan `AppColors`, `AppTextStyles`, `AppSizes`, `AppLocalizations`.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `offline`, `submitting`, `login gagal`, `2FA diperlukan`, `akun terkunci`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Masuk sebagai guest.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `ANY` | `/login` | `-` | Tidak ada | Masuk dengan email dan password |
| `ANY` | `/register` | `-` | Tidak ada | Registrasi akun baru |
| `POST` | `/auth/google` | `AuthController@googleLogin` | Publik | Login Google memakai Firebase ID token |
| `POST` | `/auth/facebook` | `AuthController@facebookLogin` | Publik | Login Facebook |
| `POST` | `/auth/apple` | `AuthController@appleLogin` | Publik | Login Apple |
| `POST` | `/auth/send-otp` | `AuthController@sendOtp` | Publik | Mengirim OTP email/WhatsApp |
| `POST` | `/auth/verify-otp` | `AuthController@verifyOtp` | Publik | Memverifikasi OTP |
| `POST` | `/auth/two-factor/verify` | `AuthController@verifyTwoFactor` | Publik | Memverifikasi tantangan 2FA |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `firebase_id_token` | `required|string` | `/auth/google` |
| `access_token` | `required|string` | `/auth/facebook` |
| `fields` | `id,name,email,picture` | `/auth/facebook` |
| `identity_token` | `required|string` | `/auth/apple` |
| `email` | `required_without:whatsapp|email` | `/auth/send-otp` |
| `whatsapp` | `required_without:email|string` | `/auth/send-otp` |
| `purpose` | `required|string|in:google_register,forgot_password,verify_email,reset_app_lock,verify_whatsapp` | `/auth/send-otp` |
| `email` | `required_without:whatsapp|email` | `/auth/verify-otp` |
| `whatsapp` | `required_without:email|string` | `/auth/verify-otp` |
| `otp` | `required|string|size:6` | `/auth/verify-otp` |
| `purpose` | `required|string|in:google_register,forgot_password,verify_email,reset_app_lock,verify_whatsapp` | `/auth/verify-otp` |
| `challenge_token` | `required|string` | `/auth/two-factor/verify` |
| `code` | `required|string|max:12` | `/auth/two-factor/verify` |
| `method` | `nullable|string|in:` | `/auth/two-factor/verify` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |
| `personal_access_tokens` | `id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at` … |
| `whatsapp_otps` | `id`, `whatsapp`, `otp_code`, `expires_at`, `verified_at`, `created_at`, `updated_at` |
| `backup_codes` | `id`, `user_id`, `code`, `used`, `used_at`, `created_at`, `updated_at` |

## 9. State minimum

| State | Harus ada |
|---|---|
| `initial` | Ya |
| `loading` | Ya |
| `content` | Ya |
| `empty` | Ya |
| `error` | Ya |
| `offline` | Ya |
| `submitting` | Ya |
| `login gagal` | Ya |
| `2FA diperlukan` | Ya |
| `akun terkunci` | Ya |
| `guest` | Ya |

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
rg "LandingScreen" lib
flutter analyze
flutter test test/Features/Splash

# dari root backend
php artisan route:list --path=api | Select-String "/login"

# dari PostgreSQL
\d+ users
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- `POST /login` dan `/register` tidak tersedia di backend (GAP-01).
- Login Google memakai Firebase ID token, sesi tetap Sanctum.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
