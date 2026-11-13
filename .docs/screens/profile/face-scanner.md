# Face Scanner

> **Fitur:** Profil & Pengaturan · **Route:** `/face-scanner` · **Akses:** Sanctum · **Tipe:** Scanner kamera / media
> **Implementasi referensi (aplikasi saat ini):** `FaceScannerScreen` · **State:** State lokal · **Pola:** kamera real-time
> **API:** 0 endpoint · **Tabel:** 0 · **Model:** 0
> Diverifikasi 6 November 2026 dari implementasi aplikasi saat ini, route Laravel, dan skema PostgreSQL. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.

## 0. Ringkasan Eksekutif

| Aspek | Ringkasan |
|---|---|
| Tujuan | Memindai wajah untuk verifikasi/liveness dan mengembalikan path foto. |
| Aktor | Pelanggan terautentikasi (Sanctum) |
| Nilai pengguna | Memindai wajah untuk verifikasi/liveness dan mengembalikan path foto. |
| Definisi sukses | File hasil scan dihasilkan dan dapat dipakai alur unggah. |
| Risiko utama | Tidak ada gap khusus yang terdokumentasi. |
| Status dokumen | Kontrak terdokumentasi |

## 1. Konteks Fitur

### 1.1 Persona & job-to-be-done

| Persona | Kebutuhan | Ukuran keberhasilan |
|---|---|---|
| Pelanggan dekorasi pernikahan | Memindai wajah untuk verifikasi/liveness dan mengembalikan path foto. | File hasil scan dihasilkan dan dapat dipakai alur unggah. |

### 1.2 In scope

- Minta izin kamera.
- Tampilkan panduan posisi wajah.
- Deteksi wajah/liveness.
- Ambil dan kembalikan foto.

### 1.3 Out of scope

- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.
- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.
- Tidak mengunggah dokumen dari dalam scanner; scanner hanya menghasilkan file.
- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.

## 2. Navigasi & Entry Point

| Arah | Detail |
|---|---|
| Masuk dari | Dari `CompleteProfileScreen` atau `ProfileScreen`. |
| Route | `/face-scanner` |
| Parameter/extra | Tidak ada parameter khusus. |
| Guard | Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login. |
| Keluar ke | Tidak ada navigasi keluar langsung yang terdeteksi. |
| Perilaku back | Gunakan navigasi kembali bawaan router; jangan membuat navigasi manual yang menduplikasi route. |

### 2.1 Layar terkait dalam fitur yang sama

| Layar | Route | PRD |
|---|---|---|
| `ProfileScreen` | `/profile` | [profile.md](../profile/profile.md) |
| `EditProfileScreen` | `/edit-profile` | [edit-profile.md](../profile/edit-profile.md) |
| `ProfileFieldScreen` | `/profile-field` | [profile-field.md](../profile/profile-field.md) |
| `DocumentScannerScreen` | `/document-scanner` | [document-scanner.md](../profile/document-scanner.md) |

## 3. Alur Pengguna

1. Minta izin kamera.
2. Tampilkan panduan posisi wajah.
3. Deteksi wajah/liveness.
4. Ambil dan kembalikan foto.

**Decision points yang wajib diuji:**

- `izin ditolak` → Tampilkan penjelasan izin dan tombol buka pengaturan.
- `wajah tidak terdeteksi` → Tampilkan status yang jelas dan aksi pemulihan.
- `liveness gagal` → Pesan ramah + retry; pertahankan input pengguna.

```mermaid
flowchart TD
  A["Masuk: Dari CompleteProfileScreen atau ProfileScreen."] --> B["Render awal / muat data"]
  B -->|sukses| C["Preview kamera"]
  C --> D["Ambil dan kembalikan foto."]
  B -->|gagal| E["Error state + retry"]
  E --> B
  D --> F["Selesai / navigasi keluar"]
```

## 4. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| Komponen/layar | `FaceScannerScreen` |
| Identifier | `FaceScannerScreen` |
| Tipe komponen | Komponen ber-state |
| Komponen state | Tersedia pada implementasi referensi |
| State management | State lokal |
| Pola data | kamera real-time |
| State/dependency | Tidak terdeteksi |
| Data source/repository | Tidak terdeteksi |
| Service | Tidak terdeteksi |
| Komponen UI bersama | `FaceScoreRing`, `CameraCoverPreview`, `AppBreadcrumbs` |
| Komponen UI fitur | Tidak terdeteksi |
| Model | Tidak terdeteksi |

### 4.1 State lokal yang terdeteksi

