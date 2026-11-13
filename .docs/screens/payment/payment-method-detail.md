# Detail Metode Pembayaran

> **Fitur:** Pembayaran · **Route:** `/payment-method/:orderId` · **Akses:** Sanctum · **Tipe:** Pembayaran
> **Implementasi referensi (aplikasi saat ini):** `PaymentMethodDetailScreen` · **State:** State management terpusat + state lokal · **Pola:** polling periodik
> **API:** 8 endpoint · **Tabel:** 10 · **Model:** 0
> Diverifikasi 6 November 2026 dari implementasi aplikasi saat ini, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Menampilkan detail satu metode pembayaran dan formulir konfirmasi. |
| Aktor | Pelanggan terautentikasi (Sanctum) |
| Nilai pengguna | Menampilkan detail satu metode pembayaran dan formulir konfirmasi. |
| Definisi sukses | Status pembayaran terkonfirmasi dari backend tanpa salah tafsir. |
| Risiko utama | `extra` wajib bertipe `PaymentMethodInfo`; route akan error bila null. |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Menampilkan detail satu metode pembayaran dan formulir konfirmasi. | Status pembayaran terkonfirmasi dari backend tanpa salah tafsir. |

### 1.2 In scope

- Terima `PaymentMethodInfo`.
- Tampilkan nomor VA/QR atau instruksi.
- Konfirmasi pembayaran atau unggah bukti.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak menghitung total final atau menyimpulkan status pembayaran dari state lokal.
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Dari `PaymentInstructionScreen` dengan `extra` `PaymentMethodInfo`. |
| Route | `/payment-method/:orderId` |
| Parameter/extra | Path `orderId`; `extra` wajib `PaymentMethodInfo`. |
| Guard | Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login. |
| Keluar ke | `/payment-webview` |
| Perilaku back | Kembali ke rincian pesanan tanpa mengulang submit; status pembayaran tetap dicek ke backend. |

### 2.1 Layar terkait dalam fitur yang sama

| Layar | Route | PRD |
|---|---|---|
| `PaymentInstructionScreen` | `/payment/:orderId` | [payment-instruction.md](../payment/payment-instruction.md) |
| `PaymentWebViewScreen` | `/payment-webview` | [payment-webview.md](../payment/payment-webview.md) |
| `QrisPaymentScreen` | — | [qris-payment.md](../payment/qris-payment.md) |
| `VirtualAccountPaymentScreen` | — | [virtual-account-payment.md](../payment/virtual-account-payment.md) |

## 3. Alur Pengguna

1. Terima `PaymentMethodInfo`.
2. Tampilkan nomor VA/QR atau instruksi.
3. Konfirmasi pembayaran atau unggah bukti.

**Decision points yang wajib diuji:**

- `metode tidak aktif` → Tampilkan status yang jelas dan aksi pemulihan.
- `konfirmasi gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Dari PaymentInstructionScreen dengan extra PaymentMethodInfo."] --> B["Render awal / muat data"]
  B -->|sukses| C["Judul metode"]
  C --> D["Konfirmasi pembayaran atau unggah bukti."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| Komponen/layar | `PaymentMethodDetailScreen` |
| Identifier | `PaymentMethodDetailScreen` |
| Tipe komponen | Komponen ber-state |
| Komponen state | Tersedia pada implementasi referensi |
| State management | State management terpusat + state lokal |
| Pola data | polling periodik |
| State/dependency | `authProvider`, `paymentProvider` |
| Data source/repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Komponen UI bersama | `AppBreadcrumbs`, `AppButton`, `AppSnackbar`, `CreditCardForm`, `GuestAuthPrompt` |
| Komponen UI fitur | Tidak terdeteksi |
| Model | Tidak terdeteksi |

### 4.1 State lokal yang terdeteksi

| Field | Tipe | Peran |
|---|---|---|
| `_order` | `Map<String, dynamic>?` | State lokal layar. |
| `_loading` | `bool` | Menandai proses muat/aksi. |
| `_submitting` | `bool` | Mencegah submit ganda. |
| `_va` | `Map<String, dynamic>?` | State lokal layar. |
| `_vaLoading` | `bool` | Menandai proses muat/aksi. |
| `_qris` | `Map<String, dynamic>?` | State lokal layar. |
| `_qrisLoading` | `bool` | Menandai proses muat/aksi. |
| `_paymentStatusTimer` | `Timer?` | Resource native; wajib dibersihkan saat layar/komponen ditutup. |
| `_cardFormKey` | `GlobalKey<CreditCardFormState>` | State lokal layar. |

### 4.2 Metode internal

`_startPaymentStatusPolling`, `_loadOrder`, `_paymentAmount`, `_confirm`, `_createVirtualAccount`, `_createQris`, `_openApp`, `_payWithGateway`, `_buildHeader`, `_buildQrisContent`, `_buildQrisPlaceholder`, `_buildQrisImage`, `_buildEWalletContent`, `_buildCreditCardContent`, `_buildGenericContent`, `_buildAmountCard`, `_buildSteps`, `_buildInfoRow`, `_buildVirtualAccountPayung`, `_buildQrisCard`.

### 4.3 Alur data

```text
UI / State layar
   ↓ baca/tulis
