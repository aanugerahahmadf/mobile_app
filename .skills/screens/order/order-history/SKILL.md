---
name: order-history
description: Implementasi layar Riwayat Pesanan (OrderHistoryScreen) pada fitur Pesanan; route /orders, 6 endpoint, 8 tabel, state, guardrail, dan definition of done.
---

# Skill: Riwayat Pesanan

> **Tipe:** Pesanan / checkout · **Route:** `/orders` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Riwayat Pesanan (OrderHistoryScreen) di fitur Pesanan.
File utama: lib/Features/Order/Presentation/Screens/OrderHistory/OrderHistoryScreen.dart. Route: /orders (Sanctum).
Tujuan: Menampilkan pesanan pengguna dengan tab status dan aksi cepat.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/order/order-history.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /bookings; POST /bookings; POST /bookings/{id}/cancel; GET /bookings/{id}; PUT /bookings/{id}; DELETE /bookings/{id}.
- Tabel: orders, transactions, order_timelines, packages, catalogs, vouchers, user_vouchers, order_payments.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Tab tidak mengubah data, hanya filter.
- Pesanan baru muncul setelah kembali dari checkout.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: lihat pesanan bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `OrderHistoryScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Order/Presentation/Screens/OrderHistory/OrderHistoryScreen.dart` |
| Route | `/orders` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Tab Pesanan di `MainShell`. |
| Provider | `authProvider`, `orderProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 6 |
| Tabel | 8 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/order/order-history.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Order/Presentation/Screens/OrderHistory/OrderHistoryScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Order/Presentation/Providers/OrderProvider/OrderProvider.dart` | State/aksi domain |
| Test | `test/Features/Pesanan/` | Test happy path + error path |
| PRD | `.docs/screens/order/order-history.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/order/order-history/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan pesanan pengguna dengan tab status dan aksi cepat.

1. Muat halaman pesanan.
2. Filter berdasarkan status.
3. Muat lebih banyak saat scroll.
4. Buka detail atau bayar.

### 5.2 Elemen UI wajib

- Tab status
- Kartu pesanan
- Badge status
- Tombol bayar
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
| `refreshing` | Spinner di atas konten | Selesai; reset halaman |
| `pagination` | Loader footer | Muat halaman berikutnya |
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `load more` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `guest` | Tampilkan `GuestAuthPrompt`; jangan panggil endpoint privat. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Tab tidak mengubah data, hanya filter.
- Pesanan baru muncul setelah kembali dari checkout.
- Stok, harga, dan ketersediaan paket divalidasi backend saat membuat pesanan.
- Cegah submit ganda; satu tap menghasilkan satu pesanan.
- Jangan mengirim total/harga final dari client sebagai sumber kebenaran.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/order/order-history.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Order/Presentation/Screens/OrderHistory/OrderHistoryScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/orders`.
4. Verifikasi endpoint ke backend: GET /bookings; POST /bookings; POST /bookings/{id}/cancel; GET /bookings/{id}; PUT /bookings/{id}; DELETE /bookings/{id}.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `pagination`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.
4. Implementasikan pagination: simpan `currentPage`/`hasMore`, reset saat refresh.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Lihat Pesanan.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/bookings` | `OrderController@getOrders` | Sanctum | Membuat/membaca pesanan |
| `POST` | `/bookings` | `OrderController@createOrder` | Sanctum | Membuat/membaca pesanan |
| `POST` | `/bookings/{id}/cancel` | `OrderController@cancelOrder` | Sanctum | Membatalkan pesanan |
| `GET` | `/bookings/{id}` | `OrderController@show` | Sanctum | Detail/mengubah/menghapus pesanan |
| `PUT` | `/bookings/{id}` | `OrderController@updateOrder` | Sanctum | Detail/mengubah/menghapus pesanan |
| `DELETE` | `/bookings/{id}` | `OrderController@deleteOrder` | Sanctum | Detail/mengubah/menghapus pesanan |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `package_id` | `required|integer` | `/bookings` |
| `catalog_id` | `required|integer` | `/bookings` |
| `event_date` | `required|date|after_or_equal:today` | `/bookings` |
| `event_time` | `nullable|string` | `/bookings` |
| `quantity` | `nullable|integer|min:1` | `/bookings` |
| `notes` | `nullable|string|max:1000` | `/bookings` |
| `customer_name` | `required|string|max:255` | `/bookings` |
| `whatsapp` | `required|string|max:20` | `/bookings` |
| `voucher_code` | `nullable|string|max:50` | `/bookings` |
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
| `orders` | `id`, `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status` … |
| `transactions` | `id`, `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount` … |
| `order_timelines` | `id`, `order_id`, `status`, `description`, `metadata`, `created_by`, `created_at`, `updated_at` |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `vouchers` | `id`, `code`, `description`, `expires_at`, `is_active`, `is_global`, `max_uses`, `uses_count` … |
| `user_vouchers` | `id`, `user_id`, `voucher_id`, `claimed_at`, `used_at`, `order_id`, `created_at`, `updated_at` |
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
| `refreshing` | Ya |
| `pagination` | Ya |
| `kosong` | Ya |
| `load more` | Ya |
| `guest` | Ya |

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
rg "OrderHistoryScreen" lib
flutter analyze
flutter test test/Features/Pesanan

# dari root backend
php artisan route:list --path=api | Select-String "/bookings"

# dari PostgreSQL
\d+ orders
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Guest diarahkan ke prompt login.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
