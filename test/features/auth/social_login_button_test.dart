import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/presentation/widgets/social_login_button/social_login_button.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Widget wrapWidget(Widget child) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('SocialLoginButton', () {
    testWidgets('renders Google button correctly', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SocialLoginButton), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
    });
    testWidgets('renders Facebook button correctly', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(
            provider: SocialProvider.facebook,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Continue with Facebook'), findsOneWidget);
    });
    testWidgets('renders Apple button correctly', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.apple, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Continue with Apple'), findsOneWidget);
    });
    testWidgets('calls onPressed when tapped', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(
            provider: SocialProvider.google,
            onPressed: () => pressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SocialLoginButton));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });
    testWidgets('does not call onPressed when disabled', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(
            provider: SocialProvider.google,
            enabled: false,
            onPressed: () => pressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SocialLoginButton), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(pressed, isFalse);
    });
    testWidgets('shows correct icon for Google', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
    });
    testWidgets('shows correct icon for Facebook', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(
            provider: SocialProvider.facebook,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.facebook), findsOneWidget);
    });
    testWidgets('shows correct icon for Apple', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.apple, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsWidgets);
    });
    testWidgets('button has correct height', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(SocialLoginButton),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.height, 50);
    });
    testWidgets('button is full width', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(SocialLoginButton),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, double.infinity);
    });
    testWidgets('button has elevation', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      // `.first` wajib: subtree punya lebih dari satu Material (mis. satu dari
      // Scaffold/kartu dan satu lagi dari tombolnya sendiri), sehingga
      // `tester.widget` tanpa itu melempar "Bad state: Too many elements".
      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(SocialLoginButton),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.elevation, 3);
    });
    testWidgets('button has correct border radius', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SocialLoginButton), findsOneWidget);
    });
    testWidgets('button has surface color background', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SocialLoginButton), findsOneWidget);
    });
    testWidgets('button has divider border', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SocialLoginButton), findsOneWidget);
    });
    testWidgets('multiple buttons render independently', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          Column(
            children: [
              SocialLoginButton(
                provider: SocialProvider.google,
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              SocialLoginButton(
                provider: SocialProvider.facebook,
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              SocialLoginButton(
                provider: SocialProvider.apple,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SocialLoginButton), findsNWidgets(3));
    });
    testWidgets('button text has correct style', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      final text = tester.widget<Text>(find.text('Continue with Google'));
      expect(text.style?.fontSize, 15);
    });
    testWidgets('button is tappable', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrapWidget(
          SocialLoginButton(
            provider: SocialProvider.google,
            onPressed: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });
}
