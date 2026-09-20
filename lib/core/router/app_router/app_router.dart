import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/splash/presentation/pages/landing/landing_page.dart';
import '../../../features/home/presentation/pages/home/home_page.dart';
import '../../../features/home/presentation/pages/main/main.dart';
import '../../../features/auth/presentation/pages/switch_account/switch_account_page.dart';
import '../../../features/catalog/presentation/pages/catalog_list/catalog_list_page.dart';
import '../../../features/catalog/presentation/pages/catalog_detail/catalog_detail_page.dart';
import '../../../features/cbir/presentation/pages/cbir_result/cbir_result_page.dart';
import '../../../features/cart/presentation/pages/cart/cart_page.dart';
import '../../../features/order/presentation/pages/checkout/checkout_page.dart';
import '../../../features/order/presentation/pages/order_history/order_history_page.dart';
import '../../../features/order/presentation/pages/order_detail/order_detail_page.dart';
import '../../../features/chat/presentation/pages/chat_list/chat_list_page.dart';
import '../../../features/chat/presentation/pages/chat_detail/chat_detail_page.dart';
import '../../../features/search/presentation/pages/search_results/search_results_page.dart';
import '../../../features/notification/presentation/pages/notification/notification_page.dart';
import '../../../features/notification/presentation/pages/notification_detail/notification_detail_page.dart';
import '../../../features/notification/data/models/notification_model/notification_model.dart';
import '../../../features/profile/presentation/pages/settings/notification_settings/notification_settings_page.dart';
import '../../../features/profile/presentation/pages/settings/password_and_security/sign_in_and_recovery/change_password/change_password_page.dart';
import '../../../features/profile/presentation/pages/settings/password_and_security/sign_in_and_recovery/two_faktor_authentication/two_factor_settings_page.dart';
import '../../../features/profile/presentation/pages/settings/password_and_security/sign_in_and_recovery/saved_sign_in/saved_login_info_page.dart';
import '../../../features/profile/presentation/pages/settings/password_and_security/sign_in_and_recovery/two_faktor_authentication/trusted_devices_page.dart';
import '../../../features/profile/presentation/pages/settings/password_and_security/security_check/where_you_sign_in/login_activity_page.dart';
import '../../../features/profile/presentation/pages/settings/password_and_security/security_check/latest_email/recent_emails_page.dart';
import '../../../features/profile/presentation/pages/settings/password_and_security/security_check/security_check/security_checkup_page.dart';
import '../../../features/profile/presentation/pages/profile/profile_page.dart';
import '../../../features/profile/presentation/pages/profile/edit_profile/edit_profile_page.dart';
import '../../../features/profile/presentation/pages/profile/complete_profile/complete_profile_page.dart';
import '../../../features/profile/presentation/pages/profile/field_profile/profile_field_page.dart';
import '../../../features/profile/presentation/pages/face_scanner/face_scanner_page.dart';
import '../../../features/profile/presentation/pages/document_scanner/document_scanner_page.dart';
import '../../../features/payment/presentation/pages/payment_instruction/payment_instruction_page.dart';
import '../../../features/payment/presentation/pages/payment_method_detail/payment_method_detail_page.dart';
import '../../../features/payment/presentation/pages/payment_webview/payment_webview_page.dart';
import '../../../features/payment/domain/payment_method_info/payment_method_info.dart';
import '../../../features/review/presentation/pages/my_reviews/my_reviews_page.dart';
import '../../../features/review/presentation/pages/review_list/review_list_page.dart';
import '../../../features/review/presentation/pages/all_reviews/all_reviews_page.dart';
import '../../../features/review/presentation/pages/user_reviews/user_reviews_page.dart';
import '../../../features/history/presentation/pages/history/history_page.dart';
import '../../../features/wishlist/presentation/pages/wishlist/wishlist_page.dart';
import '../../../features/voucher/presentation/pages/voucher_list/voucher_list_page.dart';
import '../../../features/voucher/presentation/pages/voucher_detail/voucher_detail_page.dart';
import '../../../features/voucher/data/models/voucher_model/voucher_model.dart';
import '../../../features/catalog/presentation/pages/catalog_combined/catalog_combined_page.dart';
import '../../../features/legal/presentation/pages/terms_of_service/terms_of_service_page.dart';
import '../../../features/legal/presentation/pages/privacy_policy/privacy_policy_page.dart';
import '../../../features/legal/presentation/pages/wedding_policy/wedding_policy_page.dart';
import '../../../features/legal/presentation/pages/help_center/help_center_page.dart';
import '../../../features/legal/presentation/pages/privacy_and_term/privacy_and_term_page.dart';
import '../../../features/profile/presentation/pages/settings/settings_page.dart';
import '../../../features/profile/presentation/pages/settings/language/language_page.dart';
import '../../../features/profile/presentation/pages/settings/password_and_security/password_and_security_page.dart';
import '../../../features/auth/presentation/pages/app_lock/app_lock_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class _RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final path = route.settings.name;
    if (path != null && path.isNotEmpty && path != '/') {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('last_route', path);
      });
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final path = newRoute?.settings.name;
    if (path != null && path.isNotEmpty && path != '/') {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('last_route', path);
      });
    }
  }
}

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/landing',
  observers: [_RouteObserver()],
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
    if (!onboardingSeen) return '/landing';
    return null;
  },
  routes: [
    GoRoute(path: '/landing', builder: (_, _) => const LandingPage()),
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/home', builder: (_, _) => const HomePage())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (_, _) => const OrderHistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chat-list',
              builder: (_, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return ChatListPage(isGuestMode: extra?['isGuestMode'] == true);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/cart', builder: (_, _) => const CartPage())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfilePage()),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/catalog/:type',
      builder: (_, state) =>
          CatalogListPage(type: state.pathParameters['type']!),
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
        return CheckoutPage(
          type: extra?['type'] as String?,
          id: extra?['id'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/order/:id',
      builder: (_, state) => OrderDetailPage(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ChatDetailPage(
          id: state.pathParameters['id']!,
          csCategory: extra?['cs_category'] as String?,
          guestId: (extra?['guestId'] ?? extra?['guest_id']) as String?,
        );
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (_, _) => const NotificationPage(),
    ),
    GoRoute(
      path: '/notification/:id',
      builder: (_, state) {
        final notif = state.extra;
        if (notif is NotificationModel) {
          return NotificationDetailPage(notification: notif);
        }
        return const NotificationPage();
      },
    ),
    GoRoute(
      path: '/notification-settings',
      builder: (_, _) => const NotificationSettingsPage(),
    ),
    GoRoute(
      path: '/password-and-security',
      builder: (_, _) => const PasswordAndSecurityPage(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (_, _) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: '/two-factor-settings',
      builder: (_, _) => const TwoFactorSettingsPage(),
    ),
    GoRoute(
      path: '/saved-login-info',
      builder: (_, _) => const SavedLoginInfoPage(),
    ),
    GoRoute(
      path: '/trusted-devices',
      builder: (_, _) => const TrustedDevicesPage(),
    ),
    GoRoute(
      path: '/login-activity',
      builder: (_, _) => const LoginActivityPage(),
    ),
    GoRoute(
      path: '/recent-emails',
      builder: (_, _) => const RecentEmailsPage(),
    ),
    GoRoute(
      path: '/security-checkup',
      builder: (_, _) => const SecurityCheckupPage(),
    ),
    GoRoute(
      path: '/search',
      builder: (_, state) {
        final query =
            (state.extra as Map<String, dynamic>?)?['query'] as String? ?? '';
        return SearchResultsPage(query: query);
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (_, state) {
        final section =
            (state.extra as Map<String, dynamic>?)?['section'] as String?;
        return EditProfilePage(scrollToSection: section);
      },
    ),
    GoRoute(
      path: '/complete-profile',
      builder: (_, state) {
        final section =
            (state.extra as Map<String, dynamic>?)?['section'] as String?;
        return CompleteProfilePage(scrollToSection: section);
      },
    ),
    GoRoute(
      path: '/profile-field',
      builder: (_, state) {
        final key =
            (state.extra as Map<String, dynamic>?)?['key'] as String? ??
            'full_name';
        return ProfileFieldPage(fieldKey: key);
      },
    ),
    GoRoute(path: '/face-scanner', builder: (_, _) => const FaceScannerPage()),
    GoRoute(
      path: '/document-scanner',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return DocumentScannerPage(
          docType: extra?['docType'] as String? ?? 'ktp',
        );
      },
    ),
    GoRoute(path: '/my-reviews', builder: (_, _) => const MyReviewsPage()),
    GoRoute(
      path: '/write-review',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ReviewListPage(
          packageId: extra?['package_id'] as String? ?? '',
          productId: extra?['product_id'] as String? ?? '',
          packageName: extra?['name'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: '/item-reviews',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AllReviewsPage(
          packageId: extra?['package_id'] as String? ?? '',
          productId: extra?['product_id'] as String? ?? '',
          title: extra?['title'] as String? ?? '',
          reviews:
              (extra?['reviews'] as List?)?.cast<Map<String, dynamic>>() ?? [],
        );
      },
    ),
    GoRoute(
      path: '/user-reviews',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return UserReviewsPage(
          userId: (extra?['user_id'] as String?) ?? '',
          userName: extra?['user_name'] as String? ?? '',
        );
      },
    ),
    GoRoute(path: '/history', builder: (_, _) => const HistoryPage()),
    GoRoute(path: '/vouchers', builder: (_, _) => const VoucherListPage()),
    GoRoute(
      path: '/vouchers/:id',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final voucher = extra != null ? VoucherModel.fromJson(extra) : null;
        return VoucherDetailPage(
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
    GoRoute(path: '/wishlist', builder: (_, _) => const WishlistPage()),
    GoRoute(path: '/catalog', builder: (_, _) => const CatalogCombinedPage()),
    GoRoute(
      path: '/terms-of-service',
      builder: (_, _) => const TermsOfServicePage(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (_, _) => const PrivacyPolicyPage(),
    ),
    GoRoute(
      path: '/wedding-policy',
      builder: (_, _) => const WeddingPolicyPage(),
    ),
    GoRoute(path: '/help-center', builder: (_, _) => const HelpCenterPage()),
    GoRoute(
      path: '/legal/privacy-term',
      builder: (_, _) => const PrivacyAndTermPage(),
    ),
    GoRoute(
      path: '/switch-account',
      builder: (_, _) => const SwitchAccountPage(),
    ),
    GoRoute(path: '/settings', builder: (_, _) => const SettingsPage()),
    GoRoute(path: '/language', builder: (_, _) => const LanguagePage()),
    GoRoute(path: '/app-lock', builder: (_, _) => const AppLockPage()),
    GoRoute(
      path: '/payment/:orderId',
      builder: (_, state) => PaymentInstructionPage(
        orderId: state.pathParameters['orderId']!,
      ),
    ),
    GoRoute(
      path: '/payment-method/:orderId',
      builder: (_, state) => PaymentMethodDetailPage(
        orderId: state.pathParameters['orderId']!,
        method: state.extra as PaymentMethodInfo,
      ),
    ),
    GoRoute(
      path: '/payment-webview',
      builder: (_, state) {
        final extra = state.extra as Map<String, String>;
        return PaymentWebViewPage(
          url: extra['url'] ?? '',
          title: extra['title'] ?? '',
        );
      },
    ),
  ],
);
