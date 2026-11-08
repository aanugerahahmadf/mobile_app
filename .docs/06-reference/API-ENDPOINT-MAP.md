# Peta Endpoint API → Backend → Database

Dibuat dari 147 konstanta `ApiEndpoints` dan route Laravel, diverifikasi 6 November 2026.

Base URL sudah berakhiran `/api`. Path di tabel adalah path setelah base URL.

## Ringkasan

| Status | Jumlah |
|---|---|
| Konstanta client | 147 |
| Cocok dengan route backend | 143 |
| Tidak cocok | 4 |
| Route backend user-api | 207 (non-admin) |

> Kecocokan dihitung berdasarkan method + path. Perbedaan nama parameter path 
> (`{id}` vs `{report}`) tidak dianggap mismatch selama posisi segmen sama.

## Auth & akun

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `appLock` | `GET` | `/profile/app-lock` | `AppLockController@show` | Sanctum | `users` |
| `appLock` | `PUT` | `/profile/app-lock` | `AppLockController@update` | Sanctum | `users` |
| `appLockFaceEnroll` | `POST` | `/profile/app-lock/face-enroll` | `AppLockController@faceEnroll` | Sanctum | `users`, `security_events` |
| `appLockFaceVerify` | `POST` | `/profile/app-lock/face-verify` | `AppLockController@faceVerify` | Sanctum | `users`, `security_events` |
| `appLockPin` | `POST` | `/profile/app-lock/pin` | `AppLockController@setPin` | Sanctum | `users`, `security_events` |
| `appLockPinVerify` | `POST` | `/profile/app-lock/pin/verify` | `AppLockController@verifyPin` | Sanctum | `users`, `security_events` |
| `appleLogin` | `POST` | `/auth/apple` | `AuthController@appleLogin` | Publik | `users`, `personal_access_tokens` |
| `changePassword` | `POST` | `/profile/change-password` | `ProfileController@changePassword` | Sanctum | `users` |
| `changePassword` | `PUT` | `/profile/change-password` | `ProfileController@changePassword` | Sanctum | `users` |
| `dashboard` | `GET` | `/profile/dashboard` | `ProfileController@dashboard` | Sanctum | `users`, `identity_documents`, `user_addresses` |
| `deleteAccount` | `DELETE` | `/user/account` | `AuthController@deleteAccount` | Sanctum | `users` |
| `facebookLogin` | `POST` | `/auth/facebook` | `AuthController@facebookLogin` | Publik | `users`, `personal_access_tokens` |
| `forgotPassword` | `ANY` | `/forgot-password` | `-` | Tidak ada | `users`, `password_reset_tokens` |
| `googleLogin` | `POST` | `/auth/google` | `AuthController@googleLogin` | Publik | `users`, `personal_access_tokens` |
| `login` | `ANY` | `/login` | `-` | Tidak ada | `users`, `personal_access_tokens` |
| `logout` | `POST` | `/logout` | `AuthController@logout` | Sanctum | `personal_access_tokens` |
| `profile` | `GET` | `/profile` | `ProfileController@show` | Sanctum | `users` |
| `profile` | `POST` | `/profile` | `AuthController@updateProfile` | Sanctum | `users` |
| `profile` | `PUT` | `/profile` | `ProfileController@update` | Sanctum | `users` |
| `profileAvatar` | `POST` | `/profile/avatar` | `ProfileController@updateAvatar` | Sanctum | `users`, `media` |
| `profileCompletion` | `GET` | `/profile/completion` | `ProfileController@completion` | Sanctum | `users`, `identity_documents`, `user_addresses` |
| `profileDocumentNumber` | `PUT` | `/profile/{documentType}` | `ProfileController@updateDocument` | Sanctum | `identity_documents`, `users` |
| `profileDocumentPhoto` | `POST` | `/profile/{documentType}-photo` | `ProfileController@uploadDocument` | Sanctum | `identity_documents`, `media` |
| `profileFaceScan` | `POST` | `/profile/face-scan` | `ProfileController@uploadFaceScan` | Sanctum | `users`, `identity_documents`, `media` |
| `profileKtp` | `POST` | `/profile/ktp-photo` | `ProfileController@uploadDocument` | Sanctum | `identity_documents`, `users`, `media` |
| `profileKtpNumber` | `PUT` | `/profile/ktp` | `ProfileController@updateDocument` | Sanctum | `users`, `identity_documents` |
| `profileSelfie` | `POST` | `/profile/selfie` | `ProfileController@uploadSelfie` | Sanctum | `users`, `identity_documents`, `media` |
| `register` | `ANY` | `/register` | `-` | Tidak ada | `users`, `personal_access_tokens` |
| `registerFcmToken` | `POST` | `/notifications/fcm-token` | `NotificationController@registerFcmToken` | Sanctum | `device_tokens`, `users` |
| `resetPassword` | `ANY` | `/reset-password` | `-` | Tidak ada | `users`, `password_reset_tokens` |
| `sendOtp` | `POST` | `/auth/send-otp` | `AuthController@sendOtp` | Publik | `whatsapp_otps`, `users` |
| `twoFactorResend` | `POST` | `/auth/two-factor/resend` | `AuthController@resendTwoFactorCode` | Publik | `users`, `backup_codes` |
| `twoFactorVerify` | `POST` | `/auth/two-factor/verify` | `AuthController@verifyTwoFactor` | Publik | `users`, `backup_codes` |
| `user` | `GET` | `/user` | `Closure` | Sanctum | `users` |
| `userReviews` | `GET` | `/reviews/user/{userId}` | `ReviewController@getUserPublicReviews` | Sanctum | `reviews`, `users` |
| `verifyOtp` | `POST` | `/auth/verify-otp` | `AuthController@verifyOtp` | Publik | `whatsapp_otps`, `users` |

