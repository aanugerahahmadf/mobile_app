# GraphQL (Hybrid Fallback)

## 1. Status

GraphQL **bukan transport utama** mobile. REST tetap menjadi kontrak resmi. GraphQL tersedia sebagai jalur hybrid/fallback dan dipakai secara internal oleh beberapa controller REST (mis. `CatalogController` mendelegasikan query ke Lighthouse).

| Item | Nilai |
|---|---|
| Endpoint | `POST /graphql` (di origin, **bukan** `/api/graphql`) |
| Server | Lighthouse GraphQL di Laravel |
| Client helper | `lib/Core/Api/GraphqlClient/GraphqlClient.dart` |
| Transport wrapper | `GraphqlTransport.dart` |
| Query strings | `GraphqlQueries.dart` |
| Dokumen schema | `lib/Core/Api/GraphqlClient/Documents/` |
| Auth | Header `Authorization: Bearer <token>` |
| Locale | Header `Accept-Language` |

## 2. Mengapa `/graphql`, bukan `/api/graphql`

`AppConfig.apiBaseUrl` berakhir dengan `/api`. Jika helper membentuk `${apiBaseUrl}/graphql`, request akan pergi ke `/api/graphql` dan gagal. Helper yang benar mengambil **origin** dari base URL, lalu menambahkan `/graphql`.

```dart
static String get endpointUrl => '${AppConfig.storageBaseHost}/graphql';
```

## 3. Header

```json
{
  "Content-Type": "application/json",
  "Accept": "application/json",
  "Authorization": "Bearer <token>",
  "Accept-Language": "id"
}
```

Jika token tidak ada (guest), jangan kirim header Authorization kosong.

## 4. Operasi yang tersedia di dokumen client

Folder `Documents/` memuat schema dan operasi untuk:

- Auth
- Cart
- Catalog
- Category
- CBIR
- Favorite
- Home
- Order
- Package
- Profile
- Review
- Search
- User
- Voucher

Contoh query penting:

- `catalogs(first, categoryId, featured, active, theme, color)`
- `catalog(id)`
- `homeData`
- `search(query)`
- `orders`
- `user`
- `vouchers`

## 5. Kapan boleh memakai GraphQL

Gunakan GraphQL hanya jika:

1. REST tidak menyediakan data yang dibutuhkan, dan
2. query sudah ada di dokumen client, dan
3. tim backend menyetujui kontraknya, dan
4. error/loading state tetap ditangani seperti REST.

Jangan:

- menambah query GraphQL baru tanpa update schema backend,
- memakai GraphQL untuk pembayaran/order mutation tanpa persetujuan,
- mencampur GraphQL dan REST untuk operasi tulis yang sama.

## 6. Contoh pemakaian

```dart
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../Core/Api/GraphqlClient/GraphqlClient.dart';
import '../../Core/Api/GraphqlClient/GraphqlQueries.dart';

final result = await GraphQLClientHelper.client.query(
  QueryOptions(
    document: gql(catalogsQuery),
    variables: {'first': 20, 'active': true},
    fetchPolicy: FetchPolicy.noCache,
  ),
);

if (result.hasException) {
  // map ke Failure / tampilkan error
}
final data = result.data?['catalogs']?['data'] as List? ?? [];
```

## 7. Perbedaan format

- GraphQL membungkus hasil dalam `data`.
- Pagination memakai `paginatorInfo`, bukan `meta`.
- Error GraphQL berada di `errors[]`, bukan `message` tunggal.
- Nullability GraphQL harus dicerminkan di model; jangan memaksa `as Map<String, dynamic>` tanpa pemeriksaan.

## 8. Risiko

- Schema GraphQL dapat berubah tanpa versioning yang terlihat di mobile.
- Query yang sama dapat menghasilkan bentuk berbeda dari REST.
- GraphQL dapat membuka permukaan data yang tidak diotorisasi jika resolver lupa memeriksa kepemilikan.
- Client helper belum dipakai di layar produksi, sehingga belum teruji luas.

## 9. Rekomendasi

- Pertahankan REST untuk semua alur transaksi.
- Gunakan GraphQL hanya untuk read-only yang sudah stabil.
- Tambahkan contract test untuk query yang dipakai.
- Dokumentasikan setiap query baru di PRD layar terkait.