| Field | Tipe | Peran |
|---|---|---|
| `_sequence` | `List<_LivenessAction>` | State lokal layar. |
| `_cameraController` | `CameraController?` | Controller/state input; wajib dibersihkan saat tidak dipakai. |
| `_faceDetector` | `FaceDetector?` | State lokal layar. |
| `_tts` | `FlutterTts` | Resource native; wajib dibersihkan saat layar/komponen ditutup. |
| `_isDetecting` | `bool` | State lokal layar. |
| `_cameraReady` | `bool` | Resource native; wajib dibersihkan saat layar/komponen ditutup. |
| `_faceDetected` | `bool` | State lokal layar. |
| `_stepSatisfied` | `bool` | State lokal layar. |
| `_faceTooSmall` | `bool` | State lokal layar. |
| `_eyesClosed` | `bool` | State lokal layar. |
| `_multipleFaces` | `bool` | State lokal layar. |
| `_isFrontCamera` | `bool` | Resource native; wajib dibersihkan saat layar/komponen ditutup. |
| `_isMuted` | `bool` | State lokal layar. |
| `_livenessIndex` | `int` | State lokal layar. |
| `_stepStableCounter` | `int` | State lokal layar. |
| `_verified` | `bool` | State lokal layar. |
| `_lastProcessAt` | `DateTime` | State lokal layar. |
| `_lastBodySize` | `Size?` | State lokal layar. |

### 4.2 Metode internal

`_buildRandomSequence`, `_initTts`, `_speak`, `_initializeCamera`, `_initCamera`, `_processImage`, `_processLiveness`, `_advanceStep`, `_showVerifiedModal`, `_detectFace`, `_buildScanner`, `_buildMuteButton`, `_buildInstructionCard`, `_buildVerifiedOverlay`.

### 4.3 Alur data

```text
UI / State layar
   ↓
Repository / HTTP client
   ↓ REST
Controller Laravel → PostgreSQL (0 tabel terkait)
```

## 5. Blueprint UI

Wireframe konseptual dari daftar elemen registry. Urutan final mengikuti implementasi aplikasi.

```text
┌────────────────────────────────────────────────────────────────────┐
│ Face Scanner                                                      │
├────────────────────────────────────────────────────────────────────┤
│ 1. Preview kamera                                                 │
│ 2. Overlay wajah                                                  │
│ 3. Instruksi                                                      │
│ 4. Tombol ambil                                                   │
└────────────────────────────────────────────────────────────────────┘
```

**Komponen bersama yang terdeteksi:**

- Core: `FaceScoreRing`, `CameraCoverPreview`, `AppBreadcrumbs`

## 6. Inventaris Komponen & Interaksi

| # | Elemen | Jenis | Aksi | Feedback |
|---|---|---|---|---|
| 1 | Preview kamera | Media native | Minta izin, tampilkan preview, ambil/unggah media. | Izin ditolak → pengaturan; dispose controller. |
| 2 | Overlay wajah | Overlay | Konfirmasi/pilih; tutup dengan back atau aksi batal. | Fokus terperangkap; dismiss aman. |
| 3 | Instruksi | Konten | Tampilkan informasi; tidak ada aksi tulis. | Loading/error state tetap wajib. |
| 4 | Tombol ambil | Aksi | Tap → jalankan aksi utama layar. | Disabled saat loading; error lewat SnackBar/inline. |

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
| Kamera | Ya |
| WebView | Tidak |
| Timer/polling | Ya |
| Pagination | Tidak |
| Pull to refresh | Tidak |

## 7. Copywriting & Microcopy

Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai sistem lokalisasi/i18n yang konsisten dan mengikuti gaya bahasa layar lain.

| Lokasi | Draft copy | Catatan |
|---|---|---|
| Judul/header | Face Scanner | Samakan dengan label navigasi. |
| Subjudul | Memindai wajah untuk verifikasi/liveness dan mengembalikan path foto. | Ringkas; jangan mengulang judul. |
| Tombol utama | Gunakan Foto | [Usulan] Disabled saat proses. |
| Empty state | Belum ada face Scanner. | [Usulan] Sertakan CTA lanjutan. |
| Error | Gagal memuat face Scanner. Periksa koneksi lalu coba lagi. | [Usulan] Jangan tampilkan stack trace. |
| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |
| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |
| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |
| Panduan | Posisikan dokumen di dalam bingkai. | [Usulan] Sediakan panduan suara/haptic. |
| Izin | Izinkan akses kamera untuk memindai. | [Usulan] Beri tombol buka pengaturan. |

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
| `permission` | Izin kamera belum diberikan | Penjelasan + tombol buka pengaturan | Izin diberikan |
| `izin ditolak` | Kondisi domain | Tampilkan penjelasan izin dan tombol buka pengaturan. | Ikuti aksi pemulihan pada pesan |
| `wajah tidak terdeteksi` | Kondisi domain | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `liveness gagal` | Kondisi domain | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `kamera error` | Kondisi domain | Pesan ramah, tombol coba lagi, pertahankan data lama bila ada. | Ikuti aksi pemulihan pada pesan |

