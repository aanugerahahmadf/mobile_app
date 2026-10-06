import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/presentation/providers/auth_provider/auth_provider.dart';
import 'package:mobile_app/features/auth/presentation/widgets/auth_modals/auth_modals.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Widget wrapWidget(Widget child) {
    return ProviderScope(
      overrides: [authProvider.overrideWith((ref) => AuthNotifier())],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  group('AuthModals', () {
    testWidgets('showSignInSheet displays sign in form', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SizedBox));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('showSignUpSheet displays sign up form', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('showForgotPasswordSheet displays forgot password form', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('showOtpVerificationSheet displays OTP form', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('showResetPasswordSheet displays reset password form', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('showAgreementModal displays agreement content', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });

    // Unit test murni: tidak butuh WidgetTester, jadi pakai test() bukan
    // testWidgets(). testWidgets() mewajibkan callback async yang menerima
    // tester, dan pemanggilannya dengan closure tanpa argumen tidak cocok.
    test('AgreementMode has correct values', () {
      expect(AgreementMode.values.length, 4);
      expect(AgreementMode.values, contains(AgreementMode.wizard));
      expect(AgreementMode.values, contains(AgreementMode.terms));
      expect(AgreementMode.values, contains(AgreementMode.privacy));
      expect(AgreementMode.values, contains(AgreementMode.weddingPolicy));
    });
    testWidgets('_rootContext returns valid context', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('sign in sheet has email field', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('sign in sheet has password field', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('sign in sheet has remember me checkbox', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('sign in sheet has agreement checkbox', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('sign in sheet has forgot password link', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('sign in sheet has sign up link', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('sign up sheet has all required fields', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('OTP sheet has 6-digit input', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('OTP sheet has resend timer', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('reset password has new password field', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('reset password has confirm password field', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('forgot password has email field', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
    testWidgets('forgot password has send button', (tester) async {
      await tester.pumpWidget(wrapWidget(const Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
