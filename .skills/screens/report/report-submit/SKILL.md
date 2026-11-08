---
name: report-submit
description: Implementasi layar Kirim Laporan (ReportSubmitScreen) pada fitur Laporan; route -, 2 endpoint, 2 tabel, state, guardrail, dan definition of done.
---

# Skill: Kirim Laporan

> **Tipe:** Formulir · **Route:** tidak terdaftar · **Akses:** Sanctum · **State:** State lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Kirim Laporan (ReportSubmitScreen) di fitur Laporan.
File utama: lib/Features/Report/Presentation/Screens/ReportSubmit/ReportSubmitScreen.dart. Route: - (Sanctum).
Tujuan: Form pelaporan konten/pengguna dengan kategori, alasan, deskripsi, dan lampiran.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/report/report-submit.md
- State management: State lokal (`setState`); pola data: request-response.
- Endpoint: GET /reports; POST /reports.
- Tabel: reports, media.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Laporan tersimpan dengan `reportable_type/id` yang benar.
- Lampiran opsional.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: kirim laporan bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `ReportSubmitScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Report/Presentation/Screens/ReportSubmit/ReportSubmitScreen.dart` |
| Route | tidak terdaftar |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Tidak memiliki route; alur laporan dari katalog/chat memakai `openReportChat`. |
| Provider | Tidak terdeteksi |
| Model | Tidak terdeteksi |
| Endpoint | 2 |
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
| PRD | `.docs/screens/report/report-submit.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Report/Presentation/Screens/ReportSubmit/ReportSubmitScreen.dart` | UI, state, interaksi |
| Test | `test/Features/Laporan/` | Test happy path + error path |
| PRD | `.docs/screens/report/report-submit.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/report/report-submit/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Form pelaporan konten/pengguna dengan kategori, alasan, deskripsi, dan lampiran.

1. Pilih kategori laporan.
2. Isi alasan dan deskripsi.
3. Lampirkan bukti.
4. Kirim `POST /reports`.

### 5.2 Elemen UI wajib

- Dropdown kategori
- Field alasan
- Deskripsi
- Upload lampiran
- Tombol kirim

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
| `validasi gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `upload gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `sukses` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Laporan tersimpan dengan `reportable_type/id` yang benar.
- Lampiran opsional.
- Validasi client untuk UX; validasi final di backend.
- Pertahankan input saat 422/network error.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/report/report-submit.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Report/Presentation/Screens/ReportSubmit/ReportSubmitScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: tidak terdaftar.
4. Verifikasi endpoint ke backend: GET /reports; POST /reports.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `validasi gagal`, `upload gagal`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Kirim Laporan.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/reports` | `ReportController@index` | Sanctum | Membuat/membaca laporan |
| `POST` | `/reports` | `ReportController@store` | Sanctum | Membuat/membaca laporan |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `reports` | `id`, `user_id`, `reportable_type`, `reportable_id`, `category`, `reason`, `description`, `status` … |
| `media` | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type` … |

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
| `validasi gagal` | Ya |
| `upload gagal` | Ya |
| `sukses` | Ya |

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
rg "ReportSubmitScreen" lib
flutter analyze
flutter test test/Features/Laporan

# dari root backend
php artisan route:list --path=api | Select-String "/reports"

# dari PostgreSQL
\d+ reports
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Layar tidak terdaftar di router (GAP-12); duplikasi dengan alur chat-report.
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Layar belum terdaftar di `AppRouter`; jangan menganggapnya dapat dijangkau lewat deep link.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Belum terhubung ke `AppRouter` (lihat gap)
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
