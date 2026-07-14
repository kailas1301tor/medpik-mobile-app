// lib/utils/helpers/product_pack_label_helper.dart
import 'package:tsuite/data/models/product_model.dart';

String productPackDisplayLabel(ProductModel product) {
  final packSize = product.packSize.trim();
  if (packSize.isEmpty) return '';

  if (product.id == 101) return 'Strip of 15 tablets';

  final lower = packSize.toLowerCase();
  if (lower.contains('ml')) return '$packSize • Oral Drops';
  if (lower.endsWith('s')) {
    final count = packSize.substring(0, packSize.length - 1);
    return 'Strip of $count tablets';
  }

  return 'Pack of $packSize';
}

String productPackBadgeLabel(ProductModel product) {
  final packSize = product.packSize.trim();
  if (packSize.isEmpty) return '';

  if (product.id == 101) return '15 Tablets';

  final lower = packSize.toLowerCase();
  if (lower.contains('ml')) return packSize;
  if (lower.endsWith('s')) {
    return '${packSize.substring(0, packSize.length - 1)} Tablets';
  }

  return packSize;
}
