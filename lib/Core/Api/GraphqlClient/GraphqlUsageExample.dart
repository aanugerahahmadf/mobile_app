/// Contoh penggunaan GraphQL di Flutter
///
/// File ini menunjukkan cara menggunakan GraphQL client untuk berbagai operasi.
///
/// Prasyarat:
/// 1. Jalankan `flutter pub get` setelah menambahkan dependensi GraphQL
/// 2. Install Lighthouse di Laravel: `composer require nuwave/lighthouse`
/// 3. Pastikan server Laravel berjalan di http://192.168.100.63:8000
///
/// Cara menggunakan di widget:
///
/// ```dart
/// import 'package:graphql_flutter/graphql_flutter.dart';
/// import 'package:flutter_riverpod/flutter_riverpod.dart';
/// import '../core/api/graphql_client/graphql_client.dart';
/// import '../core/api/graphql_client/graphql_queries.dart';
///
/// class ExampleScreen extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     return GraphQLProvider(
///       client: GraphQLClient.client(),
///       child: MyWidget(),
///     );
///   }
/// }
/// ```
class GraphQLUsageExample {
  GraphQLUsageExample._();

  // ============================================================
  // Contoh 1: Query Catalogs menggunakan GraphQL widget
  // ============================================================
  ///
  /// ```dart
  /// import 'package:graphql_flutter/graphql_flutter.dart';
  ///
  /// class CatalogListScreen extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Query(
  ///       options: QueryOptions(
  ///         document: gql(GraphQLQueries.catalogs),
  ///         variables: {
  ///           'first': 10,
  ///           'categoryId': null,
  ///           'featured': false,
  ///           'search': null,
  ///         },
  ///       ),
  ///       builder: (QueryResult result, {VoidCallback? refetch}) {
  ///         if (result.isLoading) {
  ///           return CircularProgressIndicator();
  ///         }
  ///
  ///         if (result.hasException) {
  ///           return Text('Error: ${result.exception?.message}');
  ///         }
  ///
  ///         final catalogs = result.data?['catalogs']['data'] as List? ?? [];
  ///
  ///         return ListView.builder(
  ///           itemCount: catalogs.length,
  ///           itemBuilder: (context, index) {
  ///             final catalog = catalogs[index];
  ///             return ListTile(
  ///               title: Text(catalog['name']),
  ///               subtitle: Text('Rp ${catalog['price']}'),
  ///               leading: CachedNetworkImage(
  ///                 imageUrl: catalog['imageUrl'] ?? '',
  ///                 width: 50,
  ///                 height: 50,
  ///               ),
  ///             );
  ///           },
  ///         );
  ///       },
  ///     );
  ///   }
  /// }
  /// ```

