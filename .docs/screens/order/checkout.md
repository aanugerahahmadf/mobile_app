# Checkout

> **Fitur:** Pesanan · **Route:** `/checkout` · **Akses:** Sanctum · **Tipe:** Pesanan / checkout
> **Implementasi referensi (aplikasi saat ini):** `CheckoutScreen` · **State:** State management terpusat + state lokal · **Pola:** request-response
> **API:** 5 endpoint · **Tabel:** 12 · **Model:** 1
> Diverifikasi 6 November 2026 dari implementasi aplikasi saat ini, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Mengumpulkan data acara, alamat, voucher, dan membuat pesanan. |
| Aktor | Pelanggan terautentikasi (Sanctum) |
| Nilai pengguna | Mengumpulkan data acara, alamat, voucher, dan membuat pesanan. |
| Definisi sukses | Pesanan dibuat/ditampilkan dengan status dan total yang benar. |
| Risiko utama | Alamat yang dikirim tidak divalidasi/disimpan backend (GAP-06). |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Mengumpulkan data acara, alamat, voucher, dan membuat pesanan. | Pesanan dibuat/ditampilkan dengan status dan total yang benar. |

### 1.2 In scope

- Muat item dari keranjang atau `extra`.
- Isi tanggal, waktu, kuantitas, kontak, dan alamat.
- Validasi voucher ke server.
- Kirim `POST /bookings`.
- Arahkan ke instruksi pembayaran.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Dari `CartScreen` (item terpilih) atau beli langsung dari detail katalog. |
| Route | `/checkout` |
| Parameter/extra | `extra: {type, id, tier_id}` untuk beli langsung; tanpa extra memakai keranjang. |
| Guard | Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login. |
| Keluar ke | `/order/:id` |
| Perilaku back | Jika ada perubahan belum disimpan, tampilkan konfirmasi sebelum keluar. [Usulan] |

### 2.1 Layar terkait dalam fitur yang sama

| Layar | Route | PRD |
|---|---|---|
| `OrderDetailScreen` | `/order/:id` | [order-detail.md](../order/order-detail.md) |
| `OrderHistoryScreen` | `/orders` | [order-history.md](../order/order-history.md) |

## 3. Alur Pengguna

1. Muat item dari keranjang atau `extra`.
2. Isi tanggal, waktu, kuantitas, kontak, dan alamat.
3. Validasi voucher ke server.
4. Kirim `POST /bookings`.
5. Arahkan ke instruksi pembayaran.

**Decision points yang wajib diuji:**

- `voucher tidak valid` → Tampilkan status yang jelas dan aksi pemulihan.
- `validasi gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Dari CartScreen (item terpilih) atau beli langsung dari detail katalog."] --> B["Render awal / muat data"]
  B -->|sukses| C["Ringkasan item"]
  C --> D["Arahkan ke instruksi pembayaran."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| Komponen/layar | `CheckoutScreen` |
| Identifier | `CheckoutScreen` |
| Tipe komponen | Komponen ber-state |
| Komponen state | Tersedia pada implementasi referensi |
| State management | State management terpusat + state lokal |
| Pola data | request-response |
| State/dependency | `authProvider`, `voucherProvider` |
| Data source/repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Komponen UI bersama | `AppButton`, `AppSnackbar`, `AppCountryPickerField`, `AppMapAddressPicker`, `AppTextField`, `AppOptionsPickerSheet`, `AppDateTimePicker`, `GuestAuthPrompt`, `AppShimmer`, `AppBreadcrumbs` |
| Komponen UI fitur | `AuthModals`, `PaymentMethodSelector`, `PaymentCountdown`, `UploadPaymentProof` |
| Model | `VoucherModel` |

### 4.1 State lokal yang terdeteksi

| Field | Tipe | Peran |
|---|---|---|
| `_formKey` | `GlobalKey<FormState>` | State lokal layar. |
| `_nameController` | `TextEditingController` | Controller/state input; wajib dibersihkan saat tidak dipakai. |
| `_whatsappController` | `TextEditingController` | Controller/state input; wajib dibersihkan saat tidak dipakai. |
| `_notesController` | `TextEditingController` | Controller/state input; wajib dibersihkan saat tidak dipakai. |
| `_voucherController` | `TextEditingController` | Controller/state input; wajib dibersihkan saat tidak dipakai. |
| `_currentStep` | `int` | State lokal layar. |
| `_loadingItem` | `bool` | Menandai proses muat/aksi. |
| `_submitting` | `bool` | Mencegah submit ganda. |
| `_voucherValid` | `bool` | State lokal layar. |
| `_countryController` | `TextEditingController` | Controller/state input; wajib dibersihkan saat tidak dipakai. |
| `_addressController` | `TextEditingController` | Controller/state input; wajib dibersihkan saat tidak dipakai. |
| `_countryCode` | `String` | State lokal layar. |
| `_provinceId` | `int?` | State lokal layar. |
| `_cityId` | `int?` | State lokal layar. |
| `_districtId` | `int?` | State lokal layar. |
| `_villageId` | `int?` | State lokal layar. |
| `_provinceName` | `String` | State lokal layar. |
| `_cityName` | `String` | State lokal layar. |
| `_districtName` | `String` | State lokal layar. |
| `_villageName` | `String` | State lokal layar. |

### 4.2 Metode internal

`_parseDialCode`, `_digitsAfterDialCode`, `_fetchItem`, `_loadFromCart`, `_pickDate`, `_pickTime`, `_checkVoucher`, `_checkVoucherFallback`, `_getItemPrice`, `_getBaseTotal`, `_getFinalPrice`, `_getItemName`, `_getItemImage`, `_nextStep`, `_prevStep`, `_requireAuthThen`, `_handleCheckout`, `_refreshAfterUpload`, `_openPaymentMethod`, `_countryCodeLabel`.

### 4.3 Alur data

```text
UI / State layar
   ↓ baca/tulis
