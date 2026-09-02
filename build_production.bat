@echo off
REM ═══════════════════════════════════════════════════════════════════
REM  Flutter Build Script — Production APK
REM  Run this from the mobile_app directory
REM ═══════════════════════════════════════════════════════════════════

echo.
echo ============================================
echo  Flutter Build — Production APK
echo ============================================
echo.

REM ── 1. Check .env.production exists ──────────────────────────────
if not exist ".env.production" (
    echo [ERROR] .env.production not found!
    echo Copy .env and update API_BASE_URL for production.
    pause
    exit /b 1
)

REM ── 2. Copy production env ────────────────────────────────────────
echo [1/4] Copying .env.production to .env ...
copy /Y .env.production .env

REM ── 3. Clean build ────────────────────────────────────────────────
echo [2/4] Cleaning previous builds ...
flutter clean

REM ── 4. Get dependencies ──────────────────────────────────────────
echo [3/4] Getting dependencies ...
flutter pub get

REM ── 5. Generate l10n ─────────────────────────────────────────────
echo [4/4] Generating localization ...
flutter gen-l10n

REM ── 6. Build APK ─────────────────────────────────────────────────
echo.
echo Building release APK ...
flutter build apk --release

echo.
echo ============================================
echo  Build Complete!
echo ============================================
echo.
echo  APK: build\app\outputs\flutter-apk\app-release.apk
echo.
echo  To build App Bundle (for Play Store):
echo    flutter build appbundle --release
echo.
pause
