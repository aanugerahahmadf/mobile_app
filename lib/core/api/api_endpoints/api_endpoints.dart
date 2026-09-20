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
  static const String facebookLogin = '/auth/facebook';
  static const String appleLogin = '/auth/apple';

  // User & Profile
  static const String user = '/user';
  static const String deleteAccount = '/user/account';
  static const String profile = '/profile';
  static const String profileAvatar = '/profile/avatar';
  static const String changePassword = '/profile/change-password';
  static const String dashboard = '/profile/dashboard';
  static const String profileKtpNumber = '/profile/ktp';
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

  // CBIR
  static const String cbirSearch = '/cbir/search';
  static const String cbirArithmetic = '/cbir/arithmetic';
  static const String cbirArithmeticOps = '/cbir/arithmetic/ops';
  static const String cbirStats = '/cbir/stats';
  static const String cbirEvaluate = '/cbir/evaluate';
  static const String cbirHealth = '/cbir/health';

  // Vendors
  static const String vendors = '/vendors';
  static String vendorDetail(String id) => '/vendors/$id';

  // Vouchers
  static const String vouchers = '/vouchers';
  static const String voucherValidate = '/vouchers/validate';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationReadAll = '/notifications/read-all';
  static const String notificationUnreadCount = '/notifications/unread-count';
  static const String registerFcmToken = '/notifications/fcm-token';
  static String notificationDelete(String id) => '/notifications/$id';

  // Reviews
  static const String reviews = '/reviews';
  static const String myReviews = '/reviews/user';
  static String userReviews(String userId) => '/reviews/user/$userId';
  static String review(int id) => '/reviews/$id';

  // Reports
  static const String reports = '/reports';
  static const String myReports = '/reports';

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
  static const String legalAbout = '/legal/about';

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
  static String conversationMessages(String id) =>
      '/messages/conversations/$id';
  static String messageDelete(String id) => '/messages/$id/delete';
  static String messageStar(String id) => '/messages/$id/star';
  static String messageForward(String id) => '/messages/$id/forward';
  static String messageReact(String id) => '/messages/$id/react';
  static String messageRead(String inboxId) => '/messages/$inboxId/read';
  static String messageRate(String inboxId) => '/messages/$inboxId/rate';
  static const String guestChatStart = '/messages/guest/start';
  static const String guestChatSend = '/messages/guest/send';
  static String guestChatMessages(String inboxId) => '/messages/guest/$inboxId';
  static String voucherClaim(String id) => '/vouchers/$id/claim';
  static String notificationRead(String id) => '/notifications/$id/read';
  static String packageReviews(String id) => '/reviews/package/$id';
  static String productReviews(String id) => '/reviews/product/$id';
  static String packageReviewSummary(String id) =>
      '/reviews/package/$id/summary';
  static String productReviewSummary(String id) =>
      '/reviews/product/$id/summary';
  static String reviewVote(int id) => '/reviews/$id/vote';
  static String reviewReply(int id) => '/reviews/$id/reply';
  static String reviewDeleteReply(int reviewId, int replyId) =>
      '/reviews/$reviewId/reply/$replyId';
  static String orderConfirmPayment(String id) =>
      '/bookings/$id/confirm-payment';
  static String orderVirtualAccount(String id) =>
      '/bookings/$id/virtual-account';
  static String orderQris(String id) => '/bookings/$id/qris';
  static String bookingUploadProof(String id) => '/bookings/$id/upload-proof';
  static String invoiceDownload(String id) => '/bookings/$id/invoice';
  static String invoiceEmail(String id) => '/bookings/$id/invoice/email';

  // Security
  static const String securityCheckup = '/security/checkup';
  static const String securityRecentEmails = '/security/recent-emails';
  static const String securityTwoFactorStatus = '/security/two-factor/status';
  static const String securityTwoFactorToggle = '/security/two-factor/toggle';
  static const String securityBackupCodes = '/security/two-factor/backup-codes';
  static const String securityTrustedDevices = '/security/trusted-devices';
  static String securityRemoveTrustedDevice(int id) =>
      '/security/trusted-devices/$id';
  static const String securitySavedLogin = '/security/saved-login';
  static const String securitySavedLoginToggle = '/security/saved-login/toggle';
  static const String securityLoginActivity = '/security/login-activity';
  static String securityRemoveSession(int id) => '/security/login-activity/$id';

  // Dropdown Options (KYC fields)
  static const String dropdownOptions = '/dropdown-options';

  // Regions
  static const String regionProvinces = '/regions/provinces';
  static String regionCities(String provinceCode) =>
      '/regions/cities/$provinceCode';
  static String regionDistricts(String cityCode) =>
      '/regions/districts/$cityCode';
  static String regionVillages(String districtCode) =>
      '/regions/villages/$districtCode';

  // App Lock
  static const String appLock = '/profile/app-lock';
  static const String appLockPin = '/profile/app-lock/pin';
  static const String appLockPinVerify = '/profile/app-lock/pin/verify';
  static const String appLockFaceEnroll = '/profile/app-lock/face-enroll';
  static const String appLockFaceVerify = '/profile/app-lock/face-verify';

  // World Regions
  static const String worldCountries = '/world-regions/countries';
  static const String worldStates = '/world-regions/states';
  static const String worldCities = '/world-regions/cities';

  // Geo (GeoNames — full hierarchy for all countries)
  static const String geoDistricts = '/geo/admin2';
  static const String geoVillages = '/geo/admin3';
  static const String geoPostalCodes = '/geo/postal-codes';
}
