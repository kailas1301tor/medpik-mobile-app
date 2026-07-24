import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/models/cart_item_model.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/utils/helpers/cart_quantity_helper.dart';

void main() {
  group('cartQuantityForProduct', () {
    const product = ProductModel(
      id: 42,
      name: 'Test',
      category: 'General',
      price: 10,
      imageUrl: '',
      requiresPrescription: false,
    );

    test('returns quantity when product is in cart', () {
      const items = [
        CartItemModel(id: 1, product: product, quantity: 3),
      ];

      expect(cartQuantityForProduct(items, 42), 3);
    });

    test('returns 0 when product is not in cart', () {
      const items = [
        CartItemModel(id: 1, product: product, quantity: 1),
      ];

      expect(cartQuantityForProduct(items, 99), 0);
    });

    test('returns 0 for empty cart', () {
      expect(cartQuantityForProduct(const [], 1), 0);
    });
  });
}
