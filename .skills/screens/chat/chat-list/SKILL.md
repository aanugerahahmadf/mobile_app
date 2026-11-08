---
name: chat-list
description: Implementasi layar Daftar Chat (ChatListScreen) pada fitur Chat & Panggilan; route /chat-list, 4 endpoint, 3 tabel, state, guardrail, dan definition of done.
---

# Skill: Daftar Chat

> **Tipe:** Chat / real-time · **Route:** `/chat-list` · **Akses:** Guest + Sanctum · **State:** Riverpod + state lokal (`setState`)

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Daftar Chat (ChatListScreen) di fitur Chat & Panggilan.
File utama: lib/Features/Chat/Presentation/Screens/ChatList/ChatListScreen.dart. Route: /chat-list (Guest + Sanctum).
Tujuan: Menampilkan daftar percakapan pengguna atau guest, jumlah belum dibaca, dan pintu masuk ke detail.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/chat/chat-list.md
- State management: Riverpod + state lokal (`setState`); pola data: request-response.
- Endpoint: GET /messages/conversations; GET /messages/unread-count; POST /messages/guest/start; GET /messages/guest/{inboxId}.
- Tabel: fm_inboxes, fm_messages, users.
- Parameter/extra: `extra: {isGuestMode: bool}` opsional.

Wajib dipertahankan:
- Badge unread sesuai `unread-count`.
- Mode guest tidak meminta token.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: kirim bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `ChatListScreen`.

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; muat `shared/flutter-screen` dan `shared/security-auth`.
- Mengubah signaling WebRTC/panggilan tanpa membaca dokumentasi chat.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `lib/Features/Chat/Presentation/Screens/ChatList/ChatListScreen.dart` |
| Route | `/chat-list` |
| Akses | Guest + Sanctum |
| Parameter | `extra: {isGuestMode: bool}` opsional. |
| Masuk dari | Cabang shell `/chat-list` (tidak terlihat di bottom navigation) atau notifikasi. |
| Provider | `guestModeProvider`, `authProvider`, `chatProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 4 |
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
| PRD | `.docs/screens/chat/chat-list.md` |

## 4. Peta file yang akan disentuh

| Layer | File | Perubahan yang diharapkan |
|---|---|---|
| Screen | `lib/Features/Chat/Presentation/Screens/ChatList/ChatListScreen.dart` | UI, state, interaksi |
| Provider | `lib/Core/Utils/GuestMode/GuestMode.dart` | State/aksi domain |
| Provider | `lib/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart` | State/aksi domain |
| Provider | `lib/Features/Chat/Presentation/Providers/ChatProvider.dart` | State/aksi domain |
| Test | `test/Features/Chat/` | Test happy path + error path |
| PRD | `.docs/screens/chat/chat-list.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/chat/chat-list/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Menampilkan daftar percakapan pengguna atau guest, jumlah belum dibaca, dan pintu masuk ke detail.

1. Muat percakapan login atau guest.
2. Urutkan berdasarkan pesan terakhir.
3. Tampilkan unread badge.
4. Buka `/chat/:id` dengan mode yang sesuai.

### 5.2 Elemen UI wajib

- Daftar percakapan
- Avatar
- Pesan terakhir
- Badge unread
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
| `guest` | `GuestAuthPrompt` | Login |
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `polling gagal` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Badge unread sesuai `unread-count`.
- Mode guest tidak meminta token.
- Pesan gagal kirim harus dapat dicoba ulang tanpa menduplikasi pesan.
- Lampiran divalidasi tipe/ukuran; jangan unggah file tak dikenal.
- Guest hanya boleh memakai alur guest yang didukung backend.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/chat/chat-list.md` dan skill ini sampai selesai.
2. Buka `lib/Features/Chat/Presentation/Screens/ChatList/ChatListScreen.dart`; catat widget, state, dan panggilan API yang sudah ada.
3. Verifikasi route di `AppRouter`: `/chat-list`.
4. Verifikasi endpoint ke backend: GET /messages/conversations; GET /messages/unread-count; POST /messages/guest/start; GET /messages/guest/{inboxId}.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di `AppRouter`.
2. Terapkan guard: Guest boleh membuka layar, tetapi aksi privat harus memunculkan `GuestAuthPrompt` dan tidak mengirim Bearer token kosong.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan widget yang sudah ada bila cocok.
2. Gunakan `AppColors`, `AppTextStyles`, `AppSizes`, `AppLocalizations`.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `refreshing`, `guest`.
2. Panggil API lewat repository/DioClient; jangan dari `build()`.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama: Kirim.
2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.
3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.

### Fase 5 — Kualitas

1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.
2. Uji text scale 200%, mode gelap, dan landscape.
3. Tambahkan widget/unit test sesuai PRD §19.

## 7. Kontrak API (jangan diubah tanpa update dokumen)

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `GET` | `/messages/conversations` | `ChatController@getConversations` | Sanctum | Daftar percakapan |
| `GET` | `/messages/unread-count` | `ChatController@getUnreadCount` | Sanctum | Jumlah pesan belum dibaca |
| `POST` | `/messages/guest/start` | `ChatController@guestStart` | Publik (guest-chat) | Memulai chat guest |
| `GET` | `/messages/guest/{inboxId}` | `ChatController@guestMessages` | Publik (guest-chat) | Pesan percakapan guest |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `guest_id` | `required|string|max:190` | `/messages/guest/start` |
| `name` | `nullable|string|max:100` | `/messages/guest/start` |
| `cs_category` | `nullable|string|max:50` | `/messages/guest/start` |
| `guest_id` | `required|string|max:190` | `/messages/guest/{inboxId}` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `fm_inboxes` | `id`, `title`, `user_ids`, `created_at`, `updated_at`, `deleted_at`, `meta` |
| `fm_messages` | `id`, `inbox_id`, `message`, `user_id`, `read_by`, `read_at`, `notified`, `created_at` … |
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |

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
| `guest` | Ya |
| `kosong` | Ya |
| `polling gagal` | Ya |

## 10. Guardrail

- Jangan mengarang endpoint, parameter, atau kolom database.
- Jangan membuat instance `Dio` baru di widget; gunakan `DioClient`/repository.
- Jangan memanggil API di `build()` atau setiap rebuild.
- Jangan menyimpan token/password/PIN di `SharedPreferences` atau log.
- Jangan menampilkan stack trace/pesan database ke pengguna.
- Jangan menambah dependensi baru tanpa alasan dan persetujuan.
- Jangan mengubah route/parameter tanpa memperbarui `AppRouter` dan dokumen.
- Jangan menghapus test yang ada untuk membuat build lulus.
- Jangan menandai pesan terkirim sebelum server mengonfirmasi.

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
rg "ChatListScreen" lib
flutter analyze
flutter test test/Features/Chat

# dari root backend
php artisan route:list --path=api | Select-String "/messages/conversations"

# dari PostgreSQL
\d+ fm_inboxes
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Tidak ada tab bottom navigation untuk chat meski branch shell aktif.
- Mode guest ditentukan `extra.isGuestMode`.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
