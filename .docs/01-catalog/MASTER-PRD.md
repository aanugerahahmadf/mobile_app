# Master PRD — Aplikasi Timeless Florals

> Dokumen payung. Detail per layar ada di [`../06-reference/SCREEN-INDEX.md`](../06-reference/SCREEN-INDEX.md).

## 1. Ringkasan produk

Aplikasi mobile membantu calon pengantin menemukan, membandingkan, dan memesan Timeless Florals. Pengguna dapat mencari katalog secara teks maupun visual (CBIR), memilih paket/tier, menyimpan favorit, memasukkan item ke keranjang, checkout dengan voucher, membayar melalui Virtual Account atau QRIS, memantau status pesanan, serta berkomunikasi dengan admin melalui chat.

Aplikasi juga mendukung **guest mode** untuk eksplorasi katalog dan chat awal tanpa akun. Fitur yang membutuhkan kepemilikan data (keranjang, pesanan, favorit, ulasan, keamanan akun) tetap memerlukan login.

## 2. Tujuan

### 2.1 Tujuan pengguna

1. Menemukan dekorasi yang sesuai tema, warna, kapasitas, dan anggaran.
2. Melihat detail paket, tier, galeri, ulasan, dan ketersediaan stok.
3. Memesan dengan alur yang jelas: katalog → keranjang/checkout → pembayaran → pelacakan.
4. Mendapatkan kepastian status pembayaran dan pesanan.
5. Menghubungi admin tanpa kehilangan konteks katalog atau pesanan.

### 2.2 Tujuan bisnis

1. Meningkatkan konversi dari eksplorasi katalog menjadi pesanan dibayar.
2. Mengurangi pertanyaan manual melalui chat dan halaman bantuan.
3. Menjaga kepercayaan melalui status pembayaran, invoice, dan ulasan terverifikasi.
4. Menyediakan data operasional (pesanan, pembayaran, stok) yang konsisten di PostgreSQL.

### 2.3 Non-goals

- Flutter tidak melakukan perhitungan harga final, pajak, diskon, atau status pembayaran sendiri.
- Flutter tidak mengakses PostgreSQL secara langsung.
- Flutter tidak memanggil AI Core secara langsung.
- Aplikasi bukan panel admin. Aksi admin ada di panel Filament backend.
- Data Connect dan gRPC bukan kanal data produksi saat ini.

## 3. Persona

| Persona | Kebutuhan utama | Hambatan yang harus diselesaikan UI |
|---|---|---|
| Calon pengantin (guest) | Melihat inspirasi dan bertanya | Harus bisa eksplorasi tanpa paksaan daftar; dorongan login jelas saat dibutuhkan |
| Calon pengantin (login) | Menyimpan favorit, memesan, memantau pembayaran | State keranjang/favorit/chat harus persisten dan akurat |
| Pasangan yang membandingkan | Filter kategori, harga, rating, visual search | Pencarian dan filter harus cepat, hasil kosong harus informatif |
| Pengguna yang sudah memesan | Melihat status, mengunduh invoice, chat admin | Status pembayaran dan pesanan tidak boleh ambigu |
| Pengguna yang peduli keamanan | 2FA, perangkat tepercaya, riwayat login | Alur keamanan harus dapat dipulihkan tanpa terkunci |

## 4. Journey utama

### 4.1 Discovery → consideration

```text
Startup → Landing → Home
                  ├─ kategori / katalog → CatalogGrid → CatalogDetail
                  ├─ search teks → Search → hasil
                  ├─ search gambar / CBIR → CbirResult → CatalogDetail
                  └─ favorit → Favorite
```

### 4.2 Purchase

```text
CatalogDetail → pilih tier → Cart
Cart → Checkout → buat order (POST /bookings)
Checkout → pilih metode → PaymentInstruction → PaymentMethodDetail
PaymentMethodDetail → VA / QRIS / confirm / upload proof
OrderHistory / OrderDetail → status + invoice
```

### 4.3 Support

```text
CatalogDetail / OrderDetail / ChatList → ChatDetail
ChatDetail → kirim pesan, lampiran, laporan, rating percakapan
Notification → NotificationDetail → deep link ke order/chat
```

### 4.4 Account & trust

```text
Profile → CompleteProfile (KYC) → FaceScanner / DocumentScanner
Profile → Settings → PasswordAndSecurity
PasswordAndSecurity → ChangePassword / 2FA / TrustedDevices / LoginActivity / RecentEmails / SecurityCheckup
```

## 5. Ruang lingkup fitur

