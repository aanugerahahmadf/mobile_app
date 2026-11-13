# Landing

> **Fitur:** Splash & Landing · **Route:** `/landing` · **Akses:** Publik · **Tipe:** Konten / navigasi
> **Implementasi referensi (aplikasi saat ini):** `LandingScreen` · **State:** State management terpusat + state lokal · **Pola:** request-response
> **API:** 1 endpoint · **Tabel:** 2 · **Model:** 0
> Diverifikasi 6 November 2026 dari implementasi aplikasi saat ini, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Gerbang masuk satu pintu: checkbox persetujuan + tombol Google via Firebase; tamu hanya bisa membuka Customer Service tanpa login. |
| Aktor | Pengunjung publik |
| Nilai pengguna | Gerbang masuk satu pintu: checkbox persetujuan + tombol Google via Firebase; tamu hanya bisa membuka Customer Service tanpa login. |
| Definisi sukses | Konten utama tampil dan navigasi lanjutan berfungsi. |
| Risiko utama | Persetujuan diwajibkan lewat checkbox di UI sebelum autentikasi Google dimulai. |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Gerbang masuk satu pintu: checkbox persetujuan + tombol Google via Firebase; tamu hanya bisa membuka Customer Service tanpa login. | Konten utama tampil dan navigasi lanjutan berfungsi. |

### 1.2 In scope

- Tampilkan gambar hero, greeting, checkbox persetujuan, dan satu tombol Google.
- Pengguna wajib menyetujui Terms/Privacy/Wedding Policy lewat checkbox; saat dicentang, wizard persetujuan (`AuthModals`) ditampilkan dan persetujuan dicatat setelah diselesaikan. Tombol Google aktif setelah disetujui.
- Tap Google (saat setuju): set `onboarding_seen`, jalankan `GoogleSignIn.signIn()` lalu `FirebaseAuth.signInWithCredential()` untuk mendapat ID token.
- Kirim `firebase_id_token` (fallback `google_id_token`/`id_token`) ke `POST /auth/google`.
- Server memverifikasi token, menerbitkan token Sanctum, lalu lanjutan OTP/2FA/Complete Profile ditangani `AuthNavigation`.
- Sukses: set `onboarding_seen`, buka `/app-lock` bila app lock aktif, selain itu `/home`.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Awal aplikasi setelah startup, atau setelah logout. |
| Route | `/landing` |
| Parameter/extra | Tidak ada parameter khusus. |
| Guard | Tidak membutuhkan token. Tetap tangani 401/403 bila endpoint berubah menjadi privat. |
| Keluar ke | `/app-lock`, `/home`, `/chat-list` |
| Perilaku back | Gunakan navigasi kembali bawaan router; jangan membuat navigasi manual yang menduplikasi route. |

### 2.1 Layar terkait dalam fitur yang sama

| Layar | Route | PRD |
|---|---|---|
| `StartupScreen` | `/startup` | [startup.md](../splash/startup.md) |

## 3. Alur Pengguna

1. Tampilkan gambar hero, greeting, checkbox persetujuan, dan satu tombol Google.
2. Pengguna wajib menyetujui Terms/Privacy/Wedding Policy lewat checkbox; saat dicentang, wizard persetujuan (`AuthModals`) ditampilkan dan persetujuan dicatat setelah diselesaikan. Tombol Google aktif setelah disetujui.
3. Tap Google (saat setuju): set `onboarding_seen`, jalankan `GoogleSignIn.signIn()` lalu `FirebaseAuth.signInWithCredential()` untuk mendapat ID token.
4. Kirim `firebase_id_token` (fallback `google_id_token`/`id_token`) ke `POST /auth/google`.
5. Server memverifikasi token, menerbitkan token Sanctum, lalu lanjutan OTP/2FA/Complete Profile ditangani `AuthNavigation`.
6. Sukses: set `onboarding_seen`, buka `/app-lock` bila app lock aktif, selain itu `/home`.

**Decision points yang wajib diuji:**

