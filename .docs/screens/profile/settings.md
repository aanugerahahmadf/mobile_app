# Pengaturan

> **Fitur:** Profil & Pengaturan · **Route:** `/settings` · **Akses:** Sanctum · **Tipe:** Formulir
> **Implementasi:** `lib/Features/Profile/Presentation/Screens/Settings/SettingsScreen.dart` — `SettingsScreen` (665 baris) · **State:** Riverpod + state lokal (`setState`) · **Pola:** request-response
> **API:** 4 endpoint · **Tabel:** 2 · **Model:** 0
> Diverifikasi 6 November 2026 dari kode Flutter, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Pusat pengaturan aplikasi: bahasa, notifikasi, tampilan, keamanan, app lock, penyimpanan, dan hapus akun. |
| Aktor | Pelanggan terautentikasi (Sanctum) |
| Nilai pengguna | Pusat pengaturan aplikasi: bahasa, notifikasi, tampilan, keamanan, app lock, penyimpanan, dan hapus akun. |
| Definisi sukses | Data tersimpan dan validasi backend terpetakan ke field. |
| Risiko utama | Preferensi notifikasi/bahasa tidak disinkronkan ke backend (GAP-09/GAP-10). |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Pusat pengaturan aplikasi: bahasa, notifikasi, tampilan, keamanan, app lock, penyimpanan, dan hapus akun. | Data tersimpan dan validasi backend terpetakan ke field. |

### 1.2 In scope

- Muat preferensi lokal dan status app lock.
- Ubah tema/bahasa/notifikasi.
- Buka sublayar keamanan/penyimpanan.
- Hapus akun dengan konfirmasi.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Dari `ProfileScreen`. |
| Route | `/settings` |
| Parameter/extra | Tidak ada parameter khusus. |
| Guard | Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login. |
| Keluar ke | `/landing`, `/language`, `/notification-settings`, `/password-and-security`, `/storage-and-data` |
| Perilaku back | Jika ada perubahan belum disimpan, tampilkan konfirmasi sebelum keluar. [Usulan] |

### 2.1 Layar terkait dalam fitur yang sama

| Layar | Route | PRD |
|---|---|---|
| `ProfileScreen` | `/profile` | [profile.md](../profile/profile.md) |
| `EditProfileScreen` | `/edit-profile` | [edit-profile.md](../profile/edit-profile.md) |
| `ProfileFieldScreen` | `/profile-field` | [profile-field.md](../profile/profile-field.md) |
| `DocumentScannerScreen` | `/document-scanner` | [document-scanner.md](../profile/document-scanner.md) |

## 3. Alur Pengguna

1. Muat preferensi lokal dan status app lock.
2. Ubah tema/bahasa/notifikasi.
3. Buka sublayar keamanan/penyimpanan.
4. Hapus akun dengan konfirmasi.

**Decision points yang wajib diuji:**

- `toggle gagal` → Pesan ramah + retry; pertahankan input pengguna.
- `hapus akun gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Dari ProfileScreen."] --> B["Render awal / muat data"]
  B -->|sukses| C["Grup pengaturan"]
  C --> D["Hapus akun dengan konfirmasi."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| File | `lib/Features/Profile/Presentation/Screens/Settings/SettingsScreen.dart` |
| Kelas layar | `SettingsScreen` |
| Base widget | `ConsumerStatefulWidget` |
| Kelas state | `_SettingsPageState` |
| State management | Riverpod + state lokal (`setState`) |
| Pola data | request-response |
| Provider | `authProvider`, `fingerprintUnlockProvider`, `faceUnlockProvider`, `currentAccountEmailProvider`, `pinUnlockProvider`, `themeProvider`, `passwordUnlockProvider` |
| Repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Widget inti | `GuestAuthPrompt`, `AppBreadcrumbs` |
| Widget fitur | `PinSetupSheet`, `PasswordSetupSheet` |
| Model | Tidak terdeteksi |

### 4.1 State lokal yang terdeteksi

| Field | Tipe | Peran |
|---|---|---|
| `_cacheSize` | `int?` | State lokal layar. |

### 4.2 Metode internal

`_refreshCacheSize`, `_showGuestPrompt`, `_runPrivate`, `_enableBiometric`, `_editBiometric`, `_deleteBiometric`, `_addPin`, `_editPin`, `_deletePin`, `_addPassword`, `_editPassword`, `_deletePassword`, `_confirmDeleteBiometric`, `_deleteAccount`, `_clearCache`, `_lockMethodCard`, `_menuTile`.

### 4.3 Alur data

```text
Widget / State
   ↓ baca/tulis
Provider Riverpod
   ↓
