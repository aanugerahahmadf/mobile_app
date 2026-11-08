# Kontrak REST API

## 1. Basis URL

| Environment | Base URL |
|---|---|
| Development LAN | `http://<IP-PC>:8000/api` |
| Android emulator | `http://10.0.2.2:8000/api` |
| Production | `https://<domain>/api` |

`API_BASE_URL` **sudah berakhiran `/api`**. Jangan menambahkan `/api` lagi di path. Contoh: `GET /catalog` menjadi `http://host/api/catalog`.

## 2. Header

| Header | Nilai | Wajib |
|---|---|---|
| `Accept` | `application/json` | Ya |
| `Content-Type` | `application/json` atau `multipart/form-data` | Sesuai body |
| `Authorization` | `Bearer <sanctum-token>` | Endpoint privat |
| `Accept-Language` | `id` atau `en` | Ya (interceptor) |
| `X-Requested-With` | `XMLHttpRequest` | Opsional |

## 3. Auth

- Login/registrasi menerbitkan token Sanctum (kontrak target).
- Token disimpan di `FlutterSecureStorage` key `auth_token`.
- Endpoint privat memakai middleware `auth:sanctum`.
- Endpoint publik: katalog publik, kategori, legal, region, settings, CBIR stats/health, guest chat.
- `401` = token tidak valid/kedaluwarsa.
- `403` = token valid tetapi tidak berhak.

## 4. Format response

### 4.1 Sukses

```json
{
  "status": "success",
  "message": "Opsional",
  "data": {}
}
```

Beberapa endpoint mengembalikan data langsung di root (mis. login: `token`, `user`). Repository harus menangani keduanya.

### 4.2 Error

```json
{
  "status": "error",
  "message": "Pesan yang aman ditampilkan",
  "errors": {
    "field": ["Pesan validasi"]
  }
}
```

### 4.3 Pagination

Dua bentuk yang dijumpai:

```json
{
  "data": [],
  "meta": {"current_page": 1, "last_page": 3, "per_page": 20, "total": 51}
}
```

```json
{
  "data": {
    "data": [],
    "paginatorInfo": {"currentPage": 1, "lastPage": 3, "perPage": 20, "total": 51}
  }
}
```

Jangan mengasumsikan satu bentuk untuk semua endpoint. Gunakan adapter per repository.

## 5. Endpoint inti per domain

### 5.1 Auth & profil

| Method | Path | Auth | Controller | Tabel utama |
|---|---|---|---|---|
| POST | `/auth/send-otp` | Publik + throttle | `AuthController@sendOtp` | `users`, `whatsapp_otps` |
| POST | `/auth/verify-otp` | Publik + throttle | `AuthController@verifyOtp` | `users`, `whatsapp_otps` |
| POST | `/auth/two-factor/verify` | Publik + throttle | `AuthController@verifyTwoFactor` | `users`, `backup_codes` |
| POST | `/auth/two-factor/resend` | Publik + throttle | `AuthController@resendTwoFactorCode` | `users` |
| POST | `/auth/google` | Publik | `AuthController@googleLogin` | `users`, `personal_access_tokens` |
| POST | `/auth/facebook` | Publik | `AuthController@facebookLogin` | `users`, `personal_access_tokens` |
| POST | `/auth/apple` | Publik | `AuthController@appleLogin` | `users`, `personal_access_tokens` |
| POST | `/logout` | Sanctum | `AuthController@logout` | `personal_access_tokens` |
| GET | `/user` | Sanctum | closure di route | `users` |
| DELETE | `/user/account` | Sanctum | `AuthController@deleteAccount` | `users` |
| GET | `/profile` | Sanctum | `ProfileController@show` | `users`, `identity_documents` |
| PUT | `/profile` | Sanctum | `ProfileController@update` | `users` |
| POST | `/profile/avatar` | Sanctum | `ProfileController@updateAvatar` | `users`, `media` |
| GET | `/profile/completion` | Sanctum | `ProfileController@completion` | `users`, `identity_documents` |
| POST | `/profile/selfie` | Sanctum | `ProfileController@uploadSelfie` | `users` |
| POST | `/profile/face-scan` | Sanctum | `ProfileController@uploadFaceScan` | `users` |
| POST | `/profile/ktp-photo` | Sanctum | `ProfileController@uploadDocument` | `identity_documents` |
| PUT | `/profile/ktp` | Sanctum | `ProfileController@updateDocument` | `identity_documents` |

