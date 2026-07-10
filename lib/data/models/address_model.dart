// lib/data/models/address_model.dart
import 'package:tsuite/utils/helpers/safe_converters.dart';

class AddressModel {
  const AddressModel({
    required this.id,
    required this.label,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
  });

  final int id;
  final String label;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  String get fullAddress => '$line1, $line2, $city, $state - $pincode';

  AddressModel copyWith({
    int? id,
    String? label,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? pincode,
    bool? isDefault,
  }) =>
      AddressModel(
        id: id ?? this.id,
        label: label ?? this.label,
        line1: line1 ?? this.line1,
        line2: line2 ?? this.line2,
        city: city ?? this.city,
        state: state ?? this.state,
        pincode: pincode ?? this.pincode,
        isDefault: isDefault ?? this.isDefault,
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: convertToInt(json['id']),
        label: convertToString(json['label']),
        line1: convertToString(json['line1']),
        line2: convertToString(json['line2']),
        city: convertToString(json['city']),
        state: convertToString(json['state']),
        pincode: convertToString(json['pincode']),
        isDefault: convertToBool(json['is_default']),
      );
}
