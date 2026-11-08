# Skills — Wedding Flowers & Decoration Mobile

Folder ini berisi instruksi kerja yang dapat dimuat agen/AI saat mengerjakan fitur. Setiap skill merangkum **file, API, tabel database, state, dan checklist** yang relevan.

## Struktur

```text
.skills/
├── README.md
├── shared/
│   ├── flutter-screen/SKILL.md
│   ├── laravel-api/SKILL.md
│   ├── postgresql-database/SKILL.md
│   ├── api-integration/SKILL.md
│   ├── security-auth/SKILL.md
│   ├── testing/SKILL.md
│   └── screen-docs/SKILL.md
└── screens/
    ├── auth/app-lock/SKILL.md
    ├── catalog/catalog-detail/SKILL.md
    └── ... (78 layar)
```

## Cara memakai

1. Cari layar di `.docs/06-reference/SCREEN-INDEX.md`.
2. Baca PRD layar di `.docs/screens/<fitur>/<layar>.md`.
3. Muat `SKILL.md` layar tersebut.
4. Jika pekerjaan menyentuh backend, muat juga `shared/laravel-api` dan `shared/postgresql-database`.
5. Jika pekerjaan menyentuh integrasi, muat `shared/api-integration`.
6. Sebelum menutup pekerjaan, jalankan checklist di `shared/testing`.

## Aturan dasar

- **REST adalah transport utama.** GraphQL, gRPC, dan Data Connect tidak dipakai runtime.
- **Sanctum Bearer token** disimpan di `FlutterSecureStorage` dengan key `auth_token`.
- **Base URL sudah berakhiran `/api`.** Jangan menambahkan `/api` lagi.
- **Jangan mengarang endpoint.** Verifikasi dengan `php artisan route:list --path=api`.
- **Jangan mengarang kolom.** Verifikasi dengan `\d+ <tabel>` di PostgreSQL.
- **Perbarui dokumen** jika route, kontrak, atau tabel berubah.
- **Bahasa dokumentasi:** Indonesia. Istilah teknis tetap dalam bahasa aslinya.

## Sumber kebenaran

| Aspek | Sumber |
|---|---|
| Layar & route | `lib/Core/Router/AppRouter/AppRouter.dart` |
| Endpoint client | `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart` |
| HTTP client | `lib/Core/Api/DioClient/DioClient.dart` |
| Backend route | `Mobile-And-Backend/routes/api/...` |
| Backend logic | `Mobile-And-Backend/app/Http/Controllers/Api/User/...` |
| Database | PostgreSQL `wedding_florals_decorations` |
| Dokumentasi | `.docs/` |

## Regenerasi dokumen layar

Registry layar dan generator ada di `.docs/06-reference/TEMPLATES/`:

```powershell
python .docs/06-reference/TEMPLATES/_generate_screens.py
```

Generator menulis ulang 78 PRD dan 78 `SKILL.md`. Jangan mengedit file hasil generate secara manual tanpa juga memperbarui registry; perubahan akan hilang saat regenerasi.

## Standar SKILL layar

Setiap `SKILL.md` adalah instruksi kerja yang dapat dieksekusi, bukan ringkasan pasif. Struktur bakunya:

1. Frontmatter `name` + `description`
2. **Prompt siap pakai** dalam blok teks (tujuan, konteks, kontrak, guardrail, definition of done)
3. Kapan dipakai / tidak dipakai
4. Input & prasyarat (file, route, akses, provider, endpoint, tabel)
5. Sumber kebenaran dan peta file yang disentuh
6. Spesifikasi: alur, elemen UI, state wajib, aturan bisnis
7. Langkah implementasi Fase 0–5 (recon → guard → UI → state → interaksi → kualitas)
8. Kontrak API + field request + envelope
9. Data/model, state minimum, guardrail
10. Definition of Done, perintah verifikasi, jebakan/gap, handoff

Semua fakta (kelas, route, endpoint, field validasi, tabel, model) diekstrak dari kode oleh `_extract.py`. Jika kontrak berubah, perbarui registry/sumber lalu regenerasi. Template acuan: [`SCREEN-SKILL-TEMPLATE.md`](../.docs/06-reference/TEMPLATES/SCREEN-SKILL-TEMPLATE.md).
