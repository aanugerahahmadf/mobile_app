#!/usr/bin/env python3
"""Generator PRD layar dan SKILL layar.

Jalankan dari root repo:

    python .docs/06-reference/TEMPLATES/_generate_screens.py

Sumber kebenaran: kode Flutter di `lib/Features`, route Laravel, dan skema
PostgreSQL yang didokumentasikan di `.docs/04-database`.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
DOCS = ROOT / ".docs"
SKILLS = ROOT / ".skills"
SCREENS_DOC = DOCS / "screens"
SCREENS_SKILL = SKILLS / "screens"

sys.path.insert(0, str(HERE))

from _catalog import API_NOTES, FEATURES  # noqa: E402
from _registry_1 import SCREENS_1  # noqa: E402
from _registry_2 import SCREENS_2  # noqa: E402
from _registry_3 import SCREENS_3  # noqa: E402
from _render_detailed import (  # noqa: E402
    render_prd_detailed,
    render_skill_detailed,
)

import json  # noqa: E402

SCREENS = SCREENS_1 + SCREENS_2 + SCREENS_3
FEATURE_ORDER = {key: i for i, key in enumerate(FEATURES)}
SCREENS.sort(key=lambda item: FEATURE_ORDER[item["feature"]])
ENDPOINTS = json.loads((HERE / "_endpoint_meta.json").read_text(encoding="utf-8"))
TABLES = json.loads((HERE / "_tables.json").read_text(encoding="utf-8"))
VERIFIED = "6 November 2026"

TABLE_ROLES = {
    "users": "Akun, profil, KYC, preferensi, dan pengaturan keamanan.",
    "personal_access_tokens": "Token Sanctum perangkat.",
    "password_reset_tokens": "Token reset password.",
    "whatsapp_otps": "Kode OTP dan masa berlaku.",
    "backup_codes": "Kode pemulihan 2FA.",
    "device_tokens": "Token FCM perangkat.",
    "user_sessions": "Sesi login dan perangkat aktif.",
    "sessions": "Sesi Laravel.",
    "trusted_devices": "Perangkat tepercaya.",
    "security_emails": "Riwayat email keamanan.",
    "security_events": "Jejak peristiwa keamanan.",
    "identity_documents": "Dokumen identitas dan hasil verifikasi AI.",
    "user_addresses": "Alamat pengguna.",
    "reference_options": "Opsi dropdown dan referensi umum.",
    "indonesia_provinces": "Master provinsi.",
    "indonesia_cities": "Master kota/kabupaten.",
    "indonesia_districts": "Master kecamatan.",
    "indonesia_villages": "Master desa dan kode pos.",
    "categories": "Kategori katalog.",
    "catalogs": "Item katalog.",
    "packages": "Tier/paket dari katalog.",
    "carts": "Item keranjang.",
    "favorites": "Favorit paket/katalog.",
    "orders": "Pesanan dan statusnya.",
    "order_timelines": "Riwayat status pesanan.",
    "order_payments": "Pembayaran dan bukti bayar.",
    "transactions": "Transaksi pembayaran/dompet.",
    "payment_methods": "Metode pembayaran yang tersedia.",
    "payment_gateways": "Konfigurasi payment gateway.",
    "payment_qris": "Data QRIS per pesanan.",
    "payment_virtual_accounts": "Data virtual account per pesanan.",
    "banks": "Bank dan payload QRIS.",
    "vouchers": "Voucher dan masa berlaku.",
    "discounts": "Diskon yang terkait voucher.",
    "user_vouchers": "Voucher yang diklaim pengguna.",
    "histories": "Mutasi dompet pengguna.",
    "notifications": "Notifikasi in-app.",
    "reviews": "Ulasan katalog/paket.",
    "review_votes": "Vote ulasan.",
    "review_replies": "Balasan ulasan.",
    "review_reports": "Laporan ulasan.",
    "reports": "Laporan konten/pengguna.",
    "fm_inboxes": "Percakapan chat.",
    "fm_messages": "Pesan chat.",
    "chat_calls": "State signaling panggilan WebRTC.",
    "legal_pages": "Halaman legal umum.",
    "privacy_policies": "Kebijakan privasi.",
    "terms_of_service": "Syarat layanan.",
    "wedding_decoration_policies": "Kebijakan dekorasi pernikahan.",
    "helps": "FAQ dan kontak bantuan.",
    "hero_banners": "Banner beranda.",
    "promotions": "Promosi beranda.",
    "search_logs": "Log pencarian teks.",
    "cbir_searches": "Sesi pencarian visual.",
    "cbir_search_results": "Hasil pencarian visual.",
    "cbir_feedback": "Umpan balik hasil visual.",
    "media": "File polymorphic (avatar, dokumen, lampiran).",
}


def find_screen_file(cls: str) -> str | None:
    best = None
    for path in (ROOT / "lib" / "Features").rglob("*.dart"):
        text = path.read_text(encoding="utf-8", errors="ignore")
        if re.search(rf"class\s+{re.escape(cls)}\b", text):
            rel = path.relative_to(ROOT).as_posix()
            if path.stem == cls:
                return rel
            best = best or rel
    return best


def line_count(rel: str | None) -> int:
    if not rel:
        return 0
    return len((ROOT / rel).read_text(encoding="utf-8", errors="ignore").splitlines())


def key_columns(table: str, limit: int = 8) -> str:
    cols = TABLES.get(table, [])
    names = [f"`{c['name']}`" for c in cols[:limit]]
    suffix = " …" if len(cols) > limit else ""
    return ", ".join(names) + suffix


def api_rows(screen: dict) -> list[dict]:
    rows = []
    seen = set()
    for name in screen["api"]:
        meta = ENDPOINTS.get(name)
        if not meta:
            raise SystemExit(f"Endpoint tidak dikenal: {name} ({screen['cls']})")
        purpose = API_NOTES.get(name, (name, [], ""))[0]
        tables = API_NOTES.get(name, (name, [], ""))[1]
        for row in meta["rows"]:
            key = (name, row["method"], row["path"])
            if key in seen:
                continue
            seen.add(key)
            rows.append({
                "name": name,
                "method": row["method"],
                "path": row["path"],
                "controller": row["controller"],
                "auth": row["auth"],
                "purpose": purpose,
                "tables": tables,
                "note": API_NOTES.get(name, ("", [], ""))[2],
            })
    return rows


def screen_tables(screen: dict) -> list[tuple[str, str]]:
    found = []
    for name in screen["api"]:
        for table in API_NOTES.get(name, ("", [], ""))[1]:
            if table not in found:
                found.append(table)
    return [(t, TABLE_ROLES.get(t, "Tabel pendukung layar.")) for t in found]


def related_screens(screen: dict) -> list[dict]:
    """Layar lain dalam fitur yang sama, maksimal 4."""
    same = [x for x in SCREENS if x["feature"] == screen["feature"] and x["cls"] != screen["cls"]]
    return same[:4]


def feature_rel(screen: dict) -> tuple[str, str]:
    feature = FEATURES[screen["feature"]]
    return feature["folder"], f"{feature['folder']}/{screen['slug']}.md"


def safe(text: str) -> str:
    return text.replace("|", "\\|")


def render_prd(screen: dict, file: str | None, lines: int) -> str:
    feature = FEATURES[screen["feature"]]
    rows = api_rows(screen)
    tables = screen_tables(screen)
    route = screen["route"]
    route_badge = f"`{route}`" if route and route != "-" else "**tidak terdaftar**"
    out = []
    out.append(f"# {screen['title']}\n")
    out.append(
        f"> **Fitur:** {feature['name']} · **Route:** {route_badge} · "
        f"**Akses:** {screen['auth']} · **File:** `{file or '-'}` ({lines} baris)\n"
    )
    out.append(f"> Diverifikasi {VERIFIED} dari kode Flutter, route Laravel, dan skema PostgreSQL.\n")
    out.append("## 1. Ringkasan\n")
    out.append(screen["purpose"] + "\n")
    out.append("## 2. Konteks & Navigasi\n")
    out.append(f"- **Masuk dari:** {screen['entry']}")
    out.append(f"- **Route:** {route_badge}")
    if screen.get("route_note"):
        out.append(f"- **Parameter/extra:** {screen['route_note']}")
    out.append(f"- **Akses:** {screen['auth']}")
    out.append(f"- **File implementasi:** `{file or '-'}`")
    if lines:
        out.append(f"- **Ukuran:** {lines} baris")
    if screen.get("notes"):
        out.append(f"- **Catatan implementasi:** {screen['notes']}")
    out.append("")
    out.append("## 3. Alur Pengguna\n")
    for i, step in enumerate(screen["flow"], 1):
        out.append(f"{i}. {step}")
    out.append("")
    out.append("## 4. UI & State\n")
    out.append("### 4.1 Elemen utama\n")
    for item in screen["ui"]:
        out.append(f"- {item}")
    out.append("")
    out.append("### 4.2 State yang wajib ditangani\n")
    out.append("| State | Perilaku UI |")
    out.append("|---|---|")
    state_behavior = [
        ("stok", "Tampilkan badge stok habis dan nonaktifkan aksi beli."),
        ("tidak ditemukan", "Tampilkan halaman not found dengan tombol kembali."),
        ("loading", "Skeleton/progress, blokir aksi ganda."),
        ("kosong", "Empty state dengan penjelasan dan aksi lanjutan."),
        ("error", "Pesan ramah, tombol coba lagi, pertahankan data lama bila ada."),
        ("guest", "Tampilkan `GuestAuthPrompt`, jangan panggil endpoint privat."),
        ("offline", "Tampilkan status offline dan opsi coba lagi."),
        ("habis", "Tampilkan penanda akhir daftar atau status kedaluwarsa."),
        ("kedaluwarsa", "Tampilkan status kedaluwarsa dan aksi muat ulang."),
        ("izin", "Tampilkan penjelasan izin dan tombol buka pengaturan."),
    ]
    for state in screen["states"]:
        key = next((k for k, _ in state_behavior if k in state.lower()), None)
        behavior = dict(state_behavior).get(key, "Tampilkan status yang jelas dan aksi pemulihan.")
        out.append(f"| `{safe(state)}` | {behavior} |")
    out.append("")
    out.append("## 5. Kontrak API\n")
    if rows:
        out.append("| # | Method | Path | Controller | Auth | Kegunaan |")
        out.append("|---|---|---|---|---|---|")
        for i, row in enumerate(rows, 1):
            out.append(
                f"| {i} | `{row['method']}` | `{row['path']}` | `{row['controller']}` | "
                f"{row['auth']} | {safe(row['purpose'])} |"
            )
        out.append("")
        out.append("**Catatan kontrak:**\n")
        notes = []
        for row in rows:
            if row["note"] and row["note"] not in notes:
                notes.append(row["note"])
        if notes:
            for note in notes:
                out.append(f"- {note}")
        else:
            out.append("- Tidak ada catatan khusus; ikuti envelope dan error mapping di `.docs/03-api/REST-API.md`.")
        out.append("")
        out.append("**Envelope acuan** (periksa controller untuk variasi):\n")
        out.append("```json")
        out.append('{"status":"success","message":"...","data":{}}')
        out.append("```")
        out.append("")
    else:
        out.append("Layar ini **tidak memanggil API jaringan**. Semua state disimpan di perangkat ")
        out.append("(`SharedPreferences`/`FlutterSecureStorage`) atau diterima lewat `extra`/provider.\n")
    out.append("## 6. Pemetaan Database\n")
    if tables:
        out.append("| Tabel | Peran | Kolom kunci |")
        out.append("|---|---|---|")
        for table, role in tables:
            out.append(f"| `{table}` | {safe(role)} | {key_columns(table)} |")
        out.append("")
        out.append("Relasi dan constraint lengkap ada di `.docs/04-database/DATABASE.md` dan `.docs/04-database/ERD.md`.")
    else:
        out.append("Tidak ada tabel PostgreSQL yang dibaca/ditulis langsung oleh layar ini.")
    out.append("")
    out.append("## 7. Aturan & Validasi\n")
    for rule in screen["accept"]:
        out.append(f"- {rule}")
    out.append("- Jangan menampilkan data dari cache setelah logout.")
    out.append("- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.")
    out.append("- Gunakan `DioClient`/repository yang sudah ada; jangan membuat instance Dio baru.")
    out.append("")
    out.append("## 8. Edge Cases & Risiko\n")
    if screen["gaps"]:
        for gap in screen["gaps"]:
            out.append(f"- {gap}")
    else:
        out.append("- Tidak ada gap khusus yang terdokumentasi. Tetap uji jaringan lambat, data kosong, dan sesi kedaluwarsa.")
    out.append("- Sesi kedaluwarsa (401) harus membersihkan token dan mengarahkan ke Landing.")
    out.append("- Respons 403/404 tidak boleh ditampilkan sebagai crash.")
    out.append("")
    out.append("## 9. Acceptance Criteria\n")
    for item in screen["accept"]:
        out.append(f"- [ ] {item}")
    out.append(f"- [ ] Jalur masuk berfungsi: {screen['entry']}")
    out.append("- [ ] Tidak ada overflow pada lebar 320 px dan orientasi landscape.")
    out.append("- [ ] Semua aksi mengikuti state loading/error dan tidak dapat ditekan ganda.")
    out.append("")
    out.append("## 10. Test Cases\n")
    out.append("| ID | Skenario | Langkah | Hasil yang diharapkan |")
    out.append("|---|---|---|---|")
    out.append(f"| TC-01 | Happy path | Buka layar melalui jalur masuk | Elemen utama tampil tanpa error |")
    out.append(f"| TC-02 | Aksi utama | {safe(screen['flow'][-1])} | Data tersimpan/berpindah sesuai alur |")
    out.append(f"| TC-03 | Error | Matikan jaringan lalu ulangi aksi | Pesan error dan tombol coba lagi muncul |")
    out.append("| TC-04 | Sesi habis | Gunakan token kedaluwarsa | Diarahkan ke Landing, token dibersihkan |")
    out.append("")
    out.append("## 11. Gap & Tindak Lanjut\n")
    if screen["gaps"]:
        for gap in screen["gaps"]:
            out.append(f"- {gap}")
    else:
        out.append("- Tidak ada gap khusus untuk layar ini.")
    out.append("- Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).")
    out.append("")
    out.append("## 12. Referensi\n")
    out.append("- [REST API](../../03-api/REST-API.md)")
    out.append("- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)")
    out.append("- [Database](../../04-database/DATABASE.md)")
    out.append("- [Arsitektur](../../02-architecture/ARCHITECTURE.md)")
    out.append(f"- [Skill layar](../../../.skills/screens/{feature['folder']}/{screen['slug']}/SKILL.md)")
    out.append("")
    return "\n".join(out)


def render_skill(screen: dict, file: str | None) -> str:
    feature = FEATURES[screen["feature"]]
    rows = api_rows(screen)
    tables = screen_tables(screen)
    out = []
    folder = feature["folder"]
    if screen["slug"] == folder:
        skill_name = folder
    elif screen["slug"].startswith(folder + "-"):
        skill_name = screen["slug"]
    else:
        skill_name = f"{folder}-{screen['slug']}"
    out.append("---")
    out.append(f"name: {skill_name}")
    out.append(
        f"description: Implementasi layar {screen['title']} ({screen['cls']}) pada fitur "
        f"{feature['name']}; mencakup route, API, database, state, dan acceptance criteria."
    )
    out.append("---\n")
    out.append(f"# Skill: {screen['title']}\n")
    out.append(f"**File:** `{file or '-'}` · **Route:** {('`' + screen['route'] + '`') if screen['route'] != '-' else 'tidak terdaftar'} · **Akses:** {screen['auth']}\n")
    out.append("## Kapan dipakai\n")
    out.append(f"Gunakan skill ini saat mengubah, menguji, atau mendokumentasikan `{screen['cls']}`.\n")
    out.append(f"Tujuan layar: {screen['purpose']}\n")
    out.append("## Langkah implementasi\n")
    out.append(f"1. Baca PRD: `.docs/screens/{feature['folder']}/{screen['slug']}.md`.")
    out.append(f"2. Buka file `{file or '-'}` dan provider/repository yang dipakai.")
    out.append("3. Verifikasi route dan parameter:")
    out.append(f"   - {screen['route_note'] or 'Tidak ada parameter khusus.'}")
    out.append("4. Implementasikan state UI:")
    for state in screen["states"]:
        out.append(f"   - `{state}`")
    out.append("5. Sambungkan API melalui repository/DioClient, bukan panggilan langsung dari widget.")
    out.append("6. Tangani 401/403/404/422/5xx sesuai `.docs/02-architecture/STATE-AND-ERRORS.md`.")
    out.append("7. Tambahkan test widget/unit untuk happy path dan minimal satu error path.\n")
    out.append("## Kontrak API\n")
    if rows:
        out.append("| Method | Path | Controller | Auth | Kegunaan |")
        out.append("|---|---|---|---|---|")
        for row in rows:
            out.append(
                f"| `{row['method']}` | `{row['path']}` | `{row['controller']}` | "
                f"{row['auth']} | {safe(row['purpose'])} |"
            )
        out.append("")
    else:
        out.append("Tidak ada API jaringan. Gunakan penyimpanan lokal atau data `extra`.\n")
    out.append("## Tabel database\n")
    if tables:
        out.append("| Tabel | Kolom kunci |")
        out.append("|---|---|")
        for table, _ in tables:
            out.append(f"| `{table}` | {key_columns(table, 6)} |")
        out.append("")
    else:
        out.append("Tidak ada tabel yang dipakai langsung.\n")
    out.append("## Checklist\n")
    for item in screen["accept"]:
        out.append(f"- [ ] {item}")
    out.append("- [ ] Route/parameter sesuai `AppRouter`.")
    out.append("- [ ] Tidak ada pemanggilan API langsung dari `build()`.")
    out.append("- [ ] Loading/empty/error/unauthorized tertangani.")
    out.append("- [ ] Tidak ada overflow di layar kecil.")
    out.append("")
    out.append("## Jebakan\n")
    if screen["gaps"]:
        for gap in screen["gaps"]:
            out.append(f"- {gap}")
    else:
        out.append("- Tidak ada jebakan khusus; tetap hormati kontrak backend.")
    out.append("- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.")
    out.append("")
    out.append("## Verifikasi\n")
    out.append("```powershell")
    out.append("# dari root mobile_app")
    out.append(f"rg \"{screen['cls']}\" lib")
    out.append("# dari root backend")
    out.append("php artisan route:list --path=api | Select-String \"" + (rows[0]["path"].split("{")[0] if rows else "legal") + "\"")
    out.append("```")
    out.append("")
    out.append("Perbarui dokumen ini bila route, kontrak API, atau tabel berubah.")
    out.append("")
    return "\n".join(out)


def write_screen_index() -> None:
    out = []
    out.append("# Indeks Layar\n")
    out.append(f"Total **{len(SCREENS)} layar** dari 19 fitur, diverifikasi {VERIFIED}.\n")
    out.append("Setiap layar memiliki PRD di `.docs/screens/` dan skill di `.skills/screens/`.\n")
    out.append("## Ringkasan per fitur\n")
    out.append("| Fitur | Jumlah layar | Folder |")
    out.append("|---|---|---|")
    for key, feature in FEATURES.items():
        count = sum(1 for s in SCREENS if s["feature"] == key)
        out.append(f"| {feature['name']} | {count} | [`screens/{feature['folder']}/`](../screens/{feature['folder']}/) |")
    out.append("")
    out.append("## Daftar layar\n")
    out.append("| # | Fitur | Layar | Route | Akses | API | PRD | Skill |")
    out.append("|---|---|---|---|---|---|---|---|")
    for i, screen in enumerate(SCREENS, 1):
        feature = FEATURES[screen["feature"]]
        route = f"`{screen['route']}`" if screen["route"] != "-" else "—"
        endpoint_count = len(api_rows(screen))
        out.append(
            f"| {i} | {feature['name']} | `{screen['cls']}` | {route} | {screen['auth']} | "
            f"{endpoint_count} | [{screen['slug']}.md](../screens/{feature['folder']}/{screen['slug']}.md) | "
            f"[SKILL.md](../../.skills/screens/{feature['folder']}/{screen['slug']}/SKILL.md) |"
        )
    out.append("")
    out.append("## Layar tanpa route\n")
    local_only = {
        "BiometricUnlockScreen", "PasswordUnlockScreen", "PinUnlockScreen",
        "StorageUsageSettingsScreen", "NetworkUsageSettingsScreen",
        "DownloadQualityScreen", "UploadQualityScreen", "AutoDownloadScreen",
        "AudioAutoDownloadScreen", "DocumentAutoDownloadScreen",
        "PhotoAutoDownloadScreen", "VideoAutoDownloadScreen", "ProxySettingsScreen",
    }
    out.append("### Subview lokal / tidak memerlukan route\n")
    for screen in SCREENS:
        if screen["route"] == "-" and screen["cls"] in local_only:
            out.append(f"- `{screen['cls']}` — {screen['title']}")
    out.append("")
    out.append("### Belum terhubung ke `AppRouter` (gap)\n")
    for screen in SCREENS:
        if screen["route"] == "-" and screen["cls"] not in local_only:
            out.append(f"- `{screen['cls']}` — {screen['title']}")
    out.append("")
    out.append("## Route ganda\n")
    out.append("- `/favorite` dan `/Favorite` sama-sama menuju `Favoritescreen`.")
    out.append("- `/notification/:id` menampilkan `NotificationDetailScreen` hanya bila `extra` adalah `NotificationModel`.")
    out.append("")
    out.append("## Cara memakai\n")
    out.append("1. Pilih layar dari tabel.")
    out.append("2. Baca PRD untuk konteks, API, dan acceptance criteria.")
    out.append("3. Baca `SKILL.md` untuk langkah implementasi.")
    out.append("4. Verifikasi endpoint di `php artisan route:list` sebelum menulis kode.")
    out.append("")
    (DOCS / "06-reference" / "SCREEN-INDEX.md").write_text("\n".join(out), encoding="utf-8")


def write_api_map() -> None:
    groups = [
        ("Auth & akun", ("login", "register", "logout", "forgotPassword", "resetPassword", "sendOtp", "verifyOtp", "twoFactor", "google", "facebook", "apple", "clerk", "user", "deleteAccount", "profile", "changePassword", "dashboard", "appLock")),
        ("Katalog & beranda", ("home", "categories", "catalog", "cart", "favorite")),
        ("Pesanan & pembayaran", ("bookings", "booking", "order", "invoice", "voucher", "wallet")),
        ("Chat & panggilan", ("conversations", "message", "guestChat", "chatCall", "unread")),
        ("Ulasan & laporan", ("reviews", "review", "myReviews", "userReviews", "catalogReview", "reports", "reportPdf")),
        ("Pencarian", ("search", "cbir")),
        ("Notifikasi", ("notification", "registerFcm")),
        ("Legal", ("legal",)),
        ("Keamanan", ("security",)),
        ("Wilayah & referensi", ("region", "world", "geo", "dropdown")),
        ("Profil dinamis", ("profileKtp", "profileSelfie", "profileFace", "profileCompletion", "profileAvatar", "profileDocument")),
    ]
    assigned = set()
    out = []
    out.append("# Peta Endpoint API → Backend → Database\n")
    out.append(f"Dibuat dari 147 konstanta `ApiEndpoints` dan route Laravel, diverifikasi {VERIFIED}.\n")
    out.append("Base URL sudah berakhiran `/api`. Path di tabel adalah path setelah base URL.\n")
    out.append("## Ringkasan\n")
    out.append("| Status | Jumlah |")
    out.append("|---|---|")
    out.append(f"| Konstanta client | {len(ENDPOINTS)} |")
    matched = sum(1 for v in ENDPOINTS.values() if v["rows"][0]["controller"] != "-")
    out.append(f"| Cocok dengan route backend | {matched} |")
    out.append(f"| Tidak cocok | {len(ENDPOINTS) - matched} |")
    out.append("| Route backend user-api | 207 (non-admin) |")
    out.append("")
    out.append("> Kecocokan dihitung berdasarkan method + path. Perbedaan nama parameter path ")
    out.append("> (`{id}` vs `{report}`) tidak dianggap mismatch selama posisi segmen sama.\n")
    for title, prefixes in groups:
        names = []
        for name in ENDPOINTS:
            if name in assigned:
                continue
            if any(name.startswith(p) for p in prefixes):
                names.append(name)
                assigned.add(name)
        if not names:
            continue
        out.append(f"## {title}\n")
        out.append("| Konstanta | Method | Path | Controller | Auth | Tabel |")
        out.append("|---|---|---|---|---|---|")
        for name in sorted(names):
            meta = ENDPOINTS[name]
            purpose_tables = API_NOTES.get(name, ("", [], ""))[1]
            tables = ", ".join(f"`{t}`" for t in purpose_tables) or "—"
            for row in meta["rows"]:
                out.append(
                    f"| `{name}` | `{row['method']}` | `{row['path']}` | `{row['controller']}` | "
                    f"{row['auth']} | {tables} |"
                )
        out.append("")
    rest = [n for n in ENDPOINTS if n not in assigned]
    if rest:
        out.append("## Lainnya\n")
        out.append("| Konstanta | Method | Path | Controller | Auth |")
        out.append("|---|---|---|---|---|")
        for name in sorted(rest):
            for row in ENDPOINTS[name]["rows"]:
                out.append(f"| `{name}` | `{row['method']}` | `{row['path']}` | `{row['controller']}` | {row['auth']} |")
        out.append("")
    out.append("## Endpoint client tanpa route backend\n")
    out.append("| Konstanta | Path client | Catatan |")
    out.append("|---|---|---|")
    for name, meta in ENDPOINTS.items():
        if meta["rows"][0]["controller"] == "-":
            out.append(f"| `{name}` | `{meta['client_path']}` | {API_NOTES.get(name, ('', [], 'Belum ada route.'))[2] or 'Belum ada route.'} |")
    out.append("")
    out.append("## Perbedaan casing\n")
    out.append("| Client | Backend | Dampak |")
    out.append("|---|---|---|")
    for name, meta in ENDPOINTS.items():
        for row in meta["rows"]:
            if row["method"] != "ANY" and row["path"].lower() == meta["client_path"].lower() and row["path"] != meta["client_path"]:
                out.append(f"| `{meta['client_path']}` | `{row['path']}` | Case-sensitive di Linux |")
    out.append("")
    out.append("## Cara memperbarui\n")
    out.append("1. Tambahkan/ubah konstanta di `lib/Core/Api/ApiEndpoints/ApiEndpoints.dart`.")
    out.append("2. Tambahkan route di `routes/api/user/...` dan verifikasi dengan `php artisan route:list`.")
    out.append("3. Perbarui tabel ini dan PRD layar terkait.")
    out.append("4. Jalankan ulang generator: `python .docs/06-reference/TEMPLATES/_generate_screens.py`.")
    out.append("")
    (DOCS / "06-reference" / "API-ENDPOINT-MAP.md").write_text("\n".join(out), encoding="utf-8")


def write_templates() -> None:
    prd = """# <Judul Layar>

