# Database PostgreSQL

## 1. Ringkasan

| Item | Nilai |
|---|---|
| Engine | PostgreSQL 18.2 |
| Database | `wedding_florals_decorations` |
| Jumlah tabel | 83 |
| Foreign key terdeteksi | 74 |
| Koneksi backend | `DB_CONNECTION=pgsql`, `127.0.0.1:5432` |
| ORM | Eloquent |
| Migration | `Mobile-And-Backend/database/migrations` |
| Sumber verifikasi | Query langsung `information_schema` pada 6 November 2026 |

## 2. Pengelompokan tabel

### 2.1 Identitas dan akses

| Tabel | Fungsi | Kolom kunci |
|---|---|---|
| `users` | Akun storefront/mobile | `id`, `full_name`, `email`, `username`, `password`, `whatsapp`, `ktp_number`, `kyc_status`, `two_factor_*`, `app_lock_*` |
| `admins` | Staf panel admin | `id`, `email`, `password`, `user_id` → `users.id` |
| `personal_access_tokens` | Token Sanctum | `tokenable_type`, `tokenable_id`, `token` |
| `password_reset_tokens` | Reset password | `email`, `token` |
| `backup_codes` | Kode pemulihan 2FA | `user_id`, `code`, `used` |
| `device_tokens` | Token perangkat/FCM | `user_id`, `token`, `type` |
| `user_fcm_devices` | Token FCM (tabel alternatif) | `user_id`, token |
| `user_sessions` | Sesi login | `user_id`, `device_name`, `ip_address`, `is_current`, `last_active_at` |
| `trusted_devices` | Perangkat tepercaya | `user_id`, `device_fingerprint`, `denied_at` |
| `trust_devices` | Tabel perangkat lama | `user_id`, `device_signature` |
| `security_emails` | Riwayat email keamanan | `user_id`, `subject`, `type`, `sent_at` |
| `security_events` | Audit event keamanan | `user_id`, `event`, `ip_address`, `metadata` |
| `whatsapp_otps` | OTP WhatsApp | `whatsapp`, `otp_code`, `expires_at` |

### 2.2 Katalog

| Tabel | Fungsi | Kolom kunci |
|---|---|---|
| `categories` | Kategori dekorasi | `id`, `name`, `slug`, `type`, `name_translations` |
| `catalogs` | Entitas katalog utama | `id`, `category_id`, `vendor_id`, `name`, `price`, `discount_price`, `stock`, `is_active`, `is_featured`, `theme`, `color`, `min_capacity`, `max_capacity` |
| `packages` | Tier/varian dalam katalog | `id`, `catalog_id`, `category_id`, `vendor_id`, `name`, `price`, `discount_price`, `stock`, `sort_order` |
| `vendors` | Vendor dekorasi | `id`, `user_id`, `store_name`, `is_active`, `is_partner` |
| `media` | Polymorphic media | `model_type`, `model_id`, `collection_name`, `file_name`, `disk` |
| `discounts` | Diskon | `id`, `type`, `value`, `start_date`, `end_date`, `min_purchase` |
| `favorites` | Favorit user | `user_id`, `catalog_id`, `package_id` |
| `hero_banners` | Banner home | `title`, `image_url`, `link_url`, `is_active`, `position` |
| `promotions` | Promo | `title`, `discount_percent`, `code`, `valid_from`, `valid_until` |

Relasi penting:

```text
categories 1─* catalogs
categories 1─* packages
catalogs   1─* packages
vendors    1─* catalogs
vendors    1─* packages
catalogs   1─* favorites
packages   1─* favorites
users      1─* favorites
```

### 2.3 Keranjang dan pesanan

