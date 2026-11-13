---
name: order-detail
description: Implementasi layar Detail Pesanan (OrderDetailScreen) pada fitur Pesanan; route /order/:id, 7 endpoint, 6 tabel, state, guardrail, dan definition of done.
---

# Skill: Detail Pesanan

> **Tipe:** Pesanan / checkout · **Route:** `/order/:id` · **Akses:** Sanctum · **State:** State management terpusat + state lokal

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Detail Pesanan di fitur Pesanan.
Referensi implementasi saat ini: OrderDetailScreen. Route: /order/:id (Sanctum).
Tujuan: Menampilkan status pesanan, item, pembayaran, timeline, invoice, dan aksi batal/bayar.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/order/order-detail.md
- State management: State management terpusat + state lokal; pola data: request-response.
- Endpoint: GET /bookings/{id}; PUT /bookings/{id}; DELETE /bookings/{id}; POST /bookings/{id}/cancel; POST /bookings/{id}/pay; GET /bookings/{id}/invoice …
- Tabel: orders, transactions, order_timelines, order_payments, payment_methods, payment_gateways.
- Parameter/extra: Path parameter `id` adalah ID pesanan.

Wajib dipertahankan:
- Status pembayaran dan status pesanan ditampilkan terpisah.
- Pembatalan hanya muncul pada status yang diizinkan.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: lihat pesanan bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Detail Pesanan** (referensi implementasi: `OrderDetailScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `OrderDetailScreen` |
| Route | `/order/:id` |
| Akses | Sanctum |
| Parameter | Path parameter `id` adalah ID pesanan. |
| Masuk dari | Dari `OrderHistoryScreen`, notifikasi, atau setelah checkout. |
| State/dependency | `authProvider`, `orderProvider`, `chatProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 7 |
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
| PRD | `.docs/screens/order/order-detail.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `OrderDetailScreen` | UI, state, interaksi |
| State/dependency | `authProvider` | State/aksi domain |
| State/dependency | `orderProvider` | State/aksi domain |
| State/dependency | `chatProvider` | State/aksi domain |
| Test | Test otomatis (platform target) di area Pesanan/` | Test happy path + error path |
| PRD | `.docs/screens/order/order-detail.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/order/order-detail/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan status pesanan, item, pembayaran, timeline, invoice, dan aksi batal/bayar.

1. Muat detail pesanan.
2. Tampilkan timeline dan status.
3. Buka pembayaran atau invoice.
4. Batalkan pesanan bila diizinkan.

### 5.2 Elemen UI wajib

- Header status
- Item pesanan
- Timeline
- Ringkasan pembayaran
- Tombol bayar/batal/invoice

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
| `tidak ditemukan` | Tampilkan halaman not found dengan tombol kembali. | Ikuti aksi pemulihan pada pesan |
| `dibatalkan` | Tampilkan status dibatalkan dan aksi lanjutan yang relevan. | Ikuti aksi pemulihan pada pesan |
| `pembayaran gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `invoice gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Status pembayaran dan status pesanan ditampilkan terpisah.
- Pembatalan hanya muncul pada status yang diizinkan.
- Stok, harga, dan ketersediaan paket divalidasi backend saat membuat pesanan.
- Cegah submit ganda; satu tap menghasilkan satu pesanan.
- Jangan mengirim total/harga final dari client sebagai sumber kebenaran.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/order/order-detail.md` dan skill ini sampai selesai.
2. Tinjau implementasi referensi `OrderDetailScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/order/:id`.
4. Verifikasi endpoint ke backend: GET /bookings/{id}; PUT /bookings/{id}; DELETE /bookings/{id}; POST /bookings/{id}/cancel; POST /bookings/{id}/pay; GET /bookings/{id}/invoice …
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `tidak ditemukan`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

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
| `GET` | `/bookings/{id}` | `OrderController@show` | Sanctum | Detail/mengubah/menghapus pesanan |
| `PUT` | `/bookings/{id}` | `OrderController@updateOrder` | Sanctum | Detail/mengubah/menghapus pesanan |
| `DELETE` | `/bookings/{id}` | `OrderController@deleteOrder` | Sanctum | Detail/mengubah/menghapus pesanan |
| `POST` | `/bookings/{id}/cancel` | `OrderController@cancelOrder` | Sanctum | Membatalkan pesanan |
| `POST` | `/bookings/{id}/pay` | `OrderController@initiatePayment` | Sanctum | Memilih metode pembayaran |
| `GET` | `/bookings/{id}/invoice` | `OrderController@downloadInvoice` | Sanctum | Mengunduh invoice |
| `POST` | `/bookings/{id}/invoice/email` | `OrderController@sendInvoiceEmail` | Sanctum | Mengirim invoice ke email |

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
| `orders` | `id`, `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status` … |
| `transactions` | `id`, `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount` … |
| `order_timelines` | `id`, `order_id`, `status`, `description`, `metadata`, `created_by`, `created_at`, `updated_at` |
| `order_payments` | `id`, `order_id`, `method`, `status`, `amount`, `paid_at`, `transaction_id`, `proof_url` … |
| `payment_methods` | `id`, `name`, `type`, `code`, `account_number`, `account_holder`, `bank_name`, `image_url` … |
| `payment_gateways` | `id`, `name`, `code`, `description`, `config`, `is_active`, `created_at`, `updated_at` |

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
| `tidak ditemukan` | Ya |
| `dibatalkan` | Ya |
| `pembayaran gagal` | Ya |
| `invoice gagal` | Ya |

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
- Pastikan komponen/layar referensi `OrderDetailScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target

# verifikasi backend (opsional)
- Cek route API: /bookings/

# verifikasi database (opsional)
- Cek tabel: orders
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Jangan menyimpulkan pembayaran dari `orders.status`.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
