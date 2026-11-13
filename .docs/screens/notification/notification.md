# Daftar Notifikasi

> **Fitur:** Notifikasi · **Route:** `/notifications` · **Akses:** Sanctum · **Tipe:** Daftar / koleksi
> **Implementasi referensi (aplikasi saat ini):** `NotificationScreen` · **State:** State management terpusat + state lokal · **Pola:** request-response
> **API:** 6 endpoint · **Tabel:** 3 · **Model:** 1
> Diverifikasi 6 November 2026 dari implementasi aplikasi saat ini, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Menampilkan daftar notifikasi, status baca, dan aksi hapus/tandai semua. |
| Aktor | Pelanggan terautentikasi (Sanctum) |
| Nilai pengguna | Menampilkan daftar notifikasi, status baca, dan aksi hapus/tandai semua. |
| Definisi sukses | Daftar tampil, dapat difilter/di-refresh, dan pagination tidak menduplikasi item. |
| Risiko utama | Preferensi notifikasi tidak disinkronkan ke backend (GAP-10). |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Menampilkan daftar notifikasi, status baca, dan aksi hapus/tandai semua. | Daftar tampil, dapat difilter/di-refresh, dan pagination tidak menduplikasi item. |

### 1.2 In scope

- Muat halaman notifikasi.
- Tandai satu/semua dibaca.
- Buka detail.
- Hapus notifikasi.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak mengubah data di luar aksi yang terlihat (refresh, buka detail, hapus bila ada).
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Dari ikon notifikasi atau route `/notifications`. |
| Route | `/notifications` |
| Parameter/extra | Tidak ada parameter khusus. |
| Guard | Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login. |
| Keluar ke | `/notification/:id` |
| Perilaku back | Gunakan navigasi kembali bawaan router; jangan membuat navigasi manual yang menduplikasi route. |

### 2.1 Layar terkait dalam fitur yang sama

| Layar | Route | PRD |
|---|---|---|
| `NotificationDetailScreen` | `/notification/:id` | [notification-detail.md](../notification/notification-detail.md) |

## 3. Alur Pengguna

1. Muat halaman notifikasi.
2. Tandai satu/semua dibaca.
3. Buka detail.
4. Hapus notifikasi.

**Decision points yang wajib diuji:**