| Tabel | Fungsi | Kolom kunci |
|---|---|---|
| `carts` | Item keranjang | `user_id`, `catalog_id`, `package_id`, `quantity`, `meta` |
| `orders` | Pesanan | `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status`, `booking_date`, `booking_time`, `quantity` |
| `order_payments` | Pembayaran per order | `order_id`, `method`, `status`, `amount`, `paid_at`, `transaction_id`, `proof_url` |
| `order_timelines` | Riwayat status order | `order_id`, `status`, `description`, `metadata`, `created_by` |
| `transactions` | Transaksi pembayaran | `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount`, `payment_gateway`, `payment_method`, `payment_url`, `status`, `payment_method_id` |
| `payment_virtual_accounts` | VA | `user_id`, `order_id`, `transaction_id`, `virtual_account_no`, `amount`, `status`, `metadata` |
| `payment_qris` | QRIS | `user_id`, `order_id`, `transaction_id`, `qr_content`, `qr_expiry`, `amount`, `status` |
| `payment_methods` | Master metode | `name`, `type`, `code`, `account_number`, `fee`, `is_active` |
| `payment_gateways` | Master gateway | `name`, `code`, `config`, `is_active` |
| `banks` | Master bank | `name`, `code`, `account_number`, `qris_payload` |
| `refund_requests` | Permintaan refund | `order_id`, `user_id`, `reason`, `amount`, `status` |

Relasi penting:

```text
users       1─* orders
catalogs    1─* orders
packages    1─* orders
orders      1─* order_payments
orders      1─* order_timelines
orders      1─* transactions
orders      1─* payment_virtual_accounts
orders      1─* payment_qris
transactions 1─* payment_virtual_accounts
transactions 1─* payment_qris
payment_methods 1─* transactions
```

### 2.4 Ulasan

| Tabel | Fungsi | Kolom kunci |
|---|---|---|
| `reviews` | Ulasan katalog/tier | `user_id`, `catalog_id`, `package_id`, `order_id`, `rating`, `comment`, `photos`, `helpful_count`, `is_anonymous` |
| `review_replies` | Balasan ulasan | `review_id`, `user_id`, `comment` |
| `review_votes` | Vote helpful | `review_id`, `user_id` |
| `review_reports` | Laporan ulasan | `review_id`, `reporter_id`, `reason`, `status` |

### 2.5 Chat dan notifikasi

| Tabel | Fungsi | Kolom kunci |
|---|---|---|
| `fm_inboxes` | Percakapan | `id`, `title`, `user_ids` (JSON), `meta` |
| `fm_messages` | Pesan | `id`, `inbox_id`, `message`, `user_id`, `read_by`, `read_at`, `meta` |
| `chat_calls` | Sesi panggilan | `token`, `inbox_id`, `caller_user_id`, `callee_user_id`, `status`, `offer`, `answer`, `ice_candidates` |
| `notifications` | Notifikasi Laravel | `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at` |

Catatan integritas:

- `fm_messages.inbox_id` **tidak memiliki foreign key** ke `fm_inboxes`.
- `fm_inboxes.user_ids` adalah JSON, bukan relasi pivot.
- `chat_calls` memiliki FK ke `fm_inboxes` dan `users`.

### 2.6 KYC dan profil

| Tabel | Fungsi | Kolom kunci |
|---|---|---|
| `identity_documents` | Dokumen identitas | `user_id`, `document_type`, `document_number`, `photo_path`, `ai_*` |
| `user_addresses` | Alamat | `user_id`, `name`, `phone`, `address`, `city`, `province`, `postal_code`, `is_default` |
| `user_languages` | Bahasa | `model_id`, `model_type`, `lang` |
| `reference_options` | Opsi dropdown | `type`, `key`, `label`, `sort_order`, `is_active` |

### 2.7 Voucher dan wallet

| Tabel | Fungsi | Kolom kunci |
|---|---|---|
| `vouchers` | Voucher | `code`, `discount_id`, `is_global`, `max_uses`, `uses_count`, `expires_at` |
| `user_vouchers` | Voucher user | `user_id`, `voucher_id`, `claimed_at`, `used_at`, `order_id` |
| `histories` | Riwayat wallet/transaksi | `user_id`, `type`, `transaction_id`, `reference_number`, `amount`, `status` |

### 2.8 Konten legal dan bantuan

| Tabel | Fungsi |
|---|---|
| `terms_of_service` | Syarat layanan |
| `privacy_policies` | Kebijakan privasi |
| `wedding_decoration_policies` | Kebijakan dekorasi |
| `helps` | FAQ dan kontak bantuan |
| `legal_pages` | Halaman legal generik berbasis slug |

### 2.9 Pencarian dan CBIR

| Tabel | Fungsi |
|---|---|
| `search_logs` | Log pencarian teks |
| `cbir_searches` | Sesi pencarian gambar |
| `cbir_search_results` | Hasil CBIR per item |
| `cbir_feedback` | Feedback relevansi hasil |

