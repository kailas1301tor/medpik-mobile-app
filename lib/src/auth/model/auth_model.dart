// lib/src/auth/model/auth_model.dart
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class AuthModel {
  const AuthModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.status = UserAccountStatus.active,
    this.accessToken,
    this.refreshToken,
  });

  final int id;
  final String name;
  final String phone;
  final String email;
  final UserAccountStatus status;
  final String? accessToken;
  final String? refreshToken;

  bool get isSuspended => status == UserAccountStatus.suspended;

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        id: convertToInt(json['id']),
        name: convertToString(json['name']),
        phone: convertToString(json['phone']),
        email: convertToString(json['email']),
        status: _parseStatus(convertToString(json['status'])),
        accessToken: convertToString(json['access']),
        refreshToken: convertToString(json['refresh']),
      );

  static UserAccountStatus _parseStatus(String value) {
    return switch (value.toLowerCase()) {
      'suspended' => UserAccountStatus.suspended,
      _ => UserAccountStatus.active,
    };
  }
}

class CommonResponseModel {
  const CommonResponseModel({required this.message, required this.status});

  final String message;
  final bool status;

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonResponseModel(
        message: convertToString(json['message']),
        status: convertToBool(json['status']),
      );
}
