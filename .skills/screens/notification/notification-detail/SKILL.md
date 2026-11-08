---
name: notification-detail
description: Implementasi layar Detail Notifikasi (NotificationDetailScreen) pada fitur Notifikasi; route /notification/:id, 2 endpoint, 1 tabel, state, guardrail, dan definition of done.
---

# Skill: Detail Notifikasi

> **Tipe:** Daftar / koleksi · **Route:** `/notification/:id` · **Akses:** Sanctum · **State:** Stateless

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Detail Notifikasi (NotificationDetailScreen) di fitur Notifikasi.
File utama: lib/Features/Notification/Presentation/Screens/NotificationDetail/NotificationDetailScreen.dart. Route: /notification/:id (Sanctum).
Tujuan: Menampilkan isi notifikasi dan membuka tujuan terkait (pesanan, chat, katalog).

Konteks wajib:
- Baca PRD lengkap: .docs/screens/notification/notification-detail.md
- State management: Stateless; pola data: request-response.
- Endpoint: POST /notifications/{id}/read; DELETE /notifications/{id}.
- Tabel: notifications.
- Parameter/extra: `extra` harus `NotificationModel` untuk halaman detail.

Wajib dipertahankan:
- Membuka detail menandai notifikasi dibaca.
- Jika `extra` bukan model, route menampilkan daftar notifikasi.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: buka bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `NotificationDetailScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Notification/Presentation/Screens/NotificationDetail/NotificationDetailScreen.dart` |
| Route | `/notification/:id` |
| Akses | Sanctum |
| Parameter | `extra` harus `NotificationModel` untuk halaman detail. |
| Masuk dari | Dari `NotificationScreen` dengan `extra` berupa `NotificationModel`. |
| Provider | Tidak terdeteksi |
| Model | `NotificationModel` |
| Endpoint | 2 |
| Tabel | 1 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/notification/notification-detail.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Notification/Presentation/Screens/NotificationDetail/NotificationDetailScreen.dart` | UI, state, interaksi |
| Model | `lib/Features/Notification/Data/Models/NotificationModel/NotificationModel.dart` | Parsing/serialisasi bila kontrak berubah |
| Test | `test/Features/Notifikasi/` | Test happy path + error path |
| PRD | `.docs/screens/notification/notification-detail.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/notification/notification-detail/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan isi notifikasi dan membuka tujuan terkait (pesanan, chat, katalog).

1. Terima model notifikasi.
2. Tandai dibaca.
3. Tampilkan isi dan aksi deep link.
4. Hapus notifikasi bila diminta.

### 5.2 Elemen UI wajib

- Judul
- Isi
- Waktu
- Tombol aksi
- Menu hapus

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
| `submitting` | Tombol disabled + progress | Selesai atau tampilkan error |
| `model tidak ada (fallback)` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `notifikasi sudah dibaca` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `deep link tidak valid` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Membuka detail menandai notifikasi dibaca.
- Jika `extra` bukan model, route menampilkan daftar notifikasi.
- Pagination tidak boleh meminta halaman yang sama berulang.
- Refresh mereset halaman dan daftar.
- Hapus item secara optimistis hanya bila aksi reversibel; jika tidak, tunggu respons.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/notification/notification-detail.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Notification/Presentation/Screens/NotificationDetail/NotificationDetailScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/notification/:id`.
4. Verifikasi endpoint ke backend: POST /notifications/{id}/read; DELETE /notifications/{id}.
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

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `model tidak ada (fallback)`, `notifikasi sudah dibaca`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Buka.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `POST` | `/notifications/{id}/read` | `NotificationController@markAsRead` | Sanctum | Menandai satu notifikasi dibaca |
| `DELETE` | `/notifications/{id}` | `NotificationController@destroy` | Sanctum | Menghapus notifikasi |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `notifications` | `id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at` |

| Model | Field kunci |
|---|---|
| `NotificationModel` | `id`, `type`, `title`, `body`, `data`, `read`, `readAt`, `createdAt` |

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
| `submitting` | Ya |
| `model tidak ada (fallback)` | Ya |
| `notifikasi sudah dibaca` | Ya |
| `deep link tidak valid` | Ya |

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
rg "NotificationDetailScreen" lib
flutter analyze
flutter test test/Features/Notifikasi

# dari root backend
php artisan route:list --path=api | Select-String "/notifications/"

# dari PostgreSQL
\d+ notifications
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- `/notification/:id` memiliki fallback ke `NotificationScreen` bila `extra` bukan `NotificationModel`.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