| Fitur | Nilai pengguna | Layar utama | Status route |
|---|---|---|---|
| Splash & onboarding | Memuat data awal, menjelaskan nilai produk | `Startup`, `Landing`, `Onboarding` | 2 route; onboarding tidak ter-route |
| Auth | Daftar, masuk, OTP, 2FA, pemulihan | `Landing`, `OtpEmailVerification`, `TwoFactorVerify`, `SecurityQuestion` | Sebagian; login/register client belum punya route backend |
| Home | Rekomendasi, kategori, promo | `Home` | Route |
| Katalog | Grid, filter, detail, tier, ulasan, favorit | `CatalogGrid`, `CatalogDetail` | Route |
| Pencarian | Teks, saran, pencarian gambar | `Search`, `SearchResults`, `CbirResult` | 2 route; hasil pencarian tidak ter-route |
| Keranjang | Pilih item, ubah qty, hapus, pindah ke favorit | `Cart` | Route |
| Checkout & order | Buat order, voucher, pembayaran, invoice | `Checkout`, `OrderHistory`, `OrderDetail` | Route |
| Pembayaran | VA, QRIS, instruksi, webview | `PaymentInstruction`, `PaymentMethodDetail`, `PaymentWebView` | Route; QRIS/VA stubs tidak ter-route |
| Chat | Percakapan admin, lampiran, panggilan, laporan | `ChatList`, `ChatDetail` | Route |
| Favorit | Simpan katalog/paket | `Favorite` | Route ganda `/favorite` dan `/Favorite` |
| Ulasan | Tulis, edit, hapus, vote, balas | `MyReviews`, `ReviewList`, `CatalogRatingCommentsByUser` | Route |
| Voucher | Daftar, detail, klaim | `VoucherList`, `VoucherDetail` | Route |
| Riwayat | Riwayat wallet/transaksi | `History` | Route |
| Notifikasi | Daftar, detail, pengaturan, FCM | `Notification`, `NotificationDetail`, `NotificationSettings` | Route |
| Profil & KYC | Data diri, dokumen, wajah, kelengkapan | `Profile`, `EditProfile`, `ProfileField`, `CompleteProfile`, scanner | Route + kamera |
| Keamanan | Password, 2FA, perangkat, sesi, email | 7 layar keamanan | Route |
| Pengaturan | Tema, bahasa, cache, app lock, hapus akun | `Settings`, `Language`, `StorageAndData` | Route |
| Legal | Syarat, privasi, kebijakan, bantuan, tentang | 6 layar legal | 5 route; About tidak ter-route |
| Pelaporan | Laporkan katalog/pesanan/chat | `ReportSubmit` | Tidak ter-route |

## 6. Aturan bisnis lintas fitur

### 6.1 Identitas dan sesi

1. Satu pengguna memiliki satu akun `users` dengan email/username unik.
2. Token Sanctum disimpan di `FlutterSecureStorage` dengan key `auth_token`.
3. `401` harus diperlakukan sebagai sesi berakhir: bersihkan token dan arahkan ke login. Saat ini `DioClient` hanya memetakan error; pembersihan token dilakukan di lapisan pemanggil.
4. Guest memiliki identitas lokal terpisah (`guest_id`) untuk chat; guest tidak memiliki akses ke keranjang, pesanan, favorit, atau keamanan akun.
5. Login/register email-password adalah kontrak yang **belum tersedia** di route Laravel saat ini. Lihat [Known Gaps](../06-reference/KNOWN-GAPS.md).

### 6.2 Katalog

1. `catalogs` adalah entitas utama; `packages` adalah tier/varian di dalam katalog (`packages.catalog_id`).
2. Harga yang ditampilkan harus berasal dari respons backend (`price`, `discount_price`, `finalPrice`), bukan dihitung ulang secara lokal.
3. Katalog tidak aktif atau stok habis tidak boleh bisa di-checkout.
4. Ulasan katalog memakai `reviews.catalog_id`; ulasan tier memakai `reviews.package_id`.
5. Favorite mendukung `catalog_id` dan `package_id`; backend canonical memakai `FavoriteController`.

### 6.3 Keranjang dan checkout

1. Keranjang membutuhkan login dan disimpan di tabel `carts`.
2. Setiap item cart minimal memiliki `catalog_id`, `package_id` (tier), dan `quantity`.
3. Checkout mengirim `POST /bookings`; backend membuat `orders`, `transactions`, `order_timelines` dalam transaksi database.
4. Voucher divalidasi melalui `POST /vouchers/validate` sebelum dipakai.
5. Total akhir dan status pembayaran adalah milik backend. UI tidak boleh mengunci status sendiri.
6. Pembayaran dapat berupa VA, QRIS, atau konfirmasi manual dengan bukti transfer.
7. Invoice diunduh/dikirim melalui endpoint backend; file tidak dibuat di Flutter.

### 6.4 Chat