State management / dependency
   ↓
Repository / HTTP client
   ↓ REST
Controller Laravel → PostgreSQL (12 tabel terkait)
```

## 5. Blueprint UI

Wireframe konseptual dari daftar elemen registry. Urutan final mengikuti implementasi aplikasi.

```text
┌────────────────────────────────────────────────────────────────────┐
│ Checkout                                                          │
├────────────────────────────────────────────────────────────────────┤
│ 1. Ringkasan item                                                 │
│ 2. Form acara                                                     │
│ 3. Pemilih voucher                                                │
│ 4. Ringkasan total                                                │
│ 5. Tombol buat pesanan                                            │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `AppButton`, `AppSnackbar`, `AppCountryPickerField`, `AppMapAddressPicker`, `AppTextField`, `AppOptionsPickerSheet`, `AppDateTimePicker`, `GuestAuthPrompt`, `AppShimmer`, `AppBreadcrumbs`
- Fitur: `AuthModals`, `PaymentMethodSelector`, `PaymentCountdown`, `UploadPaymentProof`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Ringkasan item | Visual data | Tampilkan ringkasan; tidak dapat diubah langsung. | Placeholder bila data kosong. |
| 2 | Form acara | Input | Isi/ubah nilai; validasi client sebelum kirim. | Error inline; 422 dipetakan per field. |
| 3 | Pemilih voucher | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |
| 4 | Ringkasan total | Visual data | Tampilkan ringkasan; tidak dapat diubah langsung. | Placeholder bila data kosong. |
| 5 | Tombol buat pesanan | Pesan | Tampilkan/balas pesan; long-press untuk menu konteks. | Status kirim/terbaca/gagal tampil jelas. |

### 6.1 Fakta teknis form & interaksi

| Fakta | Nilai |
|---|---|
| TextEditingController | 6 |
| Field teks/form | 1 |
| Dropdown | 0 |
| Switch/toggle | 0 |
| Validator client | 2 |
| Field password (teks tersamar) | 0 |
| maxLength | Tidak terdeteksi |
| Keyboard | number |
| Input formatter | FilteringTextInputFormatter |
| Upload file | Tidak |
| Kamera | Tidak |
| WebView | Tidak |
| Timer/polling | Tidak |
| Pagination | Tidak |
| Pull to refresh | Tidak |

## 7. Copywriting & Microcopy

Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai sistem lokalisasi/i18n yang konsisten dan mengikuti gaya bahasa layar lain.

