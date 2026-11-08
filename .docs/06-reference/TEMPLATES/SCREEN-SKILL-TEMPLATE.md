---
name: <fitur>-<layar>
description: Implementasi layar <judul>; route, endpoint, tabel, state, guardrail, dan definition of done.
---

# Skill: <Judul>

> **Tipe:** <list/detail/form/chat/payment/...> · **Route:** `<path>` · **Akses:** <Guest/Sanctum> · **State:** <Riverpod/state lokal>

## 0. Prompt siap pakai

```text
Anda bekerja pada layar <Judul> (<XScreen>) di fitur <fitur>.
File utama: <path.dart>. Route: <path> (<akses>).
Tujuan: <tujuan>.

Konteks wajib:
- Baca PRD lengkap: .docs/screens/<fitur>/<slug>.md
- State management: <Riverpod + setState>; pola data: <sekali muat/polling/realtime>.
- Endpoint: <METHOD path>; <...>.
- Tabel: <tabel...>.
- Parameter/extra: <param>.

Wajib dipertahankan:
- <aturan bisnis 1>
- <aturan bisnis 2>
- Tangani loading, empty, error, offline, unauthorized, dan double-submit.
- Gunakan AppColors/AppTextStyles/AppSizes/AppLocalizations; jangan hardcode.
- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.
- Jangan memanggil Dio baru dari widget; gunakan repository/DioClient yang ada.

Selesai jika: <aksi utama> bekerja, semua state di atas tertangani, flutter analyze bersih, dan test happy path + minimal satu error path lulus.
```

## 1. Kapan dipakai / tidak

**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan `XScreen`.

**Tidak dipakai** untuk mengubah kontrak backend tanpa memperbarui PRD, atau mendesain ulang design system.

## 2. Input & prasyarat

| Prasyarat | Nilai |
|---|---|
| File layar | `<path.dart>` |
| Route | `<path>` |
| Akses | <Guest/Sanctum> |
| Parameter | <param> |
| Masuk dari | <sumber> |
| Provider | `<provider>` |
| Endpoint | <jumlah> |
| Tabel | <jumlah> |

## 3. Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Desain | `lib/Core/Constants/` dan `lib/Core/Theme/` |
| Backend | `../Mobile-And-Backend/routes/api` dan controller |
| Database | `.docs/04-database/DATABASE.md` |
| PRD | `.docs/screens/<fitur>/<slug>.md` |

## 4. Peta file

| Layer | File | Perubahan |
|---|---|---|
| Screen | `<path.dart>` | UI, state, interaksi |
| Provider | `<provider path>` | State/aksi domain |
| Test | `test/Features/<Fitur>/` | Happy path + error path |
| PRD | `.docs/screens/<fitur>/<slug>.md` | Perbarui bila kontrak berubah |

## 5. Spesifikasi

### 5.1 Alur

1. <langkah>
2. <langkah>

### 5.2 Elemen UI wajib

- <elemen 1>
- <elemen 2>

### 5.3 State wajib

| State | UI | Pemulihan |
|---|---|---|
| `loading` | Skeleton; CTA disabled | Tunggu/retry |
| `content` | Konten utama | — |
| `empty` | Empty state + CTA | Refresh |
| `error` | Pesan + retry | Retry |
| `unauthorized` | Redirect login | Login ulang |
| `offline` | Banner offline | Coba saat online |

### 5.4 Aturan bisnis

- <aturan 1>
- <aturan 2>
- Disable tombol submit selama request.

## 6. Langkah implementasi

### Fase 0 — Recon (wajib)

1. Baca PRD dan skill ini sampai selesai.
2. Buka file layar; catat widget, state, dan panggilan API.
3. Verifikasi route di `AppRouter`.
4. Verifikasi endpoint ke backend.
5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.

### Fase 1 — Navigasi & guard

1. Pastikan route/parameter/extra sesuai.
2. Terapkan guard Guest/Sanctum.
3. Pastikan back tidak mengulang submit.

### Fase 2 — UI scaffold

1. Susun layout sesuai PRD §6.
2. Gunakan token design system.
3. Uji 320 px, keyboard, safe area.

### Fase 3 — State & data

1. Implementasikan state wajib.
2. Panggil API lewat repository/DioClient; bukan dari `build()`.
3. Kelola pagination/timer/kamera sesuai kebutuhan.

### Fase 4 — Interaksi & feedback

1. Hubungkan aksi utama.
2. Disable saat proses; tampilkan progress/sukses.
3. Petakan 422/401/403/5xx.

### Fase 5 — Kualitas

1. Semantics untuk kontrol non-teks.
2. Uji text scale 200%, dark mode, landscape.
3. Tambahkan widget/unit test.

## 7. Kontrak API

| Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|
| `<GET>` | `</api/...>` | `XController@method` | Sanctum | <kegunaan> |

Envelope: `{"status":"success","message":"...","data":{}}`.

## 8. Data & model

| Tabel | Kolom kunci |
|---|---|
| `<table>` | `id`, `<fk>`, `created_at` |

## 9. State minimum

`initial`, `loading`, `content`, `empty`, `error`, `unauthorized`, `offline`, `submitting`.

## 10. Guardrail

- Token hanya di secure storage.
- Jangan tampilkan stack trace/query.
- Guest tidak memanggil endpoint privat.
- Nominal/stok/status dari backend.

## 11. Definition of Done

- [ ] Semua elemen UI berfungsi.
- [ ] Semua state tertangani.
- [ ] Kontrak endpoint/tabel tidak berubah tanpa update dokumen.
- [ ] Tidak ada Dio baru di widget.
- [ ] 401 membersihkan token dan redirect login.
- [ ] Tidak ada overflow di 320 px/landscape/text scale 200%.
- [ ] `flutter analyze` bersih.
- [ ] Test happy path + minimal satu error path lulus.

## 12. Verifikasi

```powershell
flutter analyze lib/Features/<Fitur>/...
flutter test test/Features/<Fitur>/
```

## 13. Jebakan & gap

- <gap 1>
- <gap 2>
