---
name: profile-password-and-security
description: Implementasi layar Password & Keamanan (PasswordAndSecurityScreen) pada fitur Profil & Pengaturan; route /password-and-security, 5 endpoint, 4 tabel, state, guardrail, dan definition of done.
---

# Skill: Password & Keamanan

> **Tipe:** Konten / navigasi · **Route:** `/password-and-security` · **Akses:** Sanctum · **State:** Riverpod (`ConsumerWidget`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Password & Keamanan (PasswordAndSecurityScreen) di fitur Profil & Pengaturan.
File utama: lib/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/PasswordAndSecurityScreen.dart. Route: /password-and-security (Sanctum).
Tujuan: Pusat pengaturan keamanan: password, 2FA, perangkat, sesi, email, dan app lock.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/profile/password-and-security.md
- State management: Riverpod (`ConsumerWidget`); pola data: request-response.
- Endpoint: GET /security/checkup; GET /security/two-factor/status; GET /security/trusted-devices; DELETE /security/trusted-devices; GET /security/saved-login.
- Tabel: users, user_sessions, trusted_devices, backup_codes.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Status 2FA dan perangkat sesuai backend.
- Menu sublayar dapat dibuka.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: buka sublayar terkait bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `PasswordAndSecurityScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/PasswordAndSecurityScreen.dart` |
| Route | `/password-and-security` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Dari `SettingsScreen`. |
| Provider | `authProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 5 |
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
| PRD | `.docs/screens/profile/password-and-security.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/PasswordAndSecurityScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Test | `test/Features/Profil/` | Test happy path + error path |
| PRD | `.docs/screens/profile/password-and-security.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/profile/password-and-security/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Pusat pengaturan keamanan: password, 2FA, perangkat, sesi, email, dan app lock.

1. Muat ringkasan keamanan.
2. Tampilkan status 2FA/perangkat.
3. Buka sublayar terkait.

### 5.2 Elemen UI wajib

- Daftar menu keamanan
- Badge status
- Ikon perangkat
- Loading

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
| `2FA aktif/nonaktif` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `belum ada perangkat` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Status 2FA dan perangkat sesuai backend.
- Menu sublayar dapat dibuka.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/profile/password-and-security.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/PasswordAndSecurityScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/password-and-security`.
4. Verifikasi endpoint ke backend: GET /security/checkup; GET /security/two-factor/status; GET /security/trusted-devices; DELETE /security/trusted-devices; GET /security/saved-login.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `2FA aktif/nonaktif`, `belum ada perangkat`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Buka sublayar terkait.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/security/checkup` | `SecurityController@checkup` | Sanctum | Ringkasan keamanan akun |
| `GET` | `/security/two-factor/status` | `SecurityController@twoFactorStatus` | Sanctum | Status 2FA |
| `GET` | `/security/trusted-devices` | `SecurityController@trustedDevices` | Sanctum | Daftar perangkat tepercaya |
| `DELETE` | `/security/trusted-devices` | `SecurityController@removeAllTrustedDevices` | Sanctum | Daftar perangkat tepercaya |
| `GET` | `/security/saved-login` | `SecurityController@savedLoginStatus` | Sanctum | Status simpan info login |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `key` | `email` | `/security/checkup` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |
| `user_sessions` | `id`, `user_id`, `device_name`, `device_type`, `ip_address`, `user_agent`, `platform`, `is_current` … |
| `trusted_devices` | `id`, `user_id`, `device_name`, `device_fingerprint`, `platform`, `trusted_at`, `created_at`, `updated_at` … |
| `backup_codes` | `id`, `user_id`, `code`, `used`, `used_at`, `created_at`, `updated_at` |

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
| `2FA aktif/nonaktif` | Ya |
| `belum ada perangkat` | Ya |

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
rg "PasswordAndSecurityScreen" lib
flutter analyze
flutter test test/Features/Profil

# dari root backend
php artisan route:list --path=api | Select-String "/security/checkup"

# dari PostgreSQL
\d+ users
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
