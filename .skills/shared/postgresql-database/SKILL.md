---
name: postgresql-database
description: Pola bekerja dengan PostgreSQL wedding_florals_decorations (migration, relasi, index, JSON, soft delete, verifikasi skema, dan query aman).
---

# Skill: PostgreSQL Database

Database: `wedding_florals_decorations` (PostgreSQL 18.2), diakses Laravel lewat `DB_CONNECTION=pgsql`.

## 1. Verifikasi sebelum menulis kode

Jangan menebak kolom. Jalankan:

```powershell
psql -U postgres -d wedding_florals_decorations -c "\d+ orders"
psql -U postgres -d wedding_florals_decorations -c "\d+ users"
psql -U postgres -d wedding_florals_decorations -c "\df"
```

Atau lewat Laravel:

```powershell
php artisan db:show
php artisan db:table orders
```

## 2. Tabel inti

| Domain | Tabel |
|---|---|
| Akun | `users`, `identity_documents`, `user_addresses`, `user_sessions`, `trusted_devices`, `backup_codes` |
| Katalog | `categories`, `catalogs`, `packages`, `media` |
| Transaksi | `carts`, `orders`, `order_timelines`, `order_payments`, `transactions`, `payment_qris`, `payment_virtual_accounts`, `vouchers`, `user_vouchers` |
| Interaksi | `favorites`, `reviews`, `review_replies`, `review_votes`, `reports`, `notifications` |
| Chat | `fm_inboxes`, `fm_messages`, `chat_calls` |
| Legal | `legal_pages`, `privacy_policies`, `terms_of_service`, `wedding_decoration_policies`, `helps` |
| Pencarian | `search_logs`, `cbir_searches`, `cbir_search_results`, `cbir_feedback` |

## 3. Konvensi yang terlihat di skema

- Primary key umumnya `bigint` auto-increment; beberapa resource memakai UUID (cek `\d+`).
- Timestamp `created_at`/`updated_at` hampir di semua tabel.
- Soft delete (`deleted_at`) ada di `users`, `orders`, `fm_inboxes`, `fm_messages`, `histories`.
- Uang disimpan sebagai numerik; jangan memakai `float` untuk total.
- Status disimpan sebagai string/enum; validasi di aplikasi dan database.
- Relasi polimorfik memakai `model_type`/`model_id` (contoh `media`).
- JSON dipakai di `fm_inboxes.user_ids`, `orders` metadata, `reports.attachments`, `users.custom_fields`.

## 4. Gap integritas yang harus diketahui

1. `fm_messages.inbox_id` **tidak memiliki FK** ke `fm_inboxes.id`. Jangan mengandalkan cascade.
2. `fm_inboxes.user_ids` adalah JSON, bukan pivot. Query anggota memakai operator JSON.
3. Tidak ada kolom alamat di `orders`; alamat hanya di `user_addresses`.
4. `users` sangat lebar (104 kolom). Jangan `SELECT *` di endpoint publik.
5. `trusted_devices` dan `trust_devices` adalah dua tabel berbeda; cek pemakaiannya.

## 5. Menambah migration

```php
Schema::table('fm_messages', function (Blueprint $table) {
    $table->foreignId('inbox_id')
        ->nullable()
        ->after('id')
        ->constrained('fm_inboxes')
        ->nullOnDelete();
});
```

Aturan:

- Selalu sediakan `down()` yang benar.
- Untuk tabel besar, tambahkan index sebelum FK.
- Gunakan `nullable()` bila data lama memungkinkan.
- Jangan mengubah tipe kolom yang sudah dipakai tanpa backfill.
- Untuk data sensitif, pertimbangkan enkripsi di aplikasi, bukan kolom plaintext.

## 6. Query aman

```php
// Baik: batasi kolom dan kepemilikan
Order::query()
    ->where('user_id', $request->user()->id)
    ->select(['id', 'order_number', 'status', 'payment_status', 'total_price', 'created_at'])
    ->latest()
    ->paginate(10);
```

Hindari:

```php
Order::all();                       // bisa bocor & lambat
DB::raw("... $request->input()");   // SQL injection
whereRaw("user_ids LIKE '%$id%'");  // salah untuk JSON
```

Untuk JSON:

```php
Inbox::whereJsonContains('user_ids', $userId)->get();
```

## 7. Index yang disarankan

- `orders(user_id, created_at)`
- `fm_messages(inbox_id, created_at)`
- `fm_inboxes(user_ids)` dengan GIN bila query JSON sering
- `reviews(catalog_id, created_at)`
- `notifications(notifiable_type, notifiable_id, read_at)`
- `user_sessions(user_id, last_active_at)`

## 8. Backup & migrasi

```powershell
pg_dump -U postgres -d wedding_florals_decorations -Fc -f backup.dump
pg_restore -U postgres -d wedding_florals_decorations --clean backup.dump
```

Jangan menjalankan `migrate:fresh` di database berisi data pengguna.

## 9. Checklist

- [ ] Kolom dan tipe diverifikasi dengan `\d+`.
- [ ] FK/index untuk relasi baru.
- [ ] `down()` dapat membalik perubahan.
- [ ] Tidak ada `SELECT *` di endpoint publik.
- [ ] Query difilter kepemilikan pengguna.
- [ ] Data lama punya strategi backfill.
- [ ] Dokumentasi `.docs/04-database/DATABASE.md` diperbarui.