State management / dependency
   ↓
Repository / HTTP client
   ↓ REST
Controller Laravel → PostgreSQL (10 tabel terkait)
```

## 5. Blueprint UI

Wireframe konseptual dari daftar elemen registry. Urutan final mengikuti implementasi aplikasi.

```text
┌────────────────────────────────────────────────────────────────────┐
│ Detail Metode Pembayaran                                          │
├────────────────────────────────────────────────────────────────────┤
│ 1. Judul metode                                                   │
│ 2. Nomor tujuan                                                   │
│ 3. Tombol salin                                                   │
│ 4. Instruksi bertahap                                             │
│ 5. Form konfirmasi                                                │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `AppBreadcrumbs`, `AppButton`, `AppSnackbar`, `CreditCardForm`, `GuestAuthPrompt`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Judul metode | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |
| 2 | Nomor tujuan | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |
| 3 | Tombol salin | Aksi | Tap → jalankan aksi utama layar. | Disabled saat loading; error lewat SnackBar/inline. |
| 4 | Instruksi bertahap | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |
| 5 | Form konfirmasi | Input | Isi/ubah nilai; validasi client sebelum kirim. | Error inline; 422 dipetakan per field. |

### 6.1 Fakta teknis form & interaksi

| Fakta | Nilai |
|---|---|
| TextEditingController | 0 |
| Field teks/form | 0 |
| Dropdown | 0 |
| Switch/toggle | 0 |
| Validator client | 0 |
| Field password (teks tersamar) | 0 |
| maxLength | Tidak terdeteksi |
| Keyboard | Tidak terdeteksi |
| Input formatter | Tidak terdeteksi |
| Upload file | Tidak |
| Kamera | Tidak |
| WebView | Tidak |
| Timer/polling | Ya |
| Pagination | Tidak |
| Pull to refresh | Ya |

## 7. Copywriting & Microcopy

Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai sistem lokalisasi/i18n yang konsisten dan mengikuti gaya bahasa layar lain.

