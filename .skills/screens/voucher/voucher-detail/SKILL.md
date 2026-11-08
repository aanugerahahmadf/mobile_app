---
name: voucher-detail
description: Implementasi layar Detail Voucher (VoucherDetailScreen) pada fitur Voucher; route /vouchers/:id, 2 endpoint, 3 tabel, state, guardrail, dan definition of done.
---

# Skill: Detail Voucher

> **Tipe:** Daftar / koleksi · **Route:** `/vouchers/:id` · **Akses:** Sanctum · **State:** Riverpod (`ConsumerWidget`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Detail Voucher (VoucherDetailScreen) di fitur Voucher.
File utama: lib/Features/Voucher/Presentation/Screens/VoucherDetail/VoucherDetailScreen.dart. Route: /vouchers/:id (Sanctum).
Tujuan: Menampilkan detail voucher, syarat, masa berlaku, dan aksi klaim.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/voucher/voucher-detail.md
- State management: Riverpod (`ConsumerWidget`); pola data: request-response.
- Endpoint: GET /vouchers; POST /vouchers/{voucher}/claim.
- Tabel: vouchers, discounts, user_vouchers.
- Parameter/extra: Path `id`; `extra` sebaiknya berisi JSON `VoucherModel`.

Wajib dipertahankan:
- Voucher kedaluwarsa tidak dapat diklaim.
- Klaim memperbarui status tombol.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: pakai voucher bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `VoucherDetailScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Voucher/Presentation/Screens/VoucherDetail/VoucherDetailScreen.dart` |
| Route | `/vouchers/:id` |
| Akses | Sanctum |
| Parameter | Path `id`; `extra` sebaiknya berisi JSON `VoucherModel`. |
| Masuk dari | Dari `VoucherListScreen` dengan `extra` berisi JSON voucher. |
| Provider | `authProvider` |
| Model | `VoucherModel` |
| Endpoint | 2 |
| Tabel | 3 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/voucher/voucher-detail.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Voucher/Presentation/Screens/VoucherDetail/VoucherDetailScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Model | `lib/Features/Voucher/Data/Models/VoucherModel/VoucherModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Voucher/` | Test happy path + error path |
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
2. Buka `lib/Features/Voucher/Presentation/Screens/VoucherDetail/VoucherDetailScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/vouchers/:id`.
4. Verifikasi endpoint ke backend: GET /vouchers; POST /vouchers/{voucher}/claim.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `kedaluwarsa`, `sudah diklaim`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
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
rg "VoucherDetailScreen" lib
flutter analyze
flutter test test/Features/Voucher

# dari root backend
php artisan route:list --path=api | Select-String "/vouchers"

# dari PostgreSQL
\d+ vouchers
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