| Lokasi | Draft copy | Catatan |
|---|---|---|
| Judul/header | Checkout | Samakan dengan label navigasi. |
| Subjudul | Mengumpulkan data acara, alamat, voucher, dan membuat pesanan. | Ringkas; jangan mengulang judul. |
| Tombol utama | Buat Pesanan | [Usulan] Disabled saat proses. |
| Empty state | Belum ada checkout. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat checkout. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |
| Ringkasan | Ringkasan pesanan | [Usulan] Total final selalu dari backend. |
| Konfirmasi | Pastikan data acara sudah benar. | [Usulan] Cek sebelum submit. |

## 8. Design System & Responsif

### 8.1 Token yang wajib dipakai

| Token | Nilai |
|---|---|
| Font | Instrument Sans (W400/W600), aset lokal |
| Warna primer | `#1E3A5F` (token primer aplikasi) |
| Aksen | `#C9A94E` |
| Background light | `#F8F6F7` |
| Surface light | `#FFFFFF` |
| Background dark | `#121212` |
| Surface dark | `#1E1E1E` |
| Teks primer light | `#1A1A2E`; dark `#E8E8E8` |
| Teks sekunder light | `#8E8E9A`; dark `#A0A0A0` |
| Sukses/error/warning/info | `#10B981` / `#EF4444` / `#F59E0B` / `#3B82F6` |
| Tipografi | `headTitle` 22/w600; `subHeadTitle` 16/w400; `h3` 14/w600; `h4` 12/w400; `description` 14/1.4 |
| Spacing | skala 2, 4, 8, 16, 24, 32, 48, 64 |
| Radius | card 16, button 14, input 14, avatar 28, bottom nav 24 |
| Glass | `AppBlurBackdrop`; `blurSigma` 15; tint light `#32FFFFFF`, night `#32000000` |

### 8.2 Aturan responsif

- Lebar minimum yang wajib diuji: **320 px**; target umum 360/390/412 px.
- Tablet ≥ 600 px: gunakan padding lebih lebar dan grid multi-kolom bila layar berupa koleksi.
- Jangan mengunci tinggi konten; gunakan `SingleChildScrollView`/sliver agar tidak overflow.
- Hormati `SafeArea`, status bar, navigation bar, dan keyboard inset.
- Teks harus tetap terbaca pada text scale 200%; hindari `maxLines: 1` untuk label penting.
- Layout harus aman untuk locale dengan teks lebih panjang (±30%).

### 8.3 Mode gelap & glass

- Tema mengikuti sistem (light/dark) dan dapat di-override `ThemeProvider`.
- Jangan hardcode warna; gunakan token/tema desain aplikasi agar mode gelap bekerja.
- Fallback tanpa blur harus tetap kontras dan terbaca.
- Hormati reduce-motion; animasi 3D/parallax tidak boleh menjadi satu-satunya pembeda state.

## 9. State Machine

| State | Pemicu | UI | Pemulihan |
|---|---|---|---|
| `initial` | Layar dibuka | Kerangka/placeholder awal | Muat data |
| `loading` | Request berjalan | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Data tersedia | Render konten utama | — |
| `empty` | Data kosong | Empty state dengan penjelasan + CTA | Refresh atau aksi lanjutan |
| `error` | Request gagal | Pesan ramah + tombol coba lagi | Retry |
| `unauthorized` | HTTP 401 | Sesi berakhir; arahkan login/Landing | Login ulang |
| `offline` | Koneksi putus | Banner/empty offline | Coba lagi saat online |
| `submitting` | Pengguna menekan aksi utama | Tombol disabled + progress | Selesai atau tampilkan error |
| `voucher tidak valid` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `stok berubah` | Kondisi domain | Tampilkan badge stok habis dan nonaktifkan aksi beli. | Ikuti aksi pemulihan pada pesan |
| `validasi gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `creating` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `GET` | `/catalog/{id}` | `CatalogController@show` | Sanctum | Detail katalog |
| 2 | `GET` | `/cart` | `CartController@index` | Sanctum | Membaca keranjang |
| 3 | `POST` | `/vouchers/validate` | `VoucherController@validateVoucher` | Sanctum | Validasi kode voucher |
| 4 | `GET` | `/bookings` | `OrderController@getOrders` | Sanctum | Membuat/membaca pesanan |
| 5 | `POST` | `/bookings` | `OrderController@createOrder` | Sanctum | Membuat/membaca pesanan |

### 10.2 Detail per endpoint

#### 10.2.1 `GET /catalog/{id}`

- **Controller:** `CatalogController@show`
- **Auth:** Sanctum
- **Kegunaan:** Detail katalog
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/CatalogController/CatalogController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.

#### 10.2.2 `GET /cart`

- **Controller:** `CartController@index`
- **Auth:** Sanctum
- **Kegunaan:** Membaca keranjang
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/CartController/CartController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `data`

#### 10.2.3 `POST /vouchers/validate`

- **Controller:** `VoucherController@validateVoucher`
- **Auth:** Sanctum
- **Kegunaan:** Validasi kode voucher
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/VoucherController/VoucherController.php`
- **Catatan:** Selalu panggil sebelum checkout.

