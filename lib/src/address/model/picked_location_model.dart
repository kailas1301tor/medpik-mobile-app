// lib/src/address/model/picked_location_model.dart
class PickedLocationModel {
  const PickedLocationModel({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.line1 = '',
    this.line2 = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.placeId,
  });

  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
  final String? placeId;
}
