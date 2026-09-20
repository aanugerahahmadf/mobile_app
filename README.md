# Wedding Flower Decoration — Flutter Mobile App

Mobile application for discovering, comparing, and ordering wedding flower-decor packages. It supports image-based package search (CBIR), secure accounts, real-time customer support, checkout, and Firebase-backed notifications.

> This repository contains the Flutter client and Firebase configuration. The business API is configured through `API_BASE_URL` and is maintained separately.

## Features

- **Catalog and CBIR** — browse packages/products, filter results, and search from a camera capture or gallery image.
- **Shopping flow** — cart, vouchers, checkout, payment instructions/WebView, order detail, and order history.
- **Accounts and security** — email/password and social sign-in integrations, biometrics, app lock, password recovery, OTP/2FA screens, trusted devices, and login activity.
- **Profile and verification** — profile completion, identity-document fields, document capture, selfie/face scan, and ML Kit face detection.
- **Communication** — Firebase Cloud Messaging, local notifications, Pusher chat, and notification screens.
- **Customer experience** — wishlists, reviews, global search, help/legal pages, themes, caching, animations, and accessible Flutter UI.
- **Localization** — Flutter `gen-l10n` localization with generated translations under `lib/l10n/`.
- **Firebase services** — Authentication, Analytics, Messaging, Firestore rules/indexes, Realtime Database rules, Remote Config, Data Connect assets, and Functions configuration.

## Technology

| Area | Main technologies |
| --- | --- |
| App | Flutter, Dart `^3.12.1` |
| UI/state/navigation | Material, Riverpod, `go_router`, Google Fonts, Lottie |
| Networking | Dio, `flutter_dotenv` |
| Auth and storage | Firebase Auth, Google/Apple/Facebook sign-in, `local_auth`, secure storage, Shared Preferences, Hive |
| Media and ML | Camera, Image Picker, Image Compression, ML Kit Face/Text Recognition |
| Realtime | Firebase Messaging/Analytics, local notifications, Pusher Channels |
| Quality | Flutter tests, `flutter analyze`, GitHub Actions |

## Prerequisites

- Flutter **3.47.5** (the version used by GitHub Actions)
- Dart compatible with `^3.12.1`
- Android Studio/Android SDK; Xcode for iOS builds on macOS
- Firebase project and reachable backend API for full functionality

```bash
flutter doctor
flutter --version
```

## Quick start

```bash
git clone https://github.com/aanugerahahmadf/mobile_app.git
cd mobile_app
flutter pub get
flutter gen-l10n
flutter run
```

### Environment configuration

Create `.env` in the repository root. It is ignored by Git and packaged as an application asset.

```env
# Required for a usable backend connection.
API_BASE_URL=https://api.example.com/api

# Pusher chat configuration.
PUSHER_APP_KEY=your-pusher-key
PUSHER_APP_CLUSTER=mt1

# Optional integrations.
GOOGLE_CLIENT_ID=your-google-oauth-client-id
FIREBASE_API_KEY=your-firebase-web-api-key
```

Never commit real keys, tokens, keystores, or production URLs. Keep `.env.production` and `.env.windows` local unless they contain only safe placeholders.

## Firebase setup

The configured Firebase project is `wedding-flower-decorasi`.

1. Create or select a Firebase project.
2. Register Android, iOS, and web apps with identifiers used by this project.
3. Place Android configuration in `android/app/google-services.json`.
4. Add `GoogleService-Info.plist` to the iOS Runner target using Xcode.
5. Regenerate/verify `lib/firebase_options.dart` after changing Firebase configuration.

Firebase deployment files:

| Path | Purpose |
| --- | --- |
| `firebase.json`, `.firebaserc` | Firebase project and deployment configuration |
| `firestore.rules`, `firestore.indexes.json` | Firestore security and indexes |
| `database.rules.json` | Realtime Database rules |
| `remoteconfig.template.json` | Remote Config template |
| `dataconnect/` | Data Connect schema, connector, and seed data |
| `functions/` | Cloud Functions source and package configuration |

## Development commands

