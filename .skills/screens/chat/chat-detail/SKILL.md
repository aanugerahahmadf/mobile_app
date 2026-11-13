---
name: chat-detail
description: Implementasi layar Detail Chat & Panggilan (ChatDetailScreen) pada fitur Chat & Panggilan; route /chat/:id, 25 endpoint, 14 tabel, state, guardrail, dan definition of done.
---

# Skill: Detail Chat & Panggilan

> **Tipe:** Chat / real-time · **Route:** `/chat/:id` · **Akses:** Guest + Sanctum · **State:** State management terpusat + state lokal

## 0. Prompt siap pakai

Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.

```text
Anda bekerja pada layar Detail Chat & Panggilan di fitur Chat & Panggilan.
Referensi implementasi saat ini: ChatDetailScreen. Route: /chat/:id (Guest + Sanctum).
Tujuan: Percakapan real-time dengan teks, lampiran, balasan, reaksi, laporan, dan panggilan audio/video WebRTC.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/chat/chat-detail.md
- State management: State management terpusat + state lokal; pola data: polling periodik.
- Endpoint: GET /messages/conversations/{inboxId}; POST /messages/send; POST /messages/{id}/star; DELETE /messages/{id}/delete; POST /messages/{id}/forward; POST /messages/{id}/react …
- Tabel: fm_messages, fm_inboxes, chat_calls, users, catalogs, categories, packages, media, orders, transactions, order_timelines, vouchers, user_vouchers, reports.
- Parameter/extra: Path `id` = inboxId. `extra: {cs_category, guestId/guest_id}`.

Wajib dipertahankan:
- Pesan optimistis berubah status setelah server merespons.
- Panggilan dapat diterima/ditolak dan state dipulihkan setelah reconnect.
- Guest tidak dapat mengakses inbox pengguna lain.
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.

Selesai jika: kirim bekerja, semua state di atas tertangani, analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **Detail Chat & Panggilan** (referensi implementasi: `ChatDetailScreen`).

**Tidak dipakai** untuk:
- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.
- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.
- Mengubah signaling WebRTC/panggilan tanpa membaca dokumentasi chat.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| Referensi implementasi | `ChatDetailScreen` |
| Route | `/chat/:id` |
| Akses | Guest + Sanctum |
| Parameter | Path `id` = inboxId. `extra: {cs_category, guestId/guest_id}`. |
| Masuk dari | Dari `ChatListScreen`, notifikasi, atau tautan laporan dari katalog. |
| State/dependency | `guestModeProvider`, `authProvider`, `chatProvider` |
| Model | Tidak terdeteksi |
| Endpoint | 25 |
| Tabel | 14 |

- Timer/polling harus diuji saat app background/resume dan saat dispose.

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | Konfigurasi router aplikasi |
| Endpoint client | Definisi endpoint API klien |
| HTTP client | HTTP client/data source bersama |
| Desain | Token desain/tema aplikasi |
| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |
| Database | PostgreSQL `wedding_florals_decorations` |
| PRD | `.docs/screens/chat/chat-detail.md` |

## 4. Peta file yang akan disentuh

| Area | Komponen | Perubahan yang diharapkan |
|---|---|---|
| Layar/UI | `ChatDetailScreen` | UI, state, interaksi |
| State/dependency | `guestModeProvider` | State/aksi domain |
| State/dependency | `authProvider` | State/aksi domain |
| State/dependency | `chatProvider` | State/aksi domain |
| Test | Test otomatis (platform target) di area Chat/` | Test happy path + error path |
| PRD | `.docs/screens/chat/chat-detail.md` | Perbarui bila route/API/tabel berubah |
| Prompt | `.skills/screens/chat/chat-detail/SKILL.md` | Skill ini |

## 5. Spesifikasi yang harus dipertahankan

### 5.1 Tujuan & alur

Percakapan real-time dengan teks, lampiran, balasan, reaksi, laporan, dan panggilan audio/video WebRTC.

1. Muat pesan berdasarkan `inboxId`.
2. Kirim teks/lampiran dan tandai sudah dibaca.
3. Balas, teruskan, beri reaksi, atau hapus pesan.
4. Mulai/terima panggilan WebRTC dan relay SDP/ICE.
5. Akhiri panggilan atau laporkan percakapan.

### 5.2 Elemen UI wajib

- Bubble pesan
- Composer
- Lampiran
- Menu konteks pesan
- Panel panggilan
- Indikator koneksi

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
| `guest` | prompt autentikasi tamu | Login |
| `kosong` | Empty state dengan penjelasan dan CTA lanjutan. | Ikuti aksi pemulihan pada pesan |
| `gagal kirim` | Pesan ramah + retry; pertahankan input pengguna. | Ikuti aksi pemulihan pada pesan |
| `reconnect` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |
| `izin mikrofon ditolak` | Tampilkan penjelasan izin dan tombol buka pengaturan. | Ikuti aksi pemulihan pada pesan |
| `panggilan berakhir` | Tampilkan status yang jelas dan aksi pemulihan. | Ikuti aksi pemulihan pada pesan |

