// lib/data/models/product_detail_args.dart
//
// ? Typed navigation args for [ProductDetailScreen].
class ProductDetailArgs {
  const ProductDetailArgs({
    required this.productId,
    this.isFromUploadPrescription = false,
  });

  final int productId;
  final bool isFromUploadPrescription;

  static ProductDetailArgs from(Object? arguments) {
    if (arguments is ProductDetailArgs) return arguments;
    if (arguments is int) return ProductDetailArgs(productId: arguments);
    return const ProductDetailArgs(productId: 0);
  }
}
