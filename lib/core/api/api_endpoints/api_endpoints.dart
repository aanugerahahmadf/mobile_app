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

  // Tantangan 2FA setelah Sign In. Padanan OtpEmailOrTwoFactory di panel
  // Filament: login() membalas tanpa token bila 2FA akun aktif, lalu kode
  // diverifikasi lewat endpoint di sini sebelum token benar-benar terbit.
  static const String twoFactorVerify = '/auth/two-factor/verify';
  static const String twoFactorResend = '/auth/two-factor/resend';

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

  // Catalog (paket & produk kini satu entitas: /catalog)
  static const String catalog = '/catalog';
  static const String catalogFeatured = '/catalog/featured';
  static const String catalogOnSale = '/catalog/on-sale';
  static const String catalogPublic = '/catalog/public';

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
  static String reportPdf(String id) => '/reports/$id/pdf';

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
  static String catalogDetail(String id) => '/catalog/$id';
  static String catalogTiers(String id) => '/catalog/$id/tiers';
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
  static const String chatCalls = '/messages/calls';
  static const String guestChatCalls = '/messages/guest/calls';
  static String guestChatCallState(String token) =>
      '/messages/guest/calls/$token';
  static String guestChatCallSignal(String token) =>
      '/messages/guest/calls/$token/signal';
  static String guestChatCallEnd(String token) =>
      '/messages/guest/calls/$token/end';
  static String chatCallState(String token) => '/messages/calls/$token';
  static String chatCallSignal(String token) => '/messages/calls/$token/signal';
  static String chatCallAccept(String token) => '/messages/calls/$token/accept';
  static String chatCallEnd(String token) => '/messages/calls/$token/end';
  static String chatCallActive(String inboxId) =>
      '/messages/$inboxId/calls/active';
  static String guestChatCallActive(String inboxId) =>
      '/messages/guest/$inboxId/calls/active';
  static String voucherClaim(String id) => '/vouchers/$id/claim';
  static String notificationRead(String id) => '/notifications/$id/read';
  static String catalogReviews(String id) => '/reviews/catalog/$id';
  static String catalogReviewSummary(String id) =>
      '/reviews/catalog/$id/summary';
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

  // Setup 2FA. Dipakai DUA halaman: Two Factor Auth (tengah alur auth, akhir
  // di Home) dan Two Factor Setup (Pengaturan, akhir kembali ke daftar
  // Keamanan). Keduanya endpoint yang sama -- sama seperti di Filament, di
  // mana Auth\TwoFactorAuth dan TwoFactorySetup sama-sama turunan
  // TwoFactorAuthenticatorPage.
  static const String securityTwoFactorSetup = '/security/two-factor/setup';
  static const String securityTwoFactorSetupVerify =
      '/security/two-factor/setup/verify';
  static const String securityTwoFactorSetupResend =
      '/security/two-factor/setup/resend';
  static const String securityTrustedDevices = '/security/trusted-devices';
  static String securityRemoveTrustedDevice(int id) =>
      '/security/trusted-devices/$id';
  // Jawaban "Perangkat Baru -- Apakah Ini Anda?": verify = "Ya, Ini Saya",
  // reject = "Bukan Saya" (token HP yang memanggil ikut dicabut di server).
  static String securityVerifyTrustedDevice(int id) =>
      '/security/trusted-devices/$id/verify';
  static String securityRejectTrustedDevice(int id) =>
      '/security/trusted-devices/$id/reject';
  static const String securityRemoveAllTrustedDevices =
      '/security/trusted-devices';
  static const String securityRemoveAllOtherSessions =
      '/security/sessions/remove-all';
  static const String securityChangeEmailSendOtp =
      '/security/change-email/send-otp';
  static const String securityChangeEmailVerifyOtp =
      '/security/change-email/verify-otp';
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
