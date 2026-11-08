# Home

> **Fitur:** Home · **Route:** `/home` · **Akses:** Guest + Sanctum · **Tipe:** Konten / navigasi
> **Implementasi:** `lib/Features/Home/Presentation/Screens/Home/HomeScreen.dart` — `HomeScreen` (747 baris) · **State:** Riverpod + state lokal (`setState`) · **Pola:** request-response
> **API:** 3 endpoint · **Tabel:** 6 · **Model:** 1
> Diverifikasi 6 November 2026 dari kode Flutter, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Beranda dengan banner, kategori, katalog unggulan, dan pintu masuk pencarian/CBIR. |
| Aktor | Guest dan pelanggan terautentikasi |
| Nilai pengguna | Beranda dengan banner, kategori, katalog unggulan, dan pintu masuk pencarian/CBIR. |
| Definisi sukses | Konten utama tampil dan navigasi lanjutan berfungsi. |
| Risiko utama | Guest tidak dapat memuat `/home`, `/catalog`, `/categories` karena Sanctum (GAP-02). |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Beranda dengan banner, kategori, katalog unggulan, dan pintu masuk pencarian/CBIR. | Konten utama tampil dan navigasi lanjutan berfungsi. |
| Guest | Mencoba melihat konten tanpa akun; diarahkan login pada aksi privat | Konten publik tampil dan prompt login muncul tepat pada aksi privat |

### 1.2 In scope

- Muat data home, katalog, dan kategori.
- Tampilkan banner dan kategori.
- Buka katalog, detail, pencarian, atau CBIR.
- Tampilkan sapaan pengguna/guest.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Tab Home setelah startup/landing. |
| Route | `/home` |
| Parameter/extra | Tidak ada parameter khusus. |
| Guard | Guest boleh membuka layar, tetapi aksi privat harus memunculkan `GuestAuthPrompt` dan tidak mengirim Bearer token kosong. |
| Keluar ke | `/catalog/:id`, `/edit-profile`, `/notifications`, `/catalog`, `/my-reviews`, `/Favorite`, `/vouchers`, `/vouchers/:id` |
| Perilaku back | State tab dipertahankan oleh `StatefulShellRoute.indexedStack`; kembali tidak boleh mereset cabang lain. [Usulan] |

## 3. Alur Pengguna

1. Muat data home, katalog, dan kategori.
2. Tampilkan banner dan kategori.
3. Buka katalog, detail, pencarian, atau CBIR.
4. Tampilkan sapaan pengguna/guest.

**Decision points yang wajib diuji:**

- `kosong` → Empty state dengan penjelasan dan CTA lanjutan.
- `gambar gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Tab Home setelah startup/landing."] --> B["Render awal / muat data"]
  B -->|sukses| C["Banner carousel"]
  C --> D["Tampilkan sapaan pengguna/guest."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| File | `lib/Features/Home/Presentation/Screens/Home/HomeScreen.dart` |
| Kelas layar | `HomeScreen` |
| Base widget | `ConsumerStatefulWidget` |
| Kelas state | `_HomePageState` |
| State management | Riverpod + state lokal (`setState`) |
| Pola data | request-response |
| Provider | `authProvider`, `notificationListProvider`, `guestModeProvider` |
| Repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Widget inti | `AppBlurBackdrop`, `AppFilterWidgets`, `AppShimmer` |
| Widget fitur | `GlobalSearchBar`, `CombinedCard`, `AuthModals` |
| Model | `ItemModel` |

### 4.1 State lokal yang terdeteksi

| Field | Tipe | Peran |
|---|---|---|
| `_homeData` | `Map<String, dynamic>?` | Data yang ditampilkan. |
| `_loading` | `bool` | Menandai proses muat/aksi. |
| `_pageController` | `PageController` | Controller input; wajib dispose. |
| `_combinedItems` | `List<Map<String, dynamic>>` | Data yang ditampilkan. |
| `_catalogLoading` | `bool` | Menandai proses muat/aksi. |
| `_catalogCategories` | `List<Map<String, dynamic>>` | State lokal layar. |
| `_selectedCategoryId` | `String?` | Filter/sortir lokal. |
| `_hasDiscountOnly` | `bool` | State lokal layar. |
| `_minRating` | `double` | State lokal layar. |
| `_sortBy` | `String` | Filter/sortir lokal. |

### 4.2 Metode internal

`_effectiveItemPrice`, `_itemHasTierDiscount`, `_fetchHome`, `_fetchCatalog`, `_fetchCategories`, `_buildSearchBar`, `_buildWelcomeRow`, `_buildMenuSection`, `_buildVoucherSection`, `_buildCatalogHeader`, `_showRatingFilterDialog`, `_buildRatingOption`.

### 4.3 Alur data

```text
Widget / State
   ↓ baca/tulis