> Template ringkas untuk penulisan manual. PRD hasil generator memakai 23 bagian (0–22) dan menambahkan Copywriting, Inventaris Komponen, serta Handoff. Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku terverifikasi.

> **Fitur:** <fitur> · **Route:** `<path>` · **Akses:** <Guest/Sanctum/lokal> · **File:** `<lib/Features/.../XScreen.dart>` · **State:** <Riverpod/state lokal>

## 1. Ringkasan Eksekutif

| Aspek | Nilai |
|---|---|
| Tujuan | <satu kalimat: masalah pengguna yang diselesaikan> |
| Definisi sukses | <hasil yang terlihat pengguna> |
| Aktor | <Guest / user login / admin> |
| Titik masuk | <dari layar mana, notifikasi, deep link> |
| Keluar | <navigasi setelah aksi utama> |

## 2. Konteks

- **Persona:** <siapa dan kebutuhannya>
- **In scope:** <hal yang dikerjakan layar ini>
- **Out of scope:** <hal yang bukan tanggung jawab layar ini>
- **Dependensi produk:** <fitur lain yang harus selesai lebih dulu>

## 3. Navigasi & Entry

| Item | Nilai |
|---|---|
| Route | `<path>` |
| Parameter path | `<nama>` |
| Query/extra | `<key>` |
| Guard | <Guest/Sanctum/redirect> |
| Masuk dari | <daftar sumber> |
| Back behavior | <kembali ke mana; apa yang dipertahankan> |