| Field request | Aturan | Wajib |
|---|---|---|
| `code` | `required|string` | Ya |
| `amount` | `required|numeric` | Ya |

- **Response top-level:** `status`, `message`, `data`
- **Pesan error terbaca:** “Voucher tidak valid atau sudah kadaluarsa”

#### 10.2.4 `GET /bookings`

- **Controller:** `OrderController@getOrders`
- **Auth:** Sanctum
- **Kegunaan:** Membuat/membaca pesanan
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `data`, `pagination`, `message`, `error`
- **Pesan error terbaca:** “Gagal memuat pesanan”

#### 10.2.5 `POST /bookings`

- **Controller:** `OrderController@createOrder`
- **Auth:** Sanctum
- **Kegunaan:** Membuat/membaca pesanan
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `package_id` | `required|integer` | Ya |
| `catalog_id` | `required|integer` | Ya |
| `event_date` | `required|date|after_or_equal:today` | Ya |
| `event_time` | `nullable|string` | Tidak |
| `quantity` | `nullable|integer|min:1` | Tidak |
| `notes` | `nullable|string|max:1000` | Tidak |
| `customer_name` | `required|string|max:255` | Ya |
| `whatsapp` | `required|string|max:20` | Ya |
| `voucher_code` | `nullable|string|max:50` | Tidak |

- **Response top-level:** `status`, `message`, `data`, `errors`, `error`
- **Pesan error terbaca:** “Paket tidak termasuk dalam katalog yang dipilih”; “Stok tidak mencukupi”; “Pesanan berhasil dibuat”; “Validasi gagal”

**Envelope acuan** (periksa controller untuk variasi):

```json
{"status":"success","message":"...","data":{}}
```

### 10.3 Pemetaan error HTTP

| HTTP | Failure | Perilaku UI |
|---|---|---|
| 401 | `AuthFailure` | Hapus token, arahkan ke Landing/login, tampilkan sesi berakhir. |
| 403 | `UnknownFailure` / izin | Pesan akses ditolak; jangan logout otomatis. |
| 404 | `NotFoundFailure` | Tampilkan resource tidak ditemukan + kembali. |
| 409 | `ConflictFailure` / server | Tampilkan konflik status (stok, duplikasi, pembayaran). |
| 422 | `ValidationFailure(errors)` | Tampilkan error per field; pertahankan input. |
| 429 | `UnknownFailure` / rate limit | Minta pengguna menunggu; jangan spam retry. |
| 5xx | `ServerFailure` | Pesan error server + tombol coba lagi. |
| null | `NetworkFailure` | Periksa koneksi + retry; pertahankan data lama. |

### 10.4 Model yang dipakai

| Model | File | Field kunci |
|---|---|---|
| `VoucherModel` | implementasi referensi aplikasi | `id`, `name`, `code`, `description`, `discountAmount`, `discountType`, `minPurchase`, `expiresAt`, `isActive`, `isClaimed` |

## 11. Data & Database

