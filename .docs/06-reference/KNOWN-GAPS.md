# Known Gaps — Mobile, Backend, dan Database

Dokumen ini mencatat **selisih nyata** antara kode Flutter, route Laravel, dan skema PostgreSQL per 6 November 2026. Gap di sini bukan daftar keinginan; semuanya ditemukan dengan membaca kode dan membandingkan kontrak.

Klasifikasi:

- **P0** — memblokir alur utama atau menyebabkan kegagalan data.
- **P1** — fitur berjalan sebagian, pengguna melihat error, atau data tidak sinkron.
- **P2** — kualitas, konsistensi, atau risiko jangka panjang.

## 1. Ringkasan prioritas

| ID | Prioritas | Gap | Dampak |
|---|---|---|---|
| GAP-01 | P0 | Route `/login` dan `/register` tidak ada di backend | Login/registrasi email-password gagal |
| GAP-02 | P0 | Guest Home memanggil endpoint Sanctum | Home guest kosong/401 |
| GAP-03 | P1 | Casing `/favorite` vs `/Favorite` | Favorit 404 pada server case-sensitive |
| GAP-04 | P1 | `removeFromFavorite` tidak mengirim `is_catalog` | Hapus favorit katalog gagal |
| GAP-05 | P1 | `CartProvider.restoreItem` tidak mengirim `packageId` | Undo hapus item keranjang selalu gagal |
| GAP-06 | P1 | Checkout mengirim alamat yang diabaikan backend | Alamat pengiriman tidak tersimpan |
| GAP-07 | P1 | Voucher dicek lokal sebelum server | Kuota/pemakaian voucher tidak akurat |
| GAP-08 | P1 | Voice search mengirim `.m4a` ke endpoint gambar | Pencarian suara ditolak validasi |
| GAP-09 | P1 | `LanguageScreen` tidak memanggil `PUT /user/language` | Bahasa tidak tersimpan di akun |
| GAP-10 | P1 | Pengaturan notifikasi hanya lokal | Preferensi hilang saat ganti perangkat |
| GAP-11 | P1 | `fm_messages.inbox_id` tanpa foreign key | Pesan yatim dan query tidak konsisten |
| GAP-12 | P1 | Banyak layar tidak terdaftar di router | Layar tidak dapat dijangkau pengguna |
| GAP-13 | P2 | `fm_inboxes.user_ids` berupa JSON | Sulit di-join, rawan data ganda |
| GAP-14 | P2 | Startup memanggil endpoint privat | Preload guest selalu 401 |
| GAP-15 | P2 | Dua route `*Screen` berbeda memakai file yang sama | Dokumentasi/route ambigu |
| GAP-16 | P2 | GraphQL/gRPC/Data Connect tidak dipakai | Biaya perawatan tanpa manfaat runtime |

## 2. Autentikasi dan sesi

### GAP-01 — Route login/register tidak tersedia (P0)

**Bukti:**

- `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` mendefinisikan `login = '/login'`, `register = '/register'`, `forgotPassword = '/forgot-password'`, `resetPassword = '/reset-password'`.
- `php artisan route:list` tidak memuat keempat route tersebut.
- `AuthController` hanya menyediakan `/auth/send-otp`, `/auth/verify-otp`, `/auth/two-factor/*`, `/auth/google`, `/auth/facebook`, `/auth/apple`, `/auth/clerk-sync`, `/logout`, `/user/account`, `/user`, `/profile`.

**Dampak:** `AuthRepositoryImpl.login()` dan `.register()` menerima 404. Alur landing → login email/password tidak dapat diselesaikan.

**Rekomendasi:** pilih salah satu:

1. Tambahkan `POST /login` dan `POST /register` di backend yang menerbitkan token Sanctum; atau
2. Ubah client ke alur OTP/Google yang sudah tersedia dan hapus layar password lama.

Sampai diputuskan, PRD layar terkait menandai alur ini **blocked**.

### GAP-02 — Guest Home memakai endpoint privat (P0)

**Bukti:**

- `HomeScreen` menampilkan UI guest dan `GuestAuthPrompt` pada beberapa aksi.
- `_fetchHome()` memanggil `GET /home`, `_fetchCatalog()` memanggil `GET /catalog`, `_fetchCategories()` memanggil `GET /categories`.
- Ketiganya berada di grup `auth:sanctum`.
- `StartupDataService` juga memanggil `/categories` dan `/catalog` sebelum pengguna login.

**Dampak:** pengguna guest melihat halaman kosong atau error; preload startup selalu gagal 401 dan error ditelan.

