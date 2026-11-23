// lib/utils/helpers/product_pack_label_helper.dart
import 'package:medpik/data/models/product_model.dart';

/// Compact pack codes like `10s` / `4S` mean "Strip of N tablets".
final _compactStripPackPattern = RegExp(r'^(\d+)\s*s$', caseSensitive: false);

String productPackDisplayLabel(ProductModel product) {
  final packSize = product.packSize.trim();
  if (packSize.isEmpty) return '';

  final lower = packSize.toLowerCase();
  if (lower.contains('ml')) return '$packSize • Oral Drops';

  final compact = _compactStripPackPattern.firstMatch(packSize);
  if (compact != null) {
    return 'Strip of ${compact.group(1)} tablets';
  }

  // Already a human label from API (e.g. "strip of 10 tablets") — show as-is.
  return packSize;
}

String productPackBadgeLabel(ProductModel product) {
  final packSize = product.packSize.trim();
  if (packSize.isEmpty) return '';

  final lower = packSize.toLowerCase();
  if (lower.contains('ml')) return packSize;

  final compact = _compactStripPackPattern.firstMatch(packSize);
  if (compact != null) {
    return '${compact.group(1)} Tablets';
  }

  return packSize;
}
