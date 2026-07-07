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
  static const String profileFaceScan = '/profile/face-scan';
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
  static const String adminSearch = '/admin/search';

  // CBIR
  static const String cbirSearch = '/cbir/search';
  static const String cbirArithmetic = '/cbir/arithmetic';
  static const String cbirArithmeticOps = '/cbir/arithmetic/ops';
  static const String cbirStats = '/cbir/stats';
  static const String cbirHealth = '/cbir/health';

  // Admin CBIR
  static const String adminSearchImage = '/admin/search/image';
  static const String adminCbirArithmetic = '/admin/cbir/arithmetic';

  // Vouchers
  static const String vouchers = '/vouchers';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationReadAll = '/notifications/read-all';
  static const String notificationUnreadCount = '/notifications/unread-count';
  static const String registerFcmToken = '/notifications/fcm-token';
  static String notificationDelete(String id) => '/notifications/$id';

  // Reviews
  static const String reviews = '/reviews';
  static const String myReviews = '/reviews/user';

  // Chat / Messages
  static const String conversations = '/messages/conversations';
  static const String messagesSend = '/messages/send';
  static const String messagesStart = '/messages/start';
  static const String unreadCount = '/messages/unread-count';
  static const String customersForChat = '/messages/customers';

  // Legal
  static const String legalTerms = '/legal/terms';
  static const String legalPrivacy = '/legal/privacy';
  static const String legalWeddingPolicy = '/legal/wedding-decoration-policy';
  static const String legalHelp = '/legal/help';
  static const String legalAbout = '/legal/about';

  // ─── Admin CRUD ──────────────────────────────────────────────────────────────
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static String adminUser(int id) => '/admin/users/$id';
  static String adminUserToggle(int id) => '/admin/users/$id/toggle-active';
  static const String adminPackages = '/admin/packages';
  static String adminPackage(int id) => '/admin/packages/$id';
  static String adminPackageUpload(int id) => '/admin/packages/$id/upload-image';
  static const String adminProducts = '/admin/products';
  static String adminProduct(int id) => '/admin/products/$id';
  static String adminProductUpload(int id) => '/admin/products/$id/upload-image';
  static const String adminCategories = '/admin/categories';
  static String adminCategory(int id) => '/admin/categories/$id';
  static const String adminOrders = '/admin/orders';
  static String adminOrder(int id) => '/admin/orders/$id';
  static String adminOrderStatus(int id) => '/admin/orders/$id/status';
  static const String adminVouchers = '/admin/vouchers';
  static String adminVoucher(int id) => '/admin/vouchers/$id';
  static const String adminReviews = '/admin/reviews';
  static String adminReview(int id) => '/admin/reviews/$id';
  static const String adminTransactions = '/admin/transactions';
  static String adminTransaction(int id) => '/admin/transactions/$id';
  static const String adminBanks = '/admin/banks';
  static String adminBank(int id) => '/admin/banks/$id';
  static const String adminPaymentMethods = '/admin/payment-methods';
  static String adminPaymentMethod(int id) => '/admin/payment-methods/$id';
  static const String adminHelp = '/admin/helps';
  static String adminHelpItem(int id) => '/admin/helps/$id';
  static const String adminLegalPages = '/admin/legal-pages';
  static String adminLegalPage(int id) => '/admin/legal-pages/$id';
  static const String adminTerms = '/admin/terms';
  static String adminTerm(int id) => '/admin/terms/$id';
  static const String adminPrivacyPolicies = '/admin/privacy-policies';
  static String adminPrivacyPolicy(int id) => '/admin/privacy-policies/$id';
  static const String adminWeddingPolicies = '/admin/wedding-policies';
  static String adminWeddingPolicy(int id) => '/admin/wedding-policies/$id';
  static const String adminNotifications = '/admin/notifications';
  static String adminNotification(int id) => '/admin/notifications/$id';
  static const String adminSendNotification = '/admin/notifications/send';
  static const String adminSendBulkNotification = '/admin/notifications/send-bulk';
  static const String adminInboxes = '/admin/messages/inboxes';
  static String adminInbox(int id) => '/admin/messages/inboxes/$id';
  static const String adminSendMessage = '/admin/messages/send';
  static String adminMessage(int id) => '/admin/messages/$id';
  static const String adminWishlists = '/admin/wishlists';
  static String adminWishlist(int id) => '/admin/wishlists/$id';

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
