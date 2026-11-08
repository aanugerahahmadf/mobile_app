---
name: payment-webview
description: Implementasi layar Webview Pembayaran (PaymentWebViewScreen) pada fitur Pembayaran; route /payment-webview, 0 endpoint, 0 tabel, state, guardrail, dan definition of done.
---

# Skill: Webview Pembayaran

> **Tipe:** WebView · **Route:** `/payment-webview` · **Akses:** Sanctum · **State:** State lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Webview Pembayaran (PaymentWebViewScreen) di fitur Pembayaran.
File utama: lib/Features/Payment/Presentation/Screens/PaymentWebview/PaymentWebviewScreen.dart. Route: /payment-webview (Sanctum).
Tujuan: Membuka halaman pembayaran eksternal (Midtrans/payment gateway) di dalam WebView.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/payment/payment-webview.md
- State management: State lokal (`setState`); pola data: request-response.
- Endpoint: tidak ada endpoint jaringan.
- Tabel: tidak ada tabel langsung.
- Parameter/extra: `extra: {url, title}` wajib.

Wajib dipertahankan:
- URL kosong tidak membuka WebView.
- Redirect kembali menutup layar.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: saya sudah bayar bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `PaymentWebViewScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Payment/Presentation/Screens/PaymentWebview/PaymentWebviewScreen.dart` |
| Route | `/payment-webview` |
| Akses | Sanctum |
| Parameter | `extra: {url, title}` wajib. |
| Masuk dari | Dari instruksi pembayaran bila backend mengembalikan `payment_url`. |
| Provider | Tidak terdeteksi |
| Model | Tidak terdeteksi |
| Endpoint | 0 |
| Tabel | 0 |

- WebView membutuhkan koneksi jaringan dan URL valid; uji juga halaman error.

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/payment/payment-webview.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Payment/Presentation/Screens/PaymentWebview/PaymentWebviewScreen.dart` | UI, state, interaksi |
| Test | `test/Features/Pembayaran/` | Test happy path + error path |
| PRD | `.docs/screens/payment/payment-webview.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/payment/payment-webview/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Membuka halaman pembayaran eksternal (Midtrans/payment gateway) di dalam WebView.

1. Terima URL dan judul.
2. Tampilkan WebView.
3. Tangani redirect sukses/gagal.
4. Tutup dan kembali.

### 5.2 Elemen UI wajib

- AppBar
- WebView
- Progress bar
- Tombol tutup

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `initial` | Kerangka/placeholder awal | Muat data |
| `loading` | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Render konten utama | — |
| `error` | Pesan ramah + tombol coba lagi | Retry |
| `unauthorized` | Sesi berakhir; arahkan login/Landing | Login ulang |
| `offline` | Banner/empty offline | Coba lagi saat online |
| `URL kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `koneksi gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `redirect sukses` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- URL kosong tidak membuka WebView.
- Redirect kembali menutup layar.
- Validasi URL sebelum membuka; hanya izinkan domain pembayaran resmi.
- Tangani back, error halaman, dan jangan menyimpan kredensial di WebView.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/payment/payment-webview.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Payment/Presentation/Screens/PaymentWebview/PaymentWebviewScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/payment-webview`.
4. Verifikasi endpoint ke backend: tidak ada endpoint jaringan.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di `AppRouter`.
2. Terapkan guard: Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan widget yang sudah ada bila cocok.
2. Gunakan `AppColors`, `AppTextStyles`, `AppSizes`, `AppLocalizations`.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `error`, `unauthorized`, `offline`, `URL kosong`, `koneksi gagal`, `redirect sukses`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Saya Sudah Bayar.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

Tidak ada API jaringan. Gunakan penyimpanan lokal atau data `extra`.

## 8. Data & model

Tidak ada tabel yang dipakai langsung.

## 9. State minimum

| State | Harus ada |
|---|---|
| `initial` | Ya |
| `loading` | Ya |
| `content` | Ya |
| `error` | Ya |
| `unauthorized` | Ya |
| `offline` | Ya |
| `URL kosong` | Ya |
| `koneksi gagal` | Ya |
| `redirect sukses` | Ya |

## 10. Guardrail

- Jangan mengarang endpoint, parameter, atau kolom database.
- Jangan membuat instance `Dio` baru di widget; gunakan `DioClient`/repository.
- Jangan memanggil API di `build()` atau setiap rebuild.
- Jangan menyimpan token/password/PIN di `SharedPreferences` atau log.
- Jangan menampilkan stack trace/pesan database ke pengguna.
- Jangan menambah dependensi baru tanpa alasan dan persetujuan.
- Jangan mengubah route/parameter tanpa memperbarui `AppRouter` dan dokumen.
- Jangan menghapus test yang ada untuk membuat build lulus.

## 11. Definition of Done

- [ ] Semua elemen UI di §5.2 tampil dan berfungsi.
- [ ] Semua state di §5.3/§9 tertangani, termasuk error dan offline.
- [ ] Kontrak endpoint dan tabel tidak berubah tanpa update PRD/peta endpoint.
- [ ] Tidak ada panggilan API langsung dari `build()` atau instance Dio baru.
- [ ] Nominal/stok/status berasal dari backend.
- [ ] 401 membersihkan token dan mengarahkan ke Landing/login.
- [ ] Tidak ada overflow di 320 px, landscape, dan text scale 200%.
- [ ] Mode terang/gelap terbaca dan target sentuh ≥48 dp.
- [ ] `flutter analyze` bersih.
- [ ] Test happy path + minimal satu error path lulus.
- [ ] PRD dan SKILL diperbarui bila ada perubahan.

## 12. Verifikasi

```powershell
# dari root mobile_app
rg "PaymentWebViewScreen" lib
flutter analyze
flutter test test/Features/Pembayaran
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Tidak ada verifikasi status langsung; status final tetap dari backend/webhook.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
