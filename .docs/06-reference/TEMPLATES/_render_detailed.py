#!/usr/bin/env python3
"""Renderer PRD dan SKILL layar versi detail.

Semua fakta diambil dari registry layar, generator endpoint/tabel, implementasi aplikasi saat ini,
dan controller Laravel. Bagian yang bersifat rekomendasi diberi tanda [Usulan].
"""
from __future__ import annotations

import textwrap

from _extract import (
    ROOT,
    extract_backend,
    extract_screen,
    find_provider_file,
    screen_type,
    table_columns,
)

VERIFIED = "6 November 2026"
WIDTH = 68

KIND_LABEL = {
    "scanner": "Scanner kamera / media",
    "webview": "WebView",
    "chat": "Chat / real-time",
    "payment": "Pembayaran",
    "order": "Pesanan / checkout",
    "auth": "Autentikasi & keamanan",
    "form": "Formulir",
    "list": "Daftar / koleksi",
    "detail": "Detail resource",
    "content": "Konten / navigasi",
}

HTTP_ROWS = [
    ("401", "`AuthFailure`", "Hapus token, arahkan ke Landing/login, tampilkan sesi berakhir."),
    ("403", "`UnknownFailure` / izin", "Pesan akses ditolak; jangan logout otomatis."),
    ("404", "`NotFoundFailure`", "Tampilkan resource tidak ditemukan + kembali."),
    ("409", "`ConflictFailure` / server", "Tampilkan konflik status (stok, duplikasi, pembayaran)."),
    ("422", "`ValidationFailure(errors)`", "Tampilkan error per field; pertahankan input."),
    ("429", "`UnknownFailure` / rate limit", "Minta pengguna menunggu; jangan spam retry."),
    ("5xx", "`ServerFailure`", "Pesan error server + tombol coba lagi."),
    ("null", "`NetworkFailure`", "Periksa koneksi + retry; pertahankan data lama."),
]

STATE_BEHAVIOR = [
    ("stok", "Tampilkan badge stok habis dan nonaktifkan aksi beli."),
    ("tidak ditemukan", "Tampilkan halaman not found dengan tombol kembali."),
    ("loading", "Skeleton/spinner; blokir aksi ganda."),
    ("kosong", "Empty state dengan penjelasan dan CTA lanjutan."),
    ("error", "Pesan ramah, tombol coba lagi, pertahankan data lama bila ada."),
    ("guest", "Tampilkan prompt autentikasi tamu; jangan panggil endpoint privat."),
    ("offline", "Banner/empty offline dan opsi coba lagi."),
    ("habis", "Tampilkan penanda akhir daftar atau status kedaluwarsa."),
    ("kedaluwarsa", "Tampilkan status kedaluwarsa dan aksi muat ulang."),
    ("izin", "Tampilkan penjelasan izin dan tombol buka pengaturan."),
    ("salah", "Tampilkan error tanpa membocorkan detail; izinkan coba lagi."),
    ("gagal", "Pesan ramah + retry; pertahankan input pengguna."),
    ("dibatalkan", "Tampilkan status dibatalkan dan aksi lanjutan yang relevan."),
    ("validasi", "Tampilkan error inline per field; fokus ke field pertama."),
    ("upload", "Tampilkan progress upload dan opsi batal bila memungkinkan."),
    ("kamera", "Jelaskan izin/ketersediaan kamera dan beri alternatif."),
    ("biometrik", "Tampilkan fallback PIN/password bila biometrik gagal."),
    ("akun terkunci", "Tampilkan countdown/instruksi pemulihan; jangan bocorkan detail."),
    ("deadline", "Tampilkan countdown dan aksi muat ulang."),
    ("pembayaran", "Bedakan status pembayaran dan status pesanan; jangan menyimpulkan sendiri."),
]


# ---------------------------------------------------------------------------
# Util
# ---------------------------------------------------------------------------

def safe(text: str) -> str:
    return str(text).replace("|", "\\|").replace("\n", " ").strip()


def code(text: str) -> str:
    text = str(text)
    if "`" in text:
        return f"`` {text} ``"
    return f"`{text}`"


def display_state_mode(mode: str) -> str:
    mode = str(mode or "")
    lower = mode.lower()
    if "riverpod" in lower and "state lokal" in lower:
        return "State management terpusat + state lokal"
    if "riverpod" in lower:
        return "State management terpusat"
    if "state lokal" in lower or "setstate" in lower:
        return "State lokal"
    if "stateless" in lower:
        return "Tanpa state lokal"
    return mode or "Tidak terdeteksi"


def display_component_type(base: str) -> str:
    base = str(base or "")
    lower = base.lower()
    if "consumerstateful" in lower or "stateful" in lower or "hook" in lower:
        return "Komponen ber-state"
    if "consumerwidget" in lower or "stateless" in lower:
        return "Komponen UI"
    return base or "Tidak terdeteksi"


def display_ref_path(path: str | None) -> str:
    if not path:
        return "Implementasi referensi aplikasi saat ini"
    # avoid exposing framework-specific source paths
    return "Implementasi referensi aplikasi saat ini"


def unique(values):
    out = []
    for value in values:
        if value and value not in out:
            out.append(value)
    return out


def lower_title(title: str) -> str:
    title = title.strip()
    if not title:
        return "data"
    return title[0].lower() + title[1:]


def actor_text(auth: str) -> str:
    auth_l = auth.lower()
    if "guest" in auth_l:
        return "Guest dan pelanggan terautentikasi"
    if "sanctum" in auth_l:
        return "Pelanggan terautentikasi (Sanctum)"
    if "lokal" in auth_l:
        return "Pengguna perangkat"
    if "publik" in auth_l:
        return "Pengunjung publik"
    return auth


def guard_text(auth: str) -> str:
    auth_l = auth.lower()
    if "guest" in auth_l:
        return ("Guest boleh membuka layar, tetapi aksi privat harus memunculkan "
                "prompt autentikasi tamu dan tidak mengirim Bearer token kosong.")
    if "sanctum" in auth_l:
        return ("Butuh Bearer token valid. 401 harus membersihkan token dan "
                "mengarahkan pengguna ke Landing/login.")
    if "lokal" in auth_l:
        return "Tidak membutuhkan token jaringan; state disimpan di perangkat atau diteruskan lewat `extra`."
    if "publik" in auth_l:
        return "Tidak membutuhkan token. Tetap tangani 401/403 bila endpoint berubah menjadi privat."
    return "Tidak ada guard khusus yang terdeteksi."


def back_text(slug: str, kind: str, route: str) -> str:
    if route in {"/home", "/orders", "/chat-list", "/cart", "/profile"}:
        return ("State tab dipertahankan oleh navigasi tab/shell; "
                "kembali tidak boleh mereset cabang lain. [Usulan]")
    if kind in {"form", "order"}:
        return "Jika ada perubahan belum disimpan, tampilkan konfirmasi sebelum keluar. [Usulan]"
    if kind == "payment":
        return "Kembali ke rincian pesanan tanpa mengulang submit; status pembayaran tetap dicek ke backend."
    if kind == "auth":
        return "Kembali dapat keluar dari alur autentikasi; jangan menyimpan kredensial di state global."
    if kind == "detail":
        return "Kembali ke daftar asal; deep link tetap membuka detail yang sama."
    return "Gunakan navigasi kembali bawaan router; jangan membuat navigasi manual yang menduplikasi route."


def success_text(screen: dict, kind: str) -> str:
    mapping = {
        "chat": "Pesan terkirim/diterima dan state panggilan pulih setelah reconnect.",
        "payment": "Status pembayaran terkonfirmasi dari backend tanpa salah tafsir.",
        "order": "Pesanan dibuat/ditampilkan dengan status dan total yang benar.",
        "auth": "Sesi terbuka atau kredensial terverifikasi tanpa membocorkan data sensitif.",
        "scanner": "File hasil scan dihasilkan dan dapat dipakai alur unggah.",
        "list": "Daftar tampil, dapat difilter/di-refresh, dan pagination tidak menduplikasi item.",
        "form": "Data tersimpan dan validasi backend terpetakan ke field.",
        "webview": "Halaman eksternal termuat atau error ditangani dengan jelas.",
        "detail": "Detail resource tampil konsisten dan aksi lanjutan berfungsi.",
        "content": "Konten utama tampil dan navigasi lanjutan berfungsi.",
    }
    return mapping.get(kind, screen["flow"][-1] if screen["flow"] else "Layar tampil tanpa error.")


def status_text(screen: dict) -> str:
    if screen["route"] == "-":
        return "Belum terhubung ke router aplikasi (lihat gap)"
    if screen["gaps"]:
        return "Kontrak terdokumentasi; ada gap yang harus ditangani"
    return "Kontrak terdokumentasi"


def cta_text(screen: dict) -> str:
    slug = screen["slug"]
    mapping = [
        ("checkout", "Buat Pesanan"),
        ("payment", "Saya Sudah Bayar"),
        ("qris", "Saya Sudah Bayar"),
        ("virtual-account", "Saya Sudah Bayar"),
        ("chat", "Kirim"),
        ("review", "Kirim Ulasan"),
        ("scanner", "Gunakan Foto"),
        ("app-lock", "Buka Kunci"),
        ("pin-unlock", "Buka Kunci"),
        ("password-unlock", "Buka Kunci"),
        ("biometric-unlock", "Buka Kunci"),
        ("two-factor", "Verifikasi"),
        ("otp", "Verifikasi"),
        ("forgot-password", "Kirim Kode"),
        ("reset-password", "Simpan Password"),
        ("complete-profile", "Simpan Profil"),
        ("edit-profile", "Simpan Perubahan"),
        ("profile-field", "Simpan"),
        ("security-question", "Lanjutkan"),
        ("switch-account", "Ganti Akun"),
        ("search", "Cari"),
        ("catalog", "Lihat Detail"),
        ("cart", "Checkout"),
        ("order", "Lihat Pesanan"),
        ("voucher", "Pakai Voucher"),
        ("favorite", "Lihat Detail"),
        ("notification", "Buka"),
        ("settings", "Simpan"),
        ("language", "Terapkan"),
        ("report", "Kirim Laporan"),
        ("help", "Hubungi Bantuan"),
    ]
    for key, value in mapping:
        if key in slug:
            return value
    if screen["flow"]:
        last = screen["flow"][-1].rstrip(".")
        if len(last) <= 48:
            return last
    return "Lanjutkan"


def component_type(text: str) -> str:
    lower = text.lower()
    if any(k in lower for k in ("switch", "toggle", "checkbox", "radio")):
        return "Toggle"
    if any(k in lower for k in ("dialog", "sheet", "modal", "popup", "overlay")):
        return "Overlay"
    if any(k in lower for k in ("kamera", "camera", "preview", "scanner", "video", "avatar")):
        return "Media native"
    if any(k in lower for k in ("bubble", "pesan", "message")):
        return "Pesan"
    if any(k in lower for k in ("composer", "input", "field", "form", "password", "pin pad", "otp", "textarea", "dropdown", "picker", "search", "pencarian")):
        return "Input"
    if any(k in lower for k in ("lampiran", "attachment", "file", "upload", "gambar", "foto")):
        return "Lampiran"
    if any(k in lower for k in ("menu", "context", "konteks", "aksi")):
        return "Menu"
    if any(k in lower for k in ("tombol", "button", "cta", "tautan", "link")):
        return "Aksi"
    if any(k in lower for k in ("panel", "panggilan", "call")):
        return "Panel"
    if any(k in lower for k in ("indikator", "status", "badge", "koneksi", "banner")):
        return "Status"
    if any(k in lower for k in ("timeline", "stepper", "tab")):
        return "Navigasi"
    if any(k in lower for k in ("daftar", "list", "grid", "carousel", "feed", "tabel")):
        return "Daftar"
    if any(k in lower for k in ("kartu", "card", "tile", "hero", "chip", "filter")):
        return "Kartu"
    if any(k in lower for k in ("map", "peta", "marker")):
        return "Peta"
    if any(k in lower for k in ("chart", "ring", "progress", "score", "skor", "rating")):
        return "Visual data"
    return "Konten"


