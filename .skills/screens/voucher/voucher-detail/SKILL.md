---
name: voucher-detail
description: Implementasi layar Detail Voucher (VoucherDetailScreen) pada fitur Voucher; route /vouchers/:id, 2 endpoint, 3 tabel, state, guardrail, dan definition of done.
---

# Skill: Detail Voucher

> **Tipe:** Daftar / koleksi · **Route:** `/vouchers/:id` · **Akses:** Sanctum · **State:** State management terpusat

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Detail Voucher di fitur Voucher.
Referensi implementasi saat ini: VoucherDetailScreen. Route: /vouchers/:id (Sanctum).
Tujuan: Menampilkan detail voucher, syarat, masa berlaku, dan aksi klaim.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/voucher/voucher-detail.md
- State management: State management terpusat; pola data: request-response.
- Endpoint: GET /vouchers; POST /vouchers/{voucher}/claim.
- Tabel: vouchers, discounts, user_vouchers.
- Parameter/extra: Path `id`; `extra` sebaiknya berisi JSON `VoucherModel`.

Wajib dipertahankan:
- Voucher kedaluwarsa tidak dapat diklaim.
- Klaim memperbarui status tombol.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: pakai voucher bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Detail Voucher** (referensi implementasi: `VoucherDetailScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `VoucherDetailScreen` |
| Route | `/vouchers/:id` |
| Akses | Sanctum |
| Parameter | Path `id`; `extra` sebaiknya berisi JSON `VoucherModel`. |
| Masuk dari | Dari `VoucherListScreen` dengan `extra` berisi JSON voucher. |
| State/dependency | `authProvider` |
| Model | `VoucherModel` |
| Endpoint | 2 |
| Tabel | 3 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | Konfigurasi router aplikasi |
| Endpoint client | Definisi endpoint API klien |
| HTTP client | HTTP client/data source bersama |
| Desain | Token desain/tema aplikasi |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/voucher/voucher-detail.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `VoucherDetailScreen` | UI, state, interaksi |
| State/dependency | `authProvider` | State/aksi domain |
| Model | implementasi referensi aplikasi | Parsing/serialisasi bila kontrak berubah |
| Test | Test otomatis (platform target) di area Voucher/` | Test happy path + error path |
| PRD | `.docs/screens/voucher/voucher-detail.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/voucher/voucher-detail/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan detail voucher, syarat, masa berlaku, dan aksi klaim.

1. Terima model voucher.
2. Tampilkan diskon, syarat, expiry.
3. Klaim voucher.
4. Tampilkan status klaim.

### 5.2 Elemen UI wajib

- Kartu voucher
- Kode
- Masa berlaku
- Tombol klaim

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
| `kedaluwarsa` | Tampilkan status kedaluwarsa dan aksi muat ulang. | Ikuti aksi pemulihan pada pesan |
| `sudah diklaim` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `habis` | Tampilkan penanda akhir daftar atau status kedaluwarsa. | Ikuti aksi pemulihan pada pesan |
| `klaim gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Voucher kedaluwarsa tidak dapat diklaim.
- Klaim memperbarui status tombol.
- Pagination tidak boleh meminta halaman yang sama berulang.
- Refresh mereset halaman dan daftar.
- Hapus item secara optimistis hanya bila aksi reversibel; jika tidak, tunggu respons.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/voucher/voucher-detail.md` dan skill ini sampai selesai.
2. Tinjau implementasi referensi `VoucherDetailScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/vouchers/:id`.
4. Verifikasi endpoint ke backend: GET /vouchers; POST /vouchers/{voucher}/claim.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `kedaluwarsa`, `sudah diklaim`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Pakai Voucher.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/vouchers` | `VoucherController@index` | Sanctum | Daftar voucher pengguna |
| `POST` | `/vouchers/{voucher}/claim` | `VoucherController@claim` | Sanctum | Mengklaim voucher |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `vouchers` | `id`, `code`, `description`, `expires_at`, `is_active`, `is_global`, `max_uses`, `uses_count` … |
| `discounts` | `id`, `description`, `discountable_type`, `discountable_id`, `type`, `value`, `start_date`, `end_date` … |
| `user_vouchers` | `id`, `user_id`, `voucher_id`, `claimed_at`, `used_at`, `order_id`, `created_at`, `updated_at` |

| Model | Field kunci |
|---|---|
| `VoucherModel` | `id`, `name`, `code`, `description`, `discountAmount`, `discountType`, `minPurchase`, `expiresAt` |

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
| `kedaluwarsa` | Ya |
| `sudah diklaim` | Ya |
| `habis` | Ya |
| `klaim gagal` | Ya |

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
- Pastikan komponen/layar referensi `VoucherDetailScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target

# verifikasi backend (opsional)
- Cek route API: /vouchers

# verifikasi database (opsional)
- Cek tabel: vouchers
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Jika `extra` kosong, layar membuat `VoucherModel` id 0 sehingga data tidak valid.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