## Katalog & beranda

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `cart` | `GET` | `/cart` | `CartController@index` | Sanctum | `carts`, `catalogs`, `packages` |
| `cartAdd` | `POST` | `/cart/add` | `CartController@store` | Sanctum | `carts`, `catalogs`, `packages` |
| `cartItem` | `PUT` | `/cart/{cart}` | `CartController@update` | Sanctum | `carts` |
| `cartItem` | `DELETE` | `/cart/{cart}` | `CartController@destroy` | Sanctum | `carts` |
| `catalog` | `GET` | `/catalog` | `CatalogController@index` | Sanctum | `catalogs`, `categories`, `packages`, `media` |
| `catalogDetail` | `GET` | `/catalog/{id}` | `CatalogController@show` | Sanctum | `catalogs`, `categories`, `packages`, `reviews`, `media` |
| `catalogFeatured` | `GET` | `/catalog/featured` | `CatalogController@featured` | Sanctum | `catalogs`, `media` |
| `catalogOnSale` | `GET` | `/catalog/on-sale` | `CatalogController@onSale` | Sanctum | `catalogs`, `discounts`, `media` |
| `catalogPublic` | `GET` | `/catalog/public` | `CatalogController@index` | Publik | `catalogs`, `categories`, `media` |
| `catalogReviewSummary` | `GET` | `/reviews/catalog/{id}/summary` | `ReviewController@getCatalogRatingSummary` | Sanctum | `reviews`, `catalogs` |
| `catalogReviews` | `GET` | `/reviews/catalog/{catalogId}` | `ReviewController@getCatalogReviews` | Sanctum | `reviews`, `review_replies`, `review_votes`, `users` |
| `catalogTiers` | `GET` | `/catalog/{id}/tiers` | `CatalogController@tiers` | Publik | `packages`, `catalogs` |
| `categories` | `GET` | `/categories` | `CategoryController@index` | Sanctum | `categories` |
| `categoriesWithPackages` | `GET` | `/categories-with-packages` | `CategoryController@withTopPackages` | Sanctum | `categories`, `packages`, `catalogs` |
| `favorite` | `GET` | `/Favorite` | `FavoriteController@index` | Sanctum | `favorites`, `packages`, `catalogs` |
| `favoriteItem` | `DELETE` | `/Favorite/{packageId}` | `FavoriteController@removeFromFavorite` | Sanctum | `favorites` |
| `favoriteToggle` | `POST` | `/Favorite/toggle` | `FavoriteController@toggle` | Sanctum | `favorites` |
| `home` | `GET` | `/home` | `HomeController@index` | Sanctum | `hero_banners`, `promotions`, `categories`, `catalogs`, `packages` |