**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; jangan merender hasil request langsung di `build()`.

## 10. Kontrak API

Layar ini **tidak memanggil API jaringan**. Semua state disimpan di perangkat (penyimpanan lokal/secure storage) atau diterima lewat `extra`/provider.

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

Tidak ada tabel PostgreSQL yang dibaca/ditulis langsung oleh layar ini.

### 11.1 Aturan data

- Jangan menampilkan data dari cache setelah logout.
- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan mengakses PostgreSQL langsung dari klien; gunakan endpoint Laravel.
- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.

## 12. Aturan Bisnis & Validasi

### 12.1 Acceptance dari registry

- Foto hanya dikirim setelah pengguna menyetujui.
- Layar menangani lifecycle kamera.

### 12.2 Validasi server yang terbaca dari controller

Tidak ada aturan validasi field yang terdeteksi otomatis. Periksa controller/FormRequest sebelum mengandalkan validasi client.

### 12.3 Validasi client yang terdeteksi

- Tidak ada form input yang terdeteksi pada layar ini.

### 12.4 Aturan bisnis wajib

- Disable tombol submit selama request berjalan untuk mencegah duplikasi.
- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.
- Gunakan HTTP client/data source/repository yang sudah ada; jangan membuat client baru di komponen UI.
- Guest tidak boleh memanggil endpoint privat; tampilkan prompt autentikasi tamu.
- Scanner hanya menghasilkan file; unggah dan verifikasi dilakukan alur terpisah.
- Jangan menyimpan frame kamera setelah layar ditutup.
- Sediakan alternatif unggah bila kamera tidak tersedia.

## 13. Error Handling

Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).

### 13.1 Kegagalan spesifik layar

- Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.
- Respons tidak sesuai envelope → tampilkan error umum, catat status code.
- 401 → bersihkan token dan arahkan ke Landing/login.
- 403 → tampilkan akses ditolak tanpa logout otomatis.
- 5xx → error server + retry; jangan menampilkan stack trace.
- Izin kamera ditolak → jelaskan dan buka pengaturan.
- Kamera tidak tersedia → tawarkan unggah dari galeri.

## 14. Keamanan & Privasi

- Token hanya di secure storage; jangan di penyimpanan lokal atau log.
- Jangan menampilkan stack trace, query database, atau detail internal pada pengguna.
- Jangan mengirim PII ke analytics/crash report.
- Validasi kepemilikan resource di backend; client tidak boleh menentukan `user_id`.
- Frame kamera tidak boleh disimpan/diunggah otomatis tanpa aksi pengguna.
- Bersihkan file sementara setelah upload/dibatalkan.

## 15. Aksesibilitas

- Semua ikon/tombol non-teks memiliki label semantik.
- Target sentuh minimal 48×48 dp; jangan hanya mengandalkan ikon kecil.
- Kontras teks memenuhi WCAG AA pada mode terang dan gelap.
- Urutan fokus screen reader mengikuti urutan visual.
- Text scale 200% tidak memotong label atau tombol utama.
- Error form diumumkan dan terhubung ke field terkait.
- Hormati reduce-motion; animasi tidak boleh menghalangi interaksi.
- Sediakan panduan suara/haptic untuk posisi dokumen.
- Sediakan alternatif unggah dari galeri.

## 16. Performa & Offline

- Gunakan `CachedNetworkImage`/cache yang ada untuk gambar jaringan.
- Hindari pekerjaan berat di `build()`; pindahkan parsing/format ke provider/util.
- Dispose controller, timer, dan subscription di `dispose`.
- Hentikan polling/timer saat app background; mulai lagi saat resume.
- Batasi resolusi/frame analysis agar UI tetap responsif; dispose kamera.
- Tidak ada cache lokal terdeteksi; jangan menambah cache tanpa kebijakan kedaluwarsa.

