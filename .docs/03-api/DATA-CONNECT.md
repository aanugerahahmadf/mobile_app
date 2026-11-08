# Firebase Data Connect

## 1. Status

Data Connect **tidak terhubung ke aplikasi produksi**. Folder `dataconnect/` dan `lib/DataConnectGenerated/` adalah scaffold/generated code yang tidak diimpor layar mana pun.

| Item | Nilai |
|---|---|
| Service ID | `mobileapp` |
| Location | `us-east4` |
| Connector | `example` |
| Database | PostgreSQL Cloud SQL `fdcdb` |
| Instance | `wedding-flower-decorasi-instance` |
| Schema | 6 tabel |
| Dipakai runtime | Tidak |

## 2. Skema

```graphql
type Wedding @table {
  title: String!
  weddingDate: Date!
  budgetLimit: Float
  themeColorPalette: String
}

type Arrangement @table {
  name: String!
  type: String!
  status: String!
  estimatedCost: Float
  actualCost: Float
  notes: String
  wedding: Wedding!
  venueArea: VenueArea
}

type VenueArea @table {
  name: String!
  wedding: Wedding!
}

type FlowerItem @table {
  name: String!
  color: String!
  seasonAvailability: String
  costPerStem: Float
  arrangement: Arrangement!
}

type ReferenceImage @table {
  imageUrl: String!
  description: String!
  wedding: Wedding!
}

type Vendor @table {
  name: String!
  contactEmail: String!
  portfolioUrl: String
  wedding: Wedding!
}
```

Relasi:

```text
Wedding 1─* Arrangement
Wedding 1─* VenueArea
Wedding 1─* ReferenceImage
Wedding 1─* Vendor
VenueArea 1─* Arrangement
Arrangement 1─* FlowerItem
```

## 3. Mengapa tidak dipakai

1. Database produksi aplikasi adalah PostgreSQL Laravel `wedding_florals_decorations` dengan 83 tabel. Data Connect memakai database Cloud SQL terpisah `fdcdb` dengan 6 tabel.
2. Tidak ada sinkronisasi data antara keduanya.
3. Tidak ada operasi Data Connect yang dipanggil dari layar.
4. Model bisnis Data Connect (Wedding, Arrangement, VenueArea, FlowerItem) berbeda dari model transaksi Laravel (catalogs, packages, orders, payments).
5. Menambah Data Connect sebagai sumber data akan menduplikasi kebenaran dan melanggar aturan “backend adalah otoritas”.

## 4. Jika akan diaktifkan

Perlu keputusan produk dan arsitektur:

1. Tentukan domain yang benar-benar membutuhkan Data Connect.
2. Jangan menduplikasi `users`, `catalogs`, `orders`, atau pembayaran.
3. Rancang sinkronisasi satu arah dari Laravel (jika hanya read model).
4. Terapkan `@auth` pada setiap operasi.
5. Tambahkan generated SDK ke build dan feature flag.
6. Uji latency, biaya, dan kegagalan koneksi.
7. Dokumentasikan sebagai sumber data sekunder, bukan pengganti REST.

## 5. Aturan

- Jangan mengimpor `DataConnectGenerated` di layar tanpa keputusan eksplisit.
- Jangan menganggap `fdcdb` berisi data katalog produksi.
- Jangan memakai Data Connect untuk pembayaran atau KYC.
- Jika tidak akan dipakai, hapus scaffold agar tidak menyesatkan kontributor.
