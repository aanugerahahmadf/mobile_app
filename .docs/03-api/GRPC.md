# gRPC (Generated, Tidak Dipakai Runtime)

## 1. Status

Client gRPC **digenerate** tetapi tidak diimpor oleh layar produksi. Ini bukan transport aktif.

| Item | Nilai |
|---|---|
| Base URL | `GRPC_BASE_URL` (contoh `http://192.168.100.2:50051`) |
| Client | `lib/Core/Api/GrpcClient/GrpcV1Client.dart` |
| Generated | `lib/Core/Api/GrpcClient/GeneratedV1/Wedding/User/V1/` |
| Server | Tidak ditemukan implementasi gRPC user service di repo backend |
| Status | Legacy / eksperimen |

## 2. Service yang digenerate

`WeddingUserService` memiliki pesan untuk:

- Auth
- Cart
- Catalog
- Category
- CBIR
- Chat
- Home
- Notification
- Order
- Package
- Profile
- Review
- Search
- Voucher
- Wishlist

Keberadaan pesan tidak berarti endpoint-nya berfungsi. Backend aktif melayani REST `routes/api`.

## 3. Mengapa tidak dipakai

1. Arsitektur backend saat ini REST-first.
2. Tidak ada server gRPC user service yang terdaftar.
3. RPC membutuhkan HTTP/2 dan penanganan deadline/retry yang belum disiapkan.
4. Flutter web/mobile membutuhkan konfigurasi koneksi yang berbeda.
5. Menambah dua transport aktif meningkatkan biaya perawatan.

## 4. Jika ingin mengaktifkan

Langkah minimum:

1. Definisikan `.proto` sebagai sumber kontrak.
2. Implementasikan server gRPC (Laravel tidak native; perlu service terpisah, mis. Go/Node).
3. Tambahkan auth token metadata (`authorization: Bearer ...`).
4. Sediakan deadline dan retry terkontrol.
5. Buat adapter di `Core/Api/GrpcClient` yang memetakan error ke `Failure`.
6. Tambahkan feature flag; jangan mengganti REST sekaligus.
7. Dokumentasikan perbedaan kontrak dengan REST.

## 5. Aturan

- Jangan memakai generated gRPC di layar tanpa server yang teruji.
- Jangan menambahkan dependency gRPC baru ke layar.
- Jika fitur gRPC dihapus, hapus folder generated dan dependency terkait agar tidak menyesatkan.
