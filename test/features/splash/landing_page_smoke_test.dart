import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/utils/guest_mode/guest_mode.dart';
import 'package:mobile_app/features/auth/presentation/providers/auth_provider/auth_provider.dart';
import 'package:mobile_app/features/auth/presentation/providers/biometric_settings_provider/biometric_settings_provider.dart';
import 'package:mobile_app/features/splash/presentation/pages/landing/landing_page.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class _NoopAuth extends AuthNotifier {
  _NoopAuth() : super();
  @override
  Future<void> checkAuth() async {}
}

class _FakeGuest extends GuestModeController {
  _FakeGuest() { state = const GuestModeState(isGuest: false); }
  @override
  Future<void> load() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await dotenv.load();
  });

  testWidgets('LandingPage renders with all button actions functional', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(ProviderScope(
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
        home: const Scaffold(body: LandingPage()),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Mulai Sekarang'), findsOneWidget);
    expect(find.text('Lanjut sebagai Tamu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}