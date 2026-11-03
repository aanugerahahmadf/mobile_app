import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/Core/Utils/GuestMode/GuestMode.dart';
import 'package:mobile_app/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import 'package:mobile_app/Features/Cart/Presentation/Screens/Cart/CartScreen.dart';
import 'package:mobile_app/Features/Chat/Presentation/Screens/ChatList/ChatListScreen.dart';
import 'package:mobile_app/Features/Chat/Presentation/Screens/ChatDetail/ChatDetailScreen.dart';
import 'package:mobile_app/Features/Order/Presentation/Screens/OrderHistory/OrderHistoryScreen.dart';
import 'package:mobile_app/Features/Order/Presentation/Screens/OrderDetail/OrderDetailScreen.dart';
import 'package:mobile_app/Features/Payment/Presentation/Screens/PaymentInstruction/PaymentInstructionScreen.dart';
import 'package:mobile_app/Features/Payment/Presentation/Screens/PaymentMethodDetail/PaymentMethodDetailScreen.dart';
import 'package:mobile_app/Features/Payment/Domain/PaymentMethodInfo/PaymentMethodInfo.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/Profile/ProfileScreen.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/WhereYouSignIn/LoginActivityScreen.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/LatestEmail/RecentEmailsScreen.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SignInAndRecovery/SavedSignIn/SavedLoginInfoScreen.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/SecurityCheck/SecurityCheck/SecurityCheckupScreen.dart';
import 'package:mobile_app/Features/History/Presentation/Screens/History/HistoryScreen.dart';
import 'package:mobile_app/Features/Order/Presentation/Screens/Checkout/CheckoutScreen.dart';
import 'package:mobile_app/Features/Auth/Presentation/Screens/CompleteProfile/CompleteProfileScreen.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/Profile/EditProfile/EditProfileScreen.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/Profile/FieldProfile/ProfileFieldScreen.dart';
import 'package:mobile_app/Features/Profile/Presentation/Screens/Settings/PasswordAndSecurity/PasswordAndSecurityScreen.dart';
import 'package:mobile_app/Features/Review/Presentation/Screens/AllReviews/AllReviewsScreen.dart';
import 'package:mobile_app/Features/Review/Presentation/Screens/ReviewList/ReviewListScreen.dart';
import 'package:mobile_app/Features/Review/Presentation/Providers/ReviewProvider/ReviewProvider.dart';
import 'package:mobile_app/Features/Review/Data/ReviewRepositoryImpl/ReviewRepositoryImpl.dart';
import 'package:mobile_app/Features/Favorite/Presentation/Screens/Favorite/Favoritescreen.dart';
import 'package:mobile_app/Core/Widgets/GuestAuthPrompt/GuestAuthPrompt.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeReviewNotifier extends ReviewNotifier {
  _FakeReviewNotifier() : super(ReviewRepositoryImpl());

  @override
  Future<void> fetchItemReviews({
    String catalogId = '',
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
    String catalogId = '',
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
    await tester.pumpWidget(_wrap(const OrderHistoryScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest Favorite shows auth prompt without fetching favorite', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const Favoritescreen()));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest Cart shows auth prompt without fetching cart', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const CartScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest Profile shows auth prompt without fetching profile', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ProfileScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('guest Chat List does not load private conversations', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const ChatListScreen(isGuestMode: true), withRouter: true),
    );
    await tester.pumpAndSettle();
    expect(find.text('Customer Service'), findsOneWidget);
    expect(find.byType(ChatDetailScreen), findsNothing);
    expect(find.text('Masuk'), findsNothing);
  });

  for (final entry in <MapEntry<String, Widget>>[
    MapEntry('Login Activity', const LoginActivityScreen()),
    MapEntry('Recent Emails', const RecentEmailsScreen()),
    MapEntry('Saved Login', const SavedLoginInfoScreen()),
    MapEntry('Security Checkup', const SecurityCheckupScreen()),
    MapEntry('History', const HistoryScreen()),
    MapEntry('Security Settings', const PasswordAndSecurityScreen()),
    MapEntry('Review List', const ReviewListScreen()),
    MapEntry('Edit Profile', const EditProfileScreen()),
    MapEntry('Complete Profile', const CompleteProfileScreen()),
    MapEntry('Profile Field', const ProfileFieldScreen(fieldKey: 'full_name')),
    MapEntry('Checkout', const CheckoutScreen()),
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
    await tester.pumpWidget(_wrap(const OrderDetailScreen(id: '99')));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets(
    'guest Payment Instruction shows auth prompt without loading order',
    (tester) async {
      await tester.pumpWidget(
        _wrap(const PaymentInstructionScreen(orderId: '99')),
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
          const PaymentMethodDetailScreen(
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
        const AllReviewsScreen(catalogId: '1', title: 'Paket Wedding'),
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
        const AllReviewsScreen(catalogId: '1', title: 'Paket Wedding'),
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
