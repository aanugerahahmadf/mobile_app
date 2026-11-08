---
name: auth-two-factor-auth
description: Implementasi layar Aktivasi 2FA (Auth Flow) (TwoFactorAuthScreen) pada fitur Auth & Keamanan; route /two-factor-setup, 5 endpoint, 2 tabel, state, guardrail, dan definition of done.
---

# Skill: Aktivasi 2FA (Auth Flow)

> **Tipe:** Autentikasi & keamanan · **Route:** `/two-factor-setup` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Aktivasi 2FA (Auth Flow) (TwoFactorAuthScreen) di fitur Auth & Keamanan.
File utama: lib/Features/Auth/Presentation/Screens/TwoFactorAuth/TwoFactorAuthScreen.dart. Route: /two-factor-setup (Sanctum).
Tujuan: Menyiapkan authenticator/email 2FA di tengah alur autentikasi dan kembali ke Home.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/auth/two-factor-auth.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /security/two-factor/status; POST /security/two-factor/setup; POST /security/two-factor/setup/verify; POST /security/two-factor/setup/resend; POST /security/two-factor/backup-codes.
- Tabel: users, backup_codes.
- Parameter/extra: Tidak menerima parameter.

Wajib dipertahankan:
- 2FA aktif setelah kode verifikasi benar.
- Backup code ditampilkan sekali dan dapat disalin.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: verifikasi bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `TwoFactorAuthScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Auth/Presentation/Screens/TwoFactorAuth/TwoFactorAuthScreen.dart` |
| Route | `/two-factor-setup` |
| Akses | Sanctum |
| Parameter | Tidak menerima parameter. |
| Masuk dari | Dari `SecurityQuestionScreen` atau `TwoFactorVerifyScreen`. |
| Provider | `authProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 5 |
| Tabel | 2 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/auth/two-factor-auth.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Auth/Presentation/Screens/TwoFactorAuth/TwoFactorAuthScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Test | `test/Features/Auth/` | Test happy path + error path |
| PRD | `.docs/screens/auth/two-factor-auth.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/auth/two-factor-auth/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menyiapkan authenticator/email 2FA di tengah alur autentikasi dan kembali ke Home.

1. Muat status 2FA.
2. Tampilkan QR/secret atau opsi email.
3. Verifikasi kode setup.
4. Tampilkan kode cadangan.
5. Selesai ke Home.

### 5.2 Elemen UI wajib

- QR code
- Secret key
- Field kode
- Daftar backup code
- Tombol salin

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
| `2FA sudah aktif` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `kode salah` | Tampilkan error tanpa membocorkan detail; izinkan coba lagi. | Ikuti aksi pemulihan pada pesan |
| `setup kedaluwarsa` | Tampilkan status kedaluwarsa dan aksi muat ulang. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- 2FA aktif setelah kode verifikasi benar.
- Backup code ditampilkan sekali dan dapat disalin.
- Jangan menyimpan password/PIN plaintext; gunakan secure storage untuk token.
- Terapkan rate limit/lockout dan jangan membocorkan apakah akun terdaftar.
- OTP/challenge memiliki masa berlaku; tangani kedaluwarsa.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/auth/two-factor-auth.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Auth/Presentation/Screens/TwoFactorAuth/TwoFactorAuthScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/two-factor-setup`.
4. Verifikasi endpoint ke backend: GET /security/two-factor/status; POST /security/two-factor/setup; POST /security/two-factor/setup/verify; POST /security/two-factor/setup/resend; POST /security/two-factor/backup-codes.
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

1. Implementasikan state: `initial`, `loading`, `content`, `error`, `unauthorized`, `offline`, `submitting`, `2FA sudah aktif`, `kode salah`, `setup kedaluwarsa`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

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
| `GET` | `/security/two-factor/status` | `SecurityController@twoFactorStatus` | Sanctum | Status 2FA |
| `POST` | `/security/two-factor/setup` | `SecurityController@setupTwoFactor` | Sanctum | Memulai setup 2FA |
| `POST` | `/security/two-factor/setup/verify` | `SecurityController@verifyTwoFactorSetup` | Sanctum | Memverifikasi setup 2FA |
| `POST` | `/security/two-factor/setup/resend` | `SecurityController@resendTwoFactorSetupOtp` | Sanctum | Mengirim ulang kode setup 2FA |
| `POST` | `/security/two-factor/backup-codes` | `SecurityController@generateBackupCodes` | Sanctum | Membuat kode cadangan |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `type` | `email` | `/security/two-factor/setup` |
| `method` | `email` | `/security/two-factor/setup` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |
| `backup_codes` | `id`, `user_id`, `code`, `used`, `used_at`, `created_at`, `updated_at` |

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
| `2FA sudah aktif` | Ya |
| `kode salah` | Ya |
| `setup kedaluwarsa` | Ya |

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
rg "TwoFactorAuthScreen" lib
flutter analyze
flutter test test/Features/Auth

# dari root backend
php artisan route:list --path=api | Select-String "/security/two-factor/status"

# dari PostgreSQL
\d+ users
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Berbeda dari `/security/two-factor-setup` yang kembali ke pengaturan keamanan.
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
