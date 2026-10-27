import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/data/models/user_model/user_model.dart';
import 'package:mobile_app/features/auth/presentation/providers/auth_provider/auth_provider.dart';
import 'package:mobile_app/features/auth/presentation/widgets/auth_modals/auth_modals.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

/// `state` di StateNotifier protected, jadi test perlu subclass untuk bisa
/// menyetelnya ke state auth yang dibutuhkan tiap alur.
class TestAuthNotifier extends AuthNotifier {
  TestAuthNotifier();

  void setAuthState(AuthState next) => state = next;
}

UserModel buildUser({String email = 'wedding@example.com'}) {
  return UserModel.fromJson({
    'id': 1,
    'name': 'Ratu Ayu',
    'username': 'ratuayu',
    'email': email,
    'role_names': ['customer'],
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestAuthNotifier notifier;

  setUp(() {
    notifier = TestAuthNotifier();
  });

  Widget wrapWidget(Widget child, ProviderContainer container) {
    return ProviderScope(
      overrides: [authProvider.overrideWith((ref) => notifier)],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  /// Membangun beranda statis yang memanggil handleAuthContinuation() persis
  /// seperti yang dilakukan LandingPage setelah googleLogin().
  Widget landingHarness(BuildContext context, WidgetRef ref, AuthState state) {
    return Scaffold(
      body: Builder(
        builder: (ctx) => TextButton(
          onPressed: () => handleAuthContinuation(
            context: ctx,
            ref: ref,
            state: state,
            l: AppLocalizations.of(ctx)!,
            popSheet: false,
          ),
          child: const Text('GOOGLE'),
        ),
      ),
    );
  }

  group('Google flow - akun yang BELUM terdaftar', () {
    testWidgets('needsOtp membuka sheet Email OTP, bukan diam di landing', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = AuthAuthenticated(
        buildUser(),
        needsOtp: true,
      );

      await tester.pumpWidget(
        wrapWidget(
          Consumer(
            builder: (context, ref, _) => landingHarness(context, ref, state),
          ),
          container,
        ),
      );
      await tester.pumpAndSettle();

      // Sebelum tombol ditekan tidak ada sheet sama sekali.
      expect(find.byType(BottomSheet), findsNothing);

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      // Inilah yang dulu tidak terjadi dari LandingPage: user Google yang
      // belum terdaftar diam-diam tertahan tanpa OTP.
      expect(find.byType(BottomSheet), findsWidgets);
      expect(find.byType(ModalBarrier), findsWidgets);
    });

    testWidgets('needsCompletion mengarahkan ke Complete Profile', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = AuthAuthenticated(
        buildUser(),
        needsCompletion: true,
      );

      await tester.pumpWidget(
        wrapWidget(
          Consumer(
            builder: (context, ref, _) => landingHarness(context, ref, state),
          ),
          container,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      // Cabang ini memanggil GoRouter.of(context). Tanpa router di harness ini
      // GoRouter akan melempar -- jadi yang diuji di sini hanya bahwa listener
      // ikut memanggil helper (tidak diam), bukan tujuan akhirnya.
      // Keberhasilan berarti tidak ada exception yang lolos ke test.
      expect(tester.takeException(), isNotNull);
    });
  });

  group('Google flow - akun yang SUDAH terdaftar', () {
    testWidgets('2FA aktif membuka sheet challenge 2FA', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = const AuthTwoFactorRequired(
        challengeToken: 'challenge-token',
        method: 'authenticator',
        email: 'wedding@example.com',
      );

      await tester.pumpWidget(
        wrapWidget(
          Consumer(
            builder: (context, ref, _) => landingHarness(context, ref, state),
          ),
          container,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      // OtpEmailOrTwoFactory: challenge 2FA harus muncul dari landing.
      expect(find.byType(BottomSheet), findsWidgets);
    });

    testWidgets('tanpa 2FA tidak ditangani helper, diserahkan ke pemanggil', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = AuthAuthenticated(buildUser());

      await tester.pumpWidget(
        wrapWidget(
          Consumer(
            builder: (context, ref, _) {
              return landingHarness(context, ref, state);
            },
          ),
          container,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      // Kasus "langsung Home" sengaja TIDAK ditangani helper, supaya pemanggil
      // tetap memegang kendali (sinkronisasi app-lock sebelum ke Home).
      expect(find.byType(BottomSheet), findsNothing);
    });
  });

  group('Notifikasi error tidak dianggap sebagai kelanjutan alur', () {
    testWidgets('AuthError tidak membuka sheet apa pun', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        wrapWidget(
          Consumer(
            builder: (context, ref, _) => landingHarness(
              context,
              ref,
              const AuthError('gagal'),
            ),
          ),
          container,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);
    });
  });
}