def component_action(kind: str) -> str:
    return {
        "Aksi": "Tap → jalankan aksi utama layar.",
        "Input": "Isi/ubah nilai; validasi client sebelum kirim.",
        "Daftar": "Tap item → buka detail; dukung refresh/pagination.",
        "Kartu": "Tap → navigasi atau buka detail.",
        "Toggle": "Ubah preferensi; simpan segera atau lewat tombol simpan.",
        "Overlay": "Konfirmasi/pilih; tutup dengan back atau aksi batal.",
        "Media native": "Minta izin, tampilkan preview, ambil/unggah media.",
        "Peta": "Pilih lokasi; validasi alamat sebelum submit.",
        "Visual data": "Tampilkan ringkasan; tidak dapat diubah langsung.",
        "Pesan": "Tampilkan/balas pesan; long-press untuk menu konteks.",
        "Lampiran": "Pilih file; validasi tipe/ukuran sebelum upload.",
        "Menu": "Pilih aksi kontekstual; tutup setelah aksi.",
        "Panel": "Mulai/terima/akhiri panggilan atau buka panel terkait.",
        "Status": "Tampilkan kondisi koneksi/status; beri aksi retry bila perlu.",
        "Navigasi": "Pindah tab/step; pertahankan state yang relevan.",
        "Konten": "Tampilkan informasi; tidak ada aksi tulis.",
    }.get(kind, "Tampilkan/aksi sesuai konteks.")


def component_feedback(kind: str) -> str:
    return {
        "Aksi": "Disabled saat loading; error lewat SnackBar/inline.",
        "Input": "Error inline; 422 dipetakan per field.",
        "Daftar": "Skeleton saat muat; empty state; retry.",
        "Kartu": "Gambar gagal → placeholder; tap memberi feedback.",
        "Toggle": "Simpan optimistic dengan rollback bila gagal.",
        "Overlay": "Fokus terperangkap; dismiss aman.",
        "Media native": "Izin ditolak → pengaturan; dispose controller.",
        "Peta": "Lokasi gagal → input manual.",
        "Visual data": "Placeholder bila data kosong.",
        "Pesan": "Status kirim/terbaca/gagal tampil jelas.",
        "Lampiran": "Progress upload; error tipe/ukuran.",
        "Menu": "Dismiss aman; aksi destruktif beri konfirmasi.",
        "Panel": "Status panggilan dan izin mikrofon/kamera jelas.",
        "Status": "Perubahan status diumumkan; retry tersedia.",
        "Navigasi": "State tab/step tidak reset tanpa alasan.",
        "Konten": "Loading/error state tetap wajib.",
    }.get(kind, "Loading/error state wajib.")


def behavior_for(state: str) -> str:
    lower = state.lower()
    for key, value in STATE_BEHAVIOR:
        if key in lower:
            return value
    return "Tampilkan status yang jelas dan aksi pemulihan."


def kind_specific_copy(kind: str, title: str) -> list[tuple[str, str, str]]:
    lower = lower_title(title)
    rows: list[tuple[str, str, str]] = []
    if kind == "chat":
        rows += [
            ("Placeholder input", "Ketik pesan...", "[Usulan] Gunakan sistem lokalisasi/i18n."),
            ("Empty list", "Belum ada percakapan.", "[Usulan] Sertakan CTA mulai chat."),
        ]
    elif kind == "payment":
        rows += [
            ("Status menunggu", "Menunggu pembayaran", "[Usulan] Tampilkan countdown."),
            ("Tombol salin", "Salin", "[Usulan] Beri konfirmasi setelah disalin."),
            ("Kedaluwarsa", "Waktu pembayaran habis. Muat ulang untuk mendapatkan kode baru.", "[Usulan] Jangan minta pengguna membayar ulang tanpa instruksi."),
        ]
    elif kind == "scanner":
        rows += [
            ("Panduan", "Posisikan dokumen di dalam bingkai.", "[Usulan] Sediakan panduan suara/haptic."),
            ("Izin", "Izinkan akses kamera untuk memindai.", "[Usulan] Beri tombol buka pengaturan."),
        ]
    elif kind == "order":
        rows += [
            ("Ringkasan", "Ringkasan pesanan", "[Usulan] Total final selalu dari backend."),
            ("Konfirmasi", "Pastikan data acara sudah benar.", "[Usulan] Cek sebelum submit."),
        ]
    elif kind == "auth":
        rows += [
            ("Instruksi", "Masukkan kode verifikasi.", "[Usulan] Tampilkan tujuan kode (email/WhatsApp)."),
            ("Keamanan", "Jangan bagikan kode ini kepada siapa pun.", "[Usulan] Tampilkan sebagai peringatan."),
        ]
    elif kind == "list":
        rows += [
            ("Empty state", f"Belum ada {lower}.", "[Usulan] Sertakan CTA sesuai konteks."),
            ("Filter kosong", "Tidak ada hasil yang cocok.", "[Usulan] Tawarkan reset filter."),
        ]
    elif kind == "form":
        rows += [
            ("Validasi", "Periksa kembali data yang Anda isi.", "[Usulan] Fokus ke field pertama yang salah."),
            ("Sukses", "Data berhasil disimpan.", "[Usulan] Kembali ke layar sebelumnya."),
        ]
    return rows


# ---------------------------------------------------------------------------
# PRD
# ---------------------------------------------------------------------------