**Rekomendasi:** sediakan varian publik (`/home/public`, `/catalog/public`, `/categories/public`) atau izinkan guest membaca katalog/kategori. Perbaiki juga `StartupDataService` agar melewati endpoint privat saat belum ada token.

### GAP-03 — Casing endpoint favorit (P1)

**Bukti:**

- Client memakai `GET /favorite`, `POST /favorite/toggle`, `DELETE /favorite/{packageId}`.
- Laravel mendaftarkan `GET /Favorite`, `POST /Favorite/toggle`, `DELETE /Favorite/{packageId}`.
- Router Laravel bersifat case-sensitive pada path.

**Dampak:** di server Linux/production favorit berisiko 404. Di Windows (case-insensitive) tidak terlihat.

**Rekomendasi:** samakan casing. Pilihan paling aman: ubah client menjadi `/Favorite` atau tambahkan route lowercase sebagai alias di backend. Dokumentasikan satu casing kanonik.

### GAP-04 — Hapus favorit katalog kehilangan tipe (P1)

**Bukti:**

- `FavoriteRepositoryImpl.removeFromFavorite(String id, {bool isCatalog = false})` mengirim query `catalog` hanya bila `isCatalog == true`.
- `FavoriteProvider` memanggil method tanpa meneruskan `isCatalog`.
- `FavoriteController@removeFromFavorite` mencari `package_id` lebih dulu.

**Dampak:** item favorit bertipe katalog dapat menghasilkan 404 atau salah hapus.

**Rekomendasi:** teruskan `resource_type`/`is_catalog` dari model favorit ke repository, atau gunakan endpoint `DELETE /Favorite/{id}` yang menerima ID favorit, bukan ID paket.

### GAP-05 — Undo hapus keranjang rusak (P1)

**Bukti:**

- `CartProvider.restoreItem()` memanggil `addItem(catalogId: ..., quantity: ...)` tanpa `packageId`.
- `CartRepositoryImpl.addToCart()` melempar `ArgumentError` bila `catalogId == null || packageId == null`.

**Dampak:** snackbar "Undo" selalu gagal untuk item yang dipulihkan.

**Rekomendasi:** simpan `package_id` di model keranjang dan kirim ulang keduanya, atau gunakan endpoint restore khusus yang menerima `cart_id`.

### GAP-06 — Alamat checkout tidak disimpan (P1)

**Bukti:**

- `CheckoutScreen` mengirim `address`, `city`, `province`, `postal_code`, dan nama penerima.
- `OrderController@createOrder` hanya memvalidasi `package_id`, `catalog_id`, `event_date`, `event_time`, `quantity`, `notes`, `customer_name`, `whatsapp`, `voucher_code`.
- Tabel `orders` tidak memiliki kolom alamat; alamat hanya ada di `user_addresses`.

**Dampak:** pengguna mengisi alamat, tetapi konfirmasi/pesanan tidak menyimpannya. Tidak ada bukti alamat yang dipakai saat event.

**Rekomendasi:** tambahkan `user_address_id` atau snapshot alamat pada `orders`, lalu validasi di backend. Jika acara dilakukan di venue yang sama, hapus field alamat dari checkout agar UI tidak menipu.

### GAP-07 — Validasi voucher lokal (P1)

**Bukti:** `VoucherProvider`/`CheckoutScreen` mencocokkan kode dengan daftar voucher yang sudah dimuat, lalu memanggil `POST /vouchers/validate` hanya jika tidak ditemukan.

**Dampak:** voucher yang sudah habis, kedaluwarsa, atau milik pengguna lain bisa lolos di UI; total akhir bisa berbeda dari backend.

**Rekomendasi:** selalu panggil `POST /vouchers/validate` sebelum menampilkan diskon dan sebelum `POST /bookings`. Anggap respons server sebagai sumber kebenaran.

### GAP-08 — Voice search mengirim audio ke endpoint gambar (P1)

**Bukti:**

- `SearchScreen` merekam audio `.m4a` lalu memanggil `POST /search/image`.
- Validasi backend untuk `/search/image` hanya menerima `image/*` dan `video/*`.

**Dampak:** pencarian suara selalu 422.

**Rekomendasi:** tambahkan endpoint transkripsi (`POST /search/voice`) atau ubah UI menjadi pencarian teks. Jangan mengirim audio ke endpoint CBIR gambar.

### GAP-09 — Bahasa tidak disinkronkan (P1)

**Bukti:**

- `LanguageScreen` memanggil `localeProvider.setLocale()` dan menyimpan `app_locale` di `SharedPreferences`.
- Backend memiliki `PUT /user/language` (atau endpoint setara) tetapi tidak dipanggil dari layar.
- `LocaleProvider` tidak memiliki dependensi ke repository/Dio.

