# App Lock

> **Fitur:** Auth & Keamanan · **Route:** `/app-lock` · **Akses:** Sanctum + lokal · **Tipe:** Autentikasi & keamanan
> **Implementasi referensi (aplikasi saat ini):** `AppLockScreen` · **State:** State management terpusat + state lokal · **Pola:** request-response
> **API:** 6 endpoint · **Tabel:** 3 · **Model:** 0
> Diverifikasi 6 November 2026 dari implementasi aplikasi saat ini, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Mengunci aplikasi dengan PIN, biometrik, atau password perangkat dan membuka kunci sebelum masuk ke layar terakhir. |
| Aktor | Pelanggan terautentikasi (Sanctum) |
| Nilai pengguna | Mengunci aplikasi dengan PIN, biometrik, atau password perangkat dan membuka kunci sebelum masuk ke layar terakhir. |
| Definisi sukses | Sesi terbuka atau kredensial terverifikasi tanpa membocorkan data sensitif. |
| Risiko utama | PIN disimpan sebagai hash di `users.app_lock_pin_hash`; flag per akun juga disimpan lokal. |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Mengunci aplikasi dengan PIN, biometrik, atau password perangkat dan membuka kunci sebelum masuk ke layar terakhir. | Sesi terbuka atau kredensial terverifikasi tanpa membocorkan data sensitif. |
| Pengguna perangkat | Mengatur preferensi lokal | Preferensi bertahan setelah aplikasi ditutup |

### 1.2 In scope

- Baca status app lock dari backend dan flag lokal per akun.
- Tampilkan PIN pad; pengguna dapat beralih ke biometrik atau password.
- Verifikasi PIN/wajah ke backend atau biometrik ke perangkat.
- Jika lupa PIN, kirim OTP dan reset app lock.
- Setelah berhasil, buka `pre_lock_route` atau `/home`.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Otomatis saat aplikasi dibuka/diresume bila app lock aktif, atau setelah login/2FA. |
| Route | `/app-lock` |
| Parameter/extra | Tidak menerima parameter. `pre_lock_route` disimpan di SharedPreferences. |
| Guard | Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login. |
| Keluar ke | Tidak ada navigasi keluar langsung yang terdeteksi. |
| Perilaku back | Kembali dapat keluar dari alur autentikasi; jangan menyimpan kredensial di state global. |

### 2.1 Layar terkait dalam fitur yang sama

| Layar | Route | PRD |
|---|---|---|
| `BiometricUnlockScreen` | — | [biometric-unlock.md](../auth/biometric-unlock.md) |
| `PasswordUnlockScreen` | — | [password-unlock.md](../auth/password-unlock.md) |
| `PinUnlockScreen` | — | [pin-unlock.md](../auth/pin-unlock.md) |
| `CompleteProfileScreen` | `/complete-profile` | [complete-profile.md](../auth/complete-profile.md) |

## 3. Alur Pengguna

1. Baca status app lock dari backend dan flag lokal per akun.
2. Tampilkan PIN pad; pengguna dapat beralih ke biometrik atau password.
3. Verifikasi PIN/wajah ke backend atau biometrik ke perangkat.
4. Jika lupa PIN, kirim OTP dan reset app lock.
5. Setelah berhasil, buka `pre_lock_route` atau `/home`.

**Decision points yang wajib diuji:**