1. Percakapan login memakai `fm_inboxes` + `fm_messages`.
2. `fm_inboxes.user_ids` berupa JSON; tidak ada tabel pivot.
3. `fm_messages.inbox_id` **tidak memiliki FK** ke `fm_inboxes` (gap integritas).
4. Guest chat memakai endpoint `/messages/guest/*`; percakapan guest tidak boleh mengakses inbox pengguna lain.
5. Panggilan memakai `chat_calls` dan endpoint `/messages/calls/*`; **sudah diimplementasikan** oleh `ChatCallController` (signaling WebRTC, media peer-to-peer). Varian guest tersedia di `/messages/guest/calls*`.
6. Rating percakapan disimpan melalui `POST /messages/{inboxId}/rate`.

### 6.5 Ulasan

1. Ulasan hanya untuk pengguna login.
2. Satu pengguna dapat memberi ulasan pada katalog/tier; backend menentukan batas duplikasi.
3. Vote helpful disimpan di `review_votes` (unik per user/review).
4. Balasan disimpan di `review_replies`.
5. Ulasan anonim tetap menyimpan `user_id`; flag `is_anonymous` hanya menyembunyikan identitas di UI.

### 6.6 Keamanan

1. Password minimal 12 karakter pada layar perubahan password.
2. 2FA mendukung email, authenticator, dan recovery code.
3. Perangkat tepercaya disimpan di `trusted_devices`; sesi di `user_sessions`.
4. Log aktivitas login berasal dari `user_sessions` dan `security_events`.
5. Email perubahan diverifikasi melalui OTP sebelum diterapkan.

### 6.7 Notifikasi

1. FCM token dikirim ke `POST /notifications/fcm-token`.
2. Notifikasi tersimpan di tabel `notifications` (Laravel notifications).
3. Badge unread dihitung dari endpoint `/notifications/unread-count` dan/atau `GET /home`.
4. Membuka notifikasi harus menandainya sudah dibaca dan menavigasi ke resource terkait.

## 7. Persyaratan non-fungsional

| Aspek | Target |
|---|---|
| Waktu muat awal | Startup tidak boleh memblokir lebih dari 2 detik; preload katalog non-blocking |
| Offline | Layar harus menampilkan error/retry; tidak boleh crash saat koneksi hilang |
| Keamanan | Token tidak boleh dicetak ke log; HTTPS di produksi; validasi input di backend |
| Aksesibilitas | Semua tombol memiliki label; kontras mengikuti tema; teks dapat membesar |
| Lokalisasi | Bahasa Indonesia dan Inggris; `Accept-Language` dikirim setiap request |
| Responsif | Layout aman untuk layar kecil, notch, dan tablet |
| Observability | Error API dipetakan ke `Failure`; crash non-fatal dilaporkan tanpa PII |

## 8. Metrik keberhasilan

- Rasio katalog dilihat → keranjang.
- Rasio keranjang → checkout → pembayaran berhasil.
- Waktu rata-rata dari order dibuat sampai pembayaran terkonfirmasi.
- Jumlah chat yang berujung pada order.
- Rasio pencarian tanpa hasil (harus diturunkan dengan katalog/filter yang lebih baik).
- Tingkat penyelesaian profil/KYC.
- Crash-free sessions.

## 9. Dependensi dan risiko

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Endpoint login/register tidak ada di route Laravel | Pengguna tidak bisa masuk dengan email/password | Implementasikan route + controller, atau ubah client ke alur yang tersedia |
| Casing `/favorite` vs `/Favorite` | Favorit gagal 404 di server case-sensitive | Samakan kontrak; gunakan `/Favorite` |
| Endpoint panggilan chat **sudah tersedia** | Fitur call berfungsi; risiko ada pada izin mikrofon/kamera dan kualitas jaringan | Uji izin runtime, fallback audio-only, dan indikator koneksi |
| `fm_messages` tanpa FK | Data chat orphan | Tambahkan FK atau validasi aplikasi |
| Banyak layar stub | Ekspektasi produk tidak terpenuhi | Tandai sebagai belum siap; jangan expose di navigasi |
| Dokumen lama menyebut Kotlin/MySQL | Salah arsitektur | Dokumen ini menggantikan bagian tersebut |

## 10. Definisi selesai (Definition of Done)

Sebuah layar dianggap selesai jika:

- PRD layar dan skill layar diperbarui.
- Route dan entry point sesuai [Navigasi](../02-architecture/NAVIGATION.md).
- Semua API yang dipakai terdaftar di Laravel dan diuji.
- Loading, empty, error, dan unauthorized state memiliki UI.
- Tidak ada data sensitif di log.
- `flutter analyze` bersih untuk file yang diubah.
- Ada bukti uji manual pada perangkat/emulator.