### 5.4 Aturan bisnis

- Pesan optimistis berubah status setelah server merespons.
- Panggilan dapat diterima/ditolak dan state dipulihkan setelah reconnect.
- Guest tidak dapat mengakses inbox pengguna lain.
- Pesan gagal kirim harus dapat dicoba ulang tanpa menduplikasi pesan.
- Lampiran divalidasi tipe/ukuran; jangan unggah file tak dikenal.
- Guest hanya boleh memakai alur guest yang didukung backend.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD `.docs/screens/chat/chat-detail.md` dan skill ini sampai selesai.
2. Tinjau implementasi referensi `ChatDetailScreen`; catat komponen UI, state, dan panggilan API yang sudah ada.
3. Verifikasi route di konfigurasi router: `/chat/:id`.
4. Verifikasi endpoint ke backend: GET /messages/conversations/{inboxId}; POST /messages/send; POST /messages/{id}/star; DELETE /messages/{id}/delete; POST /messages/{id}/forward; POST /messages/{id}/react …
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di konfigurasi router.
2. Terapkan guard: Guest boleh membuka layar, tetapi aksi privat harus memunculkan prompt autentikasi tamu dan tidak mengirim Bearer token kosong.
3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.

### Fase 2 — UI scaffold

1. Susun layout sesuai blueprint PRD §5; gunakan komponen UI yang sudah ada bila cocok.
2. Gunakan token desain (warna, tipografi, spacing) dan lokalisasi yang konsisten.
3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.

### Fase 3 — State & data

1. Implementasikan state: `initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`, `guest`, `kosong`.
2. Panggil API lewat repository/data source; jangan dari siklus render UI.
3. Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.
4. Kelola timer/polling: mulai setelah layar siap, hentikan di `dispose`/background.

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
| `GET` | `/messages/conversations/{inboxId}` | `ChatController@getMessages` | Sanctum | Pesan dalam percakapan |
| `POST` | `/messages/send` | `ChatController@sendMessage` | Sanctum | Mengirim pesan |
| `POST` | `/messages/{id}/star` | `ChatController@starMessage` | Sanctum | Menandai pesan |
| `DELETE` | `/messages/{id}/delete` | `ChatController@deleteMessage` | Sanctum | Menghapus pesan |
| `POST` | `/messages/{id}/forward` | `ChatController@forwardMessage` | Sanctum | Meneruskan pesan |
| `POST` | `/messages/{id}/react` | `ChatController@addReaction` | Sanctum | Reaksi pesan |
| `POST` | `/messages/{inboxId}/read` | `ChatController@markInboxAsRead` | Sanctum | Menandai pesan dibaca |
| `POST` | `/messages/{inboxId}/rate` | `ChatController@rateInbox` | Sanctum | Menilai percakapan |
| `POST` | `/messages/calls` | `ChatCallController@start` | Sanctum | Memulai panggilan WebRTC |
| `GET` | `/messages/calls/{token}` | `ChatCallController@state` | Sanctum | Status panggilan |
| `POST` | `/messages/calls/{token}/signal` | `ChatCallController@signal` | Sanctum | Signaling SDP/ICE |
| `POST` | `/messages/calls/{token}/accept` | `ChatCallController@accept` | Sanctum | Menerima panggilan |
| `POST` | `/messages/calls/{token}/end` | `ChatCallController@end` | Sanctum | Mengakhiri panggilan |
| `GET` | `/messages/guest/{inboxId}` | `ChatController@guestMessages` | Publik (guest-chat) | Pesan percakapan guest |
| `POST` | `/messages/guest/send` | `ChatController@guestSend` | Publik (guest-chat) | Mengirim pesan guest |
| `POST` | `/messages/guest/calls` | `ChatCallController@start` | Publik (guest-chat) | Memulai panggilan guest |
| `GET` | `/messages/guest/calls/{token}` | `ChatCallController@state` | Publik (guest-chat) | Status panggilan guest |
| `POST` | `/messages/guest/calls/{token}/signal` | `ChatCallController@signal` | Publik (guest-chat) | Signaling SDP/ICE guest |
| `POST` | `/messages/guest/calls/{token}/end` | `ChatCallController@end` | Publik (guest-chat) | Mengakhiri panggilan guest |
| `GET` | `/catalog` | `CatalogController@index` | Sanctum | Daftar katalog dengan filter/paginasi |
| `GET` | `/bookings` | `OrderController@getOrders` | Sanctum | Membuat/membaca pesanan |
| `POST` | `/bookings` | `OrderController@createOrder` | Sanctum | Membuat/membaca pesanan |
| `GET` | `/reports` | `ReportController@index` | Sanctum | Membuat/membaca laporan |
| `POST` | `/reports` | `ReportController@store` | Sanctum | Membuat/membaca laporan |
| `GET` | `/reports/{report}/pdf` | `ReportController@downloadPdf` | Sanctum | Mengunduh PDF laporan |

**Field request yang terbaca dari controller:**

