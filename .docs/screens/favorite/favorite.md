# Favorit

> **Fitur:** Favorit · **Route:** `/favorite dan /Favorite` · **Akses:** Sanctum · **Tipe:** Daftar / koleksi
> **Implementasi:** `lib/Features/Favorite/Presentation/Screens/Favorite/Favoritescreen.dart` — `Favoritescreen` (113 baris) · **State:** Tidak terdeteksi · **Pola:** request-response
> **API:** 3 endpoint · **Tabel:** 3 · **Model:** 1
> Diverifikasi 6 November 2026 dari kode Flutter, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Menampilkan item favorit (paket/katalog) dan memungkinkan membuka detail atau menghapusnya. |
| Aktor | Pelanggan terautentikasi (Sanctum) |
| Nilai pengguna | Menampilkan item favorit (paket/katalog) dan memungkinkan membuka detail atau menghapusnya. |
| Definisi sukses | Daftar tampil, dapat difilter/di-refresh, dan pagination tidak menduplikasi item. |
| Risiko utama | Casing client `/favorite` vs backend `/Favorite` (GAP-03). |
| Status dokumen | Kontrak terdokumentasi; ada gap yang harus ditangani |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Menampilkan item favorit (paket/katalog) dan memungkinkan membuka detail atau menghapusnya. | Daftar tampil, dapat difilter/di-refresh, dan pagination tidak menduplikasi item. |

### 1.2 In scope

- Muat daftar favorit.
- Tampilkan resource_type dan data paket/katalog.
- Buka detail item.
- Hapus favorit dengan tipe resource yang benar.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak mengubah data di luar aksi yang terlihat (refresh, buka detail, hapus bila ada).
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Dari `ProfileScreen`, `SettingsScreen`, atau tombol favorit. |
| Route | `/favorite dan /Favorite` |
| Parameter/extra | Dua route (`/favorite`, `/Favorite`) menuju layar yang sama. |
| Guard | Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login. |
| Keluar ke | `/catalog/:id` |
| Perilaku back | Gunakan tombol back bawaan `go_router`; jangan membuat navigasi manual yang menduplikasi route. |

## 3. Alur Pengguna

1. Muat daftar favorit.
2. Tampilkan resource_type dan data paket/katalog.
3. Buka detail item.
4. Hapus favorit dengan tipe resource yang benar.

**Decision points yang wajib diuji:**

- `kosong` → Empty state dengan penjelasan dan CTA lanjutan.
- `hapus gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Dari ProfileScreen, SettingsScreen, atau tombol favorit."] --> B["Render awal / muat data"]
  B -->|sukses| C["Grid/list favorit"]
  C --> D["Hapus favorit dengan tipe resource yang benar."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| File | `lib/Features/Favorite/Presentation/Screens/Favorite/Favoritescreen.dart` |
| Kelas layar | `Favoritescreen` |
| Base widget | `Tidak terdeteksi` |
| Kelas state | `_FavoritePageState` |
| State management | Tidak terdeteksi |
| Pola data | request-response |
| Provider | `authProvider`, `favoriteProvider` |
| Repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Widget inti | `AppEmptyState`, `AppErrorState`, `GuestAuthPrompt`, `AppBreadcrumbs` |
| Widget fitur | `CombinedCard` |
| Model | `ItemModel` |

### 4.2 Metode internal

`_fetchFavoriteIfAuthenticated`.

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
│ Favorit                                                           │
├────────────────────────────────────────────────────────────────────┤
│ 1. Grid/list favorit                                              │
│ 2. Badge tipe                                                     │
│ 3. Tombol hapus                                                   │
│ 4. Empty state                                                    │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `AppEmptyState`, `AppErrorState`, `GuestAuthPrompt`, `AppBreadcrumbs`
- Fitur: `CombinedCard`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Grid/list favorit | Daftar | Tap item → buka detail; dukung refresh/pagination. | Skeleton saat muat; empty state; retry. |
| 2 | Badge tipe | Status | Tampilkan kondisi koneksi/status; beri aksi retry bila perlu. | Perubahan status diumumkan; retry tersedia. |
| 3 | Tombol hapus | Aksi | Tap → jalankan aksi utama layar. | Disabled saat loading; error lewat SnackBar/inline. |
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
| Pull to refresh | Ya |

## 7. Copywriting & Microcopy

Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai `AppLocalizations` dan mengikuti gaya bahasa layar lain.

| Lokasi | Draft copy | Catatan |
|---|---|---|
| Judul/header | Favorit | Samakan dengan label navigasi. |
| Subjudul | Menampilkan item favorit (paket/katalog) dan memungkinkan membuka detail atau menghapusny… | Ringkas; jangan mengulang judul. |
| Tombol utama | Lihat Detail | [Usulan] Disabled saat proses. |
| Empty state | Belum ada favorit. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat favorit. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |
| Empty state | Belum ada favorit. | [Usulan] Sertakan CTA sesuai konteks. |
| Filter kosong | Tidak ada hasil yang cocok. | [Usulan] Tawarkan reset filter. |

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
| `kosong` | Kondisi domain | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `hapus gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

