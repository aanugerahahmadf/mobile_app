---
name: profile-login-activity
description: Implementasi layar Aktivitas Login (LoginActivityScreen) pada fitur Profil & Pengaturan; route /login-activity, 3 endpoint, 2 tabel, state, guardrail, dan definition of done.
---

# Skill: Aktivitas Login

> **Tipe:** Formulir · **Route:** `/login-activity` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Aktivitas Login (LoginActivityScreen) di fitur Profil & Pengaturan.
File utama: lib/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/WhereYouSignIn/LoginActivityScreen.dart. Route: /login-activity (Sanctum).
Tujuan: Menampilkan sesi/perangkat yang pernah login dan memungkinkan mencabut sesi.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/profile/login-activity.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /security/login-activity; DELETE /security/login-activity/{id}; POST /security/sessions/remove-all.
- Tabel: user_sessions, sessions.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Sesi saat ini tidak dapat dicabut dari daftar.
- Setelah mencabut semua, pengguna tetap login di perangkat ini.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: cabut satu sesi atau semua sesi lain bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `LoginActivityScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/WhereYouSignIn/LoginActivityScreen.dart` |
| Route | `/login-activity` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Dari `PasswordAndSecurityScreen`. |
| Provider | `authProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 3 |
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
| PRD | `.docs/screens/profile/login-activity.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/WhereYouSignIn/LoginActivityScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Test | `test/Features/Profil/` | Test happy path + error path |
| PRD | `.docs/screens/profile/login-activity.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/profile/login-activity/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan sesi/perangkat yang pernah login dan memungkinkan mencabut sesi.

1. Muat daftar sesi.
2. Tandai sesi saat ini.
3. Cabut satu sesi atau semua sesi lain.

### 5.2 Elemen UI wajib

- Daftar sesi
- Info perangkat/IP
- Tombol cabut
- Konfirmasi

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
| `sesi saat ini` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `cabut gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Sesi saat ini tidak dapat dicabut dari daftar.
- Setelah mencabut semua, pengguna tetap login di perangkat ini.
- Validasi client untuk UX; validasi final di backend.
- Pertahankan input saat 422/network error.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/profile/login-activity.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/WhereYouSignIn/LoginActivityScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/login-activity`.
4. Verifikasi endpoint ke backend: GET /security/login-activity; DELETE /security/login-activity/{id}; POST /security/sessions/remove-all.
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

1. Hubungkan aksi utama: Cabut satu sesi atau semua sesi lain.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/security/login-activity` | `LoginActivityController@index` | Sanctum | Riwayat sesi login |
| `DELETE` | `/security/login-activity/{id}` | `LoginActivityController@destroy` | Sanctum | Mencabut satu sesi |
| `POST` | `/security/sessions/remove-all` | `SecurityController@removeAllOtherSessions` | Sanctum | Mencabut semua sesi lain |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `user_sessions` | `id`, `user_id`, `device_name`, `device_type`, `ip_address`, `user_agent`, `platform`, `is_current` … |
| `sessions` | `id`, `user_id`, `ip_address`, `user_agent`, `label`, `payload`, `last_activity` |

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
| `sesi saat ini` | Ya |
| `cabut gagal` | Ya |

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
rg "LoginActivityScreen" lib
flutter analyze
flutter test test/Features/Profil

# dari root backend
php artisan route:list --path=api | Select-String "/security/login-activity"

# dari PostgreSQL
\d+ user_sessions
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Tidak ada gap khusus; tetap hormati kontrak backend.
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
