---
name: payment-instruction
description: Implementasi layar Instruksi Pembayaran (PaymentInstructionScreen) pada fitur Pembayaran; route /payment/:orderId, 8 endpoint, 10 tabel, state, guardrail, dan definition of done.
---

# Skill: Instruksi Pembayaran

> **Tipe:** Pembayaran · **Route:** `/payment/:orderId` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Instruksi Pembayaran (PaymentInstructionScreen) di fitur Pembayaran.
File utama: lib/Features/Payment/Presentation/Screens/PaymentInstruction/PaymentInstructionScreen.dart. Route: /payment/:orderId (Sanctum).
Tujuan: Menampilkan metode pembayaran, total, countdown, dan instruksi untuk menyelesaikan pembayaran.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/payment/payment-instruction.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /bookings/{id}; PUT /bookings/{id}; DELETE /bookings/{id}; POST /bookings/{id}/pay; POST /bookings/{id}/virtual-account; POST /bookings/{id}/qris …
- Tabel: orders, transactions, order_timelines, order_payments, payment_methods, payment_gateways, payment_virtual_accounts, banks, payment_qris, media.
- Parameter/extra: Path parameter `orderId`.

Wajib dipertahankan:
- Countdown berhenti saat status paid/expired.
- Instruksi berubah sesuai metode.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: saya sudah bayar bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `PaymentInstructionScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.
- Mengubah logika payment gateway di backend; itu di luar layar ini.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Payment/Presentation/Screens/PaymentInstruction/PaymentInstructionScreen.dart` |
| Route | `/payment/:orderId` |
| Akses | Sanctum |
| Parameter | Path parameter `orderId`. |
| Masuk dari | Setelah checkout atau dari detail pesanan. |
| Provider | `authProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 8 |
| Tabel | 10 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/payment/payment-instruction.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Payment/Presentation/Screens/PaymentInstruction/PaymentInstructionScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Test | `test/Features/Pembayaran/` | Test happy path + error path |
| PRD | `.docs/screens/payment/payment-instruction.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/payment/payment-instruction/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan metode pembayaran, total, countdown, dan instruksi untuk menyelesaikan pembayaran.

1. Muat detail pesanan dan metode pembayaran.
2. Pilih metode.
3. Buat VA/QRIS atau tampilkan instruksi manual.
4. Unggah bukti bayar bila manual.

### 5.2 Elemen UI wajib

