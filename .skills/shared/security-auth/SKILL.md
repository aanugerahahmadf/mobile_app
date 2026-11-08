---
name: security-auth
description: Aturan autentikasi dan keamanan aplikasi (Sanctum, 2FA, Google/Firebase, app lock, KYC, guest chat, upload, dan penanganan token).
---

# Skill: Security & Auth

## 1. Model autentikasi

- Sesi mobile memakai **Laravel Sanctum Bearer token**, bukan cookie.
- Token disimpan di `FlutterSecureStorage`, key `auth_token`.
- Firebase Auth **hanya** dipakai untuk memperoleh `firebase_id_token` pada login Google.
- Setelah verifikasi, backend menerbitkan token Sanctum; Firebase bukan sumber sesi.
- Login Facebook/Apple memakai endpoint backend masing-masing.
- 2FA memakai **challenge token** sementara; token sesi baru terbit setelah kode benar.

## 2. Alur 2FA

```text
POST /auth/...            → {requires_2fa: true, challenge_token}
POST /auth/two-factor/verify {challenge_token, code, method}
                          → {token, user}
```

Aturan:

- Jangan menyimpan `challenge_token` permanen.
- Challenge kedaluwarsa → kembali ke Landing.
- Recovery code dinormalisasi (huruf besar, format `abcd-efgh`).
- Jangan menampilkan detail internal saat kode salah.

## 3. Penyimpanan token

```dart
const storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
await storage.delete(key: 'auth_token'); // logout/401
```

- Jangan menulis token ke `SharedPreferences`, log, atau crash report.
- Saat logout, panggil `POST /logout` lalu hapus token lokal.
- Saat 401, hapus token dan reset state auth sebelum redirect.

## 4. App lock

- Status dan PIN diverifikasi backend (`/profile/app-lock*`).
- PIN disimpan sebagai hash; client tidak menyimpan PIN plaintext.
- Flag biometrik/wajah juga disimpan lokal per akun untuk pengalaman offline.
- Wajib mengunci ulang saat aplikasi resume dari background.
- Jangan menampilkan snapshot konten sensitif di task switcher.
- Sediakan fallback PIN/password bila biometrik gagal.

## 5. Data sensitif (KYC)

- Foto KTP, selfie, dan face scan adalah data pribadi.
- Jangan menampilkan nomor dokumen penuh di UI publik.
- Jangan mengirim path file ke log/analytics.
- Upload hanya lewat endpoint terautentikasi.
- Tampilkan alasan penolakan AI secara umum, tanpa membocorkan model internal.
- Hapus file sementara setelah upload selesai.

## 6. Guest mode

- Guest tidak memiliki token; jangan memanggil endpoint privat.
- Guest chat memakai `/messages/guest/*` dengan throttle `guest-chat`.
- Guest tidak boleh mengakses inbox pengguna lain.
- Setelah login, migrasikan/perbarui state guest dengan hati-hati.

## 7. Upload dan izin

- Minta izin kamera/mikrofon saat dibutuhkan, bukan saat startup.
- Jelaskan alasan izin sebelum dialog sistem.
- Tangani `permanentlyDenied` dengan tautan ke pengaturan.
- Validasi tipe file di client **dan** server.
- Jangan mempercayai MIME dari nama file saja.

## 8. Endpoint publik vs privat

Publik (contoh): legal, region, settings, CBIR health, guest chat.

Privat: katalog (saat ini), cart, checkout, favorit, chat login, profil, keamanan, notifikasi, voucher.

Jika ingin membuka katalog untuk guest, ubah backend secara eksplisit; jangan hanya menghapus header Authorization di client.

## 9. Rate limit & abuse

- Hormati 429 dan tampilkan cooldown.
- Jangan retry OTP/login tanpa jeda.
- Batasi ukuran upload.
- Laporkan konten lewat endpoint laporan, bukan chat bebas.

## 10. Checklist

- [ ] Token hanya di secure storage.
- [ ] Logout mencabut token server + lokal.
- [ ] 401 menangani redirect dengan benar.
- [ ] 2FA tidak menyimpan challenge permanen.
- [ ] Data KYC tidak masuk log/analytics.
- [ ] Guest tidak memanggil endpoint privat.
- [ ] Izin runtime diminta tepat waktu.
- [ ] Tidak ada client secret di aplikasi.
- [ ] Endpoint sensitif memiliki throttle.
