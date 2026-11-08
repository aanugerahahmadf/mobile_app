import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Features/Splash/Presentation/Screens/Landing/LandingScreen.dart';
import '../../../Features/Splash/Presentation/Screens/Startup/StartupScreen.dart';
import '../../../Features/Home/Presentation/Screens/Home/HomeScreen.dart';
import '../../../Features/Home/Presentation/Screens/Main/Main.dart';
import '../../../Features/Auth/Presentation/Screens/SwitchAccount/SwitchAccountScreen.dart';
import '../../../Features/Catalog/Presentation/Screens/CatalogDetail/CatalogDetailScreen.dart';
import '../../../Features/Cbir/Presentation/Screens/CbirResult/CbirResultScreen.dart';
import '../../../Features/Cart/Presentation/Screens/Cart/CartScreen.dart';
import '../../../Features/Order/Presentation/Screens/Checkout/CheckoutScreen.dart';
import '../../../Features/Order/Presentation/Screens/OrderHistory/OrderHistoryScreen.dart';
import '../../../Features/Order/Presentation/Screens/OrderDetail/OrderDetailScreen.dart';
import '../../../Features/Chat/Presentation/Screens/ChatList/ChatListScreen.dart';
import '../../../Features/Chat/Presentation/Screens/ChatDetail/ChatDetailScreen.dart';
import '../../../Features/Search/Presentation/Screens/Search/SearchScreen.dart';
import '../../../Features/Notification/Presentation/Screens/Notification/NotificationScreen.dart';
import '../../../Features/Notification/Presentation/Screens/NotificationDetail/NotificationDetailScreen.dart';
import '../../../Features/Notification/Data/Models/NotificationModel/NotificationModel.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/NotificationSettings/NotificationSettingsScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SignInAndRecovery/ChangePassword/ChangePasswordScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SignInAndRecovery/TwoFaktorAuthentication/TwoFactorSettingsScreen.dart';
// Alias supaya dua halaman 2FA tidak tertukar: yang di `features/auth`
// adalah Two Factor AUTH (tengah alur, akhir di Home), yang di sini Two
// Factor SETUP (dari Pengaturan, akhir kembali ke daftar Keamanan).
import '../../../Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SignInAndRecovery/TwoFaktorAuthentication/TwoFactorSetupScreen.dart'
    as security_two_factor_setup;
import '../../../Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SignInAndRecovery/SavedSignIn/SavedLoginInfoScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SignInAndRecovery/TwoFaktorAuthentication/TrustedDevicesScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/WhereYouSignIn/LoginActivityScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/LatestEmail/RecentEmailsScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/SecurityCheck/SecurityCheckupScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Profile/ProfileScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Profile/EditProfile/EditProfileScreen.dart';
import '../../../Features/Auth/Presentation/Screens/CompleteProfile/CompleteProfileScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Profile/FieldProfile/ProfileFieldScreen.dart';
import '../../../Features/Profile/Presentation/Screens/FaceScanner/FaceScannerScreen.dart';
import '../../../Features/Profile/Presentation/Screens/DocumentScanner/DocumentScannerScreen.dart';
import '../../../Features/Payment/Presentation/Screens/PaymentInstruction/PaymentInstructionScreen.dart';
import '../../../Features/Payment/Presentation/Screens/PaymentMethodDetail/PaymentMethodDetailScreen.dart';
import '../../../Features/Payment/Presentation/Screens/PaymentWebview/PaymentWebviewScreen.dart';
import '../../../Features/Payment/Domain/PaymentMethodInfo/PaymentMethodInfo.dart';
import '../../../Features/Review/Presentation/Screens/MyReviews/MyReviewsScreen.dart';
import '../../../Features/Review/Presentation/Screens/ReviewList/ReviewListScreen.dart';
import '../../../Features/History/Presentation/Screens/History/HistoryScreen.dart';
import '../../../Features/Favorite/Presentation/Screens/Favorite/Favoritescreen.dart';
import '../../../Features/Voucher/Presentation/Screens/VoucherList/VoucherListScreen.dart';
import '../../../Features/Voucher/Presentation/Screens/VoucherDetail/VoucherDetailScreen.dart';
import '../../../Features/Voucher/Data/Models/VoucherModel/VoucherModel.dart';
import '../../../Features/Catalog/Presentation/Screens/CatalogGrid/CatalogGridScreen.dart';
import '../../../Features/Legal/Presentation/Screens/TermsOfService/TermsOfServiceScreen.dart';
import '../../../Features/Legal/Presentation/Screens/PrivacyPolicy/PrivacyPolicyScreen.dart';
import '../../../Features/Legal/Presentation/Screens/WeddingPolicy/WeddingPolicyScreen.dart';
import '../../../Features/Legal/Presentation/Screens/HelpCenter/HelpCenterScreen.dart';
import '../../../Features/Legal/Presentation/Screens/PrivacyAndTerm/PrivacyAndTermScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/SettingsScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/StorageAndData/StorageAndDataScreen.dart';

