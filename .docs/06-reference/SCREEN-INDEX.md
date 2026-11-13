# Indeks Layar

Total **77 layar** dari 19 fitur, diverifikasi 6 November 2026.

Setiap layar memiliki PRD di `.docs/screens/` dan skill di `.skills/screens/`.

## Ringkasan per fitur

| Fitur | Jumlah layar | Folder |
|---|---|---|
| Auth & Keamanan | 12 | [`screens/auth/`](../screens/auth/) |
| Keranjang | 1 | [`screens/cart/`](../screens/cart/) |
| Katalog | 2 | [`screens/catalog/`](../screens/catalog/) |
| Pencarian Gambar | 1 | [`screens/cbir/`](../screens/cbir/) |
| Chat & Panggilan | 2 | [`screens/chat/`](../screens/chat/) |
| Favorit | 1 | [`screens/favorite/`](../screens/favorite/) |
| Riwayat | 1 | [`screens/history/`](../screens/history/) |
| Home | 1 | [`screens/home/`](../screens/home/) |
| Legal & Bantuan | 6 | [`screens/legal/`](../screens/legal/) |
| Notifikasi | 2 | [`screens/notification/`](../screens/notification/) |
| Onboarding | 1 | [`screens/onboarding/`](../screens/onboarding/) |
| Pesanan | 3 | [`screens/order/`](../screens/order/) |
| Pembayaran | 5 | [`screens/payment/`](../screens/payment/) |
| Profil & Pengaturan | 30 | [`screens/profile/`](../screens/profile/) |
| Laporan | 1 | [`screens/report/`](../screens/report/) |
| Ulasan | 2 | [`screens/review/`](../screens/review/) |
| Pencarian | 2 | [`screens/search/`](../screens/search/) |
| Splash & Landing | 2 | [`screens/splash/`](../screens/splash/) |
| Voucher | 2 | [`screens/voucher/`](../screens/voucher/) |

## Daftar layar

