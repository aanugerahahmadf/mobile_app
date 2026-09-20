import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/utils/guest_mode/guest_mode.dart';
import 'package:mobile_app/features/auth/presentation/providers/auth_provider/auth_provider.dart';
import 'package:mobile_app/features/cart/presentation/pages/cart/cart_page.dart';
import 'package:mobile_app/features/chat/presentation/pages/chat_list/chat_list_page.dart';
import 'package:mobile_app/features/chat/presentation/pages/chat_detail/chat_detail_page.dart';
import 'package:mobile_app/features/order/presentation/pages/order_history/order_history_page.dart';
import 'package:mobile_app/features/order/presentation/pages/order_detail/order_detail_page.dart';
import 'package:mobile_app/features/payment/presentation/pages/payment_instruction/payment_instruction_page.dart';
import 'package:mobile_app/features/payment/presentation/pages/payment_method_detail/payment_method_detail_page.dart';
import 'package:mobile_app/features/payment/domain/payment_method_info/payment_method_info.dart';
import 'package:mobile_app/features/profile/presentation/pages/profile/profile_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/settings/password_and_security/security_check/where_you_sign_in/login_activity_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/settings/password_and_security/security_check/latest_email/recent_emails_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/settings/password_and_security/sign_in_and_recovery/saved_sign_in/saved_login_info_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/settings/password_and_security/security_check/security_check/security_checkup_page.dart';
import 'package:mobile_app/features/history/presentation/pages/history/history_page.dart';
import 'package:mobile_app/features/order/presentation/pages/checkout/checkout_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/profile/complete_profile/complete_profile_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/profile/edit_profile/edit_profile_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/profile/field_profile/profile_field_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/settings/password_and_security/password_and_security_page.dart';
import 'package:mobile_app/features/review/presentation/pages/all_reviews/all_reviews_page.dart';
import 'package:mobile_app/features/review/presentation/pages/review_list/review_list_page.dart';
import 'package:mobile_app/features/review/presentation/providers/review_provider/review_provider.dart';
import 'package:mobile_app/features/review/data/review_repository_impl/review_repository_impl.dart';
import 'package:mobile_app/features/wishlist/presentation/pages/wishlist/wishlist_page.dart';
import 'package:mobile_app/core/widgets/guest_auth_prompt/guest_auth_prompt.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeReviewNotifier extends ReviewNotifier {
  _FakeReviewNotifier() : super(ReviewRepositoryImpl());

  @override
  Future<void> fetchItemReviews({
    String? packageId,
    String? productId,
    bool refresh = false,
  }) async {
    state = state.copyWith(
      loading: false,
      reviews: [
        {
          'id': 101,
          'user_name': 'Budi',
          'rating': 5,
          'comment': 'Sangat bagus dan rapi',
          'helpful_count': 2,
        },
      ],
    );
  }

  @override
  Future<void> fetchRatingSummary({
    String? packageId,
    String? productId,
  }) async {
    state = state.copyWith(loading: false);
  }
}

Widget _wrap(
  Widget child, {
  bool withRouter = false,
  List<Override> extraOverrides = const [],
}) {
  final overrides = [
    authProvider.overrideWith(
      (ref) => AuthNotifier()..state = const AuthInitial(),
    ),
    ...extraOverrides,
  ];
  final content = ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      locale: const Locale('id'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
  if (!withRouter) return content;
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      locale: const Locale('id'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        routes: [GoRoute(path: '/', builder: (_, _) => child)],
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({'guest_mode': true});
    await setGuestMode(true);
  });

  test('guest mode controller loads and updates cached state', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(guestModeProvider.notifier).load();
    expect(container.read(guestModeProvider).isGuest, isTrue);

    await container.read(guestModeProvider.notifier).setGuest(false);
    expect(container.read(guestModeProvider).isGuest, isFalse);
    expect(await isGuestModeEnabled(), isFalse);
  });

  testWidgets('guest auth prompt exposes sign in and sign up actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: GuestAuthPrompt()),
        ),
      ),
    );

    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest Orders shows auth prompt without loading private orders', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const OrderHistoryPage()));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest Wishlist shows auth prompt without fetching wishlist', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const WishlistPage()));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest Cart shows auth prompt without fetching cart', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const CartPage()));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest Profile shows auth prompt without fetching profile', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ProfilePage()));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest Chat List does not load private conversations', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const ChatListPage(isGuestMode: true), withRouter: true),
    );
    await tester.pumpAndSettle();
    expect(find.text('Customer Service'), findsOneWidget);
    expect(find.byType(ChatDetailPage), findsNothing);
    expect(find.text('Masuk'), findsNothing);
  });

  for (final entry in <MapEntry<String, Widget>>[
    MapEntry('Login Activity', const LoginActivityPage()),
    MapEntry('Recent Emails', const RecentEmailsPage()),
    MapEntry('Saved Login', const SavedLoginInfoPage()),
    MapEntry('Security Checkup', const SecurityCheckupPage()),
    MapEntry('History', const HistoryPage()),
    MapEntry('Security Settings', const PasswordAndSecurityPage()),
    MapEntry('Review List', const ReviewListPage()),
    MapEntry('Edit Profile', const EditProfilePage()),
    MapEntry('Complete Profile', const CompleteProfilePage()),
    MapEntry('Profile Field', const ProfileFieldPage(fieldKey: 'full_name')),
    MapEntry('Checkout', const CheckoutPage()),
  ]) {
    testWidgets('guest ${entry.key} does not fetch private endpoint', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(entry.value));
      await tester.pumpAndSettle();
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Daftar'), findsOneWidget);
    });
  }

  testWidgets('guest Order Detail shows auth prompt without loading order', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const OrderDetailPage(id: '99')));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets(
    'guest Payment Instruction shows auth prompt without loading order',
    (tester) async {
      await tester.pumpWidget(
        _wrap(const PaymentInstructionPage(orderId: '99')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Daftar'), findsOneWidget);
    },
  );

  testWidgets(
    'guest Payment Method Detail shows auth prompt without private calls',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PaymentMethodDetailPage(
            orderId: '99',
            method: PaymentMethodInfo(
              id: 1,
              name: 'Bank BCA',
              type: 'bank_transfer',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Daftar'), findsOneWidget);
    },
  );

  testWidgets('guest AllReviews tapping write review shows auth prompt sheet', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AllReviewsPage(packageId: '1', title: 'Paket Wedding'),
        extraOverrides: [
          reviewProvider.overrideWith((ref) => _FakeReviewNotifier()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    final writeBtn = find.text('Tulis Ulasan');
    expect(writeBtn, findsOneWidget);
    await tester.tap(writeBtn);
    await tester.pumpAndSettle();

    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest AllReviews tapping helpful vote shows auth prompt sheet', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AllReviewsPage(packageId: '1', title: 'Paket Wedding'),
        extraOverrides: [
          reviewProvider.overrideWith((ref) => _FakeReviewNotifier()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    final helpfulBtn = find.text('Membantu');
    expect(helpfulBtn, findsOneWidget);
    await tester.tap(helpfulBtn);
    await tester.pumpAndSettle();

    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });
}
