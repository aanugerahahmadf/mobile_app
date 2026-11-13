---
name: cbir-result
description: Implementasi layar Hasil Pencarian Gambar (CbirResultScreen) pada fitur Pencarian Gambar; route /cbir-result, 4 endpoint, 6 tabel, state, guardrail, dan definition of done.
---

# Skill: Hasil Pencarian Gambar

> **Tipe:** Konten / navigasi · **Route:** `/cbir-result` · **Akses:** Sanctum · **State:** State management terpusat + state lokal

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Hasil Pencarian Gambar di fitur Pencarian Gambar.
Referensi implementasi saat ini: CbirResultScreen. Route: /cbir-result (Sanctum).
Tujuan: Menampilkan hasil pencarian visual (CBIR) berupa katalog/paket yang mirip.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/cbir/cbir-result.md
- State management: State management terpusat + state lokal; pola data: request-response.
- Endpoint: POST /search/image; POST /cbir/search; POST /cbir/arithmetic; GET /categories.
- Tabel: search_logs, cbir_searches, cbir_search_results, catalogs, packages, categories.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Hasil menampilkan minimal gambar, nama, dan harga.
- Kegagalan AI menampilkan opsi coba lagi.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: ulangi pencarian atau kembali bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Hasil Pencarian Gambar** (referensi implementasi: `CbirResultScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `CbirResultScreen` |
| Route | `/cbir-result` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Setelah pengguna memilih/merekam gambar dari `SearchScreen`. |
| State/dependency | `cbirProvider` |
| Model | `CbirResultItem` |
| Endpoint | 4 |
| Tabel | 6 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | Konfigurasi router aplikasi |
| Endpoint client | Definisi endpoint API klien |
| HTTP client | HTTP client/data source bersama |
| Desain | Token desain/tema aplikasi |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/cbir/cbir-result.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `CbirResultScreen` | UI, state, interaksi |
| State/dependency | `cbirProvider` | State/aksi domain |
| Model | implementasi referensi aplikasi | Parsing/serialisasi bila kontrak berubah |
| Test | Test otomatis (platform target) di area Pencarian/` | Test happy path + error path |
| PRD | `.docs/screens/cbir/cbir-result.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/cbir/cbir-result/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan hasil pencarian visual (CBIR) berupa katalog/paket yang mirip.

1. Terima hasil dari `CbirProvider` atau jalankan pencarian.
2. Tampilkan grid hasil dengan skor kemiripan.
3. Buka detail item.
4. Ulangi pencarian atau kembali.

### 5.2 Elemen UI wajib

- Grid hasil
- Skor kemiripan
- Tombol ulangi
- Empty state

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
| `tidak ada hasil` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `gambar terlalu besar` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `error AI` | Pesan ramah, tombol coba lagi, pertahankan data lama bila ada. | Ikuti aksi pemulihan pada pesan |
| `video tidak didukung` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Hasil menampilkan minimal gambar, nama, dan harga.
- Kegagalan AI menampilkan opsi coba lagi.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/cbir/cbir-result.md` dan skill ini sampai selesai.
2. Tinjau implementasi referensi `CbirResultScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/cbir-result`.
4. Verifikasi endpoint ke backend: POST /search/image; POST /cbir/search; POST /cbir/arithmetic; GET /categories.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `tidak ada hasil`, `gambar terlalu besar`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Ulangi pencarian atau kembali.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `POST` | `/search/image` | `SearchController@byImage` | Sanctum | Pencarian gambar/video |
| `POST` | `/cbir/search` | `CBIRController@searchSimilar` | Sanctum | Pencarian kemiripan CBIR |
| `POST` | `/cbir/arithmetic` | `CBIRController@arithmeticSearch` | Sanctum | Operasi aritmetika vektor CBIR |
| `GET` | `/categories` | `CategoryController@index` | Sanctum | Daftar kategori |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `image` | `required|file|mimes:jpeg,png,jpg,bmp,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/search/image` |
| `image` | `required|file|mimes:jpeg,png,jpg,bmp,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/cbir/search` |
| `image_1` | `required|image|max:10240` | `/cbir/arithmetic` |
| `image_2` | `required|image|max:10240` | `/cbir/arithmetic` |
| `operation` | `required|string|in:add,average,subtract,multiply,divide` | `/cbir/arithmetic` |
| `weights` | `nullable|array` | `/cbir/arithmetic` |
| `weights.*` | `numeric|min:0|max:1` | `/cbir/arithmetic` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `search_logs` | `id`, `query`, `user_id`, `ip_address`, `user_agent`, `created_at`, `updated_at` |
| `cbir_searches` | `id`, `user_id`, `query_image_url`, `results_count`, `top_similarity`, `created_at`, `updated_at` |
| `cbir_search_results` | `id`, `search_id`, `type`, `item_id`, `similarity`, `score`, `created_at`, `updated_at` |
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `categories` | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at` … |

| Model | Field kunci |
|---|---|
| `CbirResultItem` | `type`, `similarity`, `sCore`, `catalogId`, `data` |

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
| `tidak ada hasil` | Ya |
| `gambar terlalu besar` | Ya |
| `error AI` | Ya |
| `video tidak didukung` | Ya |

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
- Pastikan komponen/layar referensi `CbirResultScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target

# verifikasi backend (opsional)
- Cek route API: /search/image

# verifikasi database (opsional)
- Cek tabel: search_logs
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Layar menerima state lewat provider; tidak ada parameter route.
- Pencarian suara tidak boleh diarahkan ke layar ini sebelum endpoint transkripsi tersedia.
- Layar memakai HTTP client bersama langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
