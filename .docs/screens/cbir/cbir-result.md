# Hasil Pencarian Gambar

> **Fitur:** Pencarian Gambar · **Route:** `/cbir-result` · **Akses:** Sanctum · **Tipe:** Konten / navigasi
> **Implementasi:** `lib/Features/Cbir/Presentation/Screens/CbirResult/CbirResultScreen.dart` — `CbirResultScreen` (209 baris) · **State:** Riverpod + state lokal (`setState`) · **Pola:** request-response
> **API:** 4 endpoint · **Tabel:** 6 · **Model:** 1
> Diverifikasi 6 November 2026 dari kode Flutter, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Menampilkan hasil pencarian visual (CBIR) berupa katalog/paket yang mirip. |
| Aktor | Pelanggan terautentikasi (Sanctum) |
| Nilai pengguna | Menampilkan hasil pencarian visual (CBIR) berupa katalog/paket yang mirip. |
| Definisi sukses | Konten utama tampil dan navigasi lanjutan berfungsi. |
| Risiko utama | Layar menerima state lewat provider; tidak ada parameter route. |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Menampilkan hasil pencarian visual (CBIR) berupa katalog/paket yang mirip. | Konten utama tampil dan navigasi lanjutan berfungsi. |

### 1.2 In scope

- Terima hasil dari `CbirProvider` atau jalankan pencarian.
- Tampilkan grid hasil dengan skor kemiripan.
- Buka detail item.
- Ulangi pencarian atau kembali.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Setelah pengguna memilih/merekam gambar dari `SearchScreen`. |
| Route | `/cbir-result` |
| Parameter/extra | Tidak ada parameter khusus. |
| Guard | Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login. |
| Keluar ke | `/catalog/:catalogId` |
| Perilaku back | Gunakan tombol back bawaan `go_router`; jangan membuat navigasi manual yang menduplikasi route. |

## 3. Alur Pengguna

1. Terima hasil dari `CbirProvider` atau jalankan pencarian.
2. Tampilkan grid hasil dengan skor kemiripan.
3. Buka detail item.
4. Ulangi pencarian atau kembali.

**Decision points yang wajib diuji:**

- `tidak ada hasil` → Tampilkan status yang jelas dan aksi pemulihan.
- `video tidak didukung` → Tampilkan status yang jelas dan aksi pemulihan.

```mermaid
flowchart TD
  A["Masuk: Setelah pengguna memilih/merekam gambar dari SearchScreen."] --> B["Render awal / muat data"]
  B -->|sukses| C["Grid hasil"]
  C --> D["Ulangi pencarian atau kembali."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| File | `lib/Features/Cbir/Presentation/Screens/CbirResult/CbirResultScreen.dart` |
| Kelas layar | `CbirResultScreen` |
| Base widget | `ConsumerStatefulWidget` |
| Kelas state | `_CbirResultPageState` |
| State management | Riverpod + state lokal (`setState`) |
| Pola data | request-response |
| Provider | `cbirProvider` |
| Repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Widget inti | `AppBlurBackdrop`, `AppBreadcrumbs`, `AppFilterWidgets`, `AppShimmer`, `AppEmptyState`, `AppErrorState` |
| Widget fitur | `GlobalSearchBar`, `CombinedCard` |
| Model | `CbirResultItem` |

### 4.1 State lokal yang terdeteksi

| Field | Tipe | Peran |
|---|---|---|
| `_categories` | `List<Map<String, dynamic>>` | State lokal layar. |

### 4.2 Metode internal

`_fetchCategories`, `_buildBody`, `_buildFilters`, `_buildResultsGrid`, `_buildGridItem`.

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
│ Hasil Pencarian Gambar                                            │
├────────────────────────────────────────────────────────────────────┤
│ 1. Grid hasil                                                     │
│ 2. Skor kemiripan                                                 │
│ 3. Tombol ulangi                                                  │
│ 4. Empty state                                                    │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `AppBlurBackdrop`, `AppBreadcrumbs`, `AppFilterWidgets`, `AppShimmer`, `AppEmptyState`, `AppErrorState`
- Fitur: `GlobalSearchBar`, `CombinedCard`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Grid hasil | Daftar | Tap item → buka detail; dukung refresh/pagination. | Skeleton saat muat; empty state; retry. |
| 2 | Skor kemiripan | Visual data | Tampilkan ringkasan; tidak dapat diubah langsung. | Placeholder bila data kosong. |
| 3 | Tombol ulangi | Aksi | Tap → jalankan aksi utama layar. | Disabled saat loading; error lewat SnackBar/inline. |
| 4 | Empty state | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |

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
| Pull to refresh | Tidak |

## 7. Copywriting & Microcopy

Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai `AppLocalizations` dan mengikuti gaya bahasa layar lain.

| Lokasi | Draft copy | Catatan |
|---|---|---|
| Judul/header | Hasil Pencarian Gambar | Samakan dengan label navigasi. |
| Subjudul | Menampilkan hasil pencarian visual (CBIR) berupa katalog/paket yang mirip. | Ringkas; jangan mengulang judul. |
| Tombol utama | Ulangi pencarian atau kembali | [Usulan] Disabled saat proses. |
| Empty state | Belum ada hasil Pencarian Gambar. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat hasil Pencarian Gambar. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
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
| `submitting` | Pengguna menekan aksi utama | Tombol disabled + progress | Selesai atau tampilkan error |
| `tidak ada hasil` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `gambar terlalu besar` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `error AI` | Kondisi domain | Pesan ramah, tombol coba lagi, pertahankan data lama bila ada. | Ikuti aksi pemulihan pada pesan |
| `video tidak didukung` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `POST` | `/search/image` | `SearchController@byImage` | Sanctum | Pencarian gambar/video |
| 2 | `POST` | `/cbir/search` | `CBIRController@searchSimilar` | Sanctum | Pencarian kemiripan CBIR |
| 3 | `POST` | `/cbir/arithmetic` | `CBIRController@arithmeticSearch` | Sanctum | Operasi aritmetika vektor CBIR |
| 4 | `GET` | `/categories` | `CategoryController@index` | Sanctum | Daftar kategori |

### 10.2 Detail per endpoint

#### 10.2.1 `POST /search/image`

- **Controller:** `SearchController@byImage`
- **Auth:** Sanctum
- **Kegunaan:** Pencarian gambar/video
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/SearchController/SearchController.php`
- **Catatan:** Hanya menerima MIME gambar/video.

