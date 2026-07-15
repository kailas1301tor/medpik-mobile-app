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
    this.latitude,
    this.longitude,
    this.placeId,
    this.formattedAddress,
  });

  final int id;
  final String label;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final String? formattedAddress;

  String get fullAddress {
    final parts = <String>[
      line1,
      if (line2.trim().isNotEmpty) line2,
      city,
      state,
      if (pincode.trim().isNotEmpty) pincode,
    ];
    return parts.join(', ');
  }

  String get deliveryHint {
    final place = formattedAddress?.trim();
    if (place != null && place.isNotEmpty) {
      return '$label · $place';
    }
    return '$label · $city, $pincode';
  }

  bool get hasCoordinates => latitude != null && longitude != null;

  AddressModel copyWith({
    int? id,
    String? label,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? pincode,
    bool? isDefault,
    double? latitude,
    double? longitude,
    String? placeId,
    String? formattedAddress,
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
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        placeId: placeId ?? this.placeId,
        formattedAddress: formattedAddress ?? this.formattedAddress,
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
        latitude: json['latitude'] == null
            ? null
            : convertToDouble(json['latitude']),
        longitude: json['longitude'] == null
            ? null
            : convertToDouble(json['longitude']),
        placeId: convertToString(json['place_id']).isEmpty
            ? null
            : convertToString(json['place_id']),
        formattedAddress: convertToString(json['formatted_address']).isEmpty
            ? null
            : convertToString(json['formatted_address']),
      );
}
