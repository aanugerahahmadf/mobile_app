# Navigasi dan Peta Route

Sumber utama: `lib/Core/Router/AppRouter/AppRouter.dart`.

## 1. Shell utama

`StatefulShellRoute.indexedStack` memiliki **5 branch**, tetapi `MainShell` hanya menampilkan **4 tab**:

| Index branch | Path | Tab terlihat | Layar |
|---|---|---|---|
| 0 | `/home` | Home | `HomeScreen` |
| 1 | `/orders` | Pesanan | `OrderHistoryScreen` |
| 2 | `/chat-list` | **Tidak** | `ChatListScreen` |
| 3 | `/cart` | Keranjang | `CartScreen` |
| 4 | `/profile` | Profil | `ProfileScreen` |

> Branch chat tetap hidup dan dapat dibuka lewat `context.go('/chat-list')` atau push notification, tetapi tidak memiliki tombol bottom navigation.

```mermaid
flowchart TD
  A[/startup] --> B[/landing]
  B -->|login/guest| C{Shell}
  C --> H[/home]
  C --> O[/orders]
  C --> K[/chat-list]
  C --> T[/cart]
  C --> P[/profile]
  H --> CAT[/catalog]
  CAT --> DET[/catalog/:id]
  DET --> CART[/cart]
  CART --> CHK[/checkout]
  CHK --> PAY[/payment/:orderId]
  PAY --> PM[/payment-method/:orderId]
  O --> OD[/order/:id]
  K --> CD[/chat/:id]
  P --> SET[/settings]
```

## 2. Redirect dan onboarding

- `initialLocation: /startup`.
- `redirect` membaca `SharedPreferences.onboarding_seen`.
- Jika `onboarding_seen == false` dan lokasi bukan `/startup`, bukan `/landing`, maka diarahkan ke `/landing`.
- `/landing` sengaja dikecualikan agar `context.go('/home')` setelah login tidak memantul kembali.
- `LandingScreen` menandai `onboarding_seen = true` saat pengguna melanjutkan (login sukses atau guest).
- `OnboardingScreen` ada tetapi **tidak terdaftar** sebagai route.

## 3. Route lengkap

| Path | Layar | Catatan |
|---|---|---|
| `/startup` | `StartupScreen` | Preload katalog/kategori, non-blocking |
| `/landing` | `LandingScreen` | Login/register/guest |
| `/home` | `HomeScreen` | Branch 0 |
| `/orders` | `OrderHistoryScreen` | Branch 1 |
| `/chat-list` | `ChatListScreen` | Branch 2, tanpa tab |
| `/cart` | `CartScreen` | Branch 3 |
| `/profile` | `ProfileScreen` | Branch 4 |
| `/catalog/:id` | `CatalogDetailScreen` | Path param `id` |
| `/cbir-result` | `CbirResultScreen` | Hasil pencarian gambar |
| `/checkout` | `CheckoutScreen` | Extra: `type`, `id`, `tier_id` |
| `/order/:id` | `OrderDetailScreen` | Path param `id` |
| `/chat/:id` | `ChatDetailScreen` | Extra: `cs_category`, `guestId`/`guest_id` |
| `/notifications` | `NotificationScreen` | Daftar |
| `/notification/:id` | `NotificationDetailScreen` | Extra wajib `NotificationModel`; fallback ke daftar |
| `/notification-settings` | `NotificationSettingsScreen` | Preferensi lokal |
| `/password-and-security` | `PasswordAndSecurityScreen` | Hub keamanan |
| `/change-password` | `ChangePasswordScreen` | |
| `/two-factor-settings` | `TwoFactorSettingsScreen` | Dari pengaturan |
| `/two-factor-setup` | `TwoFactorAuthScreen` | Alur auth, selesai ke Home |
| `/security/two-factor-setup` | `TwoFactorSetupScreen` | Dari pengaturan, kembali ke keamanan |
| `/security-question` | `SecurityQuestionScreen` | |
| `/otp-email-verification` | `OtpEmailVerificationScreen` | Extra: `email`, `purpose` |
| `/two-factor-verify` | `TwoFactorVerifyScreen` | |
| `/saved-login-info` | `SavedLoginInfoScreen` | |
| `/trusted-devices` | `TrustedDevicesScreen` | |
| `/login-activity` | `LoginActivityScreen` | |
| `/recent-emails` | `RecentEmailsScreen` | |
| `/security-checkup` | `SecurityCheckupScreen` | |
| `/search` | `SearchScreen` | Extra: `query` |
| `/edit-profile` | `EditProfileScreen` | Extra: `section` |
| `/complete-profile` | `CompleteProfileScreen` | Extra: `section` |
| `/profile-field` | `ProfileFieldScreen` | Extra: `key`, default `full_name` |
| `/face-scanner` | `FaceScannerScreen` | Kamera |
| `/document-scanner` | `DocumentScannerScreen` | Extra: `docType`, default `ktp` |
| `/my-reviews` | `MyReviewsScreen` | |
| `/write-review` | `ReviewListScreen` | Extra: `catalog_id`, `name` |
| `/catalog-rating-comments-by-user` | `CatalogRatingCommentsByUserScreen` | Extra: `user_id`, `user_name` |
| `/history` | `HistoryScreen` | Wallet history |
| `/vouchers` | `VoucherListScreen` | |
| `/vouchers/:id` | `VoucherDetailScreen` | Extra: `VoucherModel`; fallback model kosong |
| `/favorite` | `Favoritescreen` | Alias |
| `/Favorite` | `Favoritescreen` | Alias; dipakai Home |
| `/catalog` | `CatalogGridScreen` | Extra: `category_id` |
| `/terms-of-service` | `TermsOfServiceScreen` | |
| `/privacy-policy` | `PrivacyPolicyScreen` | |
| `/wedding-policy` | `WeddingPolicyScreen` | |
| `/help-center` | `HelpCenterScreen` | |
| `/legal/privacy-term` | `PrivacyAndTermScreen` | Hub legal |
| `/switch-account` | `SwitchAccountScreen` | |
| `/settings` | `SettingsScreen` | |
| `/storage-and-data` | `StorageAndDataScreen` | Subview: storage, network, quality, auto-download, proxy |
| `/language` | `LanguageScreen` | |
| `/app-lock` | `AppLockScreen` | PIN/biometric |
| `/payment/:orderId` | `PaymentInstructionScreen` | Path param `orderId` |
| `/payment-method/:orderId` | `PaymentMethodDetailScreen` | Extra wajib `PaymentMethodInfo` |
| `/payment-webview` | `PaymentWebViewScreen` | Extra: `url`, `title` |

