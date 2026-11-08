import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Features/Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import 'package:mobile_app/Features/Review/Data/Models/CatalogRatingCommentModel/CatalogRatingCommentModel.dart';
import 'package:mobile_app/Features/Review/Data/Models/ReviewPage/ReviewPage.dart';
import 'package:mobile_app/Features/Review/Data/ReviewRepositoryImpl/ReviewRepositoryImpl.dart';
import 'package:mobile_app/Features/Review/Presentation/Providers/CatalogRatingCommentsProvider/CatalogRatingCommentsProvider.dart';
import 'package:mobile_app/Features/Review/Presentation/Widgets/CatalogRatingComments/CatalogRatingCommentsView.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

/// Notifier tanpa network yang berisi satu penilaian dan agregat 4,9 dari 123
/// ulasan, cukup untuk menguji baris heading section.
class _SeededCatalogRatingCommentsNotifier
    extends CatalogRatingCommentsNotifier {
  _SeededCatalogRatingCommentsNotifier()
    : super(ReviewRepositoryImpl(), catalogId: '1');

  @override
  Future<void> fetchCatalogRatingComments({bool refresh = false}) async {
    if (state.reviews.isNotEmpty) return;
    state = state.copyWith(
      loading: false,
      summary: const ReviewSummaryModel(average: 4.9, total: 123),
      reviews: [
        const CatalogRatingCommentModel(
          id: 101,
          userId: 7,
          reviewerName: 'calyafebyola',
          itemName: 'Buket Pengantin Putih',
          rating: 5,
          comment: 'Nyaman dipakai sehari hari',
          helpfulCount: 47,
        ),
      ],
    );
  }

  @override
  Future<void> voteHelpful(int reviewId) async {}
}

Widget _wrap(Widget child) => ProviderScope(
  overrides: [
    authProvider.overrideWith(
      (ref) => AuthNotifier()..state = const AuthInitial(),
    ),
    catalogRatingCommentsProvider.overrideWith(
      (ref, catalogId) => _SeededCatalogRatingCommentsNotifier(),
    ),
  ],
  child: MaterialApp(
    locale: const Locale('id'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  testWidgets('heading reads Penilaian with score and count, not Katalog', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const CatalogRatingCommentsView(catalogId: '1', title: 'Buket')),
    );
    await tester.pumpAndSettle();

    // Baris heading meniru PDP Shopee: `4.9 ★ Penilaian (123) >`.
    expect(find.text('Penilaian'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('(123)'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    // "Penilaian Katalog"/"Komentar Penilaian Katalog" tidak boleh muncul lagi,
    // dan skor tidak boleh tertulis dua kali (RatingSummary memakai
    // showAverage: false).
    expect(find.text('Penilaian Katalog'), findsNothing);
    expect(find.text('Komentar Penilaian Katalog'), findsNothing);
  });

  testWidgets('embedded preview keeps the see-all link below the cards', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const CatalogRatingCommentsView(catalogId: '1', title: 'Buket')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lihat Semua (123)'), findsOneWidget);
    expect(find.text('Nyaman dipakai sehari hari'), findsOneWidget);
  });
}
