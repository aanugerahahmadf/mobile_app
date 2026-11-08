# Daftar Chat

> **Fitur:** Chat & Panggilan · **Route:** `/chat-list` · **Akses:** Guest + Sanctum · **Tipe:** Chat / real-time
> **Implementasi:** `lib/Features/Chat/Presentation/Screens/ChatList/ChatListScreen.dart` — `ChatListScreen` (784 baris) · **State:** Riverpod + state lokal (`setState`) · **Pola:** request-response
> **API:** 4 endpoint · **Tabel:** 3 · **Model:** 0
> Diverifikasi 6 November 2026 dari kode Flutter, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Menampilkan daftar percakapan pengguna atau guest, jumlah belum dibaca, dan pintu masuk ke detail. |
| Aktor | Guest dan pelanggan terautentikasi |
| Nilai pengguna | Menampilkan daftar percakapan pengguna atau guest, jumlah belum dibaca, dan pintu masuk ke detail. |
| Definisi sukses | Pesan terkirim/diterima dan state panggilan pulih setelah reconnect. |
| Risiko utama | Tidak ada tab bottom navigation untuk chat meski branch shell aktif. |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Menampilkan daftar percakapan pengguna atau guest, jumlah belum dibaca, dan pintu masuk ke detail. | Pesan terkirim/diterima dan state panggilan pulih setelah reconnect. |
| Guest | Mencoba melihat konten tanpa akun; diarahkan login pada aksi privat | Konten publik tampil dan prompt login muncul tepat pada aksi privat |

### 1.2 In scope

- Muat percakapan login atau guest.
- Urutkan berdasarkan pesan terakhir.
- Tampilkan unread badge.
- Buka `/chat/:id` dengan mode yang sesuai.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak menyimpan riwayat pesan permanen di perangkat di luar cache yang sudah ada.
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Cabang shell `/chat-list` (tidak terlihat di bottom navigation) atau notifikasi. |
| Route | `/chat-list` |
| Parameter/extra | `extra: {isGuestMode: bool}` opsional. |
| Guard | Guest boleh membuka layar, tetapi aksi privat harus memunculkan `GuestAuthPrompt` dan tidak mengirim Bearer token kosong. |
| Keluar ke | `/chat/:id`, `/chat/:conversations` |
| Perilaku back | State tab dipertahankan oleh `StatefulShellRoute.indexedStack`; kembali tidak boleh mereset cabang lain. [Usulan] |

### 2.1 Layar terkait dalam fitur yang sama

| Layar | Route | PRD |
|---|---|---|
| `ChatDetailScreen` | `/chat/:id` | [chat-detail.md](../chat/chat-detail.md) |

## 3. Alur Pengguna

1. Muat percakapan login atau guest.
2. Urutkan berdasarkan pesan terakhir.
3. Tampilkan unread badge.
4. Buka `/chat/:id` dengan mode yang sesuai.

**Decision points yang wajib diuji:**

- `kosong` → Empty state dengan penjelasan dan CTA lanjutan.
- `polling gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Cabang shell /chat-list (tidak terlihat di bottom navigation) atau notifikasi."] --> B["Render awal / muat data"]
  B -->|sukses| C["Daftar percakapan"]
  C --> D["Buka /chat/:id dengan mode yang sesuai."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| File | `lib/Features/Chat/Presentation/Screens/ChatList/ChatListScreen.dart` |
| Kelas layar | `ChatListScreen` |
| Base widget | `ConsumerStatefulWidget` |
| Kelas state | `_ChatListPageState` |
| State management | Riverpod + state lokal (`setState`) |
| Pola data | request-response |
| Provider | `guestModeProvider`, `authProvider`, `chatProvider` |
| Repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Widget inti | `AppButton`, `AppBreadcrumbs` |
| Widget fitur | Tidak terdeteksi |
| Model | Tidak terdeteksi |

### 4.1 State lokal yang terdeteksi

| Field | Tipe | Peran |
|---|---|---|
| `_loading` | `bool` | Menandai proses muat/aksi. |
| `_searchController` | `TextEditingController` | Controller input; wajib dispose. |
| `_searchQuery` | `String` | Filter/sortir lokal. |

### 4.2 Metode internal

`_showError`, `_startOrOpenChat`, `_startChatWithCategory`, `_buildUserView`, `_buildStatusCard`, `_buildConversationCard`, `_buildAvatarContent`, `_buildCsActionCard`.

### 4.3 Alur data

```text
Widget / State
   ↓ baca/tulis