```bash
# Dependencies and localization
flutter pub get
flutter gen-l10n

# Static checks and tests
flutter analyze --no-fatal-infos
flutter test

# Generated code, when editing annotated models
dart run build_runner build --delete-conflicting-outputs

# Target a test file
flutter test test/features/chat/chat_text_normalizer_test.dart
```

## Build

```bash
# Android APK for device testing/distribution
flutter build apk --release

# Android App Bundle for Google Play
flutter build appbundle --release

# Other supported platforms
flutter build web --release
flutter build ios --release
```

### Android signing

For a production release, create an untracked `android/key.properties`:

```properties
storeFile=/absolute/path/to/upload-keystore.jks
storePassword=your-store-password
keyAlias=your-key-alias
keyPassword=your-key-password
```

Without this file, Gradle can use debug signing for non-production builds. Debug-signed artifacts cannot be used to publish or update an app on Google Play.

## Project structure

Each Dart source file lives in a folder with the same base name, e.g. `app_colors/app_colors.dart`. This makes every unit ready to contain related parts, tests, or assets without changing its public path later.

```text
lib/
├── core/
│   ├── api/                 # API endpoints and Dio client
│   ├── config/              # Runtime configuration
│   ├── constants/           # Colors, sizes, text styles, shadows
│   ├── errors/              # Error codes and localized failures
│   ├── models/              # Shared response/pagination models
│   ├── providers/           # Global locale and theme state
│   ├── router/              # Routes and transitions
│   ├── services/            # Notifications and image scanning
│   ├── theme/               # Material theme configuration
│   ├── utils/               # Validators, formatters, document/cache helpers
│   └── widgets/             # Reusable UI components
├── features/
│   ├── auth/                # Login, recovery, biometrics
│   ├── cart/                # Shopping cart
│   ├── catalog/             # Packages, products, filters
│   ├── cbir/                # Content-based image retrieval
│   ├── chat/                # Customer support chat
│   ├── history/, home/, legal/, notification/, onboarding/
│   ├── order/, payment/, profile/, report/, review/, search/
│   ├── splash/, vendor/, voucher/, wishlist/
│   └── ...                  # Feature-specific data/domain/presentation layers
├── l10n/                    # ARB source and generated localization classes
└── main.dart                # Application entry point

assets/
├── animations/
├── icons/
└── images/
```

## Testing and quality gate

Run this sequence before merging or tagging a release:

```bash
flutter pub get
flutter gen-l10n
flutter analyze --no-fatal-infos
flutter test
flutter build apk --release
```

## CI and releases

| Workflow | Trigger | Result |
| --- | --- | --- |
| `.github/workflows/ci.yml` | Push to `main`/`develop`; pull request to `main` | Gets packages, generates localization, analyzes, tests, builds a release APK, and retains it as an artifact for 7 days. |
| `.github/workflows/release.yml` | `v*` tag or manual dispatch | Builds APK/AAB, uploads artifacts, and creates a GitHub Release for a version tag. |

Create a tagged release:

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

For production Android signing in the release workflow, set repository secrets:

| Secret | Purpose |
| --- | --- |
| `KEYSTORE_BASE64` | Base64-encoded Android upload keystore |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Alias for the signing key |

The standard CI workflow uses a safe placeholder API URL so that validation does not contact a production backend.

## Security checklist

- Never commit `.env`, keystores, service-account files, OAuth secrets, or private API keys.
- Review Firebase rules before deployment; repository rules are not automatically production-safe.
- Use a production upload key for Play Store distribution.
- Restrict OAuth redirect URIs, Android SHA fingerprints, and backend CORS policies to deployed apps.
- Rotate any credential immediately if it is exposed.

## Troubleshooting

### `flutter pub get` reports an incompatible Dart SDK

Install Flutter `3.47.5` or a newer stable Flutter release with compatible Dart.

### Android CI refers to a Windows Java path

Do not set `org.gradle.java.home` to a local path in `android/gradle.properties`. GitHub Actions provisions Java 17 for release builds.

### Firebase or Google sign-in fails

Verify Firebase platform files, Android SHA fingerprints, iOS bundle identifier, OAuth client IDs, and values in `.env`.

### The app cannot reach the API

Verify `API_BASE_URL`, device connectivity, server health, and Android HTTPS/cleartext configuration.

## License

All rights reserved. This project is not published as an open-source package.
