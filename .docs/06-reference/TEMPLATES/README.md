# Templates & Generator

Folder ini menyimpan sumber yang dapat diregenerasi untuk seluruh PRD dan skill layar.

| File | Fungsi |
|---|---|
| `_generate_screens.py` | Generator utama; menulis 78 PRD + 78 `SKILL.md` + indeks + peta endpoint. |
| `_registry_1.py` | Registry layar Auth, Cart, Catalog, CBIR, Chat, Favorite, History, Home. |
| `_registry_2.py` | Registry layar Legal, Notification, Onboarding, Order, Payment, Report, Review, Search, Splash, Voucher. |
| `_registry_3.py` | Registry layar Profile (profil, keamanan, scanner, penyimpanan). |
| `_catalog.py` | Nama fitur, ringkasan, dan metadata endpoint/tabel. |
| `_endpoint_meta.json` | Hasil pencocokan 147 konstanta client terhadap route Laravel. |
| `_tables.json` | Kolom 83 tabel PostgreSQL hasil query `information_schema`. |
| `SCREEN-PRD-TEMPLATE.md` | Kerangka PRD layar. |
| `SCREEN-SKILL-TEMPLATE.md` | Kerangka skill layar. |

## Menjalankan

Dari root `mobile_app`:

```powershell
python .docs/06-reference/TEMPLATES/_generate_screens.py
```

Output:

- `.docs/screens/<fitur>/<layar>.md`
- `.skills/screens/<fitur>/<layar>/SKILL.md`
- `.docs/06-reference/SCREEN-INDEX.md`
- `.docs/06-reference/API-ENDPOINT-MAP.md`

## Mengubah data

1. Ubah `_registry_*.py` untuk konten layar.
2. Ubah `_catalog.py` untuk metadata endpoint/tabel.
3. Jika ada endpoint baru, perbarui `_endpoint_meta.json` (atau hasilkan ulang dari `route:list`).
4. Jalankan generator.
5. Periksa link dan jumlah file.

## Aturan

- Registry harus berisi tepat **78** layar dengan slug unik.
- Setiap nama endpoint di registry harus ada di `_endpoint_meta.json`.
- Jangan mengedit file hasil generate secara manual; perubahan akan tertimpa.
- Perubahan kontrak harus disertai pembaruan `REST-API.md`, `DATABASE.md`, dan `KNOWN-GAPS.md` bila relevan.