| Field request | Aturan | Wajib |
|---|---|---|
| `image` | `required|file|mimes:jpeg,png,jpg,bmp,webp,mp4,mov,m4v,webm,3gp|max:51200` | Ya |

- **Response top-level:** `status`, `data`, `message`, `diagnostics`
- **Pesan error terbaca:** “Pencarian gambar gagal.”

#### 10.2.2 `POST /cbir/search`

- **Controller:** `CBIRController@searchSimilar`
- **Auth:** Sanctum
- **Kegunaan:** Pencarian kemiripan CBIR
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/CBIRController/CBIRController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `image` | `required|file|mimes:jpeg,png,jpg,bmp,webp,mp4,mov,m4v,webm,3gp|max:51200` | Ya |

- **Response top-level:** `success`, `message`, `results`, `total_results`, `query_time_seconds`

#### 10.2.3 `POST /cbir/arithmetic`

- **Controller:** `CBIRController@arithmeticSearch`
- **Auth:** Sanctum
- **Kegunaan:** Operasi aritmetika vektor CBIR
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/CBIRController/CBIRController.php`

| Field request | Aturan | Wajib |
|---|---|---|
| `image_1` | `required|image|max:10240` | Ya |
| `image_2` | `required|image|max:10240` | Ya |
| `operation` | `required|string|in:add,average,subtract,multiply,divide` | Ya |
| `weights` | `nullable|array` | Tidak |
| `weights.*` | `numeric|min:0|max:1` | Tidak |

- **Response top-level:** `success`, `message`, `results`, `total_results`, `query_time_seconds`, `operation`, `source_images`

#### 10.2.4 `GET /categories`

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
| `CbirResultItem` | `lib/Features/Cbir/Data/Models/CbirResultModel/CbirResultModel.dart` | `type`, `similarity`, `sCore`, `catalogId`, `data` |

## 11. Data & Database

| Tabel | Peran | Akses | Kolom kunci |
|---|---|---|---|
| `search_logs` | Log pencarian teks. | Baca/tulis (indikasi) | `id`, `query`, `user_id`, `ip_address`, `user_agent`, `created_at`, `updated_at` |
| `cbir_searches` | Sesi pencarian visual. | Baca/tulis (indikasi) | `id`, `user_id`, `query_image_url`, `results_count`, `top_similarity`, `created_at`, `updated_at` |
| `cbir_search_results` | Hasil pencarian visual. | Baca/tulis (indikasi) | `id`, `search_id`, `type`, `item_id`, `similarity`, `score`, `created_at`, `updated_at` |
| `catalogs` | Item katalog. | Baca/tulis (indikasi) | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock`, `is_active`, `created_at` … |
| `packages` | Tier/paket dari katalog. | Baca/tulis (indikasi) | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price`, `is_featured`, `features` … |
| `categories` | Kategori katalog. | Baca/tulis (indikasi) | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at`, `name_translations`, `description_translations` … |

Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service untuk memastikan operasi baca/tulis yang sebenarnya.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL dari Flutter; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Hasil menampilkan minimal gambar, nama, dan harga.
- Kegagalan AI menampilkan opsi coba lagi.

### 12.2 Validasi server yang terbaca dari controller

