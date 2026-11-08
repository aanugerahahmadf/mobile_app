---
name: order-checkout
description: Implementasi layar Checkout (CheckoutScreen) pada fitur Pesanan; route /checkout, 5 endpoint, 12 tabel, state, guardrail, dan definition of done.
---

# Skill: Checkout

> **Tipe:** Pesanan / checkout · **Route:** `/checkout` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Checkout (CheckoutScreen) di fitur Pesanan.
File utama: lib/Features/Order/Presentation/Screens/Checkout/CheckoutScreen.dart. Route: /checkout (Sanctum).
Tujuan: Mengumpulkan data acara, alamat, voucher, dan membuat pesanan.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/order/checkout.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /catalog/{id}; GET /cart; POST /vouchers/validate; GET /bookings; POST /bookings.
- Tabel: catalogs, categories, packages, reviews, media, carts, vouchers, discounts, user_vouchers, orders, transactions, order_timelines.
- Parameter/extra: `extra: {type, id, tier_id}` untuk beli langsung; tanpa extra memakai keranjang.

Wajib dipertahankan:
- Pesanan hanya dibuat sekali per tap.
- Total akhir memakai respons backend.
- Voucher divalidasi server sebelum submit.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: buat pesanan bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `CheckoutScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Order/Presentation/Screens/Checkout/CheckoutScreen.dart` |
| Route | `/checkout` |
| Akses | Sanctum |
| Parameter | `extra: {type, id, tier_id}` untuk beli langsung; tanpa extra memakai keranjang. |
| Masuk dari | Dari `CartScreen` (item terpilih) atau beli langsung dari detail katalog. |
| Provider | `authProvider`, `voucherProvider` |
| Model | `VoucherModel` |
| Endpoint | 5 |
| Tabel | 12 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/order/checkout.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Order/Presentation/Screens/Checkout/CheckoutScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Voucher/Presentation/Providers/VoucherProvider/VoucherProvider.dart` | State/aksi domain |
| Model | `lib/Features/Voucher/Data/Models/VoucherModel/VoucherModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Pesanan/` | Test happy path + error path |
| PRD | `.docs/screens/order/checkout.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/order/checkout/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Mengumpulkan data acara, alamat, voucher, dan membuat pesanan.

1. Muat item dari keranjang atau `extra`.
2. Isi tanggal, waktu, kuantitas, kontak, dan alamat.
3. Validasi voucher ke server.
4. Kirim `POST /bookings`.
5. Arahkan ke instruksi pembayaran.

### 5.2 Elemen UI wajib

- Ringkasan item
- Form acara
- Pemilih voucher
- Ringkasan total
- Tombol buat pesanan

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
| `voucher tidak valid` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `stok berubah` | Tampilkan badge stok habis dan nonaktifkan aksi beli. | Ikuti aksi pemulihan pada pesan |
| `validasi gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `creating` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Pesanan hanya dibuat sekali per tap.
- Total akhir memakai respons backend.
- Voucher divalidasi server sebelum submit.
- Stok, harga, dan ketersediaan paket divalidasi backend saat membuat pesanan.
- Cegah submit ganda; satu tap menghasilkan satu pesanan.
- Jangan mengirim total/harga final dari client sebagai sumber kebenaran.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/order/checkout.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Order/Presentation/Screens/Checkout/CheckoutScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/checkout`.
4. Verifikasi endpoint ke backend: GET /catalog/{id}; GET /cart; POST /vouchers/validate; GET /bookings; POST /bookings.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `voucher tidak valid`, `stok berubah`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Buat Pesanan.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/catalog/{id}` | `CatalogController@show` | Sanctum | Detail katalog |
| `GET` | `/cart` | `CartController@index` | Sanctum | Membaca keranjang |
| `POST` | `/vouchers/validate` | `VoucherController@validateVoucher` | Sanctum | Validasi kode voucher |
| `GET` | `/bookings` | `OrderController@getOrders` | Sanctum | Membuat/membaca pesanan |
| `POST` | `/bookings` | `OrderController@createOrder` | Sanctum | Membuat/membaca pesanan |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `code` | `required|string` | `/vouchers/validate` |
| `amount` | `required|numeric` | `/vouchers/validate` |
| `package_id` | `required|integer` | `/bookings` |
| `catalog_id` | `required|integer` | `/bookings` |
| `event_date` | `required|date|after_or_equal:today` | `/bookings` |
| `event_time` | `nullable|string` | `/bookings` |
| `quantity` | `nullable|integer|min:1` | `/bookings` |
| `notes` | `nullable|string|max:1000` | `/bookings` |
| `customer_name` | `required|string|max:255` | `/bookings` |
| `whatsapp` | `required|string|max:20` | `/bookings` |
| `voucher_code` | `nullable|string|max:50` | `/bookings` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `categories` | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at` … |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `reviews` | `id`, `user_id`, `package_id`, `catalog_id`, `rating`, `comment`, `created_at`, `updated_at` … |
| `media` | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type` … |
| `carts` | `id`, `user_id`, `catalog_id`, `package_id`, `quantity`, `meta`, `created_at`, `updated_at` |
| `vouchers` | `id`, `code`, `description`, `expires_at`, `is_active`, `is_global`, `max_uses`, `uses_count` … |
| `discounts` | `id`, `description`, `discountable_type`, `discountable_id`, `type`, `value`, `start_date`, `end_date` … |
| `user_vouchers` | `id`, `user_id`, `voucher_id`, `claimed_at`, `used_at`, `order_id`, `created_at`, `updated_at` |
| `orders` | `id`, `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status` … |
| `transactions` | `id`, `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount` … |
| `order_timelines` | `id`, `order_id`, `status`, `description`, `metadata`, `created_by`, `created_at`, `updated_at` |

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
| `voucher tidak valid` | Ya |
| `stok berubah` | Ya |
| `validasi gagal` | Ya |
| `creating` | Ya |

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
rg "CheckoutScreen" lib
flutter analyze
flutter test test/Features/Pesanan

# dari root backend
php artisan route:list --path=api | Select-String "/catalog/"

# dari PostgreSQL
\d+ catalogs
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Alamat yang dikirim tidak divalidasi/disimpan backend (GAP-06).
- Voucher dicek lokal lebih dulu (GAP-07).
- `package_id` wajib; tanpa itu backend menolak.
- Layar memakai `DioClient.instance` langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