**Catatan penting:** route `/login`, `/register`, `/forgot-password`, `/reset-password` **tidak terdaftar** di `routes/api` saat verifikasi. Client masih memanggil path tersebut. Lihat [Known Gaps](../06-reference/KNOWN-GAPS.md).

### 5.2 Home, katalog, kategori

| Method | Path | Auth | Controller | Tabel |
|---|---|---|---|---|
| GET | `/home` | Sanctum* | `HomeController@index` | `categories`, `packages`, `vouchers`, `orders`, `notifications`, `fm_messages`, `fm_inboxes` |
| GET | `/categories` | Sanctum | `CategoryController@index` | `categories` |
| GET | `/categories-with-packages` | Sanctum | `CategoryController@withTopPackages` | `categories`, `packages` |
| GET | `/catalog` | Sanctum | `CatalogController@index` (GraphQL delegate) | `catalogs`, `packages`, `categories`, `media`, `reviews`, `favorites` |
| GET | `/catalog/public` | Publik | `CatalogController@index` | sama |
| GET | `/catalog/featured` | Sanctum | `CatalogController@featured` | sama |
| GET | `/catalog/on-sale` | Sanctum | `CatalogController@onSale` | sama |
| GET | `/catalog/{id}` | Sanctum | `CatalogController@show` | sama |
| GET | `/catalog/{id}/tiers` | Publik | `CatalogController@tiers` | `packages` |

\* `HomeController` memakai `Auth::user()` opsional; route tetap di middleware Sanctum. Guest yang memanggil tanpa token akan 401. Ini perlu diperbaiki jika guest home ingin didukung.

### 5.3 Keranjang, favorit, voucher

| Method | Path | Auth | Controller | Tabel |
|---|---|---|---|---|
| GET | `/cart` | Sanctum | `CartController@index` | `carts`, `catalogs`, `packages` |
| POST | `/cart/add` | Sanctum | `CartController@store` | `carts` |
| PUT | `/cart/{cart}` | Sanctum | `CartController@update` | `carts` |
| DELETE | `/cart/{cart}` | Sanctum | `CartController@destroy` | `carts` |
| GET | `/Favorite` | Sanctum | `FavoriteController@index` | `favorites`, `packages`, `catalogs` |
| POST | `/Favorite/toggle` | Sanctum | `FavoriteController@toggle` | `favorites` |
| GET | `/Favorite/{packageId}/check` | Sanctum | `FavoriteController@isInFavorite` | `favorites` |
| DELETE | `/Favorite/{packageId}` | Sanctum | `FavoriteController@removeFromFavorite` | `favorites` |
| GET | `/vouchers` | Sanctum | `VoucherController@index` | `vouchers`, `user_vouchers`, `discounts` |
| POST | `/vouchers/validate` | Sanctum | `VoucherController@validateVoucher` | `vouchers`, `discounts` |
| POST | `/vouchers/{voucher}/claim` | Sanctum | `VoucherController@claim` | `vouchers`, `user_vouchers` |

**Casing:** client memakai `/favorite` (huruf kecil), Laravel mendaftarkan `/Favorite` (huruf besar). Di server case-sensitive ini 404. Gunakan `/Favorite` atau tambahkan alias route.

### 5.4 Pesanan dan pembayaran

| Method | Path | Auth | Controller | Tabel |
|---|---|---|---|---|
| GET | `/bookings` | Sanctum | `OrderController@getOrders` | `orders`, `order_payments`, `packages`, `catalogs` |
| POST | `/bookings` | Sanctum | `OrderController@createOrder` | `orders`, `order_payments`, `order_timelines`, `transactions`, `carts`, `vouchers`, `user_vouchers` |
| GET | `/bookings/{id}` | Sanctum | `OrderController@show` | `orders`, `order_timelines`, `transactions`, `payment_*` |
| PUT | `/bookings/{id}` | Sanctum | `OrderController@updateOrder` | `orders` |
| DELETE | `/bookings/{id}` | Sanctum | `OrderController@deleteOrder` | `orders` |
| POST | `/bookings/{id}/cancel` | Sanctum | `OrderController@cancelOrder` | `orders`, `order_timelines` |
| POST | `/bookings/{id}/confirm-payment` | Sanctum | `OrderController@confirmPayment` | `orders`, `order_payments`, `transactions` |
| POST | `/bookings/{id}/virtual-account` | Sanctum | `OrderController@createVirtualAccount` | `payment_virtual_accounts`, `transactions`, `banks` |
| POST | `/bookings/{id}/qris` | Sanctum | `OrderController@createQris` | `payment_qris`, `transactions` |
| POST | `/bookings/{id}/pay` | Sanctum | `OrderController@initiatePayment` | `transactions`, `payment_methods` |
| POST | `/bookings/{id}/upload-proof` | Sanctum | `OrderController@uploadProof` | `order_payments`, `orders` |
| GET | `/bookings/{id}/invoice` | Sanctum | `OrderController@downloadInvoice` | `orders`, `transactions` |
| POST | `/bookings/{id}/invoice/email` | Sanctum | `OrderController@sendInvoiceEmail` | `orders`, `transactions` |
| GET | `/bookings/{id}/payment-info` | Sanctum | `OrderController@getPaymentInfo` | `transactions`, `payment_methods`, `payment_virtual_accounts`, `payment_qris` |