| Lokasi | Draft copy | Catatan |
|---|---|---|
| Judul/header | Detail Metode Pembayaran | Samakan dengan label navigasi. |
| Subjudul | Menampilkan detail satu metode pembayaran dan formulir konfirmasi. | Ringkas; jangan mengulang judul. |
| Tombol utama | Saya Sudah Bayar | [Usulan] Disabled saat proses. |
| Empty state | Belum ada detail Metode Pembayaran. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat detail Metode Pembayaran. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |
| Status menunggu | Menunggu pembayaran | [Usulan] Tampilkan countdown. |
| Tombol salin | Salin | [Usulan] Beri konfirmasi setelah disalin. |
| Kedaluwarsa | Waktu pembayaran habis. Muat ulang untuk mendapatkan kode baru. | [Usulan] Jangan minta pengguna membayar ulang tanpa instruksi. |

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
| `refreshing` | Pull to refresh | Spinner di atas konten | Selesai; reset halaman |
| `expired` | Deadline pembayaran lewat | Status kedaluwarsa + instruksi | Muat ulang/buat kode baru |
| `metode tidak aktif` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `bukti invalid` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `konfirmasi gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `GET` | `/bookings/{id}` | `OrderController@show` | Sanctum | Detail/mengubah/menghapus pesanan |
| 2 | `PUT` | `/bookings/{id}` | `OrderController@updateOrder` | Sanctum | Detail/mengubah/menghapus pesanan |
| 3 | `DELETE` | `/bookings/{id}` | `OrderController@deleteOrder` | Sanctum | Detail/mengubah/menghapus pesanan |
| 4 | `POST` | `/bookings/{id}/pay` | `OrderController@initiatePayment` | Sanctum | Memilih metode pembayaran |
| 5 | `POST` | `/bookings/{id}/virtual-account` | `OrderController@createVirtualAccount` | Sanctum | Membuat virtual account |
| 6 | `POST` | `/bookings/{id}/qris` | `OrderController@createQris` | Sanctum | Membuat QRIS |
| 7 | `POST` | `/bookings/{id}/upload-proof` | `OrderController@uploadProof` | Sanctum | Mengunggah bukti bayar |
| 8 | `POST` | `/bookings/{id}/confirm-payment` | `OrderController@confirmPayment` | Sanctum | Konfirmasi pembayaran manual |

### 10.2 Detail per endpoint

#### 10.2.1 `GET /bookings/{id}`

- **Controller:** `OrderController@show`
- **Auth:** Sanctum
- **Kegunaan:** Detail/mengubah/menghapus pesanan
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `data`, `message`
- **Pesan error terbaca:** “Pesanan tidak ditemukan atau bukan milik Anda”; “Gagal mengambil detail pesanan”

#### 10.2.2 `PUT /bookings/{id}`

- **Controller:** `OrderController@updateOrder`
- **Auth:** Sanctum
- **Kegunaan:** Detail/mengubah/menghapus pesanan
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `event_date` | `nullable|date|after_or_equal:today` | Tidak |
| `event_time` | `nullable|string|max:255` | Tidak |
| `quantity` | `nullable|integer|min:1` | Tidak |
| `notes` | `nullable|string|max:1000` | Tidak |
| `whatsapp` | `nullable|string|max:20` | Tidak |
| `voucher_code` | `nullable|string|max:50` | Tidak |
| `payment_type` | `nullable|string|in:virtual_account,qris` | Tidak |

- **Response top-level:** `status`, `message`, `data`, `errors`, `error`
- **Pesan error terbaca:** “Pesanan sudah dibayar atau sedang diproses dan tidak dapat diubah lagi”; “Virtual Account BRI belum diaktifkan. Hubungi admin.”; “QRIS BRI belum diaktifkan. Hubungi admin.”; “Stok tidak mencukupi”

#### 10.2.3 `DELETE /bookings/{id}`

- **Controller:** `OrderController@deleteOrder`
- **Auth:** Sanctum
- **Kegunaan:** Detail/mengubah/menghapus pesanan
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `message`, `data`, `error`
- **Pesan error terbaca:** “Pesanan yang sudah dibayar tidak dapat dihapus. Hubungi admin untuk refund.”; “Pesanan yang sedang diproses tidak dapat dihapus”; “Pesanan berhasil dihapus dari riwayat”; “Pesanan tidak ditemukan”

#### 10.2.4 `POST /bookings/{id}/pay`

- **Controller:** `OrderController@initiatePayment`
- **Auth:** Sanctum
- **Kegunaan:** Memilih metode pembayaran
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `message`, `data`, `error`
- **Pesan error terbaca:** “Pesanan sudah dibayar”; “Tidak ada transaksi aktif”; “Gateway pembayaran belum diaktifkan. Hubungi admin.”; “Gagal membuat pembayaran. Silakan coba lagi.”

#### 10.2.5 `POST /bookings/{id}/virtual-account`

- **Controller:** `OrderController@createVirtualAccount`
- **Auth:** Sanctum
- **Kegunaan:** Membuat virtual account
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `message`, `data`, `error`
- **Pesan error terbaca:** “Virtual Account BRI belum diaktifkan. Hubungi admin.”; “Pesanan sudah dibayar”; “Tidak ada transaksi aktif”; “Nomor Virtual Account berhasil dibuat”

#### 10.2.6 `POST /bookings/{id}/qris`

- **Controller:** `OrderController@createQris`
- **Auth:** Sanctum
- **Kegunaan:** Membuat QRIS
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `message`, `data`, `error`
- **Pesan error terbaca:** “QRIS BRI belum diaktifkan. Hubungi admin.”; “Pesanan sudah dibayar”; “Tidak ada transaksi aktif”; “Kode QRIS berhasil dibuat”

#### 10.2.7 `POST /bookings/{id}/upload-proof`

- **Controller:** `OrderController@uploadProof`
- **Auth:** Sanctum
- **Kegunaan:** Mengunggah bukti bayar
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `proof_images` | `sometimes|array|min:1` | Tidak |
| `proof_images.*` | `file|mimes:jpeg,png,jpg,mp4,mov,m4v,webm,3gp,pdf|max:51200` | Tidak |
| `proof_image` | `sometimes|file|mimes:jpeg,png,jpg,mp4,mov,m4v,webm,3gp,pdf|max:51200` | Tidak |

- **Response top-level:** `status`, `message`, `data`, `errors`
- **Pesan error terbaca:** “Pesanan sudah dibayar”; “Bukti pembayaran wajib disertakan”; “Bukti pembayaran terverifikasi, pembayaran berhasil”; “Validasi gagal”

#### 10.2.8 `POST /bookings/{id}/confirm-payment`

- **Controller:** `OrderController@confirmPayment`
- **Auth:** Sanctum
- **Kegunaan:** Konfirmasi pembayaran manual
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/OrderController/OrderController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `payment_method_id` | `nullable|exists:payment_methods,id` | Tidak |
| `payment_method` | `nullable|string|max:255` | Tidak |
| `bank_name` | `nullable|string|max:255` | Tidak |
| `account_number` | `nullable|string|max:100` | Tidak |
| `account_holder` | `nullable|string|max:255` | Tidak |
| `amount` | `nullable|numeric|min:0` | Tidak |
| `card_number` | `nullable|string|max:19` | Tidak |
| `card_holder` | `nullable|string|max:255` | Tidak |
| `card_expiry` | `nullable|string|max:7` | Tidak |
| `card_cvv` | `nullable|string|max:4` | Tidak |

- **Response top-level:** `status`, `message`, `errors`, `data`, `error`
- **Pesan error terbaca:** “Pesanan sudah dibatalkan”; “Pesanan sudah dibayar”; “Data kartu tidak lengkap”; “Kolom wajib diisi”

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

## 11. Data & Database

| Tabel | Peran | Akses | Kolom kunci |
|---|---|---|---|
| `orders` | Pesanan dan statusnya. | Baca/tulis (indikasi) | `id`, `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status`, `booking_date`, `notes` … |
| `transactions` | Transaksi pembayaran/dompet. | Baca/tulis (indikasi) | `id`, `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount`, `payment_gateway`, `payment_method` … |
| `order_timelines` | Riwayat status pesanan. | Baca/tulis (indikasi) | `id`, `order_id`, `status`, `description`, `metadata`, `created_by`, `created_at`, `updated_at` |
| `order_payments` | Pembayaran dan bukti bayar. | Baca/tulis (indikasi) | `id`, `order_id`, `method`, `status`, `amount`, `paid_at`, `transaction_id`, `proof_url`, `created_at`, `updated_at` |
| `payment_methods` | Metode pembayaran yang tersedia. | Baca/tulis (indikasi) | `id`, `name`, `type`, `code`, `account_number`, `account_holder`, `bank_name`, `image_url`, `instructions`, `fee` … |
| `payment_gateways` | Konfigurasi payment gateway. | Baca/tulis (indikasi) | `id`, `name`, `code`, `description`, `config`, `is_active`, `created_at`, `updated_at` |
| `payment_virtual_accounts` | Data virtual account per pesanan. | Baca/tulis (indikasi) | `id`, `user_id`, `order_id`, `transaction_id`, `virtual_account_no`, `virtual_account_name`, `virtual_account_expiry`, `amount`, `status`, `metadata` … |
| `banks` | Bank dan payload QRIS. | Baca/tulis (indikasi) | `id`, `name`, `code`, `type`, `account_number`, `account_holder`, `logo`, `qris_payload`, `qris_image`, `is_active` … |
| `payment_qris` | Data QRIS per pesanan. | Baca/tulis (indikasi) | `id`, `user_id`, `order_id`, `transaction_id`, `qr_content`, `qr_expiry`, `amount`, `status`, `metadata`, `created_at` … |
| `media` | File polymorphic (avatar, dokumen, lampiran). | Baca/tulis (indikasi) | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type`, `disk`, `conversions_disk` … |

Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service untuk memastikan operasi baca/tulis yang sebenarnya.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL langsung dari klien; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.
- Jangan menyimpulkan status pembayaran dari `orders.status`; gunakan data pembayaran/transaksi.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Nomor VA/QR sesuai respons backend.
- Konfirmasi manual mengubah status menjadi pending/paid sesuai validasi.