def render_prd_detailed(screen, feature, file, lines, rows, tables, related):
    ex = extract_screen(ROOT / file) if file else {
        "lines": lines, "class": screen["cls"], "base": "", "state_class": "",
        "state_mode": "Tidak terdeteksi", "realtime": "request-response",
        "core_widgets": [], "feature_widgets": [], "models": [], "providers": [],
        "repositories": [], "services": [], "state_fields": [], "methods": [],
        "nav_routes": [], "controllers": 0, "form_fields": 0, "dropdowns": 0,
        "switches": 0, "validators": 0, "obscure": 0, "max_lengths": [],
        "keyboard_types": [], "input_formatters": [], "flags": {},
    }
    kind = screen_type(screen["slug"], ex)
    kind_label = KIND_LABEL.get(kind, kind)
    flags = ex["flags"]
    route = screen["route"]
    route_badge = code(route) if route and route != "-" else "**tidak terdaftar**"
    title = screen["title"]
    lower = lower_title(title)
    cta = cta_text(screen)
    out: list[str] = []

    # Header ---------------------------------------------------------------
    out.append(f"# {title}\n")
    out.append(
        f"> **Fitur:** {feature['name']} · **Route:** {route_badge} · "
        f"**Akses:** {screen['auth']} · **Tipe:** {kind_label}"
    )
    out.append(
        f"> **Implementasi referensi (aplikasi saat ini):** `{ex['class']}` · "
        f"**State:** {display_state_mode(ex['state_mode'])} · **Pola:** {ex['realtime']}"
    )
    out.append(
        f"> **API:** {len(rows)} endpoint · **Tabel:** {len(tables)} · "
        f"**Model:** {len(ex['models'])}"
    )
    out.append(
        f"> Diverifikasi {VERIFIED} dari implementasi aplikasi saat ini, route Laravel, dan skema PostgreSQL. "
        "Bagian bertanda **[Usulan]** adalah rekomendasi, bukan perilaku yang sudah diverifikasi.\n"
    )

    # 0 --------------------------------------------------------------------
    out.append("## 0. Ringkasan Eksekutif\n")
    out.append("| Aspek | Ringkasan |")
    out.append("|---|---|")
    out.append(f"| Tujuan | {safe(screen['purpose'])} |")
    out.append(f"| Aktor | {safe(actor_text(screen['auth']))} |")
    out.append(f"| Nilai pengguna | {safe(screen['purpose'])} |")
    last_flow = screen["flow"][-1] if screen["flow"] else "Layar tampil tanpa error."
    success = success_text(screen, kind)
    out.append(f"| Definisi sukses | {safe(success)} |")
    risk = screen["gaps"][0] if screen["gaps"] else "Tidak ada gap khusus yang terdokumentasi."
    out.append(f"| Risiko utama | {safe(risk)} |")
    out.append(f"| Status dokumen | {status_text(screen)} |")
    out.append("")

    # 1 --------------------------------------------------------------------
    context_heading = "Konteks Katalog" if screen["feature"] == "catalog" else "Konteks Fitur"
    out.append(f"## 1. {context_heading}\n")
    out.append("### 1.1 Persona & job-to-be-done\n")
    out.append("| Persona | Kebutuhan | Ukuran keberhasilan |")
    out.append("|---|---|---|")
    out.append(
        f"| Pelanggan dekorasi pernikahan | {safe(screen['purpose'])} | "
        f"{safe(success)} |"
    )
    if "guest" in screen["auth"].lower():
        out.append(
            "| Guest | Mencoba melihat konten tanpa akun; diarahkan login pada aksi privat | "
            "Konten publik tampil dan prompt login muncul tepat pada aksi privat |"
        )
    if "lokal" in screen["auth"].lower():
        out.append(
            "| Pengguna perangkat | Mengatur preferensi lokal | Preferensi bertahan setelah aplikasi ditutup |"
        )
    out.append("")
    out.append("### 1.2 In scope\n")
    for step in screen["flow"]:
        out.append(f"- {step}")
    out.append("")
    out.append("### 1.3 Out of scope\n")
    out.append("- Tidak mengakses database secara langsung; semua data lewat REST/Laravel.")
    out.append("- Tidak menggantikan validasi backend untuk harga, stok, status, atau kepemilikan resource.")
    if kind == "payment":
        out.append("- Tidak menghitung total final atau menyimpulkan status pembayaran dari state lokal.")
    if kind == "scanner":
        out.append("- Tidak mengunggah dokumen dari dalam scanner; scanner hanya menghasilkan file.")
    if kind == "chat":
        out.append("- Tidak menyimpan riwayat pesan permanen di perangkat di luar cache yang sudah ada.")
    if kind == "list":
        out.append("- Tidak mengubah data di luar aksi yang terlihat (refresh, buka detail, hapus bila ada).")
    out.append("- Tidak menambahkan dependensi atau endpoint baru tanpa memperbarui dokumen ini dan peta endpoint.")
    out.append("")

    # 2 --------------------------------------------------------------------
    out.append("## 2. Navigasi & Entry Point\n")
    out.append("| Arah | Detail |")
    out.append("|---|---|")
    out.append(f"| Masuk dari | {safe(screen['entry'])} |")
    out.append(f"| Route | {route_badge} |")
    out.append(f"| Parameter/extra | {safe(screen['route_note'] or 'Tidak ada parameter khusus.')} |")
    out.append(f"| Guard | {safe(guard_text(screen['auth']))} |")
    outgoing = ex["nav_routes"]
    out.append(
        f"| Keluar ke | {safe(', '.join(code(r) for r in outgoing)) if outgoing else 'Tidak ada navigasi keluar langsung yang terdeteksi.'} |"
    )
    out.append(f"| Perilaku back | {safe(back_text(screen['slug'], kind, route))} |")
    out.append("")
    if related:
        out.append("### 2.1 Layar terkait dalam fitur yang sama\n")
        out.append("| Layar | Route | PRD |")
        out.append("|---|---|---|")
        for other in related:
            other_route = code(other["route"]) if other["route"] != "-" else "—"
            out.append(
                f"| `{other['cls']}` | {other_route} | "
                f"[{other['slug']}.md](../{feature['folder']}/{other['slug']}.md) |"
            )
        out.append("")

    # 3 --------------------------------------------------------------------
    out.append("## 3. Alur Pengguna\n")
    for index, step in enumerate(screen["flow"], 1):
        out.append(f"{index}. {step}")
    out.append("")
    out.append("**Decision points yang wajib diuji:**\n")
    decision_states = [s for s in screen["states"] if any(k in s.lower() for k in ("gagal", "salah", "tidak", "kurang", "kosong", "izin", "offline"))]
    if decision_states:
        for state in decision_states[:8]:
            out.append(f"- `{state}` → {behavior_for(state)}")
    else:
        out.append("- Tidak ada cabang kegagalan khusus; tetap uji loading, error jaringan, dan sesi kedaluwarsa.")
    out.append("")
    first_ui = screen["ui"][0] if screen["ui"] else "Konten utama"
    out.append("```mermaid")
    out.append("flowchart TD")
    out.append(f'  A["Masuk: {_mermaid(screen["entry"])}"] --> B["Render awal / muat data"]')
    out.append('  B -->|sukses| C["' + _mermaid(first_ui) + '"]')
    out.append('  C --> D["' + _mermaid(last_flow) + '"]')
    out.append('  B -->|gagal| E["Error state + retry"]')
    out.append("  E --> B")
    out.append('  D --> F["Selesai / navigasi keluar"]')
    out.append("```\n")

    # 4 --------------------------------------------------------------------
    out.append("## 4. Arsitektur Layar\n")
    out.append("| Aspek | Nilai |")
    out.append("|---|---|")
    out.append(f"| Komponen/layar | `{ex['class']}` |")
    out.append(f"| Identifier | `{ex['class']}` |")
    out.append(f"| Tipe komponen | {display_component_type(ex.get('base', ''))} |")
    if ex.get("state_class"):
        out.append(f"| Komponen state | Tersedia pada implementasi referensi |")
    out.append(f"| State management | {display_state_mode(ex['state_mode'])} |")
    out.append(f"| Pola data | {ex['realtime']} |")
    out.append(f"| State/dependency | {_inline_list(ex['providers'])} |")
    out.append(f"| Data source/repository | {_inline_list(ex['repositories'])} |")
    out.append(f"| Service | {_inline_list(ex['services'])} |")
    out.append(f"| Komponen UI bersama | {_inline_list(ex['core_widgets'])} |")
    out.append(f"| Komponen UI fitur | {_inline_list(ex['feature_widgets'])} |")
    out.append(f"| Model | {_inline_list([m['class'] for m in ex['models']])} |")
    out.append("")
    if ex["state_fields"]:
        out.append("### 4.1 State lokal yang terdeteksi\n")
        out.append("| Field | Tipe | Peran |")
        out.append("|---|---|---|")
        for name, type_name in ex["state_fields"]:
            out.append(f"| `{name}` | `{type_name}` | {_field_role(name)} |")
        out.append("")
    if ex["methods"]:
        out.append("### 4.2 Metode internal\n")
        out.append(", ".join(code(m) for m in ex["methods"]) + ".\n")
    out.append("### 4.3 Alur data\n")
    out.append("```text")
    out.append("UI / State layar")
    if ex["providers"]:
        out.append("   ↓ baca/tulis")
        out.append("State management / dependency")
    out.append("   ↓")
    out.append("Repository / HTTP client")
    out.append(f"   ↓ REST")
    out.append(f"Controller Laravel → PostgreSQL ({len(tables)} tabel terkait)")
    out.append("```\n")

    # 5 --------------------------------------------------------------------
    out.append("## 5. Blueprint UI\n")
    out.append("Wireframe konseptual dari daftar elemen registry. Urutan final mengikuti implementasi aplikasi.\n")
    out.append("```text")
    out.append("┌" + "─" * WIDTH + "┐")
    out.append("│ " + title[:WIDTH - 3].ljust(WIDTH - 2) + "│")
    out.append("├" + "─" * WIDTH + "┤")
    for index, item in enumerate(screen["ui"], 1):
        label = f"{index}. {item}"
        for line in textwrap.wrap(label, WIDTH - 4) or [label]:
            out.append("│ " + line.ljust(WIDTH - 2) + "│")
    out.append("└" + "─" * WIDTH + "┘")
    out.append("```\n")
    if ex["core_widgets"] or ex["feature_widgets"]:
        out.append("**Komponen bersama yang terdeteksi:**\n")
        if ex["core_widgets"]:
            out.append("- Core: " + ", ".join(code(w) for w in ex["core_widgets"]))
        if ex["feature_widgets"]:
            out.append("- Fitur: " + ", ".join(code(w) for w in ex["feature_widgets"]))
        out.append("")

    # 6 --------------------------------------------------------------------
    out.append("## 6. Inventaris Komponen & Interaksi\n")
    out.append("| # | Elemen | Jenis | Aksi | Feedback |")
    out.append("|---|---|---|---|---|")
    for index, item in enumerate(screen["ui"], 1):
        ctype = component_type(item)
        out.append(
            f"| {index} | {safe(item)} | {ctype} | {component_action(ctype)} | "
            f"{component_feedback(ctype)} |"
        )
    out.append("")
    out.append("### 6.1 Fakta teknis form & interaksi\n")
    out.append("| Fakta | Nilai |")
    out.append("|---|---|")
    out.append(f"| TextEditingController | {ex['controllers']} |")
    out.append(f"| Field teks/form | {ex['form_fields']} |")
    out.append(f"| Dropdown | {ex['dropdowns']} |")
    out.append(f"| Switch/toggle | {ex['switches']} |")
    out.append(f"| Validator client | {ex['validators']} |")
    out.append(f"| Field password (teks tersamar) | {ex['obscure']} |")
    out.append(f"| maxLength | {', '.join(ex['max_lengths']) if ex['max_lengths'] else 'Tidak terdeteksi'} |")
    out.append(f"| Keyboard | {', '.join(ex['keyboard_types']) if ex['keyboard_types'] else 'Tidak terdeteksi'} |")
    out.append(f"| Input formatter | {', '.join(ex['input_formatters']) if ex['input_formatters'] else 'Tidak terdeteksi'} |")
    out.append(f"| Upload file | {'Ya' if flags.get('upload') else 'Tidak'} |")
    out.append(f"| Kamera | {'Ya' if flags.get('camera') else 'Tidak'} |")
    out.append(f"| WebView | {'Ya' if flags.get('webview') else 'Tidak'} |")
    out.append(f"| Timer/polling | {'Ya' if flags.get('timer') else 'Tidak'} |")
    out.append(f"| Pagination | {'Ya' if flags.get('pagination') else 'Tidak'} |")
    out.append(f"| Pull to refresh | {'Ya' if flags.get('refresh_indicator') else 'Tidak'} |")
    out.append("")

    # 7 --------------------------------------------------------------------
    out.append("## 7. Copywriting & Microcopy\n")
    out.append("Semua teks di bawah ini adalah **usulan**. Implementasi wajib memakai sistem lokalisasi/i18n yang konsisten dan mengikuti gaya bahasa layar lain.\n")
    out.append("| Lokasi | Draft copy | Catatan |")
    out.append("|---|---|---|")
    out.append(f"| Judul/header | {safe(title)} | Samakan dengan label navigasi. |")
    out.append(f"| Subjudul | {safe(_short(screen['purpose'], 90))} | Ringkas; jangan mengulang judul. |")
    out.append(f"| Tombol utama | {safe(cta)} | [Usulan] Disabled saat proses. |")
    out.append("| Empty state | " + safe(f"Belum ada {lower}.") + " | [Usulan] Sertakan CTA lanjutan. |")
    out.append(f"| Error | {safe(f'Gagal memuat {lower}. Periksa koneksi lalu coba lagi.')} | [Usulan] Jangan tampilkan stack trace. |")
    out.append("| Retry | Coba lagi | [Usulan] Pertahankan data lama bila ada. |")
    if "guest" in screen["auth"].lower():
        out.append("| Guest | Masuk untuk melanjutkan. | [Usulan] Gunakan prompt autentikasi tamu. |")
    out.append("| Offline | Anda sedang offline. Periksa koneksi internet. | [Usulan] Sediakan retry. |")
    out.append("| Validasi | Periksa kembali data yang Anda isi. | [Usulan] Fokus ke field pertama. |")
    for location, copy, note in kind_specific_copy(kind, title):
        out.append(f"| {safe(location)} | {safe(copy)} | {safe(note)} |")
    out.append("")

    # 8 --------------------------------------------------------------------
    out.append("## 8. Design System & Responsif\n")
    out.append("### 8.1 Token yang wajib dipakai\n")
    out.append("| Token | Nilai |")
    out.append("|---|---|")
    out.append("| Font | Instrument Sans (W400/W600), aset lokal |")
    out.append("| Warna primer | `#1E3A5F` (token primer aplikasi) |")
    out.append("| Aksen | `#C9A94E` |")
    out.append("| Background light | `#F8F6F7` |")
    out.append("| Surface light | `#FFFFFF` |")
    out.append("| Background dark | `#121212` |")
    out.append("| Surface dark | `#1E1E1E` |")
    out.append("| Teks primer light | `#1A1A2E`; dark `#E8E8E8` |")
    out.append("| Teks sekunder light | `#8E8E9A`; dark `#A0A0A0` |")
    out.append("| Sukses/error/warning/info | `#10B981` / `#EF4444` / `#F59E0B` / `#3B82F6` |")
    out.append("| Tipografi | `headTitle` 22/w600; `subHeadTitle` 16/w400; `h3` 14/w600; `h4` 12/w400; `description` 14/1.4 |")
    out.append("| Spacing | skala 2, 4, 8, 16, 24, 32, 48, 64 |")
    out.append("| Radius | card 16, button 14, input 14, avatar 28, bottom nav 24 |")
    out.append("| Glass | `AppBlurBackdrop`; `blurSigma` 15; tint light `#32FFFFFF`, night `#32000000` |")
    out.append("")
    out.append("### 8.2 Aturan responsif\n")
    out.append("- Lebar minimum yang wajib diuji: **320 px**; target umum 360/390/412 px.")
    out.append("- Tablet ≥ 600 px: gunakan padding lebih lebar dan grid multi-kolom bila layar berupa koleksi.")
    out.append("- Jangan mengunci tinggi konten; gunakan `SingleChildScrollView`/sliver agar tidak overflow.")
    out.append("- Hormati `SafeArea`, status bar, navigation bar, dan keyboard inset.")
    out.append("- Teks harus tetap terbaca pada text scale 200%; hindari `maxLines: 1` untuk label penting.")
    out.append("- Layout harus aman untuk locale dengan teks lebih panjang (±30%).")
    out.append("")
    out.append("### 8.3 Mode gelap & glass\n")
    out.append("- Tema mengikuti sistem (light/dark) dan dapat di-override `ThemeProvider`.")
    out.append("- Jangan hardcode warna; gunakan token/tema desain aplikasi agar mode gelap bekerja.")
    out.append("- Fallback tanpa blur harus tetap kontras dan terbaca.")
    out.append("- Hormati reduce-motion; animasi 3D/parallax tidak boleh menjadi satu-satunya pembeda state.")
    out.append("")

    # 9 --------------------------------------------------------------------
    state_rows = _state_rows(screen, kind, flags, rows)
    out.append("## 9. State Machine\n")
    out.append("| State | Pemicu | UI | Pemulihan |")
    out.append("|---|---|---|---|")
    for state, trigger, ui, recovery in state_rows:
        out.append(f"| `{safe(state)}` | {safe(trigger)} | {safe(ui)} | {safe(recovery)} |")
    out.append("")
    out.append("**Aturan umum:** setiap request harus melewati `idle → loading → success/empty/failure`; "
               "jangan merender hasil request langsung di `build()`.\n")

    # 10 -------------------------------------------------------------------
    out.append("## 10. Kontrak API\n")
    if rows:
        out.append("### 10.1 Ringkasan endpoint\n")
        out.append("| # | Method | Path | Controller | Auth | Kegunaan |")
        out.append("|---|---|---|---|---|---|")
        for index, row in enumerate(rows, 1):
            out.append(
                f"| {index} | `{row['method']}` | `{row['path']}` | `{row['controller']}` | "
                f"{row['auth']} | {safe(row['purpose'])} |"
            )
        out.append("")
        out.append("### 10.2 Detail per endpoint\n")
        for index, row in enumerate(rows, 1):
            out.append(f"#### 10.2.{index} `{row['method']} {row['path']}`\n")
            out.append(f"- **Controller:** `{row['controller']}`")
            out.append(f"- **Auth:** {row['auth']}")
            out.append(f"- **Kegunaan:** {row['purpose']}")
            backend = _backend_for(row)
            if backend["found"]:
                out.append(f"- **Sumber aturan:** `{backend['source']}`")
            if row["note"]:
                out.append(f"- **Catatan:** {row['note']}")
            if backend["fields"]:
                out.append("")
                out.append("| Field request | Aturan | Wajib |")
                out.append("|---|---|---|")
                seen_fields = set()
                for name, rule in backend["fields"]:
                    if (name, rule) in seen_fields:
                        continue
                    seen_fields.add((name, rule))
                    if "required" in rule and "nullable" in rule:
                        required = "Bersyarat"
                    elif "required" in rule:
                        required = "Ya"
                    else:
                        required = "Tidak"
                    out.append(f"| `{name}` | `{rule}` | {required} |")
                out.append("")
            else:
                out.append("- **Field request:** tidak ada aturan validasi field yang terdeteksi otomatis "
                           "(GET, validasi di service, atau `FormRequest` lain). Periksa controller sebelum menulis kode.")
            if backend["response_keys"]:
                out.append(
                    "- **Response top-level:** "
                    + ", ".join(code(k) for k in backend["response_keys"])
                )
            if backend["messages"]:
                out.append(
                    "- **Pesan error terbaca:** "
                    + "; ".join(f"“{m}”" for m in backend["messages"])
                )
            if row["controller"] == "-":
                out.append("- **Mismatch:** konstanta client belum cocok dengan route backend; lihat "
                           "[Known Gaps](../../06-reference/KNOWN-GAPS.md).")
            out.append("")
        out.append("**Envelope acuan** (periksa controller untuk variasi):\n")
        out.append("```json")
        out.append('{"status":"success","message":"...","data":{}}')
        out.append("```\n")
    else:
        out.append("Layar ini **tidak memanggil API jaringan**. Semua state disimpan di perangkat "
                   "(penyimpanan lokal/secure storage) atau diterima lewat `extra`/provider.\n")
    out.append("### 10.3 Pemetaan error HTTP\n")
    out.append("| HTTP | Failure | Perilaku UI |")
    out.append("|---|---|---|")
    for status, failure, behavior in HTTP_ROWS:
        out.append(f"| {status} | {failure} | {behavior} |")
    out.append("")
    if ex["models"]:
        out.append("### 10.4 Model yang dipakai\n")
        out.append("| Model | File | Field kunci |")
        out.append("|---|---|---|")
        for model in ex["models"]:
            fields = ", ".join(code(name) for name, _ in model["fields"][:10]) or "Tidak terdeteksi"
            out.append(f"| `{model['class']}` | `{model['file']}` | {fields} |")
        out.append("")

    # 11 -------------------------------------------------------------------
    out.append("## 11. Data & Database\n")
    if tables:
        out.append("| Tabel | Peran | Akses | Kolom kunci |")
        out.append("|---|---|---|---|")
        for table, role in tables:
            out.append(
                f"| `{table}` | {safe(role)} | {_table_access(rows)} | {table_columns(table)} |"
            )
        out.append("")
        out.append("Akses tabel di atas adalah **indikasi dari endpoint**; verifikasi controller/service "
                   "untuk memastikan operasi baca/tulis yang sebenarnya.")
        out.append("")
    else:
        out.append("Tidak ada tabel PostgreSQL yang dibaca/ditulis langsung oleh layar ini.\n")
    out.append("### 11.1 Aturan data\n")
    out.append("- Jangan menampilkan data dari cache setelah logout.")
    out.append("- Nominal, stok, status pesanan, dan kepemilikan resource **wajib** divalidasi backend.")
    out.append("- Jangan mengakses PostgreSQL langsung dari klien; gunakan endpoint Laravel.")
    out.append("- Filter data milik pengguna dilakukan server-side (`user_id` dari token), bukan di client.")
    if "orders" in [t for t, _ in tables]:
        out.append("- Jangan menyimpulkan status pembayaran dari `orders.status`; gunakan data pembayaran/transaksi.")
    if flags.get("shared_prefs"):
        out.append("- Preferensi lokal disimpan di penyimpanan lokal; token tetap di secure storage.")
    out.append("")

    # 12 -------------------------------------------------------------------
    out.append("## 12. Aturan Bisnis & Validasi\n")
    out.append("### 12.1 Acceptance dari registry\n")
    for item in screen["accept"]:
        out.append(f"- {item}")
    out.append("")
    out.append("### 12.2 Validasi server yang terbaca dari controller\n")
    server_fields = _server_fields(rows)
    if server_fields:
        out.append("| Field | Aturan | Endpoint |")
        out.append("|---|---|---|")
        for name, rule, path in server_fields[:30]:
            out.append(f"| `{name}` | `{rule}` | `{path}` |")
        out.append("")
        if len(server_fields) > 30:
            out.append(f"> Menampilkan 30 dari {len(server_fields)} aturan. Lihat controller untuk sisanya.\n")
    else:
        out.append("Tidak ada aturan validasi field yang terdeteksi otomatis. Periksa controller/FormRequest "
                   "sebelum mengandalkan validasi client.\n")
    out.append("### 12.3 Validasi client yang terdeteksi\n")
    if ex["validators"] or ex["form_fields"]:
        out.append(f"- Form memiliki **{ex['form_fields']} field** dan **{ex['validators']} validator** client.")
        if ex["max_lengths"]:
            out.append(f"- Batas panjang input: {', '.join(ex['max_lengths'])}.")
        if ex["keyboard_types"]:
            out.append(f"- Keyboard: {', '.join(ex['keyboard_types'])}.")
        out.append("- Validasi client hanya untuk UX; hasil final tetap dari backend (`422`).")
    else:
        out.append("- Tidak ada form input yang terdeteksi pada layar ini.")
    out.append("")
    out.append("### 12.4 Aturan bisnis wajib\n")
    out.append("- Disable tombol submit selama request berjalan untuk mencegah duplikasi.")
    out.append("- Terapkan `Accept-Language` dari `localeProvider` pada setiap request.")
    out.append("- Gunakan HTTP client/data source/repository yang sudah ada; jangan membuat client baru di komponen UI.")
    out.append("- Guest tidak boleh memanggil endpoint privat; tampilkan prompt autentikasi tamu.")
    for rule in _kind_business_rules(kind):
        out.append(f"- {rule}")
    out.append("")

    # 13 -------------------------------------------------------------------
    out.append("## 13. Error Handling\n")
    out.append("Pemetaan status HTTP mengikuti `.docs/02-architecture/STATE-AND-ERRORS.md` (lihat §10.3).\n")
    out.append("### 13.1 Kegagalan spesifik layar\n")
    for failure in _screen_failures(kind, flags, screen):
        out.append(f"- {failure}")
    out.append("")

    # 14 -------------------------------------------------------------------
    out.append("## 14. Keamanan & Privasi\n")
    for item in _security_rules(kind, flags, screen):
        out.append(f"- {item}")
    out.append("")

    # 15 -------------------------------------------------------------------
    out.append("## 15. Aksesibilitas\n")
    for item in _a11y_rules(kind, flags):
        out.append(f"- {item}")
    out.append("")

    # 16 -------------------------------------------------------------------
    out.append("## 16. Performa & Offline\n")
    for item in _performance_rules(kind, flags, ex):
        out.append(f"- {item}")
    out.append("")

    # 17 -------------------------------------------------------------------
    out.append("## 17. Analytics & Observability [Usulan]\n")
    out.append("Belum diverifikasi apakah event berikut sudah diimplementasikan. Jangan mengirim PII.\n")
    out.append("| Event | Pemicu | Properti | PII |")
    out.append("|---|---|---|---|")
    for event, trigger, props in _analytics_rows(screen, kind):
        out.append(f"| `{event}` | {trigger} | {props} | Tidak |")
    out.append("")
    out.append("- Catat `request_id`/status code pada log debug, bukan payload sensitif.")
    out.append("- Crashlytics tidak boleh memuat token, password, dokumen identitas, atau isi chat.")
    out.append("")

    # 18 -------------------------------------------------------------------
    out.append("## 18. Acceptance Criteria\n")
    out.append("### 18.1 Fungsional\n")
    for item in screen["accept"]:
        out.append(f"- [ ] {item}")
    out.append(f"- [ ] Tombol utama menjalankan aksi: {cta}.")
    out.append("")
    out.append("### 18.2 Navigasi\n")
    out.append(f"- [ ] Jalur masuk berfungsi: {screen['entry']}")
    out.append(f"- [ ] Route/parameter sesuai: {route_badge}.")
    out.append("- [ ] Back tidak meninggalkan state ganda atau mengulang submit.")
    out.append("")
    out.append("### 18.3 State & error\n")
    out.append("- [ ] Loading, content, empty, error, offline, dan unauthorized tertangani.")
    out.append("- [ ] 401 membersihkan token dan mengarahkan ke Landing/login.")
    out.append("- [ ] 422 menampilkan error per field dan mempertahankan input.")
    out.append("- [ ] Tombol tidak dapat ditekan ganda saat request berjalan.")
    out.append("")
    out.append("### 18.4 Data & keamanan\n")
    out.append("- [ ] Semua endpoint yang dipakai terdaftar di backend; tidak ada endpoint karangan.")
    out.append("- [ ] Nominal/stok/status berasal dari respons backend, bukan hitungan lokal.")
    out.append("- [ ] Tidak ada PII/token di log, analytics, atau pesan error.")
    out.append("- [ ] Guest tidak memanggil endpoint privat.")
    out.append("")
    out.append("### 18.5 Responsif & aksesibilitas\n")
    out.append("- [ ] Tidak ada overflow pada lebar 320 px dan orientasi landscape.")
    out.append("- [ ] Mode terang dan gelap terbaca.")
    out.append("- [ ] Text scale 200% tidak memotong label penting.")
    out.append("- [ ] Target sentuh minimal 48×48 dp dan label semantik tersedia.")
    out.append("")
    out.append("### 18.6 Kualitas\n")
    out.append("- [ ] Analisis statis/lint sesuai toolchain target bersih untuk bagian yang diubah.")
    out.append("- [ ] Test happy path dan minimal satu error path ditambahkan/diperbarui.")
    out.append("- [ ] PRD/SKILL diperbarui bila route, endpoint, atau tabel berubah.")
    out.append("")

    # 19 -------------------------------------------------------------------
    out.append("## 19. Test Plan\n")
    out.append("| ID | Jenis | Skenario | Langkah | Hasil yang diharapkan |")
    out.append("|---|---|---|---|---|")
    for tc in _test_plan(screen, kind, flags, rows):
        out.append(f"| {tc['id']} | {tc['type']} | {safe(tc['scenario'])} | {safe(tc['steps'])} | {safe(tc['expected'])} |")
    out.append("")
    out.append("**Otomasi yang disarankan:** widget test untuk state utama, unit test untuk parsing/validasi, "
               "dan golden test untuk layar dengan layout kompleks.\n")

    # 20 -------------------------------------------------------------------
    out.append("## 20. Gap, Risiko & Dependensi\n")
    if screen["gaps"]:
        out.append("### 20.1 Gap terdokumentasi\n")
        for gap in screen["gaps"]:
            out.append(f"- {gap}")
        out.append("")
    else:
        out.append("Tidak ada gap khusus untuk layar ini.\n")
    out.append("### 20.2 Risiko\n")
    out.append("| Risiko | Peluang | Dampak | Mitigasi |")
    out.append("|---|---|---|---|")
    for risk, probability, impact, mitigation in _risk_rows(screen, kind, flags):
        out.append(f"| {safe(risk)} | {probability} | {impact} | {safe(mitigation)} |")
    out.append("")
    out.append("### 20.3 Dependensi\n")
    out.append("| Jenis | Item | Catatan |")
    out.append("|---|---|---|")
    for dep_type, item, note in _dependency_rows(screen, rows, tables, ex):
        out.append(f"| {dep_type} | {safe(item)} | {safe(note)} |")
    out.append("")
    out.append("Rujukan global: [Known Gaps](../../06-reference/KNOWN-GAPS.md).\n")

    # 21 -------------------------------------------------------------------
    out.append("## 21. Peta Implementasi & Simbol\n")
    out.append("| Layer | Komponen/Referensi | Catatan |")
    out.append("|---|---|---|")
    out.append(f"| Layar/UI | `{ex['class']}` | Implementasi referensi aplikasi saat ini |")
    for provider in ex["providers"]:
        out.append(f"| State/dependency | `{provider}` | Komponen state/dependency terkait |")
    for model in ex["models"]:
        out.append(f"| Model/data | `{model['class']}` | Struktur data terkait |")
    for widget in ex["core_widgets"]:
        out.append(f"| Komponen UI bersama | `{widget}` | Komponen UI reusable |")
    for widget in ex["feature_widgets"]:
        out.append(f"| Komponen UI fitur | `{widget}` | Komponen UI khusus fitur |")
    out.append("| Test | Sesuai platform target | Tambahkan test sesuai §19 |")
    out.append(f"| Dokumen | `.docs/screens/{feature['folder']}/{screen['slug']}.md` | PRD ini |")
    out.append(f"| Prompt | `.skills/screens/{feature['folder']}/{screen['slug']}/SKILL.md` | Skill layar |")
    out.append("")
    if ex["methods"]:
        out.append("**Metode internal terdeteksi:** " + ", ".join(code(m) for m in ex["methods"]) + ".\n")
    if flags.get("direct_dio"):
        out.append("> **Catatan arsitektur:** layar memakai HTTP client bersama langsung. "
                   "Saat refactor, pindahkan ke repository/provider tanpa mengubah kontrak.\n")

    # 22 -------------------------------------------------------------------
    out.append("## 22. Referensi & Riwayat\n")
    out.append("- [REST API](../../03-api/REST-API.md)")
    out.append("- [State & Error](../../02-architecture/STATE-AND-ERRORS.md)")
    out.append("- [Peta Endpoint](../../06-reference/API-ENDPOINT-MAP.md)")
    out.append("- [Database](../../04-database/DATABASE.md)")
    out.append("- [Arsitektur](../../02-architecture/ARCHITECTURE.md)")
    out.append(f"- [Skill layar](../../../.skills/screens/{feature['folder']}/{screen['slug']}/SKILL.md)")
    out.append("")
    out.append("| Tanggal | Perubahan | Sumber |")
    out.append("|---|---|---|")
    out.append(f"| {VERIFIED} | Regenerasi detail: arsitektur, state machine, kontrak API, validasi, a11y, test plan | "
               "Implementasi aplikasi, route Laravel, skema PostgreSQL |")
    out.append("")
    return "\n".join(out)