`/orders` adalah alias dari `/bookings` untuk beberapa method. Gunakan `/bookings` pada implementasi baru agar konsisten dengan client saat ini.

### 5.5 Ulasan

| Method | Path | Auth | Controller | Tabel |
|---|---|---|---|---|
| GET | `/reviews` | Sanctum | `ReviewController@getAllReviews` | `reviews`, `users`, `media` |
| POST | `/reviews` | Sanctum | `ReviewController@store` | `reviews` |
| PUT | `/reviews/{id}` | Sanctum | `ReviewController@update` | `reviews` |
| DELETE | `/reviews/{id}` | Sanctum | `ReviewController@destroy` | `reviews` |
| GET | `/reviews/catalog/{id}` | Sanctum | `ReviewController@getCatalogReviews` | `reviews`, `users` |
| GET | `/reviews/catalog/{id}/summary` | Sanctum | `ReviewController@getCatalogRatingSummary` | `reviews` |
| GET | `/reviews/user` | Sanctum | `ReviewController@getUserReviews` | `reviews` |
| POST | `/reviews/{id}/vote` | Sanctum | `ReviewController@voteHelpful` | `review_votes` |
| POST | `/reviews/{id}/reply` | Sanctum | `ReviewController@reply` | `review_replies` |
| DELETE | `/reviews/{id}/reply/{replyId}` | Sanctum | `ReviewController@deleteReply` | `review_replies` |

### 5.6 Chat

| Method | Path | Auth | Controller | Tabel |
|---|---|---|---|---|
| GET | `/messages/conversations` | Sanctum | `ChatController@getConversations` | `fm_inboxes`, `fm_messages`, `users` |
| GET | `/messages/conversations/{inboxId}` | Sanctum | `ChatController@getMessages` | `fm_inboxes`, `fm_messages`, `users` |
| POST | `/messages/start` | Sanctum | `ChatController@startConversation` | `fm_inboxes` |
| POST | `/messages/send` | Sanctum | `ChatController@sendMessage` | `fm_messages` |
| GET | `/messages/unread-count` | Sanctum | `ChatController@getUnreadCount` | `fm_messages`, `fm_inboxes` |
| POST | `/messages/{inboxId}/read` | Sanctum | `ChatController@markInboxAsRead` | `fm_messages` |
| POST | `/messages/{id}/react` | Sanctum | `ChatController@addReaction` | `fm_messages.meta` |
| POST | `/messages/{id}/star` | Sanctum | `ChatController@starMessage` | `fm_messages.meta` |
| POST | `/messages/{id}/forward` | Sanctum | `ChatController@forwardMessage` | `fm_messages` |
| DELETE | `/messages/{id}/delete` | Sanctum | `ChatController@deleteMessage` | `fm_messages` |
| POST | `/messages/{inboxId}/rate` | Sanctum | `ChatController@rateInbox` | `fm_inboxes.meta` |
| POST | `/messages/guest/start` | Guest throttle | `ChatController@guestStart` | `fm_inboxes` |
| POST | `/messages/guest/send` | Guest throttle | `ChatController@guestSend` | `fm_messages` |
| GET | `/messages/guest/{inboxId}` | Guest throttle | `ChatController@guestMessages` | `fm_inboxes`, `fm_messages` |
| GET | `/messages/customers` | Sanctum | `ChatController@getCustomersForChat` | `users`, `fm_inboxes` |
| POST | `/messages/calls` | Sanctum | `ChatCallController@start` | `chat_calls`, `fm_inboxes`, `users` |
| GET | `/messages/calls/{token}` | Sanctum | `ChatCallController@state` | `chat_calls` |
| POST | `/messages/calls/{token}/signal` | Sanctum | `ChatCallController@signal` | `chat_calls` |
| POST | `/messages/calls/{token}/accept` | Sanctum | `ChatCallController@accept` | `chat_calls` |
| POST | `/messages/calls/{token}/end` | Sanctum | `ChatCallController@end` | `chat_calls` |
| GET | `/messages/{inboxId}/calls/active` | Sanctum | `ChatCallController@active` | `chat_calls`, `fm_inboxes` |

