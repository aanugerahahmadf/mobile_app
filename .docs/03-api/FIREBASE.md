# Firebase

## 1. Status per layanan

| Layanan | Dipakai? | Bukti / catatan |
|---|---|---|
| Firebase Core | Ya | `Firebase.initializeApp` di `main.dart`, dibungkus try/catch |
| Firebase Cloud Messaging | Ya | `NotificationService.initialize`, token FCM |
| Firebase Auth | Parsial | Hanya untuk Google Sign-In (`signInWithCredential`) guna memperoleh Firebase ID token |
| Firebase Analytics | Tidak | `firebase_analytics` ada di `pubspec` tetapi tidak dipanggil |
| Firebase Crashlytics | Tidak | Tidak ada inisialisasi/pemanggilan |
| Cloud Firestore | Tidak | `firestore.rules` menolak semua akses |
| Firebase Data Connect | Tidak | Generated `DataConnectGenerated` tidak dipakai |

## 2. Inisialisasi

```dart
bool firebaseReady = false;
try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  firebaseReady = true;
} catch (error, stack) {
  // Firebase tidak boleh menggagalkan start aplikasi.
}

if (firebaseReady) {
  try {
    await NotificationService.instance.initialize();
  } catch (_) {}
}
```

Prinsip: **Firebase opsional**. Tanpa Firebase, pengguna tetap bisa login, melihat katalog, dan memesan.

## 3. FCM

Alur:

1. `NotificationService` meminta izin notifikasi.
2. Mendapatkan token FCM.
3. Token dikirim ke `POST /notifications/fcm-token` (butuh login).
4. Backend menyimpan token di tabel `device_tokens`/`user_fcm_devices`.
5. Notifikasi masuk ditangani `FirebaseMessaging.onMessage` dan `onMessageOpenedApp`.
6. `NotificationService.onNavigate` memanggil `appRouter.go(route)`.

Aturan:

- Jangan mengirim token sebelum login.
- Tangani token refresh.
- Jangan menampilkan notifikasi duplikat saat app foreground.
- Validasi route deep link sebelum `go()`.

## 4. Firebase Auth untuk Google

`AuthProvider.googleLogin()`:

```text
Google Sign-In → GoogleAuthProvider.credential
→ FirebaseAuth.signInWithCredential
→ getIdToken(true)
→ POST /auth/google { firebase_id_token }
→ Laravel memverifikasi token dan menerbitkan Sanctum token
```

Firebase Auth **bukan** sumber sesi aplikasi. Sesi tetap Sanctum. Jika Firebase Auth gagal, login Google gagal meskipun Google Sign-In berhasil.

## 5. Yang tidak boleh dilakukan

- Menyimpan token FCM/Sanctum di log atau analytics.
- Mengirim data KTP, selfie, bukti transfer, nomor VA, atau isi chat ke Analytics.
- Memakai Firestore sebagai database cadangan tanpa persetujuan.
- Mengandalkan Firebase Auth sebagai pengganti Sanctum.
- Membuat inisialisasi Firebase blocking yang membuat layar putih jika config salah.

## 6. Konfigurasi platform

- Android: `google-services.json`, plugin Google Services.
- iOS: `GoogleService-Info.plist`, capability push notification.
- Web/desktop: konfigurasi `DefaultFirebaseOptions`.
- Linux: Firebase mungkin tidak siap; aplikasi harus tetap berjalan.

## 7. Risiko

| Risiko | Mitigasi |
|---|---|
| Firebase config tidak ada | Try/catch + fitur push dinonaktifkan |
| Token FCM tidak terdaftar | Kirim ulang setelah login |
| Deep link tidak valid | Fallback ke `/notifications` |
| Firebase Auth Google gagal | Tampilkan pesan, jangan set authenticated |
