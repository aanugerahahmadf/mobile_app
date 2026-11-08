---
name: history
description: Implementasi layar Riwayat Dompet (HistoryScreen) pada fitur Riwayat; route /history, 2 endpoint, 3 tabel, state, guardrail, dan definition of done.
---

# Skill: Riwayat Dompet

> **Tipe:** Daftar / koleksi · **Route:** `/history` · **Akses:** Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Riwayat Dompet (HistoryScreen) di fitur Riwayat.
File utama: lib/Features/History/Presentation/Screens/History/HistoryScreen.dart. Route: /history (Sanctum).
Tujuan: Menampilkan mutasi saldo dan riwayat transaksi dompet pengguna.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/history/history.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /wallet/history; GET /wallet.
- Tabel: histories, transactions, users.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Nominal masuk dan keluar dibedakan.
- Tidak memakai endpoint `/histories` yang tidak cocok.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: buka detail transaksi bila tersedia bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `HistoryScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/History/Presentation/Screens/History/HistoryScreen.dart` |
| Route | `/history` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Dari `ProfileScreen` atau tautan di voucher/pesanan. |
| Provider | `authProvider`, `historyProvider` |
| Model | `HistoryModel` |
| Endpoint | 2 |
| Tabel | 3 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/history/history.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/History/Presentation/Screens/History/HistoryScreen.dart` | UI, state, interaksi |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/History/Presentation/Providers/HistoryProvider.dart` | State/aksi domain |
| Model | `lib/Features/History/Data/Models/HistoryModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Riwayat/` | Test happy path + error path |
| PRD | `.docs/screens/history/history.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/history/history/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan mutasi saldo dan riwayat transaksi dompet pengguna.

1. Muat `/wallet/history` dengan paginasi.
2. Kelompokkan transaksi berdasarkan tanggal.
3. Tampilkan nominal masuk/keluar dan status.
4. Buka detail transaksi bila tersedia.

### 5.2 Elemen UI wajib

- Daftar transaksi
- Filter/segmen
- Nominal berwarna
- Empty state

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `initial` | Kerangka/placeholder awal | Muat data |
| `loading` | Skeleton/spinner; aksi utama disabled | Tunggu atau retry saat timeout |
| `content` | Render konten utama | — |
| `empty` | Empty state dengan penjelasan + CTA | Refresh atau aksi lanjutan |
| `error` | Pesan ramah + tombol coba lagi | Retry |
| `unauthorized` | Sesi berakhir; arahkan login/Landing | Login ulang |
| `offline` | Banner/empty offline | Coba lagi saat online |
| `refreshing` | Spinner di atas konten | Selesai; reset halaman |
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `paginasi habis` | Tampilkan penanda akhir daftar atau status kedaluwarsa. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Nominal masuk dan keluar dibedakan.
- Tidak memakai endpoint `/histories` yang tidak cocok.
- Pagination tidak boleh meminta halaman yang sama berulang.
- Refresh mereset halaman dan daftar.
- Hapus item secara optimistis hanya bila aksi reversibel; jika tidak, tunggu respons.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/history/history.md` dan skill ini sampai selesai.
2. Buka `lib/Features/History/Presentation/Screens/History/HistoryScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/history`.
4. Verifikasi endpoint ke backend: GET /wallet/history; GET /wallet.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `refreshing`, `kosong`, `paginasi habis`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Buka detail transaksi bila tersedia.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/wallet/history` | `WalletController@getHistory` | Sanctum | Mutasi dompet |
| `GET` | `/wallet` | `WalletController@getWalletData` | Sanctum | Saldo dompet |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `histories` | `id`, `user_id`, `type`, `transaction_id`, `reference_number`, `amount`, `info`, `status` … |
| `transactions` | `id`, `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount` … |
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |

| Model | Field kunci |
|---|---|
| `HistoryModel` | `id`, `userId`, `type`, `transactionId`, `referenceNumber`, `amount`, `info`, `status` |

## 9. State minimum

| State | Harus ada |
|---|---|
| `initial` | Ya |
| `loading` | Ya |
| `content` | Ya |
| `empty` | Ya |
| `error` | Ya |
| `unauthorized` | Ya |
| `offline` | Ya |
| `refreshing` | Ya |
| `kosong` | Ya |
| `paginasi habis` | Ya |

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
rg "HistoryScreen" lib
flutter analyze
flutter test test/Features/Riwayat

# dari root backend
php artisan route:list --path=api | Select-String "/wallet/history"

# dari PostgreSQL
\d+ histories
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- `HistoryScreen` memakai `GET /wallet/history`; jangan menggantinya dengan `/histories`.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