Provider Riverpod
   ↓
Repository / DioClient
   ↓ REST
Controller Laravel → PostgreSQL (6 tabel terkait)
```

## 5. Blueprint UI

Wireframe konseptual dari daftar elemen registry. Urutan final mengikuti file implementasi.

```text
┌────────────────────────────────────────────────────────────────────┐
│ Home                                                              │
├────────────────────────────────────────────────────────────────────┤
│ 1. Banner carousel                                                │
│ 2. Chip kategori                                                  │
│ 3. Kartu katalog                                                  │
│ 4. Search bar                                                     │
│ 5. Sapaan pengguna                                                │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `AppBlurBackdrop`, `AppFilterWidgets`, `AppShimmer`
- Fitur: `GlobalSearchBar`, `CombinedCard`, `AuthModals`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Banner carousel | Status | Tampilkan kondisi koneksi/status; beri aksi retry bila perlu. | Perubahan status diumumkan; retry tersedia. |
| 2 | Chip kategori | Kartu | Tap → navigasi atau buka detail. | Gambar gagal → placeholder; tap memberi feedback. |
| 3 | Kartu katalog | Kartu | Tap → navigasi atau buka detail. | Gambar gagal → placeholder; tap memberi feedback. |
| 4 | Search bar | Input | Isi/ubah nilai; validasi client sebelum kirim. | Error inline; 422 dipetakan per field. |
| 5 | Sapaan pengguna | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |

### 6.1 Fakta teknis form & interaksi

| Fakta | Nilai |
|---|---|
| TextEditingController | 0 |
| Field teks/form | 0 |
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
| Judul/header | Home | Samakan dengan label navigasi. |
| Subjudul | Beranda dengan banner, kategori, katalog unggulan, dan pintu masuk pencarian/CBIR. | Ringkas; jangan mengulang judul. |
| Tombol utama | Tampilkan sapaan pengguna/guest | [Usulan] Disabled saat proses. |
| Empty state | Belum ada home. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat home. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Guest | Masuk untuk melanjutkan. | [Usulan] Gunakan `GuestAuthPrompt`. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |

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
| `refreshing` | Pull to refresh | Spinner di atas konten | Selesai; reset halaman |
| `guest` | Guest menekan aksi privat | `GuestAuthPrompt` | Login |
| `error 401` | Kondisi domain | Pesan ramah, tombol coba lagi, pertahankan data lama bila ada. | Ikuti aksi pemulihan pada pesan |
| `kosong` | Kondisi domain | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `gambar gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `GET` | `/home` | `HomeController@index` | Sanctum | Data beranda |
| 2 | `GET` | `/catalog` | `CatalogController@index` | Sanctum | Daftar katalog dengan filter/paginasi |
| 3 | `GET` | `/categories` | `CategoryController@index` | Sanctum | Daftar kategori |

### 10.2 Detail per endpoint

#### 10.2.1 `GET /home`

- **Controller:** `HomeController@index`
- **Auth:** Sanctum
- **Kegunaan:** Data beranda
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/HomeController/HomeController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `data`, `message`
- **Pesan error terbaca:** “Terjadi kesalahan pada server.”

#### 10.2.2 `GET /catalog`

- **Controller:** `CatalogController@index`
- **Auth:** Sanctum
- **Kegunaan:** Daftar katalog dengan filter/paginasi
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/CatalogController/CatalogController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.

#### 10.2.3 `GET /categories`

- **Controller:** `CategoryController@index`
- **Auth:** Sanctum
- **Kegunaan:** Daftar kategori
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/CategoryController/CategoryController.php`
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `data`, `pagination`, `message`
- **Pesan error terbaca:** “Gagal mengambil kategori”

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
| `ItemModel` | `lib/Features/Catalog/Data/Models/ItemModel/ItemModel.dart` | `id`, `categoryId`, `name`, `slug`, `description`, `stock`, `isActive`, `isFeatured`, `features`, `theme` |