### 2.10 Wilayah dan sistem

| Tabel | Fungsi |
|---|---|
| `indonesia_provinces`, `indonesia_cities`, `indonesia_districts`, `indonesia_villages` | Hierarki wilayah Indonesia |
| `sessions`, `cache`, `cache_locks`, `jobs`, `job_batches`, `failed_jobs` | Infrastruktur Laravel |
| `migrations`, `permissions`, `roles`, `model_has_*`, `role_has_permissions` | Framework/akses |
| `activity_log` | Audit aktivitas |
| `imports`, `exports`, `failed_import_rows` | Import/export |
| `translations` | Terjemahan |
| `developer_studio_endpoints` | Metadata developer |
| `breezy_sessions` | Sesi panel |

## 3. Aturan data

1. Semua tabel transaksi memakai `id` bigint auto-increment (kecuali tabel framework tertentu).
2. Timestamp `created_at`/`updated_at` dipakai konsisten.
3. Soft delete (`deleted_at`) ada pada `users`? Tidak semua; cek model sebelum mengandalkan `withTrashed`.
4. `orders.status` dan `orders.payment_status` adalah string; nilainya harus divalidasi enum aplikasi.
5. `catalogs.stock` dan `packages.stock` dapat null/0; 0 berarti habis.
6. `reviews.rating` 1–5.
7. `vouchers.uses_count` harus diupdate dalam transaksi yang sama dengan klaim/pemakaian.
8. `transactions.status` dan `payment_*` harus konsisten dengan `orders.payment_status`.
9. Nominal memakai tipe numerik; jangan memakai float untuk uang di kode baru jika tersedia decimal.

## 4. Index dan performa

Index yang perlu dipastikan (verifikasi via `pg_indexes` sebelum optimasi):

- `users.email`, `users.username`
- `orders.user_id`, `orders.order_number`, `orders.status`
- `transactions.order_id`, `transactions.reference_number`
- `carts.user_id`
- `favorites.user_id`
- `reviews.catalog_id`, `reviews.package_id`
- `notifications.notifiable_type`, `notifiable_id`, `read_at`
- `fm_messages.inbox_id`, `created_at`
- `search_logs.user_id`, `created_at`

Jangan menambah index tanpa mengukur query lambat.

## 5. Migrasi dan seeding

- Perubahan skema **wajib** melalui migration Laravel.
- Jangan mengubah database produksi manual.
- Seeder harus idempoten.
- Untuk data wilayah, gunakan seeder khusus dan jangan menimpa kode yang sudah ada.
- Backup sebelum migrasi destruktif.

## 6. Query larangan

- Jangan memakai `SELECT *` di endpoint baru tanpa alasan.
- Jangan memanggil `DB::table` dari controller tanpa validasi/parameter binding.
- Jangan menyimpan token plaintext.
- Jangan menyimpan password tanpa `Hash`.
- Jangan mempercayai `user_id` dari body; gunakan `$request->user()->id`.

## 7. Tabel kanonik per fitur

| Fitur | Tabel utama |
|---|---|
| Home | `categories`, `packages`, `vouchers`, `orders`, `notifications`, `fm_messages`, `fm_inboxes` |
| Katalog | `catalogs`, `packages`, `categories`, `media`, `reviews`, `favorites` |
| Cart | `carts`, `catalogs`, `packages` |
| Checkout | `orders`, `order_payments`, `order_timelines`, `transactions`, `carts`, `vouchers`, `user_vouchers` |
| Payment | `transactions`, `payment_virtual_accounts`, `payment_qris`, `payment_methods`, `banks` |
| Review | `reviews`, `review_replies`, `review_votes` |
| Chat | `fm_inboxes`, `fm_messages`, `chat_calls` |
| Notification | `notifications`, `device_tokens` |
| Profile/KYC | `users`, `identity_documents`, `media` |
| Security | `users`, `user_sessions`, `trusted_devices`, `security_emails`, `security_events`, `backup_codes` |
| Voucher | `vouchers`, `user_vouchers`, `discounts` |
| History/Wallet | `histories`, `transactions`, `orders` |
| Legal | `terms_of_service`, `privacy_policies`, `wedding_decoration_policies`, `helps`, `legal_pages` |
| Search/CBIR | `search_logs`, `cbir_searches`, `cbir_search_results`, `cbir_feedback` |
