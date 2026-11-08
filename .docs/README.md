# Dokumentasi Mobile App — Wedding Flowers & Decoration

Dokumentasi ini adalah **sumber kebenaran untuk implementasi layar Flutter** yang terhubung ke backend Laravel dan database PostgreSQL. Isinya disusun dari kode aktual, bukan dari asumsi dokumen lama.

- **Aplikasi:** Flutter (`mobile_app`)
- **Backend:** Laravel 12 (`../Mobile-And-Backend`)
- **Database:** PostgreSQL 18.2, database `wedding_florals_decorations`
- **Transport utama:** REST JSON di bawah `/api`
- **Auth:** Laravel Sanctum Bearer token
- **State management:** Riverpod
- **Navigasi:** `go_router` dengan `StatefulShellRoute`
- **Tanggal verifikasi:** 6 November 2026

## Cara membaca

1. Mulai dari [Master PRD](01-catalog/MASTER-PRD.md) untuk konteks aplikasi.
2. Baca [Arsitektur](02-architecture/ARCHITECTURE.md) dan [Navigasi](02-architecture/NAVIGATION.md).
3. Untuk pekerjaan per layar, buka [Indeks Layar](06-reference/SCREEN-INDEX.md), lalu PRD layar di `screens/<feature>/`.
4. Untuk kontrak HTTP, buka [REST API](03-api/REST-API.md) dan [Peta Endpoint](06-reference/API-ENDPOINT-MAP.md).
5. Untuk skema data, buka [Database](04-database/DATABASE.md) dan [ERD](04-database/ERD.md).
6. Sebelum mengubah kode, baca [Integration Guide](05-operations/INTEGRATION-GUIDE.md) dan [Known Gaps](06-reference/KNOWN-GAPS.md).
7. Untuk instruksi kerja per layar, buka [Skills](../.skills/README.md).

## Struktur

```text
.docs/
├── 01-catalog/            # visi, persona, alur bisnis
├── 02-architecture/       # arsitektur, navigasi, state/error
├── 03-api/                # REST, GraphQL, gRPC, Firebase, Data Connect
├── 04-database/           # skema, relasi, aturan data
├── 05-operations/         # environment, integrasi, verifikasi
├── 06-reference/          # indeks layar, peta endpoint, gap, template
└── screens/<feature>/     # satu PRD per layar
```

```text
.skills/
├── shared/                # skill lintas layar
└── screens/<feature>/<screen>/SKILL.md
```

Generator PRD/skill ada di `.docs/06-reference/TEMPLATES/`. Jalankan ulang setelah registry berubah:

```powershell
python .docs/06-reference/TEMPLATES/_generate_screens.py
```

## Standar PRD layar

Setiap PRD di `.docs/screens/<fitur>/<layar>.md` memakai 23 bagian (0–22) dan **diturunkan dari kode aktual**:

1. Ringkasan eksekutif, konteks, dan definisi sukses
2. Navigasi/entry, guard, dan parameter `go_router`
3. Alur pengguna + diagram Mermaid
4. Arsitektur layar: kelas, state management, state lokal, alur data
5. Blueprint UI + inventaris komponen
6. Design system dan aturan responsif
7. State machine lengkap dengan pemulihan
8. Kontrak API per endpoint: aturan validasi, response top-level, pesan error
9. Data & database: tabel dan kolom kunci
10. Aturan bisnis, error handling, security, accessibility, performance
11. Analytics [Usulan], acceptance criteria, test plan
12. Gap/risiko/dependensi, peta simbol, referensi, riwayat

Sumber fakta: `lib/`, `routes/api/`, controller Laravel, dan `_tables.json`. Jangan menambahkan endpoint/kolom yang tidak ada di sumber. Template acuan: [`SCREEN-PRD-TEMPLATE.md`](06-reference/TEMPLATES/SCREEN-PRD-TEMPLATE.md).

## Status dokumentasi

| Area | Cakupan | Status |
|---|---|---|
| Layar | 78 PRD layar + 78 skill layar, 19 fitur | Selesai |
| Route | 56 route `go_router` + layar tak ter-route | Terdokumentasi |
| REST | 207 route user API, 147 konstanta client | Terdokumentasi |
| Database | 83 tabel, 74 foreign key | Terdokumentasi |
| GraphQL | Endpoint `/graphql`, client helper | Terdokumentasi sebagai fallback |
| gRPC | Generated client, tidak dipakai runtime | Terdokumentasi sebagai legacy |
| Firebase | FCM aktif; Auth/Analytics/Data Connect tidak dipakai sebagai kanal data | Terdokumentasi |

## Aturan penting

- Semua nominal, status pesanan, ketersediaan stok, dan kepemilikan resource **wajib** divalidasi backend.
- Jangan menambah query database langsung dari Flutter. Flutter hanya berbicara ke REST/GraphQL.
- Jangan menganggap semua konstanta `ApiEndpoints` valid. Beberapa endpoint tidak terdaftar di Laravel; lihat [Known Gaps](06-reference/KNOWN-GAPS.md).
- Perubahan kontrak API harus memperbarui PRD layar, peta endpoint, dan skill layar terkait.