**Dampak:** bahasa kembali ke default saat pengguna memasang ulang aplikasi atau login di perangkat lain. Email/notifikasi backend memakai locale lama.

**Rekomendasi:** setelah `setLocale`, panggil endpoint bahasa bila pengguna terautentikasi; tangani kegagalan tanpa membatalkan perubahan lokal.

### GAP-10 — Preferensi notifikasi hanya lokal (P1)

**Bukti:** `NotificationSettingsScreen` menyimpan switch ke `SharedPreferences`; tidak ada pemanggilan API. Backend tidak memiliki route preferensi notifikasi per kategori.

**Dampak:** preferensi tidak portabel dan tidak memengaruhi pengiriman FCM dari server.

**Rekomendasi:** tambahkan kolom/endpoint preferensi (mis. `notification_preferences` pada `users` sudah ada) dan sinkronkan.

### GAP-11 — Integritas pesan (P1)

**Bukti:** `fm_messages.inbox_id` tidak memiliki foreign key ke `fm_inboxes.id`; `fm_inboxes.user_ids` adalah JSON, bukan pivot.

**Dampak:** penghapusan inbox meninggalkan pesan yatim; query anggota memakai `JSON contains` dan rawan duplikasi.

**Rekomendasi:** tambahkan FK `fm_messages.inbox_id → fm_inboxes.id` dengan `ON DELETE CASCADE`, dan pertimbangkan tabel `fm_inbox_participants`.

### GAP-12 — Layar tidak terhubung ke router (P1)

Layar berikut ada dan dapat di-import, tetapi tidak memiliki `GoRoute`:

- `OnboardingScreen`
- `AboutScreen`
- `ForgotPasswordScreen`
- `ResetPasswordScreen`
- `SearchResultsScreen`
- `QrisPaymentScreen`
- `VirtualAccountPaymentScreen`
- `AutoCaptureScannerScreen`
- `ScannedImageReviewScreen`
- `ReportSubmitScreen`

**Dampak:** fitur tidak dapat dibuka lewat navigasi normal. Beberapa layar hanya bisa muncul lewat `Navigator.push` lokal atau tidak sama sekali.

**Rekomendasi:** daftarkan route atau hapus layar mati. Untuk scanner, putuskan apakah alur memakai `DocumentScannerScreen`/`FaceScannerScreen` saja.

### GAP-13 — Model partisipan chat berbasis JSON (P2)

`fm_inboxes.user_ids` menyimpan array ID pengguna. Tidak ada FK, tidak ada index GIN, dan sulit melakukan join ke `users`. Untuk laporan/administrasi, pertimbangkan tabel pivot `fm_inbox_participants(inbox_id, user_id, role)`.

### GAP-14 — Preload startup memanggil endpoint privat (P2)

`StartupDataService.prepare()` selalu memanggil `/categories` dan `/catalog`. Jika belum ada token, keduanya 401; error ditelan sehingga progress bar tetap selesai tetapi tidak ada data. Perbaiki dengan cek status autentikasi atau gunakan endpoint publik.

### GAP-15 — Route ganda dan layar wrapper (P2)

- `/favorite` dan `/Favorite` sama-sama menuju `Favoritescreen`.
- `StorageAndDataScreen.dart` mendefinisikan beberapa kelas layar sekaligus; file `AudioAutoDownloadScreen.dart`, `AutoDownloadScreen.dart`, dan lainnya hanya re-export/subclass. Dokumentasi memperlakukan setiap layar sebagai unit terpisah dengan catatan wrapper.

### GAP-16 — Teknologi yang tidak dipakai runtime (P2)

- GraphQL: endpoint `/graphql` ada, tetapi aplikasi mobile memakai REST.
- gRPC: file generated ada, tidak ada server/user-service yang dipanggil.
- Firebase Data Connect: generated code ada, tidak dipakai.
- Firebase Firestore: dinonaktifkan.
- Firebase Auth: hanya untuk memperoleh Google ID token; sesi tetap Sanctum.

**Rekomendasi:** hapus dependensi/generated code yang tidak dipakai atau dokumentasikan sebagai eksperimen. Jangan menambah fitur baru di jalur yang tidak teruji.

## 3. Kontrak yang sering disalahpahami

### 3.1 Base URL

`API_BASE_URL` sudah berakhiran `/api`. Jangan menulis `/api/catalog`; cukup `/catalog`.

### 3.2 Envelope respons

