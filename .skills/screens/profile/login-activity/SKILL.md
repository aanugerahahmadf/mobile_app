---
name: profile-login-activity
description: Implementasi layar Aktivitas Login (SignInActivityScreen) pada fitur Profil & Pengaturan; route /login-activity, 3 endpoint, 2 tabel, state, guardrail, dan definition of done.
---

# Skill: Aktivitas Login

> **Tipe:** Formulir · **Route:** `/login-activity` · **Akses:** Sanctum · **State:** State management terpusat + state lokal

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Aktivitas Login di fitur Profil & Pengaturan.
Referensi implementasi saat ini: SignInActivityScreen. Route: /login-activity (Sanctum).
Tujuan: Menampilkan sesi/perangkat yang pernah login dan memungkinkan mencabut sesi.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/profile/login-activity.md
- State management: State management terpusat + state lokal; pola data: request-response.
- Endpoint: GET /security/login-activity; DELETE /security/login-activity/{id}; POST /security/sessions/remove-all.
- Tabel: user_sessions, sessions.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Sesi saat ini tidak dapat dicabut dari daftar.
- Setelah mencabut semua, pengguna tetap login di perangkat ini.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: cabut satu sesi atau semua sesi lain bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Aktivitas Login** (referensi implementasi: `SignInActivityScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `SignInActivityScreen` |
| Route | `/login-activity` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Dari `PasswordAndSecurityScreen`. |
| State/dependency | `authProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 3 |
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
| PRD | `.docs/screens/profile/login-activity.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `SignInActivityScreen` | UI, state, interaksi |
| State/dependency | `authProvider` | State/aksi domain |
| Test | Test otomatis (platform target) di area Profil/` | Test happy path + error path |
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
2. Tinjau implementasi referensi `SignInActivityScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/login-activity`.
4. Verifikasi endpoint ke backend: GET /security/login-activity; DELETE /security/login-activity/{id}; POST /security/sessions/remove-all.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di konfigurasi router.
2. Terapkan guard: Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan komponen UI yang sudah ada bila cocok.
2. Gunakan token desain (warna, tipografi, spacing) dan lokalisasi yang konsisten.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `kosong`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
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
- Pastikan komponen/layar referensi `SignInActivityScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target

# verifikasi backend (opsional)
- Cek route API: /security/login-activity

# verifikasi database (opsional)
- Cek tabel: user_sessions
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Tidak ada gap khusus; tetap hormati kontrak backend.
- Layar memakai HTTP client bersama langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
