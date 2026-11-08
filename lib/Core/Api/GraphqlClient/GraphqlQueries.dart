// GraphQL Query Strings untuk Wedding Flower Decoration App
//
// Semua dokumen di file ini divalidasi terhadap schema server yang benar-benar
// dipakai runtime (`graphql/schema.graphql`, dicek dengan
// `php artisan lighthouse:print-schema`). Salinan SDL di `Documents/` adalah
// referensi historis dan tidak dipakai client. Aturan yang membuat dokumen
// sebelumnya ditolak server:
//
//   * `login`, `changePassword`, `addToCart`, `updateCartItem`, `createOrder`,
//     `createReview`, `toggleFavorite` memakai satu argumen `input:`, bukan
//     argumen datar;
//   * tipe `Catalog` tidak punya `price`/`discountPrice`/`finalPrice`. Harga
//     hanya ada di tier (`Package`), sama seperti REST `GET /api/catalog`, dan
//     `ItemModel` sudah menghitung harga dari `tiers` — jadi dokumen katalog
//     selalu menyertakan `tiers { ... }`;
//   * paginator Lighthouse bernama `paginatorInfo` (bukan `pageInfo`) dengan
//     `currentPage`, `lastPage`, `perPage`, `count`, `total`, `hasMorePages`;
//   * `featuredCatalogs`, `featuredPackages`, `search`, dan isi `homeData`
//     mengembalikan array langsung tanpa pembungkus `data`, jadi dibaca lewat
//     `GraphqlTransport.list()`/`rows()`, bukan `page()`;
//   * `catalogs` dan `categories` tidak menerima `search`, `onSale`, `minPrice`,
//     atau `maxPrice`. Filter harga hanya ada di `packages`; pencarian nama
//     lewat `searchCatalogs` / `search`.

// ============================================================
// AUTH QUERIES
// ============================================================

const loginMutation = '''
mutation Login(\$input: LoginInput!) {
  login(input: \$input) {
    user {
      id
      name
      email
      phone
      avatar
    }
    token
    tokenType
    expiresIn
  }
}
''';

const registerMutation = '''
mutation Register(\$input: RegisterInput!) {
  register(input: \$input) {
    user {
      id
      name
      email
      phone
      avatar
    }
    token
    tokenType
    expiresIn
  }
}
''';

const logoutMutation = '''
mutation Logout {
  logout
}
''';

// ============================================================
// USER & PROFILE QUERIES
// ============================================================

const userQuery = '''
query User(\$id: ID) {
  user(id: \$id) {
    id
    name
    email
    phone
    avatar
    emailVerifiedAt
    createdAt
    profileCompletion
  }
}
''';

const updateProfileMutation = '''
mutation UpdateProfile(\$input: UpdateProfileInput!) {
  updateProfile(input: \$input) {
    id
    name
    email
    phone
    avatar
  }
}
''';

const changePasswordMutation = '''
mutation ChangePassword(\$input: ChangePasswordInput!) {
  changePassword(input: \$input)
}
''';

// ============================================================
// CATEGORIES QUERIES
//
// `categories` menerima `first`, `type`, `page` dan mengembalikan
// `CategoryPaginator`.
// ============================================================

const categoriesQuery = '''
query Categories(\$first: Int, \$page: Int, \$type: String) {
  categories(first: \$first, page: \$page, type: \$type) {
    data {
      id
      name
      slug
      type
      description
      imageUrl
      isActive
      createdAt
    }
    paginatorInfo {
      currentPage
      lastPage
      perPage
      count
      total
      hasMorePages
    }
  }
}
''';

// ============================================================
// CATALOG QUERIES
// ============================================================

const catalogsQuery = '''
query Catalogs(\$first: Int, \$page: Int, \$categoryId: ID, \$featured: Boolean, \$active: Boolean, \$theme: String, \$color: String) {
  catalogs(
    first: \$first
    page: \$page
    categoryId: \$categoryId
    featured: \$featured
    active: \$active
    theme: \$theme
    color: \$color
  ) {
    data {
      id
      name
      slug
      description
      stock
      isActive
      isFeatured
      isOutOfStock
      is_Favoriteed
      imageUrl
      thumbnailUrl
      videoUrl
      features
      theme
      color
      minCapacity
      maxCapacity
      category {
        id
        name
      }
      averageRating
      tiers {
        id
        catalogId
        name
        description
        price
        discountPrice
        finalPrice
        stock
        sortOrder
        imageUrl
        features
      }
      createdAt
    }
    paginatorInfo {
      currentPage
      lastPage
      perPage
      count
      total
      hasMorePages
    }
  }
}
''';