import '../../../Features/Profile/Presentation/Screens/Settings/Language/LanguageScreen.dart';
import '../../../Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/PasswordAndSecurityScreen.dart';
import '../../Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';
import '../../../Features/Auth/Presentation/Screens/AppLock/AppLockScreen.dart';
import '../../../Features/Auth/Presentation/Screens/SecurityQuestion/SecurityQuestionScreen.dart';
import '../../../Features/Auth/Presentation/Screens/TwoFactorAuth/TwoFactorAuthScreen.dart';
import '../../../Features/Auth/Presentation/Screens/TwoFactorVerify/TwoFactorVerifyScreen.dart';
import '../../../Features/Auth/Presentation/Screens/OtpEmailVerification/OtpEmailVerificationScreen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class _RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final path = route.settings.name;
    if (path != null && path.isNotEmpty && path != '/') {
      AppNavigationTrail.instance.record(path);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('last_route', path);
      });
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final path = newRoute?.settings.name;
    if (path != null && path.isNotEmpty && path != '/') {
      AppNavigationTrail.instance.record(path);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('last_route', path);
      });
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppNavigationTrail.instance.pop(route.settings.name);
  }
}

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/startup',
  observers: [_RouteObserver()],
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
    if (state.matchedLocation == '/startup') return null;
    // Jangan pernah memantulkan pengguna yang SEDANG di '/landing', kalau tidak
    // `context.go('/home')` dari LandingScreen akanmental balik ke sini terus.
    if (onboardingSeen) return null;
    final atLanding = state.matchedLocation == '/landing';
    if (atLanding) return null;
    return '/landing';
  },
  routes: [
    GoRoute(path: '/startup', builder: (_, _) => const StartupScreen()),
    GoRoute(path: '/landing', builder: (_, _) => const LandingScreen()),
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (_, _) => const OrderHistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chat-list',
              builder: (_, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return ChatListScreen(
                  isGuestMode: extra?['isGuestMode'] == true,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/cart', builder: (_, _) => const CartScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/catalog/:id',
      builder: (_, state) =>
          CatalogDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(path: '/cbir-result', builder: (_, _) => const CbirResultScreen()),
    GoRoute(
      path: '/checkout',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CheckoutScreen(
          type: extra?['type'] as String?,
          id: extra?['id'] as String?,
          tierId: extra?['tier_id'] as int?,
        );
      },
    ),
    GoRoute(
      path: '/order/:id',
      builder: (_, state) => OrderDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ChatDetailScreen(
          id: state.pathParameters['id']!,
          csCategory: extra?['cs_category'] as String?,
          guestId: (extra?['guestId'] ?? extra?['guest_id']) as String?,
        );
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (_, _) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/notification/:id',
      builder: (_, state) {
        final notif = state.extra;
        if (notif is NotificationModel) {
          return NotificationDetailScreen(notification: notif);
        }
        return const NotificationScreen();
      },
    ),
    GoRoute(
      path: '/notification-settings',
      builder: (_, _) => const NotificationSettingsScreen(),
    ),
    GoRoute(
      path: '/password-and-security',
      builder: (_, _) => const PasswordAndSecurityScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (_, _) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/two-factor-settings',
      builder: (_, _) => const TwoFactorSettingsScreen(),
    ),
    // Dua halaman 2FA yang berbeda, sama seperti di backend:
    //
    //   /two-factor-setup          -> Two Factor Auth  (Auth\TwoFactorAuth)
    //                                 tengah alur auth, selesai ke Home
    //   /security/two-factor-setup -> Two Factor Setup (TwoFactorySetup)
    //                                 dari Pengaturan, selesai kembali ke
    //                                 daftar Keamanan
    //
    // Dipisah karena tujuan akhirnya berbeda. Alurnya sendiri sama, dan
    // keduanya memakai TwoFactorSetupFlow yang sama.
    GoRoute(
      path: '/two-factor-setup',
      builder: (_, _) => const TwoFactorAuthScreen(),
    ),
    GoRoute(
      path: '/security/two-factor-setup',
      builder: (_, _) => const security_two_factor_setup.TwoFactorSetupScreen(),
    ),
    GoRoute(
      path: '/security-question',
      builder: (_, _) => const SecurityQuestionScreen(),
    ),
    GoRoute(
      path: '/otp-email-verification',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return OtpEmailVerificationScreen(
          email: extra?['email'] as String?,
          purpose: extra?['purpose'] as String? ?? 'verify_email',
        );
      },
    ),
    GoRoute(
      path: '/two-factor-verify',
      builder: (_, _) => const TwoFactorVerifyScreen(),
    ),
    GoRoute(
      path: '/saved-login-info',
      builder: (_, _) => const SavedLoginInfoScreen(),
    ),
    GoRoute(
      path: '/trusted-devices',
      builder: (_, _) => const TrustedDevicesScreen(),
    ),
    GoRoute(
      path: '/login-activity',
      builder: (_, _) => const LoginActivityScreen(),
    ),
    GoRoute(
      path: '/recent-emails',
      builder: (_, _) => const RecentEmailsScreen(),
    ),
    GoRoute(
      path: '/security-checkup',
      builder: (_, _) => const SecurityCheckupScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (_, state) {
        final query =
            (state.extra as Map<String, dynamic>?)?['query'] as String? ?? '';
        return SearchScreen(initialQuery: query);
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (_, state) {
        final section =
            (state.extra as Map<String, dynamic>?)?['section'] as String?;
        return EditProfileScreen(scrollToSection: section);
      },
    ),
    GoRoute(
      path: '/complete-profile',
      builder: (_, state) {
        final section =
            (state.extra as Map<String, dynamic>?)?['section'] as String?;
        return CompleteProfileScreen(scrollToSection: section);
      },
    ),
    GoRoute(
      path: '/profile-field',
      builder: (_, state) {
        final key =
            (state.extra as Map<String, dynamic>?)?['key'] as String? ??
            'full_name';
        return ProfileFieldScreen(fieldKey: key);
      },
    ),
    GoRoute(
      path: '/face-scanner',
      builder: (_, _) => const FaceScannerScreen(),
    ),
    GoRoute(
      path: '/document-scanner',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return DocumentScannerScreen(
          docType: extra?['docType'] as String? ?? 'ktp',
        );
      },
    ),
    GoRoute(path: '/my-reviews', builder: (_, _) => const MyReviewsScreen()),
    GoRoute(
      path: '/write-review',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ReviewListScreen(
          catalogId: extra?['catalog_id'] as String? ?? '',
          catalogName: extra?['name'] as String? ?? '',
        );
      },
    ),
    GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
    GoRoute(path: '/vouchers', builder: (_, _) => const VoucherListScreen()),
    GoRoute(
      path: '/vouchers/:id',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final voucher = extra != null ? VoucherModel.fromJson(extra) : null;
        return VoucherDetailScreen(
          voucher:
              voucher ??
              VoucherModel(
                id: 0,
                code: '',
                discountAmount: 0,
                discountType: '',
              ),
        );
      },
    ),
    GoRoute(path: '/favorite', builder: (_, _) => const Favoritescreen()),
    GoRoute(path: '/Favorite', builder: (_, _) => const Favoritescreen()),
    GoRoute(
      path: '/catalog',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CatalogGridScreen(
          initialCategoryId: extra?['category_id'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/terms-of-service',
      builder: (_, _) => const TermsOfServiceScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (_, _) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/wedding-policy',
      builder: (_, _) => const WeddingPolicyScreen(),
    ),
    GoRoute(path: '/help-center', builder: (_, _) => const HelpCenterScreen()),
    GoRoute(
      path: '/legal/privacy-term',
      builder: (_, _) => const PrivacyAndTermScreen(),
    ),
    GoRoute(
      path: '/switch-account',
      builder: (_, _) => const SwitchAccountScreen(),
    ),
    GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    GoRoute(
      path: '/storage-and-data',
      builder: (_, _) => const StorageAndDataScreen(),
    ),
    GoRoute(path: '/language', builder: (_, _) => const LanguageScreen()),
    GoRoute(path: '/app-lock', builder: (_, _) => const AppLockScreen()),
    GoRoute(
      path: '/payment/:orderId',
      builder: (_, state) =>
          PaymentInstructionScreen(orderId: state.pathParameters['orderId']!),
    ),
    GoRoute(
      path: '/payment-method/:orderId',
      builder: (_, state) => PaymentMethodDetailScreen(
        orderId: state.pathParameters['orderId']!,
        method: state.extra as PaymentMethodInfo,
      ),
    ),
    GoRoute(
      path: '/payment-webview',
      builder: (_, state) {
        final extra = state.extra as Map<String, String>;
        return PaymentWebViewScreen(
          url: extra['url'] ?? '',
          title: extra['title'] ?? '',
        );
      },
    ),
  ],
);