- Total & countdown
- Daftar metode
- Instruksi
- Tombol salin nomor
- Upload bukti

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
| `expired` | Status kedaluwarsa + instruksi | Muat ulang/buat kode baru |
| `kedaluwarsa` | Tampilkan status kedaluwarsa dan aksi muat ulang. | Ikuti aksi pemulihan pada pesan |
| `metode tidak tersedia` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `upload gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `sudah dibayar` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Countdown berhenti saat status paid/expired.
- Instruksi berubah sesuai metode.
- Nominal final dan status pembayaran berasal dari backend; jangan menghitung ulang di client.
- Jangan menandai lunas berdasarkan callback UI; lakukan polling/refresh status resmi.
- Tampilkan deadline dari server dan tangani status kedaluwarsa.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/payment/payment-instruction.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Payment/Presentation/Screens/PaymentInstruction/PaymentInstructionScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/payment/:orderId`.
4. Verifikasi endpoint ke backend: GET /bookings/{id}; PUT /bookings/{id}; DELETE /bookings/{id}; POST /bookings/{id}/pay; POST /bookings/{id}/virtual-account; POST /bookings/{id}/qris …
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `expired`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Saya Sudah Bayar.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/bookings/{id}` | `OrderController@show` | Sanctum | Detail/mengubah/menghapus pesanan |
| `PUT` | `/bookings/{id}` | `OrderController@updateOrder` | Sanctum | Detail/mengubah/menghapus pesanan |
| `DELETE` | `/bookings/{id}` | `OrderController@deleteOrder` | Sanctum | Detail/mengubah/menghapus pesanan |
| `POST` | `/bookings/{id}/pay` | `OrderController@initiatePayment` | Sanctum | Memilih metode pembayaran |
| `POST` | `/bookings/{id}/virtual-account` | `OrderController@createVirtualAccount` | Sanctum | Membuat virtual account |
| `POST` | `/bookings/{id}/qris` | `OrderController@createQris` | Sanctum | Membuat QRIS |
| `POST` | `/bookings/{id}/upload-proof` | `OrderController@uploadProof` | Sanctum | Mengunggah bukti bayar |
| `GET` | `/bookings/{id}/invoice` | `OrderController@downloadInvoice` | Sanctum | Mengunduh invoice |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `event_date` | `nullable|date|after_or_equal:today` | `/bookings/{id}` |
| `event_time` | `nullable|string|max:255` | `/bookings/{id}` |
| `quantity` | `nullable|integer|min:1` | `/bookings/{id}` |
| `notes` | `nullable|string|max:1000` | `/bookings/{id}` |
| `whatsapp` | `nullable|string|max:20` | `/bookings/{id}` |
| `voucher_code` | `nullable|string|max:50` | `/bookings/{id}` |
| `payment_type` | `nullable|string|in:virtual_account,qris` | `/bookings/{id}` |
| `proof_images` | `sometimes|array|min:1` | `/bookings/{id}/upload-proof` |
| `proof_images.*` | `file|mimes:jpeg,png,jpg,mp4,mov,m4v,webm,3gp,pdf|max:51200` | `/bookings/{id}/upload-proof` |
| `proof_image` | `sometimes|file|mimes:jpeg,png,jpg,mp4,mov,m4v,webm,3gp,pdf|max:51200` | `/bookings/{id}/upload-proof` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `orders` | `id`, `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status` … |
| `transactions` | `id`, `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount` … |
| `order_timelines` | `id`, `order_id`, `status`, `description`, `metadata`, `created_by`, `created_at`, `updated_at` |
| `order_payments` | `id`, `order_id`, `method`, `status`, `amount`, `paid_at`, `transaction_id`, `proof_url` … |
| `payment_methods` | `id`, `name`, `type`, `code`, `account_number`, `account_holder`, `bank_name`, `image_url` … |
| `payment_gateways` | `id`, `name`, `code`, `description`, `config`, `is_active`, `created_at`, `updated_at` |
| `payment_virtual_accounts` | `id`, `user_id`, `order_id`, `transaction_id`, `virtual_account_no`, `virtual_account_name`, `virtual_account_expiry`, `amount` … |
| `banks` | `id`, `name`, `code`, `type`, `account_number`, `account_holder`, `logo`, `qris_payload` … |
| `payment_qris` | `id`, `user_id`, `order_id`, `transaction_id`, `qr_content`, `qr_expiry`, `amount`, `status` … |
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
| `refreshing` | Ya |
| `expired` | Ya |
| `kedaluwarsa` | Ya |
| `metode tidak tersedia` | Ya |
| `upload gagal` | Ya |
| `sudah dibayar` | Ya |

## 10. Guardrail

- Jangan mengarang endpoint, parameter, atau kolom database.
- Jangan membuat instance `Dio` baru di widget; gunakan `DioClient`/repository.
- Jangan memanggil API di `build()` atau setiap rebuild.
- Jangan menyimpan token/password/PIN di `SharedPreferences` atau log.
- Jangan menampilkan stack trace/pesan database ke pengguna.
- Jangan menambah dependensi baru tanpa alasan dan persetujuan.
- Jangan mengubah route/parameter tanpa memperbarui `AppRouter` dan dokumen.
- Jangan menghapus test yang ada untuk membuat build lulus.
- Jangan menghitung total/status pembayaran di client.

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
rg "PaymentInstructionScreen" lib
flutter analyze
flutter test test/Features/Pembayaran

# dari root backend
php artisan route:list --path=api | Select-String "/bookings/"

# dari PostgreSQL
\d+ orders
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- QRIS/VA memiliki layar terpisah yang belum terhubung (GAP-12).
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