## Pesanan & pembayaran

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `bookingCancel` | `POST` | `/bookings/{id}/cancel` | `OrderController@cancelOrder` | Sanctum | `orders`, `order_timelines` |
| `bookingDetail` | `GET` | `/bookings/{id}` | `OrderController@show` | Sanctum | `orders`, `transactions`, `order_timelines`, `order_payments` |
| `bookingDetail` | `PUT` | `/bookings/{id}` | `OrderController@updateOrder` | Sanctum | `orders`, `transactions`, `order_timelines`, `order_payments` |
| `bookingDetail` | `DELETE` | `/bookings/{id}` | `OrderController@deleteOrder` | Sanctum | `orders`, `transactions`, `order_timelines`, `order_payments` |
| `bookingPay` | `POST` | `/bookings/{id}/pay` | `OrderController@initiatePayment` | Sanctum | `orders`, `transactions`, `payment_methods`, `payment_gateways` |
| `bookingUploadProof` | `POST` | `/bookings/{id}/upload-proof` | `OrderController@uploadProof` | Sanctum | `order_payments`, `orders`, `media` |
| `bookings` | `GET` | `/bookings` | `OrderController@getOrders` | Sanctum | `orders`, `transactions`, `order_timelines`, `packages`, `catalogs`, `vouchers`, `user_vouchers` |
| `bookings` | `POST` | `/bookings` | `OrderController@createOrder` | Sanctum | `orders`, `transactions`, `order_timelines`, `packages`, `catalogs`, `vouchers`, `user_vouchers` |
| `invoiceDownload` | `GET` | `/bookings/{id}/invoice` | `OrderController@downloadInvoice` | Sanctum | `orders`, `transactions`, `order_payments` |
| `invoiceEmail` | `POST` | `/bookings/{id}/invoice/email` | `OrderController@sendInvoiceEmail` | Sanctum | `orders`, `transactions` |
| `orderConfirmPayment` | `POST` | `/bookings/{id}/confirm-payment` | `OrderController@confirmPayment` | Sanctum | `order_payments`, `orders`, `media` |
| `orderQris` | `POST` | `/bookings/{id}/qris` | `OrderController@createQris` | Sanctum | `payment_qris`, `transactions`, `banks` |
| `orderVirtualAccount` | `POST` | `/bookings/{id}/virtual-account` | `OrderController@createVirtualAccount` | Sanctum | `payment_virtual_accounts`, `transactions`, `banks` |
| `voucherClaim` | `POST` | `/vouchers/{voucher}/claim` | `VoucherController@claim` | Sanctum | `vouchers`, `user_vouchers` |
| `voucherValidate` | `POST` | `/vouchers/validate` | `VoucherController@validateVoucher` | Sanctum | `vouchers`, `discounts`, `user_vouchers` |
| `vouchers` | `GET` | `/vouchers` | `VoucherController@index` | Sanctum | `vouchers`, `discounts`, `user_vouchers` |
| `wallet` | `GET` | `/wallet` | `WalletController@getWalletData` | Sanctum | `users`, `transactions` |
| `walletHistory` | `GET` | `/wallet/history` | `WalletController@getHistory` | Sanctum | `histories`, `transactions` |

