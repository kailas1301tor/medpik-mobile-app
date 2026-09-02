// lib/src/profile/model/store_profile_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class StoreProfileResponse {
  const StoreProfileResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final StoreProfileResults results;
  final String message;
  final bool status;

  StoreProfileModel? get data => results.data;

  factory StoreProfileResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return StoreProfileResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: StoreProfileResults.fromJson(convertToMap(json['results'])),
    );
  }
}

class StoreProfileResults {
  const StoreProfileResults({this.data});

  final StoreProfileModel? data;

  factory StoreProfileResults.fromJson(Map<String, dynamic> json) =>
      StoreProfileResults(
        data: json['data'] == null
            ? null
            : StoreProfileModel.fromJson(convertToMap(json['data'])),
      );
}

class StoreProfileModel {
  const StoreProfileModel({
    this.id = 0,
    this.supportPhone = '',
    this.supportEmail = '',
    this.updatedAt = '',
  });

  final int id;
  final String supportPhone;
  final String supportEmail;
  final String updatedAt;

  bool get hasSupportPhone => supportPhone.trim().isNotEmpty;
  bool get hasSupportEmail => supportEmail.trim().isNotEmpty;
  bool get hasContact => hasSupportPhone || hasSupportEmail;

  factory StoreProfileModel.fromJson(Map<String, dynamic> json) =>
      StoreProfileModel(
        id: convertToInt(json['id']),
        supportPhone: convertToString(json['support_phone']),
        supportEmail: convertToString(json['support_email']),
        updatedAt: convertToString(json['updated_at']),
      );
}