- `login gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Awal aplikasi setelah startup, atau setelah logout."] --> B["Render awal / muat data"]
  B -->|sukses| C["Gambar hero"]
  C --> D["Sukses: set onboarding_seen, buka /app-lock bila app lock aktif, selain itu /home."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| Komponen/layar | `LandingScreen` |
| Identifier | `LandingScreen` |
| Tipe komponen | Komponen ber-state |
| Komponen state | Tersedia pada implementasi referensi |
| State management | State management terpusat + state lokal |
| Pola data | request-response |
| State/dependency | `authProvider`, `currentAccountEmailProvider`, `localeProvider` |
| Data source/repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Komponen UI bersama | `AppBlurBackdrop` |
| Komponen UI fitur | `SocialSignInButton`, `AuthModals` |
| Model | Tidak terdeteksi |

### 4.1 State lokal yang terdeteksi

| Field | Tipe | Peran |
|---|---|---|
| `_agreedToTerms` | `bool` | State lokal layar. |
| `_routeScheduled` | `bool` | State lokal layar. |

### 4.2 Metode internal

`_setAgreedToTerms`, `_markOnboardingSeen`, `_routeAfterAuth`, `_buildLandingUI`, `_openCs`, `_blob`, `_buildButtons`, `_buildFooter`.

### 4.3 Alur data

```text
UI / State layar
   ↓ baca/tulis
State management / dependency
   ↓
Repository / HTTP client
   ↓ REST
Controller Laravel → PostgreSQL (2 tabel terkait)
```

## 5. Blueprint UI

Wireframe konseptual dari daftar elemen registry. Urutan final mengikuti implementasi aplikasi.

```text
┌────────────────────────────────────────────────────────────────────┐
│ Landing                                                           │
├────────────────────────────────────────────────────────────────────┤
│ 1. Gambar hero                                                    │
│ 2. Greeting selamat datang                                        │
│ 3. Checkbox persetujuan Terms/Privacy/Wedding Policy              │
│ 4. Tombol Google (`SocialSignInButton`, nonaktif sampai           │
│ disetujui)                                                        │
│ 5. Ikon Customer Service (guest chat)                             │
│ 6. Footer persetujuan Terms/Privacy/Policy                        │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `AppBlurBackdrop`
- Fitur: `SocialSignInButton`, `AuthModals`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Gambar hero | Lampiran | Pilih file; validasi tipe/ukuran sebelum upload. | Progress upload; error tipe/ukuran. |
| 2 | Greeting selamat datang | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |
| 3 | Checkbox persetujuan Terms/Privacy/Wedding Policy | Toggle | Ubah preferensi; simpan segera atau lewat tombol simpan. | Simpan optimistic dengan rollback bila gagal. |
| 4 | Tombol Google (`SocialSignInButton`, nonaktif sampai disetujui) | Aksi | Tap → jalankan aksi utama layar. | Disabled saat loading; error lewat SnackBar/inline. |
| 5 | Ikon Customer Service (guest chat) | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |
| 6 | Footer persetujuan Terms/Privacy/Policy | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |

### 6.1 Fakta teknis form & interaksi

