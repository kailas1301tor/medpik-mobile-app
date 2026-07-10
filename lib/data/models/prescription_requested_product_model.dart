// lib/data/models/prescription_requested_product_model.dart
import 'package:tsuite/utils/helpers/safe_converters.dart';

class PrescriptionRequestedProductModel {
  const PrescriptionRequestedProductModel({
    required this.name,
    required this.quantity,
    this.notes = '',
  });

  final String name;
  final int quantity;
  final String notes;

  PrescriptionRequestedProductModel copyWith({
    String? name,
    int? quantity,
    String? notes,
  }) =>
      PrescriptionRequestedProductModel(
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        notes: notes ?? this.notes,
      );

  factory PrescriptionRequestedProductModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      PrescriptionRequestedProductModel(
        name: convertToString(json['name']),
        quantity: convertToInt(json['quantity'], defValue: 1),
        notes: convertToString(json['notes']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'notes': notes,
      };
}