| Tabel | Peran | Akses | Kolom kunci |
|---|---|---|---|
| `catalogs` | Item katalog. | Baca/tulis (indikasi) | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock`, `is_active`, `created_at` … |
| `categories` | Kategori katalog. | Baca/tulis (indikasi) | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at`, `name_translations`, `description_translations` … |
| `packages` | Tier/paket dari katalog. | Baca/tulis (indikasi) | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price`, `is_featured`, `features` … |
| `reviews` | Ulasan katalog/paket. | Baca/tulis (indikasi) | `id`, `user_id`, `package_id`, `catalog_id`, `rating`, `comment`, `created_at`, `updated_at`, `title`, `photo` … |
| `media` | File polymorphic (avatar, dokumen, lampiran). | Baca/tulis (indikasi) | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type`, `disk`, `conversions_disk` … |
| `carts` | Item keranjang. | Baca/tulis (indikasi) | `id`, `user_id`, `catalog_id`, `package_id`, `quantity`, `meta`, `created_at`, `updated_at` |
| `vouchers` | Voucher dan masa berlaku. | Baca/tulis (indikasi) | `id`, `code`, `description`, `expires_at`, `is_active`, `is_global`, `max_uses`, `uses_count`, `created_at`, `updated_at` … |
| `discounts` | Diskon yang terkait voucher. | Baca/tulis (indikasi) | `id`, `description`, `discountable_type`, `discountable_id`, `type`, `value`, `start_date`, `end_date`, `is_active`, `created_at` … |
| `user_vouchers` | Voucher yang diklaim pengguna. | Baca/tulis (indikasi) | `id`, `user_id`, `voucher_id`, `claimed_at`, `used_at`, `order_id`, `created_at`, `updated_at` |
| `orders` | Pesanan dan statusnya. | Baca/tulis (indikasi) | `id`, `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status`, `booking_date`, `notes` … |
| `transactions` | Transaksi pembayaran/dompet. | Baca/tulis (indikasi) | `id`, `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount`, `payment_gateway`, `payment_method` … |
| `order_timelines` | Riwayat status pesanan. | Baca/tulis (indikasi) | `id`, `order_id`, `status`, `description`, `metadata`, `created_by`, `created_at`, `updated_at` |

Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service untuk memastikan operasi baca/tulis yang sebenarnya.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL langsung dari klien; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.
- Jangan menyimpulkan status pembayaran dari `orders.status`; gunakan data pembayaran/transaksi.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Pesanan hanya dibuat sekali per tap.
- Total akhir memakai respons backend.
- Voucher divalidasi server sebelum submit.

### 12.2 Validasi server yang terbaca dari controller

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

### 12.3 Validasi client yang terdeteksi

- Form memiliki **1 field** dan **2 validator** client.
- Keyboard: number.
- Validasi client hanya untuk UX; hasil final tetap dari backend (`422`).

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan HTTP client/data source/repository yang sudah ada; jangan membuat client baru di komponen UI.
- Guest tidak boleh memanggil endpoint privat; tampilkan prompt autentikasi tamu.
- Stok, harga, dan ketersediaan paket divalidasi backend saat membuat pesanan.
- Cegah submit ganda; satu tap menghasilkan satu pesanan.
- Jangan mengirim total/harga final dari client sebagai sumber kebenaran.

## 13. Error Handling

Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).

### 13.1 Kegagalan spesifik layar

- Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.
- Respons tidak sesuai envelope → tampilkan error umum, catat status code.
- 401 → bersihkan token dan arahkan ke Landing/login.
- 403 → tampilkan akses ditolak tanpa logout otomatis.
- 5xx → error server + retry; jangan menampilkan stack trace.
- Gap: Alamat yang dikirim tidak divalidasi/disimpan backend (GAP-06).
- Gap: Voucher dicek lokal lebih dulu (GAP-07).
- Gap: `package_id` wajib; tanpa itu backend menolak.

## 14. Keamanan & Privasi

- Token hanya di secure storage; jangan di penyimpanan lokal atau log.
- Jangan menampilkan stack trace, query database, atau detail internal pada pengguna.
- Jangan mengirim PII ke analytics/crash report.
- Validasi kepemilikan resource di backend; client tidak boleh menentukan `user_id`.
- Guest tidak boleh mengirim Bearer token kosong atau mengakses resource privat.

## 15. Aksesibilitas

- Semua ikon/tombol non-teks memiliki label semantik.
- Target sentuh minimal 48×48 dp; jangan hanya mengandalkan ikon kecil.
- Kontras teks memenuhi WCAG AA pada mode terang dan gelap.
- Urutan fokus screen reader mengikuti urutan visual.
- Text scale 200% tidak memotong label atau tombol utama.
- Error form diumumkan dan terhubung ke field terkait.
- Hormati reduce-motion; animasi tidak boleh menghalangi interaksi.

## 16. Performa & Offline

