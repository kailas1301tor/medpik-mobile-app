// lib/src/profile/model/profile_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class ProfileResponse {
  const ProfileResponse({
    required this.results,
    this.message = '',
  });

  final ProfileResults results;
  final String message;

  ProfileModel? get profile => results.data;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        message: convertToString(json['message']),
        results: ProfileResults.fromJson(convertToMap(json['results'])),
      );
}

class ProfileResults {
  const ProfileResults({this.data});

  final ProfileModel? data;

  factory ProfileResults.fromJson(Map<String, dynamic> json) => ProfileResults(
        data: json['data'] == null
            ? null
            : ProfileModel.fromJson(convertToMap(json['data'])),
      );
}

class ProfileModel {
  const ProfileModel({
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
  });

  final String firstName;
  final String lastName;
  final String phoneNumber;

  String get displayName =>
      '$firstName $lastName'.trim().replaceAll(RegExp(r'\s+'), ' ');

  Map<String, dynamic> toUpdateJson() => {
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
      };

  ProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) =>
      ProfileModel(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
      );

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        firstName: convertToString(json['first_name']),
        lastName: convertToString(json['last_name']),
        phoneNumber: convertToString(json['phone_number']),
      );
}