# ---------------------------------------------------------------------------
# SKILL
# ---------------------------------------------------------------------------

def render_skill_detailed(screen, feature, file, rows, tables):
    ex = extract_screen(ROOT / file) if file else {
        "class": screen["cls"], "base": "", "state_mode": "Tidak terdeteksi",
        "realtime": "request-response", "providers": [], "models": [],
        "repositories": [], "services": [], "state_fields": [], "methods": [],
        "core_widgets": [], "feature_widgets": [], "nav_routes": [],
        "flags": {}, "controllers": 0, "form_fields": 0, "validators": 0,
    }
    kind = screen_type(screen["slug"], ex)
    kind_label = KIND_LABEL.get(kind, kind)
    flags = ex["flags"]
    route = screen["route"]
    route_badge = code(route) if route and route != "-" else "tidak terdaftar"
    title = screen["title"]
    cta = cta_text(screen)
    folder = feature["folder"]
    slug = screen["slug"]
    skill_name = slug if slug.startswith(folder + "-") or slug == folder else f"{folder}-{slug}"
    out: list[str] = []

    out.append("---")
    out.append(f"name: {skill_name}")
    out.append(
        f"description: Implementasi layar {title} ({ex['class']}) pada fitur {feature['name']}; "
        f"route {screen['route']}, {len(rows)} endpoint, {len(tables)} tabel, state, guardrail, dan definition of done."
    )
    out.append("---\n")
    out.append(f"# Skill: {title}\n")
    out.append(
        f"> **Tipe:** {kind_label} · **Route:** {route_badge} · **Akses:** {screen['auth']} · "
        f"**State:** {display_state_mode(ex['state_mode'])}\n"
    )

    # Prompt siap pakai
    out.append("## 0. Prompt siap pakai\n")
    out.append("Tempel blok berikut ke agen implementasi. Ganti bagian dalam `<...>` bila perlu.\n")
    out.append("```text")
    out.append(f"Anda bekerja pada layar {title} di fitur {feature['name']}.")
    out.append(f"Referensi implementasi saat ini: {ex['class']}. Route: {screen['route']} ({screen['auth']}).")
    out.append(f"Tujuan: {screen['purpose']}")
    out.append("")
    out.append("Konteks wajib:")
    out.append(f"- Baca PRD lengkap: .docs/screens/{folder}/{slug}.md")
    out.append(f"- State management: {display_state_mode(ex['state_mode'])}; pola data: {ex['realtime']}.")
    out.append("- Endpoint: " + _sentence(_endpoint_summary(rows)))
    out.append(f"- Tabel: {_table_summary(tables)}.")
    out.append("- Parameter/extra: " + _sentence(screen['route_note'] or 'tidak ada parameter khusus'))
    out.append("")
    out.append("Wajib dipertahankan:")
    for item in screen["accept"][:6]:
        out.append(f"- {item}")
    out.append("- Tangani loading, empty, error, offline, unauthorized, dan double-submit.")
    out.append("- Gunakan token desain dan sistem lokalisasi yang konsisten; jangan hardcode.")
    out.append("- Jangan mengarang endpoint/kolom. Verifikasi ke backend sebelum menulis kode.")
    out.append("- Jangan memanggil HTTP client baru dari komponen UI; gunakan repository/data source yang ada.")
    out.append("")
    out.append(f"Selesai jika: {cta.lower()} bekerja, semua state di atas tertangani, "
               "analisis statis/lint bersih, dan test otomatis sesuai platform target untuk happy path + minimal satu error path lulus.")
    out.append("```\n")

    # 1
    out.append("## 1. Kapan dipakai / tidak\n")
    out.append(f"**Dipakai** saat mengubah, menguji, me-refactor, atau mendokumentasikan layar **{title}** (referensi implementasi: `{ex['class']}`).\n")
    out.append("**Tidak dipakai** untuk:")
    out.append("- Mengubah kontrak backend tanpa juga memperbarui PRD dan peta endpoint.")
    out.append("- Mendesain ulang seluruh design system; ikuti panduan desain dan keamanan bersama jika tersedia.")
    if kind == "chat":
        out.append("- Mengubah signaling WebRTC/panggilan tanpa membaca dokumentasi chat.")
    if kind == "payment":
        out.append("- Mengubah logika payment gateway di backend; itu di luar layar ini.")
    out.append("")

    # 2
    out.append("## 2. Input & prasyarat\n")
    out.append("| Prasyarat | Nilai |")
    out.append("|---|---|")
    out.append(f"| Referensi implementasi | `{ex['class']}` |")
    out.append(f"| Route | {route_badge} |")
    out.append(f"| Akses | {screen['auth']} |")
    out.append(f"| Parameter | {safe(screen['route_note'] or 'Tidak ada')} |")
    out.append(f"| Masuk dari | {safe(screen['entry'])} |")
    out.append(f"| State/dependency | {_inline_list(ex['providers'])} |")
    out.append(f"| Model | {_inline_list([m['class'] for m in ex['models']])} |")
    out.append(f"| Endpoint | {len(rows)} |")
    out.append(f"| Tabel | {len(tables)} |")
    out.append("")
    if flags.get("camera"):
        out.append("- Izin kamera dan lifecycle controller wajib diuji di perangkat fisik/emulator dengan kamera.\n")
    if flags.get("webview"):
        out.append("- WebView membutuhkan koneksi jaringan dan URL valid; uji juga halaman error.\n")
    if flags.get("timer"):
        out.append("- Timer/polling harus diuji saat app background/resume dan saat dispose.\n")

    # 3
    out.append("## 3. Sumber kebenaran\n")
    out.append("| Aspek | Sumber |")
    out.append("|---|---|")
    out.append("| Layar & route | Konfigurasi router aplikasi |")
    out.append("| Endpoint client | Definisi endpoint API klien |")
    out.append("| HTTP client | HTTP client/data source bersama |")
    out.append("| Desain | Token desain/tema aplikasi |")
    out.append("| Backend | `../Mobile-And-Backend/routes/api` dan `app/Http/Controllers/Api/User` |")
    out.append("| Database | PostgreSQL `wedding_florals_decorations` |")
    out.append(f"| PRD | `.docs/screens/{folder}/{slug}.md` |")
    out.append("")

    # 4
    out.append("## 4. Peta file yang akan disentuh\n")
    out.append("| Area | Komponen | Perubahan yang diharapkan |")
    out.append("|---|---|---|")
    out.append(f"| Layar/UI | `{ex['class']}` | UI, state, interaksi |")
    for provider in ex["providers"]:
        provider_file = find_provider_file(provider)
        out.append(f"| State/dependency | `{provider}` | State/aksi domain |")
    for model in ex["models"]:
        out.append(f"| Model | `{model['file']}` | Parsing/serialisasi bila kontrak berubah |")
    out.append(f"| Test | Test otomatis (platform target) di area {feature['name'].split()[0]}/` | Test happy path + error path |")
    out.append(f"| PRD | `.docs/screens/{folder}/{slug}.md` | Perbarui bila route/API/tabel berubah |")
    out.append(f"| Prompt | `.skills/screens/{folder}/{slug}/SKILL.md` | Skill ini |")
    out.append("")

    # 5
    out.append("## 5. Spesifikasi yang harus dipertahankan\n")
    out.append("### 5.1 Tujuan & alur\n")
    out.append(screen["purpose"] + "\n")
    for index, step in enumerate(screen["flow"], 1):
        out.append(f"{index}. {step}")
    out.append("")
    out.append("### 5.2 Elemen UI wajib\n")
    for item in screen["ui"]:
        out.append(f"- {item}")
    out.append("")
    out.append("### 5.3 State wajib\n")
    state_rows = _state_rows(screen, kind, flags, rows)
    out.append("| State | UI | Pemulihan |")
    out.append("|---|---|---|")
    for state, _trigger, ui, recovery in state_rows:
        out.append(f"| `{state}` | {safe(ui)} | {safe(recovery)} |")
    out.append("")
    out.append("### 5.4 Aturan bisnis\n")
    for item in screen["accept"]:
        out.append(f"- {item}")
    for item in _kind_business_rules(kind):
        out.append(f"- {item}")
    out.append("")

    # 6
    out.append("## 6. Langkah implementasi\n")
    out.append("### Fase 0 — Recon (wajib)\n")
    out.append(f"1. Baca PRD `.docs/screens/{folder}/{slug}.md` dan skill ini sampai selesai.")
    out.append(f"2. Tinjau implementasi referensi `{ex['class']}`; catat komponen UI, state, dan panggilan API yang sudah ada.")
    out.append(f"3. Verifikasi route di konfigurasi router: {route_badge}.")
    out.append("4. Verifikasi endpoint ke backend: " + _sentence(_endpoint_summary(rows)))
    out.append("5. Cek tabel/kolom di `DATABASE.md`; jangan mengarang kolom.\n")
    out.append("### Fase 1 — Navigasi & guard\n")
    out.append("1. Pastikan route dan parameter/extra sesuai. Jangan menambah route baru tanpa mendaftarkannya di konfigurasi router.")
    out.append(f"2. Terapkan guard: {guard_text(screen['auth'])}")
    out.append("3. Pastikan back tidak mengulang submit dan tidak kehilangan input tanpa konfirmasi.\n")
    out.append("### Fase 2 — UI scaffold\n")
    out.append("1. Susun layout sesuai blueprint PRD §5; gunakan komponen UI yang sudah ada bila cocok.")
    out.append("2. Gunakan token desain (warna, tipografi, spacing) dan lokalisasi yang konsisten.")
    out.append("3. Pastikan layout tidak overflow di 320 px dan aman terhadap keyboard/safe area.\n")
    out.append("### Fase 3 — State & data\n")
    fase3 = [
        "Implementasikan state: " + ", ".join(code(s[0]) for s in state_rows[:10]) + ".",
        "Panggil API lewat repository/data source; jangan dari siklus render UI.",
        "Simpan state minimal yang diperlukan; jangan menduplikasi sumber kebenaran.",
    ]
    if flags.get("pagination"):
        fase3.append("Implementasikan pagination: simpan `currentPage`/`hasMore`, reset saat refresh.")
    if flags.get("timer"):
        fase3.append("Kelola timer/polling: mulai setelah layar siap, hentikan di `dispose`/background.")
    if flags.get("camera"):
        fase3.append("Kelola lifecycle kamera dan dispose controller; tangani izin ditolak.")
    for index, line in enumerate(fase3, 1):
        out.append(f"{index}. {line}")
    out.append("")
    out.append("### Fase 4 — Interaksi & feedback\n")
    out.append(f"1. Hubungkan aksi utama: {cta}.")
    out.append("2. Disable aksi saat proses; tampilkan progress/SnackBar sukses.")
    out.append("3. Petakan 422 per field; 401 logout; 403/404/5xx pesan yang sesuai.\n")
    out.append("### Fase 5 — Kualitas\n")
    out.append("1. Tambahkan semantics/label untuk ikon dan kontrol non-teks.")
    out.append("2. Uji text scale 200%, mode gelap, dan landscape.")
    out.append("3. Tambahkan widget/unit test sesuai PRD §19.\n")

    # 7
    out.append("## 7. Kontrak API (jangan diubah tanpa update dokumen)\n")
    if rows:
        out.append("| Method | Path | Controller | Auth | Kegunaan |")
        out.append("|---|---|---|---|---|")
        for row in rows:
            out.append(
                f"| `{row['method']}` | `{row['path']}` | `{row['controller']}` | "
                f"{row['auth']} | {safe(row['purpose'])} |"
            )
        out.append("")
        request_rows = _server_fields(rows)
        if request_rows:
            out.append("**Field request yang terbaca dari controller:**\n")
            out.append("| Field | Aturan | Endpoint |")
            out.append("|---|---|---|")
            for name, rule, path in request_rows[:16]:
                out.append(f"| `{name}` | `{rule}` | `{path}` |")
            out.append("")
        out.append("Envelope: `{\"status\":\"success\",\"message\":\"...\",\"data\":{}}`; "
                   "periksa controller untuk variasi `success`/`error_code`.\n")
    else:
        out.append("Tidak ada API jaringan. Gunakan penyimpanan lokal atau data `extra`.\n")

    # 8
    out.append("## 8. Data & model\n")
    if tables:
        out.append("| Tabel | Kolom kunci |")
        out.append("|---|---|")
        for table, _role in tables:
            out.append(f"| `{table}` | {table_columns(table, 8)} |")
        out.append("")
    else:
        out.append("Tidak ada tabel yang dipakai langsung.\n")
    if ex["models"]:
        out.append("| Model | Field kunci |")
        out.append("|---|---|")
        for model in ex["models"]:
            fields = ", ".join(code(name) for name, _ in model["fields"][:8]) or "Tidak terdeteksi"
            out.append(f"| `{model['class']}` | {fields} |")
        out.append("")

    # 9
    out.append("## 9. State minimum\n")
    out.append("| State | Harus ada |")
    out.append("|---|---|")
    for state, _trigger, _ui, _recovery in state_rows[:14]:
        out.append(f"| `{state}` | Ya |")
    out.append("")

    # 10
    out.append("## 10. Guardrail\n")
    for item in _guardrails(kind):
        out.append(f"- {item}")
    out.append("")

    # 11
    out.append("## 11. Definition of Done\n")
    out.append("- [ ] Semua elemen UI di §5.2 tampil dan berfungsi.")
    out.append("- [ ] Semua state di §5.3/§9 tertangani, termasuk error dan offline.")
    out.append("- [ ] Kontrak endpoint dan tabel tidak berubah tanpa update PRD/peta endpoint.")
    out.append("- [ ] Tidak ada panggilan API langsung dari siklus render UI atau pembuatan HTTP client baru di komponen UI.")
    out.append("- [ ] Nominal/stok/status berasal dari backend.")
    out.append("- [ ] 401 membersihkan token dan mengarahkan ke Landing/login.")
    out.append("- [ ] Tidak ada overflow di 320 px, landscape, dan text scale 200%.")
    out.append("- [ ] Mode terang/gelap terbaca dan target sentuh ≥48 dp.")
    out.append("- [ ] Analisis statis/lint sesuai toolchain target bersih.")
    out.append("- [ ] Test happy path + minimal satu error path lulus.")
    out.append("- [ ] PRD dan SKILL diperbarui bila ada perubahan.")
    out.append("")

    # 12
    out.append("## 12. Verifikasi\n")
    out.append("```text")
    out.append("# verifikasi implementasi")
    out.append(f"- Pastikan komponen/layar referensi `{ex['class']}` dan perilakunya sesuai")
    out.append("- Jalankan analisis statis/lint sesuai toolchain target")
    out.append("- Jalankan test otomatis sesuai platform target")
    if rows:
        first_path = rows[0]["path"].split("{")[0]
        out.append("")
        out.append("# verifikasi backend (opsional)")
        out.append(f"- Cek route API: {first_path}")
    if tables:
        out.append("")
        out.append("# verifikasi database (opsional)")
        out.append(f"- Cek tabel: {tables[0][0]}")
    out.append("```\n")
    out.append("Uji manual minimum: happy path, loading, empty, error jaringan, 401, 422, "
               "double-tap submit, 320 px, mode gelap, dan text scale 200%.\n")

    # 13
    out.append("## 13. Jebakan & gap\n")
    if screen["gaps"]:
        for gap in screen["gaps"]:
            out.append(f"- {gap}")
    else:
        out.append("- Tidak ada gap khusus; tetap hormati kontrak backend.")
    if flags.get("direct_dio"):
        out.append("- Layar memakai HTTP client bersama langsung. Refactor ke repository harus menjaga kontrak dan error mapping.")
    if screen["route"] == "-":
        out.append("- Layar belum terdaftar di `AppRouter`; jangan menganggapnya dapat dijangkau lewat deep link.")
    out.append("- Jangan mengubah nama endpoint/konstanta tanpa memperbarui PRD dan peta endpoint.")
    out.append("")

    # 14
    out.append("## 14. Handoff\n")
    out.append(f"- **Status awal:** {status_text(screen)}")
    out.append(f"- **Perubahan terakhir:** regenerasi detail {VERIFIED}.")
    out.append(f"- **Pemilik berikutnya:** baca PRD §20 untuk gap dan §19 untuk test plan.")
    out.append("- **Jangan menutup pekerjaan** tanpa menjalankan §12 dan memenuhi §11.")
    out.append("")
    return "\n".join(out)


