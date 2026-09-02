@echo off
REM ═══════════════════════════════════════════════════════════════════
REM  Build Script — Windows Desktop (EXE)
REM  Run this from the mobile_app directory
REM ═══════════════════════════════════════════════════════════════════

echo.
echo ============================================
echo  Flutter Build — Windows Desktop (EXE)
echo ============================================
echo.

REM ── 1. Check .env.windows exists ─────────────────────────────────
if not exist ".env.windows" (
    echo [ERROR] .env.windows not found!
    pause
    exit /b 1
)

REM ── 2. Copy Windows env ──────────────────────────────────────────
echo [1/5] Copying .env.windows to .env ...
copy /Y .env.windows .env

REM ── 3. Clean ─────────────────────────────────────────────────────
echo [2/5] Cleaning previous builds ...
flutter clean

REM ── 4. Get dependencies ──────────────────────────────────────────
echo [3/5] Getting dependencies ...
flutter pub get

REM ── 5. Generate l10n ─────────────────────────────────────────────
echo [4/5] Generating localization ...
flutter gen-l10n

REM ── 6. Build Windows ─────────────────────────────────────────────
echo [5/5] Building Windows Desktop ...
flutter build windows --release

echo.
echo ============================================
echo  Build Complete!
echo ============================================
echo.
echo  EXE: build\windows\x64\runner\Release\mobile_app.exe
echo  Distribution: build\windows\x64\runner\Release\ (full folder)
echo.
echo  To create installer, use Inno Setup or MSIX:
echo    flutter build windows --release
echo.
pause
