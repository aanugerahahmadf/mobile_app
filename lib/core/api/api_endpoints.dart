class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String googleLogin = '/auth/google';

  // User & Profile
  static const String user = '/user';
  static const String profile = '/profile';
  static const String profileAvatar = '/profile/avatar';
  static const String changePassword = '/profile/change-password';
  static const String dashboard = '/profile/dashboard';
  static const String profileNik = '/profile/nik';
  static const String profileKtp = '/profile/ktp-photo';
  static const String profileSelfie = '/profile/selfie';
  static const String profileCompletion = '/profile/completion';

  // Home & Categories
  static const String home = '/home';
  static const String categories = '/categories';
  static const String categoriesWithPackages = '/categories-with-packages';

  // Packages
  static const String packages = '/packages';
  static const String packagesFeatured = '/packages/featured';
  static const String packagesOnSale = '/packages/on-sale';

  // Products
  static const String products = '/products';
  static const String productsFeatured = '/products/featured';
  static const String productsOnSale = '/products/on-sale';

  // Cart
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';

  // Wishlist
  static const String wishlist = '/wishlist';
  static const String wishlistToggle = '/wishlist/toggle';

  // Bookings / Orders
  static const String bookings = '/bookings';

  // Search
  static const String search = '/search';
  static const String searchImage = '/search/image';

  // CBIR
  static const String cbirSearch = '/cbir/search';
  static const String cbirStats = '/cbir/stats';
  static const String cbirHealth = '/cbir/health';

  // Vouchers
  static const String vouchers = '/vouchers';

  // Notifications
  static const String notifications = '/notifications';

  // Reviews
  static const String reviews = '/reviews';
  static const String myReviews = '/reviews/user';

  // Chat / Messages
  static const String conversations = '/messages/conversations';
  static const String messagesSend = '/messages/send';
  static const String messagesStart = '/messages/start';
  static const String unreadCount = '/messages/unread-count';

  // Legal
  static const String legalTerms = '/legal/terms';
  static const String legalPrivacy = '/legal/privacy';
  static const String legalWeddingPolicy = '/legal/wedding-decoration-policy';
  static const String legalHelp = '/legal/help';

  // Wallet
  static const String wallet = '/wallet';
  static const String walletHistory = '/wallet/history';

  // Dynamic endpoints
  static String packageDetail(String id) => '/packages/$id';
  static String productDetail(String id) => '/products/$id';
  static String cartItem(String id) => '/cart/$id';
  static String bookingDetail(String id) => '/bookings/$id';
  static String bookingPay(String id) => '/bookings/$id/pay';
  static String bookingCancel(String id) => '/bookings/$id/cancel';
  static String wishlistItem(String packageId) => '/wishlist/$packageId';
  static String conversationMessages(String id) => '/messages/conversations/$id';
  static String voucherClaim(String id) => '/vouchers/$id/claim';
  static String notificationRead(String id) => '/notifications/$id/read';
  static String packageReviews(String id) => '/reviews/package/$id';
  static String invoiceDownload(String id) => '/bookings/$id/invoice';
  static String invoiceEmail(String id) => '/bookings/$id/invoice/email';

  // Regions
  static const String regionProvinces = '/regions/provinces';
  static String regionCities(String provinceCode) => '/regions/cities/$provinceCode';
  static String regionDistricts(String cityCode) => '/regions/districts/$cityCode';
  static String regionVillages(String districtCode) => '/regions/villages/$districtCode';

  // World Regions
  static const String worldCountries = '/world-regions/countries';
  static const String worldStates = '/world-regions/states';
  static const String worldCities = '/world-regions/cities';

  // Geo (GeoNames — full hierarchy for all countries)
  static const String geoAdmin2 = '/geo/admin2';
  static const String geoAdmin3 = '/geo/admin3';
  static const String geoPostalCodes = '/geo/postal-codes';
}
