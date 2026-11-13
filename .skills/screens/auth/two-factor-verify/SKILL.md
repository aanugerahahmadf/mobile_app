---
name: auth-two-factor-verify
description: Implementasi layar Verifikasi 2FA saat Login (TwoFactorVerifyScreen) pada fitur Auth & Keamanan; route /two-factor-verify, 2 endpoint, 2 tabel, state, guardrail, dan definition of done.
---

# Skill: Verifikasi 2FA saat Login

> **Tipe:** Autentikasi & keamanan · **Route:** `/two-factor-verify` · **Akses:** Publik (challenge) · **State:** State management terpusat + state lokal

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Verifikasi 2FA saat Login di fitur Auth & Keamanan.
Referensi implementasi saat ini: TwoFactorVerifyScreen. Route: /two-factor-verify (Publik (challenge)).
Tujuan: Meminta kode 2FA setelah login berhasil tetapi sebelum token sesi diterbitkan.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/auth/two-factor-verify.md
- State management: State management terpusat + state lokal; pola data: request-response.
- Endpoint: POST /auth/two-factor/verify; POST /auth/two-factor/resend.
- Tabel: users, backup_codes.
- Parameter/extra: Tidak menerima parameter; challenge disimpan di `AuthProvider`.

Wajib dipertahankan:
- Token hanya terbit setelah kode benar.
- Challenge kedaluwarsa mengembalikan pengguna ke Landing.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: verifikasi bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Verifikasi 2FA saat Login** (referensi implementasi: `TwoFactorVerifyScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `TwoFactorVerifyScreen` |
| Route | `/two-factor-verify` |
| Akses | Publik (challenge) |
| Parameter | Tidak menerima parameter; challenge disimpan di `AuthProvider`. |
| Masuk dari | Otomatis dari `LandingScreen` bila `login()` mengembalikan challenge 2FA. |
| State/dependency | `authProvider`, `currentAccountEmailProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 2 |
| Tabel | 2 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | Konfigurasi router aplikasi |
| Endpoint client | Definisi endpoint API klien |
| HTTP client | HTTP client/data source bersama |
| Desain | Token desain/tema aplikasi |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/auth/two-factor-verify.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `TwoFactorVerifyScreen` | UI, state, interaksi |
| State/dependency | `authProvider` | State/aksi domain |
| State/dependency | `currentAccountEmailProvider` | State/aksi domain |
| Test | Test otomatis (platform target) di area Auth/` | Test happy path + error path |
| PRD | `.docs/screens/auth/two-factor-verify.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/auth/two-factor-verify/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Meminta kode 2FA setelah login berhasil tetapi sebelum token sesi diterbitkan.

1. Terima challenge token dari AuthProvider.
2. Pilih metode authenticator/email/recovery.
3. Verifikasi kode.
4. Simpan token dan arahkan ke Home/AppLock.

### 5.2 Elemen UI wajib

- Field kode
- Pemilih metode
- Tombol kirim ulang
- Info sesi kedaluwarsa

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `initial` | Kerangka/placeholder awal | Muat data |
| `loading` | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Render konten utama | — |
| `error` | Pesan ramah + tombol coba lagi | Retry |
| `offline` | Banner/empty offline | Coba lagi saat online |
| `submitting` | Tombol disabled + progress | Selesai atau tampilkan error |
| `kode salah` | Tampilkan error tanpa membocorkan detail; izinkan coba lagi. | Ikuti aksi pemulihan pada pesan |
| `challenge kedaluwarsa` | Tampilkan status kedaluwarsa dan aksi muat ulang. | Ikuti aksi pemulihan pada pesan |
| `recovery code tidak valid` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Token hanya terbit setelah kode benar.
- Challenge kedaluwarsa mengembalikan pengguna ke Landing.
- Jangan menyimpan password/PIN plaintext; gunakan secure storage untuk token.
- Terapkan rate limit/lockout dan jangan membocorkan apakah akun terdaftar.
- OTP/challenge memiliki masa berlaku; tangani kedaluwarsa.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/auth/two-factor-verify.md` dan skill ini sampai selesai.
2. Tinjau implementasi referensi `TwoFactorVerifyScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/two-factor-verify`.
4. Verifikasi endpoint ke backend: POST /auth/two-factor/verify; POST /auth/two-factor/resend.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di konfigurasi router.
2. Terapkan guard: Tidak membutuhkan token. Tetap tangani 401/403 bila endpoint berubah menjadi privat.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan komponen UI yang sudah ada bila cocok.
2. Gunakan token desain (warna, tipografi, spacing) dan lokalisasi yang konsisten.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `error`, `offline`, `submitting`, `kode salah`, `challenge kedaluwarsa`, `recovery code tidak valid`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
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
| `POST` | `/auth/two-factor/verify` | `AuthController@verifyTwoFactor` | Publik | Memverifikasi tantangan 2FA |
| `POST` | `/auth/two-factor/resend` | `AuthController@resendTwoFactorCode` | Publik | Mengirim ulang kode 2FA |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `challenge_token` | `required|string` | `/auth/two-factor/verify` |
| `code` | `required|string|max:12` | `/auth/two-factor/verify` |
| `method` | `nullable|string|in:` | `/auth/two-factor/verify` |
| `challenge_token` | `required|string` | `/auth/two-factor/resend` |

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
| `offline` | Ya |
| `submitting` | Ya |
| `kode salah` | Ya |
| `challenge kedaluwarsa` | Ya |
| `recovery code tidak valid` | Ya |

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
- Pastikan komponen/layar referensi `TwoFactorVerifyScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target

# verifikasi backend (opsional)
- Cek route API: /auth/two-factor/verify

# verifikasi database (opsional)
- Cek tabel: users
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Recovery code dinormalisasi ke huruf besar dan panjang 9 karakter.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
