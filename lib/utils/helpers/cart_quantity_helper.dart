// lib/utils/helpers/cart_quantity_helper.dart
import 'package:medpik/data/models/cart_item_model.dart';

int cartQuantityForProduct(List<CartItemModel> items, int productId) {
  for (final item in items) {
    if (item.product.id == productId) return item.quantity;
  }
  return 0;
}
