#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Sisipkan key yang hilang di app_id.arb.

Locale Indonesia adalah default DAN fallback aplikasi, jadi key yang hilang di
sini tampil dalam bahasa Inggris untuk semua pengguna — termasuk label filter
dan badge di halaman hasil CBIR (`packages`, `products`, `priceLowToHigh`,
`priceHighToLow`).

Disisipkan secara TEKSUAL sebelum brace penutup supaya seluruh isi file lain
tidak berubah byte satu pun.
"""

import io
import json
import os
import sys

ARB = os.path.join("lib", "l10n", "app_id.arb")

# Terjemahan. "Reset" mengikuti gaya `resetPassword` yang sudah ada
# ("Atur Ulang Kata Sandi"), dan panah naik/turun mengikuti `priceAsc`/`priceDesc`.
ADDITIONS = [
    ("packages", "Paket"),
    ("products", "Produk"),
    ("priceLowToHigh", "Harga \u2191"),
    ("priceHighToLow", "Harga \u2193"),
    ("enabled", "Aktif"),
    ("disabled", "Nonaktif"),
    ("reset", "Atur Ulang"),
    ("deletePrompt", "Anda yakin ingin menghapus %s?"),
    ("noMatchingItems", "Tidak ada item yang cocok"),
    ("forgotPin", "Lupa PIN?"),
    (
        "forgotPinConfirm",
        "Kode OTP akan dikirim ke email terdaftar Anda untuk memverifikasi "
        "identitas sebelum mengatur ulang kunci aplikasi. Lanjutkan?",
    ),
    ("emailNotFound", "Tidak ada email terdaftar di perangkat ini."),
    ("appLockReset", "Kunci aplikasi telah diatur ulang"),
]


def main() -> int:
    with io.open(ARB, encoding="utf-8") as fh:
        raw = fh.read()

    existing = json.loads(raw)
    todo = [(k, v) for k, v in ADDITIONS if k not in existing]

    if not todo:
        print("Semua key sudah ada. Tidak ada perubahan.")
        return 0

    marker = raw.rstrip()
    if not marker.endswith("}"):
        print("ERROR: format ARB tidak dikenali.")
        return 1

    body = marker[:-1].rstrip()
    # Buang koma menggantung di baris terakhir, kalau ada.
    if body.endswith(","):
        body = body[:-1]

    block = ",\n".join(
        '  {}: {}'.format(json.dumps(k, ensure_ascii=False), json.dumps(v, ensure_ascii=False))
        for k, v in todo
    )

    updated = body + ",\n" + block + "\n}\n"

    with io.open(ARB, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(updated)

    # Verifikasi hasilnya benar-benar JSON valid dan lengkap.
    after = json.load(io.open(ARB, encoding="utf-8"))
    en = json.load(io.open(os.path.join("lib", "l10n", "app_en.arb"), encoding="utf-8"))
    missing = sorted(
        {k for k in en if not k.startswith("@")} - {k for k in after if not k.startswith("@")}
    )

    print("Ditambahkan : {} key".format(len(todo)))
    print("Total id    : {}".format(len([k for k in after if not k.startswith("@")])))
    print("Masih kurang: {}".format(len(missing)))
    for k in missing:
        print("   -", k)

    return 0


if __name__ == "__main__":
    sys.exit(main())