## 4. Alur Pengguna

1. <langkah 1>
2. <langkah 2>
3. <langkah 3>

```mermaid
flowchart TD
  A["Masuk"] --> B["Muat data"]
  B -->|sukses| C["Konten"]
  B -->|gagal| D["Error + retry"]
  C --> E["Aksi utama"]
  E --> F["Selesai / navigasi"]
```

## 5. Arsitektur Layar

| Aspek | Nilai |
|---|---|
| Kelas | `XScreen` / `_XScreenState` |
| State management | <Riverpod + setState / ConsumerWidget> |
| Pola data | <sekali muat / polling / realtime> |
| Provider | `<provider>` |
| Repository | `<repository>` |
| Widget inti | `<AppBar/...>` |

### 5.1 State lokal

| Field | Tipe | Peran | Dispose |
|---|---|---|---|
| `_loading` | `bool` | Menandai proses muat | — |
| `_controller` | `TextEditingController` | Input | Ya |

### 5.2 Alur data

```text
Widget → Provider → Repository → DioClient → Controller Laravel → PostgreSQL
```

## 6. Blueprint UI

```text
┌──────────────────────────────┐
│ AppBar / judul               │
├──────────────────────────────┤
│ 1. <elemen>                  │
│ 2. <elemen>                  │
│ 3. <elemen>                  │
└──────────────────────────────┘
```