## Chat & panggilan

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `chatCallAccept` | `POST` | `/messages/calls/{token}/accept` | `ChatCallController@accept` | Sanctum | `chat_calls` |
| `chatCallActive` | `GET` | `/messages/{inboxId}/calls/active` | `ChatCallController@active` | Sanctum | `chat_calls`, `fm_inboxes` |
| `chatCallEnd` | `POST` | `/messages/calls/{token}/end` | `ChatCallController@end` | Sanctum | `chat_calls` |
| `chatCallSignal` | `POST` | `/messages/calls/{token}/signal` | `ChatCallController@signal` | Sanctum | `chat_calls` |
| `chatCallState` | `GET` | `/messages/calls/{token}` | `ChatCallController@state` | Sanctum | `chat_calls` |
| `chatCalls` | `POST` | `/messages/calls` | `ChatCallController@start` | Sanctum | `chat_calls`, `fm_inboxes`, `users` |
| `conversations` | `GET` | `/messages/conversations` | `ChatController@getConversations` | Sanctum | `fm_inboxes`, `fm_messages`, `users` |
| `guestChatCallActive` | `GET` | `/messages/guest/{inboxId}/calls/active` | `ChatCallController@active` | Publik (guest-chat) | `chat_calls`, `fm_inboxes` |
| `guestChatCallEnd` | `POST` | `/messages/guest/calls/{token}/end` | `ChatCallController@end` | Publik (guest-chat) | `chat_calls` |
| `guestChatCallSignal` | `POST` | `/messages/guest/calls/{token}/signal` | `ChatCallController@signal` | Publik (guest-chat) | `chat_calls` |
| `guestChatCallState` | `GET` | `/messages/guest/calls/{token}` | `ChatCallController@state` | Publik (guest-chat) | `chat_calls` |
| `guestChatCalls` | `POST` | `/messages/guest/calls` | `ChatCallController@start` | Publik (guest-chat) | `chat_calls`, `fm_inboxes` |
| `guestChatMessages` | `GET` | `/messages/guest/{inboxId}` | `ChatController@guestMessages` | Publik (guest-chat) | `fm_messages`, `fm_inboxes` |
| `guestChatSend` | `POST` | `/messages/guest/send` | `ChatController@guestSend` | Publik (guest-chat) | `fm_messages`, `fm_inboxes` |
| `guestChatStart` | `POST` | `/messages/guest/start` | `ChatController@guestStart` | Publik (guest-chat) | `fm_inboxes`, `fm_messages` |
| `messageDelete` | `DELETE` | `/messages/{id}/delete` | `ChatController@deleteMessage` | Sanctum | `fm_messages` |
| `messageForward` | `POST` | `/messages/{id}/forward` | `ChatController@forwardMessage` | Sanctum | `fm_messages`, `fm_inboxes` |
| `messageRate` | `POST` | `/messages/{inboxId}/rate` | `ChatController@rateInbox` | Sanctum | `fm_messages`, `fm_inboxes` |
| `messageReact` | `POST` | `/messages/{id}/react` | `ChatController@addReaction` | Sanctum | `fm_messages` |
| `messageRead` | `POST` | `/messages/{inboxId}/read` | `ChatController@markInboxAsRead` | Sanctum | `fm_messages`, `fm_inboxes` |
| `messageStar` | `POST` | `/messages/{id}/star` | `ChatController@starMessage` | Sanctum | `fm_messages` |
| `messagesSend` | `POST` | `/messages/send` | `ChatController@sendMessage` | Sanctum | `fm_messages`, `fm_inboxes` |
| `messagesStart` | `POST` | `/messages/start` | `ChatController@startConversation` | Sanctum | `fm_inboxes`, `fm_messages` |
| `unreadCount` | `GET` | `/messages/unread-count` | `ChatController@getUnreadCount` | Sanctum | `fm_messages`, `fm_inboxes` |

## Ulasan & laporan

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `myReviews` | `GET` | `/reviews/user` | `ReviewController@getUserReviews` | Sanctum | `reviews`, `catalogs`, `packages` |
| `reportPdf` | `GET` | `/reports/{report}/pdf` | `ReportController@downloadPdf` | Sanctum | `reports`, `media` |
| `reports` | `GET` | `/reports` | `ReportController@index` | Sanctum | `reports`, `media` |
| `reports` | `POST` | `/reports` | `ReportController@store` | Sanctum | `reports`, `media` |
| `review` | `PUT` | `/reviews/{id}` | `ReviewController@update` | Sanctum | `reviews`, `media` |
| `review` | `DELETE` | `/reviews/{id}` | `ReviewController@destroy` | Sanctum | `reviews`, `media` |
| `reviewDeleteReply` | `DELETE` | `/reviews/{id}/reply/{replyId}` | `ReviewController@deleteReply` | Sanctum | `review_replies` |
| `reviewReply` | `POST` | `/reviews/{id}/reply` | `ReviewController@reply` | Sanctum | `review_replies` |
| `reviewVote` | `POST` | `/reviews/{id}/vote` | `ReviewController@voteHelpful` | Sanctum | `review_votes` |
| `reviews` | `GET` | `/reviews` | `ReviewController@getAllReviews` | Sanctum | `reviews`, `orders`, `catalogs`, `packages`, `media` |
| `reviews` | `POST` | `/reviews` | `ReviewController@store` | Sanctum | `reviews`, `orders`, `catalogs`, `packages`, `media` |

## Pencarian

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `cbirArithmetic` | `POST` | `/cbir/arithmetic` | `CBIRController@arithmeticSearch` | Sanctum | `cbir_search_results` |
| `cbirArithmeticOps` | `GET` | `/cbir/arithmetic/ops` | `CBIRController@arithmeticOps` | Publik | `cbir_search_results` |
| `cbirEvaluate` | `GET` | `/cbir/evaluate` | `CBIRController@evaluate` | Publik | `cbir_searches`, `cbir_feedback` |
| `cbirHealth` | `GET` | `/cbir/health` | `CBIRController@healthCheck` | Publik | — |
| `cbirSearch` | `POST` | `/cbir/search` | `CBIRController@searchSimilar` | Sanctum | `cbir_searches`, `cbir_search_results`, `catalogs`, `packages` |
| `cbirStats` | `GET` | `/cbir/stats` | `CBIRController@getStats` | Publik | `cbir_searches`, `cbir_search_results`, `cbir_feedback` |
| `search` | `GET` | `/search` | `SearchController@byText` | Sanctum | `search_logs`, `catalogs`, `packages` |
| `searchImage` | `POST` | `/search/image` | `SearchController@byImage` | Sanctum | `search_logs`, `cbir_searches`, `cbir_search_results`, `catalogs`, `packages` |

