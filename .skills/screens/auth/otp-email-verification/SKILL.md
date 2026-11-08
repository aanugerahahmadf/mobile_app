---
name: auth-otp-email-verification
description: Implementasi layar Verifikasi OTP Email (OtpEmailVerificationScreen) pada fitur Auth & Keamanan; route /otp-email-verification, 2 endpoint, 2 tabel, state, guardrail, dan definition of done.
---

# Skill: Verifikasi OTP Email

> **Tipe:** Autentikasi & keamanan · **Route:** `/otp-email-verification` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Verifikasi OTP Email (OtpEmailVerificationScreen) di fitur Auth & Keamanan.
File utama: lib/Features/Auth/Presentation/Screens/OtpEmailVerification/OtpEmailVerificationScreen.dart. Route: /otp-email-verification (Sanctum).
Tujuan: Memverifikasi kode OTP untuk email baru atau verifikasi email.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/auth/otp-email-verification.md
- State management: Riverpod + state lokal (`setState`); pola data: polling periodik.
- Endpoint: POST /auth/send-otp; POST /auth/verify-otp.
- Tabel: whatsapp_otps, users.
- Parameter/extra: `extra: {email, purpose}`; `purpose` default `verify_email`.

Wajib dipertahankan:
- Kode benar menutup layar dan memperbarui status email.
- Kirim ulang tidak dapat ditekan sebelum cooldown selesai.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: verifikasi bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `OtpEmailVerificationScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Auth/Presentation/Screens/OtpEmailVerification/OtpEmailVerificationScreen.dart` |
| Route | `/otp-email-verification` |
| Akses | Sanctum |
| Parameter | `extra: {email, purpose}`; `purpose` default `verify_email`. |
| Masuk dari | Dari `RecentEmailsScreen`/pengaturan keamanan dengan `extra.email` dan `extra.purpose`. |
| Provider | `authProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 2 |
| Tabel | 2 |

- Timer/polling harus diuji saat app background/resume dan saat dispose.

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/auth/otp-email-verification.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Auth/Presentation/Screens/OtpEmailVerification/OtpEmailVerificationScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Test | `test/Features/Auth/` | Test happy path + error path |
| PRD | `.docs/screens/auth/otp-email-verification.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/auth/otp-email-verification/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Memverifikasi kode OTP untuk email baru atau verifikasi email.

1. Tampilkan email tujuan dan jumlah digit.
2. Kirim ulang OTP dengan cooldown.
3. Verifikasi kode ke `/auth/verify-otp`.
4. Perbarui status email dan kembali.

### 5.2 Elemen UI wajib

- Field OTP
- Tombol kirim ulang
- Timer cooldown
- Email tujuan

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `initial` | Kerangka/placeholder awal | Muat data |
| `loading` | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Render konten utama | — |
| `error` | Pesan ramah + tombol coba lagi | Retry |
| `unauthorized` | Sesi berakhir; arahkan login/Landing | Login ulang |
| `offline` | Banner/empty offline | Coba lagi saat online |
| `submitting` | Tombol disabled + progress | Selesai atau tampilkan error |
| `kode salah` | Tampilkan error tanpa membocorkan detail; izinkan coba lagi. | Ikuti aksi pemulihan pada pesan |
| `kode kedaluwarsa` | Tampilkan status kedaluwarsa dan aksi muat ulang. | Ikuti aksi pemulihan pada pesan |
| `batas kirim ulang` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Kode benar menutup layar dan memperbarui status email.
- Kirim ulang tidak dapat ditekan sebelum cooldown selesai.
- Jangan menyimpan password/PIN plaintext; gunakan secure storage untuk token.
- Terapkan rate limit/lockout dan jangan membocorkan apakah akun terdaftar.
- OTP/challenge memiliki masa berlaku; tangani kedaluwarsa.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/auth/otp-email-verification.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Auth/Presentation/Screens/OtpEmailVerification/OtpEmailVerificationScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/otp-email-verification`.
4. Verifikasi endpoint ke backend: POST /auth/send-otp; POST /auth/verify-otp.
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

1. Implementasikan state: `initial`, `loading`, `content`, `error`, `unauthorized`, `offline`, `submitting`, `kode salah`, `kode kedaluwarsa`, `batas kirim ulang`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.
4. Kelola timer/polling: mulai setelah layar siap, hentikan di `dispose`/background.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Verifikasi.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `POST` | `/auth/send-otp` | `AuthController@sendOtp` | Publik | Mengirim OTP email/WhatsApp |
| `POST` | `/auth/verify-otp` | `AuthController@verifyOtp` | Publik | Memverifikasi OTP |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `email` | `required_without:whatsapp|email` | `/auth/send-otp` |
| `whatsapp` | `required_without:email|string` | `/auth/send-otp` |
| `purpose` | `required|string|in:google_register,forgot_password,verify_email,reset_app_lock,verify_whatsapp` | `/auth/send-otp` |
| `email` | `required_without:whatsapp|email` | `/auth/verify-otp` |
| `whatsapp` | `required_without:email|string` | `/auth/verify-otp` |
| `otp` | `required|string|size:6` | `/auth/verify-otp` |
| `purpose` | `required|string|in:google_register,forgot_password,verify_email,reset_app_lock,verify_whatsapp` | `/auth/verify-otp` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `whatsapp_otps` | `id`, `whatsapp`, `otp_code`, `expires_at`, `verified_at`, `created_at`, `updated_at` |
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |

## 9. State minimum

| State | Harus ada |
|---|---|
| `initial` | Ya |
| `loading` | Ya |
| `content` | Ya |
| `error` | Ya |
| `unauthorized` | Ya |
| `offline` | Ya |
| `submitting` | Ya |
| `kode salah` | Ya |
| `kode kedaluwarsa` | Ya |
| `batas kirim ulang` | Ya |

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
rg "OtpEmailVerificationScreen" lib
flutter analyze
flutter test test/Features/Auth

# dari root backend
php artisan route:list --path=api | Select-String "/auth/send-otp"

# dari PostgreSQL
\d+ whatsapp_otps
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- `purpose` harus diteruskan ke backend; client saat ini mengirim nilai default `verify_email`.
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
