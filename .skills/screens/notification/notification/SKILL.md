---
name: notification
description: Implementasi layar Daftar Notifikasi (NotificationScreen) pada fitur Notifikasi; route /notifications, 6 endpoint, 3 tabel, state, guardrail, dan definition of done.
---

# Skill: Daftar Notifikasi

> **Tipe:** Daftar / koleksi · **Route:** `/notifications` · **Akses:** Sanctum · **State:** State management terpusat + state lokal

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Daftar Notifikasi di fitur Notifikasi.
Referensi implementasi saat ini: NotificationScreen. Route: /notifications (Sanctum).
Tujuan: Menampilkan daftar notifikasi, status baca, dan aksi hapus/tandai semua.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/notification/notification.md
- State management: State management terpusat + state lokal; pola data: request-response.
- Endpoint: GET /notifications; POST /notifications/{id}/read; POST /notifications/read-all; GET /notifications/unread-count; DELETE /notifications/{id}; POST /notifications/fcm-token.
- Tabel: notifications, device_tokens, users.
- Parameter/extra: tidak ada parameter khusus.

Wajib dipertahankan:
- Badge mengikuti `unread-count`.
- Menghapus item mengurangi daftar tanpa reload penuh.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: buka bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Daftar Notifikasi** (referensi implementasi: `NotificationScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `NotificationScreen` |
| Route | `/notifications` |
| Akses | Sanctum |
| Parameter | Tidak ada |
| Masuk dari | Dari ikon notifikasi atau route `/notifications`. |
| State/dependency | `authProvider`, `notificationListProvider` |
| Model | `NotificationModel` |
| Endpoint | 6 |
| Tabel | 3 |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | Konfigurasi router aplikasi |
| Endpoint client | Definisi endpoint API klien |
| HTTP client | HTTP client/data source bersama |
| Desain | Token desain/tema aplikasi |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/notification/notification.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `NotificationScreen` | UI, state, interaksi |
| State/dependency | `authProvider` | State/aksi domain |
| State/dependency | `notificationListProvider` | State/aksi domain |
| Model | implementasi referensi aplikasi | Parsing/serialisasi bila kontrak berubah |
| Test | Test otomatis (platform target) di area Notifikasi/` | Test happy path + error path |
| PRD | `.docs/screens/notification/notification.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/notification/notification/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan daftar notifikasi, status baca, dan aksi hapus/tandai semua.

1. Muat halaman notifikasi.
2. Tandai satu/semua dibaca.
3. Buka detail.
4. Hapus notifikasi.

### 5.2 Elemen UI wajib

- Daftar notifikasi
- Badge unread
- Tombol tandai semua
- Swipe/menu hapus
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
| `submitting` | Tombol disabled + progress | Selesai atau tampilkan error |
| `refreshing` | Spinner di atas konten | Selesai; reset halaman |
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `unread count gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Badge mengikuti `unread-count`.
- Menghapus item mengurangi daftar tanpa reload penuh.
- Pagination tidak boleh meminta halaman yang sama berulang.
- Refresh mereset halaman dan daftar.
- Hapus item secara optimistis hanya bila aksi reversibel; jika tidak, tunggu respons.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/notification/notification.md` dan skill ini sampai selesai.
2. Tinjau implementasi referensi `NotificationScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/notifications`.
4. Verifikasi endpoint ke backend: GET /notifications; POST /notifications/{id}/read; POST /notifications/read-all; GET /notifications/unread-count; DELETE /notifications/{id}; POST /notifications/fcm-token.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di konfigurasi router.
2. Terapkan guard: Butuh Bearer token valid. 401 harus membersihkan token dan mengarahkan pengguna ke Landing/login.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan komponen UI yang sudah ada bila cocok.
2. Gunakan token desain (warna, tipografi, spacing) dan lokalisasi yang konsisten.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `kosong`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
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
| `GET` | `/notifications` | `NotificationController@index` | Sanctum | Daftar notifikasi |
| `POST` | `/notifications/{id}/read` | `NotificationController@markAsRead` | Sanctum | Menandai satu notifikasi dibaca |
| `POST` | `/notifications/read-all` | `NotificationController@markAllAsRead` | Sanctum | Tandai semua notifikasi dibaca |
| `GET` | `/notifications/unread-count` | `NotificationController@unreadCount` | Sanctum | Jumlah notifikasi belum dibaca |
| `DELETE` | `/notifications/{id}` | `NotificationController@destroy` | Sanctum | Menghapus notifikasi |
| `POST` | `/notifications/fcm-token` | `NotificationController@registerFcmToken` | Sanctum | Mendaftarkan token FCM |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `token` | `required|string` | `/notifications/fcm-token` |
| `platform` | `nullable|string|in:android,ios` | `/notifications/fcm-token` |
| `device_name` | `nullable|string|max:255` | `/notifications/fcm-token` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `notifications` | `id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at` |
| `device_tokens` | `id`, `user_id`, `token`, `type`, `created_at`, `updated_at` |
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |

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
| `refreshing` | Ya |
| `kosong` | Ya |
| `unread count gagal` | Ya |

## 10. Guardrail

- Jangan mengarang endpoint, parameter, atau kolom database.
- Jangan membuat HTTP client baru di komponen UI; gunakan data source/repository bersama.
- Jangan memanggil API di `build()` atau setiap rebuild.
- Jangan menyimpan token/password/PIN di penyimpanan lokal atau log.
- Jangan menampilkan stack trace/pesan database ke pengguna.
- Jangan menambah dependensi baru tanpa alasan dan persetujuan.
- Jangan mengubah route/parameter tanpa memperbarui konfigurasi router dan dokumen.
- Jangan menghapus test yang ada untuk membuat build lulus.

## 11. Definition of Done

- [ ] Semua elemen UI di §5.2 tampil dan berfungsi.
- [ ] Semua state di §5.3/§9 tertangani, termasuk error dan offline.
- [ ] Kontrak endpoint dan tabel tidak berubah tanpa update PRD/peta endpoint.
- [ ] Tidak ada panggilan API langsung dari siklus render UI atau pembuatan HTTP client baru di komponen UI.
- [ ] Nominal/stok/status berasal dari backend.
- [ ] 401 membersihkan token dan mengarahkan ke Landing/login.
- [ ] Tidak ada overflow di 320 px, landscape, dan text scale 200%.
- [ ] Mode terang/gelap terbaca dan target sentuh ≥48 dp.
- [ ] Analisis statis/lint sesuai toolchain target bersih.
- [ ] Test happy path + minimal satu error path lulus.
- [ ] PRD dan SKILL diperbarui bila ada perubahan.

## 12. Verifikasi

```text
# verifikasi implementasi
- Pastikan komponen/layar referensi `NotificationScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target

# verifikasi backend (opsional)
- Cek route API: /notifications

# verifikasi database (opsional)
- Cek tabel: notifications
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Preferensi notifikasi tidak disinkronkan ke backend (GAP-10).
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
