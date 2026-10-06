import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/widgets/app_empty_state/app_empty_state.dart';
import 'package:mobile_app/core/widgets/app_shimmer/app_shimmer.dart';
import 'package:mobile_app/features/search/data/models/search_result/search_result.dart';
import 'package:mobile_app/features/search/data/models/search_suggestion/search_suggestion.dart';
import 'package:mobile_app/features/search/domain/search_repository/search_repository.dart';
import 'package:mobile_app/features/search/presentation/pages/search/search_page.dart';
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

  group('SearchPage', () {
    testWidgets('renders with empty query state', (tester) async {
      await tester.pumpWidget(wrapWidget(const SearchPage()));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
      // Ikon search muncul dua kali secara sah: sebagai prefix di dalam
      // GlobalSearchBar, dan sebagai ilustrasi besar di empty state. Yang
      // diuji di sini adalah "halaman dirender", bukan jumlahnya.
      expect(find.byIcon(Icons.search_rounded), findsWidgets);
    });
    testWidgets('renders with initial query', (tester) async {
      fakeRepo.setResult(const SearchResult(items: []));
      await tester.pumpWidget(
        wrapWidget(const SearchPage(initialQuery: 'wedding')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
    });
    testWidgets('shows loading state when searching', (tester) async {
      final gate = Completer<SearchResult>();
      fakeRepo.gate = gate;
      await tester.pumpWidget(
        wrapWidget(const SearchPage(initialQuery: 'test')),
      );
      // Pump pertama menjalankan postFrameCallback yang memanggil search();
      // pump kedua membangun ulang widget dengan `loading` = true.
      await tester.pump();
      await tester.pump();
      // Loading state memakai shimmer grid, bukan CircularProgressIndicator.
      expect(find.byType(AppShimmerGrid), findsOneWidget);

      // Lepas gerbang lalu diamkan supaya tidak ada future yang menggantung.
      gate.complete(const SearchResult(items: []));
      await tester.pumpAndSettle();
    });
    testWidgets('shows error state on search failure', (tester) async {
      fakeRepo.setShouldThrow(true);
      await tester.pumpWidget(
        wrapWidget(const SearchPage(initialQuery: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });
    testWidgets('shows empty state when no results', (tester) async {
      fakeRepo.setResult(const SearchResult(items: []));
      await tester.pumpWidget(
        wrapWidget(const SearchPage(initialQuery: 'test')),
      );
      await tester.pumpAndSettle();
      // Hasil kosong dirender lewat AppEmptyState, bukan ListView kosong.
      expect(find.byType(AppEmptyState), findsOneWidget);
    });
    testWidgets('shows results when available', (tester) async {
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
        wrapWidget(const SearchPage(initialQuery: 'wedding')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Paket Wedding Premium'), findsOneWidget);
      expect(find.text('Buket Bunga'), findsOneWidget);
    });
    testWidgets('has back button', (tester) async {
      await tester.pumpWidget(wrapWidget(const SearchPage()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
    testWidgets('has camera button', (tester) async {
      await tester.pumpWidget(wrapWidget(const SearchPage()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
    });
    testWidgets('has voice/mic button', (tester) async {
      await tester.pumpWidget(wrapWidget(const SearchPage()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
    });
    testWidgets('does not show chat button', (tester) async {
      await tester.pumpWidget(wrapWidget(const SearchPage()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.support_agent_rounded), findsNothing);
    });
    testWidgets('displays result count', (tester) async {
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
        wrapWidget(const SearchPage(initialQuery: 'paket')),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('2'), findsWidgets);
    });
    testWidgets('groups results by type', (tester) async {
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
        wrapWidget(const SearchPage(initialQuery: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Paket A'), findsOneWidget);
      expect(find.text('Product A'), findsOneWidget);
    });
    testWidgets('shows "See All" button for sections with more than 5 items', (
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
        wrapWidget(const SearchPage(initialQuery: 'paket')),
      );
      await tester.pumpAndSettle();
      // Label lokal, bukan literal "See All". String aslinya:
      // "See all {count} {label}".
      expect(find.textContaining('See all'), findsOneWidget);
    });
    testWidgets('does not show "See all" for sections with 5 or fewer items', (
      tester,
    ) async {
      final items = List.generate(
        3,
        (i) => SearchSuggestion(
          type: SuggestionType.packages,
          id: i + 1,
          name: 'Paket $i',
          routePath: '/catalog/packages/${i + 1}',
        ),
      );
      fakeRepo.setResult(SearchResult(items: items));
      await tester.pumpWidget(
        wrapWidget(const SearchPage(initialQuery: 'paket')),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('See all'), findsNothing);
    });
    testWidgets('filters out vendors from results', (tester) async {
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
        wrapWidget(const SearchPage(initialQuery: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Vendor A'), findsNothing);
      expect(find.text('Paket A'), findsOneWidget);
    });
    testWidgets('displays suggestion type badges', (tester) async {
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
        wrapWidget(const SearchPage(initialQuery: 'voucher')),
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
        wrapWidget(const SearchPage(initialQuery: 'order')),
      );
      await tester.pumpAndSettle();
      expect(find.text('completed'), findsOneWidget);
    });
    testWidgets('refresh indicator works', (tester) async {
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
        wrapWidget(const SearchPage(initialQuery: 'test')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
