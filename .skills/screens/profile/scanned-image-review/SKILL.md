---
name: profile-scanned-image-review
description: Implementasi layar Review Hasil Scan (ScannedImageReviewScreen) pada fitur Profil & Pengaturan; route -, 0 endpoint, 0 tabel, state, guardrail, dan definition of done.
---

# Skill: Review Hasil Scan

> **Tipe:** Konten / navigasi · **Route:** tidak terdaftar · **Akses:** Lokal · **State:** State lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Review Hasil Scan (ScannedImageReviewScreen) di fitur Profil & Pengaturan.
File utama: lib/Features/Profile/Presentation/Screens/ScannedImageReview/ScannedImageReviewScreen.dart. Route: - (Lokal).
Tujuan: Menampilkan hasil scan untuk diputar, dipotong, atau dikonfirmasi sebelum dipakai.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/profile/scanned-image-review.md
- State management: State lokal (`setState`); pola data: request-response.
- Endpoint: tidak ada endpoint jaringan.
- Tabel: tidak ada tabel langsung.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Gambar yang dipakai adalah file final, bukan preview kamera.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: kirim ulasan bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `ScannedImageReviewScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Profile/Presentation/Screens/ScannedImageReview/ScannedImageReviewScreen.dart` |
| Route | tidak terdaftar |
| Akses | Lokal |
| Parameter | Tidak ada |
| Masuk dari | Tidak memiliki route; bagian dari alur scanner. |
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
| PRD | `.docs/screens/profile/scanned-image-review.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Profile/Presentation/Screens/ScannedImageReview/ScannedImageReviewScreen.dart` | UI, state, interaksi |
| Test | `test/Features/Profil/` | Test happy path + error path |
| PRD | `.docs/screens/profile/scanned-image-review.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/profile/scanned-image-review/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan hasil scan untuk diputar, dipotong, atau dikonfirmasi sebelum dipakai.

1. Terima path gambar.
2. Tampilkan preview.
3. Retake atau gunakan.
4. Kembalikan path ke pemanggil.

### 5.2 Elemen UI wajib

- Preview
- Tombol retake
- Tombol gunakan
- Info kualitas

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `initial` | Kerangka/placeholder awal | Muat data |
| `loading` | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Render konten utama | — |
| `empty` | Empty state dengan penjelasan + CTA | Refresh atau aksi lanjutan |
| `error` | Pesan ramah + tombol coba lagi | Retry |
| `offline` | Banner/empty offline | Coba lagi saat online |
| `gambar kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `gagal memuat` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `retake` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Gambar yang dipakai adalah file final, bukan preview kamera.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/profile/scanned-image-review.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Profile/Presentation/Screens/ScannedImageReview/ScannedImageReviewScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `offline`, `gambar kosong`, `gagal memuat`, `retake`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Kirim Ulasan.
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
| `empty` | Ya |
| `error` | Ya |
| `offline` | Ya |
| `gambar kosong` | Ya |
| `gagal memuat` | Ya |
| `retake` | Ya |

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
rg "ScannedImageReviewScreen" lib
flutter analyze
flutter test test/Features/Profil
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Layar tidak terdaftar di router (GAP-12).
- Layar belum terdaftar di `AppRouter`; jangan menganggapnya dapat dijangkau lewat deep link.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Belum terhubung ke `AppRouter` (lihat gap)
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