- `PIN salah` → Tampilkan error tanpa membocorkan detail; izinkan coba lagi.
- `biometrik tidak tersedia` → Tampilkan fallback PIN/password bila biometrik gagal.
- `OTP gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Otomatis saat aplikasi dibuka/diresume bila app lock aktif, atau setelah login/2FA."] --> B["Render awal / muat data"]
  B -->|sukses| C["PIN pad 6 digit"]
  C --> D["Setelah berhasil, buka pre_lock_route atau /home."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| Komponen/layar | `AppLockScreen` |
| Identifier | `AppLockScreen` |
| Tipe komponen | Komponen ber-state |
| Komponen state | Tersedia pada implementasi referensi |
| State management | State management terpusat + state lokal |
| Pola data | request-response |
| State/dependency | `appLockServiceProvider`, `currentAccountEmailProvider`, `authProvider` |
| Data source/repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Komponen UI bersama | Tidak terdeteksi |
| Komponen UI fitur | Tidak terdeteksi |
| Model | Tidak terdeteksi |

### 4.1 State lokal yang terdeteksi

| Field | Tipe | Peran |
|---|---|---|
| `_authenticating` | `bool` | State lokal layar. |
| `_pinError` | `bool` | Menyimpan pesan kegagalan. |
| `_pinEnabled` | `bool` | State lokal layar. |
| `_faceEnabled` | `bool` | State lokal layar. |
| `_fingerprintEnabled` | `bool` | State lokal layar. |
| `_passwordEnabled` | `bool` | State lokal layar. |
| `_anyEnabled` | `bool` | State lokal layar. |
| `_pinBuffer` | `String` | State lokal layar. |
| `_passwordController` | `TextEditingController` | Controller/state input; wajib dibersihkan saat tidak dipakai. |
| `_passwordError` | `bool` | Menyimpan pesan kegagalan. |
| `_biometricFailed` | `bool` | State lokal layar. |
| `_lastAuthAttempt` | `DateTime` | State lokal layar. |

### 4.2 Metode internal

`_init`, `_authenticateBiometric`, `_authenticateWithDeviceBiometric`, `_onPinDigit`, `_onPinDelete`, `_verifyPin`, `_verifyPassword`, `_forgotPin`, `_goHome`.

### 4.3 Alur data

```text
UI / State layar
   ↓ baca/tulis
State management / dependency
   ↓
Repository / HTTP client
   ↓ REST
Controller Laravel → PostgreSQL (3 tabel terkait)
```

## 5. Blueprint UI

Wireframe konseptual dari daftar elemen registry. Urutan final mengikuti implementasi aplikasi.

```text
┌────────────────────────────────────────────────────────────────────┐
│ App Lock                                                          │
├────────────────────────────────────────────────────────────────────┤
│ 1. PIN pad 6 digit                                                │
│ 2. Tombol biometrik                                               │
│ 3. Tautan lupa PIN                                                │
│ 4. Dialog reset via OTP                                           │
│ 5. Indikator akun aktif                                           │
└────────────────────────────────────────────────────────────────────┘
```

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | PIN pad 6 digit | Input | Isi/ubah nilai; validasi client sebelum kirim. | Error inline; 422 dipetakan per field. |
| 2 | Tombol biometrik | Aksi | Tap → jalankan aksi utama layar. | Disabled saat loading; error lewat SnackBar/inline. |
| 3 | Tautan lupa PIN | Aksi | Tap → jalankan aksi utama layar. | Disabled saat loading; error lewat SnackBar/inline. |
| 4 | Dialog reset via OTP | Overlay | Konfirmasi/pilih; tutup dengan back atau aksi batal. | Fokus terperangkap; dismiss aman. |
| 5 | Indikator akun aktif | Status | Tampilkan kondisi koneksi/status; beri aksi retry bila perlu. | Perubahan status diumumkan; retry tersedia. |

### 6.1 Fakta teknis form & interaksi

| Fakta | Nilai |
|---|---|
| TextEditingController | 1 |
| Field teks/form | 0 |
| Dropdown | 0 |
| Switch/toggle | 0 |
| Validator client | 0 |
| Field password (teks tersamar) | 0 |
| maxLength | Tidak terdeteksi |
| Keyboard | Tidak terdeteksi |
| Input formatter | Tidak terdeteksi |
| Upload file | Tidak |
| Kamera | Tidak |
| WebView | Tidak |
| Timer/polling | Tidak |
| Pagination | Tidak |
| Pull to refresh | Tidak |

## 7. Copywriting & Microcopy

Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai sistem lokalisasi/i18n yang konsisten dan mengikuti gaya bahasa layar lain.

| Lokasi | Draft copy | Catatan |
|---|---|---|
| Judul/header | App Lock | Samakan dengan label navigasi. |
| Subjudul | Mengunci aplikasi dengan PIN, biometrik, atau password perangkat dan membuka kunci sebelu… | Ringkas; jangan mengulang judul. |
| Tombol utama | Buka Kunci | [Usulan] Disabled saat proses. |
| Empty state | Belum ada app Lock. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat app Lock. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |
| Instruksi | Masukkan kode verifikasi. | [Usulan] Tampilkan tujuan kode (email/WhatsApp). |
| Keamanan | Jangan bagikan kode ini kepada siapa pun. | [Usulan] Tampilkan sebagai peringatan. |

## 8. Design System & Responsif

### 8.1 Token yang wajib dipakai

| Token | Nilai |
|---|---|
| Font | Instrument Sans (W400/W600), aset lokal |
| Warna primer | `#1E3A5F` (token primer aplikasi) |
| Aksen | `#C9A94E` |
| Background light | `#F8F6F7` |
| Surface light | `#FFFFFF` |
| Background dark | `#121212` |
| Surface dark | `#1E1E1E` |
| Teks primer light | `#1A1A2E`; dark `#E8E8E8` |
| Teks sekunder light | `#8E8E9A`; dark `#A0A0A0` |
| Sukses/error/warning/info | `#10B981` / `#EF4444` / `#F59E0B` / `#3B82F6` |
| Tipografi | `headTitle` 22/w600; `subHeadTitle` 16/w400; `h3` 14/w600; `h4` 12/w400; `description` 14/1.4 |
| Spacing | skala 2, 4, 8, 16, 24, 32, 48, 64 |
| Radius | card 16, button 14, input 14, avatar 28, bottom nav 24 |
| Glass | `AppBlurBackdrop`; `blurSigma` 15; tint light `#32FFFFFF`, night `#32000000` |