**Panggilan WebRTC:** endpoint signaling di atas **sudah diimplementasikan** oleh `App\Http\Controllers\ChatCall\ChatCallController`. Client memakainya lewat `ChatCallService` (flutter_webrtc). Media audio/video mengalir peer-to-peer; backend hanya menyimpan state panggilan dan relay SDP/ICE. Varian guest tersedia di `/messages/guest/calls*` dengan throttle `guest-chat`, dan `GET /messages/guest/{inboxId}/calls/active` untuk memulihkan panggilan aktif setelah reconnect.

### 5.7 Notifikasi

| Method | Path | Auth | Controller | Tabel |
|---|---|---|---|---|
| GET | `/notifications` | Sanctum | `NotificationController@index` | `notifications` |
| GET | `/notifications/unread-count` | Sanctum | `NotificationController@unreadCount` | `notifications` |
| POST | `/notifications/{id}/read` | Sanctum | `NotificationController@markAsRead` | `notifications` |
| POST | `/notifications/read-all` | Sanctum | `NotificationController@markAllAsRead` | `notifications` |
| DELETE | `/notifications/{id}` | Sanctum | `NotificationController@destroy` | `notifications` |
| POST | `/notifications/fcm-token` | Sanctum | `NotificationController@registerFcmToken` | `device_tokens`/`user_fcm_devices` |

### 5.8 Keamanan

| Method | Path | Auth | Controller | Tabel |
|---|---|---|---|---|
| GET | `/security/checkup` | Sanctum | `SecurityController@checkup` | `users`, `user_sessions`, `trusted_devices` |
| GET | `/security/recent-emails` | Sanctum | `SecurityController@recentEmails` | `security_emails` |
| POST | `/security/change-email/send-otp` | Sanctum | `SecurityController@sendEmailChangeOtp` | `users` |
| POST | `/security/change-email/verify-otp` | Sanctum | `SecurityController@verifyEmailChangeOtp` | `users` |
| GET | `/security/saved-login` | Sanctum | `SecurityController@savedLoginStatus` | `users` |
| POST | `/security/saved-login/toggle` | Sanctum | `SecurityController@savedLoginToggle` | `users` |
| GET | `/security/login-activity` | Sanctum | `LoginActivityController@index` | `user_sessions` |
| DELETE | `/security/login-activity/{id}` | Sanctum | `LoginActivityController@destroy` | `user_sessions` |
| POST | `/security/sessions/remove-all` | Sanctum | `SecurityController@removeAllOtherSessions` | `user_sessions` |
| GET | `/security/trusted-devices` | Sanctum | `SecurityController@trustedDevices` | `trusted_devices` |
| DELETE | `/security/trusted-devices/{id}` | Sanctum | `SecurityController@removeTrustedDevice` | `trusted_devices` |
| POST | `/security/trusted-devices/{id}/verify` | Sanctum | `SecurityController@verifyTrustedDevice` | `trusted_devices` |
| POST | `/security/trusted-devices/{id}/reject` | Sanctum | `SecurityController@rejectTrustedDevice` | `trusted_devices` |
| DELETE | `/security/trusted-devices` | Sanctum | `SecurityController@removeAllTrustedDevices` | `trusted_devices` |
| GET | `/security/two-factor/status` | Sanctum | `SecurityController@twoFactorStatus` | `users` |
| POST | `/security/two-factor/toggle` | Sanctum | `SecurityController@twoFactorToggle` | `users` |
| POST | `/security/two-factor/setup` | Sanctum | `SecurityController@setupTwoFactor` | `users` |
| POST | `/security/two-factor/setup/verify` | Sanctum | `SecurityController@verifyTwoFactorSetup` | `users` |
| POST | `/security/two-factor/setup/resend` | Sanctum | `SecurityController@resendTwoFactorSetupOtp` | `users` |
| POST | `/security/two-factor/backup-codes` | Sanctum | `SecurityController@generateBackupCodes` | `backup_codes` |

### 5.9 Legal, wilayah, pencarian, CBIR