## Notifikasi

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `notificationDelete` | `DELETE` | `/notifications/{id}` | `NotificationController@destroy` | Sanctum | `notifications` |
| `notificationRead` | `POST` | `/notifications/{id}/read` | `NotificationController@markAsRead` | Sanctum | `notifications` |
| `notificationReadAll` | `POST` | `/notifications/read-all` | `NotificationController@markAllAsRead` | Sanctum | `notifications` |
| `notificationUnreadCount` | `GET` | `/notifications/unread-count` | `NotificationController@unreadCount` | Sanctum | `notifications` |
| `notifications` | `GET` | `/notifications` | `NotificationController@index` | Sanctum | `notifications` |

## Legal

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `legalAbout` | `GET` | `/legal/about` | `LegalController@getAbout` | Publik | `legal_pages` |
| `legalHelp` | `GET` | `/legal/help` | `LegalController@getHelp` | Publik | `helps` |
| `legalPrivacy` | `GET` | `/legal/privacy` | `LegalController@getPrivacy` | Publik | `privacy_policies` |
| `legalTerms` | `GET` | `/legal/terms` | `LegalController@getTerms` | Publik | `terms_of_service` |
| `legalWeddingPolicy` | `GET` | `/legal/wedding-decoration-policy` | `LegalController@getWeddingDecorationPolicy` | Publik | `wedding_decoration_policies` |

## Keamanan

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `securityBackupCodes` | `POST` | `/security/two-factor/backup-codes` | `SecurityController@generateBackupCodes` | Sanctum | `backup_codes` |
| `securityChangeEmailSendOtp` | `POST` | `/security/change-email/send-otp` | `SecurityController@sendEmailChangeOtp` | Sanctum | `whatsapp_otps`, `users` |
| `securityChangeEmailVerifyOtp` | `POST` | `/security/change-email/verify-otp` | `SecurityController@verifyEmailChangeOtp` | Sanctum | `whatsapp_otps`, `users` |
| `securityCheckup` | `GET` | `/security/checkup` | `SecurityController@checkup` | Sanctum | `users`, `user_sessions`, `trusted_devices`, `backup_codes` |
| `securityLoginActivity` | `GET` | `/security/login-activity` | `LoginActivityController@index` | Sanctum | `user_sessions`, `sessions` |
| `securityRecentEmails` | `GET` | `/security/recent-emails` | `SecurityController@recentEmails` | Sanctum | `security_emails` |
| `securityRejectTrustedDevice` | `POST` | `/security/trusted-devices/{deviceId}/reject` | `SecurityController@rejectTrustedDevice` | Sanctum | `trusted_devices` |
| `securityRemoveAllOtherSessions` | `POST` | `/security/sessions/remove-all` | `SecurityController@removeAllOtherSessions` | Sanctum | `user_sessions`, `sessions` |
| `securityRemoveAllTrustedDevices` | `GET` | `/security/trusted-devices` | `SecurityController@trustedDevices` | Sanctum | `trusted_devices` |
| `securityRemoveAllTrustedDevices` | `DELETE` | `/security/trusted-devices` | `SecurityController@removeAllTrustedDevices` | Sanctum | `trusted_devices` |
| `securityRemoveSession` | `DELETE` | `/security/login-activity/{id}` | `LoginActivityController@destroy` | Sanctum | `user_sessions`, `sessions` |
| `securityRemoveTrustedDevice` | `DELETE` | `/security/trusted-devices/{deviceId}` | `SecurityController@removeTrustedDevice` | Sanctum | `trusted_devices` |
| `securitySavedLogin` | `GET` | `/security/saved-login` | `SecurityController@savedLoginStatus` | Sanctum | `users` |
| `securitySavedLoginToggle` | `POST` | `/security/saved-login/toggle` | `SecurityController@savedLoginToggle` | Sanctum | `users` |
| `securityTrustedDevices` | `GET` | `/security/trusted-devices` | `SecurityController@trustedDevices` | Sanctum | `trusted_devices` |
| `securityTrustedDevices` | `DELETE` | `/security/trusted-devices` | `SecurityController@removeAllTrustedDevices` | Sanctum | `trusted_devices` |
| `securityTwoFactorSetup` | `POST` | `/security/two-factor/setup` | `SecurityController@setupTwoFactor` | Sanctum | `users`, `backup_codes` |
| `securityTwoFactorSetupResend` | `POST` | `/security/two-factor/setup/resend` | `SecurityController@resendTwoFactorSetupOtp` | Sanctum | `users`, `backup_codes` |
| `securityTwoFactorSetupVerify` | `POST` | `/security/two-factor/setup/verify` | `SecurityController@verifyTwoFactorSetup` | Sanctum | `users`, `backup_codes` |
| `securityTwoFactorStatus` | `GET` | `/security/two-factor/status` | `SecurityController@twoFactorStatus` | Sanctum | `users`, `backup_codes` |
| `securityTwoFactorToggle` | `POST` | `/security/two-factor/toggle` | `SecurityController@twoFactorToggle` | Sanctum | `users`, `backup_codes` |
| `securityVerifyTrustedDevice` | `POST` | `/security/trusted-devices/{deviceId}/verify` | `SecurityController@verifyTrustedDevice` | Sanctum | `trusted_devices` |