### 8.2 Aturan responsif

- Lebar minimum yang wajib diuji: **320 px**; target umum 360/390/412 px.
- Tablet ≥ 600 px: gunakan padding lebih lebar dan grid multi-kolom bila layar berupa koleksi.
- Jangan mengunci tinggi konten; gunakan `SingleChildScrollView`/sliver agar tidak overflow.
- Hormati `SafeArea`, status bar, navigation bar, dan keyboard inset.
- Teks harus tetap terbaca pada text scale 200%; hindari `maxLines: 1` untuk label penting.
- Layout harus aman untuk locale dengan teks lebih panjang (±30%).

### 8.3 Mode gelap & glass

- Tema mengikuti sistem (light/dark) dan dapat di-override `ThemeProvider`.
- Jangan hardcode warna; gunakan token/tema desain aplikasi agar mode gelap bekerja.
- Fallback tanpa blur harus tetap kontras dan terbaca.
- Hormati reduce-motion; animasi 3D/parallax tidak boleh menjadi satu-satunya pembeda state.

## 9. State Machine

| State | Pemicu | UI | Pemulihan |
|---|---|---|---|
| `initial` | Layar dibuka | Kerangka/placeholder awal | Muat data |
| `loading` | Request berjalan | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Data tersedia | Render konten utama | — |
| `error` | Request gagal | Pesan ramah + tombol coba lagi | Retry |
| `unauthorized` | HTTP 401 | Sesi berakhir; arahkan login/Landing | Login ulang |
| `offline` | Koneksi putus | Banner/empty offline | Coba lagi saat online |
| `submitting` | Pengguna menekan aksi utama | Tombol disabled + progress | Selesai atau tampilkan error |
| `loading status` | Kondisi domain | Skeleton/spinner; blokir aksi ganda. | Ikuti aksi pemulihan pada pesan |
| `PIN salah` | Kondisi domain | Tampilkan error tanpa membocorkan detail; izinkan coba lagi. | Ikuti aksi pemulihan pada pesan |
| `biometrik tidak tersedia` | Kondisi domain | Tampilkan fallback PIN/password bila biometrik gagal. | Ikuti aksi pemulihan pada pesan |
| `OTP gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `akun terkunci sementara` | Kondisi domain | Tampilkan countdown/instruksi pemulihan; jangan bocorkan detail. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `GET` | `/profile/app-lock` | `AppLockController@show` | Sanctum | Konfigurasi app lock |
| 2 | `PUT` | `/profile/app-lock` | `AppLockController@update` | Sanctum | Konfigurasi app lock |
| 3 | `POST` | `/profile/app-lock/pin/verify` | `AppLockController@verifyPin` | Sanctum | Memverifikasi PIN app lock |
| 4 | `POST` | `/profile/app-lock/face-verify` | `AppLockController@faceVerify` | Sanctum | Memverifikasi wajah app lock |
| 5 | `POST` | `/auth/send-otp` | `AuthController@sendOtp` | Publik | Mengirim OTP email/WhatsApp |
| 6 | `POST` | `/auth/verify-otp` | `AuthController@verifyOtp` | Publik | Memverifikasi OTP |

### 10.2 Detail per endpoint

#### 10.2.1 `GET /profile/app-lock`

- **Controller:** `AppLockController@show`
- **Auth:** Sanctum
- **Kegunaan:** Konfigurasi app lock
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/AppLockController/AppLockController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `data`

#### 10.2.2 `PUT /profile/app-lock`

- **Controller:** `AppLockController@update`
- **Auth:** Sanctum
- **Kegunaan:** Konfigurasi app lock
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/AppLockController/AppLockController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `fingerprint_enabled` | `sometimes|boolean` | Tidak |
| `face_enabled` | `sometimes|boolean` | Tidak |
| `pin_enabled` | `sometimes|boolean` | Tidak |

- **Response top-level:** `status`, `message`, `data`

#### 10.2.3 `POST /profile/app-lock/pin/verify`

- **Controller:** `AppLockController@verifyPin`
- **Auth:** Sanctum
- **Kegunaan:** Memverifikasi PIN app lock
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/AppLockController/AppLockController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `pin` | `required|string|size:6|digits:6` | Ya |

- **Response top-level:** `status`, `data`

#### 10.2.4 `POST /profile/app-lock/face-verify`

- **Controller:** `AppLockController@faceVerify`
- **Auth:** Sanctum
- **Kegunaan:** Memverifikasi wajah app lock
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/AppLockController/AppLockController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `face_photo` | `required|image|mimes:jpg,jpeg,png|max:10240` | Ya |

- **Response top-level:** `status`, `message`, `data`
- **Pesan error terbaca:** “Wajah belum didaftarkan untuk kunci aplikasi”; “Foto wajah tidak dapat diproses”; “Referensi wajah tidak ditemukan”

#### 10.2.5 `POST /auth/send-otp`

- **Controller:** `AuthController@sendOtp`
- **Auth:** Publik
- **Kegunaan:** Mengirim OTP email/WhatsApp
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/AuthController/AuthController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `email` | `required_without:whatsapp|email` | Ya |
| `whatsapp` | `required_without:email|string` | Ya |
| `purpose` | `required|string|in:google_register,forgot_password,verify_email,reset_app_lock,verify_whatsapp` | Ya |

- **Response top-level:** `status`, `message`
- **Pesan error terbaca:** “Tujuan OTP tidak valid”; “Format nomor WhatsApp tidak valid”; “Kode OTP berhasil dikirim ke WhatsApp”; “User tidak ditemukan”

#### 10.2.6 `POST /auth/verify-otp`

- **Controller:** `AuthController@verifyOtp`
- **Auth:** Publik
- **Kegunaan:** Memverifikasi OTP
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/AuthController/AuthController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `email` | `required_without:whatsapp|email` | Ya |
| `whatsapp` | `required_without:email|string` | Ya |
| `otp` | `required|string|size:6` | Ya |
| `purpose` | `required|string|in:google_register,forgot_password,verify_email,reset_app_lock,verify_whatsapp` | Ya |

- **Response top-level:** `status`, `message`, `data`
- **Pesan error terbaca:** “Tujuan OTP tidak valid”; “Kode OTP tidak valid atau sudah kedaluwarsa”; “OTP berhasil diverifikasi”

**Envelope acuan** (periksa controller untuk variasi):

```json
{"status":"success","message":"...","data":{}}
```

### 10.3 Pemetaan error HTTP

| HTTP | Failure | Perilaku UI |
|---|---|---|
| 401 | `AuthFailure` | Hapus token, arahkan ke Landing/login, tampilkan sesi berakhir. |
| 403 | `UnknownFailure` / izin | Pesan akses ditolak; jangan logout otomatis. |
| 404 | `NotFoundFailure` | Tampilkan resource tidak ditemukan + kembali. |
| 409 | `ConflictFailure` / server | Tampilkan konflik status (stok, duplikasi, pembayaran). |
| 422 | `ValidationFailure(errors)` | Tampilkan error per field; pertahankan input. |
| 429 | `UnknownFailure` / rate limit | Minta pengguna menunggu; jangan spam retry. |
| 5xx | `ServerFailure` | Pesan error server + tombol coba lagi. |
| null | `NetworkFailure` | Periksa koneksi + retry; pertahankan data lama. |

## 11. Data & Database

| Tabel | Peran | Akses | Kolom kunci |
|---|---|---|---|
| `users` | Akun, profil, KYC, preferensi, dan pengaturan keamanan. | Baca/tulis (indikasi) | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance`, `email_verified_at`, `password` … |
| `security_events` | Jejak peristiwa keamanan. | Baca/tulis (indikasi) | `id`, `event`, `method`, `path`, `status`, `ip_address`, `user_agent`, `user_id`, `admin_id`, `metadata` … |
| `whatsapp_otps` | Kode OTP dan masa berlaku. | Baca/tulis (indikasi) | `id`, `whatsapp`, `otp_code`, `expires_at`, `verified_at`, `created_at`, `updated_at` |

Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service untuk memastikan operasi baca/tulis yang sebenarnya.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL langsung dari klien; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.
- Preferensi lokal disimpan di penyimpanan lokal; token tetap di secure storage.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Aplikasi terkunci saat lifecycle resume bila flag aktif.
- PIN benar membuka aplikasi tanpa memanggil ulang login.
- Reset PIN hanya berhasil setelah OTP terverifikasi.