| Field | Aturan | Endpoint |
|---|---|---|
| `inbox_id` | `required` | `/messages/send` |
| `message` | `required_without_all:attachment,type,order_id|nullable|string` | `/messages/send` |
| `attachment` | `nullable|file|mimes:jpg,jpeg,png,gif,webp,mp4,mov,m4v,webm,3gp|max:51200` | `/messages/send` |
| `type` | `nullable|string` | `/messages/send` |
| `item_id` | `nullable|integer` | `/messages/send` |
| `item_name` | `nullable|string` | `/messages/send` |
| `item_price` | `nullable|numeric` | `/messages/send` |
| `item_image` | `nullable|string` | `/messages/send` |
| `order_id` | `nullable|integer` | `/messages/send` |
| `cs_category` | `nullable|string|max:50` | `/messages/send` |
| `reply_to_id` | `nullable|integer` | `/messages/send` |
| `target_inbox_id` | `required|integer` | `/messages/{id}/forward` |
| `emoji` | `required|string|max:10` | `/messages/{id}/react` |
| `rating` | `required|integer|min:1|max:5` | `/messages/{inboxId}/rate` |
| `comment` | `nullable|string|max:500` | `/messages/{inboxId}/rate` |
| `inbox_id` | `required|integer` | `/messages/calls` |

Envelope: `{"status":"success","message":"...","data":{}}`; periksa controller untuk variasi `success`/`error_code`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `fm_messages` | `id`, `inbox_id`, `message`, `user_id`, `read_by`, `read_at`, `notified`, `created_at` … |
| `fm_inboxes` | `id`, `title`, `user_ids`, `created_at`, `updated_at`, `deleted_at`, `meta` |
| `chat_calls` | `id`, `token`, `inbox_id`, `caller_user_id`, `callee_user_id`, `status`, `offer`, `answer` … |
| `users` | `id`, `full_name`, `first_name`, `mid_name`, `last_name`, `username`, `email`, `balance` … |
| `catalogs` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `discount_price`, `stock` … |
| `categories` | `id`, `name`, `slug`, `icon`, `color`, `description`, `created_at`, `updated_at` … |
| `packages` | `id`, `category_id`, `name`, `slug`, `description`, `price`, `stock`, `discount_price` … |
| `media` | `id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type` … |
| `orders` | `id`, `user_id`, `package_id`, `catalog_id`, `order_number`, `total_price`, `status`, `payment_status` … |
| `transactions` | `id`, `user_id`, `order_id`, `type`, `reference_number`, `amount`, `admin_fee`, `total_amount` … |
| `order_timelines` | `id`, `order_id`, `status`, `description`, `metadata`, `created_by`, `created_at`, `updated_at` |
| `vouchers` | `id`, `code`, `description`, `expires_at`, `is_active`, `is_global`, `max_uses`, `uses_count` … |
| `user_vouchers` | `id`, `user_id`, `voucher_id`, `claimed_at`, `used_at`, `order_id`, `created_at`, `updated_at` |
| `reports` | `id`, `user_id`, `reportable_type`, `reportable_id`, `category`, `reason`, `description`, `status` … |

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
| `guest` | Ya |
| `kosong` | Ya |
| `gagal kirim` | Ya |
| `reconnect` | Ya |
| `izin mikrofon ditolak` | Ya |
| `panggilan berakhir` | Ya |

## 10. Guardrail

- Jangan mengarang endpoint, parameter, atau kolom database.
- Jangan membuat HTTP client baru di komponen UI; gunakan data source/repository bersama.
- Jangan memanggil API di `build()` atau setiap rebuild.
- Jangan menyimpan token/password/PIN di penyimpanan lokal atau log.
- Jangan menampilkan stack trace/pesan database ke pengguna.
- Jangan menambah dependensi baru tanpa alasan dan persetujuan.
- Jangan mengubah route/parameter tanpa memperbarui konfigurasi router dan dokumen.
- Jangan menghapus test yang ada untuk membuat build lulus.
- Jangan menandai pesan terkirim sebelum server mengonfirmasi.

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
- Pastikan komponen/layar referensi `ChatDetailScreen` dan perilakunya sesuai
- Jalankan analisis statis/lint sesuai toolchain target
- Jalankan test otomatis sesuai platform target

# verifikasi backend (opsional)
- Cek route API: /messages/conversations/

# verifikasi database (opsional)
- Cek tabel: fm_messages
```

Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, double-tap submit, 320 px, mode gelap, dan text scale 200%.

## 13. Jebakan & gap

- Layar sangat besar (3170 baris); pisahkan logika panggilan dan composer.
- `fm_messages.inbox_id` tidak memiliki FK (GAP-11).
- Laporan dibuat lewat `openReportChat`, bukan form laporan terpisah.
- Layar memakai HTTP client bersama langsung. Refactor ke repository harus menjaga kontrak dan error mapping.
- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.

## 14. Handoff

- **Status awal:** Kontrak terdokumentasi; ada gap yang harus ditangani
- **Perubahan terakhir:** regenerasi detail 6 November 2026.
- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.
- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.
