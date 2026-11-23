import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/utils/helpers/product_pack_label_helper.dart';

ProductModel _product({required String packSize}) => ProductModel(
  id: 1,
  name: 'Test',
  category: 'Test',
  price: 0,
  imageUrl: '',
  requiresPrescription: false,
  packSize: packSize,
);

void main() {
  group('productPackDisplayLabel', () {
    test('rewrites compact 10s codes only', () {
      expect(
        productPackDisplayLabel(_product(packSize: '10s')),
        'Strip of 10 tablets',
      );
      expect(
        productPackDisplayLabel(_product(packSize: '4S')),
        'Strip of 4 tablets',
      );
    });

    test('does not duplicate strip of when API already sent a label', () {
      expect(
        productPackDisplayLabel(
          _product(packSize: 'strip of 10 tablets'),
        ),
        'strip of 10 tablets',
      );
      expect(
        productPackDisplayLabel(
          _product(packSize: 'Strip of 4 soft gelatin capsules'),
        ),
        'Strip of 4 soft gelatin capsules',
      );
    });

    test('keeps ml packs with oral drops hint', () {
      expect(
        productPackDisplayLabel(_product(packSize: '15 ml')),
        '15 ml • Oral Drops',
      );
    });
  });

  group('productPackBadgeLabel', () {
    test('rewrites compact codes without duplicating full labels', () {
      expect(productPackBadgeLabel(_product(packSize: '10s')), '10 Tablets');
      expect(
        productPackBadgeLabel(_product(packSize: 'strip of 10 tablets')),
        'strip of 10 tablets',
      );
    });
  });
}