### 12.2 Validasi server yang terbaca dari controller

| Field | Aturan | Endpoint |
|---|---|---|
| `fingerprint_enabled` | `sometimes|boolean` | `/profile/app-lock` |
| `face_enabled` | `sometimes|boolean` | `/profile/app-lock` |
| `pin_enabled` | `sometimes|boolean` | `/profile/app-lock` |
| `pin` | `required|string|size:6|digits:6` | `/profile/app-lock/pin/verify` |
| `face_photo` | `required|image|mimes:jpg,jpeg,png|max:10240` | `/profile/app-lock/face-verify` |
| `email` | `required_without:whatsapp|email` | `/auth/send-otp` |
| `whatsapp` | `required_without:email|string` | `/auth/send-otp` |
| `purpose` | `required|string|in:google_register,forgot_password,verify_email,reset_app_lock,verify_whatsapp` | `/auth/send-otp` |
| `email` | `required_without:whatsapp|email` | `/auth/verify-otp` |
| `whatsapp` | `required_without:email|string` | `/auth/verify-otp` |
| `otp` | `required|string|size:6` | `/auth/verify-otp` |
| `purpose` | `required|string|in:google_register,forgot_password,verify_email,reset_app_lock,verify_whatsapp` | `/auth/verify-otp` |

### 12.3 Validasi client yang terdeteksi

