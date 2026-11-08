# Environment dan Konfigurasi

## 1. File environment

### 1.1 Mobile (`mobile_app`)

| File | Fungsi |
|---|---|
| `.env` | Konfigurasi aktif untuk build lokal |
| `.env.example` | Template |
| `.env.production` | Contoh produksi |
| `.env.windows` | Override untuk Windows |

`main.dart` memanggil `dotenv.load()` tanpa argumen. Pastikan file `.env` ada di root `mobile_app` dan terdaftar sebagai asset di `pubspec.yaml`.

### 1.2 Backend (`Mobile-And-Backend`)

| File | Fungsi |
|---|---|
| `.env` | Konfigurasi aktif Laravel |
| `.env.example` | Template |
| `config/lighthouse.php` | Endpoint GraphQL `/graphql` |
| `config/database.php` | Koneksi PostgreSQL |

## 2. Variabel mobile

| Key | Wajib | Contoh | Catatan |
|---|---|---|---|
| `API_BASE_URL` | Ya | `http://192.168.100.2:8000/api` | Sudah termasuk `/api` |
| `STORAGE_BASE_URL` / host | Ya | `http://192.168.100.2:8000` | Untuk URL media |
| `GRPC_BASE_URL` | Tidak | `http://192.168.100.2:50051` | Generated, tidak dipakai |
| `GOOGLE_CLIENT_ID` | Untuk Google | `xxx.apps.googleusercontent.com` | Google Sign-In |
| `FACEBOOK_APP_ID` | Untuk Facebook | — | Facebook Login |
| `PUSHER_APP_KEY` | Untuk realtime | — | Opsional |
| `PUSHER_APP_CLUSTER` | Untuk realtime | `mt1` | Opsional |
| `FIREBASE_*` | Untuk push | — | Lihat `FirebaseOptions.dart` |

Jangan commit kredensial produksi. Gunakan secret manager/CI variables.

## 3. Variabel backend penting

| Key | Nilai lokal | Catatan |
|---|---|---|
| `APP_ENV` | `local` | |
| `APP_URL` | `https://wedding-flower-decorations.whop.site` | |
| `DB_CONNECTION` | `pgsql` | **Bukan MySQL** |
| `DB_HOST` | `127.0.0.1` | |
| `DB_PORT` | `5432` | |
| `DB_DATABASE` | `wedding_florals_decorations` | |
| `DB_USERNAME` | `postgres` | |
| `DB_PASSWORD` | (kosong di lokal) | Jangan commit |
| `SESSION_DRIVER` | `database` | |
| `CACHE_STORE` | `database` | |
| `FILESYSTEM_DISK` | `public` | |
| `AI_CORE_URL` | `http://127.0.0.1:5000` | CBIR/OCR |
| `AI_CORE_GRPC_ENABLED` | `true` | Untuk AI Core, bukan mobile |
| `AI_CORE_GRPC_HOST` | `127.0.0.1:15052` | |

## 4. Menjalankan backend

```powershell
cd D:\WeddingFlowersDecorationApp\Mobile-And-Backend
php artisan serve --host=0.0.0.0 --port=8000
```

Cek route:

```powershell
php artisan route:list --path=api
```

Cek koneksi database:

```powershell
php artisan migrate:status
```

## 5. Menjalankan mobile

```powershell
cd D:\WeddingFlowersDecorationApp\mobile_app
flutter pub get
flutter run
```

Untuk emulator Android:

```dotenv
API_BASE_URL=http://10.0.2.2:8000/api
```

Untuk perangkat fisik, gunakan IP LAN PC yang menjalankan backend, bukan `localhost`.

## 6. Cek cepat koneksi

```powershell
curl http://192.168.100.2:8000/api/catalog/public
curl http://192.168.100.2:8000/api/categories
```

Jika 401, endpoint tersebut memang privat. Untuk menguji endpoint privat:

```powershell
curl -H "Authorization: Bearer <token>" http://192.168.100.2:8000/api/profile
```

## 7. Storage dan media

- Backend menyimpan file di disk `public`.
- URL media dihasilkan backend; jangan menyusun URL manual dari nama file.
- Jika gambar tidak muncul, cek:
  1. `php artisan storage:link`
  2. `APP_URL`
  3. host storage yang dipakai `AppConfig`
  4. permission folder `storage/app/public`

## 8. GraphQL

```powershell
curl -X POST http://192.168.100.2:8000/graphql `
  -H "Content-Type: application/json" `
  -d '{\"query\":\"{ __typename }\"}'
```

Endpoint ada di root, bukan `/api/graphql`.

## 9. Firebase

- Android: letakkan `google-services.json` di `android/app/`.
- iOS: letakkan `GoogleService-Info.plist` di `ios/Runner/`.
- Jika Firebase gagal, aplikasi tetap berjalan; push notification dinonaktifkan.
- FCM membutuhkan izin notifikasi dan token yang terdaftar setelah login.

## 10. Build

```powershell
flutter analyze
flutter test
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
flutter build ios --release   # macOS
```

## 11. Troubleshooting

| Gejala | Penyebab umum | Solusi |
|---|---|---|
| `Connection refused` | Backend tidak jalan / IP salah | Jalankan `php artisan serve --host=0.0.0.0`, cek IP |
| Semua endpoint 404 | `API_BASE_URL` dobel `/api` | Pastikan hanya satu `/api` |
| 401 setelah login | Token tidak tersimpan/header tidak terkirim | Cek `auth_token`, interceptor |
| Gambar tidak muncul | Storage link/URL | `storage:link`, cek `APP_URL` |
| Firebase crash | Config tidak ada | Try/catch sudah ada; cek platform config |
| GraphQL 404 | Memakai `/api/graphql` | Gunakan `/graphql` |
| Database error | MySQL vs PostgreSQL | Gunakan `pgsql`, cek `.env` |
| Favorit 404 | Casing `/favorite` | Gunakan `/Favorite` |
