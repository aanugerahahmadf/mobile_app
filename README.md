# Wedding Flower Decoration - Mobile App

A Flutter-based mobile application for wedding flower decoration services, featuring CBIR (Content-Based Image Retrieval) for searching decorations by image, real-time face verification using ML Kit, multi-language support (10 languages), and complete order management.

## Features

- **Authentication** — Email/password, Google Sign-In, Facebook, Apple, biometric login
- **CBIR Search** — Search flower packages by uploading or capturing images
- **Catalog** — Browse flower packages and products with filtering and search
- **Order Management** — Cart, checkout, payment (Midtrans), order history
- **Face Verification** — Real-time face scanning with ML Kit for identity verification in profile
- **Profile** — Edit profile with first/middle/last name auto-sync, identity fields (NIK, KTP photo, birth place, birth date, country, address), profile completion bar
- **Multi-language** — 10 languages: Indonesian, English, Arabic, Spanish, Japanese, Korean, Malay, Thai, Vietnamese, Chinese
- **Notifications** — Firebase Cloud Messaging, push notifications for orders, chat, promotions
- **Chat** — Real-time chat with admin via Pusher
- **Reviews & Ratings** — Product and package reviews
- **Wishlist** — Save favorite items
- **Vouchers** — Claim and apply discount vouchers
- **Dark/Light Theme** — Customizable app theme
- **Biometric Lock** — Fingerprint/Face ID app unlock

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart) |
| State Management | Riverpod (flutter_riverpod) |
| Routing | go_router |
| Localization | easy_localization |
| HTTP Client | Dio |
| Face Detection | google_mlkit_face_detection |
| Camera | camera (for face scanner) |
| Image Picker | image_picker |
| Push Notifications | Firebase Cloud Messaging |
| Local Notifications | flutter_local_notifications |
| Real-time Chat | pusher_channels_flutter |
| Biometric Auth | local_auth |
| Secure Storage | flutter_secure_storage |
| Social Auth | google_sign_in, flutter_facebook_auth, sign_in_with_apple |
| Maps | geolocator |
| File Management | file_picker, open_file |
| Payments | Midtrans (via WebView) |
| Backend | Laravel (separate repository) |

## Requirements

- Flutter SDK >= 3.0
- Dart SDK >= 3.0
- Android SDK / Xcode
- Firebase project (for push notifications)

## Setup

### 1. Clone & Install

```bash
git clone <repo-url>
cd mobile_app
flutter pub get
```

### 2. Firebase Configuration

Place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the project root.

### 3. Environment Variables

Create `.env` in the project root:

```env
API_BASE_URL=https://your-api-url.com
CBIR_ENDPOINT=https://your-cbir-endpoint.com
PUSHER_APP_ID=your-pusher-app-id
PUSHER_KEY=your-pusher-key
PUSHER_CLUSTER=your-pusher-cluster
```

### 4. Run

```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── api/           # Dio client, API endpoints
│   ├── constants/     # Colors, sizes, text styles, shadows
│   ├── errors/        # Failure models
│   ├── models/        # Shared models (API response, pagination)
│   ├── providers/     # Global providers (theme)
│   ├── router/        # App router with go_router
│   ├── theme/         # App theme definitions
│   ├── utils/         # Validators, formatters
│   └── widgets/       # Shared widgets (buttons, text fields, etc.)
├── features/
│   ├── auth/          # Login, register, forgot/reset password, OTP
│   ├── cart/          # Shopping cart
│   ├── catalog/       # Product & package catalog
│   ├── cbir/          # Image-based search
│   ├── chat/          # Real-time admin chat
│   ├── history/       # Order history
│   ├── home/          # Home page, main shell
│   ├── legal/         # Privacy, terms, about, help center
│   ├── notification/  # Push notifications
│   ├── onboarding/    # First-run onboarding
│   ├── order/         # Checkout, order detail, order history
│   ├── payment/       # Midtrans payment WebView
│   ├── profile/       # Profile, edit profile, settings, face scanner
│   ├── review/        # Reviews & ratings
│   ├── search/        # Global search
│   ├── splash/        # Splash screen, landing page
│   ├── voucher/       # Discount vouchers
│   └── wishlist/      # Favorites
├── main.dart
└── firebase_options.dart
assets/
├── translations/      # 10 JSON language files
├── images/            # App images
└── animations/        # Lottie animations
```

## Translations

Language files are in `assets/translations/`:

| File | Language |
|------|----------|
| id.json | Bahasa Indonesia |
| en.json | English |
| ar.json | العربية |
| es.json | Español |
| ja.json | 日本語 |
| ko.json | 한국어 |
| ms.json | Bahasa Melayu |
| th.json | ไทย |
| vi.json | Tiếng Việt |
| zh.json | 中文 |

## Testing

```bash
flutter test
flutter analyze
```

## Build

```bash
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

## License

All rights reserved.