- Tidak ada form input yang terdeteksi pada layar ini.

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan HTTP client/data source/repository yang sudah ada; jangan membuat client baru di komponen UI.
- Guest tidak boleh memanggil endpoint privat; tampilkan prompt autentikasi tamu.
- Jangan menyimpan password/PIN plaintext; gunakan secure storage untuk token.
- Terapkan rate limit/lockout dan jangan membocorkan apakah akun terdaftar.
- OTP/challenge memiliki masa berlaku; tangani kedaluwarsa.

## 13. Error Handling

Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).

### 13.1 Kegagalan spesifik layar

- Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.
- Respons tidak sesuai envelope → tampilkan error umum, catat status code.
- 401 → bersihkan token dan arahkan ke Landing/login.
- 403 → tampilkan akses ditolak tanpa logout otomatis.
- 5xx → error server + retry; jangan menampilkan stack trace.
- Gap: PIN disimpan sebagai hash di `users.app_lock_pin_hash`; flag per akun juga disimpan lokal.
- Gap: Jangan menampilkan konten sensitif di snapshot task switcher.

## 14. Keamanan & Privasi

- Token hanya di secure storage; jangan di penyimpanan lokal atau log.
- Jangan menampilkan stack trace, query database, atau detail internal pada pengguna.
- Jangan mengirim PII ke analytics/crash report.
- Validasi kepemilikan resource di backend; client tidak boleh menentukan `user_id`.
- Data identitas (nama, email, telepon, alamat, KTP, selfie) adalah PII; batasi tampilan dan log.
- Pertimbangkan proteksi screenshot/task switcher untuk layar kunci. [Usulan]