Sebagian endpoint mengembalikan `{status, message, data}`, sebagian mengembalikan `{data: ...}`, dan sebagian data langsung. Client harus membaca repository masing-masing, bukan mengasumsikan satu bentuk.

### 3.3 Status pesanan vs pembayaran

- `orders.status`: `pending`, `confirmed`, `preparing`, `event_day`, `completed`, `cancelled`.
- `orders.payment_status`: `unpaid`, `pending`, `paid`, `failed`, `refunded`, `cancelled`.

Jangan memakai `status` untuk menyimpulkan pembayaran.

### 3.4 Parameter path

Beberapa route memakai nama parameter berbeda (`{report}` vs `{id}`, `{deviceId}` vs `{id}`). Client mengirim nilai berdasarkan posisi, jadi perbedaan nama tidak masalah selama urutan path sama. Yang menjadi masalah hanya perbedaan jumlah segmen atau metode HTTP.

### 3.5 Checkout wajib `package_id`

`POST /bookings` membutuhkan `package_id` (tier) dan `catalog_id`. Mengirim hanya `catalog_id` akan gagal validasi.

## 4. Gap per fitur

| Fitur | Gap utama | Layar terdampak |
|---|---|---|
| Auth | Login/register 404; 2FA memakai challenge token; app lock lokal + backend bercampur | `LandingScreen`, `ForgotPasswordScreen`, `ResetPasswordScreen`, `AppLockScreen` |
| Home | Guest 401; preload privat | `HomeScreen`, `StartupScreen` |
| Katalog | `categories`/`catalog` privat; detail memakai tier | `CatalogGridScreen`, `CatalogDetailScreen` |
| Keranjang | Restore tanpa `package_id`; guest prompt | `CartScreen` |
| Checkout | Alamat diabaikan; voucher lokal | `CheckoutScreen` |
| Pembayaran | QRIS/VA layar tidak terhubung; status bergantung polling | `PaymentInstructionScreen`, `QrisPaymentScreen`, `VirtualAccountPaymentScreen` |
| Chat | Guest dan login bercabang; FK pesan tidak ada; panggilan sudah ada | `ChatListScreen`, `ChatDetailScreen` |
| Favorit | Casing + tipe resource | `Favoritescreen`, `CatalogDetailScreen` |
| Ulasan | Ringkasan/komentar memakai endpoint berbeda; moderasi | `ReviewListScreen`, `MyReviewsScreen` |
| Pencarian | Voice salah endpoint; hasil tidak punya route | `SearchScreen`, `SearchResultsScreen` |
| Notifikasi | Preferensi lokal; deep link fallback | `NotificationScreen`, `NotificationDetailScreen`, `NotificationSettingsScreen` |
| Profil | Dokumen dinamis; KYC; avatar | `ProfileScreen`, `CompleteProfileScreen`, `ProfileFieldScreen` |
| Keamanan | Banyak layar, endpoint sebagian belum dipakai | `PasswordAndSecurityScreen` dan sublayar |
| Legal | Konten dari API; fallback lokal | `AboutScreen`, `HelpCenterScreen`, `PrivacyPolicyScreen`, `TermsOfServiceScreen`, `WeddingPolicyScreen` |
| Riwayat | Memakai `/wallet/history`, bukan `/histories` | `HistoryScreen` |

## 5. Urutan perbaikan yang disarankan

1. **P0:** putuskan auth (tambah route atau ubah client) dan buka akses katalog publik untuk guest.
2. **P1:** perbaiki casing favorit, hapus favorit, restore keranjang, validasi voucher server, dan alamat checkout.
3. **P1:** sambungkan layar mati atau hapus; perbaiki voice search dan sinkronisasi bahasa.
4. **P2:** tambahkan FK pesan, pivot inbox, dan sinkronisasi preferensi notifikasi.
5. **P2:** bersihkan jalur GraphQL/gRPC/Data Connect yang tidak dipakai.

## 6. Cara memverifikasi ulang

```powershell
# Route backend
cd ..\Mobile-And-Backend
php artisan route:list --path=api

# Skema database
psql -U postgres -d wedding_florals_decorations -c "\d+ orders"

# Endpoint client
rg "ApiEndpoints\." lib

# Layar tanpa route
rg "class \w+Screen" lib/Features
```

Setiap perubahan kontrak harus memperbarui:

- PRD layar terkait di `.docs/screens/`.
- `SKILL.md` layar terkait di `.skills/screens/`.
- `.docs/03-api/REST-API.md` dan `.docs/06-reference/API-ENDPOINT-MAP.md`.
- `.docs/04-database/DATABASE.md` bila tabel/kolom berubah.