## 17. Analytics & Observability [Usulan]

Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_face_scanner` | Layar dibuka | screen, route, auth | Tidak |
| `face_scanner_cta_tap` | Aksi utama ditekan | cta, state | Tidak |
| `face_scanner_success` | Aksi utama berhasil | duration_ms | Tidak |
| `face_scanner_failure` | Request/aksi gagal | error_code, status | Tidak |
| `face_scanner_capture` | Foto diambil | doc_type, success | Tidak |

- Catat `request_id`/status code pada log debug, bukan payload sensitif.
- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.

## 18. Acceptance Criteria

### 18.1 Fungsional

- [ ] Foto hanya dikirim setelah pengguna menyetujui.
- [ ] Layar menangani lifecycle kamera.
- [ ] Tombol utama menjalankan aksi: Gunakan Foto.

### 18.2 Navigasi

- [ ] Jalur masuk berfungsi: Dari `CompleteProfileScreen` atau `ProfileScreen`.
- [ ] Route/parameter sesuai: `/face-scanner`.
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
| TC-01 | Widget | Happy path | Buka layar melalui: Dari `CompleteProfileScreen` atau `ProfileScreen`. | Elemen utama tampil; request sukses; tidak ada error. |
| TC-02 | Manual | Route/parameter | Buka /face-scanner dengan parameter sesuai | Parameter terbaca; layar menampilkan data yang benar. |
| TC-03 | Manual | Loading | Buka layar dengan jaringan lambat | Skeleton/spinner tampil; aksi utama disabled. |
| TC-04 | Manual | Error server | Mock respons 500 | Pesan error + tombol coba lagi; aplikasi tidak crash. |
| TC-05 | Manual | Sesi habis | Gunakan token kedaluwarsa/401 | Token dibersihkan; diarahkan ke Landing/login. |
| TC-06 | Manual | Akses ditolak | Mock respons 403 | Pesan akses ditolak; tidak logout otomatis. |
| TC-07 | Manual | Offline | Matikan jaringan lalu muat/aksi | Pesan offline + retry; data lama (bila ada) tidak hilang. |
| TC-08 | Widget | Double submit | Tekan aksi utama cepat dua kali | Hanya satu request; tombol disabled saat proses. |
| TC-09 | Manual | Layar kecil | Uji lebar 320 px dan landscape | Tidak ada overflow; tombol tetap terjangkau. |
| TC-10 | Manual | Mode gelap | Aktifkan dark mode sistem | Semua teks/komponen terbaca; tidak ada warna hardcode yang pecah. |
| TC-11 | Manual | Aksesibilitas | Aktifkan screen reader dan text scale 200% | Label terbaca; tidak ada teks terpotong. |
| TC-12 | Manual | Izin kamera | Tolak izin kamera | Penjelasan + tombol buka pengaturan; tidak crash. |
| TC-13 | Widget | Dispose kamera | Keluar saat kamera aktif | Controller dihentikan; tidak ada error lifecycle. |
| TC-14 | Manual | Regresi fitur terkait | Buka layar terkait setelah aksi | Navigasi/state tidak rusak dan data konsisten. |

**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, dan golden test untuk layar dengan layout kompleks.

## 20. Gap, Risiko & Dependensi

Tidak ada gap khusus untuk layar ini.

### 20.2 Risiko

| Risiko | Peluang | Dampak | Mitigasi |
|---|---|---|---|
| Kamera tidak di-dispose | Sedang | Sedang | Lifecycle + dispose; uji keluar/masuk layar. |

### 20.3 Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Route | /face-scanner | Terdaftar di konfigurasi router aplikasi. |

Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).

## 21. Peta Implementasi & Simbol

| Layer | Komponen/Referensi | Catatan |
|---|---|---|
| Layar/UI | `FaceScannerScreen` | Implementasi referensi aplikasi saat ini |
| Komponen UI bersama | `FaceScoreRing` | Komponen UI reusable |
| Komponen UI bersama | `CameraCoverPreview` | Komponen UI reusable |
| Komponen UI bersama | `AppBreadcrumbs` | Komponen UI reusable |
| Test | Sesuai platform target | Tambahkan test sesuai §19 |
| Dokumen | `.docs/screens/profile/face-scanner.md` | PRD ini |
| Prompt | `.skills/screens/profile/face-scanner/SKILL.md` | Skill layar |

**Metode internal terdeteksi:** `_buildRandomSequence`, `_initTts`, `_speak`, `_initializeCamera`, `_initCamera`, `_processImage`, `_processLiveness`, `_advanceStep`, `_showVerifiedModal`, `_detectFace`, `_buildScanner`, `_buildMuteButton`, `_buildInstructionCard`, `_buildVerifiedOverlay`.

## 22. Referensi & Riwayat

- [REST API](../../03-api/REST-API.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)
- [Database](../../04-database/DATABASE.md)
- [Arsitektur](../../02-architecture/ARCHITECTURE.md)
- [Skill layar](../../../.skills/screens/profile/face-scanner/SKILL.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| 6 November 2026 | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | Implementasi aplikasi, route Laravel, skema PostgreSQL |
