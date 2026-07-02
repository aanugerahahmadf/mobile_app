import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/splash/presentation/pages/landing_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/otp_email_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/main_shell.dart';
import '../../features/auth/presentation/pages/switch_account_page.dart';
import '../../features/catalog/presentation/pages/catalog_list_page.dart';
import '../../features/catalog/presentation/pages/catalog_detail_page.dart';
import '../../features/cbir/presentation/pages/cbir_result_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/order/presentation/pages/checkout_page.dart';
import '../../features/order/presentation/pages/order_history_page.dart';
import '../../features/order/presentation/pages/order_detail_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
import '../../features/search/presentation/pages/search_results_page.dart';
import '../../features/notification/presentation/pages/notification_page.dart';
import '../../features/profile/presentation/pages/notification_settings_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/complete_profile_page.dart';
import '../../features/profile/presentation/pages/profile_field_page.dart';
import '../../features/profile/presentation/pages/face_scanner_page.dart';
import '../../features/payment/presentation/pages/midtrans_webview_page.dart';
import '../../features/review/presentation/pages/my_reviews_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';
import '../../features/voucher/presentation/pages/voucher_list_page.dart';
import '../../features/voucher/presentation/pages/voucher_detail_page.dart';
import '../../features/voucher/data/models/voucher_model.dart';
import '../../features/catalog/presentation/pages/catalog_combined_page.dart';
import '../../features/legal/presentation/pages/terms_of_service_page.dart';
import '../../features/legal/presentation/pages/privacy_policy_page.dart';
import '../../features/legal/presentation/pages/wedding_policy_page.dart';
import '../../features/legal/presentation/pages/help_center_page.dart';
import '../../features/legal/presentation/pages/privacy_and_term_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/pages/app_lock_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/landing',
  redirect: (context, state) async {
    if (state.matchedLocation == '/onboarding') return null;
    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
    if (!onboardingSeen) return '/onboarding';
    return null;
  },
  routes: [
    GoRoute(path: '/landing', builder: (_, _) => const LandingPage()),
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingPage()),
    GoRoute(path: '/verify-otp', builder: (_, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return OtpEmailVerificationPage(
        email: extra?['email'] as String?,
        purpose: (extra?['purpose'] as String?) ?? 'verify_email',
      );
    }),
    GoRoute(path: '/forgot-password', builder: (_, _) => const ForgotPasswordPage()),
    GoRoute(path: '/reset-password', builder: (_, _) => const ResetPasswordPage()),
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) => MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomePage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/orders', builder: (_, _) => const OrderHistoryPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/chat-list', builder: (_, _) => const ChatListPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/cart', builder: (_, _) => const CartPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (_, _) => const ProfilePage()),
        ]),
      ],
    ),
    GoRoute(
      path: '/catalog/:type',
      builder: (_, state) => CatalogListPage(type: state.pathParameters['type']!),
    ),
    GoRoute(
      path: '/catalog/:type/:id',
      builder: (_, state) => CatalogDetailPage(
        type: state.pathParameters['type']!,
        id: state.pathParameters['id']!,
      ),
    ),
    GoRoute(path: '/cbir-result', builder: (_, _) => const CbirResultPage()),
    GoRoute(
      path: '/checkout',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CheckoutPage(type: extra?['type'] as String?, id: extra?['id'] as String?);
      },
    ),
    GoRoute(path: '/order/:id', builder: (_, state) => OrderDetailPage(id: state.pathParameters['id']!)),
    GoRoute(path: '/chat/:id', builder: (_, state) => ChatDetailPage(id: state.pathParameters['id']!)),
    GoRoute(path: '/notifications', builder: (_, _) => const NotificationPage()),
    GoRoute(path: '/notification-settings', builder: (_, _) => const NotificationSettingsPage()),
    GoRoute(
      path: '/search',
      builder: (_, state) {
        final query = (state.extra as Map<String, dynamic>?)?['query'] as String? ?? '';
        return SearchResultsPage(query: query);
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (_, state) {
        final section = (state.extra as Map<String, dynamic>?)?['section'] as String?;
        return EditProfilePage(scrollToSection: section);
      },
    ),
    GoRoute(
      path: '/complete-profile',
      builder: (_, state) {
        final section = (state.extra as Map<String, dynamic>?)?['section'] as String?;
        return CompleteProfilePage(scrollToSection: section);
      },
    ),
    GoRoute(
      path: '/profile-field',
      builder: (_, state) {
        final key = (state.extra as Map<String, dynamic>?)?['key'] as String? ?? 'full_name';
        return ProfileFieldPage(fieldKey: key);
      },
    ),
    GoRoute(path: '/face-scanner', builder: (_, _) => const FaceScannerPage()),
    GoRoute(path: '/my-reviews', builder: (_, _) => const MyReviewsPage()),
    GoRoute(path: '/history', builder: (_, _) => const HistoryPage()),
    GoRoute(path: '/vouchers', builder: (_, _) => const VoucherListPage()),
    GoRoute(path: '/vouchers/:id', builder: (_, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final voucher = extra != null ? VoucherModel.fromJson(extra) : null;
      return VoucherDetailPage(voucher: voucher ?? VoucherModel(id: 0, code: '', discountAmount: 0, discountType: ''));
    }),
    GoRoute(path: '/wishlist', builder: (_, _) => const WishlistPage()),
    GoRoute(path: '/catalog', builder: (_, _) => const CatalogCombinedPage()),
    GoRoute(path: '/terms-of-service', builder: (_, _) => const TermsOfServicePage()),
    GoRoute(path: '/privacy-policy', builder: (_, _) => const PrivacyPolicyPage()),
    GoRoute(path: '/wedding-policy', builder: (_, _) => const WeddingPolicyPage()),
    GoRoute(path: '/help-center', builder: (_, _) => const HelpCenterPage()),
    GoRoute(path: '/legal/privacy-term', builder: (_, _) => const PrivacyAndTermPage()),
    GoRoute(path: '/switch-account', builder: (_, _) => const SwitchAccountPage()),
    GoRoute(path: '/settings', builder: (_, _) => const SettingsPage()),
    GoRoute(path: '/app-lock', builder: (_, _) => const AppLockPage()),
    GoRoute(
      path: '/payment/:orderId',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return MidtransWebviewPage(
          orderId: state.pathParameters['orderId']!,
          initialSnapToken: extra?['snap_token'] as String?,
        );
      },
    ),
  ],
);