const featuredCatalogsQuery = '''
query FeaturedCatalogs(\$first: Int) {
  featuredCatalogs(first: \$first) {
    id
    name
    slug
    imageUrl
    thumbnailUrl
    averageRating
    category {
      id
      name
    }
    tiers {
      id
      name
      price
      discountPrice
      finalPrice
      stock
      imageUrl
    }
  }
}
''';

const catalogQuery = '''
query Catalog(\$id: ID, \$slug: String) {
  catalog(id: \$id, slug: \$slug) {
    id
    name
    slug
    description
    stock
    isActive
    isFeatured
    isOutOfStock
    is_Favoriteed
    imageUrl
    thumbnailUrl
    videoUrl
    features
    theme
    color
    minCapacity
    maxCapacity
    category {
      id
      name
      slug
    }
    averageRating
    galleryUrls {
      id
      url
      thumb
      collection
      order
    }
    tiers {
      id
      catalogId
      name
      description
      price
      discountPrice
      finalPrice
      stock
      sortOrder
      imageUrl
      features
    }
    reviews {
      id
      rating
      title
      comment
      createdAt
      user {
        id
        name
      }
    }
    createdAt
  }
}
''';

// ============================================================
// PACKAGES QUERIES
//
// `packages` adalah satu-satunya daftar yang mendukung filter harga di server.
// ============================================================

const packagesQuery = '''
query Packages(\$first: Int, \$page: Int, \$categoryId: ID, \$featured: Boolean, \$minPrice: Float, \$maxPrice: Float, \$active: Boolean) {
  packages(
    first: \$first
    page: \$page
    categoryId: \$categoryId
    featured: \$featured
    minPrice: \$minPrice
    maxPrice: \$maxPrice
    active: \$active
  ) {
    data {
      id
      name
      slug
      description
      catalogId
      price
      discountPrice
      finalPrice
      stock
      isActive
      isFeatured
      imageUrl
      features
      theme
      color
      minCapacity
      maxCapacity
      category {
        id
        name
      }
      averageRating
      createdAt
    }
    paginatorInfo {
      currentPage
      lastPage
      perPage
      count
      total
      hasMorePages
    }
  }
}
''';

const featuredPackagesQuery = '''
query FeaturedPackages(\$first: Int) {
  featuredPackages(first: \$first) {
    id
    name
    slug
    catalogId
    price
    discountPrice
    finalPrice
    imageUrl
    category {
      id
      name
    }
  }
}
''';

// ============================================================
// CART QUERIES
//
// myCart butuh autentikasi; belum dipakai screen sampai resolvernya dibutuhkan.
// ============================================================

const addToCartMutation = '''
mutation AddToCart(\$input: AddToCartInput!) {
  addToCart(input: \$input) {
    id
    quantity
    subtotal
    catalog {
      id
      name
    }
    package {
      id
      name
      price
      finalPrice
    }
  }
}
''';

// `cartItemId` adalah argumen di luar, quantity/options masuk `input`.
const updateCartItemMutation = '''
mutation UpdateCartItem(\$cartItemId: ID!, \$input: UpdateCartItemInput!) {
  updateCartItem(cartItemId: \$cartItemId, input: \$input) {
    id
    quantity
    subtotal
  }
}
''';

const removeFromCartMutation = '''
mutation RemoveFromCart(\$cartItemId: ID!) {
  removeFromCart(cartItemId: \$cartItemId)
}
''';

const clearCartMutation = '''
mutation ClearCart {
  clearCart
}
''';

// ============================================================
// FAVORITE QUERIES
//
// Permukaan "wishlist" di server bernama `toggleFavorite` dan mengembalikan
// `FavoriteAction` (action + pesan + baris favorite), bukan objek favorite
// langsung.
// ============================================================

