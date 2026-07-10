// lib/data/mock/mock_users.dart
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/auth/model/auth_model.dart';

class MockUsers {
  static const String validOtp = '123456';

  static AuthModel activeUser({required String phone}) => AuthModel(
        id: 1,
        name: 'Medpik User',
        phone: phone,
        email: 'user@medpik.com',
        status: UserAccountStatus.active,
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
      );

  static AuthModel suspendedUser({required String phone}) => AuthModel(
        id: 2,
        name: 'Suspended User',
        phone: phone,
        email: 'suspended@medpik.com',
        status: UserAccountStatus.suspended,
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
      );

  static bool isSuspendedPhone(String phone) =>
      phone == AppConstants.suspendedTestPhone;
}
