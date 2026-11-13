# DESIGN.md — Kotlin Multiplatform (KMP) Client



## 1. Tujuan

- Satu codebase Kotlin untuk Android dan iOS dengan UI Compose Multiplatform.
- Kontrak API, token Sanctum, dan perilaku bisnis identik di kedua platform.
- Visual: modern glassy wedding editorial (ivory/blush/champagne/lavender), full-screen screens, floating capsule bottom bar.

## 2. Tech Stack

| Layer | Teknologi |
|---|---|
| Language | Kotlin 2.x |
| UI | Compose Multiplatform (Material 3) |
| Networking | Ktor Client + kotlinx.serialization |
| DI | Koin |
| State | ViewModel + StateFlow/SharedFlow |
| Image | Coil (via expect/actual) |
| Secure storage | Android Keystore / iOS Keychain |
| Push/Analytics | Firebase (FCM, Crashlytics, Analytics, Remote Config) |
| Build | Gradle (Kotlin DSL) |

## 3. Struktur Modul

Struktur modul KMP standar (composeApp, shared, androidApp, iosApp) dengan feature-based packages di commonMain.

## 4. Design System (Modern Glass + 3D Animation + Tri-Mode Themes)

### 4.1. Core Visual Pillars
- **Glass Modern (Glassmorphism)**:
  - Frosted glass surfaces using real-time BackdropFilter (sigma 16-24).
  - Multi-stop specular highlight borders (gradient stroke with top-left reflection highlight).
  - Translucent surfaces with soft diffuse shadows and luxury wedding ambiance.
  - Floating capsule bottom bar (CapsuleBottomBar), glass dialogs, and elevated glass cards.
- **3D Animation & Perspective Transform**:
  - Interactive 3D Perspective Tilt on cards and hero items via Matrix4.identity()..setEntry(3, 2, 0.0012)..rotateX(rotX)..rotateY(rotY).
  - Dynamic specular light glare / sheen that realistically follows touch and tilt angle.
  - Multi-plane depth parallax (Z-axis separation for text, glass surface, and decorative flower accents).
  - Smooth spring physics and fluid micro-interactions.

### 4.2. Tri-Mode Theme System (Light, Dark/Night, System Default)
- **Mode System (Default)**:
  - **Mengikuti pengaturan sistem HP secara real-time.**
  - Jika HP pengguna berada di Mode Gelap (Dark), aplikasi secara otomatis menjadi Mode Gelap.
  - Jika HP pengguna berada di Mode Terang (Light), aplikasi secara otomatis menjadi Mode Terang.
  - Perubahan mode tema di HP langsung direspons seketika via WidgetsBindingObserver.didChangePlatformBrightness().