**Komponen:** `<WidgetA>`, `<WidgetB>`.

## 7. Design System

| Token | Nilai/Pemakaian |
|---|---|
| `AppColors.primary` | `#1E3A5F` |
| `AppColors.accent` | `#C9A94E` |
| Radius kartu/tombol | 16 / 14 |
| Spacing | 4/8/16/24/32 |
| Tipografi | Instrument Sans, `AppTextStyles` |

- Wajib aman di 320 px, landscape, text scale 200%, mode terang/gelap.
- Jangan hardcode warna, ukuran, atau string UI.

## 8. State Machine

| State | Pemicu | UI | Pemulihan |
|---|---|---|---|
| `initial` | Layar dibuka | Placeholder | Muat data |
| `loading` | Request berjalan | Skeleton; CTA disabled | Tunggu/retry |
| `content` | Data tersedia | Konten utama | — |
| `empty` | Data kosong | Empty state + CTA | Refresh |
| `error` | Request gagal | Pesan + retry | Retry |
| `unauthorized` | 401 | Arahkan login | Login ulang |
| `offline` | Koneksi putus | Banner offline | Coba saat online |
| `submitting` | Aksi utama | Tombol disabled + progress | Selesai/error |

## 9. Kontrak API

| # | Method | Path | Controller | Auth | Kegunaan |
|---|---|---|---|---|---|
| 1 | `<GET>` | `</api/...>` | `XController@method` | Sanctum | <kegunaan> |