# ---------------------------------------------------------------------------
# Helper isi
# ---------------------------------------------------------------------------

def _mermaid(text: str) -> str:
    return (
        str(text)
        .replace("`", "")
        .replace('"', "'")
        .replace("[", "(")
        .replace("]", ")")
        .replace("\n", " ")
    )[:90]


def _sentence(text: str) -> str:
    text = str(text).strip()
    if not text:
        return ""
    return text if text[-1] in ".!?…" else text + "."


def _short(text: str, limit: int) -> str:
    text = str(text).strip()
    return text if len(text) <= limit else text[: limit - 1].rstrip() + "…"


def _inline_list(values) -> str:
    values = [v for v in values if v]
    if not values:
        return "Tidak terdeteksi"
    return ", ".join(code(v) for v in values)


def _field_role(name: str) -> str:
    lower = name.lower()
    if any(k in lower for k in ("loading", "fetching", "processing")):
        return "Menandai proses muat/aksi."
    if any(k in lower for k in ("submitting", "saving", "sending")):
        return "Mencegah submit ganda."
    if "error" in lower:
        return "Menyimpan pesan kegagalan."
    if "controller" in lower:
        return "Controller/state input; wajib dibersihkan saat tidak dipakai."
    if any(k in lower for k in ("selected", "filter", "sort", "category", "query")):
        return "Filter/sortir lokal."
    if any(k in lower for k in ("page", "scroll", "hasmore")):
        return "Kontrol posisi/paginasi."
    if any(k in lower for k in ("callactive", "callstatus", "callstate", "incall", "call_token", "calltoken")):
        return "Status panggilan; sinkronkan dengan sinyal server."
    if any(k in lower for k in ("camera", "tts", "recognizer", "timer")):
        return "Resource native; wajib dibersihkan saat layar/komponen ditutup."
    if any(k in lower for k in ("data", "items", "list", "model", "profile", "orders")):
        return "Data yang ditampilkan."
    return "State lokal layar."


