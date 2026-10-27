# Flutter ↔ Laravel Connection Guide

Panduan lengkap untuk menghubungkan Flutter mobile app ke Laravel backend.

---

## 📋 Ringkasan Arsitektur

```
┌─────────────────┐         ┌──────────────────┐         ┌──────────┐
│  Flutter App    │  HTTP   │  Laravel API     │  HTTP   │  AI Core │
│  (Mobile)       │────────▶│  (Port 8000)     │────────▶│ (5000)   │
│                 │  REST   │                  │  REST   │          │
└─────────────────┘         └──────────────────┘         └──────────┘
```

**Alur koneksi:**
1. Flutter app → Laravel API (`http://IP:8000/api`)
2. Laravel API → AI Core Flask (`http://127.0.0.1:5000`)
3. AI Core → MySQL database

---

## 🔧 File Konfigurasi Flutter

### 1. `.env` — Environment Variables

File: `mobile_app/.env`

```env
API_BASE_URL=http://192.168.100.63:8000/api
PUSHER_APP_KEY=mrrifx7p7ewh6sk2vrfq
PUSHER_APP_CLUSTER=mt1
GOOGLE_CLIENT_ID=125956093579-49v70n0pagru7nt2i1g2fephu1a5renn.apps.googleusercontent.com
FIREBASE_API_KEY=AIzaSyB-nKM5RfstmvGF0fo2IrWiTtA-G5_yv4I
```

**Penting:** `API_BASE_URL` harus disesuaikan dengan IP address komputer Anda.

### 2. `.env.production` — Production Build

File: `mobile_app/.env.production`

Digunakan saat build release APK. Ganti dengan domain production asli.

### 3. `.env.windows` — Windows Development

File: `mobile_app/.env.windows`

Khusus development di Windows.

---

## 🌐 Menentukan API_BASE_URL yang Benar

`API_BASE_URL` di `.env` harus disesuaikan dengan cara Anda menjalankan Laravel dan cara Anda menjalankan Flutter app:

### Skenario 1: Android Emulator + Laravel di localhost

```env
API_BASE_URL=http://10.0.2.2:8000/api
```

`10.0.2.2` adalah special alias yang mengarah ke `localhost` dari Android emulator.

### Skenario 2: Physical Android Device + Laravel di komputer yang sama

```env
API_BASE_URL=http://IP_KOMPUTER_ANDA:8000/api
```

Cari IP komputer Windows:
```powershell
ipconfig
```
Cari IPv4 Address di adapter WiFi/Ethernet, contoh: `192.168.100.63`

### Skenario 3: iOS Simulator + Laravel di localhost

```env
API_BASE_URL=http://localhost:8000/api
```

### Skenario 4: Docker Compose

Jika Laravel dijalankan via Docker Compose (`docker-compose.yml`), port tetap `8000`:

```env
# Android Emulator
API_BASE_URL=http://10.0.2.2:8000/api

# Physical Device
API_BASE_URL=http://IP_KOMPUTER_ANDA:8000/api
```

---

## 📦 Cara Menjalankan Laravel Backend

### Opsi A: PHP Artisan Serve (Local)

```powershell
cd Mobile-And-Backend
php artisan serve --host=0.0.0.0 --port=8000
```

`--host=0.0.0.0` penting agar bisa diakses dari device lain di jaringan yang sama.

### Opsi B: Docker Compose

```powershell
docker compose up --build -d
```

Services yang akan berjalan:
- **Laravel**: `http://localhost:8000`
- **AI Core**: `http://localhost:5000`
- **MySQL**: `port 3307`
- **phpMyAdmin**: `http://localhost:8081`

---

## 📱 Cara Menjalankan Flutter App

### 1. Install Dependencies

```powershell
cd mobile_app
flutter pub get
```

### 2. Pastikan .env Sudah Benar

Edit `mobile_app/.env` dan pastikan `API_BASE_URL` sesuai dengan skenario Anda.

### 3. Jalankan App

```powershell
# Android Emulator
flutter run

# Physical Device (hubungkan via USB)
flutter run -d <device-id>
```

---

## 🔍 Menguji Koneksi

### Test 1: Ping Endpoint

Buka browser atau Postman dan akses:

```
http://IP_KOMPUTER_ANDA:8000/api/ping
```

Response yang diharapkan:
```json
{
  "status": "ok",
  "timestamp": "2025-01-01T00:00:00+07:00",
  "is_mobile": false,
  "db_status": "connected",
  "user_count": 0
}
```

### Test 2: Health Check CBIR

```
http://IP_KOMPUTER_ANDA:8000/api/cbir/health
```

### Test 3: Stats CBIR

```
http://IP_KOMPUTER_ANDA:8000/api/cbir/stats
```

---

## 🏗️ Alur Data Flutter → Laravel → AI Core

### Contoh: CBIR Image Search

