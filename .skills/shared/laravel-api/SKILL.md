---
name: laravel-api
description: Pola menambah dan mengubah endpoint Laravel 12 untuk aplikasi mobile (route, controller, validasi, Sanctum, envelope, transaksi, pagination, unggah file, dan test).
---

# Skill: Laravel API

Gunakan saat menambah endpoint mobile atau memperbaiki controller di `Mobile-And-Backend`.

## 1. Lokasi file

```text
routes/api/api.php                     # registrasi grup
routes/api/user/<Controller>/...       # route per domain (jika dipisah)
app/Http/Controllers/Api/User/<Domain>/<Controller>.php
app/Http/Requests/...                  # FormRequest bila ada
app/Models/...                         # Eloquent
app/Enums/...                          # enum status
database/migrations/...                # perubahan skema
```

## 2. Menambah route

1. Tambahkan route di file grup yang sesuai, bukan di `web.php`.
2. Gunakan prefix `api` (sudah otomatis).
3. Endpoint privat wajib `auth:sanctum`.
4. Endpoint guest memakai throttle `guest-chat`.
5. Gunakan nama parameter yang konsisten: `{id}`, `{order}`, `{catalog}`, `{deviceId}`.
6. Verifikasi:

```powershell
php artisan route:list --path=api
php artisan route:list --path=api --json
```

## 3. Controller

- Gunakan `$request->user()` untuk kepemilikan data; jangan menerima `user_id` dari body.
- Validasi dengan `$request->validate([...])` atau FormRequest.
- Bungkus operasi multi-tabel dengan `DB::transaction`.
- Gunakan eager loading (`with`) untuk menghindari N+1.
- Pagination memakai `paginate($request->get('per_page', 10))`.
- Gunakan `app()->getLocale()` untuk konten terjemahan.
- Jangan menelan exception tanpa log; gunakan `Log::error` dengan konteks yang aman.
- Kembalikan envelope konsisten:

```json
{"status":"success","message":"...","data":{}}
```

Untuk error:

```json
{"status":"error","message":"...","errors":{"field":["..."]}}
```

## 4. Validasi yang sering dipakai

```php
$validated = $request->validate([
    'catalog_id' => ['required', 'uuid', 'exists:catalogs,id'],
    'package_id' => ['required', 'uuid', 'exists:packages,id'],
    'quantity' => ['required', 'integer', 'min:1', 'max:99'],
    'event_date' => ['required', 'date', 'after_or_equal:today'],
    'voucher_code' => ['nullable', 'string', 'max:50'],
]);
```

Catatan: sesuaikan tipe ID dengan skema aktual (UUID vs bigint). Jangan menebak.

## 5. Status & enum

Ikuti enum yang sudah ada:

- `orders.status`: `pending`, `confirmed`, `preparing`, `event_day`, `completed`, `cancelled`.
- `orders.payment_status`: `unpaid`, `pending`, `paid`, `failed`, `refunded`, `cancelled`.
- `reports.status`: sesuai enum report.
- `payment_qris.status`/`payment_virtual_accounts.status`: sesuai enum payment.

Jangan menambah string status baru tanpa migration/enum dan kesepakatan client.

## 6. Unggah file

- Validasi `image|mimes:jpg,jpeg,png|max:10240` untuk foto.
- Simpan lewat Storage disk yang dikonfigurasi; kembalikan URL publik.
- Gunakan nama field yang cocok dengan client.
- Jangan menyimpan file di `public/` langsung.
- Hapus file lama saat replace bila tidak dipakai lagi.

## 7. Keamanan

- Jangan mengembalikan `password`, token, `two_factor_secret`, atau path internal.
- Gunakan policy/gate untuk resource milik pengguna.
- Rate limit endpoint OTP, login, chat guest, dan upload.
- Sanitasi konten legal/HTML sebelum render.
- Untuk aksi destruktif, gunakan POST/DELETE + konfirmasi, bukan GET.

## 8. Test (Pest)

Minimal:

```php
it('lists orders for the authenticated user', function () {
    $user = User::factory()->create();
    Order::factory()->for($user)->count(3)->create();

    $this->actingAs($user)
        ->getJson('/api/bookings')
        ->assertOk()
        ->assertJsonCount(3, 'data');
});

it('rejects checkout without package_id', function () {
    $this->actingAs(User::factory()->create())
        ->postJson('/api/bookings', [])
        ->assertUnprocessable()
        ->assertJsonValidationErrors('package_id');
});
```

Uji juga: 401 tanpa token, 403 resource milik orang lain, 422 validasi, dan 404 resource tidak ada.

## 9. Checklist

- [ ] Route terdaftar dan metode benar.
- [ ] Middleware auth/throttle benar.
- [ ] Validasi lengkap dan pesan jelas.
- [ ] Kepemilikan data dicek.
- [ ] Transaksi untuk operasi multi-tabel.
- [ ] Envelope konsisten.
- [ ] Tidak ada data sensitif di respons.
- [ ] Test happy path + error path.
- [ ] Dokumentasi PRD/endpoint map diperbarui.
