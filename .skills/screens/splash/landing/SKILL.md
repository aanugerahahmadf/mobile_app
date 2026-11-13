---
name: splash-landing
description: Implementasi layar Landing (LandingScreen) pada fitur Splash & Landing; route /landing, 1 endpoint, 2 tabel, state, guardrail, dan definition of done.
---

# Skill: Landing

> **Tipe:** Konten / navigasi · **Route:** `/landing` · **Akses:** Publik · **State:** State management terpusat + state lokal

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Landing di fitur Splash & Landing.
Referensi implementasi saat ini: LandingScreen. Route: /landing (Publik).
Tujuan: Gerbang masuk satu pintu: checkbox persetujuan + tombol Google via Firebase; tamu hanya bisa membuka Customer Service tanpa login.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/splash/landing.md
- State management: State management terpusat + state lokal; pola data: request-response.
- Endpoint: POST /auth/google.
- Tabel: users, personal_access_tokens.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Tombol Google hanya aktif bila checkbox persetujuan dicentang dan tidak sedang loading.
- Login Google sukses menyimpan token Sanctum lalu membuka Home/AppLock.
- Layar ini tidak menampilkan form email/password, tombol daftar, maupun tombol guest.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: lanjutkan bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Landing** (referensi implementasi: `LandingScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `LandingScreen` |
| Route | `/landing` |
| Akses | Publik |
| Parameter | Tidak ada |
| Masuk dari | Awal aplikasi setelah startup, atau setelah logout. |
| State/dependency | `authProvider`, `currentAccountEmailProvider`, `localeProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 1 |
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
| PRD | `.docs/screens/splash/landing.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `LandingScreen` | UI, state, interaksi |
| State/dependency | `authProvider` | State/aksi domain |
| State/dependency | `currentAccountEmailProvider` | State/aksi domain |
| State/dependency | `localeProvider` | State/aksi domain |
| Test | Test otomatis (platform target) di area Splash/` | Test happy path + error path |
| PRD | `.docs/screens/splash/landing.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/splash/landing/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Gerbang masuk satu pintu: checkbox persetujuan + tombol Google via Firebase; tamu hanya bisa membuka Customer Service tanpa login.

1. Tampilkan gambar hero, greeting, checkbox persetujuan, dan satu tombol Google.
2. Pengguna wajib menyetujui Terms/Privacy/Wedding Policy lewat checkbox; saat dicentang, wizard persetujuan (`AuthModals`) ditampilkan dan persetujuan dicatat setelah diselesaikan. Tombol Google aktif setelah disetujui.
3. Tap Google (saat setuju): set `onboarding_seen`, jalankan `GoogleSignIn.signIn()` lalu `FirebaseAuth.signInWithCredential()` untuk mendapat ID token.
4. Kirim `firebase_id_token` (fallback `google_id_token`/`id_token`) ke `POST /auth/google`.
5. Server memverifikasi token, menerbitkan token Sanctum, lalu lanjutan OTP/2FA/Complete Profile ditangani `AuthNavigation`.
6. Sukses: set `onboarding_seen`, buka `/app-lock` bila app lock aktif, selain itu `/home`.

### 5.2 Elemen UI wajib

- Gambar hero
- Greeting selamat datang
- Checkbox persetujuan Terms/Privacy/Wedding Policy
- Tombol Google (`SocialSignInButton`, nonaktif sampai disetujui)
- Ikon Customer Service (guest chat)
- Footer persetujuan Terms/Privacy/Policy

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
| `belum setuju (tombol Google nonaktif)` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `loading (`AuthLoading`)` | Skeleton/spinner; blokir aksi ganda. | Ikuti aksi pemulihan pada pesan |
| `login gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `2FA diperlukan` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `OTP/Complete Profile` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `guest chat` | Tampilkan prompt autentikasi tamu; jangan panggil endpoint privat. | Ikuti aksi pemulihan pada pesan |
| `app lock` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Tombol Google hanya aktif bila checkbox persetujuan dicentang dan tidak sedang loading.
- Login Google sukses menyimpan token Sanctum lalu membuka Home/AppLock.
- Layar ini tidak menampilkan form email/password, tombol daftar, maupun tombol guest.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/splash/landing.md` dan skill ini sampai selesai.
2. Tinjau implementasi referensi `LandingScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/landing`.
4. Verifikasi endpoint ke backend: POST /auth/google.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `offline`, `submitting`, `belum setuju (tombol Google nonaktif)`, `` loading (`AuthLoading`) ``, `login gagal`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Lanjutkan.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `POST` | `/auth/google` | `AuthController@googleLogin` | Publik | Login Google memakai Firebase ID token |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `firebase_id_token` | `nullable|string` | `/auth/google` |
| `google_id_token` | `nullable|string` | `/auth/google` |
| `id_token` | `nullable|string` | `/auth/google` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |
| `personal_access_tokens` | `id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at` … |

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
| `belum setuju (tombol Google nonaktif)` | Ya |
| `loading (`AuthLoading`)` | Ya |
| `login gagal` | Ya |
| `2FA diperlukan` | Ya |
| `OTP/Complete Profile` | Ya |
| `guest chat` | Ya |
| `app lock` | Ya |

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
- Pastikan komponen/layar referensi `LandingScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target

# verifikasi backend (opsional)
- Cek route API: /auth/google

# verifikasi database (opsional)
- Cek tabel: users
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Persetujuan diwajibkan lewat checkbox di UI sebelum autentikasi Google dimulai.
- Layar ini hanya memakai satu endpoint (`/auth/google`); jalur email/password tetap ada di backend tetapi tidak dimount dari Landing.
- Login Google memakai Firebase ID token, sesi tetap Sanctum (bukan sesi Firebase).
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