### 12.2 Validasi server yang terbaca dari controller

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
| `payment_method_id` | `nullable|exists:payment_methods,id` | `/bookings/{id}/confirm-payment` |
| `payment_method` | `nullable|string|max:255` | `/bookings/{id}/confirm-payment` |
| `bank_name` | `nullable|string|max:255` | `/bookings/{id}/confirm-payment` |
| `account_number` | `nullable|string|max:100` | `/bookings/{id}/confirm-payment` |
| `account_holder` | `nullable|string|max:255` | `/bookings/{id}/confirm-payment` |
| `amount` | `nullable|numeric|min:0` | `/bookings/{id}/confirm-payment` |
| `card_number` | `nullable|string|max:19` | `/bookings/{id}/confirm-payment` |
| `card_holder` | `nullable|string|max:255` | `/bookings/{id}/confirm-payment` |
| `card_expiry` | `nullable|string|max:7` | `/bookings/{id}/confirm-payment` |
| `card_cvv` | `nullable|string|max:4` | `/bookings/{id}/confirm-payment` |

### 12.3 Validasi client yang terdeteksi

- Tidak ada form input yang terdeteksi pada layar ini.

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan HTTP client/data source/repository yang sudah ada; jangan membuat client baru di komponen UI.
- Guest tidak boleh memanggil endpoint privat; tampilkan prompt autentikasi tamu.
- Nominal final dan status pembayaran berasal dari backend; jangan menghitung ulang di client.
- Jangan menandai lunas berdasarkan callback UI; lakukan polling/refresh status resmi.
- Tampilkan deadline dari server dan tangani status kedaluwarsa.