## 11. Data & Database

| Tabel | Peran | Akses | Kolom kunci |
|---|---|---|---|
| `hero_banners` | Banner beranda. | Baca | `id`, `title`, `subtitle`, `image_url`, `link_url`, `link_type`, `link_id`, `position`, `is_active`, `created_at` … |
| `promotions` | Promosi beranda. | Baca | `id`, `title`, `description`, `image_url`, `discount_percent`, `code`, `valid_from`, `valid_until`, `is_active`, `created_at` … |
| `categories` | Kategori katalog. | Baca | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at`, `name_translations`, `description_translations` … |
| `catalogs` | Item katalog. | Baca | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock`, `is_active`, `created_at` … |
| `packages` | Tier/paket dari katalog. | Baca | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price`, `is_featured`, `features` … |
| `media` | File polymorphic (avatar, dokumen, lampiran). | Baca | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type`, `disk`, `conversions_disk` … |

Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service untuk memastikan operasi baca/tulis yang sebenarnya.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL dari Flutter; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Data muncul untuk pengguna login.
- Guest melihat prompt login pada aksi yang membutuhkan akun.

### 12.2 Validasi server yang terbaca dari controller

Tidak ada aturan validasi field yang terdeteksi otomatis. Periksa controller/FormRequest sebelum mengandalkan validasi client.

### 12.3 Validasi client yang terdeteksi

- Tidak ada form input yang terdeteksi pada layar ini.

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan `DioClient`/repository yang sudah ada; jangan membuat instance Dio baru.
- Guest tidak boleh memanggil endpoint privat; tampilkan `GuestAuthPrompt`.
- Konten statis tetap harus memiliki loading/error state bila berasal dari API.

## 13. Error Handling

Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).

### 13.1 Kegagalan spesifik layar

- Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.
- Respons tidak sesuai envelope → tampilkan error umum, catat status code.
- 401 → bersihkan token dan arahkan ke Landing/login.
- 403 → tampilkan akses ditolak tanpa logout otomatis.
- 5xx → error server + retry; jangan menampilkan stack trace.
- Gap: Guest tidak dapat memuat `/home`, `/catalog`, `/categories` karena Sanctum (GAP-02).
- Gap: Startup juga memanggil endpoint privat (GAP-14).

## 14. Keamanan & Privasi

- Token hanya di `FlutterSecureStorage`; jangan di `SharedPreferences` atau log.
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

## 16. Performa & Offline

- Gunakan `CachedNetworkImage`/cache yang ada untuk gambar jaringan.
- Hindari pekerjaan berat di `build()`; pindahkan parsing/format ke provider/util.
- Dispose controller, timer, dan subscription di `dispose`.
- Pull-to-refresh mereset halaman dan tidak menumpuk request.
- Tidak ada cache lokal terdeteksi; jangan menambah cache tanpa kebijakan kedaluwarsa.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_home` | Layar dibuka | screen, route, auth | Tidak |
| `home_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `home_success` | Aksi utama berhasil | duration_ms | Tidak |
| `home_failure` | Request/aksi gagal | error_code, status | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Data muncul untuk pengguna login.
- [ ] Guest melihat prompt login pada aksi yang membutuhkan akun.
- [ ] Tombol utama menjalankan aksi: Tampilkan sapaan pengguna/guest.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Tab Home setelah startup/landing.
- [ ] Route/parameter sesuai: `/home`.
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
| TC-01 | Widget | Happy path | Buka layar melalui: Tab Home setelah startup/landing. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /home dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
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
| TC-13 | Manual | Regresi fitur terkait | Buka layar terkait setelah aksi | Navigasi/state tidak rusak dan data konsisten. |

