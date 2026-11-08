---
name: auth-biometric-unlock
description: Implementasi layar Biometric Unlock (subview) (BiometricUnlockScreen) pada fitur Auth & Keamanan; route -, 0 endpoint, 0 tabel, state, guardrail, dan definition of done.
---

# Skill: Biometric Unlock (subview)

> **Tipe:** Autentikasi & keamanan · **Route:** tidak terdaftar · **Akses:** Lokal · **State:** Stateless

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Biometric Unlock (subview) (BiometricUnlockScreen) di fitur Auth & Keamanan.
File utama: lib/Features/Auth/Presentation/Screens/AppLock/BiometricUnlock/BiometricUnlockScreen.dart. Route: - (Lokal).
Tujuan: Subview tombol biometrik yang dipakai `AppLockScreen` untuk memicu Face ID/fingerprint perangkat.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/auth/biometric-unlock.md
- State management: Stateless; pola data: request-response.
- Endpoint: tidak ada endpoint jaringan.
- Tabel: tidak ada tabel langsung.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Tidak memanggil API jaringan.
- Kegagalan biometrik tidak mengunci pengguna dari PIN.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: buka kunci bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `BiometricUnlockScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Auth/Presentation/Screens/AppLock/BiometricUnlock/BiometricUnlockScreen.dart` |
| Route | tidak terdaftar |
| Akses | Lokal |
| Parameter | Tidak ada |
| Masuk dari | Dirender di dalam `AppLockScreen` saat biometrik tersedia. |
| Provider | Tidak terdeteksi |
| Model | Tidak terdeteksi |
| Endpoint | 0 |
| Tabel | 0 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/auth/biometric-unlock.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Auth/Presentation/Screens/AppLock/BiometricUnlock/BiometricUnlockScreen.dart` | UI, state, interaksi |
| Test | `test/Features/Auth/` | Test happy path + error path |
| PRD | `.docs/screens/auth/biometric-unlock.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/auth/biometric-unlock/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Subview tombol biometrik yang dipakai `AppLockScreen` untuk memicu Face ID/fingerprint perangkat.

1. Periksa dukungan biometrik perangkat.
2. Tampilkan ikon dan label sesuai tipe biometrik.
3. Panggil autentikasi lokal; hasil diteruskan ke AppLock.

### 5.2 Elemen UI wajib

- Tombol/ikon biometrik
- Label Face ID atau fingerprint
- Status loading

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `initial` | Kerangka/placeholder awal | Muat data |
| `loading` | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Render konten utama | — |
| `error` | Pesan ramah + tombol coba lagi | Retry |
| `offline` | Banner/empty offline | Coba lagi saat online |
| `submitting` | Tombol disabled + progress | Selesai atau tampilkan error |
| `biometrik tersedia` | Tampilkan fallback PIN/password bila biometrik gagal. | Ikuti aksi pemulihan pada pesan |
| `biometrik ditolak` | Tampilkan fallback PIN/password bila biometrik gagal. | Ikuti aksi pemulihan pada pesan |
| `biometrik tidak terdaftar` | Tampilkan fallback PIN/password bila biometrik gagal. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Tidak memanggil API jaringan.
- Kegagalan biometrik tidak mengunci pengguna dari PIN.
- Jangan menyimpan password/PIN plaintext; gunakan secure storage untuk token.
- Terapkan rate limit/lockout dan jangan membocorkan apakah akun terdaftar.
- OTP/challenge memiliki masa berlaku; tangani kedaluwarsa.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/auth/biometric-unlock.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Auth/Presentation/Screens/AppLock/BiometricUnlock/BiometricUnlockScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: tidak terdaftar.
4. Verifikasi endpoint ke backend: tidak ada endpoint jaringan.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di `AppRouter`.
2. Terapkan guard: Tidak membutuhkan token jaringan; state disimpan di perangkat atau diteruskan lewat `extra`.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan widget yang sudah ada bila cocok.
2. Gunakan `AppColors`, `AppTextStyles`, `AppSizes`, `AppLocalizations`.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `error`, `offline`, `submitting`, `biometrik tersedia`, `biometrik ditolak`, `biometrik tidak terdaftar`.
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

Tidak ada API jaringan. Gunakan penyimpanan lokal atau data `extra`.

## 8. Data & model

Tidak ada tabel yang dipakai langsung.

## 9. State minimum

| State | Harus ada |
|---|---|
| `initial` | Ya |
| `loading` | Ya |
| `content` | Ya |
| `error` | Ya |
| `offline` | Ya |
| `submitting` | Ya |
| `biometrik tersedia` | Ya |
| `biometrik ditolak` | Ya |
| `biometrik tidak terdaftar` | Ya |

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
rg "BiometricUnlockScreen" lib
flutter analyze
flutter test test/Features/Auth
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Bukan layar mandiri; tidak memiliki route sendiri.
- Layar belum terdaftar di `AppRouter`; jangan menganggapnya dapat dijangkau lewat deep link.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Belum terhubung ke `AppRouter` (lihat gap)
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