### 9.1 Request/response per endpoint

- **Path params:** `<nama>` — <validasi backend>
- **Body:** `<field>` (`required|string|max:255`) — <arti>
- **Response sukses:** `{"status":"success","message":"...","data":{...}}`
- **Error terbaca:** 401/403/404/422/5xx — <pesan dan perilaku UI>

> Jangan mengarang endpoint/kolom. Cocokkan dengan `routes/api.php` dan controller.

## 10. Data & Database

| Tabel | Peran | Kolom kunci |
|---|---|---|
| `<table>` | <peran> | `id`, `<fk>`, `created_at` |

- Semua nominal/stok/status dari backend.
- Tidak ada query database langsung dari Flutter.

## 11. Aturan Bisnis & Validasi

- <aturan 1>
- <aturan 2>
- Disable submit selama request; satu tap = satu request.
- Guest hanya memakai alur guest yang didukung backend.

## 12. Error Handling

| HTTP | Failure | Perilaku UI |
|---|---|---|
| 401 | `AuthFailure` | Hapus token, arahkan login |
| 403 | Izin | Pesan akses ditolak, tanpa logout |
| 404 | `NotFoundFailure` | Resource tidak ditemukan |
| 422 | `ValidationFailure` | Error per field, input dipertahankan |
| 500 | `ServerFailure` | Pesan server + retry |
| null | `NetworkFailure` | Periksa koneksi + retry |

