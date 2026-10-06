import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/search/data/models/search_suggestion/search_suggestion.dart';

void main() {
  group('SuggestionType', () {
    test('has all expected values', () {
      // 12 nilai, sama dengan yang didaftar di bawah. Sebelumnya tertulis 13
      // padahal hanya 12 nilai yang di-assert, jadi test ini selalu gagal.
      expect(SuggestionType.values.length, 12);
      expect(SuggestionType.values, contains(SuggestionType.packages));
      expect(SuggestionType.values, contains(SuggestionType.products));
      expect(SuggestionType.values, contains(SuggestionType.categories));
      expect(SuggestionType.values, contains(SuggestionType.vouchers));
      expect(SuggestionType.values, contains(SuggestionType.orders));
      expect(SuggestionType.values, contains(SuggestionType.reviews));
      expect(SuggestionType.values, contains(SuggestionType.terms));
      expect(SuggestionType.values, contains(SuggestionType.privacy));
      expect(SuggestionType.values, contains(SuggestionType.helps));
      expect(SuggestionType.values, contains(SuggestionType.histories));
      expect(SuggestionType.values, contains(SuggestionType.weddingPolicy));
      expect(SuggestionType.values, contains(SuggestionType.vendors));
    });
  });

  group('SearchSuggestion.fromJson', () {
    test('parses packages correctly', () {
      final json = {
        'id': 1,
        'name': 'Paket Wedding Premium',
        'price': 15000000,
        'description': 'Paket lengkap',
        'category': {'name': 'Wedding'},
        'image_url': 'https://example.com/image.jpg',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.packages,
        json,
      );
      expect(suggestion.type, SuggestionType.packages);
      expect(suggestion.id, 1);
      expect(suggestion.name, 'Paket Wedding Premium');
      expect(suggestion.routePath, '/catalog/packages/1');
      expect(suggestion.imageUrl, 'https://example.com/image.jpg');
    });

    test('parses products correctly', () {
      final json = {
        'id': 2,
        'name': 'Buket Bunga',
        'price': 500000,
        'description': 'Buket cantik',
        'category_name': 'Bunga',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.products,
        json,
      );
      expect(suggestion.type, SuggestionType.products);
      expect(suggestion.id, 2);
      expect(suggestion.name, 'Buket Bunga');
      expect(suggestion.routePath, '/catalog/products/2');
    });

    test('parses categories correctly', () {
      final json = {
        'id': 3,
        'name': 'Wedding',
        'description': 'Kategori wedding',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.categories,
        json,
      );
      expect(suggestion.type, SuggestionType.categories);
      expect(suggestion.id, 3);
      expect(suggestion.name, 'Wedding');
      expect(suggestion.routePath, '/catalog');
      expect(suggestion.routeExtra, isNotNull);
      expect(suggestion.routeExtra!['category_id'], '3');
    });

    test('parses vouchers correctly', () {
      final json = {
        'id': 4,
        'code': 'HEMAT10',
        'description': 'Diskon 10%',
        'discount': '10%',
        'valid_until': '2024-12-31',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.vouchers,
        json,
      );
      expect(suggestion.type, SuggestionType.vouchers);
      expect(suggestion.id, 4);
      expect(suggestion.name, 'HEMAT10');
      expect(suggestion.routePath, '/vouchers/4');
    });

    test('parses orders correctly', () {
      final json = {
        'id': 5,
        'order_number': 'ORD-2024-001',
        'status': 'completed',
        'total': 2500000,
        'user': {'name': 'John Doe'},
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.orders,
        json,
      );
      expect(suggestion.type, SuggestionType.orders);
      expect(suggestion.id, 5);
      expect(suggestion.name, 'ORD-2024-001');
      expect(suggestion.subtitle, 'completed');
      expect(suggestion.routePath, '/order/5');
    });

    test('parses reviews correctly', () {
      final json = {
        'id': 6,
        'comment': 'Pelayanan bagus',
        'rating': 5,
        'package': {'name': 'Paket A'},
        'user': {'name': 'Jane'},
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.reviews,
        json,
      );
      expect(suggestion.type, SuggestionType.reviews);
      expect(suggestion.id, 6);
      expect(suggestion.name, 'Pelayanan bagus');
      expect(suggestion.subtitle, 'Paket A');
      expect(suggestion.routePath, '/my-reviews');
    });

    test('parses vendors correctly', () {
      final json = {
        'id': 7,
        'store_name': 'Toko Bunga Indah',
        'store_description': 'Terpercaya',
        'contact_person': 'Budi',
        'packages_count': 10,
        'products_count': 20,
        'logo': 'https://example.com/logo.jpg',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.vendors,
        json,
      );
      expect(suggestion.type, SuggestionType.vendors);
      expect(suggestion.id, 7);
      expect(suggestion.name, 'Toko Bunga Indah');
      expect(suggestion.imageUrl, 'https://example.com/logo.jpg');
      expect(suggestion.routePath, '/vendor/7');
    });

    test('parses terms correctly', () {
      final json = {
        'id': 8,
        'name': 'Syarat Layanan',
        'title': 'Terms of Service',
        'description': 'Isi terms',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.terms,
        json,
      );
      expect(suggestion.type, SuggestionType.terms);
      expect(suggestion.id, 8);
      expect(suggestion.name, 'Syarat Layanan');
      expect(suggestion.routePath, '/terms-of-service');
    });

    test('parses privacy correctly', () {
      final json = {
        'id': 9,
        'name': 'Kebijakan Privasi',
        'title': 'Privacy Policy',
        'content': 'Isi privacy',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.privacy,
        json,
      );
      expect(suggestion.type, SuggestionType.privacy);
      expect(suggestion.id, 9);
      expect(suggestion.routePath, '/privacy-policy');
    });

    test('parses helps correctly', () {
      final json = {
        'id': 10,
        'name': 'Cara Pemesanan',
        'title': 'How to Order',
        'description': 'Panduan pemesanan',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.helps,
        json,
      );
      expect(suggestion.type, SuggestionType.helps);
      expect(suggestion.id, 10);
      expect(suggestion.routePath, '/help-center');
    });

    test('parses histories correctly', () {
      final json = {
        'id': 11,
        'reference_number': 'TRX-001',
        'type': 'payment',
        'status': 'success',
        'info': 'Pembayaran berhasil',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.histories,
        json,
      );
      expect(suggestion.type, SuggestionType.histories);
      expect(suggestion.id, 11);
      expect(suggestion.name, 'TRX-001');
      expect(suggestion.routePath, '/history');
    });

    test('parses weddingPolicy correctly', () {
      final json = {
        'id': 12,
        'name': 'Kebijakan Wedding',
        'title': 'Wedding Policy',
        'description': 'Kebijakan',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.weddingPolicy,
        json,
      );
      expect(suggestion.type, SuggestionType.weddingPolicy);
      expect(suggestion.id, 12);
      expect(suggestion.routePath, '/wedding-policy');
    });

    test('handles null/empty fields gracefully', () {
      final json = <String, dynamic>{};
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.packages,
        json,
      );
      expect(suggestion.id, 0);
      expect(suggestion.name, isNull);
      expect(suggestion.subtitle, isNull);
      expect(suggestion.imageUrl, isNull);
    });

    test('extracts image from media array', () {
      final json = {
        'id': 13,
        'name': 'Test',
        'media': [
          {
            'original_url': 'https://example.com/original.jpg',
            'preview_url': 'https://example.com/preview.jpg',
          },
        ],
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.products,
        json,
      );
      expect(suggestion.imageUrl, 'https://example.com/original.jpg');
    });

    test('extracts image from media preview_url when original is null', () {
      final json = {
        'id': 14,
        'name': 'Test',
        'media': [
          {
            'preview_url': 'https://example.com/preview.jpg',
          },
        ],
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.products,
        json,
      );
      expect(suggestion.imageUrl, 'https://example.com/preview.jpg');
    });

    test('extracts image from image field', () {
      final json = {
        'id': 15,
        'name': 'Test',
        'image': 'https://example.com/image.jpg',
      };
      final suggestion = SearchSuggestion.fromJson(
        SuggestionType.products,
        json,
      );
      expect(suggestion.imageUrl, 'https://example.com/image.jpg');
    });
  });

  group('SearchSuggestion properties', () {
    test('const constructor works', () {
      const suggestion = SearchSuggestion(
        type: SuggestionType.packages,
        id: 1,
        name: 'Test',
        routePath: '/test',
      );
      expect(suggestion.type, SuggestionType.packages);
      expect(suggestion.id, 1);
      expect(suggestion.name, 'Test');
      expect(suggestion.routePath, '/test');
      expect(suggestion.subtitle, isNull);
      expect(suggestion.subtitle2, isNull);
      expect(suggestion.imageUrl, isNull);
      expect(suggestion.routeExtra, isNull);
      expect(suggestion.rawData, isNull);
    });

    test('constructor with all fields', () {
      final suggestion = SearchSuggestion(
        type: SuggestionType.vouchers,
        id: 2,
        name: 'Voucher',
        subtitle: 'Sub',
        subtitle2: 'Sub2',
        imageUrl: 'https://example.com/img.jpg',
        routePath: '/voucher/2',
        routeExtra: {'key': 'value'},
        rawData: {'raw': 'data'},
      );
      expect(suggestion.type, SuggestionType.vouchers);
      expect(suggestion.id, 2);
      expect(suggestion.name, 'Voucher');
      expect(suggestion.subtitle, 'Sub');
      expect(suggestion.subtitle2, 'Sub2');
      expect(suggestion.imageUrl, 'https://example.com/img.jpg');
      expect(suggestion.routePath, '/voucher/2');
      expect(suggestion.routeExtra, {'key': 'value'});
      expect(suggestion.rawData, {'raw': 'data'});
    });
  });
}
