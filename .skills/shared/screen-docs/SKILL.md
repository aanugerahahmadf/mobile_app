---
name: screen-docs
description: Cara memelihara PRD per layar dan SKILL per layar di folder .docs dan .skills, termasuk registry, generator, dan validasi.
---

# Skill: Dokumentasi Layar

## 1. Struktur

```text
.docs/
├── 01-catalog/MASTER-PRD.md
├── 02-architecture/
├── 03-api/
├── 04-database/
├── 05-operations/
├── 06-reference/
│   ├── SCREEN-INDEX.md
│   ├── API-ENDPOINT-MAP.md
│   ├── KNOWN-GAPS.md
│   └── TEMPLATES/
│       ├── _generate_screens.py   # entry point + registry + tulisan index/peta
│       ├── _extract.py            # ekstraksi fakta dari Flutter/Laravel/DB
│       ├── _render_detailed.py    # renderer PRD 22 bagian + SKILL 13 bagian
│       ├── _registry_1.py
│       ├── _registry_2.py
│       ├── _registry_3.py
│       ├── _catalog.py
│       ├── _endpoint_meta.json
│       └── _tables.json
└── screens/<fitur>/<layar>.md

.skills/
├── shared/...
└── screens/<fitur>/<layar>/SKILL.md
```

## 1.1 Pipeline generator

```text
Registry (_registry_*.py)
   + _catalog.py / _endpoint_meta.json / _tables.json
        ↓
_extract.py  → fakta kode: kelas, state, provider, model, endpoint,
               route, form, flag, tabel, validasi controller Laravel
        ↓
_render_detailed.py → PRD (23 bagian, 0–22) + SKILL (15 bagian, 0–14)
        ↓
_generate_screens.py → menulis 78 + 78 file, SCREEN-INDEX, API-ENDPOINT-MAP
```

- **PRD** memuat ringkasan eksekutif, konteks, navigasi, alur + Mermaid, arsitektur, blueprint UI, design system, state machine, kontrak API per endpoint (field validasi + response + pesan error), database, aturan bisnis, error/security/a11y/perf, analytics [Usulan], acceptance, test plan, gap, peta simbol.
- **SKILL** memuat prompt siap pakai, prasyarat, sumber kebenaran, peta file, spesifikasi, Fase 0–5, kontrak API, state minimum, guardrail, Definition of Done, verifikasi, jebakan, handoff.
- Jangan mengedit hasil generate manual. Perbaiki registry atau ekstraktor, lalu regenerasi.

## 2. Menambah layar

1. Buat file `*Screen.dart` di `lib/Features/<Fitur>/Presentation/Screens/...`.
2. Daftarkan route di `AppRouter` bila layar dapat dijangkau.
3. Tambahkan entri ke salah satu `_registry_*.py`:

```python
s("catalog", "catalog-detail", "CatalogDetailScreen", "Detail Katalog",
  "/catalog/:id", "Guest + Sanctum", "Tujuan layar...",
  "Dari ...", ["Langkah 1", "Langkah 2"], ["catalogDetail"],
  ["Elemen UI"], ["loading", "error"], ["Acceptance"], gaps=["..."])
```

4. Jalankan generator:

```powershell
python .docs/06-reference/TEMPLATES/_generate_screens.py
```

5. Pastikan jumlah tetap 78 (atau perbarui angka di dokumentasi bila layar memang bertambah).

## 3. Mengubah kontrak

Jika endpoint/tabel berubah:

1. Perbarui `_catalog.py` (`API_NOTES`) atau `_endpoint_meta.json`.
2. Perbarui registry layar terkait.
3. Regenerasi.
4. Perbarui `.docs/03-api/REST-API.md` dan `.docs/06-reference/API-ENDPOINT-MAP.md` bila perlu.
5. Perbarui `.docs/04-database/DATABASE.md` bila skema berubah.
6. Catat gap baru di `KNOWN-GAPS.md`.

## 4. Gaya penulisan

- Bahasa Indonesia, ringkas, berbasis fakta.
- Sebut path/route/endpoint persis.
- Jangan menulis "seharusnya" tanpa menandai sebagai rekomendasi (`[Usulan]`).
- Bedakan **kontrak aktual** dan **target**.
- Gunakan tabel untuk API dan database.
- Acceptance criteria harus dapat diuji.
- Setiap PRD minimal mencakup: definisi sukses, guard, state machine, kontrak API, tabel, aturan bisnis, error, security, a11y, acceptance, test plan, dan gap.
- Setiap SKILL minimal mencakup: prompt siap pakai, prasyarat, file map, Fase 0–5, Definition of Done, dan perintah verifikasi.

## 5. Validasi

```powershell
# Jumlah file
(Get-ChildItem .docs\screens -Recurse -Filter *.md).Count   # 78
(Get-ChildItem .skills\screens -Recurse -Filter SKILL.md).Count # 78

# Placeholder yang tidak boleh tersisa
Select-String -Path .docs\screens\*\*.md -Pattern "<Judul|<fitur>|TODO|TBD"

# Field yang gagal diinferensi
Select-String -Path .docs\screens\*\*.md -Pattern "`inferred`"

# Link relatif rusak (jalankan dari root mobile_app)
python - <<'PY'
import re, pathlib
for base in [pathlib.Path('.docs/screens'), pathlib.Path('.skills/screens')]:
    for p in base.rglob('*.md'):
        for m in re.finditer(r'\]\(([^)#]+)', p.read_text(encoding='utf-8')):
            link = m.group(1).strip()
            if not link.startswith(('http://','https://','mailto:')) and not (p.parent/link).resolve().exists():
                print('BROKEN', p, '->', link)
PY
```

Pastikan link relatif benar:

- Dari `.docs/screens/<fitur>/` ke `.docs/03-api/` = `../../03-api/`.
- Ke `.skills/` = `../../../.skills/`.
- Dari `.skills/screens/<fitur>/<layar>/` ke `.docs/` = `../../../../.docs/`.

## 6. Checklist

- [ ] Semua `*Screen.dart` punya PRD dan skill.
- [ ] Route/akses/parameter benar.
- [ ] Endpoint cocok dengan route list dan controller.
- [ ] Field request di PRD cocok dengan `validate()`/FormRequest.
- [ ] Tabel dan kolom cocok dengan `\d+`.
- [ ] Gap dicatat, bukan disembunyikan.
- [ ] Link relatif valid.
- [ ] Tidak ada placeholder/`inferred` yang tersisa.
- [ ] Generator dijalankan ulang (`OK: 78 PRD + 78 SKILL`).
