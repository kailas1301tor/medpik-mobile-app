// lib/src/search/model/product_catalog_args.dart
import 'package:tsuite/res/constants/string_constants.dart';

/// Typed navigation args for the unified customer-products catalog screen.
class ProductCatalogArgs {
  const ProductCatalogArgs({
    required this.title,
    this.search = '',
    this.categoryId,
    this.offerId,
  });

  final String title;
  final String search;
  final int? categoryId;
  final int? offerId;

  /// Accepts [ProductCatalogArgs] or a legacy [String] query.
  static ProductCatalogArgs from(Object? arguments) {
    if (arguments is ProductCatalogArgs) return arguments;
    if (arguments is String) {
      final query = arguments.trim();
      return ProductCatalogArgs(
        title: query.isEmpty ? Strings.search : query,
        search: query,
      );
    }
    return const ProductCatalogArgs(title: Strings.search);
  }
}
