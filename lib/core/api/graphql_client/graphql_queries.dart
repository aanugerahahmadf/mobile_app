// GraphQL Query Strings untuk Wedding Flower Decoration App

// ============================================================
// AUTH QUERIES
// ============================================================

const loginMutation = '''
mutation Login(\$email: String!, \$password: String!) {
  login(email: \$email, password: \$password) {
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
mutation ChangePassword(\$currentPassword: String!, \$newPassword: String!, \$newPasswordConfirmation: String!) {
  changePassword(
    currentPassword: \$currentPassword
    newPassword: \$newPassword
    newPasswordConfirmation: \$newPasswordConfirmation
  )
}
''';

// ============================================================
// CATEGORIES QUERIES
// ============================================================

const categoriesQuery = '''
query Categories(\$first: Int!, \$search: String, \$active: Boolean) {
  categories(first: \$first, search: \$search, active: \$active) {
    data {
      id
      name
      slug
      description
      imageUrl
      isActive
      createdAt
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
    }
  }
}
''';

// ============================================================
// CATALOG QUERIES
// ============================================================

const catalogsQuery = '''
query Catalogs(\$first: Int!, \$search: String, \$categoryId: ID, \$featured: Boolean, \$onSale: Boolean, \$minPrice: Float, \$maxPrice: Float, \$active: Boolean) {
  catalogs(
    first: \$first
    search: \$search
    categoryId: \$categoryId
    featured: \$featured
    onSale: \$onSale
    minPrice: \$minPrice
    maxPrice: \$maxPrice
    active: \$active
  ) {
    data {
      id
      name
      slug
      description
      price
      discountPrice
      finalPrice
      stock
      isActive
      isFeatured
      isOutOfStock
      imageUrl
      videoUrl
      features
      theme
      color
      category {
        id
        name
      }
      averageRating
      createdAt
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
    }
  }
}
''';

const featuredCatalogsQuery = '''
query FeaturedCatalogs(\$first: Int!) {
  featuredCatalogs(first: \$first) {
    data {
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
    price
    discountPrice
    finalPrice
    stock
    isActive
    isFeatured
    isOutOfStock
    imageUrl
    videoUrl
    features
    theme
    color
    category {
      id
      name
    }
    averageRating
    reviews {
      id
      rating
      comment
      user {
        id
        name
      }
    }
  }
}
''';

// ============================================================
// PACKAGES QUERIES
// ============================================================

const packagesQuery = '''
query Packages(\$first: Int!, \$search: String, \$categoryId: ID, \$featured: Boolean, \$onSale: Boolean, \$minPrice: Float, \$maxPrice: Float, \$active: Boolean) {
  packages(
    first: \$first
    search: \$search
    categoryId: \$categoryId
    featured: \$featured
    onSale: \$onSale
    minPrice: \$minPrice
    maxPrice: \$maxPrice
    active: \$active
  ) {
    data {
      id
      name
      slug
      description
      price
      discountPrice
      finalPrice
      isActive
      isFeatured
      imageUrl
      features
      theme
      color
      category {
        id
        name
      }
      averageRating
      createdAt
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
    }
  }
}
''';

const featuredPackagesQuery = '''
query FeaturedPackages(\$first: Int!) {
  featuredPackages(first: \$first) {
    data {
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
  }
}
''';

// ============================================================
// CART QUERIES
// ============================================================

// Note: myCart query requires authentication.
// Use REST API /cart for now or implement a custom resolver.

const addToCartMutation = '''
mutation AddToCart(\$catalogId: ID!, \$quantity: Int!) {
  addToCart(catalogId: \$catalogId, quantity: \$quantity) {
    id
    quantity
    subtotal
    catalog {
      id
      name
    }
  }
}
''';

const updateCartItemMutation = '''
mutation UpdateCartItem(\$cartItemId: ID!, \$quantity: Int!) {
  updateCartItem(cartItemId: \$cartItemId, quantity: \$quantity) {
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
// WISHLIST QUERIES
// ============================================================

// Note: myWishlist query requires authentication.

const toggleWishlistMutation = '''
mutation ToggleWishlist(\$catalogId: ID) {
  toggleWishlist(catalogId: \$catalogId) {
    id
    catalog {
      id
      name
    }
  }
}
''';

// ============================================================
// ORDERS QUERIES
// ============================================================

// Note: myOrders query requires authentication.

const createOrderMutation = '''
mutation CreateOrder(\$input: CreateOrderInput!) {
  createOrder(input: \$input) {
    id
    orderNumber
    status
    total
    items {
      id
      quantity
      price
    }
  }
}
''';

// ============================================================
// REVIEWS QUERIES
// ============================================================

// Note: myReviews query requires authentication.

const createReviewMutation = '''
mutation CreateReview(\$input: CreateReviewInput!) {
  createReview(input: \$input) {
    id
    rating
    comment
    createdAt
  }
}
''';

// ============================================================
// CBIR QUERIES
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
// ============================================================

const homeDataQuery = '''
query HomeData {
  homeData {
    featuredCatalogs {
      id
      name
      slug
      price
      imageUrl
    }
    featuredPackages {
      id
      name
      slug
      price
      imageUrl
    }
    onSaleCatalogs {
      id
      name
      slug
      price
      discountPrice
      imageUrl
    }
    onSalePackages {
      id
      name
      slug
      price
      discountPrice
      imageUrl
    }
    categories {
      id
      name
      slug
    }
  }
}
''';

// ============================================================
// SEARCH QUERY
// ============================================================

const searchQuery = '''
query Search(\$query: String!, \$type: SearchType, \$first: Int!) {
  search(query: \$query, type: \$type, first: \$first) {
    id
    type
    name
    slug
    price
    imageUrl
    category
  }
}
''';

// ============================================================
// VOUCHER QUERY
// ============================================================

const validateVoucherMutation = '''
mutation ValidateVoucher(\$code: String!) {
  validateVoucher(code: \$code) {
    valid
    discount
    message
    voucher {
      id
      code
      type
      value
    }
  }
}
''';