| # | Fitur | Layar | Route | Akses | API | PRD | Skill |
|---|---|---|---|---|---|---|---|
| 1 | Auth & Keamanan | `AppLockScreen` | `/app-lock` | Sanctum + lokal | 6 | [app-lock.md](../screens/auth/app-lock.md) | [SKILL.md](../../.skills/screens/auth/app-lock/SKILL.md) |
| 2 | Auth & Keamanan | `BiometricUnlockScreen` | — | Lokal | 0 | [biometric-unlock.md](../screens/auth/biometric-unlock.md) | [SKILL.md](../../.skills/screens/auth/biometric-unlock/SKILL.md) |
| 3 | Auth & Keamanan | `PasswordUnlockScreen` | — | Lokal | 0 | [password-unlock.md](../screens/auth/password-unlock.md) | [SKILL.md](../../.skills/screens/auth/password-unlock/SKILL.md) |
| 4 | Auth & Keamanan | `PinUnlockScreen` | — | Lokal | 0 | [pin-unlock.md](../screens/auth/pin-unlock.md) | [SKILL.md](../../.skills/screens/auth/pin-unlock/SKILL.md) |
| 5 | Auth & Keamanan | `CompleteProfileScreen` | `/complete-profile` | Sanctum | 14 | [complete-profile.md](../screens/auth/complete-profile.md) | [SKILL.md](../../.skills/screens/auth/complete-profile/SKILL.md) |
| 6 | Auth & Keamanan | `ForgotPasswordScreen` | — | Publik (blocked) | 1 | [forgot-password.md](../screens/auth/forgot-password.md) | [SKILL.md](../../.skills/screens/auth/forgot-password/SKILL.md) |
| 7 | Auth & Keamanan | `OtpEmailVerificationScreen` | `/otp-email-verification` | Sanctum | 2 | [otp-email-verification.md](../screens/auth/otp-email-verification.md) | [SKILL.md](../../.skills/screens/auth/otp-email-verification/SKILL.md) |
| 8 | Auth & Keamanan | `ResetPasswordScreen` | — | Publik (blocked) | 1 | [reset-password.md](../screens/auth/reset-password.md) | [SKILL.md](../../.skills/screens/auth/reset-password/SKILL.md) |
| 9 | Auth & Keamanan | `SecurityQuestionScreen` | `/security-question` | Sanctum | 0 | [security-question.md](../screens/auth/security-question.md) | [SKILL.md](../../.skills/screens/auth/security-question/SKILL.md) |
| 10 | Auth & Keamanan | `SwitchAccountScreen` | `/switch-account` | Lokal | 1 | [switch-account.md](../screens/auth/switch-account.md) | [SKILL.md](../../.skills/screens/auth/switch-account/SKILL.md) |
| 11 | Auth & Keamanan | `TwoFactorAuthScreen` | `/two-factor-setup` | Sanctum | 5 | [two-factor-auth.md](../screens/auth/two-factor-auth.md) | [SKILL.md](../../.skills/screens/auth/two-factor-auth/SKILL.md) |
| 12 | Auth & Keamanan | `TwoFactorVerifyScreen` | `/two-factor-verify` | Publik (challenge) | 2 | [two-factor-verify.md](../screens/auth/two-factor-verify.md) | [SKILL.md](../../.skills/screens/auth/two-factor-verify/SKILL.md) |
| 13 | Keranjang | `CartScreen` | `/cart` | Sanctum | 5 | [cart.md](../screens/cart/cart.md) | [SKILL.md](../../.skills/screens/cart/cart/SKILL.md) |
| 14 | Katalog | `CatalogDetailScreen` | `/catalog/:id` | Guest + Sanctum | 9 | [catalog-detail.md](../screens/catalog/catalog-detail.md) | [SKILL.md](../../.skills/screens/catalog/catalog-detail/SKILL.md) |
| 15 | Katalog | `CatalogGridScreen` | `/catalog` | Guest + Sanctum | 3 | [catalog-grid.md](../screens/catalog/catalog-grid.md) | [SKILL.md](../../.skills/screens/catalog/catalog-grid/SKILL.md) |
| 16 | Pencarian Gambar | `CbirResultScreen` | `/cbir-result` | Sanctum | 4 | [cbir-result.md](../screens/cbir/cbir-result.md) | [SKILL.md](../../.skills/screens/cbir/cbir-result/SKILL.md) |
| 17 | Chat & Panggilan | `ChatListScreen` | `/chat-list` | Guest + Sanctum | 4 | [chat-list.md](../screens/chat/chat-list.md) | [SKILL.md](../../.skills/screens/chat/chat-list/SKILL.md) |
| 18 | Chat & Panggilan | `ChatDetailScreen` | `/chat/:id` | Guest + Sanctum | 25 | [chat-detail.md](../screens/chat/chat-detail.md) | [SKILL.md](../../.skills/screens/chat/chat-detail/SKILL.md) |
| 19 | Favorit | `Favoritescreen` | `/favorite dan /Favorite` | Sanctum | 3 | [favorite.md](../screens/favorite/favorite.md) | [SKILL.md](../../.skills/screens/favorite/favorite/SKILL.md) |
| 20 | Riwayat | `HistoryScreen` | `/history` | Sanctum | 2 | [history.md](../screens/history/history.md) | [SKILL.md](../../.skills/screens/history/history/SKILL.md) |
| 21 | Home | `HomeScreen` | `/home` | Guest + Sanctum | 3 | [home.md](../screens/home/home.md) | [SKILL.md](../../.skills/screens/home/home/SKILL.md) |
| 22 | Legal & Bantuan | `AboutScreen` | — | Publik | 1 | [about.md](../screens/legal/about.md) | [SKILL.md](../../.skills/screens/legal/about/SKILL.md) |
| 23 | Legal & Bantuan | `HelpCenterScreen` | `/help-center` | Publik | 1 | [help-center.md](../screens/legal/help-center.md) | [SKILL.md](../../.skills/screens/legal/help-center/SKILL.md) |
| 24 | Legal & Bantuan | `PrivacyAndTermScreen` | `/legal/privacy-term` | Publik | 0 | [privacy-term.md](../screens/legal/privacy-term.md) | [SKILL.md](../../.skills/screens/legal/privacy-term/SKILL.md) |
| 25 | Legal & Bantuan | `PrivacyPolicyScreen` | `/privacy-policy` | Publik | 1 | [privacy-policy.md](../screens/legal/privacy-policy.md) | [SKILL.md](../../.skills/screens/legal/privacy-policy/SKILL.md) |
| 26 | Legal & Bantuan | `TermsOfServiceScreen` | `/terms-of-service` | Publik | 1 | [terms-of-service.md](../screens/legal/terms-of-service.md) | [SKILL.md](../../.skills/screens/legal/terms-of-service/SKILL.md) |
| 27 | Legal & Bantuan | `WeddingPolicyScreen` | `/wedding-policy` | Publik | 1 | [wedding-policy.md](../screens/legal/wedding-policy.md) | [SKILL.md](../../.skills/screens/legal/wedding-policy/SKILL.md) |
| 28 | Notifikasi | `NotificationDetailScreen` | `/notification/:id` | Sanctum | 2 | [notification-detail.md](../screens/notification/notification-detail.md) | [SKILL.md](../../.skills/screens/notification/notification-detail/SKILL.md) |
| 29 | Notifikasi | `NotificationScreen` | `/notifications` | Sanctum | 6 | [notification.md](../screens/notification/notification.md) | [SKILL.md](../../.skills/screens/notification/notification/SKILL.md) |
| 30 | Onboarding | `OnboardingScreen` | — | Publik | 0 | [onboarding.md](../screens/onboarding/onboarding.md) | [SKILL.md](../../.skills/screens/onboarding/onboarding/SKILL.md) |
| 31 | Pesanan | `CheckoutScreen` | `/checkout` | Sanctum | 5 | [checkout.md](../screens/order/checkout.md) | [SKILL.md](../../.skills/screens/order/checkout/SKILL.md) |
| 32 | Pesanan | `OrderDetailScreen` | `/order/:id` | Sanctum | 7 | [order-detail.md](../screens/order/order-detail.md) | [SKILL.md](../../.skills/screens/order/order-detail/SKILL.md) |
| 33 | Pesanan | `OrderHistoryScreen` | `/orders` | Sanctum | 6 | [order-history.md](../screens/order/order-history.md) | [SKILL.md](../../.skills/screens/order/order-history/SKILL.md) |
| 34 | Pembayaran | `PaymentInstructionScreen` | `/payment/:orderId` | Sanctum | 8 | [payment-instruction.md](../screens/payment/payment-instruction.md) | [SKILL.md](../../.skills/screens/payment/payment-instruction/SKILL.md) |
| 35 | Pembayaran | `PaymentMethodDetailScreen` | `/payment-method/:orderId` | Sanctum | 8 | [payment-method-detail.md](../screens/payment/payment-method-detail.md) | [SKILL.md](../../.skills/screens/payment/payment-method-detail/SKILL.md) |
| 36 | Pembayaran | `PaymentWebViewScreen` | `/payment-webview` | Sanctum | 0 | [payment-webview.md](../screens/payment/payment-webview.md) | [SKILL.md](../../.skills/screens/payment/payment-webview/SKILL.md) |
| 37 | Pembayaran | `QrisPaymentScreen` | — | Sanctum | 4 | [qris-payment.md](../screens/payment/qris-payment.md) | [SKILL.md](../../.skills/screens/payment/qris-payment/SKILL.md) |
| 38 | Pembayaran | `VirtualAccountPaymentScreen` | — | Sanctum | 4 | [virtual-account-payment.md](../screens/payment/virtual-account-payment.md) | [SKILL.md](../../.skills/screens/payment/virtual-account-payment/SKILL.md) |
| 39 | Profil & Pengaturan | `ProfileScreen` | `/profile` | Sanctum | 5 | [profile.md](../screens/profile/profile.md) | [SKILL.md](../../.skills/screens/profile/profile/SKILL.md) |
| 40 | Profil & Pengaturan | `EditProfileScreen` | `/edit-profile` | Sanctum | 10 | [edit-profile.md](../screens/profile/edit-profile.md) | [SKILL.md](../../.skills/screens/profile/edit-profile/SKILL.md) |
| 41 | Profil & Pengaturan | `ProfileFieldScreen` | `/profile-field` | Sanctum | 4 | [profile-field.md](../screens/profile/profile-field.md) | [SKILL.md](../../.skills/screens/profile/profile-field/SKILL.md) |
| 42 | Profil & Pengaturan | `DocumentScannerScreen` | `/document-scanner` | Sanctum | 0 | [document-scanner.md](../screens/profile/document-scanner.md) | [SKILL.md](../../.skills/screens/profile/document-scanner/SKILL.md) |
| 43 | Profil & Pengaturan | `FaceScannerScreen` | `/face-scanner` | Sanctum | 0 | [face-scanner.md](../screens/profile/face-scanner.md) | [SKILL.md](../../.skills/screens/profile/face-scanner/SKILL.md) |
| 44 | Profil & Pengaturan | `AutoCaptureScannerScreen` | — | Lokal | 0 | [auto-capture-scanner.md](../screens/profile/auto-capture-scanner.md) | [SKILL.md](../../.skills/screens/profile/auto-capture-scanner/SKILL.md) |
| 45 | Profil & Pengaturan | `ScannedImageReviewScreen` | — | Lokal | 0 | [scanned-image-review.md](../screens/profile/scanned-image-review.md) | [SKILL.md](../../.skills/screens/profile/scanned-image-review/SKILL.md) |
| 46 | Profil & Pengaturan | `LanguageScreen` | `/language` | Publik | 0 | [language.md](../screens/profile/language.md) | [SKILL.md](../../.skills/screens/profile/language/SKILL.md) |
| 47 | Profil & Pengaturan | `NotificationSettingsScreen` | `/notification-settings` | Sanctum | 0 | [notification-settings.md](../screens/profile/notification-settings.md) | [SKILL.md](../../.skills/screens/profile/notification-settings/SKILL.md) |
| 48 | Profil & Pengaturan | `PasswordAndSecurityScreen` | `/password-and-security` | Sanctum | 5 | [password-and-security.md](../screens/profile/password-and-security.md) | [SKILL.md](../../.skills/screens/profile/password-and-security/SKILL.md) |
| 49 | Profil & Pengaturan | `RecentEmailsScreen` | `/recent-emails` | Sanctum | 3 | [recent-emails.md](../screens/profile/recent-emails.md) | [SKILL.md](../../.skills/screens/profile/recent-emails/SKILL.md) |
| 50 | Profil & Pengaturan | `SecurityCheckupScreen` | `/security-checkup` | Sanctum | 6 | [security-checkup.md](../screens/profile/security-checkup.md) | [SKILL.md](../../.skills/screens/profile/security-checkup/SKILL.md) |
| 51 | Profil & Pengaturan | `SignInActivityScreen` | `/login-activity` | Sanctum | 3 | [login-activity.md](../screens/profile/login-activity.md) | [SKILL.md](../../.skills/screens/profile/login-activity/SKILL.md) |
| 52 | Profil & Pengaturan | `ChangePasswordScreen` | `/change-password` | Sanctum | 2 | [change-password.md](../screens/profile/change-password.md) | [SKILL.md](../../.skills/screens/profile/change-password/SKILL.md) |
| 53 | Profil & Pengaturan | `SavedSignInInfoScreen` | `/saved-login-info` | Sanctum | 2 | [saved-login-info.md](../screens/profile/saved-login-info.md) | [SKILL.md](../../.skills/screens/profile/saved-login-info/SKILL.md) |
| 54 | Profil & Pengaturan | `TrustedDevicesScreen` | `/trusted-devices` | Sanctum | 7 | [trusted-devices.md](../screens/profile/trusted-devices.md) | [SKILL.md](../../.skills/screens/profile/trusted-devices/SKILL.md) |
| 55 | Profil & Pengaturan | `TwoFactorSettingsScreen` | `/two-factor-settings` | Sanctum | 5 | [two-factor-settings.md](../screens/profile/two-factor-settings.md) | [SKILL.md](../../.skills/screens/profile/two-factor-settings/SKILL.md) |
| 56 | Profil & Pengaturan | `TwoFactorSetupScreen` | `/security/two-factor-setup` | Sanctum | 5 | [two-factor-setup.md](../screens/profile/two-factor-setup.md) | [SKILL.md](../../.skills/screens/profile/two-factor-setup/SKILL.md) |
| 57 | Profil & Pengaturan | `SettingsScreen` | `/settings` | Sanctum | 4 | [settings.md](../screens/profile/settings.md) | [SKILL.md](../../.skills/screens/profile/settings/SKILL.md) |
| 58 | Profil & Pengaturan | `StorageAndDataScreen` | `/storage-and-data` | Lokal | 0 | [storage-and-data.md](../screens/profile/storage-and-data.md) | [SKILL.md](../../.skills/screens/profile/storage-and-data/SKILL.md) |
| 59 | Profil & Pengaturan | `StorageUsageSettingsScreen` | — | Lokal | 0 | [storage-usage-settings.md](../screens/profile/storage-usage-settings.md) | [SKILL.md](../../.skills/screens/profile/storage-usage-settings/SKILL.md) |
| 60 | Profil & Pengaturan | `NetworkUsageSettingsScreen` | — | Lokal | 0 | [network-usage-settings.md](../screens/profile/network-usage-settings.md) | [SKILL.md](../../.skills/screens/profile/network-usage-settings/SKILL.md) |
| 61 | Profil & Pengaturan | `DownloadQualityScreen` | — | Lokal | 0 | [download-quality.md](../screens/profile/download-quality.md) | [SKILL.md](../../.skills/screens/profile/download-quality/SKILL.md) |
| 62 | Profil & Pengaturan | `UploadQualityScreen` | — | Lokal | 0 | [upload-quality.md](../screens/profile/upload-quality.md) | [SKILL.md](../../.skills/screens/profile/upload-quality/SKILL.md) |
| 63 | Profil & Pengaturan | `AutoDownloadScreen` | — | Lokal | 0 | [auto-download.md](../screens/profile/auto-download.md) | [SKILL.md](../../.skills/screens/profile/auto-download/SKILL.md) |
| 64 | Profil & Pengaturan | `AudioAutoDownloadScreen` | — | Lokal | 0 | [audio-auto-download.md](../screens/profile/audio-auto-download.md) | [SKILL.md](../../.skills/screens/profile/audio-auto-download/SKILL.md) |
| 65 | Profil & Pengaturan | `DocumentAutoDownloadScreen` | — | Lokal | 0 | [document-auto-download.md](../screens/profile/document-auto-download.md) | [SKILL.md](../../.skills/screens/profile/document-auto-download/SKILL.md) |
| 66 | Profil & Pengaturan | `PhotoAutoDownloadScreen` | — | Lokal | 0 | [photo-auto-download.md](../screens/profile/photo-auto-download.md) | [SKILL.md](../../.skills/screens/profile/photo-auto-download/SKILL.md) |
| 67 | Profil & Pengaturan | `VideoAutoDownloadScreen` | — | Lokal | 0 | [video-auto-download.md](../screens/profile/video-auto-download.md) | [SKILL.md](../../.skills/screens/profile/video-auto-download/SKILL.md) |
| 68 | Profil & Pengaturan | `ProxySettingsScreen` | — | Lokal | 0 | [proxy-settings.md](../screens/profile/proxy-settings.md) | [SKILL.md](../../.skills/screens/profile/proxy-settings/SKILL.md) |
| 69 | Laporan | `ReportSubmitScreen` | — | Sanctum | 2 | [report-submit.md](../screens/report/report-submit.md) | [SKILL.md](../../.skills/screens/report/report-submit/SKILL.md) |
| 70 | Ulasan | `MyReviewsScreen` | `/my-reviews` | Sanctum | 4 | [my-reviews.md](../screens/review/my-reviews.md) | [SKILL.md](../../.skills/screens/review/my-reviews/SKILL.md) |
| 71 | Ulasan | `ReviewListScreen` | `/write-review` | Sanctum | 7 | [review-list.md](../screens/review/review-list.md) | [SKILL.md](../../.skills/screens/review/review-list/SKILL.md) |
| 72 | Pencarian | `SearchResultsScreen` | — | Guest + Sanctum | 1 | [search-results.md](../screens/search/search-results.md) | [SKILL.md](../../.skills/screens/search/search-results/SKILL.md) |
| 73 | Pencarian | `SearchScreen` | `/search` | Guest + Sanctum | 2 | [search.md](../screens/search/search.md) | [SKILL.md](../../.skills/screens/search/search/SKILL.md) |
| 74 | Splash & Landing | `LandingScreen` | `/landing` | Publik | 1 | [landing.md](../screens/splash/landing.md) | [SKILL.md](../../.skills/screens/splash/landing/SKILL.md) |
| 75 | Splash & Landing | `StartupScreen` | `/startup` | Publik | 2 | [startup.md](../screens/splash/startup.md) | [SKILL.md](../../.skills/screens/splash/startup/SKILL.md) |
| 76 | Voucher | `VoucherDetailScreen` | `/vouchers/:id` | Sanctum | 2 | [voucher-detail.md](../screens/voucher/voucher-detail.md) | [SKILL.md](../../.skills/screens/voucher/voucher-detail/SKILL.md) |
| 77 | Voucher | `VoucherListScreen` | `/vouchers` | Sanctum | 2 | [voucher-list.md](../screens/voucher/voucher-list.md) | [SKILL.md](../../.skills/screens/voucher/voucher-list/SKILL.md) |