## 4. Layar tanpa route GoRoute

Layar berikut ada di kode tetapi tidak terdaftar di `AppRouter`:

| Layar | Cara diakses saat ini | Rekomendasi |
|---|---|---|
| `OnboardingScreen` | Tidak dipakai | Daftarkan `/onboarding` atau hapus |
| `AboutScreen` | Tidak dipakai | Tambahkan ke hub legal |
| `ForgotPasswordScreen` | Tidak dipakai | Hubungkan dari login |
| `ResetPasswordScreen` | Tidak dipakai | Hubungkan setelah OTP |
| `SearchResultsScreen` | Tidak dipakai | Gabungkan ke `SearchScreen` atau daftarkan route |
| `QrisPaymentScreen` | Tidak dipakai | Ganti stub dengan alur di `PaymentMethodDetail` |
| `VirtualAccountPaymentScreen` | Tidak dipakai | Sama seperti QRIS |
| `AutoCaptureScannerScreen` | Dibuka via `CameraScanUtils` (MaterialPageRoute) | Dokumentasikan sebagai utility |
| `ScannedImageReviewScreen` | Dibuka via `CameraScanUtils` | Sama |
| `ReportSubmitScreen` | Dibuka via bottom sheet/utility | Daftarkan route atau eksplisitkan entry point |
| `Favoritescreen` | Route ada, parser otomatis melewatkan karena nama class | Sudah ter-route di `/favorite` dan `/Favorite` |
| `BiometricUnlockScreen`, `PasswordUnlockScreen`, `PinUnlockScreen` | Komponen internal `AppLockScreen` | Jangan didokumentasikan sebagai halaman mandiri |
| `StorageUsageScreen`, `NetworkUsageScreen`, `QualityScreen`, `AutoDownloadScreen`, `ProxyScreen` | Subview `StorageAndDataScreen` | Satu PRD induk |
| `StorageDataController` | Bukan layar | Jangan dibuat route |

## 5. Deep link notifikasi

`NotificationService` memanggil `appRouter.go(route)` ketika notifikasi dibuka. Route yang perlu didukung:

| Tipe notifikasi | Target ideal |
|---|---|
| Pesanan | `/order/:id` |
| Pembayaran | `/payment/:orderId` |
| Chat | `/chat/:id` |
| Katalog | `/catalog/:id` |
| Voucher | `/vouchers/:id` |
| Keamanan | `/security-checkup` atau `/login-activity` |
| Fallback | `/notifications` |

Validasi bahwa route tujuan ada dan parameter tidak null sebelum `go()`.

## 6. Aturan navigasi

1. Gunakan `context.go` untuk berpindah tab/shell; `context.push` untuk halaman detail.
2. Jangan menumpuk halaman yang sama berulang kali.
3. Setelah checkout sukses, gunakan `go` ke detail pesanan/pembayaran, bukan `push`.
4. Setelah logout, `go('/landing')` dan bersihkan stack.
5. Layar yang membutuhkan login harus menampilkan `GuestAuthPrompt` atau memicu login, bukan error mentah.
6. Route dengan `extra` wajib memiliki fallback yang aman jika `extra` null.
