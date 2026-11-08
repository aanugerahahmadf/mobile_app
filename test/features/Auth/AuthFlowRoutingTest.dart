import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/Features/Auth/Data/Models/UserModel/UserModel.dart';
import 'package:mobile_app/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import 'package:mobile_app/Features/Auth/Presentation/Utils/AuthNavigation.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

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

  Widget wrapWithRouter({
    required Widget Function(BuildContext, WidgetRef) builder,
    List<String>? pushedRoutes,
  }) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Consumer(
            builder: (ctx, ref, _) => builder(ctx, ref),
          ),
        ),
        GoRoute(
          path: '/otp-email-verification',
          builder: (context, state) {
            pushedRoutes?.add('/otp-email-verification');
            return const Scaffold(body: Text('OTP Screen'));
          },
        ),
        GoRoute(
          path: '/two-factor-verify',
          builder: (context, state) {
            pushedRoutes?.add('/two-factor-verify');
            return const Scaffold(body: Text('2FA Screen'));
          },
        ),
        GoRoute(
          path: '/complete-profile',
          builder: (context, state) {
            pushedRoutes?.add('/complete-profile');
            return const Scaffold(body: Text('Complete Profile Screen'));
          },
        ),
      ],
    );

    return ProviderScope(
      overrides: [authProvider.overrideWith((ref) => notifier)],
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  Widget landingHarness(BuildContext context, WidgetRef ref, AuthState state) {
    return Scaffold(
      body: Builder(
        builder: (ctx) => TextButton(
          onPressed: () => handleAuthContinuation(
            context: ctx,
            ref: ref,
            state: state,
            l: AppLocalizations.of(ctx)!,
          ),
          child: const Text('GOOGLE'),
        ),
      ),
    );
  }

  group('Google flow - akun yang BELUM terdaftar', () {
    testWidgets('needsOtp mengarahkan ke /otp-email-verification screen', (
      tester,
    ) async {
      final pushedRoutes = <String>[];
      final state = AuthAuthenticated(
        buildUser(),
        needsOtp: true,
      );

      await tester.pumpWidget(
        wrapWithRouter(
          pushedRoutes: pushedRoutes,
          builder: (ctx, ref) => landingHarness(ctx, ref, state),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('OTP Screen'), findsNothing);

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      expect(find.text('OTP Screen'), findsOneWidget);
    });

    testWidgets('needsCompletion mengarahkan ke Complete Profile', (
      tester,
    ) async {
      final pushedRoutes = <String>[];
      final state = AuthAuthenticated(
        buildUser(),
        needsCompletion: true,
      );

      await tester.pumpWidget(
        wrapWithRouter(
          pushedRoutes: pushedRoutes,
          builder: (ctx, ref) => landingHarness(ctx, ref, state),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      expect(find.text('Complete Profile Screen'), findsOneWidget);
    });
  });

  group('Google flow - akun yang SUDAH terdaftar', () {
    testWidgets('2FA aktif mengarahkan ke /two-factor-verify screen', (
      tester,
    ) async {
      final pushedRoutes = <String>[];
      final state = const AuthTwoFactorRequired(
        challengeToken: 'challenge-token',
        method: 'authenticator',
        email: 'wedding@example.com',
      );

      await tester.pumpWidget(
        wrapWithRouter(
          pushedRoutes: pushedRoutes,
          builder: (ctx, ref) => landingHarness(ctx, ref, state),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2FA Screen'), findsNothing);

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      expect(find.text('2FA Screen'), findsOneWidget);
    });

    testWidgets('tanpa 2FA tidak ditangani helper, diserahkan ke pemanggil', (
      tester,
    ) async {
      final state = AuthAuthenticated(buildUser());

      await tester.pumpWidget(
        wrapWithRouter(
          builder: (ctx, ref) => landingHarness(ctx, ref, state),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      expect(find.text('GOOGLE'), findsOneWidget);
    });
  });

  group('Notifikasi error tidak dianggap sebagai kelanjutan alur', () {
    testWidgets('AuthError tidak membuka rute apa pun', (tester) async {
      await tester.pumpWidget(
        wrapWithRouter(
          builder: (ctx, ref) => landingHarness(
            ctx,
            ref,
            const AuthError('gagal'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('GOOGLE'));
      await tester.pumpAndSettle();

      expect(find.text('GOOGLE'), findsOneWidget);
    });
  });
}