## 13. Security & Privacy

- Token hanya di `FlutterSecureStorage`; jangan di log/SharedPreferences.
- Jangan menampilkan stack trace, query, atau detail internal.
- Jangan mengirim PII ke analytics/crash report.
- Guest tidak mengirim Bearer token kosong.

## 14. Accessibility

- Label semantik untuk semua ikon/kontrol non-teks.
- Target sentuh ≥48×48 dp; kontras WCAG AA.
- Text scale 200% tidak memotong label utama.
- Error form diumumkan dan terhubung ke field.

## 15. Performance & Offline

- Jangan memuat seluruh data sekaligus; gunakan pagination/cursor.
- Dispose controller/timer/subscription di `dispose`.
- Hentikan polling saat background, lanjutkan saat resume.
- Gunakan cache gambar yang sudah ada.

## 16. Analytics [Usulan]

| Event | Pemicu | Properti | PII |
|---|---|---|---|
| `screen_view_<slug>` | Layar dibuka | screen, route, auth | Tidak |
| `<slug>_cta_tap` | Aksi utama | cta, state | Tidak |
| `<slug>_failure` | Aksi gagal | error_code, status | Tidak |

## 17. Acceptance Criteria

- [ ] <kriteria fungsional 1>
- [ ] <kriteria fungsional 2>
- [ ] Loading/empty/error/offline/unauthorized tertangani.
- [ ] 401 membersihkan token dan mengarahkan login.
- [ ] 422 menampilkan error per field dan mempertahankan input.
- [ ] Tidak ada overflow di 320 px/landscape/text scale 200%.
- [ ] `flutter analyze` bersih dan test happy path + satu error path lulus.