- Gunakan `CachedNetworkImage`/cache yang ada untuk gambar jaringan.
- Hindari pekerjaan berat di `build()`; pindahkan parsing/format ke provider/util.
- Dispose controller, timer, dan subscription di `dispose`.
- Tidak ada cache lokal terdeteksi; jangan menambah cache tanpa kebijakan kedaluwarsa.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_checkout` | Layar dibuka | screen, route, auth | Tidak |
| `checkout_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `checkout_success` | Aksi utama berhasil | duration_ms | Tidak |
| `checkout_failure` | Request/aksi gagal | error_code, status | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Pesanan hanya dibuat sekali per tap.
- [ ] Total akhir memakai respons backend.
- [ ] Voucher divalidasi server sebelum submit.
- [ ] Tombol utama menjalankan aksi: Buat Pesanan.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Dari `CartScreen` (item terpilih) atau beli langsung dari detail katalog.
- [ ] Route/parameter sesuai: `/checkout`.
- [ ] Back tidak meninggalkan state ganda atau mengulang submit.

### 18.3 State & error

- [ ] Loading, content, empty, error, offline, dan unauthorized tertangani.
- [ ] 401 membersihkan token dan mengarahkan ke Landing/login.
- [ ] 422 menampilkan error per field dan mempertahankan input.
- [ ] Tombol tidak dapat ditekan ganda saat request berjalan.

### 18.4 Data & keamanan

- [ ] Semua endpoint yang dipakai terdaftar di backend; tidak ada endpoint karangan.
- [ ] Nominal/stok/status berasal dari respons backend, bukan hitungan lokal.
- [ ] Tidak ada PII/token di log, analytics, atau pesan error.
- [ ] Guest tidak memanggil endpoint privat.

### 18.5 Responsif & aksesibilitas

- [ ] Tidak ada overflow pada lebar 320 px dan orientasi landscape.
- [ ] Mode terang dan gelap terbaca.
- [ ] Text scale 200% tidak memotong label penting.
- [ ] Target sentuh minimal 48×48 dp dan label semantik tersedia.

### 18.6 Kualitas

- [ ] Analisis statis/lint sesuai toolchain target bersih untuk bagian yang diubah.
- [ ] Test happy path dan minimal satu error path ditambahkan/diperbarui.
- [ ] PRD/SKILL diperbarui bila route, endpoint, atau tabel berubah.

## 19. Test Plan

| ID | Jenis | Skenario | Langkah | Hasil yang diharapkan |
|---|---|---|---|---|
| TC-01 | Widget | Happy path | Buka layar melalui: Dari `CartScreen` (item terpilih) atau beli langsung dari detail katalog. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /checkout dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
| TC-03 | Manual | Loading | Buka layar dengan jaringan lambat | Skeleton/spinner tampil; aksi utama disabled. |
| TC-04 | Manual | Empty | Gunakan akun/data tanpa item | Empty state tampil dengan CTA yang sesuai. |
| TC-05 | Manual | Error server | Mock respons 500 | Pesan error + tombol coba lagi; aplikasi tidak crash. |
| TC-06 | Manual | Sesi habis | Gunakan token kedaluwarsa/401 | Token dibersihkan; diarahkan ke Landing/login. |
| TC-07 | Manual | Akses ditolak | Mock respons 403 | Pesan akses ditolak; tidak logout otomatis. |
| TC-08 | Manual | Offline | Matikan jaringan lalu muat/aksi | Pesan offline + retry; data lama (bila ada) tidak hilang. |
| TC-09 | Widget | Double submit | Tekan aksi utama cepat dua kali | Hanya satu request; tombol disabled saat proses. |
| TC-10 | Manual | Layar kecil | Uji lebar 320 px dan landscape | Tidak ada overflow; tombol tetap terjangkau. |
| TC-11 | Manual | Mode gelap | Aktifkan dark mode sistem | Semua teks/komponen terbaca; tidak ada warna hardcode yang pecah. |
| TC-12 | Manual | Aksesibilitas | Aktifkan screen reader dan text scale 200% | Label terbaca; tidak ada teks terpotong. |
| TC-13 | Widget | Validasi kosong | Submit form kosong | Error inline per field; fokus ke field pertama. |
| TC-14 | Manual | Validasi 422 | Mock 422 dengan errors | Error dipetakan ke field; input dipertahankan. |
| TC-15 | Manual | 404 | Buka resource yang tidak ada | Halaman not found + tombol kembali. |
| TC-16 | Manual | Regresi fitur terkait | Buka layar terkait setelah aksi | Navigasi/state tidak rusak dan data konsisten. |

