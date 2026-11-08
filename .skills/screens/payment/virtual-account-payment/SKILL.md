---
name: payment-virtual-account-payment
description: Implementasi layar Pembayaran Virtual Account (VirtualAccountPaymentScreen) pada fitur Pembayaran; route -, 4 endpoint, 6 tabel, state, guardrail, dan definition of done.
---

# Skill: Pembayaran Virtual Account

> **Tipe:** Pembayaran · **Route:** tidak terdaftar · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Pembayaran Virtual Account (VirtualAccountPaymentScreen) di fitur Pembayaran.
File utama: lib/Features/Payment/Presentation/Screens/VirtualAccountPayment/VirtualAccountPaymentScreen.dart. Route: - (Sanctum).
Tujuan: Menampilkan nomor virtual account dan instruksi transfer.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/payment/virtual-account-payment.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: POST /bookings/{id}/virtual-account; GET /bookings/{id}; PUT /bookings/{id}; DELETE /bookings/{id}.
- Tabel: payment_virtual_accounts, transactions, banks, orders, order_timelines, order_payments.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Nomor VA sesuai respons dan dapat disalin.
- Status paid menghentikan countdown.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: saya sudah bayar bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `VirtualAccountPaymentScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.
- Mengubah logika payment gateway di backend; itu di luar layar ini.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Payment/Presentation/Screens/VirtualAccountPayment/VirtualAccountPaymentScreen.dart` |
| Route | tidak terdaftar |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Tidak memiliki route; layar pembayaran saat ini memakai instruksi umum. |
| Provider | Tidak terdeteksi |
| Model | Tidak terdeteksi |
| Endpoint | 4 |
| Tabel | 6 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/payment/virtual-account-payment.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Payment/Presentation/Screens/VirtualAccountPayment/VirtualAccountPaymentScreen.dart` | UI, state, interaksi |
| Test | `test/Features/Pembayaran/` | Test happy path + error path |
| PRD | `.docs/screens/payment/virtual-account-payment.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/payment/virtual-account-payment/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan nomor virtual account dan instruksi transfer.

1. Minta VA ke backend.
2. Tampilkan nomor dan bank.
3. Salin nomor.
4. Polling status.

### 5.2 Elemen UI wajib

- Nomor VA
- Nama bank
- Tombol salin
- Countdown

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
| `expired` | Status kedaluwarsa + instruksi | Muat ulang/buat kode baru |
| `VA kedaluwarsa` | Tampilkan status kedaluwarsa dan aksi muat ulang. | Ikuti aksi pemulihan pada pesan |
| `sudah dibayar` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `gagal membuat VA` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Nomor VA sesuai respons dan dapat disalin.
- Status paid menghentikan countdown.
- Nominal final dan status pembayaran berasal dari backend; jangan menghitung ulang di client.
- Jangan menandai lunas berdasarkan callback UI; lakukan polling/refresh status resmi.
- Tampilkan deadline dari server dan tangani status kedaluwarsa.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/payment/virtual-account-payment.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Payment/Presentation/Screens/VirtualAccountPayment/VirtualAccountPaymentScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: tidak terdaftar.
4. Verifikasi endpoint ke backend: POST /bookings/{id}/virtual-account; GET /bookings/{id}; PUT /bookings/{id}; DELETE /bookings/{id}.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `expired`, `VA kedaluwarsa`.
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
| `POST` | `/bookings/{id}/virtual-account` | `OrderController@createVirtualAccount` | Sanctum | Membuat virtual account |
| `GET` | `/bookings/{id}` | `OrderController@show` | Sanctum | Detail/mengubah/menghapus pesanan |
| `PUT` | `/bookings/{id}` | `OrderController@updateOrder` | Sanctum | Detail/mengubah/menghapus pesanan |
| `DELETE` | `/bookings/{id}` | `OrderController@deleteOrder` | Sanctum | Detail/mengubah/menghapus pesanan |

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

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `payment_virtual_accounts` | `id`, `user_id`, `order_id`, `transaction_id`, `virtual_account_no`, `virtual_account_name`, `virtual_account_expiry`, `amount` … |
| `transactions` | `id`, `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount` … |
| `banks` | `id`, `name`, `code`, `type`, `account_number`, `account_holder`, `logo`, `qris_payload` … |
| `orders` | `id`, `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status` … |
| `order_timelines` | `id`, `order_id`, `status`, `description`, `metadata`, `created_by`, `created_at`, `updated_at` |
| `order_payments` | `id`, `order_id`, `method`, `status`, `amount`, `paid_at`, `transaction_id`, `proof_url` … |

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
| `expired` | Ya |
| `VA kedaluwarsa` | Ya |
| `sudah dibayar` | Ya |
| `gagal membuat VA` | Ya |

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
rg "VirtualAccountPaymentScreen" lib
flutter analyze
flutter test test/Features/Pembayaran

# dari root backend
php artisan route:list --path=api | Select-String "/bookings/"

# dari PostgreSQL
\d+ payment_virtual_accounts
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Layar tidak terdaftar di router (GAP-12), meski endpoint tersedia.
- Layar belum terdaftar di `AppRouter`; jangan menganggapnya dapat dijangkau lewat deep link.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Belum terhubung ke `AppRouter` (lihat gap)
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
