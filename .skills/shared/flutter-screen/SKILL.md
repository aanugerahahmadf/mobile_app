---
name: flutter-screen
description: Pola implementasi layar Flutter di aplikasi ini (Riverpod, go_router, DioClient, l10n, state loading/error, guest mode, dan responsive layout).
---

# Skill: Implementasi Layar Flutter

Gunakan saat membuat atau mengubah layar di `lib/Features/**/Presentation/Screens/**`.

## 1. Struktur folder yang berlaku

```text
lib/Features/<Fitur>/
├── Data/
│   ├── Models/<Model>/<Model>.dart
│   └── <Repository>Impl/<Repository>Impl.dart
├── Domain/
│   └── <Repository>/<Repository>.dart
└── Presentation/
    ├── Providers/<Provider>/<Provider>.dart
    ├── Screens/<Layar>/<Layar>Screen.dart
    └── Widgets/<Widget>/<Widget>.dart
```

Jangan memindahkan file ke struktur baru tanpa alasan kuat. Banyak import bergantung pada path ini.

## 2. Aturan layar

1. **Satu layar = satu widget utama** dengan sufiks `Screen`.
2. Gunakan `ConsumerWidget`/`ConsumerStatefulWidget`; akses state lewat `ref.watch`/`ref.read`.
3. Jangan memanggil `Dio` langsung dari `build()`. Panggilan jaringan dilakukan di provider/notifier atau repository.
4. Jangan menyimpan `BuildContext` di provider.
5. Selalu cek `mounted` sebelum `setState`/`context` setelah `await`.
6. Gunakan `AppLocalizations.of(context)!` untuk teks; jangan hardcode bahasa di layar baru.
7. Gunakan widget bersama di `lib/Core/Widgets/`:
   - `AppButton`, `AppShimmer`, `AppEmptyState`, `AppErrorState`, `AppSnackBar`, `AppNotification`, `GuestAuthPrompt`, `AppBreadcrumbs`.
8. Navigasi memakai `context.go` untuk pindah tab/root dan `context.push` untuk layar bertumpuk.
9. Validasi parameter route sebelum dipakai; jangan memaksa `!` pada nilai yang bisa null.
10. Hormati `SafeArea`, keyboard inset, dan lebar minimum 320 px.

## 3. State standar

Setiap layar data harus memiliki minimal:

```dart
sealed class ScreenState {}
class ScreenLoading extends ScreenState {}
class ScreenData extends ScreenState { final Data data; }
class ScreenEmpty extends ScreenState {}
class ScreenError extends ScreenState { final String message; }
```

Jika proyek memakai `StateNotifier` dengan field `loading/error`, tetap bedakan:

- `loading` pertama kali → skeleton.
- `loading` refresh → pertahankan data lama + indikator kecil.
- `error` → tampilkan pesan + tombol coba lagi.
- `empty` → empty state dengan aksi lanjutan.
- `unauthorized` → bersihkan token, arahkan ke `/landing`.

## 4. Guest mode

- Cek `guestModeProvider` dan `authProvider`.
- Jangan memanggil endpoint privat untuk guest.
- Tampilkan `GuestAuthPrompt` pada aksi yang membutuhkan akun.
- Setelah login, muat ulang data yang sebelumnya gagal.

## 5. Pola provider yang disarankan

```dart
final screenProvider = StateNotifierProvider.autoDispose<ScreenNotifier, ScreenState>((ref) {
  final repo = ref.watch(screenRepositoryProvider);
  return ScreenNotifier(repo);
});

class ScreenNotifier extends StateNotifier<ScreenState> {
  ScreenNotifier(this._repo) : super(ScreenLoading()) {
    load();
  }
  final ScreenRepository _repo;

  Future<void> load() async {
    state = ScreenLoading();
    try {
      final data = await _repo.fetch();
      state = data.isEmpty ? ScreenEmpty() : ScreenData(data);
    } catch (e) {
      state = ScreenError(LocalizedError.from(e));
    }
  }
}
```

## 6. Error mapping

Gunakan `DioClient.safeCall`/`LocalizedError` yang sudah ada. Pemetaan minimal:

| Status | UI |
|---|---|
| 401 | Logout lokal + redirect `/landing` |
| 403 | "Tidak punya akses" + kembali |
| 404 | "Data tidak ditemukan" |
| 422 | Tampilkan pesan validasi per field |
| 429 | "Terlalu banyak percobaan" + cooldown |
| 5xx | "Server sedang bermasalah" + retry |

## 7. Upload file

- Kompres gambar sebelum upload (`flutter_image_compress`).
- Gunakan `MultipartFile.fromFile`.
- Kirim field name yang sesuai controller (`avatar`, `photo`, `proof`, `file`, `face_photo`).
- Tangani progres dan batalkan bila layar dispose.
- Jangan menyimpan path file permanen; gunakan cache/temporary directory.

## 8. Checklist sebelum selesai

- [ ] Tidak ada panggilan API di `build()`.
- [ ] `mounted` dicek setelah `await`.
- [ ] Loading/empty/error/unauthorized ditangani.
- [ ] Teks memakai l10n.
- [ ] Tidak ada overflow 320 px.
- [ ] Route dan parameter sesuai `AppRouter`.
- [ ] `flutter analyze` bersih untuk file yang diubah.
- [ ] Test widget/unit untuk happy path dan satu error path.