| Field | Aturan | Endpoint |
|---|---|---|
| `image` | `required|file|mimes:jpeg,png,jpg,bmp,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/search/image` |
| `image` | `required|file|mimes:jpeg,png,jpg,bmp,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/cbir/search` |
| `image_1` | `required|image|max:10240` | `/cbir/arithmetic` |
| `image_2` | `required|image|max:10240` | `/cbir/arithmetic` |
| `operation` | `required|string|in:add,average,subtract,multiply,divide` | `/cbir/arithmetic` |
| `weights` | `nullable|array` | `/cbir/arithmetic` |
| `weights.*` | `numeric|min:0|max:1` | `/cbir/arithmetic` |

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
- Gap: Layar menerima state lewat provider; tidak ada parameter route.
- Gap: Pencarian suara tidak boleh diarahkan ke layar ini sebelum endpoint transkripsi tersedia.

## 14. Keamanan & Privasi

- Token hanya di `FlutterSecureStorage`; jangan di `SharedPreferences` atau log.
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
- Tidak ada cache lokal terdeteksi; jangan menambah cache tanpa kebijakan kedaluwarsa.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_cbir_result` | Layar dibuka | screen, route, auth | Tidak |
| `cbir_result_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `cbir_result_success` | Aksi utama berhasil | duration_ms | Tidak |
| `cbir_result_failure` | Request/aksi gagal | error_code, status | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Hasil menampilkan minimal gambar, nama, dan harga.
- [ ] Kegagalan AI menampilkan opsi coba lagi.
- [ ] Tombol utama menjalankan aksi: Ulangi pencarian atau kembali.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Setelah pengguna memilih/merekam gambar dari `SearchScreen`.
- [ ] Route/parameter sesuai: `/cbir-result`.
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
| TC-01 | Widget | Happy path | Buka layar melalui: Setelah pengguna memilih/merekam gambar dari `SearchScreen`. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /cbir-result dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
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

- Layar menerima state lewat provider; tidak ada parameter route.
- Pencarian suara tidak boleh diarahkan ke layar ini sebelum endpoint transkripsi tersedia.

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| Layar menerima state lewat provider; tidak ada parameter route. | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |
| Panggilan API tersebar di widget | Sedang | Sedang | Refactor bertahap ke repository/provider. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | POST /search/image | SearchController@byImage |
| Endpoint | POST /cbir/search | CBIRController@searchSimilar |
| Endpoint | POST /cbir/arithmetic | CBIRController@arithmeticSearch |
| Endpoint | GET /categories | CategoryController@index |
| Database | search_logs | Jangan query langsung dari Flutter. |
| Database | cbir_searches | Jangan query langsung dari Flutter. |
| Database | cbir_search_results | Jangan query langsung dari Flutter. |
| Database | catalogs | Jangan query langsung dari Flutter. |
| Database | packages | Jangan query langsung dari Flutter. |
| Database | categories | Jangan query langsung dari Flutter. |
| Provider | cbirProvider | lib/Features/Cbir/Presentation/Providers/CbirProvider/CbirProvider.dart |
| Route | /cbir-result | Terdaftar di `AppRouter`. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | File/Simbol | Catatan |
|---|---|---|
| Screen | `lib/Features/Cbir/Presentation/Screens/CbirResult/CbirResultScreen.dart` · `CbirResultScreen` | 209 baris |
| Provider | `cbirProvider` | `lib/Features/Cbir/Presentation/Providers/CbirProvider/CbirProvider.dart` |
| Model | `CbirResultItem` | `lib/Features/Cbir/Data/Models/CbirResultModel/CbirResultModel.dart` |
| Widget inti | `AppBlurBackdrop` | `lib/Core/Widgets/AppBlurBackdrop/` |
| Widget inti | `AppBreadcrumbs` | `lib/Core/Widgets/AppBreadcrumbs/` |
| Widget inti | `AppFilterWidgets` | `lib/Core/Widgets/AppFilterWidgets/` |
| Widget inti | `AppShimmer` | `lib/Core/Widgets/AppShimmer/` |
| Widget inti | `AppEmptyState` | `lib/Core/Widgets/AppEmptyState/` |
| Widget inti | `AppErrorState` | `lib/Core/Widgets/AppErrorState/` |
| Widget fitur | `GlobalSearchBar` | Berada di `Presentation/Widgets/` fitur terkait |
| Widget fitur | `CombinedCard` | Berada di `Presentation/Widgets/` fitur terkait |
| Test | `test/Features/Pencarian/` | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/cbir/cbir-result.md` | PRD ini |
| Prompt | `.skills/screens/cbir/cbir-result/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_fetchCategories`, `_buildBody`, `_buildFilters`, `_buildResultsGrid`, `_buildGridItem`.

> **Catatan arsitektur:** layar memakai `DioClient.instance` langsung. Saat refactor, pindahkan ke repository/provider tanpa mengubah kontrak.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/cbir/cbir-result/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Kode Flutter, route Laravel, skema PostgreSQL |