**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, dan golden test untuk layar dengan layout kompleks.

## 20. Gap, Risiko & Dependensi

### 20.1 Gap terdokumentasi

- Guest tidak dapat memuat `/home`, `/catalog`, `/categories` karena Sanctum (GAP-02).
- Startup juga memanggil endpoint privat (GAP-14).

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| Guest tidak dapat memuat `/home`, `/catalog`, `/categories` karena Sanctum (GAP-02). | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |
| Panggilan API tersebar di widget | Sedang | Sedang | Refactor bertahap ke repository/provider. |
| Guest memanggil endpoint privat | Sedang | Tinggi | Guard di UI dan interceptor; uji 401/403. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | GET /home | HomeController@index |
| Endpoint | GET /catalog | CatalogController@index |
| Endpoint | GET /categories | CategoryController@index |
| Database | hero_banners | Jangan query langsung dari Flutter. |
| Database | promotions | Jangan query langsung dari Flutter. |
| Database | categories | Jangan query langsung dari Flutter. |
| Database | catalogs | Jangan query langsung dari Flutter. |
| Database | packages | Jangan query langsung dari Flutter. |
| Database | media | Jangan query langsung dari Flutter. |
| Provider | authProvider | lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart |
| Provider | notificationListProvider | lib/Features/Notification/Presentation/Providers/NotificationProvider/NotificationProvider.dart |
| Provider | guestModeProvider | lib/Core/Utils/GuestMode/GuestMode.dart |
| Route | /home | Terdaftar di `AppRouter`. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | File/Simbol | Catatan |
|---|---|---|
| Screen | `lib/Features/Home/Presentation/Screens/Home/HomeScreen.dart` · `HomeScreen` | 747 baris |
| Provider | `authProvider` | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` |
| Provider | `notificationListProvider` | `lib/Features/Notification/Presentation/Providers/NotificationProvider/NotificationProvider.dart` |
| Provider | `guestModeProvider` | `lib/Core/Utils/GuestMode/GuestMode.dart` |
| Model | `ItemModel` | `lib/Features/Catalog/Data/Models/ItemModel/ItemModel.dart` |
| Widget inti | `AppBlurBackdrop` | `lib/Core/Widgets/AppBlurBackdrop/` |
| Widget inti | `AppFilterWidgets` | `lib/Core/Widgets/AppFilterWidgets/` |
| Widget inti | `AppShimmer` | `lib/Core/Widgets/AppShimmer/` |
| Widget fitur | `GlobalSearchBar` | Berada di `Presentation/Widgets/` fitur terkait |
| Widget fitur | `CombinedCard` | Berada di `Presentation/Widgets/` fitur terkait |
| Widget fitur | `AuthModals` | Berada di `Presentation/Widgets/` fitur terkait |
| Test | `test/Features/Home/` | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/home/home.md` | PRD ini |
| Prompt | `.skills/screens/home/home/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_effectiveItemPrice`, `_itemHasTierDiscount`, `_fetchHome`, `_fetchCatalog`, `_fetchCategories`, `_buildSearchBar`, `_buildWelcomeRow`, `_buildMenuSection`, `_buildVoucherSection`, `_buildCatalogHeader`, `_showRatingFilterDialog`, `_buildRatingOption`.

> **Catatan arsitektur:** layar memakai `DioClient.instance` langsung. Saat refactor, pindahkan ke repository/provider tanpa mengubah kontrak.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/home/home/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Kode Flutter, route Laravel, skema PostgreSQL |