def _table_access(rows) -> str:
    methods = {r["method"] for r in rows if r["method"] != "ANY"}
    if not methods:
        return "Tidak pasti"
    if methods <= {"GET"}:
        return "Baca"
    return "Baca/tulis (indikasi)"


def _backend_for(row):
    controller = row["controller"]
    if "@" not in controller:
        return {"found": False, "fields": [], "response_keys": [], "messages": [], "source": ""}
    cls, method = controller.split("@", 1)
    return extract_backend(cls, method)


def _server_fields(rows):
    out = []
    seen = set()
    for row in rows:
        backend = _backend_for(row)
        for name, rule in backend["fields"]:
            key = (name, rule, row["path"])
            if key in seen:
                continue
            seen.add(key)
            out.append((name, rule, row["path"]))
    return out


def _endpoint_summary(rows) -> str:
    if not rows:
        return "tidak ada endpoint jaringan"
    return "; ".join(f"{r['method']} {r['path']}" for r in rows[:6]) + (" …" if len(rows) > 6 else "")


def _table_summary(tables) -> str:
    if not tables:
        return "tidak ada tabel langsung"
    return ", ".join(t for t, _ in tables)


def _state_rows(screen, kind, flags, rows):
    rows_out = []

    def add(state, trigger, ui, recovery):
        if any(state.lower() == existing[0].lower() for existing in rows_out):
            return
        rows_out.append((state, trigger, ui, recovery))

    add("initial", "Layar dibuka", "Kerangka/placeholder awal", "Muat data")
    add("loading", "Request berjalan", "Skeleton/spinner; aksi utama disabled", "Tunggu atau retry saat timeout")
    add("content", "Data tersedia", "Render konten utama", "—")
    if kind in {"list", "detail", "form", "content", "chat", "order", "payment"}:
        add("empty", "Data kosong", "Empty state dengan penjelasan + CTA", "Refresh atau aksi lanjutan")
    add("error", "Request gagal", "Pesan ramah + tombol coba lagi", "Retry")
    if "sanctum" in screen["auth"].lower() or "guest" in screen["auth"].lower():
        add("unauthorized", "HTTP 401", "Sesi berakhir; arahkan login/Landing", "Login ulang")
    add("offline", "Koneksi putus", "Banner/empty offline", "Coba lagi saat online")
    if any(r["method"] in {"POST", "PUT", "PATCH", "DELETE"} for r in rows) or kind in {"form", "auth", "order", "payment"}:
        add("submitting", "Pengguna menekan aksi utama", "Tombol disabled + progress", "Selesai atau tampilkan error")
    if flags.get("refresh_indicator"):
        add("refreshing", "Pull to refresh", "Spinner di atas konten", "Selesai; reset halaman")
    if flags.get("pagination"):
        add("pagination", "Scroll mendekati akhir", "Loader footer", "Muat halaman berikutnya")
    if flags.get("camera"):
        add("permission", "Izin kamera belum diberikan", "Penjelasan + tombol buka pengaturan", "Izin diberikan")
    if kind == "payment":
        add("expired", "Deadline pembayaran lewat", "Status kedaluwarsa + instruksi", "Muat ulang/buat kode baru")
    if "guest" in screen["auth"].lower():
        add("guest", "Guest menekan aksi privat", "prompt autentikasi tamu", "Login")
    for state in screen["states"]:
        add(state, "Kondisi domain", behavior_for(state), "Ikuti aksi pemulihan pada pesan")
    return rows_out