**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, dan golden test untuk layar dengan layout kompleks.

## 20. Gap, Risiko & Dependensi

### 20.1 Gap terdokumentasi

- Alamat yang dikirim tidak divalidasi/disimpan backend (GAP-06).
- Voucher dicek lokal lebih dulu (GAP-07).
- `package_id` wajib; tanpa itu backend menolak.

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| Alamat yang dikirim tidak divalidasi/disimpan backend (GAP-06). | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |
| Panggilan API tersebar di widget | Sedang | Sedang | Refactor bertahap ke repository/provider. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | GET /catalog/{id} | CatalogController@show |
| Endpoint | GET /cart | CartController@index |
| Endpoint | POST /vouchers/validate | VoucherController@validateVoucher |
| Endpoint | GET /bookings | OrderController@getOrders |
| Endpoint | POST /bookings | OrderController@createOrder |
| Database | catalogs | Jangan query langsung dari klien. |
| Database | categories | Jangan query langsung dari klien. |
| Database | packages | Jangan query langsung dari klien. |
| Database | reviews | Jangan query langsung dari klien. |
| Database | media | Jangan query langsung dari klien. |
| Database | carts | Jangan query langsung dari klien. |
| Database | vouchers | Jangan query langsung dari klien. |
| Database | discounts | Jangan query langsung dari klien. |
| Database | user_vouchers | Jangan query langsung dari klien. |
| Database | orders | Jangan query langsung dari klien. |
| Database | transactions | Jangan query langsung dari klien. |
| Database | order_timelines | Jangan query langsung dari klien. |
| State/dependency | authProvider | Komponen state/dependency terkait |
| State/dependency | voucherProvider | Komponen state/dependency terkait |
| Route | /checkout | Terdaftar di konfigurasi router aplikasi. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | Komponen/Referensi | Catatan |
|---|---|---|
| Layar/UI | `CheckoutScreen` | Implementasi referensi aplikasi saat ini |
| State/dependency | `authProvider` | Komponen state/dependency terkait |
| State/dependency | `voucherProvider` | Komponen state/dependency terkait |
| Model/data | `VoucherModel` | Struktur data terkait |
| Komponen UI bersama | `AppButton` | Komponen UI reusable |
| Komponen UI bersama | `AppSnackbar` | Komponen UI reusable |
| Komponen UI bersama | `AppCountryPickerField` | Komponen UI reusable |
| Komponen UI bersama | `AppMapAddressPicker` | Komponen UI reusable |
| Komponen UI bersama | `AppTextField` | Komponen UI reusable |
| Komponen UI bersama | `AppOptionsPickerSheet` | Komponen UI reusable |
| Komponen UI bersama | `AppDateTimePicker` | Komponen UI reusable |
| Komponen UI bersama | `GuestAuthPrompt` | Komponen UI reusable |
| Komponen UI bersama | `AppShimmer` | Komponen UI reusable |
| Komponen UI bersama | `AppBreadcrumbs` | Komponen UI reusable |
| Komponen UI fitur | `AuthModals` | Komponen UI khusus fitur |
| Komponen UI fitur | `PaymentMethodSelector` | Komponen UI khusus fitur |
| Komponen UI fitur | `PaymentCountdown` | Komponen UI khusus fitur |
| Komponen UI fitur | `UploadPaymentProof` | Komponen UI khusus fitur |
| Test | Sesuai platform target | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/order/checkout.md` | PRD ini |
| Prompt | `.skills/screens/order/checkout/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_parseDialCode`, `_digitsAfterDialCode`, `_fetchItem`, `_loadFromCart`, `_pickDate`, `_pickTime`, `_checkVoucher`, `_checkVoucherFallback`, `_getItemPrice`, `_getBaseTotal`, `_getFinalPrice`, `_getItemName`, `_getItemImage`, `_nextStep`, `_prevStep`, `_requireAuthThen`, `_handleCheckout`, `_refreshAfterUpload`, `_openPaymentMethod`, `_countryCodeLabel`.

> **Catatan arsitektur:** layar memakai HTTP client bersama langsung. Saat refactor, pindahkan ke repository/provider tanpa mengubah kontrak.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/order/checkout/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Implementasi aplikasi, route Laravel, skema PostgreSQL |