## 15. Aksesibilitas

- Semua ikon/tombol non-teks memiliki label semantik.
- Target sentuh minimal 48×48 dp; jangan hanya mengandalkan ikon kecil.
- Kontras teks memenuhi WCAG AA pada mode terang dan gelap.
- Urutan fokus screen reader mengikuti urutan visual.
- Text scale 200% tidak memotong label atau tombol utama.
- Error form diumumkan dan terhubung ke field terkait.
- Hormati reduce-motion; animasi tidak boleh menghalangi interaksi.
- PIN pad memiliki label angka dan tombol hapus.
- Field password memiliki tombol tampil/sembunyikan berlabel.

## 16. Performa & Offline

- Gunakan `CachedNetworkImage`/cache yang ada untuk gambar jaringan.
- Hindari pekerjaan berat di `build()`; pindahkan parsing/format ke provider/util.
- Dispose controller, timer, dan subscription di `dispose`.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_app_lock` | Layar dibuka | screen, route, auth | Tidak |
| `app_lock_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `app_lock_success` | Aksi utama berhasil | duration_ms | Tidak |
| `app_lock_failure` | Request/aksi gagal | error_code, status | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Aplikasi terkunci saat lifecycle resume bila flag aktif.
- [ ] PIN benar membuka aplikasi tanpa memanggil ulang login.
- [ ] Reset PIN hanya berhasil setelah OTP terverifikasi.
- [ ] Tombol utama menjalankan aksi: Buka Kunci.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Otomatis saat aplikasi dibuka/diresume bila app lock aktif, atau setelah login/2FA.
- [ ] Route/parameter sesuai: `/app-lock`.
- [ ] Back tidak meninggalkan state ganda atau mengulang submit.

### 18.3 State & error

- [ ] Loading, content, empty, error, offline, dan unauthorized tertangani.
- [ ] 401 membersihkan token dan mengarahkan ke Landing/login.
- [ ] 422 menampilkan error per field dan mempertahankan input.
- [ ] Tombol tidak dapat ditekan ganda saat request berjalan.

### 18.4 Data & keamanan

- [ ] Semua endpoint yang dipakai terdaftar di backend; tidak ada endpoint karangan.
- [ ] Nominal/stok/status berasal dari respons backend, bukan hitungan lokal.
- [ ] Tidak ada PII/token di log, analytics, atau pesan error.
- [ ] Guest tidak memanggil endpoint privat.

### 18.5 Responsif & aksesibilitas

- [ ] Tidak ada overflow pada lebar 320 px dan orientasi landscape.
- [ ] Mode terang dan gelap terbaca.
- [ ] Text scale 200% tidak memotong label penting.
- [ ] Target sentuh minimal 48×48 dp dan label semantik tersedia.

### 18.6 Kualitas

- [ ] Analisis statis/lint sesuai toolchain target bersih untuk bagian yang diubah.
- [ ] Test happy path dan minimal satu error path ditambahkan/diperbarui.
- [ ] PRD/SKILL diperbarui bila route, endpoint, atau tabel berubah.

## 19. Test Plan