| Method | Path | Auth | Controller | Tabel |
|---|---|---|---|---|
| GET | `/legal/terms` | Publik | `LegalController@getTerms` | `terms_of_service` |
| GET | `/legal/privacy` | Publik | `LegalController@getPrivacy` | `privacy_policies` |
| GET | `/legal/wedding-decoration-policy` | Publik | `LegalController@getWeddingDecorationPolicy` | `wedding_decoration_policies` |
| GET | `/legal/help` | Publik | `LegalController@getHelp` | `helps` |
| GET | `/legal/about` | Publik | `LegalController@getAbout` | `legal_pages` |
| GET | `/legal-pages` | Publik | `LegalPageController@index` | `legal_pages` |
| GET | `/legal-pages/{slug}` | Publik | `LegalPageController@show` | `legal_pages` |
| GET | `/regions/provinces` | Publik | `RegionController@provinces` | `indonesia_provinces` |
| GET | `/regions/cities/{provinceCode}` | Publik | `RegionController@cities` | `indonesia_cities` |
| GET | `/regions/districts/{cityCode}` | Publik | `RegionController@districts` | `indonesia_districts` |
| GET | `/regions/villages/{districtCode}` | Publik | `RegionController@villages` | `indonesia_villages` |
| GET | `/search` | Sanctum | `SearchController@byText` | `search_logs`, `catalogs`, `packages`, `categories` |
| POST | `/search/image` | Sanctum | `SearchController@byImage` | `cbir_searches`, `cbir_search_results` |
| POST | `/cbir/search` | Sanctum | `CBIRController@searchSimilar` | `cbir_searches`, `cbir_search_results`, `catalogs`, `packages` |
| POST | `/cbir/arithmetic` | Sanctum | `CBIRController@arithmeticSearch` | `cbir_searches`, `cbir_search_results` |
| GET | `/cbir/stats` | Publik | `CBIRController@getStats` | `cbir_searches`, `cbir_search_results` |
| GET | `/cbir/health` | Publik | `CBIRController@healthCheck` | — |

### 5.10 Wallet, riwayat, laporan

| Method | Path | Auth | Controller | Tabel |
|---|---|---|---|---|
| GET | `/wallet` | Sanctum | `WalletController@getWalletData` | `users`, `histories`, `transactions` |
| GET | `/wallet/history` | Sanctum | `WalletController@getHistory` | `histories`, `transactions`, `orders` |
| GET | `/histories` | Sanctum | `HistoryController@index` | `histories` |
| GET | `/transactions` | Sanctum | `TransactionController@index` | `transactions`, `orders` |
| GET | `/transactions/{id}` | Sanctum | `TransactionController@show` | `transactions`, `orders` |
| POST | `/reports` | Sanctum | `ReportController@store` | `reports` |
| GET | `/reports` | Sanctum | `ReportController@index` | `reports` |
| GET | `/reports/{id}/pdf` | Sanctum | `ReportController@downloadPdf` | `reports` |

## 6. Upload file

- Gunakan `multipart/form-data`.
- Field contoh: `avatar`, `ktp_photo`, `selfie`, `proof`, `photos[]`.
- Ukuran dan MIME divalidasi backend. Client sebaiknya membatasi ukuran sebelum upload.
- Tampilkan progress dan tangani timeout 30 detik.
- Jangan mengirim base64 untuk file besar.

## 7. Idempotensi dan retry

- `GET` boleh retry otomatis terbatas.
- `POST` pembayaran/order **tidak boleh** retry otomatis tanpa idempotency key; backend belum tentu mendukung.
- Jika timeout setelah `POST /bookings`, cek daftar order sebelum membuat ulang.
- Untuk aksi sensitif, gunakan tombol disabled saat proses.

## 8. Endpoint yang tidak boleh dipakai

| Client path | Alasan |
|---|---|
| `/login`, `/register`, `/forgot-password`, `/reset-password` | Tidak terdaftar di route API saat ini |
| `/Favorite*` dengan casing selain persis `/Favorite` | Laravel case-sensitive; gunakan `/Favorite` |
| `/profile/ktp` GET | Yang tersedia `PUT` |
| `/bookings/{id}/qris` GET | Yang tersedia `POST` |

**Catatan:** `/messages/calls*` **bukan** endpoint yang dilarang — lihat §5.6. Dokumentasi lama yang menyebut endpoint ini tidak ada sudah tidak berlaku.

Lihat [API Endpoint Map](../06-reference/API-ENDPOINT-MAP.md) untuk pemetaan 147 konstanta client.