- **Mode Light (Terang / Editorial Wedding)**:
  - Background: Soft iridescent gradient (Ivory, blush, champagne, lavender, pure white #EEF2FF -> #F8F6F7 -> #FFFFFF).
  - Glass surface: Pure crystal white frost (alpha 55-75%), border specular putih mengkilap.
- **Mode Night / Dark (Gelap / Midnight Luxury)**:
  - Background: Deep midnight obsidian & navy gradient (#0F2440 -> #1A1A2E -> #121212) dengan warm gold ambient glow.
  - Glass surface: Smoked obsidian glass (alpha 30-45%) dengan luminous edge highlight.
- Font: **Instrument Sans** (W400, W600) - asset lokal.
- Radius card 20-24dp, capsule 32dp. Padding phone 20dp, tablet 32dp.
- Full-screen screens; CapsuleBottomBar floating overlay (Home | Orders | Cart | Profile).
- Fallback tanpa blur harus tetap terbaca (low-end device, dark theme, reduce-motion, high-contrast).
- State wajib: loading, content, empty, refresh, pagination, upload, validation, unauthorized, forbidden, offline, server error.

## 5. Daftar Screen (parity Flutter → KMP)

### Auth
- `SplashScreen` → `LandingScreen` (hanya logo + tombol "Continue with Google", tanpa form login manual)
- `OtpVerificationScreen` (email/whatsapp)
- `CompleteProfileScreen` (di Features/Auth)
- `SecurityQuestionScreen`
- `TwoFactorSetupScreen`, `TwoFactorVerifyScreen`
- `GoogleSignInFlow`

### Home & Catalog
- `HomeScreen`
- `CatalogScreen`, `CatalogDetailScreen`
- `VisualSearchScreen` (CBIR upload + result)
- `CombinedCard`, `FilterSheet`

### Cart & Checkout
- `CartScreen`
- `CheckoutScreen` (wizard: Detail Acara → Info Kontak → Voucher → Metode Pembayaran → Konfirmasi)
- `VirtualAccountPaymentScreen`
- `QrisPaymentScreen`
- `PaymentInstructionScreen`

### Orders
- `OrderHistoryScreen` (tabs: all/pending/confirmed/preparing/completed/cancelled)
- `OrderDetailScreen`

### Profile & KYC
- `ProfileScreen`
- `CompleteProfileScreen`
- `KycScreen` (KTP/SIM/NPWP/Paspor)
- `FaceScanScreen`
- `SettingsScreen` (language, security, app lock, notifications, storage, delete account)

### Chat & Notification
- `ChatListScreen`, `ChatDetailScreen`
- `NotificationScreen`, `NotificationDetailScreen`

### Review & Legal
- `ReviewListScreen`, `ReviewFormScreen`
- `LegalPageScreen`, `TermsScreen`, `PrivacyScreen`

## 6. Alur Lengkap (start to end)

### 6.1 Splash & Onboarding
1. `SplashScreen` → cek `onboarding_seen` flag.
2. Jika belum → `LandingScreen` (Google login + CS icon).
3. Jika sudah → `checkAuth()` → jika token valid → `HomeScreen`, else `LandingScreen`.

### 6.2 Auth Flow (Google) — lengkap

**LandingScreen**: hanya logo + tombol "Continue with Google".

1. User tap "Continue with Google" → Firebase Google Sign-In → kirim `firebase_id_token` ke `/auth/google`.

**Alur 1 — Google Sign Up, Security Question "Iya":**
   Verify OTP -> Complete Profile -> Security Question: Menjawab Iya -> TwoFactorSetupScreen (setup 2FA) -> Landing (logoutForReauth) -> re-login "Continue with Google" -> tantangan 2FA (Otp Email Or Two Factory) -> Home

**Alur 2 — Google Sign In (terdaftar), Security Question "Iya" + 2FA aktif:**
   Continue With Google → tantangan 2FA (Otp Email Or Two Factory) → Home

**Alur 3 — Google Sign Up, Security Question "Tidak":**
   Verify OTP → CompleteProfile → Security Question: Menjawab Tidak → Landing (logoutForReauth) → re-login "Continue with Google" → Home

**Alur 4 — Google Sign In (terdaftar), Security Question "Tidak" + 2FA tidak aktif:**
   Continue With Google → Home

Backend response branches:
- `status == two_factor_required` → `AuthTwoFactorRequired` → sheet 2FA → verify → Home.
- `needs_otp == true` → kirim OTP → `OtpVerificationScreen` → verify → `CompleteProfileScreen` → `SecurityQuestionScreen`.
- `needs_completion == true` → `CompleteProfileScreen` → `SecurityQuestionScreen`.
- Security Question:
  - **Ya** → `TwoFactorSetupScreen` → kembali Landing → challenge 2FA → Home.
  - **Tidak** → `markAnswered` → Landing → Home.

### 6.3 Catalog & Visual Search
1. `HomeScreen` → `CatalogScreen` (grid + filter).
2. Tap catalog → `CatalogDetailScreen` (tiers, reviews).
3. Tap "Pesan" → `CheckoutScreen` (wizard).
4. Visual Search: upload foto → `/search/image` → result list → tap → `CatalogDetailScreen`.

### 6.4 Checkout & Payment
1. `CheckoutScreen` wizard (5 step) → submit → backend create order + transaction.
2. Jika metode VA → `VirtualAccountPaymentScreen` (nomor VA, nama, expiry, nominal).
3. Jika metode QRIS → `QrisPaymentScreen` (QR image, nominal, deadline).
4. Setelah pembayaran → `OrderHistoryScreen`.

### 6.5 Order History
1. `OrderHistoryScreen` (tabs by status).
2. Tap order → `OrderDetailScreen` (info, payment info, cancel).
3. Cancel → konfirmasi → hapus dari list.

### 6.6 Profile & KYC
1. `ProfileScreen` → edit profil, avatar, password.
2. KYC: upload KTP/SIM/NPWP/Paspor + selfie + face scan → verifikasi AI.
3. Settings: bahasa, keamanan, app lock, notifikasi, hapus akun.

### 6.7 Chat & Notification
1. `ChatListScreen` → `ChatDetailScreen` (text, attachment, call signaling).
2. FCM push → `NotificationScreen` → `NotificationDetailScreen`.

## 7. Networking & State

- Base URL berakhir `/api/`; path tanpa leading slash.
- `AuthInterceptor` + `TokenStore` (encrypted, atomic).
- 401 → single logout event via session coordinator.
- DTO nullable; mapper untuk tanggal, nominal (Long rupiah), URL media.
- `MediaUrlResolver` untuk relative `/storage/...`.

## 8. Firebase (Frontend)

- FCM (push), Crashlytics (redacted), Analytics (tanpa PII), Remote Config (feature flag), Performance Monitoring.
- Firebase bukan sumber kebenaran bisnis; Laravel tetap authoritative.

## 9. Testing

- Unit: DTO deserialization, mapper, error parser, token store.
- MockWebServer untuk login, catalog, CBIR multipart, KYC, order, payment.
- ViewModel tests (rotation/retry/double-submit).
- Compose UI test (empty/loading/error/success).
- Instrumented: camera/gallery permission, upload.
- Device test dua perangkat untuk WebRTC.

## 10. Integrasi Backend (Mobile-And-Backend)

### Auth
- `POST /api/login` (email/username + password), `POST /api/register`, `POST /api/auth/google`
- OTP: `POST /api/auth/send-otp`, `/auth/verify-otp`
- 2FA: `/auth/two-factor/verify`, `/auth/two-factor/resend`
- Profil: `GET/PUT /api/profile`, avatar, change password
- KYC: `/api/profile/{ktp|sim|npwp|passport}` + photo, selfie, face-scan

### Catalog & Search
- `GET /api/catalog`, `/catalog/{id}`, `/catalog/{id}/tiers`
- `GET /api/categories`, `/categories-with-packages`
- `GET /api/search`, `POST /api/search/image` (CBIR multipart)

### Cart & Favorite
- `/api/cart`, `/api/wishlist` → `/api/favorite` (renamed)
- Voucher: `/api/vouchers`, `/api/vouchers/validate`, `/api/vouchers/{id}/claim`

### Orders & Payment
- `POST /api/orders` (create), `GET /api/orders`, `GET /api/orders/{id}`
- Payment: `/orders/{id}/payment-info`, `/virtual-account`, `/qris`, `/upload-proof`, `/confirm-payment`, `/cancel`
- PaymentWindow: displayAmount = latest_transaction.total_amount ?? order.total_price; deadline = VA expiry ?? created_at + 24h.

### Chat & Notification
- Conversations, messages, attachments, FCM token, notifications.

### Media
- `MediaUrlResolver`: relative `/storage/...` resolved against Laravel origin.

## 11. Catatan

- Semua string brand "Timeless Florals" (English).
- Endpoint `/wishlist` → `/favorite` (sudah di-rename di backend).
- Model `Wishlist` → `Favorite`.
- Payment VA/QRIS: screen `VirtualAccountPaymentScreen`, `QrisPaymentScreen`.
- CompleteProfile berada di `Features/Auth`, bukan `Features/Profile`.