def _kind_business_rules(kind: str) -> list[str]:
    common = {
        "payment": [
            "Nominal final dan status pembayaran berasal dari backend; jangan menghitung ulang di client.",
            "Jangan menandai lunas berdasarkan callback UI; lakukan polling/refresh status resmi.",
            "Tampilkan deadline dari server dan tangani status kedaluwarsa.",
        ],
        "order": [
            "Stok, harga, dan ketersediaan paket divalidasi backend saat membuat pesanan.",
            "Cegah submit ganda; satu tap menghasilkan satu pesanan.",
            "Jangan mengirim total/harga final dari client sebagai sumber kebenaran.",
        ],
        "auth": [
            "Jangan menyimpan password/PIN plaintext; gunakan secure storage untuk token.",
            "Terapkan rate limit/lockout dan jangan membocorkan apakah akun terdaftar.",
            "OTP/challenge memiliki masa berlaku; tangani kedaluwarsa.",
        ],
        "chat": [
            "Pesan gagal kirim harus dapat dicoba ulang tanpa menduplikasi pesan.",
            "Lampiran divalidasi tipe/ukuran; jangan unggah file tak dikenal.",
            "Guest hanya boleh memakai alur guest yang didukung backend.",
        ],
        "scanner": [
            "Scanner hanya menghasilkan file; unggah dan verifikasi dilakukan alur terpisah.",
            "Jangan menyimpan frame kamera setelah layar ditutup.",
            "Sediakan alternatif unggah bila kamera tidak tersedia.",
        ],
        "list": [
            "Pagination tidak boleh meminta halaman yang sama berulang.",
            "Refresh mereset halaman dan daftar.",
            "Hapus item secara optimistis hanya bila aksi reversibel; jika tidak, tunggu respons.",
        ],
        "form": [
            "Validasi client untuk UX; validasi final di backend.",
            "Pertahankan input saat 422/network error.",
        ],
        "webview": [
            "Validasi URL sebelum membuka; hanya izinkan domain pembayaran resmi.",
            "Tangani back, error halaman, dan jangan menyimpan kredensial di WebView.",
        ],
        "detail": [
            "Resource yang tidak ditemukan harus menampilkan 404, bukan crash.",
            "Data harus dimuat ulang saat kembali dari layar yang mengubah resource.",
        ],
        "content": [
            "Konten statis tetap harus memiliki loading/error state bila berasal dari API.",
        ],
    }
    return common.get(kind, ["Ikuti kontrak backend dan jangan mengarang data."])


def _screen_failures(kind, flags, screen):
    items = [
        "Timeout jaringan → tampilkan pesan koneksi dan tombol coba lagi.",
        "Respons tidak sesuai envelope → tampilkan error umum, catat status code.",
        "401 → bersihkan token dan arahkan ke Landing/login.",
        "403 → tampilkan akses ditolak tanpa logout otomatis.",
        "5xx → error server + retry; jangan menampilkan stack trace.",
    ]
    if kind == "form":
        items.append("422 → petakan `errors` ke field; fokus ke field pertama.")
    if kind == "payment":
        items += [
            "Kedaluwarsa → tampilkan instruksi muat ulang; jangan minta bayar ke rekening lama.",
            "Status pending terlalu lama → sediakan refresh manual.",
        ]
    if kind == "chat":
        items += [
            "Koneksi real-time putus → tampilkan status reconnect dan coba lagi.",
            "Kirim pesan gagal → tandai pesan gagal dan sediakan retry.",
        ]
    if kind == "scanner":
        items += [
            "Izin kamera ditolak → jelaskan dan buka pengaturan.",
            "Kamera tidak tersedia → tawarkan unggah dari galeri.",
        ]
    if kind == "webview":
        items += [
            "Halaman gagal dimuat → tampilkan error + retry/tutup.",
            "URL tidak valid → jangan buka WebView.",
        ]
    if kind == "list":
        items += [
            "Halaman berikutnya gagal → pertahankan item lama dan tampilkan retry footer.",
        ]
    for gap in screen["gaps"]:
        items.append(f"Gap: {gap}")
    return unique(items)


def _security_rules(kind, flags, screen):
    items = [
        "Token hanya di secure storage; jangan di penyimpanan lokal atau log.",
        "Jangan menampilkan stack trace, query database, atau detail internal pada pengguna.",
        "Jangan mengirim PII ke analytics/crash report.",
        "Validasi kepemilikan resource di backend; client tidak boleh menentukan `user_id`.",
    ]
    if kind in {"auth", "form"} or "profile" in screen["slug"]:
        items.append("Data identitas (nama, email, telepon, alamat, KTP, selfie) adalah PII; batasi tampilan dan log.")
    if kind == "payment":
        items += [
            "Nominal dan status pembayaran tidak boleh dipercaya dari client.",
            "Jangan menyimpan nomor VA/QR/kartu di log atau clipboard tanpa aksi eksplisit.",
            "Validasi domain WebView pembayaran; tolak URL di luar gateway resmi.",
        ]
    if kind == "chat":
        items += [
            "Isi pesan dan lampiran bersifat privat; jangan log isi pesan.",
            "Validasi tipe/ukuran lampiran sebelum upload.",
        ]
    if kind == "scanner":
        items += [
            "Frame kamera tidak boleh disimpan/diunggah otomatis tanpa aksi pengguna.",
            "Bersihkan file sementara setelah upload/dibatalkan.",
        ]
    if "app-lock" in screen["slug"] or "unlock" in screen["slug"]:
        items.append("Pertimbangkan proteksi screenshot/task switcher untuk layar kunci. [Usulan]")
    if flags.get("guest_prompt"):
        items.append("Guest tidak boleh mengirim Bearer token kosong atau mengakses resource privat.")
    return unique(items)