const toggleFavoriteMutation = '''
mutation ToggleFavorite(\$input: ToggleFavoriteInput!) {
  toggleFavorite(input: \$input) {
    action
    message
    Favorite {
      id
      catalog {
        id
        name
      }
    }
  }
}
''';

// ============================================================
// ORDERS QUERIES
//
// myOrders butuh autentikasi. `Order` tidak punya `total` atau `items`:
// nominalnya `totalPrice`, dan satu order merujuk satu `package`/`catalog`.
// ============================================================

const createOrderMutation = '''
mutation CreateOrder(\$input: CreateOrderInput!) {
  createOrder(input: \$input) {
    id
    orderNumber
    status
    paymentStatus
    totalPrice
    bookingDate
    quantity
    notes
    catalog {
      id
      name
    }
    package {
      id
      name
      price
      finalPrice
    }
    createdAt
  }
}
''';

// ============================================================
// REVIEWS QUERIES
//
// myReviews butuh autentikasi.
// ============================================================

const createReviewMutation = '''
mutation CreateReview(\$input: CreateReviewInput!) {
  createReview(input: \$input) {
    id
    rating
    title
    comment
    createdAt
  }
}
''';

// ============================================================
// CBIR QUERIES
//
// `cbirStats` adalah operasi admin: resolver menolak token storefront biasa.
// Screen mobile tidak boleh mengandalkannya.
// ============================================================

const cbirStatsQuery = '''
query CbirStats {
  cbirStats {
    totalImages
    totalFeatures
    databaseSize
    lastUpdated
  }
}
''';

// ============================================================
// HOME DATA QUERY
//
// Satu request untuk Beranda; setiap fieldnya array langsung tanpa paginator.
// ============================================================

const homeDataQuery = '''
query HomeData {
  homeData {
    featuredCatalogs {
      id
      name
      slug
      imageUrl
      thumbnailUrl
      averageRating
      tiers {
        id
        name
        price
        discountPrice
        finalPrice
        stock
      }
    }
    featuredPackages {
      id
      name
      slug
      price
      discountPrice
      finalPrice
      imageUrl
    }
    onSaleCatalogs {
      id
      name
      slug
      imageUrl
      tiers {
        id
        name
        price
        discountPrice
        finalPrice
        stock
      }
    }
    onSalePackages {
      id
      name
      slug
      price
      discountPrice
      finalPrice
      imageUrl
    }
    categories {
      id
      name
      slug
      imageUrl
    }
  }
}
''';

// ============================================================
// SEARCH QUERY
//
// Hasil `search` berbentuk GROUPED (katalog / paket / kategori + total + took),
// sama seperti REST `/api/search` dan pesan gRPC `SearchResults`. Harga hanya
// ada di tier `Package`; `Catalog` tidak punya kolom harga.
// ============================================================

const searchQuery = '''
query Search(
  \$query: String!
  \$type: SearchType
  \$first: Int
  \$categoryId: ID
  \$minPrice: Float
  \$maxPrice: Float
) {
  search(
    query: \$query
    type: \$type
    first: \$first
    categoryId: \$categoryId
    minPrice: \$minPrice
    maxPrice: \$maxPrice
  ) {
    query
    took
    totalCatalogs
    totalPackages
    catalogs {
      id
      name
      slug
      imageUrl
      thumbnailUrl
      averageRating
      category {
        id
        name
      }
      tiers {
        id
        name
        price
        discountPrice
        finalPrice
        stock
      }
    }
    packages {
      id
      name
      slug
      price
      discountPrice
      finalPrice
      imageUrl
      category {
        id
        name
      }
    }
    categories {
      id
      name
      slug
      imageUrl
    }
  }
}
''';

// ============================================================
// VOUCHER QUERY
//
// `validateVoucher` menuntut `cartTotal`. Field nominal voucher bernama
// `discountType`/`discountAmount`, bukan `type`/`value`.
// ============================================================

const validateVoucherMutation = '''
mutation ValidateVoucher(\$code: String!, \$cartTotal: Float!, \$items: [ValidateVoucherItemInput!]) {
  validateVoucher(code: \$code, cartTotal: \$cartTotal, items: \$items) {
    valid
    discount
    message
    voucher {
      id
      code
      name
      discountType
      discountAmount
      maxDiscount
      minPurchase
      expiresAt
    }
  }
}
''';