Provider Riverpod
   ↓
Repository / DioClient
   ↓ REST
Controller Laravel → PostgreSQL (3 tabel terkait)
```

## 5. Blueprint UI

Wireframe konseptual dari daftar elemen registry. Urutan final mengikuti file implementasi.

```text
┌────────────────────────────────────────────────────────────────────┐
│ Daftar Chat                                                       │
├────────────────────────────────────────────────────────────────────┤
│ 1. Daftar percakapan                                              │
│ 2. Avatar                                                         │
│ 3. Pesan terakhir                                                 │
│ 4. Badge unread                                                   │
│ 5. Empty state                                                    │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `AppButton`, `AppBreadcrumbs`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Daftar percakapan | Daftar | Tap item → buka detail; dukung refresh/pagination. | Skeleton saat muat; empty state; retry. |
| 2 | Avatar | Media native | Minta izin, tampilkan preview, ambil/unggah media. | Izin ditolak → pengaturan; dispose controller. |
| 3 | Pesan terakhir | Pesan | Tampilkan/balas pesan; long-press untuk menu konteks. | Status kirim/terbaca/gagal tampil jelas. |
| 4 | Badge unread | Status | Tampilkan kondisi koneksi/status; beri aksi retry bila perlu. | Perubahan status diumumkan; retry tersedia. |
| 5 | Empty state | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |

### 6.1 Fakta teknis form & interaksi

| Fakta | Nilai |
|---|---|
| TextEditingController | 1 |
| Field teks/form | 1 |
| Dropdown | 0 |
| Switch/toggle | 0 |
| Validator client | 0 |
| Field password (`obscureText`) | 0 |
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

Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai `AppLocalizations` dan mengikuti gaya bahasa layar lain.

| Lokasi | Draft copy | Catatan |
|---|---|---|
| Judul/header | Daftar Chat | Samakan dengan label navigasi. |
| Subjudul | Menampilkan daftar percakapan pengguna atau guest, jumlah belum dibaca, dan pintu masuk k… | Ringkas; jangan mengulang judul. |
| Tombol utama | Kirim | [Usulan] Disabled saat proses. |
| Empty state | Belum ada daftar Chat. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat daftar Chat. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Guest | Masuk untuk melanjutkan. | [Usulan] Gunakan `GuestAuthPrompt`. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |
| Placeholder input | Ketik pesan... | [Usulan] Gunakan AppLocalizations. |
| Empty list | Belum ada percakapan. | [Usulan] Sertakan CTA mulai chat. |

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
| `refreshing` | Pull to refresh | Spinner di atas konten | Selesai; reset halaman |
| `guest` | Guest menekan aksi privat | `GuestAuthPrompt` | Login |
| `kosong` | Kondisi domain | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `polling gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `GET` | `/messages/conversations` | `ChatController@getConversations` | Sanctum | Daftar percakapan |
| 2 | `GET` | `/messages/unread-count` | `ChatController@getUnreadCount` | Sanctum | Jumlah pesan belum dibaca |
| 3 | `POST` | `/messages/guest/start` | `ChatController@guestStart` | Publik (guest-chat) | Memulai chat guest |
| 4 | `GET` | `/messages/guest/{inboxId}` | `ChatController@guestMessages` | Publik (guest-chat) | Pesan percakapan guest |

### 10.2 Detail per endpoint

#### 10.2.1 `GET /messages/conversations`

- **Controller:** `ChatController@getConversations`
- **Auth:** Sanctum
- **Kegunaan:** Daftar percakapan
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/ChatController/ChatController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `success`, `message`, `data`, `current_user_is_staff`
- **Pesan error terbaca:** “Tidak terautentikasi”

#### 10.2.2 `GET /messages/unread-count`

- **Controller:** `ChatController@getUnreadCount`
- **Auth:** Sanctum
- **Kegunaan:** Jumlah pesan belum dibaca
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/ChatController/ChatController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `success`, `data`

#### 10.2.3 `POST /messages/guest/start`

- **Controller:** `ChatController@guestStart`
- **Auth:** Publik (guest-chat)
- **Kegunaan:** Memulai chat guest
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/ChatController/ChatController.php`
- **Catatan:** Throttle guest-chat.

| Field request | Aturan | Wajib |
|---|---|---|
| `guest_id` | `required|string|max:190` | Ya |
| `name` | `nullable|string|max:100` | Tidak |
| `cs_category` | `nullable|string|max:50` | Tidak |