## 18. Test Plan

| ID | Jenis | Skenario | Hasil yang diharapkan |
|---|---|---|---|
| TC-01 | Widget | Happy path | Konten tampil, tidak ada error |
| TC-02 | Manual | Loading lambat | Skeleton; CTA disabled |
| TC-03 | Manual | Empty | Empty state + CTA |
| TC-04 | Manual | 500 | Pesan + retry, tidak crash |
| TC-05 | Manual | 401 | Token dibersihkan, redirect login |
| TC-06 | Manual | 403 | Pesan akses ditolak |
| TC-07 | Manual | Offline | Pesan offline + retry |
| TC-08 | Widget | Double submit | Hanya satu request |
| TC-09 | Manual | 320 px/landscape | Tidak overflow |
| TC-10 | Manual | Dark mode + text scale 200% | Tetap terbaca |

## 19. Gap, Risiko & Dependensi

| Jenis | Item | Catatan |
|---|---|---|
| Gap | <gap> | <dampak> |
| Risiko | <risiko> | <mitigasi> |
| Dependensi | `<endpoint>` | `<controller>` |

## 20. Peta Implementasi & Simbol

| Layer | File/Simbol |
|---|---|
| Screen | `<path.dart>` · `XScreen` |
| Provider | `<provider>` |
| Repository | `<repository>` |
| Test | `test/Features/<Fitur>/` |
| Dokumen | `.docs/screens/<fitur>/<slug>.md` |
| Skill | `.skills/screens/<fitur>/<slug>/SKILL.md` |

