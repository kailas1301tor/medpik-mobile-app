// lib/src/auth/model/verify_otp_response_model.dart
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/auth/model/auth_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class VerifyOtpResponse {
  const VerifyOtpResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final VerifyOtpResultsModel results;
  final String message;
  final bool status;

  bool get verified => results.data?.verified ?? false;

  bool get isNewUser => results.data?.isNewUser ?? false;

  bool get hasData => results.data != null;

  AuthModel? get authModel => results.data?.authModel;

  String get resolvedMessage {
    final dataMessage = results.data?.message ?? '';
    return dataMessage.isNotEmpty ? dataMessage : message;
  }

  String? get validationError {
    if (!hasData || !verified) return Strings.otpVerificationFailed;
    final model = authModel;
    if (model == null) return Strings.otpVerificationFailed;
    if (model.isSuspended) return Strings.accountSuspended;
    return null;
  }

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return VerifyOtpResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: VerifyOtpResultsModel.fromJson(convertToMap(json['results'])),
    );
  }
}

class VerifyOtpResultsModel {
  const VerifyOtpResultsModel({this.data});

  final VerifyOtpDataModel? data;

  factory VerifyOtpResultsModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResultsModel(
        data: json['data'] == null
            ? null
            : VerifyOtpDataModel.fromJson(convertToMap(json['data'])),
      );
}

class VerifyOtpDataModel {
  const VerifyOtpDataModel({
    required this.verified,
    required this.isNewUser,
    required this.user,
    required this.customer,
    required this.tokens,
    this.message = '',
  });

  final bool verified;
  final bool isNewUser;
  final AuthUserModel user;
  final CustomerModel customer;
  final AuthTokensModel tokens;
  final String message;

  AuthModel get authModel => AuthModel(
        id: user.id,
        name: '',
        phone: user.phoneNumber,
        email: '',
        customerId: customer.id,
        countryCode: user.countryCode,
        accessToken: tokens.access,
        refreshToken: tokens.refresh,
      );

  factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpDataModel(
        verified: convertToBool(json['verified']),
        isNewUser: convertToBool(json['is_new_user']),
        user: AuthUserModel.fromJson(convertToMap(json['user'])),
        customer: CustomerModel.fromJson(convertToMap(json['customer'])),
        tokens: AuthTokensModel.fromJson(convertToMap(json['tokens'])),
        message: convertToString(json['message']),
      );
}