| Fakta | Nilai |
|---|---|
| TextEditingController | 0 |
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
| Judul/header | Landing | Samakan dengan label navigasi. |
| Subjudul | Gerbang masuk satu pintu: checkbox persetujuan + tombol Google via Firebase; tamu hanya b… | Ringkas; jangan mengulang judul. |
| Tombol utama | Lanjutkan | [Usulan] Disabled saat proses. |
| Empty state | Belum ada landing. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat landing. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |

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
| `empty` | Data kosong | Empty state dengan penjelasan + CTA | Refresh atau aksi lanjutan |
| `error` | Request gagal | Pesan ramah + tombol coba lagi | Retry |
| `offline` | Koneksi putus | Banner/empty offline | Coba lagi saat online |
| `submitting` | Pengguna menekan aksi utama | Tombol disabled + progress | Selesai atau tampilkan error |
| `belum setuju (tombol Google nonaktif)` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `loading (`AuthLoading`)` | Kondisi domain | Skeleton/spinner; blokir aksi ganda. | Ikuti aksi pemulihan pada pesan |
| `login gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `2FA diperlukan` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `OTP/Complete Profile` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `guest chat` | Kondisi domain | Tampilkan prompt autentikasi tamu; jangan panggil endpoint privat. | Ikuti aksi pemulihan pada pesan |
| `app lock` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `POST` | `/auth/google` | `AuthController@googleLogin` | Publik | Login Google memakai Firebase ID token |

### 10.2 Detail per endpoint

#### 10.2.1 `POST /auth/google`

- **Controller:** `AuthController@googleLogin`
- **Auth:** Publik
- **Kegunaan:** Login Google memakai Firebase ID token
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/AuthController/AuthController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `firebase_id_token` | `nullable|string` | Tidak |
| `google_id_token` | `nullable|string` | Tidak |
| `id_token` | `nullable|string` | Tidak |

- **Response top-level:** `status`, `message`, `data`, `error_code`
- **Pesan error terbaca:** “Token Firebase tidak valid atau sudah kedaluwarsa”; “Login berhasil”; “Akun Google kamu sudah terdaftar. Silakan masuk dengan email dan password.”; “Registrasi berhasil”

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
| `personal_access_tokens` | Token Sanctum perangkat. | Baca/tulis (indikasi) | `id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at` |

Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service untuk memastikan operasi baca/tulis yang sebenarnya.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL langsung dari klien; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.
- Preferensi lokal disimpan di penyimpanan lokal; token tetap di secure storage.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Tombol Google hanya aktif bila checkbox persetujuan dicentang dan tidak sedang loading.
- Login Google sukses menyimpan token Sanctum lalu membuka Home/AppLock.
- Layar ini tidak menampilkan form email/password, tombol daftar, maupun tombol guest.

### 12.2 Validasi server yang terbaca dari controller

| Field | Aturan | Endpoint |
|---|---|---|
| `firebase_id_token` | `nullable|string` | `/auth/google` |
| `google_id_token` | `nullable|string` | `/auth/google` |
| `id_token` | `nullable|string` | `/auth/google` |

### 12.3 Validasi client yang terdeteksi

- Tidak ada form input yang terdeteksi pada layar ini.

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan HTTP client/data source/repository yang sudah ada; jangan membuat client baru di komponen UI.
- Guest tidak boleh memanggil endpoint privat; tampilkan prompt autentikasi tamu.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 13. Error Handling

Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).

### 13.1 Kegagalan spesifik layar

- Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.
- Respons tidak sesuai envelope → tampilkan error umum, catat status code.
- 401 → bersihkan token dan arahkan ke Landing/login.
- 403 → tampilkan akses ditolak tanpa logout otomatis.
- 5xx → error server + retry; jangan menampilkan stack trace.
- Gap: Persetujuan diwajibkan lewat checkbox di UI sebelum autentikasi Google dimulai.
- Gap: Layar ini hanya memakai satu endpoint (`/auth/google`); jalur email/password tetap ada di backend tetapi tidak dimount dari Landing.
- Gap: Login Google memakai Firebase ID token, sesi tetap Sanctum (bukan sesi Firebase).

## 14. Keamanan & Privasi

- Token hanya di secure storage; jangan di penyimpanan lokal atau log.
- Jangan menampilkan stack trace, query database, atau detail internal pada pengguna.
- Jangan mengirim PII ke analytics/crash report.
- Validasi kepemilikan resource di backend; client tidak boleh menentukan `user_id`.

## 15. Aksesibilitas

- Semua ikon/tombol non-teks memiliki label semantik.
- Target sentuh minimal 48×48 dp; jangan hanya mengandalkan ikon kecil.
- Kontras teks memenuhi WCAG AA pada mode terang dan gelap.
- Urutan fokus screen reader mengikuti urutan visual.
- Text scale 200% tidak memotong label atau tombol utama.
- Error form diumumkan dan terhubung ke field terkait.
- Hormati reduce-motion; animasi tidak boleh menghalangi interaksi.

## 16. Performa & Offline

- Gunakan `CachedNetworkImage`/cache yang ada untuk gambar jaringan.
- Hindari pekerjaan berat di `build()`; pindahkan parsing/format ke provider/util.
- Dispose controller, timer, dan subscription di `dispose`.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_landing` | Layar dibuka | screen, route, auth | Tidak |
| `landing_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `landing_success` | Aksi utama berhasil | duration_ms | Tidak |
| `landing_failure` | Request/aksi gagal | error_code, status | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Tombol Google hanya aktif bila checkbox persetujuan dicentang dan tidak sedang loading.
- [ ] Login Google sukses menyimpan token Sanctum lalu membuka Home/AppLock.
- [ ] Layar ini tidak menampilkan form email/password, tombol daftar, maupun tombol guest.
- [ ] Tombol utama menjalankan aksi: Lanjutkan.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Awal aplikasi setelah startup, atau setelah logout.
- [ ] Route/parameter sesuai: `/landing`.
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
| TC-01 | Widget | Happy path | Buka layar melalui: Awal aplikasi setelah startup, atau setelah logout. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /landing dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
| TC-03 | Manual | Loading | Buka layar dengan jaringan lambat | Skeleton/spinner tampil; aksi utama disabled. |
| TC-04 | Manual | Empty | Gunakan akun/data tanpa item | Empty state tampil dengan CTA yang sesuai. |
| TC-05 | Manual | Error server | Mock respons 500 | Pesan error + tombol coba lagi; aplikasi tidak crash. |
| TC-06 | Manual | Akses ditolak | Mock respons 403 | Pesan akses ditolak; tidak logout otomatis. |
| TC-07 | Manual | Offline | Matikan jaringan lalu muat/aksi | Pesan offline + retry; data lama (bila ada) tidak hilang. |
| TC-08 | Widget | Double submit | Tekan aksi utama cepat dua kali | Hanya satu request; tombol disabled saat proses. |
| TC-09 | Manual | Layar kecil | Uji lebar 320 px dan landscape | Tidak ada overflow; tombol tetap terjangkau. |
| TC-10 | Manual | Mode gelap | Aktifkan dark mode sistem | Semua teks/komponen terbaca; tidak ada warna hardcode yang pecah. |
| TC-11 | Manual | Aksesibilitas | Aktifkan screen reader dan text scale 200% | Label terbaca; tidak ada teks terpotong. |
| TC-12 | Manual | Regresi fitur terkait | Buka layar terkait setelah aksi | Navigasi/state tidak rusak dan data konsisten. |

**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, dan golden test untuk layar dengan layout kompleks.

## 20. Gap, Risiko & Dependensi

### 20.1 Gap terdokumentasi

- Persetujuan diwajibkan lewat checkbox di UI sebelum autentikasi Google dimulai.
- Layar ini hanya memakai satu endpoint (`/auth/google`); jalur email/password tetap ada di backend tetapi tidak dimount dari Landing.
- Login Google memakai Firebase ID token, sesi tetap Sanctum (bukan sesi Firebase).

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| Persetujuan diwajibkan lewat checkbox di UI sebelum autentikasi Google dimulai. | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | POST /auth/google | AuthController@googleLogin |
| Database | users | Jangan query langsung dari klien. |
| Database | personal_access_tokens | Jangan query langsung dari klien. |
| State/dependency | authProvider | Komponen state/dependency terkait |
| State/dependency | currentAccountEmailProvider | Komponen state/dependency terkait |
| State/dependency | localeProvider | Komponen state/dependency terkait |
| Route | /landing | Terdaftar di konfigurasi router aplikasi. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | Komponen/Referensi | Catatan |
|---|---|---|
| Layar/UI | `LandingScreen` | Implementasi referensi aplikasi saat ini |
| State/dependency | `authProvider` | Komponen state/dependency terkait |
| State/dependency | `currentAccountEmailProvider` | Komponen state/dependency terkait |
| State/dependency | `localeProvider` | Komponen state/dependency terkait |
| Komponen UI bersama | `AppBlurBackdrop` | Komponen UI reusable |
| Komponen UI fitur | `SocialSignInButton` | Komponen UI khusus fitur |
| Komponen UI fitur | `AuthModals` | Komponen UI khusus fitur |
| Test | Sesuai platform target | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/splash/landing.md` | PRD ini |
| Prompt | `.skills/screens/splash/landing/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_setAgreedToTerms`, `_markOnboardingSeen`, `_routeAfterAuth`, `_buildLandingUI`, `_openCs`, `_blob`, `_buildButtons`, `_buildFooter`.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/splash/landing/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Implementasi aplikasi, route Laravel, skema PostgreSQL |
