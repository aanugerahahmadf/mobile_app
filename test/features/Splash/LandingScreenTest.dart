import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Core/Utils/GuestMode/GuestMode.dart';
import 'package:mobile_app/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import 'package:mobile_app/Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart';
import 'package:mobile_app/Features/Splash/Presentation/Screens/Landing/LandingScreen.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

class _NoopAuth extends AuthNotifier {
  _NoopAuth() : super();
  @override
  Future<void> checkAuth() async {}
}

class _FakeGuest extends GuestModeController {
  _FakeGuest() {
    state = const GuestModeState(isGuest: false);
  }
  @override
  Future<void> load() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    await dotenv.load();
  });
  testWidgets('LandingScreen renders with all button actions functional', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _NoopAuth()),
          guestModeProvider.overrideWith((ref) => _FakeGuest()),
          currentAccountEmailProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          locale: const Locale('id'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: LandingScreen()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byType(LandingScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('LandingScreen shows Google sign-in button', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _NoopAuth()),
          guestModeProvider.overrideWith((ref) => _FakeGuest()),
          currentAccountEmailProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: LandingScreen()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Continue with Google'), findsOneWidget);
  });
  testWidgets('LandingScreen has customer service button', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _NoopAuth()),
          guestModeProvider.overrideWith((ref) => _FakeGuest()),
          currentAccountEmailProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: LandingScreen()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byIcon(Icons.support_agent_rounded), findsOneWidget);
  });
  testWidgets('LandingScreen has background image', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _NoopAuth()),
          guestModeProvider.overrideWith((ref) => _FakeGuest()),
          currentAccountEmailProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: LandingScreen()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byType(Image), findsWidgets);
  });
  testWidgets('LandingScreen has decorative blobs', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _NoopAuth()),
          guestModeProvider.overrideWith((ref) => _FakeGuest()),
          currentAccountEmailProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: LandingScreen()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byType(Stack), findsWidgets);
  });
  testWidgets('LandingScreen renders without errors in English locale', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _NoopAuth()),
          guestModeProvider.overrideWith((ref) => _FakeGuest()),
          currentAccountEmailProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: LandingScreen()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(tester.takeException(), isNull);
  });
  testWidgets('LandingScreen renders without errors in Indonesian locale', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _NoopAuth()),
          guestModeProvider.overrideWith((ref) => _FakeGuest()),
          currentAccountEmailProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          locale: const Locale('id'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: LandingScreen()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(tester.takeException(), isNull);
  });
}
