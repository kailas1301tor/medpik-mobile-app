import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/src/home/model/home_model.dart';

void main() {
  group('HomeFeedModel', () {
    test('parses latest home envelope with banners, rails, and badge count', () {
      final feed = HomeFeedModel.fromJson({
        'message': 'Home feed retrieved',
        'status': true,
        'results': {
          'data': {
            'banners': [
              {
                'id': 1,
                'title': null,
                'image': 'https://cdn.example.com/banner-a.png',
              },
              {
                'id': 2,
                'title': 'Summer',
                'image': 'https://cdn.example.com/banner-b.png',
              },
            ],
            'categories': [
              {
                'id': 7,
                'name': 'Fever',
                'image': 'https://cdn.example.com/cat.png',
              },
            ],
            'offers': [
              {
                'id': 11,
                'title': 'Flat 20% off',
                'description': 'On selected meds',
                'offer_label': 'HOT',
                'coupon_code': 'SAVE20',
                'image': null,
                'gradient_color_1': '#112233',
                'gradient_color_2': '#445566',
                'discount_value': '20',
                'discount_type': 'percent',
              },
            ],
            'products': [
              {
                'id': 101,
                'name': 'Popular Pill',
                'rate': '99.00',
                'mrp': '120.00',
                'is_otc': true,
                'is_wishlisted': false,
                'category_detail': {'id': 7, 'name': 'Fever'},
              },
            ],
            'vitamins_and_supplements': [
              {
                'id': 7275,
                'name': 'Zeefron-S Injection',
                'rate': '300.00',
                'is_otc': false,
                'category_detail': {
                  'id': 55,
                  'name': 'Vitamins & Supplements',
                },
              },
            ],
            'personal_care': [],
            'baby_care': [
              {
                'id': 8001,
                'name': 'Baby Lotion',
                'rate': '199.00',
                'is_otc': true,
              },
            ],
            'support_phone': '9995567671',
            'in_app_notification_count': 28,
          },
        },
      });

      expect(feed.status, isTrue);
      expect(feed.message, 'Home feed retrieved');
      expect(feed.supportPhone, '9995567671');
      expect(feed.inAppNotificationCount, 28);
      expect(feed.bannerImageUrls, [
        'https://cdn.example.com/banner-a.png',
        'https://cdn.example.com/banner-b.png',
      ]);
      expect(feed.banners.first.title, isEmpty);
      expect(feed.offers, hasLength(1));
      expect(feed.offers.first.badgeLabel, 'HOT');
      expect(feed.offers.first.promoCode, 'SAVE20');
      expect(feed.offers.first.imageUrl, isEmpty);

      final imaged = HomeFeedModel.fromJson({
        'status': true,
        'results': {
          'data': {
            'offers': [
              {
                'id': 4,
                'title': 'flat 20% off',
                'description': 'purchase 500rs ++',
                'offer_label': 'Purchase Above 500rs',
                'image':
                    'http://127.0.0.1:8000/media/offers/offer.webp',
              },
            ],
          },
        },
      });
      expect(imaged.offers.first.imageUrl,
          'http://127.0.0.1:8000/media/offers/offer.webp');
      expect(feed.featuredProducts, hasLength(1));
      expect(feed.vitaminsAndSupplements.first.id, 7275);
      expect(feed.personalCare, isEmpty);
      expect(feed.babyCare, hasLength(1));
      expect(feed.categories.first.name, 'Fever');
    });

    test('falls back to results.support_phone when data phone is blank', () {
      final feed = HomeFeedModel.fromJson({
        'status': true,
        'results': {
          'support_phone': '8881112222',
          'data': {
            'support_phone': '',
            'in_app_notification_count': 0,
          },
        },
      });

      expect(feed.supportPhone, '8881112222');
      expect(feed.inAppNotificationCount, 0);
    });

    test('keeps missing data nullable', () {
      final feed = HomeFeedModel.fromJson({
        'message': 'ok',
        'results': {},
      });

      expect(feed.results.data, isNull);
      expect(feed.featuredProducts, isEmpty);
      expect(feed.bannerImageUrls, isEmpty);
      expect(feed.supportPhone, isEmpty);
    });
  });
}