| ID | Jenis | Skenario | Langkah | Hasil yang diharapkan |
|---|---|---|---|---|
| TC-01 | Widget | Happy path | Buka layar melalui: Otomatis saat aplikasi dibuka/diresume bila app lock aktif, atau setelah login/2FA. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /app-lock dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
| TC-03 | Manual | Loading | Buka layar dengan jaringan lambat | Skeleton/spinner tampil; aksi utama disabled. |
| TC-04 | Manual | Error server | Mock respons 500 | Pesan error + tombol coba lagi; aplikasi tidak crash. |
| TC-05 | Manual | Sesi habis | Gunakan token kedaluwarsa/401 | Token dibersihkan; diarahkan ke Landing/login. |
| TC-06 | Manual | Akses ditolak | Mock respons 403 | Pesan akses ditolak; tidak logout otomatis. |
| TC-07 | Manual | Offline | Matikan jaringan lalu muat/aksi | Pesan offline + retry; data lama (bila ada) tidak hilang. |
| TC-08 | Widget | Double submit | Tekan aksi utama cepat dua kali | Hanya satu request; tombol disabled saat proses. |
| TC-09 | Manual | Layar kecil | Uji lebar 320 px dan landscape | Tidak ada overflow; tombol tetap terjangkau. |
| TC-10 | Manual | Mode gelap | Aktifkan dark mode sistem | Semua teks/komponen terbaca; tidak ada warna hardcode yang pecah. |
| TC-11 | Manual | Aksesibilitas | Aktifkan screen reader dan text scale 200% | Label terbaca; tidak ada teks terpotong. |
| TC-12 | Manual | Kredensial salah | Masukkan kode/PIN salah | Error jelas, tidak membocorkan detail, dapat coba lagi. |
| TC-13 | Manual | Persistensi lokal | Ubah preferensi lalu restart app | Preferensi tetap tersimpan. |
| TC-14 | Manual | Regresi fitur terkait | Buka layar terkait setelah aksi | Navigasi/state tidak rusak dan data konsisten. |

**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, dan golden test untuk layar dengan layout kompleks.

## 20. Gap, Risiko & Dependensi

### 20.1 Gap terdokumentasi

- PIN disimpan sebagai hash di `users.app_lock_pin_hash`; flag per akun juga disimpan lokal.
- Jangan menampilkan konten sensitif di snapshot task switcher.

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| PIN disimpan sebagai hash di `users.app_lock_pin_hash`; flag per akun juga disimpan lokal. | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |
| Preferensi tidak tersinkron | Tinggi | Rendah | Dokumentasikan sebagai lokal; jangan klaim sync. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | GET /profile/app-lock | AppLockController@show |
| Endpoint | PUT /profile/app-lock | AppLockController@update |
| Endpoint | POST /profile/app-lock/pin/verify | AppLockController@verifyPin |
| Endpoint | POST /profile/app-lock/face-verify | AppLockController@faceVerify |
| Endpoint | POST /auth/send-otp | AuthController@sendOtp |
| Endpoint | POST /auth/verify-otp | AuthController@verifyOtp |
| Database | users | Jangan query langsung dari klien. |
| Database | security_events | Jangan query langsung dari klien. |
| Database | whatsapp_otps | Jangan query langsung dari klien. |
| State/dependency | appLockServiceProvider | Komponen state/dependency terkait |
| State/dependency | currentAccountEmailProvider | Komponen state/dependency terkait |
| State/dependency | authProvider | Komponen state/dependency terkait |
| Route | /app-lock | Terdaftar di konfigurasi router aplikasi. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | Komponen/Referensi | Catatan |
|---|---|---|
| Layar/UI | `AppLockScreen` | Implementasi referensi aplikasi saat ini |
| State/dependency | `appLockServiceProvider` | Komponen state/dependency terkait |
| State/dependency | `currentAccountEmailProvider` | Komponen state/dependency terkait |
| State/dependency | `authProvider` | Komponen state/dependency terkait |
| Test | Sesuai platform target | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/auth/app-lock.md` | PRD ini |
| Prompt | `.skills/screens/auth/app-lock/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_init`, `_authenticateBiometric`, `_authenticateWithDeviceBiometric`, `_onPinDigit`, `_onPinDelete`, `_verifyPin`, `_verifyPassword`, `_forgotPin`, `_goHome`.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/auth/app-lock/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Implementasi aplikasi, route Laravel, skema PostgreSQL |
