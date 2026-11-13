---
name: profile-document-scanner
description: Implementasi layar Scanner Dokumen (DocumentScannerScreen) pada fitur Profil & Pengaturan; route /document-scanner, 0 endpoint, 0 tabel, state, guardrail, dan definition of done.
---

# Skill: Scanner Dokumen

> **Tipe:** Scanner kamera / media · **Route:** `/document-scanner` · **Akses:** Sanctum · **State:** State lokal

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Scanner Dokumen di fitur Profil & Pengaturan.
Referensi implementasi saat ini: DocumentScannerScreen. Route: /document-scanner (Sanctum).
Tujuan: Memindai dokumen identitas dengan kamera, mendeteksi tepi, dan menghasilkan file untuk diunggah.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/profile/document-scanner.md
- State management: State lokal; pola data: kamera real-time.
- Endpoint: tidak ada endpoint jaringan.
- Tabel: tidak ada tabel langsung.
- Parameter/extra: `extra: {docType}` default `ktp`.

Wajib dipertahankan:
- File yang dikembalikan dapat dipakai upload dokumen.
- Layar membersihkan controller saat dispose.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: gunakan foto bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Scanner Dokumen** (referensi implementasi: `DocumentScannerScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `DocumentScannerScreen` |
| Route | `/document-scanner` |
| Akses | Sanctum |
| Parameter | `extra: {docType}` default `ktp`. |
| Masuk dari | Dari `CompleteProfileScreen` atau alur verifikasi identitas. |
| State/dependency | Tidak terdeteksi |
| Model | Tidak terdeteksi |
| Endpoint | 0 |
| Tabel | 0 |

- Izin kamera dan lifecycle controller wajib diuji di perangkat fisik/emulator dengan kamera.

- Timer/polling harus diuji saat app background/resume dan saat dispose.

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | Konfigurasi router aplikasi |
| Endpoint client | Definisi endpoint API klien |
| HTTP client | HTTP client/data source bersama |
| Desain | Token desain/tema aplikasi |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/profile/document-scanner.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `DocumentScannerScreen` | UI, state, interaksi |
| Test | Test otomatis (platform target) di area Profil/` | Test happy path + error path |
| PRD | `.docs/screens/profile/document-scanner.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/profile/document-scanner/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Memindai dokumen identitas dengan kamera, mendeteksi tepi, dan menghasilkan file untuk diunggah.

1. Minta izin kamera.
2. Tampilkan preview dan panduan.
3. Deteksi dokumen/validasi kualitas.
4. Ambil foto dan kembalikan path.

### 5.2 Elemen UI wajib

- Preview kamera
- Overlay bingkai
- Panduan TTS
- Tombol ambil/retake

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `initial` | Kerangka/placeholder awal | Muat data |
| `loading` | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Render konten utama | — |
| `error` | Pesan ramah + tombol coba lagi | Retry |
| `unauthorized` | Sesi berakhir; arahkan login/Landing | Login ulang |
| `offline` | Banner/empty offline | Coba lagi saat online |
| `permission` | Penjelasan + tombol buka pengaturan | Izin diberikan |
| `izin ditolak` | Tampilkan penjelasan izin dan tombol buka pengaturan. | Ikuti aksi pemulihan pada pesan |
| `kamera tidak tersedia` | Jelaskan izin/ketersediaan kamera dan beri alternatif. | Ikuti aksi pemulihan pada pesan |
| `dokumen tidak terdeteksi` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `terlalu gelap` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- File yang dikembalikan dapat dipakai upload dokumen.
- Layar membersihkan controller saat dispose.
- Scanner hanya menghasilkan file; unggah dan verifikasi dilakukan alur terpisah.
- Jangan menyimpan frame kamera setelah layar ditutup.
- Sediakan alternatif unggah bila kamera tidak tersedia.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/profile/document-scanner.md` dan skill ini sampai selesai.
2. Tinjau implementasi referensi `DocumentScannerScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/document-scanner`.
4. Verifikasi endpoint ke backend: tidak ada endpoint jaringan.
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

1. Implementasikan state: `initial`, `loading`, `content`, `error`, `unauthorized`, `offline`, `permission`, `izin ditolak`, `kamera tidak tersedia`, `dokumen tidak terdeteksi`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.
4. Kelola timer/polling: mulai setelah layar siap, hentikan di `dispose`/background.
5. Kelola lifecycle kamera dan dispose controller; tangani izin ditolak.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Gunakan Foto.
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
| `unauthorized` | Ya |
| `offline` | Ya |
| `permission` | Ya |
| `izin ditolak` | Ya |
| `kamera tidak tersedia` | Ya |
| `dokumen tidak terdeteksi` | Ya |
| `terlalu gelap` | Ya |

## 10. Guardrail

- Jangan mengarang endpoint, parameter, atau kolom database.
- Jangan membuat HTTP client baru di komponen UI; gunakan data source/repository bersama.
- Jangan memanggil API di `build()` atau setiap rebuild.
- Jangan menyimpan token/password/PIN di penyimpanan lokal atau log.
- Jangan menampilkan stack trace/pesan database ke pengguna.
- Jangan menambah dependensi baru tanpa alasan dan persetujuan.
- Jangan mengubah route/parameter tanpa memperbarui konfigurasi router dan dokumen.
- Jangan menghapus test yang ada untuk membuat build lulus.
- Jangan menyimpan/mengunggah frame kamera otomatis.

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
- Pastikan komponen/layar referensi `DocumentScannerScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Tidak memiliki route sendiri untuk `AutoCaptureScanner`/`ScannedImageReview`.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