Repository / DioClient
   ↓ REST
Controller Laravel → PostgreSQL (2 tabel terkait)
```

## 5. Blueprint UI

Wireframe konseptual dari daftar elemen registry. Urutan final mengikuti file implementasi.

```text
┌────────────────────────────────────────────────────────────────────┐
│ Pengaturan                                                        │
├────────────────────────────────────────────────────────────────────┤
│ 1. Grup pengaturan                                                │
│ 2. Switch tema                                                    │
│ 3. Menu keamanan                                                  │
│ 4. Menu penyimpanan                                               │
│ 5. Tombol hapus akun                                              │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `GuestAuthPrompt`, `AppBreadcrumbs`
- Fitur: `PinSetupSheet`, `PasswordSetupSheet`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Grup pengaturan | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |
| 2 | Switch tema | Toggle | Ubah preferensi; simpan segera atau lewat tombol simpan. | Simpan optimistic dengan rollback bila gagal. |
| 3 | Menu keamanan | Menu | Pilih aksi kontekstual; tutup setelah aksi. | Dismiss aman; aksi destruktif beri konfirmasi. |
| 4 | Menu penyimpanan | Menu | Pilih aksi kontekstual; tutup setelah aksi. | Dismiss aman; aksi destruktif beri konfirmasi. |
| 5 | Tombol hapus akun | Aksi | Tap → jalankan aksi utama layar. | Disabled saat loading; error lewat SnackBar/inline. |

### 6.1 Fakta teknis form & interaksi

| Fakta | Nilai |
|---|---|
| TextEditingController | 1 |
| Field teks/form | 1 |
| Dropdown | 0 |
| Switch/toggle | 1 |
| Validator client | 0 |
| Field password (`obscureText`) | 0 |
| maxLength | Tidak terdeteksi |
| Keyboard | emailAddress |
| Input formatter | Tidak terdeteksi |
| Upload file | Tidak |
| Kamera | Tidak |
| WebView | Tidak |
| Timer/polling | Tidak |
| Pagination | Tidak |
| Pull to refresh | Tidak |

## 7. Copywriting & Microcopy

Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai `AppLocalizations` dan mengikuti gaya bahasa layar lain.

| Lokasi | Draft copy | Catatan |
|---|---|---|
| Judul/header | Pengaturan | Samakan dengan label navigasi. |
| Subjudul | Pusat pengaturan aplikasi: bahasa, notifikasi, tampilan, keamanan, app lock, penyimpanan,… | Ringkas; jangan mengulang judul. |
| Tombol utama | Simpan | [Usulan] Disabled saat proses. |
| Empty state | Belum ada pengaturan. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat pengaturan. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama yang salah. |
| Sukses | Data berhasil disimpan. | [Usulan] Kembali ke layar sebelumnya. |

## 8. Design System & Responsif

### 8.1 Token yang wajib dipakai

| Token | Nilai |
|---|---|
| Font | Instrument Sans (W400/W600), aset lokal |
| Warna primer | `AppColors.primaryColor` = `#1E3A5F` |
| Aksen | `AppColors.accentColor` = `#C9A94E` |
| Background light | `AppColors.backgroundColor` = `#F8F6F7` |
| Surface light | `AppColors.surfaceColor` = `#FFFFFF` |
| Background dark | `AppColors.darkBackground` = `#121212` |
| Surface dark | `AppColors.darkSurface` = `#1E1E1E` |
| Teks primer light | `#1A1A2E`; dark `#E8E8E8` |
| Teks sekunder light | `#8E8E9A`; dark `#A0A0A0` |
| Sukses/error/warning/info | `#10B981` / `#EF4444` / `#F59E0B` / `#3B82F6` |
| Tipografi | `headTitle` 22/w600; `subHeadTitle` 16/w400; `h3` 14/w600; `h4` 12/w400; `description` 14/1.4 |
| Spacing | `AppSizes` 2, 4, 8, 16, 24, 32, 48, 64 |
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
- Jangan hardcode warna; gunakan `AppColors`/`AppTheme` agar mode gelap bekerja.
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
| `unauthorized` | HTTP 401 | Sesi berakhir; arahkan login/Landing | Login ulang |
| `offline` | Koneksi putus | Banner/empty offline | Coba lagi saat online |
| `submitting` | Pengguna menekan aksi utama | Tombol disabled + progress | Selesai atau tampilkan error |
| `guest` | Kondisi domain | Tampilkan `GuestAuthPrompt`; jangan panggil endpoint privat. | Ikuti aksi pemulihan pada pesan |
| `toggle gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `hapus akun gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `GET` | `/profile/app-lock` | `AppLockController@show` | Sanctum | Konfigurasi app lock |
| 2 | `PUT` | `/profile/app-lock` | `AppLockController@update` | Sanctum | Konfigurasi app lock |
| 3 | `DELETE` | `/user/account` | `AuthController@deleteAccount` | Sanctum | Menghapus akun |
| 4 | `POST` | `/logout` | `AuthController@logout` | Sanctum | Mencabut token Sanctum aktif |

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

