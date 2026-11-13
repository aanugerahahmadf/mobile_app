import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Auth/Presentation/Widgets/SocialSignInButton/SocialSignInButton.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

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

  group('SocialSignInButton', () {
    testWidgets('renders Google button correctly', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialSignInButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SocialSignInButton), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        wrapWidget(
          SocialSignInButton(
            provider: SocialProvider.google,
            onPressed: () => pressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SocialSignInButton));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        wrapWidget(
          SocialSignInButton(
            provider: SocialProvider.google,
            enabled: false,
            onPressed: () => pressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SocialSignInButton), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(pressed, isFalse);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialSignInButton(
            provider: SocialProvider.google,
            onPressed: () {},
            loading: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows correct icon for Google', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialSignInButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('button has correct height', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialSignInButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(SocialSignInButton),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.height, 50);
    });

    testWidgets('button is full width', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialSignInButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(SocialSignInButton),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('button has elevation', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialSignInButton(provider: SocialProvider.google, onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(SocialSignInButton),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.elevation, 3);
    });

    testWidgets('disabled button has null onPressed', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          SocialSignInButton(
            provider: SocialProvider.google,
            onPressed: () {},
            enabled: false,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('SocialProvider enum', () {
    test('has google value', () {
      expect(SocialProvider.values, contains(SocialProvider.google));
    });

    test('has exactly 1 provider', () {
      expect(SocialProvider.values.length, 1);
    });
  });
}
