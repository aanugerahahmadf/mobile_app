# Dokumentasi Lengkap GraphQL dan gRPC

## Wedding Flowers Decoration App

Dokumentasi ini menjelaskan implementasi lengkap GraphQL dan gRPC di aplikasi Wedding Flowers Decoration.

---

## Daftar Isi

1. [Arsitektur API](#arsitektur-api)
2. [GraphQL](#graphql)
   - [Firebase Data Connect](#firebase-data-connect)
   - [Laravel GraphQL](#laravel-graphql)
3. [gRPC](#grpc)
   - [Layanan Tersedia](#layanan-tersedia)
   - [Cara Penggunaan](#cara-penggunaan)
4. [Unified API Service](#unified-api-service)
5. [Contoh Penggunaan](#contoh-penggunaan)
6. [Konfigurasi](#konfigurasi)
7. [Development & Testing](#development--testing)

---

## Arsitektur API

```
┌─────────────────────────────────────────────────────────────┐
│                      UI Layer (Widgets)                     │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                  Provider Layer (Riverpod)                   │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│              UnifiedApiService (Entry Point)                 │
└────────────────────────┬────────────────────────────────────┘
                         │
          ┌──────────────┴──────────────┐
          │                             │
┌─────────▼─────────┐      ┌───────────▼───────────┐
│   GraphQL Layer   │      │      gRPC Layer       │
│                   │      │                       │
│ • Data Connect    │      │ • 16 Service Clients  │
│ • Laravel GraphQL │      │ • HTTP/2 Protocol     │
│ • PostgreSQL DB   │      │ • Protobuf Messages   │
└───────────────────┘      └───────────────────────┘
```

### Kapan Menggunakan GraphQL vs gRPC?

| Fitur | GraphQL | gRPC | Alasan |
|-------|---------|------|--------|
| Wedding Decoration Data | Ya | | Data relational, butuh relasi kompleks |
| Catalog & Produk | | Ya | High performance, typed data |
| Authentication | Ya | Ya | Keduanya support, pilih sesuai kebutuhan |
| Real-time Updates | Ya | | Data Connect support subscriptions |
| Image Search (CBIR) | | Ya | Binary data, butuh performa tinggi |
| Chat & Messaging | | Ya | Low latency, streaming support |
| Notifications | | Ya | Push-based, real-time |
| Complex Queries | Ya | | Flexible field selection |
| Microservices | | Ya | Service-to-service communication |

---

## GraphQL

### Firebase Data Connect

Firebase Data Connect menyediakan GraphQL API dengan backend PostgreSQL untuk data wedding decoration.

#### Struktur Proyek

```
dataconnect/
├── dataconnect.yaml          # Konfigurasi service
├── seed_data.gql             # Data untuk development
├── schema/
│   └── schema.gql            # Model data (5 entitas)
└── example/
    ├── connector.yaml        # Konfigurasi SDK generation
    ├── queries.gql           # Query operations
    └── mutations.gql         # Mutation operations
```

#### Model Data

**1. Wedding**
```graphql
type Wedding @table {
  id: UUID!                    # Auto-generated
  title: String!               # Judul wedding
  weddingDate: Date!           # Tanggal pernikahan
  budgetLimit: Float           # Batas budget
  themeColorPalette: String    # Palet warna tema
}
```

**2. Arrangement**
```graphql
type Arrangement @table {
  id: UUID!
  name: String!                # Nama arrangement
  type: String!                # Tipe (Floral, Greenery, dll)
  status: String!              # Status (Pending, Booked, dll)
  estimatedCost: Float         # Biaya estimasi
  actualCost: Float            # Biaya aktual
  notes: String                # Catatan
  wedding: Wedding!            # Relasi ke Wedding
  venueArea: VenueArea         # Relasi opsional ke VenueArea
}
```

**3. VenueArea**
```graphql
type VenueArea @table {
  id: UUID!
  name: String!                # Nama area venue
  wedding: Wedding!            # Relasi ke Wedding
}
```

**4. FlowerItem**
```graphql
type FlowerItem @table {
  id: UUID!
  name: String!                # Nama bunga
  color: String!               # Warna
  seasonAvailability: String   # Ketersediaan musim
  costPerStem: Float           # Harga per tangkai
  arrangement: Arrangement!    # Relasi ke Arrangement
}
```

**5. ReferenceImage**
```graphql
type ReferenceImage @table {
  id: UUID!
  imageUrl: String!            # URL gambar referensi
  description: String!         # Deskripsi
  wedding: Wedding!            # Relasi ke Wedding
}
```

#### Query Operations

**Query Dasar**
```graphql
# Ambil semua wedding
query ListWeddings {
  weddings {
    id
    title
    weddingDate
    budgetLimit
  }
}

# Ambil wedding by ID
query GetWedding($id: UUID!) {
  wedding(id: $id) {
    id
    title
    weddingDate
  }
}
```

**Query dengan Relasi**
```graphql
# Wedding dengan semua detail
query GetWeddingWithDetails($id: UUID!) {
  wedding(id: $id) {
    id
    title
    weddingDate
    budgetLimit
    themeColorPalette
    
    # Relasi: Arrangements
    arrangements {
      id
      name
      type
      status
      estimatedCost
      actualCost
      
      # Nested relasi: VenueArea
      venueArea {
        id
        name
      }
      
      # Nested relasi: FlowerItems
      flowerItems {
        id
        name
        color
        costPerStem
      }
    }
    
    # Relasi: VenueAreas
    venueAreas {
      id
      name
    }
    
    # Relasi: ReferenceImages
    referenceImages {
      id
      imageUrl
      description
    }
  }
}
```

**Query dengan Filtering**
```graphql
# Arrangements by wedding
query ListArrangementsByWedding($weddingId: UUID!) {
  arrangements(where: { weddingId: { eq: $weddingId } }) {
    id
    name
    type
    status
  }
}

# Arrangements by status
query ListArrangementsByStatus($status: String!) {
  arrangements(where: { status: { eq: $status } }) {
    id
    name
    status
  }
}

# Flower items by color
query ListFlowerItemsByColor($color: String!) {
  flowerItems(where: { color: { eq: $color } }) {
    id
    name
    color
    costPerStem
  }
}
```

#### Mutation Operations

**CRUD Dasar**
```graphql
# Create Wedding
mutation CreateWedding(
  $title: String!,
  $weddingDate: Date!,
  $budgetLimit: Float,
  $themeColorPalette: String
) {
  wedding_insert(
    data: {
      title: $title,
      weddingDate: $weddingDate,
      budgetLimit: $budgetLimit,
      themeColorPalette: $themeColorPalette
    }
  ) {
    id
    title
    weddingDate
  }
}

# Update Wedding
mutation UpdateWedding($id: UUID!, $title: String) {
  wedding_update(key: { id: $id }, data: { title: $title }) {
    id
    title
  }
}

# Delete Wedding
mutation DeleteWedding($id: UUID!) {
  wedding_delete(key: { id: $id }) {
    keys
  }
}
```

**Transaction Mutations**
```graphql
# Create Wedding + Venue dalam satu transaksi
mutation CreateWeddingWithVenue(
  $weddingTitle: String!,
  $weddingDate: Date!,
  $venueName: String!
) @transaction {
  createdWedding: wedding_insert(
    data: {
      title: $weddingTitle,
      weddingDate: $weddingDate
    }
  ) {
    id
    title
  }
  
  createdVenue: venueArea_insert(
    data: {
      name: $venueName,
      weddingId: _expr: "response.createdWedding.id"
    }
  ) {
    id
    name
  }
}
```

#### Cara Penggunaan di Flutter

```dart
import 'package:mobile_app/Core/Api/DataConnect/DataConnectService.dart';

// Inisialisasi
await DataConnectService.instance.initialize();

// Query
final dc = DataConnectService.instance;

// List semua wedding
final weddings = await dc.weddings.listAll();

// Get wedding dengan detail
final wedding = await dc.weddings.getWithDetails('uuid-here');

// Create wedding
await dc.weddings.create(
  title: 'Wedding Saya',
  weddingDate: DateTime(2025, 10, 10),
  budgetLimit: 25000.0,
  themeColorPalette: 'Blue and White',
);

// Update wedding
await dc.weddings.update(
  id: 'uuid-here',
  title: 'Wedding yang Diupdate',
);

// Delete wedding
await dc.weddings.delete('uuid-here');

// Arrangements
final arrangements = await dc.arrangements.listByWedding('wedding-uuid');
final bookedArrangements = await dc.arrangements.listByStatus('Booked');

// Real-time subscription
final subscription = dc.weddings.subscribe(
  id: 'uuid-here',
  onData: (wedding) {
    // Update UI saat data berubah
  },
  onError: (error) {
    // Handle error
  },
);
```

#### Generate SDK

```bash
# Generate Dart SDK
npx -y firebase-tools@latest dataconnect:sdk:generate

# Compile dan validasi
npx -y firebase-tools@latest dataconnect:compile

# Jalankan emulator untuk development
npx -y firebase-tools@latest emulators:start --only dataconnect

# Deploy ke production
npx -y firebase-tools@latest deploy --only dataconnect
```

---

### Laravel GraphQL

Laravel GraphQL digunakan untuk operasi yang sudah ada di backend Laravel.

#### Query yang Tersedia

```dart
import 'package:mobile_app/Core/Api/GraphqlClient/GraphqlQueries.dart';

// Auth queries
const loginMutation;
const registerMutation;
const logoutMutation;

// User queries
const userQuery;
const updateProfileMutation;
const changePasswordMutation;

// Category queries
const categoriesQuery;

// Catalog queries
const catalogsQuery;
const catalogQuery;
const featuredCatalogsQuery;

// Cart queries
const cartQuery;
const addToCartMutation;

// Order queries
const ordersQuery;
const orderQuery;

// Review queries
const reviewsQuery;
const createReviewMutation;

// Notification queries
const notificationsQuery;

// Chat queries
const conversationsQuery;
const sendMessageMutation;

// Search queries
const searchQuery;

// Voucher queries
const vouchersQuery;
const validateVoucherMutation;

// Favorite queries
const favoritesQuery;
const toggleFavoriteMutation;
```

#### Cara Penggunaan

```dart
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile_app/Core/Api/GraphqlClient/GraphqlClient.dart';
import 'package:mobile_app/Core/Api/GraphqlClient/GraphqlQueries.dart';

// Build client
final client = await GraphQLClientHelper.buildClient();

// Query
final result = await client.query(
  QueryOptions(
    document: gql(categoriesQuery),
    variables: {'first': 10},
  ),
);

// Mutation
final loginResult = await client.mutate(
  MutationOptions(
    document: gql(loginMutation),
    variables: {
      'email': 'user@example.com',
      'password': 'password123',
    },
  ),
);

// Dengan GraphQL Provider
return GraphQLProvider(
  client: await GraphQLClientHelper.buildClient(),
  child: Query(
    options: QueryOptions(
      document: gql(catalogsQuery),
      variables: {'first': 20},
    ),
    builder: (result, {refetch}) {
      if (result.isLoading) return CircularProgressIndicator();
      if (result.hasException) return Text('Error: ${result.exception}');
      
      final catalogs = result.data?['catalogs']['data'] as List? ?? [];
      return ListView.builder(
        itemCount: catalogs.length,
        itemBuilder: (context, index) {
          final catalog = catalogs[index];
          return ListTile(
            title: Text(catalog['name']),
            subtitle: Text('Rp ${catalog['price']}'),
          );
        },
      );
    },
  ),
);
```

---

## gRPC

### Layanan Tersedia

Aplikasi menggunakan 16 layanan gRPC yang di-generate dari protobuf definitions:

| Service | Deskripsi | Metode Utama |
|---------|-----------|--------------|
| **AuthService** | Autentikasi & otorisasi | Login, Register, Logout, 2FA, Social Login |
| **CatalogService** | Katalog produk | List, Get, Featured, OnSale |
| **CartService** | Keranjang belanja | Get, AddItem, UpdateItem, RemoveItem, Clear |
| **CategoryService** | Kategori produk | List, Get |
| **CbirService** | Pencarian gambar | Search, Health, Stats |
| **ChatService** | Chat & pesan | ListConversations, SendMessage, StartConversation |
| **HomeService** | Data halaman utama | Get |
| **NotificationService** | Notifikasi | List, MarkAllRead, Delete, RegisterFcmToken |
| **OrderService** | Pesanan | List, Get, Create, UpdateStatus |
| **PackageService** | Paket wedding | List, Get |
| **ProfileService** | Profil pengguna | Get, Update, UploadAvatar, ChangePassword |
| **ReviewService** | Ulasan & rating | List, Create, MyReviews |
| **SearchService** | Pencarian | Search, SearchByImage |
| **VoucherService** | Voucher & diskon | List, Validate |
| **FavoriteService** | Favorit | List, Toggle, IsFavorite |
| **LegalService** | Legal documents | TermsOfService, PrivacyPolicy, HelpCenter |

### Cara Penggunaan

```dart
import 'package:mobile_app/Core/Api/GrpcService.dart';

// Inisialisasi
await GrpcService.instance.initialize();

final grpc = GrpcService.instance;

// ============================================================
// Auth
// ============================================================

// Login
final loginResult = await grpc.auth.login('email@test.com', 'password');

// Register
final registerResult = await grpc.auth.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  phone: '+6281234567890',
);

// Social Login
await grpc.auth.googleLogin(idToken: 'google-id-token');
await grpc.auth.facebookLogin(accessToken: 'facebook-token');
await grpc.auth.appleLogin(idToken: 'apple-id-token');

// 2FA
await grpc.auth.verifyTwoFactor(code: '123456');

// Forgot Password
await grpc.auth.forgotPassword('email@test.com');

// Reset Password
await grpc.auth.resetPassword(
  token: 'reset-token',
  newPassword: 'newPassword123',
  newPasswordConfirmation: 'newPassword123',
);

// Logout
await grpc.auth.logout();

// ============================================================
// Catalog
// ============================================================

// List catalogs
final catalogs = await grpc.catalog.list(
  page: 1,
  limit: 20,
  categoryId: 'category-id',
  featured: true,
  search: 'rose',
);

// Get catalog detail
final catalog = await grpc.catalog.getById('catalog-id');

// Featured catalogs
final featured = await grpc.catalog.featured(limit: 10);

// On sale catalogs
final onSale = await grpc.catalog.onSale(limit: 10);

// ============================================================
// Cart
// ============================================================

// Get cart
final cart = await grpc.cart.get();

// Add to cart
await grpc.cart.addItem(
  catalogId: 'catalog-id',
  quantity: 2,
  notes: 'Untuk wedding di Jakarta',
);

// Update item
await grpc.cart.updateItem(
  itemId: 'item-id',
  quantity: 3,
);

// Remove item
await grpc.cart.removeItem('item-id');

// Clear cart
await grpc.cart.clear();

// ============================================================
// Category
// ============================================================

// List categories
final categories = await grpc.category.list(
  active: true,
  search: 'floral',
);

// Get category
final category = await grpc.category.getById('category-id');

// ============================================================
// CBIR (Content-Based Image Retrieval)
// ============================================================

// Search by image
final imageBytes = await File('path/to/image.jpg').readAsBytes();
final results = await grpc.cbir.search(
  imageBytes: imageBytes,
  limit: 10,
  threshold: 0.8,
);

// Health check
final health = await grpc.cbir.health();

// Stats
final stats = await grpc.cbir.stats();

// ============================================================
// Chat
// ============================================================

// List conversations
final conversations = await grpc.chat.listConversations(
  page: 1,
  limit: 20,
);

// Send message
await grpc.chat.sendMessage(
  conversationId: 'conversation-id',
  message: 'Halo, saya ingin bertanya tentang paket wedding',
);

// Start new conversation
await grpc.chat.startConversation(
  recipientId: 'vendor-id',
  initialMessage: 'Halo',
);

// Unread count
final unreadCount = await grpc.chat.unreadCount();

// ============================================================
// Home
// ============================================================

final homeData = await grpc.home.get();

// ============================================================
// Notification
// ============================================================

// List notifications
final notifications = await grpc.notification.list(
  page: 1,
  limit: 20,
  unreadOnly: true,
);

// Mark all read
await grpc.notification.markAllRead();

// Delete notification
await grpc.notification.delete('notification-id');

// Register FCM token
await grpc.notification.registerFcmToken('fcm-token-here');

// Unread count
final unreadCount = await grpc.notification.unreadCount();

// ============================================================
// Order
// ============================================================

// List orders
final orders = await grpc.order.list(
  page: 1,
  limit: 20,
  status: 'pending',
);

// Get order detail
final order = await grpc.order.getById('order-id');

// Create order
await grpc.order.create(
  cartId: 'cart-id',
  notes: 'Wedding di Jakarta Convention Center',
  specialRequests: 'Butuh setup sebelum jam 6 sore',
);

// Update order status
await grpc.order.updateStatus(
  id: 'order-id',
  status: 'confirmed',
);

// ============================================================
// Package
// ============================================================

// List packages
final packages = await grpc.package.list(
  page: 1,
  limit: 20,
  categoryId: 'category-id',
);

// Get package detail
final package = await grpc.package.getById('package-id');

// ============================================================
// Profile
// ============================================================

// Get profile
final profile = await grpc.profile.get();

// Update profile
await grpc.profile.update(
  name: 'New Name',
  phone: '+6281234567890',
  avatarUrl: 'https://example.com/avatar.jpg',
);

// Upload avatar
final avatarBytes = await File('path/to/avatar.jpg').readAsBytes();
await grpc.profile.uploadAvatar(imageBytes: avatarBytes);

// Change password
await grpc.profile.changePassword(
  currentPassword: 'oldPassword',
  newPassword: 'newPassword',
  newPasswordConfirmation: 'newPassword',
);

// Profile completion
final completion = await grpc.profile.completion();
print('Profile ${completion.percentage}% lengkap');

// Delete account
await grpc.profile.deleteAccount(password: 'password');

// ============================================================
// Review
// ============================================================

// List reviews for catalog
final reviews = await grpc.review.list(
  catalogId: 'catalog-id',
  page: 1,
  limit: 20,
);

// Create review
await grpc.review.create(
  catalogId: 'catalog-id',
  rating: 5,
  comment: 'Sangat bagus!',
  imageUrls: ['https://example.com/review1.jpg'],
);

// My reviews
final myReviews = await grpc.review.myReviews(
  page: 1,
  limit: 20,
);

// ============================================================
// Search
// ============================================================

// Text search
final searchResults = await grpc.search.search(
  query: 'rose bouquet',
  page: 1,
  limit: 20,
  categoryId: 'category-id',
);

// Image search (CBIR)
final imageSearchResults = await grpc.search.searchByImage(
  imageBytes: imageBytes,
  limit: 10,
);

// ============================================================
// Voucher
// ============================================================

// List vouchers
final vouchers = await grpc.voucher.list();

// Validate voucher
final validation = await grpc.voucher.validate(
  code: 'DISKON50',
  cartTotal: 1000000,
);

if (validation.isValid) {
  print('Voucher valid! Diskon: ${validation.discount}');
}

// ============================================================
// Favorite
// ============================================================

// List favorites
final favorites = await grpc.favorite.list(
  page: 1,
  limit: 20,
);

// Toggle favorite
final toggleResult = await grpc.favorite.toggle(
  catalogId: 'catalog-id',
);

// Check if favorite
final isFav = await grpc.favorite.isFavorite(
  catalogId: 'catalog-id',
);

// ============================================================
// Legal
// ============================================================

// Terms of Service
final terms = await grpc.legal.termsOfService();

// Privacy Policy
final privacy = await grpc.legal.privacyPolicy();

// Wedding Decoration Policy
final policy = await grpc.legal.weddingDecorationPolicy();

// Help Center
final help = await grpc.legal.helpCenter();

// About
final about = await grpc.legal.about();

// ============================================================
// Shutdown
// ============================================================

await grpc.shutdown();
```

---

## Unified API Service

UnifiedApiService menggabungkan GraphQL dan gRPC menjadi satu antarmuka.

### Inisialisasi

```dart
import 'package:mobile_app/Core/Api/UnifiedApiService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi semua service
  await UnifiedApiService.instance.initialize(
    enableDataConnect: true,
    enableGrpc: true,
    useDataConnectEmulator: true, // Untuk development
  );
  
  runApp(MyApp());
}
```

### Penggunaan

```dart
final api = UnifiedApiService.instance;

// Data Connect - Wedding
final weddings = await api.listWeddings();
final wedding = await api.getWedding('uuid');

// gRPC - Catalog
final catalogs = await api.listCatalogs(page: 1, limit: 20);

// gRPC - Auth
await api.loginWithGrpc('email@test.com', 'password');

// GraphQL - Auth (alternatif)
await api.loginWithGraphQL('email@test.com', 'password');

// gRPC - Search
final results = await api.searchCatalogs(query: 'rose');

// gRPC - Order
final orders = await api.listOrders();

// Shutdown
await api.shutdown();
```

---

## Konfigurasi

### Environment Variables (.env)

```env
# API Base URL untuk REST & GraphQL
API_BASE_URL=http://10.0.2.2:8000/api

# gRPC Base URL
GRPC_BASE_URL=http://127.0.0.1:50051
```

### Production (.env.production)

```env
API_BASE_URL=https://api.yourdomain.com/api
GRPC_BASE_URL=https://grpc.yourdomain.com
```

### Firebase Data Connect

```yaml
# dataconnect/dataconnect.yaml
specVersion: "v1"
serviceId: "mobileapp"
location: "us-east4"
schemas:
  - source: "./schema"
    datasource:
      postgresql:
        database: "fdcdb"
        cloudSql:
          instanceId: "wedding-flower-decorasi-instance"
connectorDirs: ["./example"]
```

### Connector SDK Generation

```yaml
# dataconnect/example/connector.yaml
connectorId: example
generate:
  dartSdk:
    - outputDir: ..\..\lib\dataconnect_generated
      package: dataconnect_generated
      clientCache:
        maxAge: 5s
        storage: memory
```

---

## Development & Testing

### 1. Jalankan Firebase Emulator

```bash
# Start emulator
npx -y firebase-tools@latest emulators:start --only dataconnect

# Compile dan validasi
npx -y firebase-tools@latest dataconnect:compile

# Generate SDK
npx -y firebase-tools@latest dataconnect:sdk:generate
```

### 2. Testing gRPC

```dart
// Test gRPC connection
void testGrpcConnection() async {
  final grpc = GrpcService.instance;
  await grpc.initialize();
  
  // Test health check
  try {
    final health = await grpc.cbir.health();
    print('gRPC connected: ${health.status}');
  } catch (e) {
    print('gRPC connection failed: $e');
  }
  
  await grpc.shutdown();
}
```

### 3. Testing GraphQL

```dart
// Test GraphQL connection
void testGraphQLConnection() async {
  final client = await GraphQLClientHelper.buildClient();
  
  final result = await client.query(
    QueryOptions(
      document: gql('query { __typename }'),
    ),
  );
  
  if (result.hasException) {
    print('GraphQL connection failed: ${result.exception}');
  } else {
    print('GraphQL connected');
  }
}
```

### 4. Testing Data Connect

```dart
// Test Data Connect
void testDataConnect() async {
  final dc = DataConnectService.instance;
  await dc.initialize(useEmulator: true);
  
  final weddings = await dc.weddings.listAll();
  print('Data Connect: ${weddings.length} weddings');
  
  dc.reset();
}
```

---

## Best Practices

### 1. Error Handling

```dart
try {
  final result = await grpc.catalog.getById('id');
  // Process result
} on GrpcError catch (e) {
  switch (e.code) {
    case StatusCode.unauthenticated:
      // Redirect to login
      break;
    case StatusCode.notFound:
      // Show not found message
      break;
    case StatusCode.deadlineExceeded:
      // Show timeout message
      break;
    default:
      // Show generic error
      break;
  }
} catch (e) {
  // Handle unexpected error
}
```

### 2. Caching

```dart
// GraphQL cache
final client = GraphQLClient(
  link: httpLink,
  cache: GraphQLCache(partialDataPolicy: PartialDataCachePolicy.accept),
);

// Fetch policies
await queryRef.execute(fetchPolicy: QueryFetchPolicy.cacheFirst);  // Cache first, then network
await queryRef.execute(fetchPolicy: QueryFetchPolicy.networkOnly); // Network only
await queryRef.execute(fetchPolicy: QueryFetchPolicy.cacheOnly);   // Cache only
```

### 3. Resource Cleanup

```dart
// Di MaterialApp atau widget root
@override
void dispose() {
  // Shutdown gRPC
  GrpcService.instance.shutdown();
  
  // Cancel subscriptions
  _subscription?.cancel();
  
  super.dispose();
}
```

### 4. Authentication

```dart
// Token otomatis ditambahkan untuk request yang memerlukan auth
// Token disimpan di FlutterSecureStorage

// Untuk gRPC, token otomatis ditambahkan via _authOptions()
// Untuk GraphQL, token ditambahkan di header via GraphQLClientHelper

// Manual refresh token
Future<void> refreshAuth() async {
  final token = await _storage.read(key: 'auth_token');
  if (token == null || token.isEmpty) {
    // Redirect to login
  }
}
```

---

## Troubleshooting

### gRPC Connection Failed

1. Pastikan `GRPC_BASE_URL` sudah dikonfigurasi di `.env`
2. Untuk emulator Android, gunakan `http://10.0.2.2:50051`
3. Untuk iOS simulator, gunakan `http://127.0.0.1:50051`
4. Pastikan server gRPC berjalan

### GraphQL Connection Failed

1. Pastikan `API_BASE_URL` sudah dikonfigurasi
2. Pastikan Laravel server berjalan
3. Cek endpoint `/graphql` accessible

### Data Connect Emulator

1. Jalankan `npx firebase-tools@latest emulators:start --only dataconnect`
2. Pastikan `useEmulator: true` di development
3. Port default: 9399

---

## Ringkasan File

| File | Deskripsi |
|------|-----------|
| `lib/Core/Api/UnifiedApiService.dart` | Entry point untuk semua API |
| `lib/Core/Api/GrpcService.dart` | Wrapper untuk 16 gRPC services |
| `lib/Core/Api/GrpcClient/GrpcV1Client.dart` | gRPC client connector |
| `lib/Core/Api/DataConnect/DataConnectService.dart` | Firebase Data Connect service |
| `lib/Core/Api/GraphqlClient/GraphqlClient.dart` | GraphQL client builder |
| `lib/Core/Api/GraphqlClient/GraphqlQueries.dart` | GraphQL query strings |
| `dataconnect/schema/schema.gql` | Data model definitions |
| `dataconnect/example/queries.gql` | GraphQL query operations |
| `dataconnect/example/mutations.gql` | GraphQL mutation operations |

---

## Kesimpulan

Aplikasi Wedding Flowers Decoration menggunakan **hybrid architecture** yang menggabungkan:

1. **Firebase Data Connect (GraphQL)** untuk data wedding decoration yang relational
2. **Laravel GraphQL** untuk operasi bisnis yang sudah ada
3. **gRPC** untuk high-performance operations (catalog, cart, order, chat, dll)

Ketiga teknologi ini digabungkan melalui `UnifiedApiService` yang menyediakan antarmuka konsisten untuk developer.