## 13. Error Handling

Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).

### 13.1 Kegagalan spesifik layar

- Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.
- Respons tidak sesuai envelope → tampilkan error umum, catat status code.
- 401 → bersihkan token dan arahkan ke Landing/login.
- 403 → tampilkan akses ditolak tanpa logout otomatis.
- 5xx → error server + retry; jangan menampilkan stack trace.
- Kedaluwarsa → tampilkan instruksi muat ulang; jangan minta bayar ke rekening lama.
- Status pending terlalu lama → sediakan refresh manual.
- Gap: `extra` wajib bertipe `PaymentMethodInfo`; route akan error bila null.

## 14. Keamanan & Privasi

- Token hanya di secure storage; jangan di penyimpanan lokal atau log.
- Jangan menampilkan stack trace, query database, atau detail internal pada pengguna.
- Jangan mengirim PII ke analytics/crash report.
- Validasi kepemilikan resource di backend; client tidak boleh menentukan `user_id`.
- Nominal dan status pembayaran tidak boleh dipercaya dari client.
- Jangan menyimpan nomor VA/QR/kartu di log atau clipboard tanpa aksi eksplisit.
- Validasi domain WebView pembayaran; tolak URL di luar gateway resmi.
- Guest tidak boleh mengirim Bearer token kosong atau mengakses resource privat.

## 15. Aksesibilitas

- Semua ikon/tombol non-teks memiliki label semantik.
- Target sentuh minimal 48×48 dp; jangan hanya mengandalkan ikon kecil.
- Kontras teks memenuhi WCAG AA pada mode terang dan gelap.
- Urutan fokus screen reader mengikuti urutan visual.
- Text scale 200% tidak memotong label atau tombol utama.
- Error form diumumkan dan terhubung ke field terkait.
- Hormati reduce-motion; animasi tidak boleh menghalangi interaksi.
- Tombol salin memiliki label yang menyebut apa yang disalin.
- Countdown/deadline diumumkan tanpa mengganggu screen reader.

## 16. Performa & Offline

