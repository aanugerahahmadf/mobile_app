import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/search/presentation/widgets/global_search_bar/global_search_bar.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

// Catatan: dulu ada `_FakeSearchRepositoryImpl extends SearchRepositoryImpl` di
// file ini, tapi tidak pernah dipakai -- GlobalSearchBar membuat repository-nya
// sendiri (`SearchRepositoryImpl get _repo => ...`) tanpa titik injeksi, jadi
// fake-nya tidak pernah terpakai. Yang tersisa hanya override dengan tipe
// return yang salah (`Future<dynamic>` vs `Future<SearchResult>`), yang
// menggagalkan analisis.
//
// Semuanya dihapus, bukan diperbaiki: menghidupkan fake-nya berarti
// GlobalSearchBar harus menerima repository sebagai parameter, dan itu
// perubahan di lib/ yang tidak diminta di sini. Kalau memang perlu, titik
// injeksinya harus ditambah dulu, baru fake-nya bisa masuk lagi.

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Widget wrapWidget(Widget child, {bool showChat = true}) {
    return ProviderScope(
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  /// Versi `wrapWidget` dengan GoRouter sungguhan.
  ///
  /// Tombol chat di GlobalSearchBar memanggil `context.push(...)`. Tanpa
  /// router di tree, widget test melempar "No GoRouter found in context" —
  /// bukan berarti tombolnya salah, hanya harness-nya yang belum menyiapkan
  /// navigasi.
  Widget wrapRouter(Widget child) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(body: child),
        ),
        GoRoute(
          path: '/chat-list',
          builder: (_, _) => const Scaffold(body: Text('chat list')),
        ),
      ],
    );
    addTearDown(router.dispose);

    return ProviderScope(
      child: MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }

  group('GlobalSearchBar', () {
    testWidgets('renders search text field', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
    });
    testWidgets('shows search icon', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });
    testWidgets('shows camera button', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
    });
    testWidgets('shows chat button when showChat is true', (tester) async {
      await tester.pumpWidget(
        wrapWidget(const GlobalSearchBar(showChat: true)),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.support_agent_rounded), findsOneWidget);
    });
    testWidgets('hides chat button when showChat is false', (tester) async {
      await tester.pumpWidget(
        wrapWidget(const GlobalSearchBar(showChat: false)),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.support_agent_rounded), findsNothing);
    });
    testWidgets('shows clear button when text is entered', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });
    testWidgets('clear button clears text when tapped', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });
    testWidgets('search field has correct hint text', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, isNotNull);
    });
    testWidgets('compact mode reduces padding', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar(compact: true)));
      await tester.pumpAndSettle();
      expect(find.byType(GlobalSearchBar), findsOneWidget);
    });
    testWidgets('translucent mode renders correctly', (tester) async {
      await tester.pumpWidget(
        wrapWidget(const GlobalSearchBar(translucent: true)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalSearchBar), findsOneWidget);
    });
    testWidgets('text input action is search', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.textInputAction, TextInputAction.search);
    });
    testWidgets('search field is filled', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.filled, isTrue);
    });
    testWidgets('has correct border radius', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      final textField = tester.widget<TextField>(find.byType(TextField));
      final border = textField.decoration?.enabledBorder as OutlineInputBorder?;
      expect(border, isNotNull);
      expect(border?.borderRadius, BorderRadius.circular(14));
    });
    testWidgets('camera button is tappable', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      final cameraBtn = find.byIcon(Icons.camera_alt_rounded);
      expect(cameraBtn, findsOneWidget);
      await tester.tap(cameraBtn);
      await tester.pumpAndSettle();
    });
    testWidgets('chat button is tappable when shown', (tester) async {
      await tester.pumpWidget(
        wrapRouter(const GlobalSearchBar(showChat: true)),
      );
      await tester.pumpAndSettle();
      final chatBtn = find.byIcon(Icons.support_agent_rounded);
      expect(chatBtn, findsOneWidget);
      await tester.tap(chatBtn);
      await tester.pumpAndSettle();
      // Tombol chat harus benar-benar menavigasi, bukan hanya bisa diketuk.
      expect(find.text('chat list'), findsOneWidget);
    });
    testWidgets('text field accepts input', (tester) async {
      await tester.pumpWidget(wrapWidget(const GlobalSearchBar()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'wedding package');
      await tester.pumpAndSettle();
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'wedding package');
    });
    testWidgets('multiple instances render independently', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          Column(
            children: const [GlobalSearchBar(), GlobalSearchBar(compact: true)],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlobalSearchBar), findsNWidgets(2));
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
}
