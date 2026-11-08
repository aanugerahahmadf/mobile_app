---
name: testing
description: Strategi pengujian mobile Flutter, API Laravel, dan database PostgreSQL untuk aplikasi ini, termasuk matriks manual dan data uji.
---

# Skill: Testing

## 1. Piramida pengujian

```text
Banyak  : unit test (model, mapper, provider)
Sedang  : widget test (state UI)
Sedikit : integration/E2E (alur kritis)
Tambahan: Pest backend + query database
```

## 2. Flutter

### Unit test

Uji:

- parsing model dari JSON (field null/tipe berubah),
- mapper harga/tanggal/status,
- logika provider (loading → data → error),
- validasi form.

```dart
test('parses order status and payment status separately', () {
  final order = OrderModel.fromJson({
    'id': '1',
    'status': 'confirmed',
    'payment_status': 'unpaid',
  });
  expect(order.status, 'confirmed');
  expect(order.paymentStatus, 'unpaid');
});
```

### Widget test

Uji:

- loading skeleton,
- empty state,
- error + retry,
- guest prompt,
- tombol disabled saat submit.

### Integration test

Alur minimum:

1. Landing → login/guest → Home.
2. Katalog → detail → pilih tier → keranjang.
3. Keranjang → checkout → pesanan dibuat.
4. Pesanan → pembayaran → status.
5. Chat → kirim pesan → panggilan.
6. Profil → edit → verifikasi dokumen.

## 3. Laravel (Pest)

Setiap endpoint baru minimal punya:

- happy path dengan user terautentikasi,
- 401 tanpa token,
- 403 resource milik pengguna lain,
- 422 validasi,
- 404 resource tidak ada.

```php
it('forbids cancelling another user order', function () {
    $order = Order::factory()->create();
    $this->actingAs(User::factory()->create())
        ->postJson("/api/bookings/{$order->id}/cancel")
        ->assertForbidden();
});
```

Gunakan `RefreshDatabase` dan factory. Jangan memakai database produksi.

## 4. Database

- Verifikasi migration `up` dan `down`.
- Uji constraint/FK dengan insert invalid.
- Cek index untuk query lambat dengan `EXPLAIN ANALYZE`.
- Pastikan soft delete tidak menghilangkan data yang masih direferensikan.

## 5. Matriks manual wajib

| Skenario | Hasil |
|---|---|
| Token kedaluwarsa | Redirect Landing, token bersih |
| Offline saat buka layar | Error + retry, tidak crash |
| Rotasi layar | Layout tidak overflow |
| Font besar | Teks tidak terpotong |
| Guest membuka fitur privat | GuestAuthPrompt, bukan 401 mentah |
| Double tap submit | Hanya satu request |
| Upload file > batas | Pesan 413/422 |
| Stok habis | Tombol beli nonaktif |
| Voucher invalid | Pesan dari server |
| Chat reconnect | Pesan tidak hilang/duplikat |

## 6. Data uji

- Gunakan akun dengan peran berbeda (guest, user biasa, user KYC verified).
- Siapkan katalog dengan minimal satu tier dan satu item stok 0.
- Siapkan pesanan untuk setiap status.
- Siapkan voucher aktif, kedaluwarsa, dan habis.
- Siapkan percakapan login dan guest.

## 7. Perintah

```powershell
flutter analyze
flutter test
flutter test test/widgets/<layar>_test.dart

cd ..\Mobile-And-Backend
php artisan test
php artisan test --filter=OrderTest
```

## 8. Checklist

- [ ] Happy path dan minimal satu error path per layar.
- [ ] 401/403/422 diuji.
- [ ] Tidak ada test yang bergantung pada urutan eksekusi.
- [ ] Tidak ada secret/data produksi di fixture.
- [ ] Test dijalankan sebelum PR.
- [ ] Gap yang ditemukan dicatat di `KNOWN-GAPS.md`.