#### 10.2.3 `DELETE /user/account`

- **Controller:** `AuthController@deleteAccount`
- **Auth:** Sanctum
- **Kegunaan:** Menghapus akun
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/AuthController/AuthController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `password` | `required` | Ya |

- **Response top-level:** `status`, `message`
- **Pesan error terbaca:** “Password tidak valid”; “Akun berhasil dihapus”

#### 10.2.4 `POST /logout`

- **Controller:** `AuthController@logout`
- **Auth:** Sanctum
- **Kegunaan:** Mencabut token Sanctum aktif
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/AuthController/AuthController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `message`
- **Pesan error terbaca:** “Berhasil keluar”

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
- Jangan mengakses PostgreSQL dari Flutter; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Preferensi lokal langsung diterapkan.
- Fitur privat meminta login sebelum membuka.

### 12.2 Validasi server yang terbaca dari controller

| Field | Aturan | Endpoint |
|---|---|---|
| `fingerprint_enabled` | `sometimes|boolean` | `/profile/app-lock` |
| `face_enabled` | `sometimes|boolean` | `/profile/app-lock` |
| `pin_enabled` | `sometimes|boolean` | `/profile/app-lock` |
| `password` | `required` | `/user/account` |

### 12.3 Validasi client yang terdeteksi

- Form memiliki **1 field** dan **0 validator** client.
- Keyboard: emailAddress.
- Validasi client hanya untuk UX; hasil final tetap dari backend (`422`).

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan `DioClient`/repository yang sudah ada; jangan membuat instance Dio baru.
- Guest tidak boleh memanggil endpoint privat; tampilkan `GuestAuthPrompt`.
- Validasi client untuk UX; validasi final di backend.
- Pertahankan input saat 422/network error.

## 13. Error Handling

Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).

### 13.1 Kegagalan spesifik layar

- Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.
- Respons tidak sesuai envelope → tampilkan error umum, catat status code.
- 401 → bersihkan token dan arahkan ke Landing/login.
- 403 → tampilkan akses ditolak tanpa logout otomatis.
- 5xx → error server + retry; jangan menampilkan stack trace.
- 422 → petakan `errors` ke field; fokus ke field pertama.
- Gap: Preferensi notifikasi/bahasa tidak disinkronkan ke backend (GAP-09/GAP-10).

## 14. Keamanan & Privasi

- Token hanya di `FlutterSecureStorage`; jangan di `SharedPreferences` atau log.
- Jangan menampilkan stack trace, query database, atau detail internal pada pengguna.
- Jangan mengirim PII ke analytics/crash report.
- Validasi kepemilikan resource di backend; client tidak boleh menentukan `user_id`.
- Data identitas (nama, email, telepon, alamat, KTP, selfie) adalah PII; batasi tampilan dan log.
- Guest tidak boleh mengirim Bearer token kosong atau mengakses resource privat.

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
- Tidak ada cache lokal terdeteksi; jangan menambah cache tanpa kebijakan kedaluwarsa.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_settings` | Layar dibuka | screen, route, auth | Tidak |
| `settings_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `settings_success` | Aksi utama berhasil | duration_ms | Tidak |
| `settings_failure` | Request/aksi gagal | error_code, status | Tidak |
| `settings_validation_failed` | Validasi gagal | field_count | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Preferensi lokal langsung diterapkan.
- [ ] Fitur privat meminta login sebelum membuka.
- [ ] Tombol utama menjalankan aksi: Simpan.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Dari `ProfileScreen`.
- [ ] Route/parameter sesuai: `/settings`.
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

- [ ] `flutter analyze` bersih untuk file yang diubah.
- [ ] Test happy path dan minimal satu error path ditambahkan/diperbarui.
- [ ] PRD/SKILL diperbarui bila route, endpoint, atau tabel berubah.

## 19. Test Plan