### 10.1 Ringkasan endpoint

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `GET` | `/Favorite` | `FavoriteController@index` | Sanctum | Daftar favorit |
| 2 | `DELETE` | `/Favorite/{packageId}` | `FavoriteController@removeFromFavorite` | Sanctum | Menghapus favorit |
| 3 | `POST` | `/Favorite/toggle` | `FavoriteController@toggle` | Sanctum | Menambah/menghapus favorit |

### 10.2 Detail per endpoint

#### 10.2.1 `GET /Favorite`

- **Controller:** `FavoriteController@index`
- **Auth:** Sanctum
- **Kegunaan:** Daftar favorit
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/FavoriteController/FavoriteController.php`
- **Catatan:** Casing backend `/Favorite`.
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `data`, `pagination`, `message`, `error`
- **Pesan error terbaca:** “Gagal mengambil Favorite”

#### 10.2.2 `DELETE /Favorite/{packageId}`

- **Controller:** `FavoriteController@removeFromFavorite`
- **Auth:** Sanctum
- **Kegunaan:** Menghapus favorit
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/FavoriteController/FavoriteController.php`
- **Catatan:** Casing backend `/Favorite/{packageId}`.
- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis (GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.
- **Response top-level:** `status`, `message`, `error`
- **Pesan error terbaca:** “Item tidak ditemukan di Favorite”; “Gagal menghapus dari Favorite”

#### 10.2.3 `POST /Favorite/toggle`

- **Controller:** `FavoriteController@toggle`
- **Auth:** Sanctum
- **Kegunaan:** Menambah/menghapus favorit
- **Sumber aturan:** `../Mobile-And-Backend/app/Http/Controllers/Api/User/FavoriteController/FavoriteController.php`
- **Catatan:** Casing backend `/Favorite/toggle`.

| Field request | Aturan | Wajib |
|---|---|---|
| `package_id` | `nullable|exists:packages,id` | Tidak |
| `catalog_id` | `nullable|exists:catalogs,id` | Tidak |

- **Response top-level:** `status`, `message`, `in_Favorite`, `data`, `error`
- **Pesan error terbaca:** “Tier tidak termasuk dalam katalog yang dipilih”; “Gagal memperbarui Favorite”

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
| `favorites` | Favorit paket/katalog. | Baca/tulis (indikasi) | `id`, `user_id`, `package_id`, `catalog_id`, `created_at`, `updated_at` |
| `packages` | Tier/paket dari katalog. | Baca/tulis (indikasi) | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price`, `is_featured`, `features` … |
| `catalogs` | Item katalog. | Baca/tulis (indikasi) | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock`, `is_active`, `created_at` … |

Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service untuk memastikan operasi baca/tulis yang sebenarnya.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL dari Flutter; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Item katalog dan paket tampil dengan tipe yang benar.
- Hapus langsung menghilangkan item dari daftar.

### 12.2 Validasi server yang terbaca dari controller

| Field | Aturan | Endpoint |
|---|---|---|
| `package_id` | `nullable|exists:packages,id` | `/Favorite/toggle` |
| `catalog_id` | `nullable|exists:catalogs,id` | `/Favorite/toggle` |

### 12.3 Validasi client yang terdeteksi

- Tidak ada form input yang terdeteksi pada layar ini.

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan `DioClient`/repository yang sudah ada; jangan membuat instance Dio baru.
- Guest tidak boleh memanggil endpoint privat; tampilkan `GuestAuthPrompt`.
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
- Gap: Casing client `/favorite` vs backend `/Favorite` (GAP-03).
- Gap: `removeFromFavorite` tidak menerima `isCatalog` dari provider (GAP-04).

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
| `screen_view_favorite` | Layar dibuka | screen, route, auth | Tidak |
| `favorite_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `favorite_success` | Aksi utama berhasil | duration_ms | Tidak |
| `favorite_failure` | Request/aksi gagal | error_code, status | Tidak |
| `favorite_filter_applied` | Filter/sortir diterapkan | filter_count, sort | Tidak |
| `favorite_pagination` | Halaman berikutnya dimuat | page | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Item katalog dan paket tampil dengan tipe yang benar.
- [ ] Hapus langsung menghilangkan item dari daftar.
- [ ] Tombol utama menjalankan aksi: Lihat Detail.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Dari `ProfileScreen`, `SettingsScreen`, atau tombol favorit.
- [ ] Route/parameter sesuai: `/favorite dan /Favorite`.
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
| TC-01 | Widget | Happy path | Buka layar melalui: Dari `ProfileScreen`, `SettingsScreen`, atau tombol favorit. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /favorite dan /Favorite dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
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

- Casing client `/favorite` vs backend `/Favorite` (GAP-03).
- `removeFromFavorite` tidak menerima `isCatalog` dari provider (GAP-04).

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| Casing client `/favorite` vs backend `/Favorite` (GAP-03). | Sedang | Tinggi | Tangani gap sebelum menganggap layar selesai. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Endpoint | GET /Favorite | FavoriteController@index |
| Endpoint | DELETE /Favorite/{packageId} | FavoriteController@removeFromFavorite |
| Endpoint | POST /Favorite/toggle | FavoriteController@toggle |
| Database | favorites | Jangan query langsung dari Flutter. |
| Database | packages | Jangan query langsung dari Flutter. |
| Database | catalogs | Jangan query langsung dari Flutter. |
| Provider | authProvider | lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart |
| Provider | favoriteProvider | lib/Features/Favorite/Presentation/Providers/FavoriteProvider/FavoriteProvider.dart |
| Route | /favorite dan /Favorite | Terdaftar di `AppRouter`. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | File/Simbol | Catatan |
|---|---|---|
| Screen | `lib/Features/Favorite/Presentation/Screens/Favorite/Favoritescreen.dart` · `Favoritescreen` | 113 baris |
| Provider | `authProvider` | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` |
| Provider | `favoriteProvider` | `lib/Features/Favorite/Presentation/Providers/FavoriteProvider/FavoriteProvider.dart` |
| Model | `ItemModel` | `lib/Features/Catalog/Data/Models/ItemModel/ItemModel.dart` |
| Widget inti | `AppEmptyState` | `lib/Core/Widgets/AppEmptyState/` |
| Widget inti | `AppErrorState` | `lib/Core/Widgets/AppErrorState/` |
| Widget inti | `GuestAuthPrompt` | `lib/Core/Widgets/GuestAuthPrompt/` |
| Widget inti | `AppBreadcrumbs` | `lib/Core/Widgets/AppBreadcrumbs/` |
| Widget fitur | `CombinedCard` | Berada di `Presentation/Widgets/` fitur terkait |
| Test | `test/Features/Favorit/` | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/favorite/favorite.md` | PRD ini |
| Prompt | `.skills/screens/favorite/favorite/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_fetchFavoriteIfAuthenticated`.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/favorite/favorite/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Kode Flutter, route Laravel, skema PostgreSQL |