- `kosong` → Empty state dengan penjelasan dan CTA lanjutan.
- `unread count gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Dari ikon notifikasi atau route /notifications."] --> B["Render awal / muat data"]
  B -->|sukses| C["Daftar notifikasi"]
  C --> D["Hapus notifikasi."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| Komponen/layar | `NotificationScreen` |
| Identifier | `NotificationScreen` |
| Tipe komponen | Komponen ber-state |
| Komponen state | Tersedia pada implementasi referensi |
| State management | State management terpusat + state lokal |
| Pola data | request-response |
| State/dependency | `authProvider`, `notificationListProvider` |
| Data source/repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Komponen UI bersama | `AppEmptyState`, `GuestAuthPrompt`, `AppBreadcrumbs` |
| Komponen UI fitur | Tidak terdeteksi |
| Model | `NotificationModel` |

### 4.2 Metode internal

`_navigateToNotification`.

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
│ Daftar Notifikasi                                                 │
├────────────────────────────────────────────────────────────────────┤
│ 1. Daftar notifikasi                                              │
│ 2. Badge unread                                                   │
│ 3. Tombol tandai semua                                            │
│ 4. Swipe/menu hapus                                               │
│ 5. Empty state                                                    │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `AppEmptyState`, `GuestAuthPrompt`, `AppBreadcrumbs`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Daftar notifikasi | Daftar | Tap item → buka detail; dukung refresh/pagination. | Skeleton saat muat; empty state; retry. |
| 2 | Badge unread | Status | Tampilkan kondisi koneksi/status; beri aksi retry bila perlu. | Perubahan status diumumkan; retry tersedia. |
| 3 | Tombol tandai semua | Aksi | Tap → jalankan aksi utama layar. | Disabled saat loading; error lewat SnackBar/inline. |
| 4 | Swipe/menu hapus | Menu | Pilih aksi kontekstual; tutup setelah aksi. | Dismiss aman; aksi destruktif beri konfirmasi. |
| 5 | Empty state | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |

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
| Pull to refresh | Ya |

## 7. Copywriting & Microcopy

Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai sistem lokalisasi/i18n yang konsisten dan mengikuti gaya bahasa layar lain.

| Lokasi | Draft copy | Catatan |
|---|---|---|
| Judul/header | Daftar Notifikasi | Samakan dengan label navigasi. |
| Subjudul | Menampilkan daftar notifikasi, status baca, dan aksi hapus/tandai semua. | Ringkas; jangan mengulang judul. |
| Tombol utama | Buka | [Usulan] Disabled saat proses. |
| Empty state | Belum ada daftar Notifikasi. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat daftar Notifikasi. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |
| Empty state | Belum ada daftar Notifikasi. | [Usulan] Sertakan CTA sesuai konteks. |
| Filter kosong | Tidak ada hasil yang cocok. | [Usulan] Tawarkan reset filter. |

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
| `unauthorized` | HTTP 401 | Sesi berakhir; arahkan login/Landing | Login ulang |
| `offline` | Koneksi putus | Banner/empty offline | Coba lagi saat online |
| `submitting` | Pengguna menekan aksi utama | Tombol disabled + progress | Selesai atau tampilkan error |
| `refreshing` | Pull to refresh | Spinner di atas konten | Selesai; reset halaman |
| `kosong` | Kondisi domain | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `unread count gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `GET` | `/notifications` | `NotificationController@index` | Sanctum | Daftar notifikasi |
| 2 | `POST` | `/notifications/{id}/read` | `NotificationController@markAsRead` | Sanctum | Menandai satu notifikasi dibaca |
| 3 | `POST` | `/notifications/read-all` | `NotificationController@markAllAsRead` | Sanctum | Tandai semua notifikasi dibaca |
| 4 | `GET` | `/notifications/unread-count` | `NotificationController@unreadCount` | Sanctum | Jumlah notifikasi belum dibaca |
| 5 | `DELETE` | `/notifications/{id}` | `NotificationController@destroy` | Sanctum | Menghapus notifikasi |
| 6 | `POST` | `/notifications/fcm-token` | `NotificationController@registerFcmToken` | Sanctum | Mendaftarkan token FCM |

### 10.2 Detail per endpoint

#### 10.2.1 `GET /notifications`

- **Controller:** `NotificationController@index`
- **Auth:** Sanctum
- **Kegunaan:** Daftar notifikasi
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/NotificationController/NotificationController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `data`, `pagination`, `message`
- **Pesan error terbaca:** “Gagal mengambil notifikasi”

#### 10.2.2 `POST /notifications/{id}/read`

- **Controller:** `NotificationController@markAsRead`
- **Auth:** Sanctum
- **Kegunaan:** Menandai satu notifikasi dibaca
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/NotificationController/NotificationController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `message`
- **Pesan error terbaca:** “Notifikasi ditandai sebagai sudah dibaca”; “Gagal menandai notifikasi sebagai sudah dibaca”

#### 10.2.3 `POST /notifications/read-all`

- **Controller:** `NotificationController@markAllAsRead`
- **Auth:** Sanctum
- **Kegunaan:** Tandai semua notifikasi dibaca
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/NotificationController/NotificationController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `message`
- **Pesan error terbaca:** “Semua notifikasi ditandai sebagai sudah dibaca”; “Gagal menandai semua notifikasi sebagai sudah dibaca”

#### 10.2.4 `GET /notifications/unread-count`

- **Controller:** `NotificationController@unreadCount`
- **Auth:** Sanctum
- **Kegunaan:** Jumlah notifikasi belum dibaca
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/NotificationController/NotificationController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `data`, `message`
- **Pesan error terbaca:** “Gagal mengambil jumlah notifikasi belum dibaca”

#### 10.2.5 `DELETE /notifications/{id}`

