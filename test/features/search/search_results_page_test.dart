import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/search/data/models/search_result/search_result.dart';
import 'package:mobile_app/features/search/data/models/search_suggestion/search_suggestion.dart';
import 'package:mobile_app/features/search/domain/search_repository/search_repository.dart';
import 'package:mobile_app/features/search/presentation/pages/search_results/search_results_page.dart';
import 'package:mobile_app/features/search/presentation/providers/search_provider/search_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class _FakeSearchRepository implements SearchRepository {
  SearchResult _result = const SearchResult();
  bool _shouldThrow = false;

  /// Gerbang manual untuk menahan `search()` agar state `loading` teramati.
  ///
  /// Memakai `Completer` (bukan `Future.delayed`) supaya tidak ada timer yang
  /// menggantung di akhir test — `testWidgets` gagal dengan "Pending timers"
  /// kalau masih ada timer yang belum selesai.
  Completer<SearchResult>? gate;

  @override
  Future<SearchResult> search(String query, {int page = 1}) async {
    final pending = gate;
    if (pending != null) {
      return pending.future;
    }
    if (_shouldThrow) throw Exception('Search failed');
    return _result;
  }

  void setResult(SearchResult result) => _result = result;
  void setShouldThrow(bool value) => _shouldThrow = value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _FakeSearchRepository fakeRepo;
  setUp(() {
    fakeRepo = _FakeSearchRepository();
  });
  Widget wrapWidget(Widget child) {
    return ProviderScope(
      overrides: [
        searchProvider.overrideWith((ref) => SearchNotifier(fakeRepo)),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  group('SearchResultsPage', () {
    testWidgets('renders with query in text field', (tester) async {
      fakeRepo.setResult(const SearchResult(items: []));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'wedding')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SearchResultsPage), findsOneWidget);
      expect(find.text('wedding'), findsOneWidget);
    });
    testWidgets('shows loading indicator while searching', (tester) async {
      final gate = Completer<SearchResult>();
      fakeRepo.gate = gate;
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'test')),
      );
      // Pump pertama menjalankan postFrameCallback yang memanggil search();
      // pump kedua membangun ulang widget dengan `loading` = true.
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Lepas gerbang lalu diamkan supaya tidak ada future yang menggantung.
      gate.complete(const SearchResult(items: []));
      await tester.pumpAndSettle();
    });
    testWidgets('shows error state on failure', (tester) async {
      fakeRepo.setShouldThrow(true);
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });
    testWidgets('shows retry button on error', (tester) async {
      fakeRepo.setShouldThrow(true);
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
    testWidgets('shows empty state when no results', (tester) async {
      fakeRepo.setResult(const SearchResult(items: []));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'nonexistent')),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });
    testWidgets('displays search results', (tester) async {
      final items = [
        const SearchSuggestion(
          type: SuggestionType.packages,
          id: 1,
          name: 'Paket Wedding Premium',
          routePath: '/catalog/packages/1',
        ),
        const SearchSuggestion(
          type: SuggestionType.products,
          id: 2,
          name: 'Buket Bunga',
          routePath: '/catalog/products/2',
        ),
      ];
      fakeRepo.setResult(SearchResult(items: items));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'wedding')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Paket Wedding Premium'), findsOneWidget);
      expect(find.text('Buket Bunga'), findsOneWidget);
    });
    testWidgets('has clear button in search field', (tester) async {
      fakeRepo.setResult(const SearchResult(items: []));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });
    testWidgets('clear button clears query', (tester) async {
      fakeRepo.setResult(const SearchResult(items: []));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'test')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });
    testWidgets('has refresh indicator', (tester) async {
      final items = [
        const SearchSuggestion(
          type: SuggestionType.packages,
          id: 1,
          name: 'Paket A',
          routePath: '/catalog/packages/1',
        ),
      ];
      fakeRepo.setResult(SearchResult(items: items));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
    testWidgets('filters out vendors from display', (tester) async {
      final items = [
        const SearchSuggestion(
          type: SuggestionType.vendors,
          id: 1,
          name: 'Vendor A',
          routePath: '/vendor/1',
        ),
        const SearchSuggestion(
          type: SuggestionType.packages,
          id: 2,
          name: 'Paket A',
          routePath: '/catalog/packages/2',
        ),
      ];
      fakeRepo.setResult(SearchResult(items: items));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Vendor A'), findsNothing);
      expect(find.text('Paket A'), findsOneWidget);
    });
    testWidgets('shows result count', (tester) async {
      final items = [
        const SearchSuggestion(
          type: SuggestionType.packages,
          id: 1,
          name: 'Paket A',
          routePath: '/catalog/packages/1',
        ),
        const SearchSuggestion(
          type: SuggestionType.packages,
          id: 2,
          name: 'Paket B',
          routePath: '/catalog/packages/2',
        ),
      ];
      fakeRepo.setResult(SearchResult(items: items));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'paket')),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('2'), findsWidgets);
    });
    testWidgets('shows "See All" for sections with more than 5 items', (
      tester,
    ) async {
      final items = List.generate(
        6,
        (i) => SearchSuggestion(
          type: SuggestionType.packages,
          id: i + 1,
          name: 'Paket $i',
          routePath: '/catalog/packages/${i + 1}',
        ),
      );
      fakeRepo.setResult(SearchResult(items: items));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'paket')),
      );
      await tester.pumpAndSettle();
      // Label lokal, bukan literal "See All". String aslinya:
      // "See all {count} {label}".
      expect(find.textContaining('See all'), findsOneWidget);
    });
    testWidgets('displays suggestion type labels', (tester) async {
      final items = [
        const SearchSuggestion(
          type: SuggestionType.vouchers,
          id: 1,
          name: 'Voucher A',
          routePath: '/vouchers/1',
        ),
      ];
      fakeRepo.setResult(SearchResult(items: items));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'voucher')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Voucher A'), findsOneWidget);
    });
    testWidgets('shows subtitle when available', (tester) async {
      final items = [
        const SearchSuggestion(
          type: SuggestionType.orders,
          id: 1,
          name: 'ORD-001',
          subtitle: 'completed',
          routePath: '/order/1',
        ),
      ];
      fakeRepo.setResult(SearchResult(items: items));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'order')),
      );
      await tester.pumpAndSettle();
      expect(find.text('completed'), findsOneWidget);
    });
    testWidgets('search field allows new search submission', (tester) async {
      fakeRepo.setResult(const SearchResult(items: []));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'initial')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'new query');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.text('new query'), findsOneWidget);
    });
    testWidgets('displays app bar with title', (tester) async {
      fakeRepo.setResult(const SearchResult(items: []));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppBar), findsOneWidget);
    });
    testWidgets('shows dividers between sections', (tester) async {
      final items = [
        const SearchSuggestion(
          type: SuggestionType.packages,
          id: 1,
          name: 'Paket A',
          routePath: '/catalog/packages/1',
        ),
        const SearchSuggestion(
          type: SuggestionType.products,
          id: 2,
          name: 'Product A',
          routePath: '/catalog/products/2',
        ),
      ];
      fakeRepo.setResult(SearchResult(items: items));
      await tester.pumpWidget(
        wrapWidget(const SearchResultsPage(query: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Divider), findsWidgets);
    });
  });
}
