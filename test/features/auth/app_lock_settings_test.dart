import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/features/profile/presentation/pages/settings/settings_page.dart';
import 'package:mobile_app/features/auth/presentation/providers/auth_provider/auth_provider.dart';
import 'package:mobile_app/features/auth/data/models/user_model/user_model.dart';
import 'package:mobile_app/features/auth/presentation/providers/biometric_settings_provider/biometric_settings_provider.dart';

Widget _wrap(Widget child) {
  final user = UserModel(
    id: 1,
    fullName: 'Test User',
    username: 'test-user',
    email: 'test@example.com',
  );
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(
        (ref) => AuthNotifier()..state = AuthAuthenticated(user),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await dotenv.load();
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });

  testWidgets('Settings page shows the PIN lock method card', (tester) async {
    await tester.pumpWidget(_wrap(const SettingsPage()));
    await tester.pumpAndSettle();

    // Scroll down to the PIN lock method card.
    await tester.scrollUntilVisible(
      find.text('PIN Lock'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    final pinCard = find.ancestor(
      of: find.text('PIN Lock'),
      matching: find.byType(Card),
    );
    expect(pinCard, findsOneWidget);
    expect(
      find.descendant(of: pinCard, matching: find.text('Add')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: pinCard, matching: find.text('Disabled')),
      findsOneWidget,
    );
  });

  testWidgets(
    'Enabling PIN opens the sheet, saving it enables PIN lock and shows Edit/Delete',
    (tester) async {
      await tester.pumpWidget(_wrap(const SettingsPage()));
      await tester.pumpAndSettle();

      // Scroll to the PIN lock card and tap its Add button.
      await tester.scrollUntilVisible(
        find.text('PIN Lock'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      final pinCard = find.ancestor(
        of: find.text('PIN Lock'),
        matching: find.byType(Card),
      );
      final pinAddButton = find.descendant(
        of: pinCard,
        matching: find.text('Add'),
      );
      await tester.ensureVisible(pinAddButton);
      await tester.pumpAndSettle();
      await tester.tap(pinAddButton);
      await tester.pumpAndSettle();

      // The setup sheet asks for a new PIN.
      expect(find.text('Enter new PIN'), findsOneWidget);

      // Enter first 6 digits -> advance to confirm step automatically.
      for (final d in ['1', '2', '3', '4', '5', '6']) {
        await tester.tap(find.text(d));
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(find.text('Confirm PIN'), findsOneWidget);

      // Enter the same 6 digits -> save & close the sheet.
      for (final d in ['1', '2', '3', '4', '5', '6']) {
        await tester.tap(find.text(d));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Sheet is closed and the PIN card now shows Edit/Delete and Enabled.
      expect(find.text('Enter new PIN'), findsNothing);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Enabled'), findsOneWidget);

      // Provider reflects the enabled state.
      final container = ProviderScope.containerOf(
        tester.element(find.text('Edit')),
      );
      expect(container.read(pinUnlockProvider), isTrue);
    },
  );

  testWidgets('verifyPin matches the stored PIN', (tester) async {
    await savePin('123456');
    expect(await verifyPin('123456'), isTrue);
    expect(await verifyPin('999999'), isFalse);
    expect(await hasStoredPin(), isTrue);
    expect(await hasValidStoredPin(), isTrue);
    await clearStoredPin();
    expect(await hasStoredPin(), isFalse);
  });

  test('app lock settings are scoped per account email', () async {
    const a = 'user.a@gmail.com';
    const b = 'user.b@gmail.com';

    await savePin('111111', email: a);
    await savePin('222222', email: b);

    expect(await verifyPin('111111', email: a), isTrue);
    expect(await verifyPin('222222', email: b), isTrue);
    expect(await verifyPin('111111', email: b), isFalse);
    expect(await verifyPin('222222', email: a), isFalse);

    await resetAppLock(email: a);
    expect(await hasStoredPin(email: a), isFalse);
    expect(await verifyPin('222222', email: b), isTrue);
  });
}