## Wilayah & referensi

| Konstanta | Method | Path | Controller | Auth | Tabel |
|---|---|---|---|---|---|
| `dropdownOptions` | `GET` | `/dropdown-options` | `DropdownOptionController@index` | Publik | `reference_options` |
| `geoDistricts` | `GET` | `/geo/admin2` | `GeoController@admin2` | Publik | `indonesia_districts` |
| `geoPostalCodes` | `GET` | `/geo/postal-codes` | `GeoController@postalCodes` | Publik | `indonesia_villages`, `indonesia_districts` |
| `geoVillages` | `GET` | `/geo/admin3` | `GeoController@admin3` | Publik | `indonesia_villages` |
| `regionCities` | `GET` | `/regions/cities/{provinceCode}` | `RegionController@cities` | Publik | `indonesia_cities` |
| `regionDistricts` | `GET` | `/regions/districts/{cityCode}` | `RegionController@districts` | Publik | `indonesia_districts` |
| `regionProvinces` | `GET` | `/regions/provinces` | `RegionController@provinces` | Publik | `indonesia_provinces` |
| `regionVillages` | `GET` | `/regions/villages/{districtCode}` | `RegionController@villages` | Publik | `indonesia_villages` |
| `worldCities` | `GET` | `/world-regions/cities` | `WorldRegionController@cities` | Publik | `reference_options` |
| `worldCountries` | `GET` | `/world-regions/countries` | `WorldRegionController@countries` | Publik | `reference_options` |
| `worldStates` | `GET` | `/world-regions/states` | `WorldRegionController@states` | Publik | `reference_options` |

## Lainnya

| Konstanta | Method | Path | Controller | Auth |
|---|---|---|---|---|
| `conversationMessages` | `GET` | `/messages/conversations/{inboxId}` | `ChatController@getMessages` | Sanctum |
| `myReports` | `GET` | `/reports` | `ReportController@index` | Sanctum |
| `myReports` | `POST` | `/reports` | `ReportController@store` | Sanctum |

## Endpoint client tanpa route backend

| Konstanta | Path client | Catatan |
|---|---|---|
| `login` | `/login` | Rute belum terdaftar di backend. |
| `register` | `/register` | Rute belum terdaftar di backend. |
| `forgotPassword` | `/forgot-password` | Rute belum terdaftar di backend. |
| `resetPassword` | `/reset-password` | Rute belum terdaftar di backend. |

## Perbedaan casing

| Client | Backend | Dampak |
|---|---|---|
| `/favorite` | `/Favorite` | Case-sensitive di Linux |
| `/favorite/toggle` | `/Favorite/toggle` | Case-sensitive di Linux |
| `/favorite/{packageId}` | `/Favorite/{packageId}` | Case-sensitive di Linux |

## Cara memperbarui

1. Tambahkan/ubah konstanta di `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart`.
2. Tambahkan route di `routes/api/user/...` dan verifikasi dengan `php artisan route:list`.
3. Perbarui tabel ini dan PRD layar terkait.
4. Jalankan ulang generator: `python .docs/06-reference/TEMPLATES/_generate_screens.py`.