| ID | Jenis | Skenario | Langkah | Hasil yang diharapkan |
|---|---|---|---|---|
| TC-01 | Widget | Happy path | Buka layar melalui: Dari `ProfileScreen`. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /settings dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
| TC-03 | Manual | Loading | Buka layar dengan jaringan lambat | Skeleton/spinner tampil; aksi utama disabled. |
| TC-04 | Manual | Empty | Gunakan akun/data tanpa item | Empty state tampil dengan CTA yang sesuai. |
| TC-05 | Manual | Error server | Mock respons 500 | Pesan error + tombol coba lagi; aplikasi tidak crash. |
| TC-06 | Manual | Sesi habis | Gunakan token kedaluwarsa/401 | Token dibersihkan; diarahkan ke Landing/login. |
| TC-07 | Manual | Akses ditolak | Mock respons 403 | Pesan akses ditolak; tidak logout otomatis. |
| TC-08 | Manual | Offline | Matikan jaringan lalu muat/aksi | Pesan offline + retry; data lama (bila ada) tidak hilang. |
| TC-09 | Widget | Double submit | Tekan aksi utama cepat dua kali | Hanya satu request; tombol disabled saat proses. |
| TC-10 | Manual | Layar kecil | Uji lebar 320 px dan landscape | Tidak ada overflow; tombol tetap terjangkau. |
| TC-11 | Manual | Mode gelap | Aktifkan dark mode sistem | Semua teks/komponen terbaca; tidak ada warna hardcode yang pecah. |
| TC-12 | Manual | Aksesibilitas | Aktifkan screen reader dan text scale 200% | Label terbaca; tidak ada teks terpotong. |
| TC-13 | Widget | Validasi kosong | Submit form kosong | Error inline per field; fokus ke field pertama. |
| TC-14 | Manual | Validasi 422 | Mock 422 dengan errors | Error dipetakan ke field; input dipertahankan. |
| TC-15 | Manual | Regresi fitur terkait | Buka layar terkait setelah aksi | Navigasi/state tidak rusak dan data konsisten. |

**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, dan golden test untuk layar dengan layout kompleks.

## 20. Gap, Risiko & Dependensi

### 20.1 Gap terdokumentasi

- Preferensi notifikasi/bahasa tidak disinkronkan ke backend (GAP-09/GAP-10).

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| Preferensi notifikasi/bahasa tidak disinkronkan ke backend (GAP-09/GAP-10). | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | GET /profile/app-lock | AppLockController@show |
| Endpoint | PUT /profile/app-lock | AppLockController@update |
| Endpoint | DELETE /user/account | AuthController@deleteAccount |
| Endpoint | POST /logout | AuthController@logout |
| Database | users | Jangan query langsung dari Flutter. |
| Database | personal_access_tokens | Jangan query langsung dari Flutter. |
| Provider | authProvider | lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart |
| Provider | fingerprintUnlockProvider | lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart |
| Provider | faceUnlockProvider | lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart |
| Provider | currentAccountEmailProvider | lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart |
| Provider | pinUnlockProvider | lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart |
| Provider | themeProvider | lib/Core/Providers/ThemeProvider/ThemeProvider.dart |
| Provider | passwordUnlockProvider | lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart |
| Route | /settings | Terdaftar di `AppRouter`. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | File/Simbol | Catatan |
|---|---|---|
| Screen | `lib/Features/Profile/Presentation/Screens/Settings/SettingsScreen.dart` · `SettingsScreen` | 665 baris |
| Provider | `authProvider` | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` |
| Provider | `fingerprintUnlockProvider` | `lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart` |
| Provider | `faceUnlockProvider` | `lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart` |
| Provider | `currentAccountEmailProvider` | `lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart` |
| Provider | `pinUnlockProvider` | `lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart` |
| Provider | `themeProvider` | `lib/Core/Providers/ThemeProvider/ThemeProvider.dart` |
| Provider | `passwordUnlockProvider` | `lib/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart` |
| Widget inti | `GuestAuthPrompt` | `lib/Core/Widgets/GuestAuthPrompt/` |
| Widget inti | `AppBreadcrumbs` | `lib/Core/Widgets/AppBreadcrumbs/` |
| Widget fitur | `PinSetupSheet` | Berada di `Presentation/Widgets/` fitur terkait |
| Widget fitur | `PasswordSetupSheet` | Berada di `Presentation/Widgets/` fitur terkait |
| Test | `test/Features/Profil/` | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/profile/settings.md` | PRD ini |
| Prompt | `.skills/screens/profile/settings/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_refreshCacheSize`, `_showGuestPrompt`, `_runPrivate`, `_enableBiometric`, `_editBiometric`, `_deleteBiometric`, `_addPin`, `_editPin`, `_deletePin`, `_addPassword`, `_editPassword`, `_deletePassword`, `_confirmDeleteBiometric`, `_deleteAccount`, `_clearCache`, `_lockMethodCard`, `_menuTile`.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/profile/settings/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Kode Flutter, route Laravel, skema PostgreSQL |
