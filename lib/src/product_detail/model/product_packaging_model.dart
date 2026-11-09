// lib/src/product_detail/model/product_packaging_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class ProductPackagingModel {
  const ProductPackagingModel({
    this.mrp,
    this.qty = '',
    this.package = '',
    this.packaging = '',
    this.productForm = '',
  });

  final double? mrp;
  final String qty;
  final String package;
  final String packaging;
  final String productForm;

  String get displayLabel {
    if (packaging.trim().isNotEmpty) return packaging.trim();
    final qtyLabel = qty.trim();
    final packageLabel = package.trim();
    if (qtyLabel.isNotEmpty && packageLabel.isNotEmpty) {
      return '$packageLabel of $qtyLabel';
    }
    if (qtyLabel.isNotEmpty) return qtyLabel;
    return packageLabel;
  }

  factory ProductPackagingModel.fromJson(Map<String, dynamic> json) =>
      ProductPackagingModel(
        mrp: json['mrp'] == null ? null : convertToDouble(json['mrp']),
        qty: convertToString(json['qty']),
        package: convertToString(json['package']),
        packaging: convertToString(json['packaging']),
        productForm: convertToString(json['product_form']),
      );
}
