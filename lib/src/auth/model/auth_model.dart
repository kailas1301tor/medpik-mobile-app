// lib/src/auth/model/auth_model.dart
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class AuthModel {
  const AuthModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.customerId,
    this.countryCode,
    this.status = UserAccountStatus.active,
    this.accessToken,
    this.refreshToken,
  });

  final int id;
  final String name;
  final String phone;
  final String email;
  final int? customerId;
  final String? countryCode;
  final UserAccountStatus status;
  final String? accessToken;
  final String? refreshToken;

  bool get isSuspended => status == UserAccountStatus.suspended;

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        id: convertToInt(json['id']),
        name: convertToString(json['name']),
        phone: convertToString(
          json['phone_number'] ?? json['phone'],
        ),
        email: convertToString(json['email']),
        customerId: json['customer_id'] == null
            ? null
            : convertToInt(json['customer_id']),
        countryCode: convertToString(json['country_code']),
        status: _parseStatus(convertToString(json['status'])),
        accessToken: convertToString(json['access']),
        refreshToken: convertToString(json['refresh']),
      );

  Map<String, dynamic> toSessionMap({
    required bool isNewUser,
  }) =>
      {
        'userId': id,
        'customerId': customerId ?? 0,
        'countryCode': countryCode ?? '',
        'phoneNumber': phone,
        'name': name,
        'email': email,
        'isNewUser': isNewUser,
        'accessToken': accessToken ?? '',
        'refreshToken': refreshToken ?? '',
      };

  factory AuthModel.fromSessionMap(Map<String, dynamic> map) => AuthModel(
        id: convertToInt(map['userId']),
        name: convertToString(map['name']),
        phone: convertToString(map['phoneNumber']),
        email: convertToString(map['email']),
        customerId: convertToInt(map['customerId']),
        countryCode: convertToString(map['countryCode']),
        accessToken: convertToString(map['accessToken']),
        refreshToken: convertToString(map['refreshToken']),
      );

  static UserAccountStatus _parseStatus(String value) {
    return switch (value.toLowerCase()) {
      'suspended' => UserAccountStatus.suspended,
      _ => UserAccountStatus.active,
    };
  }
}

class AuthTokensModel {
  const AuthTokensModel({
    required this.access,
    required this.refresh,
  });

  final String access;
  final String refresh;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      AuthTokensModel(
        access: convertToString(json['access']),
        refresh: convertToString(json['refresh']),
      );
}

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.countryCode,
    required this.phoneNumber,
  });

  final int id;
  final String countryCode;
  final String phoneNumber;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        id: convertToInt(json['id']),
        countryCode: convertToString(json['country_code']),
        phoneNumber: convertToString(json['phone_number']),
      );
}

class CustomerModel {
  const CustomerModel({required this.id});

  final int id;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: convertToInt(json['id']),
      );
}

/// Parsed verify-otp payload from `results.data`.
class VerifyOtpResult {
  const VerifyOtpResult({
    required this.verified,
    required this.isNewUser,
    required this.user,
    required this.customer,
    required this.tokens,
    required this.authModel,
    this.message = '',
  });

  final bool verified;
  final bool isNewUser;
  final AuthUserModel user;
  final CustomerModel customer;
  final AuthTokensModel tokens;
  final AuthModel authModel;
  final String message;

  factory VerifyOtpResult.fromApiJson(Map<String, dynamic> json) {
    final topMessage = convertToString(json['message']);
    final results = convertToMap(json['results']);
    final data = convertToMap(results['data']);
    final user = AuthUserModel.fromJson(convertToMap(data['user']));
    final customer = CustomerModel.fromJson(convertToMap(data['customer']));
    final tokens = AuthTokensModel.fromJson(convertToMap(data['tokens']));
    final dataMessage = convertToString(data['message']);

    return VerifyOtpResult(
      verified: convertToBool(data['verified']),
      isNewUser: convertToBool(data['is_new_user']),
      user: user,
      customer: customer,
      tokens: tokens,
      message: dataMessage.isNotEmpty ? dataMessage : topMessage,
      authModel: AuthModel(
        id: user.id,
        name: '',
        phone: user.phoneNumber,
        email: '',
        customerId: customer.id,
        countryCode: user.countryCode,
        accessToken: tokens.access,
        refreshToken: tokens.refresh,
      ),
    );
  }
}

class CommonResponseModel {
  const CommonResponseModel({required this.message, this.status = true});

  final String message;
  final bool status;

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return CommonResponseModel(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
    );
  }
}