- **Controller:** `NotificationController@destroy`
- **Auth:** Sanctum
- **Kegunaan:** Menghapus notifikasi
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/NotificationController/NotificationController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `message`
- **Pesan error terbaca:** “Notifikasi berhasil dihapus”; “Gagal menghapus notifikasi”

#### 10.2.6 `POST /notifications/fcm-token`

- **Controller:** `NotificationController@registerFcmToken`
- **Auth:** Sanctum
- **Kegunaan:** Mendaftarkan token FCM
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/NotificationController/NotificationController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `token` | `required|string` | Ya |
| `platform` | `nullable|string|in:android,ios` | Tidak |
| `device_name` | `nullable|string|max:255` | Tidak |

- **Response top-level:** `status`, `message`
- **Pesan error terbaca:** “Token FCM berhasil didaftarkan”; “Gagal mendaftarkan token FCM”

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

### 10.4 Model yang dipakai

| Model | File | Field kunci |
|---|---|---|
| `NotificationModel` | implementasi referensi aplikasi | `id`, `type`, `title`, `body`, `data`, `read`, `readAt`, `createdAt` |

## 11. Data & Database

| Tabel | Peran | Akses | Kolom kunci |
|---|---|---|---|
| `notifications` | Notifikasi in-app. | Baca/tulis (indikasi) | `id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at` |
| `device_tokens` | Token FCM perangkat. | Baca/tulis (indikasi) | `id`, `user_id`, `token`, `type`, `created_at`, `updated_at` |
| `users` | Akun, profil, KYC, preferensi, dan pengaturan keamanan. | Baca/tulis (indikasi) | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance`, `email_verified_at`, `password` … |

Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service untuk memastikan operasi baca/tulis yang sebenarnya.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL langsung dari klien; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Badge mengikuti `unread-count`.
- Menghapus item mengurangi daftar tanpa reload penuh.

### 12.2 Validasi server yang terbaca dari controller

| Field | Aturan | Endpoint |
|---|---|---|
| `token` | `required|string` | `/notifications/fcm-token` |
| `platform` | `nullable|string|in:android,ios` | `/notifications/fcm-token` |
| `device_name` | `nullable|string|max:255` | `/notifications/fcm-token` |

### 12.3 Validasi client yang terdeteksi

- Tidak ada form input yang terdeteksi pada layar ini.

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan HTTP client/data source/repository yang sudah ada; jangan membuat client baru di komponen UI.
- Guest tidak boleh memanggil endpoint privat; tampilkan prompt autentikasi tamu.
- Pagination tidak boleh meminta halaman yang sama berulang.
- Refresh mereset halaman dan daftar.
- Hapus item secara optimistis hanya bila aksi reversibel; jika tidak, tunggu respons.

## 13. Error Handling

Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).

### 13.1 Kegagalan spesifik layar

- Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.
- Respons tidak sesuai envelope → tampilkan error umum, catat status code.
- 401 → bersihkan token dan arahkan ke Landing/login.
- 403 → tampilkan akses ditolak tanpa logout otomatis.
- 5xx → error server + retry; jangan menampilkan stack trace.
- Halaman berikutnya gagal → pertahankan item lama dan tampilkan retry footer.
- Gap: Preferensi notifikasi tidak disinkronkan ke backend (GAP-10).

## 14. Keamanan & Privasi

- Token hanya di secure storage; jangan di penyimpanan lokal atau log.
- Jangan menampilkan stack trace, query database, atau detail internal pada pengguna.
- Jangan mengirim PII ke analytics/crash report.
- Validasi kepemilikan resource di backend; client tidak boleh menentukan `user_id`.
- Guest tidak boleh mengirim Bearer token kosong atau mengakses resource privat.

## 15. Aksesibilitas

- Semua ikon/tombol non-teks memiliki label semantik.
- Target sentuh minimal 48×48 dp; jangan hanya mengandalkan ikon kecil.
- Kontras teks memenuhi WCAG AA pada mode terang dan gelap.
- Urutan fokus screen reader mengikuti urutan visual.
- Text scale 200% tidak memotong label atau tombol utama.
- Error form diumumkan dan terhubung ke field terkait.
- Hormati reduce-motion; animasi tidak boleh menghalangi interaksi.
- Item daftar memiliki label ringkas yang mencakup aksi utamanya.

## 16. Performa & Offline

- Gunakan `CachedNetworkImage`/cache yang ada untuk gambar jaringan.
- Hindari pekerjaan berat di `build()`; pindahkan parsing/format ke provider/util.
- Dispose controller, timer, dan subscription di `dispose`.
- Pull-to-refresh mereset halaman dan tidak menumpuk request.
- Gunakan `ListView.builder`/sliver agar item dibuat lazy.
- Tidak ada cache lokal terdeteksi; jangan menambah cache tanpa kebijakan kedaluwarsa.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_notification` | Layar dibuka | screen, route, auth | Tidak |
| `notification_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `notification_success` | Aksi utama berhasil | duration_ms | Tidak |
| `notification_failure` | Request/aksi gagal | error_code, status | Tidak |
| `notification_filter_applied` | Filter/sortir diterapkan | filter_count, sort | Tidak |
| `notification_pagination` | Halaman berikutnya dimuat | page | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Badge mengikuti `unread-count`.
- [ ] Menghapus item mengurangi daftar tanpa reload penuh.
- [ ] Tombol utama menjalankan aksi: Buka.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Dari ikon notifikasi atau route `/notifications`.
- [ ] Route/parameter sesuai: `/notifications`.
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
| TC-01 | Widget | Happy path | Buka layar melalui: Dari ikon notifikasi atau route `/notifications`. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /notifications dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
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
| TC-13 | Manual | Pagination | Scroll sampai akhir daftar | Halaman berikutnya dimuat sekali; tidak ada duplikasi. |
| TC-14 | Manual | Refresh | Tarik untuk refresh | Daftar/halaman direset dan data terbaru tampil. |
| TC-15 | Manual | Regresi fitur terkait | Buka layar terkait setelah aksi | Navigasi/state tidak rusak dan data konsisten. |

**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, dan golden test untuk layar dengan layout kompleks.

## 20. Gap, Risiko & Dependensi

### 20.1 Gap terdokumentasi

- Preferensi notifikasi tidak disinkronkan ke backend (GAP-10).

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| Preferensi notifikasi tidak disinkronkan ke backend (GAP-10). | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | GET /notifications | NotificationController@index |
| Endpoint | POST /notifications/{id}/read | NotificationController@markAsRead |
| Endpoint | POST /notifications/read-all | NotificationController@markAllAsRead |
| Endpoint | GET /notifications/unread-count | NotificationController@unreadCount |
| Endpoint | DELETE /notifications/{id} | NotificationController@destroy |
| Endpoint | POST /notifications/fcm-token | NotificationController@registerFcmToken |
| Database | notifications | Jangan query langsung dari klien. |
| Database | device_tokens | Jangan query langsung dari klien. |
| Database | users | Jangan query langsung dari klien. |
| State/dependency | authProvider | Komponen state/dependency terkait |
| State/dependency | notificationListProvider | Komponen state/dependency terkait |
| Route | /notifications | Terdaftar di konfigurasi router aplikasi. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | Komponen/Referensi | Catatan |
|---|---|---|
| Layar/UI | `NotificationScreen` | Implementasi referensi aplikasi saat ini |
| State/dependency | `authProvider` | Komponen state/dependency terkait |
| State/dependency | `notificationListProvider` | Komponen state/dependency terkait |
| Model/data | `NotificationModel` | Struktur data terkait |
| Komponen UI bersama | `AppEmptyState` | Komponen UI reusable |
| Komponen UI bersama | `GuestAuthPrompt` | Komponen UI reusable |
| Komponen UI bersama | `AppBreadcrumbs` | Komponen UI reusable |
| Test | Sesuai platform target | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/notification/notification.md` | PRD ini |
| Prompt | `.skills/screens/notification/notification/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_navigateToNotification`.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/notification/notification/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Implementasi aplikasi, route Laravel, skema PostgreSQL |
