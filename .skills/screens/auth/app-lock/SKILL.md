---
name: auth-app-lock
description: Implementasi layar App Lock (AppLockScreen) pada fitur Auth & Keamanan; route /app-lock, 6 endpoint, 3 tabel, state, guardrail, dan definition of done.
---

# Skill: App Lock

> **Tipe:** Autentikasi & keamanan · **Route:** `/app-lock` · **Akses:** Sanctum + lokal · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar App Lock (AppLockScreen) di fitur Auth & Keamanan.
File utama: lib/Features/Auth/Presentation/Screens/AppLock/AppLockScreen.dart. Route: /app-lock (Sanctum + lokal).
Tujuan: Mengunci aplikasi dengan PIN, biometrik, atau password perangkat dan membuka kunci sebelum masuk ke layar terakhir.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/auth/app-lock.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /profile/app-lock; PUT /profile/app-lock; POST /profile/app-lock/pin/verify; POST /profile/app-lock/face-verify; POST /auth/send-otp; POST /auth/verify-otp.
- Tabel: users, security_events, whatsapp_otps.
- Parameter/extra: Tidak menerima parameter. `pre_lock_route` disimpan di SharedPreferences.

Wajib dipertahankan:
- Aplikasi terkunci saat lifecycle resume bila flag aktif.
- PIN benar membuka aplikasi tanpa memanggil ulang login.
- Reset PIN hanya berhasil setelah OTP terverifikasi.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: buka kunci bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `AppLockScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Auth/Presentation/Screens/AppLock/AppLockScreen.dart` |
| Route | `/app-lock` |
| Akses | Sanctum + lokal |
| Parameter | Tidak menerima parameter. `pre_lock_route` disimpan di SharedPreferences. |
| Masuk dari | Otomatis saat aplikasi dibuka/diresume bila app lock aktif, atau setelah login/2FA. |
| Provider | `appLockServiceProvider`, `currentAccountEmailProvider`, `authProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 6 |
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
| PRD | `.docs/screens/auth/app-lock.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Auth/Presentation/Screens/AppLock/AppLockScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Test | `test/Features/Auth/` | Test happy path + error path |
| PRD | `.docs/screens/auth/app-lock.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/auth/app-lock/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Mengunci aplikasi dengan PIN, biometrik, atau password perangkat dan membuka kunci sebelum masuk ke layar terakhir.

1. Baca status app lock dari backend dan flag lokal per akun.
2. Tampilkan PIN pad; pengguna dapat beralih ke biometrik atau password.
3. Verifikasi PIN/wajah ke backend atau biometrik ke perangkat.
4. Jika lupa PIN, kirim OTP dan reset app lock.
5. Setelah berhasil, buka `pre_lock_route` atau `/home`.

### 5.2 Elemen UI wajib

- PIN pad 6 digit
- Tombol biometrik
- Tautan lupa PIN
- Dialog reset via OTP
- Indikator akun aktif

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
| `loading status` | Skeleton/spinner; blokir aksi ganda. | Ikuti aksi pemulihan pada pesan |
| `PIN salah` | Tampilkan error tanpa membocorkan detail; izinkan coba lagi. | Ikuti aksi pemulihan pada pesan |
| `biometrik tidak tersedia` | Tampilkan fallback PIN/password bila biometrik gagal. | Ikuti aksi pemulihan pada pesan |
| `OTP gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `akun terkunci sementara` | Tampilkan countdown/instruksi pemulihan; jangan bocorkan detail. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Aplikasi terkunci saat lifecycle resume bila flag aktif.
- PIN benar membuka aplikasi tanpa memanggil ulang login.
- Reset PIN hanya berhasil setelah OTP terverifikasi.
- Jangan menyimpan password/PIN plaintext; gunakan secure storage untuk token.
- Terapkan rate limit/lockout dan jangan membocorkan apakah akun terdaftar.
- OTP/challenge memiliki masa berlaku; tangani kedaluwarsa.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/auth/app-lock.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Auth/Presentation/Screens/AppLock/AppLockScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/app-lock`.
4. Verifikasi endpoint ke backend: GET /profile/app-lock; PUT /profile/app-lock; POST /profile/app-lock/pin/verify; POST /profile/app-lock/face-verify; POST /auth/send-otp; POST /auth/verify-otp.
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

1. Implementasikan state: `initial`, `loading`, `content`, `error`, `unauthorized`, `offline`, `submitting`, `loading status`, `PIN salah`, `biometrik tidak tersedia`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Buka Kunci.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/profile/app-lock` | `AppLockController@show` | Sanctum | Konfigurasi app lock |
| `PUT` | `/profile/app-lock` | `AppLockController@update` | Sanctum | Konfigurasi app lock |
| `POST` | `/profile/app-lock/pin/verify` | `AppLockController@verifyPin` | Sanctum | Memverifikasi PIN app lock |
| `POST` | `/profile/app-lock/face-verify` | `AppLockController@faceVerify` | Sanctum | Memverifikasi wajah app lock |
| `POST` | `/auth/send-otp` | `AuthController@sendOtp` | Publik | Mengirim OTP email/WhatsApp |
| `POST` | `/auth/verify-otp` | `AuthController@verifyOtp` | Publik | Memverifikasi OTP |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `fingerprint_enabled` | `sometimes|boolean` | `/profile/app-lock` |
| `face_enabled` | `sometimes|boolean` | `/profile/app-lock` |
| `pin_enabled` | `sometimes|boolean` | `/profile/app-lock` |
| `pin` | `required|string|size:6|digits:6` | `/profile/app-lock/pin/verify` |
| `face_photo` | `required|image|mimes:jpg,jpeg,png|max:10240` | `/profile/app-lock/face-verify` |
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
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |
| `security_events` | `id`, `event`, `method`, `path`, `status`, `ip_address`, `user_agent`, `user_id` … |
| `whatsapp_otps` | `id`, `whatsapp`, `otp_code`, `expires_at`, `verified_at`, `created_at`, `updated_at` |

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
| `loading status` | Ya |
| `PIN salah` | Ya |
| `biometrik tidak tersedia` | Ya |
| `OTP gagal` | Ya |
| `akun terkunci sementara` | Ya |

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
rg "AppLockScreen" lib
flutter analyze
flutter test test/Features/Auth

# dari root backend
php artisan route:list --path=api | Select-String "/profile/app-lock"

# dari PostgreSQL
\d+ users
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- PIN disimpan sebagai hash di `users.app_lock_pin_hash`; flag per akun juga disimpan lokal.
- Jangan menampilkan konten sensitif di snapshot task switcher.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