- Gunakan `CachedNetworkImage`/cache yang ada untuk gambar jaringan.
- Hindari pekerjaan berat di `build()`; pindahkan parsing/format ke provider/util.
- Dispose controller, timer, dan subscription di `dispose`.
- Pull-to-refresh mereset halaman dan tidak menumpuk request.
- Hentikan polling/timer saat app background; mulai lagi saat resume.
- Tidak ada cache lokal terdeteksi; jangan menambah cache tanpa kebijakan kedaluwarsa.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_payment_method_detail` | Layar dibuka | screen, route, auth | Tidak |
| `payment_method_detail_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `payment_method_detail_success` | Aksi utama berhasil | duration_ms | Tidak |
| `payment_method_detail_failure` | Request/aksi gagal | error_code, status | Tidak |
| `payment_method_detail_copy` | Nomor/QR disalin | method | Tidak |
| `payment_method_detail_expired` | Pembayaran kedaluwarsa | method | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Nomor VA/QR sesuai respons backend.
- [ ] Konfirmasi manual mengubah status menjadi pending/paid sesuai validasi.
- [ ] Tombol utama menjalankan aksi: Saya Sudah Bayar.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Dari `PaymentInstructionScreen` dengan `extra` `PaymentMethodInfo`.
- [ ] Route/parameter sesuai: `/payment-method/:orderId`.
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
| TC-01 | Widget | Happy path | Buka layar melalui: Dari `PaymentInstructionScreen` dengan `extra` `PaymentMethodInfo`. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /payment-method/:orderId dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
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
| TC-13 | Manual | Kedaluwarsa | Biarkan deadline lewat | Status kedaluwarsa + instruksi muat ulang. |
| TC-14 | Manual | Polling status | Simulasikan status berubah menjadi lunas | UI memperbarui status dari backend, bukan asumsi lokal. |
| TC-15 | Manual | Regresi fitur terkait | Buka layar terkait setelah aksi | Navigasi/state tidak rusak dan data konsisten. |

**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, dan golden test untuk layar dengan layout kompleks.

## 20. Gap, Risiko & Dependensi

### 20.1 Gap terdokumentasi

- `extra` wajib bertipe `PaymentMethodInfo`; route akan error bila null.

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| `extra` wajib bertipe `PaymentMethodInfo`; route akan error bila null. | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |
| Status pembayaran tidak sinkron | Sedang | Tinggi | Polling/refresh status resmi; jangan simpulkan dari UI. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | GET /bookings/{id} | OrderController@show |
| Endpoint | PUT /bookings/{id} | OrderController@updateOrder |
| Endpoint | DELETE /bookings/{id} | OrderController@deleteOrder |
| Endpoint | POST /bookings/{id}/pay | OrderController@initiatePayment |
| Endpoint | POST /bookings/{id}/virtual-account | OrderController@createVirtualAccount |
| Endpoint | POST /bookings/{id}/qris | OrderController@createQris |
| Endpoint | POST /bookings/{id}/upload-proof | OrderController@uploadProof |
| Endpoint | POST /bookings/{id}/confirm-payment | OrderController@confirmPayment |
| Database | orders | Jangan query langsung dari klien. |
| Database | transactions | Jangan query langsung dari klien. |
| Database | order_timelines | Jangan query langsung dari klien. |
| Database | order_payments | Jangan query langsung dari klien. |
| Database | payment_methods | Jangan query langsung dari klien. |
| Database | payment_gateways | Jangan query langsung dari klien. |
| Database | payment_virtual_accounts | Jangan query langsung dari klien. |
| Database | banks | Jangan query langsung dari klien. |
| Database | payment_qris | Jangan query langsung dari klien. |
| Database | media | Jangan query langsung dari klien. |
| State/dependency | authProvider | Komponen state/dependency terkait |
| State/dependency | paymentProvider | Komponen state/dependency terkait |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | Komponen/Referensi | Catatan |
|---|---|---|
| Layar/UI | `PaymentMethodDetailScreen` | Implementasi referensi aplikasi saat ini |
| State/dependency | `authProvider` | Komponen state/dependency terkait |
| State/dependency | `paymentProvider` | Komponen state/dependency terkait |
| Komponen UI bersama | `AppBreadcrumbs` | Komponen UI reusable |
| Komponen UI bersama | `AppButton` | Komponen UI reusable |
| Komponen UI bersama | `AppSnackbar` | Komponen UI reusable |
| Komponen UI bersama | `CreditCardForm` | Komponen UI reusable |
| Komponen UI bersama | `GuestAuthPrompt` | Komponen UI reusable |
| Test | Sesuai platform target | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/payment/payment-method-detail.md` | PRD ini |
| Prompt | `.skills/screens/payment/payment-method-detail/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_startPaymentStatusPolling`, `_loadOrder`, `_paymentAmount`, `_confirm`, `_createVirtualAccount`, `_createQris`, `_openApp`, `_payWithGateway`, `_buildHeader`, `_buildQrisContent`, `_buildQrisPlaceholder`, `_buildQrisImage`, `_buildEWalletContent`, `_buildCreditCardContent`, `_buildGenericContent`, `_buildAmountCard`, `_buildSteps`, `_buildInfoRow`, `_buildVirtualAccountPayung`, `_buildQrisCard`.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/payment/payment-method-detail/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Implementasi aplikasi, route Laravel, skema PostgreSQL |