def _a11y_rules(kind, flags):
    items = [
        "Semua ikon/tombol non-teks memiliki label semantik.",
        "Target sentuh minimal 48×48 dp; jangan hanya mengandalkan ikon kecil.",
        "Kontras teks memenuhi WCAG AA pada mode terang dan gelap.",
        "Urutan fokus screen reader mengikuti urutan visual.",
        "Text scale 200% tidak memotong label atau tombol utama.",
        "Error form diumumkan dan terhubung ke field terkait.",
        "Hormati reduce-motion; animasi tidak boleh menghalangi interaksi.",
    ]
    if kind == "scanner":
        items += [
            "Sediakan panduan suara/haptic untuk posisi dokumen.",
            "Sediakan alternatif unggah dari galeri.",
        ]
    if kind == "payment":
        items += [
            "Tombol salin memiliki label yang menyebut apa yang disalin.",
            "Countdown/deadline diumumkan tanpa mengganggu screen reader.",
        ]
    if kind == "chat":
        items += [
            "Bubble pesan menyertakan pengirim/waktu pada semantics.",
            "Status terkirim/gagal terbaca oleh screen reader.",
        ]
    if kind == "auth":
        items += [
            "PIN pad memiliki label angka dan tombol hapus.",
            "Field password memiliki tombol tampil/sembunyikan berlabel.",
        ]
    if "list" in kind:
        items.append("Item daftar memiliki label ringkas yang mencakup aksi utamanya.")
    return items


def _performance_rules(kind, flags, ex):
    items = [
        "Gunakan `CachedNetworkImage`/cache yang ada untuk gambar jaringan.",
        "Hindari pekerjaan berat di `build()`; pindahkan parsing/format ke provider/util.",
        "Dispose controller, timer, dan subscription di `dispose`.",
    ]
    if flags.get("pagination"):
        items.append("Muat halaman berikutnya hanya saat mendekati akhir; cegah request paralel.")
    if flags.get("refresh_indicator"):
        items.append("Pull-to-refresh mereset halaman dan tidak menumpuk request.")
    if flags.get("timer"):
        items.append("Hentikan polling/timer saat app background; mulai lagi saat resume.")
    if flags.get("camera"):
        items.append("Batasi resolusi/frame analysis agar UI tetap responsif; dispose kamera.")
    if kind == "chat":
        items.append("Jangan memuat seluruh riwayat sekaligus; gunakan pagination/cursor.")
    if kind == "list":
        items.append("Gunakan `ListView.builder`/sliver agar item dibuat lazy.")
    if kind == "webview":
        items.append("Tampilkan progress loading dan batasi pemuatan ulang yang tidak perlu.")
    if not flags.get("shared_prefs") and not flags.get("secure_storage"):
        items.append("Tidak ada cache lokal terdeteksi; jangan menambah cache tanpa kebijakan kedaluwarsa.")
    return unique(items)


def _analytics_rows(screen, kind):
    slug = screen["slug"].replace("-", "_")
    rows = [
        (f"screen_view_{slug}", "Layar dibuka", "screen, route, auth"),
        (f"{slug}_cta_tap", "Aksi utama ditekan", "cta, state"),
        (f"{slug}_success", "Aksi utama berhasil", "duration_ms"),
        (f"{slug}_failure", "Request/aksi gagal", "error_code, status"),
    ]
    if kind == "list":
        rows.append((f"{slug}_filter_applied", "Filter/sortir diterapkan", "filter_count, sort"))
        rows.append((f"{slug}_pagination", "Halaman berikutnya dimuat", "page"))
    if kind == "payment":
        rows.append((f"{slug}_copy", "Nomor/QR disalin", "method"))
        rows.append((f"{slug}_expired", "Pembayaran kedaluwarsa", "method"))
    if kind == "chat":
        rows.append((f"{slug}_message_sent", "Pesan terkirim", "type, has_attachment"))
        rows.append((f"{slug}_reconnect", "Koneksi real-time dipulihkan", "duration_ms"))
    if kind == "scanner":
        rows.append((f"{slug}_capture", "Foto diambil", "doc_type, success"))
    if kind == "form":
        rows.append((f"{slug}_validation_failed", "Validasi gagal", "field_count"))
    return rows


def _test_plan(screen, kind, flags, rows):
    tests = []
    counter = 0

    def add(scenario, steps, expected, type_="Manual"):
        nonlocal counter
        counter += 1
        tests.append({
            "id": f"TC-{counter:02d}",
            "type": type_,
            "scenario": scenario,
            "steps": steps,
            "expected": expected,
        })

    add("Happy path", f"Buka layar melalui: {screen['entry']}", "Elemen utama tampil; request sukses; tidak ada error.", "Widget")
    add("Route/parameter", f"Buka {screen['route']} dengan parameter sesuai", "Parameter terbaca; layar menampilkan data yang benar.")
    add("Loading", "Buka layar dengan jaringan lambat", "Skeleton/spinner tampil; aksi utama disabled.")
    if kind in {"list", "detail", "form", "content", "chat", "order", "payment"}:
        add("Empty", "Gunakan akun/data tanpa item", "Empty state tampil dengan CTA yang sesuai.")
    add("Error server", "Mock respons 500", "Pesan error + tombol coba lagi; aplikasi tidak crash.")
    if "sanctum" in screen["auth"].lower() or "guest" in screen["auth"].lower():
        add("Sesi habis", "Gunakan token kedaluwarsa/401", "Token dibersihkan; diarahkan ke Landing/login.")
    add("Akses ditolak", "Mock respons 403", "Pesan akses ditolak; tidak logout otomatis.")
    add("Offline", "Matikan jaringan lalu muat/aksi", "Pesan offline + retry; data lama (bila ada) tidak hilang.")
    add("Double submit", "Tekan aksi utama cepat dua kali", "Hanya satu request; tombol disabled saat proses.", "Widget")
    add("Layar kecil", "Uji lebar 320 px dan landscape", "Tidak ada overflow; tombol tetap terjangkau.")
    add("Mode gelap", "Aktifkan dark mode sistem", "Semua teks/komponen terbaca; tidak ada warna hardcode yang pecah.")
    add("Aksesibilitas", "Aktifkan screen reader dan text scale 200%", "Label terbaca; tidak ada teks terpotong.")
    if kind == "form" or ex_kind_form(screen):
        add("Validasi kosong", "Submit form kosong", "Error inline per field; fokus ke field pertama.", "Widget")
        add("Validasi 422", "Mock 422 dengan errors", "Error dipetakan ke field; input dipertahankan.")
    if kind == "detail" or kind == "order":
        add("404", "Buka resource yang tidak ada", "Halaman not found + tombol kembali.")
    if kind == "list" or flags.get("pagination"):
        add("Pagination", "Scroll sampai akhir daftar", "Halaman berikutnya dimuat sekali; tidak ada duplikasi.")
        add("Refresh", "Tarik untuk refresh", "Daftar/halaman direset dan data terbaru tampil.")
    if kind == "payment":
        add("Kedaluwarsa", "Biarkan deadline lewat", "Status kedaluwarsa + instruksi muat ulang.")
        add("Polling status", "Simulasikan status berubah menjadi lunas", "UI memperbarui status dari backend, bukan asumsi lokal.")
    if kind == "scanner":
        add("Izin kamera", "Tolak izin kamera", "Penjelasan + tombol buka pengaturan; tidak crash.")
        add("Dispose kamera", "Keluar saat kamera aktif", "Controller dihentikan; tidak ada error lifecycle.", "Widget")
    if kind == "webview":
        add("Gagal muat", "Buka URL yang gagal", "Halaman error + retry/tutup.")
    if kind == "chat":
        add("Reconnect", "Putuskan jaringan saat chat terbuka", "Status reconnect tampil; pesan dapat dikirim ulang.")
        add("Lampiran", "Kirim file tipe/ukuran tidak valid", "Ditolak dengan pesan jelas; tidak crash.")
    if kind == "auth":
        add("Kredensial salah", "Masukkan kode/PIN salah", "Error jelas, tidak membocorkan detail, dapat coba lagi.")
    if "lokal" in screen["auth"].lower():
        add("Persistensi lokal", "Ubah preferensi lalu restart app", "Preferensi tetap tersimpan.")
    add("Regresi fitur terkait", "Buka layar terkait setelah aksi", "Navigasi/state tidak rusak dan data konsisten.")
    return tests


def ex_kind_form(screen):
    return any(word in screen["slug"] for word in ("checkout", "edit", "profile-field", "reset", "forgot", "two-factor", "otp", "security-question"))


def _risk_rows(screen, kind, flags):
    risks = []
    if screen["gaps"]:
        risks.append((screen["gaps"][0], "Sedang", "Tinggi", "Tangani gap sebelum menganggap layar selesai."))
    if flags.get("direct_dio"):
        risks.append(("Panggilan API tersebar di widget", "Sedang", "Sedang", "Refactor bertahap ke repository/provider."))
    if "guest" in screen["auth"].lower():
        risks.append(("Guest memanggil endpoint privat", "Sedang", "Tinggi", "Guard di UI dan interceptor; uji 401/403."))
    if kind == "payment":
        risks.append(("Status pembayaran tidak sinkron", "Sedang", "Tinggi", "Polling/refresh status resmi; jangan simpulkan dari UI."))
    if kind == "chat":
        risks.append(("Pesan duplikat/gagal saat reconnect", "Sedang", "Sedang", "Idempotensi/retry dan tandai pesan gagal."))
    if kind == "scanner":
        risks.append(("Kamera tidak di-dispose", "Sedang", "Sedang", "Lifecycle + dispose; uji keluar/masuk layar."))
    if kind == "webview":
        risks.append(("URL pembayaran tidak valid", "Rendah", "Tinggi", "Whitelist domain dan validasi URL."))
    if "lokal" in screen["auth"].lower():
        risks.append(("Preferensi tidak tersinkron", "Tinggi", "Rendah", "Dokumentasikan sebagai lokal; jangan klaim sync."))
    if not risks:
        risks.append(("Regresi UI saat refactor", "Sedang", "Sedang", "Widget test + golden test untuk state utama."))
    return risks[:5]


def _dependency_rows(screen, rows, tables, ex):
    deps = []
    for row in rows:
        deps.append(("Endpoint", f"{row['method']} {row['path']}", row["controller"]))
    for table, _role in tables:
        deps.append(("Database", table, "Jangan query langsung dari klien."))
    for provider in ex["providers"]:
        deps.append(("Provider", provider, find_provider_file(provider) or "File tidak terdeteksi"))
    if screen["route"] != "-":
        deps.append(("Route", screen["route"], "Terdaftar di konfigurasi router aplikasi."))
    else:
        deps.append(("Route", "tidak terdaftar", "Layar belum dapat dijangkau lewat deep link."))
    return deps[:20]


def _guardrails(kind):
    items = [
        "Jangan mengarang endpoint, parameter, atau kolom database.",
        "Jangan membuat HTTP client baru di komponen UI; gunakan data source/repository bersama.",
        "Jangan memanggil API di `build()` atau setiap rebuild.",
        "Jangan menyimpan token/password/PIN di penyimpanan lokal atau log.",
        "Jangan menampilkan stack trace/pesan database ke pengguna.",
        "Jangan menambah dependensi baru tanpa alasan dan persetujuan.",
        "Jangan mengubah route/parameter tanpa memperbarui konfigurasi router dan dokumen.",
        "Jangan menghapus test yang ada untuk membuat build lulus.",
    ]
    if kind == "payment":
        items.append("Jangan menghitung total/status pembayaran di client.")
    if kind == "scanner":
        items.append("Jangan menyimpan/mengunggah frame kamera otomatis.")
    if kind == "chat":
        items.append("Jangan menandai pesan terkirim sebelum server mengonfirmasi.")
    return items