- **Response top-level:** `success`, `data`

#### 10.2.4 `GET /messages/guest/{inboxId}`

- **Controller:** `ChatController@guestMessages`
- **Auth:** Publik (guest-chat)
- **Kegunaan:** Pesan percakapan guest
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/ChatController/ChatController.php`
- **Catatan:** Throttle guest-chat.

| Field request | Aturan | Wajib |
|---|---|---|
| `guest_id` | `required|string|max:190` | Ya |

- **Response top-level:** `success`, `data`, `other_user`
- **Pesan error terbaca:** “Kotak pesan tidak ditemukan”; “Tidak terautentikasi”

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
| `fm_inboxes` | Percakapan chat. | Baca/tulis (indikasi) | `id`, `title`, `user_ids`, `created_at`, `updated_at`, `deleted_at`, `meta` |
| `fm_messages` | Pesan chat. | Baca/tulis (indikasi) | `id`, `inbox_id`, `message`, `user_id`, `read_by`, `read_at`, `notified`, `created_at`, `updated_at`, `deleted_at` … |
| `users` | Akun, profil, KYC, preferensi, dan pengaturan keamanan. | Baca/tulis (indikasi) | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance`, `email_verified_at`, `password` … |

Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service untuk memastikan operasi baca/tulis yang sebenarnya.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL dari Flutter; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Badge unread sesuai `unread-count`.
- Mode guest tidak meminta token.

### 12.2 Validasi server yang terbaca dari controller

| Field | Aturan | Endpoint |
|---|---|---|
| `guest_id` | `required|string|max:190` | `/messages/guest/start` |
| `name` | `nullable|string|max:100` | `/messages/guest/start` |
| `cs_category` | `nullable|string|max:50` | `/messages/guest/start` |
| `guest_id` | `required|string|max:190` | `/messages/guest/{inboxId}` |

### 12.3 Validasi client yang terdeteksi

- Form memiliki **1 field** dan **0 validator** client.
- Validasi client hanya untuk UX; hasil final tetap dari backend (`422`).

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan `DioClient`/repository yang sudah ada; jangan membuat instance Dio baru.
- Guest tidak boleh memanggil endpoint privat; tampilkan `GuestAuthPrompt`.
- Pesan gagal kirim harus dapat dicoba ulang tanpa menduplikasi pesan.
- Lampiran divalidasi tipe/ukuran; jangan unggah file tak dikenal.
- Guest hanya boleh memakai alur guest yang didukung backend.

## 13. Error Handling

Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).

### 13.1 Kegagalan spesifik layar

- Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.
- Respons tidak sesuai envelope → tampilkan error umum, catat status code.
- 401 → bersihkan token dan arahkan ke Landing/login.
- 403 → tampilkan akses ditolak tanpa logout otomatis.
- 5xx → error server + retry; jangan menampilkan stack trace.
- Koneksi real-time putus → tampilkan status reconnect dan coba lagi.
- Kirim pesan gagal → tandai pesan gagal dan sediakan retry.
- Gap: Tidak ada tab bottom navigation untuk chat meski branch shell aktif.
- Gap: Mode guest ditentukan `extra.isGuestMode`.

## 14. Keamanan & Privasi

- Token hanya di `FlutterSecureStorage`; jangan di `SharedPreferences` atau log.
- Jangan menampilkan stack trace, query database, atau detail internal pada pengguna.
- Jangan mengirim PII ke analytics/crash report.
- Validasi kepemilikan resource di backend; client tidak boleh menentukan `user_id`.
- Isi pesan dan lampiran bersifat privat; jangan log isi pesan.
- Validasi tipe/ukuran lampiran sebelum upload.
- Guest tidak boleh mengirim Bearer token kosong atau mengakses resource privat.

## 15. Aksesibilitas

- Semua ikon/tombol non-teks memiliki label semantik.
- Target sentuh minimal 48×48 dp; jangan hanya mengandalkan ikon kecil.
- Kontras teks memenuhi WCAG AA pada mode terang dan gelap.
- Urutan fokus screen reader mengikuti urutan visual.
- Text scale 200% tidak memotong label atau tombol utama.
- Error form diumumkan dan terhubung ke field terkait.
- Hormati reduce-motion; animasi tidak boleh menghalangi interaksi.
- Bubble pesan menyertakan pengirim/waktu pada semantics.
- Status terkirim/gagal terbaca oleh screen reader.

## 16. Performa & Offline

