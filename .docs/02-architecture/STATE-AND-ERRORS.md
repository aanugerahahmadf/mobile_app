# State Management, Error, dan Guest Mode

## 1. Prinsip state

1. **Single source of truth per domain.** Contoh: `cartProvider` untuk keranjang, `authProvider` untuk sesi, `notificationListProvider` untuk notifikasi.
2. **UI tidak menghitung ulang aturan bisnis.** Harga, stok, status, dan diskon berasal dari respons.
3. **State eksplisit.** Minimal: `initial`, `loading`, `loaded`, `empty`, `error`, `unauthorized`.
4. **Optimistic update hanya untuk aksi reversibel.** Contoh: toggle favorit boleh optimistis dengan rollback; pembayaran tidak boleh.
5. **Jangan menyimpan token di provider.** Token hanya di `FlutterSecureStorage`.

## 2. Pola provider yang dipakai

| Pola | Contoh | Kapan dipakai |
|---|---|---|
| `StateProvider` | `bottomNavIndexProvider` | State UI sederhana |
| `NotifierProvider` | `authProvider`, `cartProvider` | State domain dengan aksi |
| `FutureProvider` | Data read-only | Query sekali |
| `Provider` | `catalogRepositoryProvider` | Dependency injection |
| `StateNotifierProvider` | `notificationListProvider` | List + pagination + error |

## 3. Siklus request standar

```text
idle → loading → success(data)
                └→ empty
                └→ failure(message, retry)
                └→ unauthorized → prompt/login
```

Setiap layar yang memuat data harus memiliki:

- indikator loading (shimmer/skeleton/spinner),
- empty state dengan CTA,
- error state dengan tombol retry,
- unauthorized state untuk endpoint privat.

## 4. Pemetaan error

`DioClient` memetakan status HTTP menjadi `Failure`:

| HTTP | Failure | Perilaku UI |
|---|---|---|
| 401 | `AuthFailure` | Hapus token, arahkan login, tampilkan sesi berakhir |
| 403 | `UnknownFailure`/izin | Tampilkan pesan akses ditolak; jangan logout otomatis |
| 404 | `NotFoundFailure` | Tampilkan resource tidak ditemukan |
| 422 | `ValidationFailure(errors)` | Tampilkan error per field |
| 500 | `ServerFailure` | Tampilkan error server + retry |
| null | `NetworkFailure` | Tampilkan periksa koneksi + retry |
| lainnya | `UnknownFailure` | Tampilkan pesan server |

Catatan: `DioClient` **belum** menghapus token otomatis saat 401. Implementasi baru harus menambahkan handler global atau menangani di provider.

## 5. Guest mode

- Guest id dibuat dan disimpan lokal oleh `GuestMode`.
- Guest dapat:
  - melihat home, katalog, detail, pencarian, legal,
  - memulai chat guest (`/messages/guest/start`),
  - melihat voucher.
- Guest tidak dapat:
  - keranjang, checkout, pesanan, favorit, ulasan, profil, keamanan, notifikasi akun.
- Layar privat menampilkan `GuestAuthPrompt`.
- Jangan mengirim Bearer token kosong; interceptor hanya menambahkan header jika token ada.

## 6. Form dan validasi

- Validasi client untuk UX; validasi final di backend.
- Tampilkan error `422` di field terkait menggunakan `ValidationFailure.errors`.
- Jangan menampilkan stack trace atau pesan database.
- Disable tombol submit saat request berjalan untuk mencegah duplikasi.
- Untuk upload, tampilkan progress dan izinkan batal jika memungkinkan.

## 7. Pagination dan refresh

- Gunakan `page`/`per_page` atau cursor sesuai endpoint.
- Simpan `hasMore` dan `currentPage`; jangan meminta halaman yang sama berulang.
- `RefreshIndicator` harus mereset list dan page.
- Saat item dihapus, perbarui list lokal tanpa harus fetch ulang seluruh halaman.

## 8. Cache lokal

| Data | Penyimpanan | Catatan |
|---|---|---|
| Token | `FlutterSecureStorage` key `auth_token` | Jangan di SharedPreferences |
| Locale | `SharedPreferences` key `app_locale` | Default `id` |
| Onboarding | `SharedPreferences` key `onboarding_seen` | Dibaca redirect |
| Guest id | `SharedPreferences`/secure storage | Dipakai chat guest |
| Preferensi notifikasi | `SharedPreferences` | Lokal; belum tentu disinkronkan backend |
| Theme | `SharedPreferences` | `ThemeProvider` |
| App lock flags | `SharedPreferences`/secure storage | Per akun |

## 9. Anti-pattern yang dilarang

- Memanggil `Dio()` baru di dalam widget.
- Menyimpan harga final di state lalu mengirimkannya sebagai total tanpa validasi backend.
- Menelan error dengan `catch (_) {}` tanpa feedback.
- Menampilkan `SnackBar` untuk setiap error tanpa membedakan validation/network.
- Menjalankan request di `build`.
- Menyimpan PII (KTP, selfie, token) di log.
- Menggunakan `Navigator.push` untuk route yang sudah ada di `go_router`.