  // ============================================================
  // Contoh 2: Login menggunakan Mutation
  // ============================================================
  ///
  /// ```dart
  /// class LoginScreen extends ConsumerWidget {
  ///   final _emailController = TextEditingController();
  ///   final _passwordController = TextEditingController();
  ///
  ///   Future<void> _login(BuildContext context) async {
  ///     final client = GraphQLClient.client();
  ///
  ///     final result = await client.mutate(
  ///       MutationOptions(
  ///         document: gql(GraphQLQueries.login),
  ///         variables: {
  ///           'email': _emailController.text,
  ///           'password': _passwordController.text,
  ///         },
  ///       ),
  ///     );
  ///
  ///     if (result.hasException) {
  ///       ScaffoldMessenger.of(context).showSnackBar(
  ///         SnackBar(content: Text('Login gagal: ${result.exception?.message}')),
  ///       );
  ///       return;
  ///     }
  ///
  ///     final token = result.data?['login']['token'];
  ///     await const FlutterSecureStorage().write(key: 'auth_token', value: token);
  ///
  ///     // Navigate to home
  ///     Navigator.of(context).pushReplacementNamed('/home');
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     return Scaffold(
  ///       body: Column(
  ///         children: [
  ///           TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
  ///           TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
  ///           ElevatedButton(
  ///             onPressed: () => _login(context),
  ///             child: Text('Login'),
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```

  // ============================================================
  // Contoh 3: CBIR Image Search menggunakan Mutation dengan Upload
  // ============================================================
  ///
  /// ```dart
  /// import 'package:image_picker/image_picker.dart';
  /// import 'package:graphql_flutter/graphql_flutter.dart';
  ///
  /// class CbirSearchScreen extends ConsumerWidget {
  ///   Future<void> _searchSimilar(BuildContext context, XFile imageFile) async {
  ///     final client = GraphQLClient.client();
  ///
  ///     final result = await client.mutate(
  ///       MutationOptions(
  ///         document: gql(GraphQLQueries.cbirSearch),
  ///         variables: {
  ///           'image': Upload(
  ///             imageFile.openRead(),
  ///             imageFile.name,
  ///             imageFile.lengthSync(),
  ///           ),
  ///         },
  ///       ),
  ///     );
  ///
  ///     if (result.hasException) {
  ///       ScaffoldMessenger.of(context).showSnackBar(
  ///         SnackBar(content: Text('Pencarian gagal: ${result.exception?.message}')),
  ///       );
  ///       return;
  ///     }
  ///
  ///     final cbirResult = result.data?['cbirSearch'];
  ///     final results = cbirResult['results'] as List? ?? [];
  ///
  ///     // Show results
  ///     Navigator.of(context).push(
  ///       MaterialPageRoute(
  ///         builder: (context) => CbirResultsScreen(results: results),
  ///       ),
  ///     );
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     return Scaffold(
  ///       body: Center(
  ///         child: ElevatedButton.icon(
  ///           onPressed: () async {
  ///             final picker = ImagePicker();
  ///             final image = await picker.pickImage(source: ImageSource.camera);
  ///             if (image != null) {
  ///               _searchSimilar(context, image);
  ///             }
  ///           },
  ///           icon: Icon(Icons.camera_alt),
  ///           label: Text('Ambil Foto untuk Cari Dekorasi'),
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```

  // ============================================================
  // Contoh 4: Menggunakan Riverpod dengan GraphQL
  // ============================================================
  ///
  /// ```dart
  /// import 'package:flutter_riverpod/flutter_riverpod.dart';
  /// import 'package:graphql_flutter/graphql_flutter.dart';
  ///
  /// final graphqlClientProvider = Provider<GraphQLClientType>((ref) {
  ///   return GraphQLClient.client();
  /// });
  ///
  /// final catalogsProvider = FutureProvider.autoDispose
  ///     .family<List<Map<String, dynamic>>, int>((ref, limit) async {
  ///   final client = ref.watch(graphqlClientProvider);
  ///
  ///   final result = await client.query(
  ///     QueryOptions(
  ///       document: gql(GraphQLQueries.catalogs),
  ///       variables: {'first': limit},
  ///     ),
  ///   );
  ///
  ///   if (result.hasException) {
  ///     throw Exception(result.exception?.message);
  ///   }
  ///
  ///   return result.data?['catalogs']['data'] as List? ?? [];
  /// });
  ///
  /// // Di widget:
  /// class CatalogListWithRiverpod extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     final catalogsAsync = ref.watch(catalogsProvider(10));
  ///
  ///     return catalogsAsync.when(
  ///       loading: () => CircularProgressIndicator(),
  ///       error: (error, stack) => Text('Error: $error'),
  ///       data: (catalogs) => ListView.builder(
  ///         itemCount: catalogs.length,
  ///         itemBuilder: (context, index) {
  ///           final catalog = catalogs[index];
  ///           return ListTile(
  ///             title: Text(catalog['name']),
  ///             subtitle: Text('Rp ${catalog['price']}'),
  ///           );
  ///         },
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```

  // ============================================================
  // Contoh 5: Add to Cart menggunakan Mutation
  // ============================================================
  ///
  /// ```dart
  /// Future<void> addToCart(BuildContext context, String catalogId, int quantity) async {
  ///   final client = GraphQLClient.client();
  ///
  ///   final result = await client.mutate(
  ///     MutationOptions(
  ///       document: gql(GraphQLQueries.addToCart),
  ///       variables: {
  ///         'catalogId': catalogId,
  ///         'quantity': quantity,
  ///       },
  ///     ),
  ///   );
  ///
  ///   if (result.hasException) {
  ///     ScaffoldMessenger.of(context).showSnackBar(
  ///       SnackBar(content: Text('Gagal menambahkan ke keranjang')),
  ///     );
  ///     return;
  ///   }
  ///
  ///   ScaffoldMessenger.of(context).showSnackBar(
  ///     SnackBar(content: Text('Berhasil menambahkan ke keranjang')),
  ///   );
  /// }
  /// ```

  // ============================================================
  // Contoh 6: Create Order menggunakan Mutation
  // ============================================================
  ///
  /// ```dart
  /// Future<void> createOrder(BuildContext context, {
  ///   required List<Map<String, dynamic>> items,
  ///   required String shippingAddress,
  ///   required String shippingPhone,
  ///   String? notes,
  ///   String? voucherCode,
  /// }) async {
  ///   final client = GraphQLClient.client();
  ///
  ///   final result = await client.mutate(
  ///     MutationOptions(
  ///       document: gql(GraphQLQueries.createOrder),
  ///       variables: {
  ///         'input': {
  ///           'items': items.map((item) => {
  ///             'catalogId': item['catalogId'],
  ///             'quantity': item['quantity'],
  ///           }).toList(),
  ///           'shippingAddress': shippingAddress,
  ///           'shippingPhone': shippingPhone,
  ///           'notes': notes,
  ///           'voucherCode': voucherCode,
  ///         },
  ///       },
  ///     ),
  ///   );
  ///
  ///   if (result.hasException) {
  ///     ScaffoldMessenger.of(context).showSnackBar(
  ///       SnackBar(content: Text('Pemesanan gagal: ${result.exception?.message}')),
  ///     );
  ///     return;
  ///   }
  ///
  ///   final order = result.data?['createOrder'];
  ///   ScaffoldMessenger.of(context).showSnackBar(
  ///     SnackBar(content: Text('Pesanan ${order['orderNumber']} berhasil dibuat')),
  ///   );
  /// }
  /// ```

  // ============================================================
  // Contoh 7: Setup GraphQL Provider di main.dart
  // ============================================================
  ///
  /// ```dart
  /// import 'package:flutter/material.dart';
  /// import 'package:graphql_flutter/graphql_flutter.dart';
  /// import 'package:flutter_riverpod/flutter_riverpod.dart';
  /// import 'core/api/graphql_client/graphql_client.dart';
  ///
  /// void main() {
  ///   runApp(
  ///     ProviderScope(
  ///       child: GraphQLProvider(
  ///         client: GraphQLClient.client(),
  ///         child: MyApp(),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class MyApp extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       title: 'Wedding Flower Decoration',
  ///       home: HomeScreen(),
  ///     );
  ///   }
  /// }
  /// ```
}