- Gunakan `CachedNetworkImage`/cache yang ada untuk gambar jaringan.
- Hindari pekerjaan berat di `build()`; pindahkan parsing/format ke provider/util.
- Dispose controller, timer, dan subscription di `dispose`.
- Pull-to-refresh mereset halaman dan tidak menumpuk request.
- Jangan memuat seluruh riwayat sekaligus; gunakan pagination/cursor.
- Tidak ada cache lokal terdeteksi; jangan menambah cache tanpa kebijakan kedaluwarsa.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_chat_list` | Layar dibuka | screen, route, auth | Tidak |
| `chat_list_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `chat_list_success` | Aksi utama berhasil | duration_ms | Tidak |
| `chat_list_failure` | Request/aksi gagal | error_code, status | Tidak |
| `chat_list_message_sent` | Pesan terkirim | type, has_attachment | Tidak |
| `chat_list_reconnect` | Koneksi real-time dipulihkan | duration_ms | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Badge unread sesuai `unread-count`.
- [ ] Mode guest tidak meminta token.
- [ ] Tombol utama menjalankan aksi: Kirim.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Cabang shell `/chat-list` (tidak terlihat di bottom navigation) atau notifikasi.
- [ ] Route/parameter sesuai: `/chat-list`.
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
| TC-01 | Widget | Happy path | Buka layar melalui: Cabang shell `/chat-list` (tidak terlihat di bottom navigation) atau notifikasi. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /chat-list dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
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
| TC-13 | Manual | Reconnect | Putuskan jaringan saat chat terbuka | Status reconnect tampil; pesan dapat dikirim ulang. |
| TC-14 | Manual | Lampiran | Kirim file tipe/ukuran tidak valid | Ditolak dengan pesan jelas; tidak crash. |
| TC-15 | Manual | Regresi fitur terkait | Buka layar terkait setelah aksi | Navigasi/state tidak rusak dan data konsisten. |

**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, dan golden test untuk layar dengan layout kompleks.

## 20. Gap, Risiko & Dependensi

### 20.1 Gap terdokumentasi

- Tidak ada tab bottom navigation untuk chat meski branch shell aktif.
- Mode guest ditentukan `extra.isGuestMode`.

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| Tidak ada tab bottom navigation untuk chat meski branch shell aktif. | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |
| Guest memanggil endpoint privat | Sedang | Tinggi | Guard di UI dan interceptor; uji 401/403. |
| Pesan duplikat/gagal saat reconnect | Sedang | Sedang | Idempotensi/retry dan tandai pesan gagal. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | GET /messages/conversations | ChatController@getConversations |
| Endpoint | GET /messages/unread-count | ChatController@getUnreadCount |
| Endpoint | POST /messages/guest/start | ChatController@guestStart |
| Endpoint | GET /messages/guest/{inboxId} | ChatController@guestMessages |
| Database | fm_inboxes | Jangan query langsung dari Flutter. |
| Database | fm_messages | Jangan query langsung dari Flutter. |
| Database | users | Jangan query langsung dari Flutter. |
| Provider | guestModeProvider | lib/Core/Utils/GuestMode/GuestMode.dart |
| Provider | authProvider | lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart |
| Provider | chatProvider | lib/Features/Chat/Presentation/Providers/ChatProvider.dart |
| Route | /chat-list | Terdaftar di `AppRouter`. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | File/Simbol | Catatan |
|---|---|---|
| Screen | `lib/Features/Chat/Presentation/Screens/ChatList/ChatListScreen.dart` · `ChatListScreen` | 784 baris |
| Provider | `guestModeProvider` | `lib/Core/Utils/GuestMode/GuestMode.dart` |
| Provider | `authProvider` | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` |
| Provider | `chatProvider` | `lib/Features/Chat/Presentation/Providers/ChatProvider.dart` |
| Widget inti | `AppButton` | `lib/Core/Widgets/AppButton/` |
| Widget inti | `AppBreadcrumbs` | `lib/Core/Widgets/AppBreadcrumbs/` |
| Test | `test/Features/Chat/` | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/chat/chat-list.md` | PRD ini |
| Prompt | `.skills/screens/chat/chat-list/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_showError`, `_startOrOpenChat`, `_startChatWithCategory`, `_buildUserView`, `_buildStatusCard`, `_buildConversationCard`, `_buildAvatarContent`, `_buildCsActionCard`.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/chat/chat-list/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Kode Flutter, route Laravel, skema PostgreSQL |