## Layar tanpa route

### Subview lokal / tidak memerlukan route

- `BiometricUnlockScreen` — Biometric Unlock (subview)
- `PasswordUnlockScreen` — Password Unlock (subview)
- `PinUnlockScreen` — PIN Unlock (subview)
- `StorageUsageSettingsScreen` — Penggunaan Penyimpanan
- `NetworkUsageSettingsScreen` — Penggunaan Jaringan
- `DownloadQualityScreen` — Kualitas Unduhan
- `UploadQualityScreen` — Kualitas Unggahan
- `AutoDownloadScreen` — Unduh Otomatis (induk)
- `AudioAutoDownloadScreen` — Unduh Otomatis Audio
- `DocumentAutoDownloadScreen` — Unduh Otomatis Dokumen
- `PhotoAutoDownloadScreen` — Unduh Otomatis Foto
- `VideoAutoDownloadScreen` — Unduh Otomatis Video
- `ProxySettingsScreen` — Pengaturan Proxy

### Belum terhubung ke `AppRouter` (gap)

- `ForgotPasswordScreen` — Lupa Password
- `ResetPasswordScreen` — Reset Password
- `AboutScreen` — Tentang Aplikasi
- `OnboardingScreen` — Onboarding
- `QrisPaymentScreen` — Pembayaran QRIS
- `VirtualAccountPaymentScreen` — Pembayaran Virtual Account
- `AutoCaptureScannerScreen` — Auto Capture Scanner
- `ScannedImageReviewScreen` — Review Hasil Scan
- `ReportSubmitScreen` — Kirim Laporan
- `SearchResultsScreen` — Hasil Pencarian

## Route ganda

- `/favorite` dan `/Favorite` sama-sama menuju `Favoritescreen`.
- `/notification/:id` menampilkan `NotificationDetailScreen` hanya bila `extra` adalah `NotificationModel`.

## Cara memakai

1. Pilih layar dari tabel.
2. Baca PRD untuk konteks, API, dan acceptance criteria.
3. Baca `SKILL.md` untuk langkah implementasi.
4. Verifikasi endpoint di `php artisan route:list` sebelum menulis kode.