1. **User** upload gambar di Flutter app
2. **Flutter** kirim `POST /api/cbir/search` ke Laravel
3. **Laravel** (`CBIRController`) terima request
4. **Laravel** forward ke AI Core via `CBIRService` → `POST /api/search`
5. **AI Core** extract fitur gambar, cari similarity
6. **AI Core** return hasil ke Laravel
7. **Laravel** normalize hasil dan return ke Flutter
8. **Flutter** tampilkan hasil pencarian

### Endpoint CBIR yang Tersedia

| Method | Endpoint | Kebutuhan Auth | Fungsi |
|--------|----------|----------------|--------|
| POST | `/api/cbir/search` | ✓ Sanctum | Cari dekorasi mirip gambar |
| POST | `/api/cbir/arithmetic` | ✓ Sanctum | Pencarian aritmetika gambar |
| GET | `/api/cbir/arithmetic/ops` | ✗ | Daftar operasi aritmetika |
| GET | `/api/cbir/stats` | ✗ | Statistik index CBIR |
| GET | `/api/cbir/health` | ✗ | Health check AI Core |
| GET | `/api/cbir/evaluate` | ✗ | Evaluasi model |

---

## 🔐 Autentikasi (Sanctum)

Flutter menggunakan **Laravel Sanctum** untuk autentikasi via Bearer Token:

1. User login via `POST /api/login`
2. Server return token
3. Token disimpan di `FlutterSecureStorage`
4. Setiap request otomatis attach header: `Authorization: Bearer <token>`
5. `AuthInterceptor` di `DioClient` menangani ini otomatis

---

## 🐛 Troubleshooting

### Problem: "Connection refused" atau "Network Failure"

**Penyebab:** `API_BASE_URL` salah atau Laravel tidak berjalan.

**Solusi:**
1. Pastikan Laravel berjalan: `php artisan serve --host=0.0.0.0 --port=8000`
2. Cek `API_BASE_URL` di `.env` sesuai dengan IP dan port
3. Test ping: `http://IP:8000/api/ping` dari browser

### Problem: "10.0.2.2 tidak bisa diakses di physical device"

**Penyebab:** `10.0.2.2` hanya untuk Android emulator.

**Solusi:** Gunakan IP komputer Anda di `.env`:
```env
API_BASE_URL=http://192.168.100.63:8000/api
```

### Problem: "CORS error"

**Penyebab:** CORS hanya berlaku untuk browser. Flutter mobile app tidak terkena CORS.

**Catatan:** Jika error masih muncul, kemungkinan bukan CORS — periksa log Dio di console Flutter.

### Problem: "AI Core tidak terjangkau dari Laravel"

**Penyebab:** AI Core tidak berjalan atau URL salah.

**Solusi:**
1. Pastikan AI Core berjalan: `http://localhost:5000/health`
2. Cek `AI_CORE_URL` di `Mobile-And-Backend/.env`
3. Untuk Docker: `AI_CORE_URL=http://ai_core:5000`

### Problem: "flutter_dotenv tidak load"

**Penyebab:** `dotenv.load()` tidak dipanggil atau file `.env` tidak ada.

**Solusi:**
1. Pastikan `await dotenv.load()` ada di `main()`
2. Pastikan file `.env` ada di `mobile_app/.env`
3. Pastikan `flutter_dotenv` ada di `pubspec.yaml`

---

## 📁 Struktur File Konfigurasi

```
mobile_app/
├── .env                 # Development (current)
├── .env.example         # Template dokumentasi
├── .env.production      # Production build
├── .env.windows         # Windows development
└── lib/
    ├── main.dart                    # dotenv.load() dipanggil di sini
    └── core/
        ├── config/
        │   └── app_config/
        │       └── app_config.dart  # Baca API_BASE_URL dari dotenv
        └── api/
            ├── dio_client/
            │   └── dio_client.dart  # Dio instance dengan AppConfig.apiBaseUrl
            └── api_endpoints/
                └── api_endpoints.dart  # Semua endpoint path

Mobile-And-Backend/
├── .env                 # Laravel environment
├── config/
│   ├── cors.php         # CORS configuration
│   ├── sanctum.php      # Sanctum mobile auth
│   └── services.php     # AI_CORE_URL configuration
├── bootstrap/
│   └── app.php          # Routing: api → routes/api/api.php
└── routes/
    └── api/
        └── api.php      # Semua API routes terdaftar
```

---

## ✅ Checklist Koneksi

- [ ] Laravel backend berjalan (`php artisan serve` atau Docker)
- [ ] AI Core berjalan (`http://localhost:5000/health` return OK)
- [ ] MySQL database berjalan dan terkoneksi
- [ ] `mobile_app/.env` sudah di-edit dengan `API_BASE_URL` yang benar
- [ ] `flutter pub get` sudah dijalankan
- [ ] Test ping: `http://IP:8000/api/ping` return `{"status":"ok"}`
- [ ] Flutter app bisa build dan run tanpa error

---

## 📞 Kontak

Jika ada masalah, periksa:
1. Console output Flutter untuk error Dio
2. Laravel log: `Mobile-And-Backend/storage/logs/laravel.log`
3. AI Core log: terminal tempat AI Core dijalankan