## 21. Referensi & Riwayat

- [Navigasi](../../02-architecture/NAVIGATION.md)
- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)
- [REST API](../../03-api/REST-API.md)
- [Database](../../04-database/DATABASE.md)
- [Known Gaps](../../06-reference/KNOWN-GAPS.md)

| Tanggal | Perubahan | Sumber |
|---|---|---|
| <tanggal> | <perubahan> | <kode/route/skema> |
"""
    skill = """---
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
"""
    (HERE / "SCREEN-PRD-TEMPLATE.md").write_text(prd, encoding="utf-8")
    (HERE / "SCREEN-SKILL-TEMPLATE.md").write_text(skill, encoding="utf-8")


def main() -> None:
    if len(SCREENS) != 78:
        raise SystemExit(f"Registry harus berisi 78 layar, ditemukan {len(SCREENS)}")
    slugs = [(s["feature"], s["slug"]) for s in SCREENS]
    if len(set(slugs)) != len(slugs):
        raise SystemExit("Ada slug duplikat")
    classes = [s["cls"] for s in SCREENS]
    if len(set(classes)) != len(classes):
        raise SystemExit("Ada class duplikat")

    missing_files = []
    for screen in SCREENS:
        file = find_screen_file(screen["cls"])
        if not file:
            missing_files.append(screen["cls"])
            continue
        feature = FEATURES[screen["feature"]]
        rows = api_rows(screen)
        tables = screen_tables(screen)
        related = related_screens(screen)
        prd_path = SCREENS_DOC / feature["folder"] / f"{screen['slug']}.md"
        prd_path.parent.mkdir(parents=True, exist_ok=True)
        prd_path.write_text(
            render_prd_detailed(
                screen, feature, file, line_count(file), rows, tables, related
            ),
            encoding="utf-8",
        )
        skill_path = SCREENS_SKILL / feature["folder"] / screen["slug"] / "SKILL.md"
        skill_path.parent.mkdir(parents=True, exist_ok=True)
        skill_path.write_text(
            render_skill_detailed(screen, feature, file, rows, tables),
            encoding="utf-8",
        )

    if missing_files:
        raise SystemExit(f"File layar tidak ditemukan: {', '.join(missing_files)}")

    write_screen_index()
    write_api_map()
    write_templates()
    print(f"OK: {len(SCREENS)} PRD + {len(SCREENS)} SKILL")
    print(f"PRD   : {SCREENS_DOC}")
    print(f"SKILL : {SCREENS_SKILL}")


if __name__ == "__main__":
    main()
