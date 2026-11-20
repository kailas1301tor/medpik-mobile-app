// test/src/auth/notifier/auth_onboarding_notifier_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/local/sembast_services.dart';
import 'package:medpik/providers/app_container.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/auth/model/auth_model.dart';
import 'package:medpik/src/auth/notifier/auth_notifier.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class FakeSembastServices extends SembastServices {
  bool isNewUserFlag = false;
  Map<String, dynamic>? storedSession;
  String? accessToken;
  String? refreshToken;

  @override
  Future<bool> isNewUser() async => isNewUserFlag;

  @override
  Future<void> saveUser({required bool isNewUser}) async {
    isNewUserFlag = isNewUser;
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    if (storedSession == null) return null;
    final session = Map<String, dynamic>.from(storedSession!);
    if (accessToken != null) session['accessToken'] = accessToken;
    if (refreshToken != null) session['refreshToken'] = refreshToken;
    return session;
  }

  @override
  Future<void> insertUserData(Map<String, dynamic> session) async {
    accessToken = convertToString(session['accessToken']);
    refreshToken = convertToString(session['refreshToken']);
    storedSession = Map<String, dynamic>.from(session)
      ..remove('accessToken')
      ..remove('refreshToken');
    isNewUserFlag = convertToBool(session['isNewUser']);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<String?> getAccessToken() async => accessToken;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<bool> clearLocalDb() async {
    storedSession = null;
    accessToken = null;
    refreshToken = null;
    isNewUserFlag = false;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthNotifier onboarding', () {
    late ProviderContainer container;
    late FakeSembastServices fakeSembast;

    setUp(() {
      fakeSembast = FakeSembastServices();
      container = ProviderContainer(
        overrides: [
          sembastServicesProvider.overrideWithValue(fakeSembast),
        ],
      );
      bindAppProviderContainer(container);
    });

    tearDown(() {
      unbindAppProviderContainer(container);
      container.dispose();
    });

    AuthNotifier readNotifier() =>
        container.read(authNotifierProvider.notifier);

    test('markProfileCompleted clears isNewUser when flag was true', () async {
      final authModel = AuthModel(
        id: 1,
        name: 'Test User',
        phone: '9876543210',
        email: 'test@example.com',
        accessToken: 'access',
        refreshToken: 'refresh',
      );

      fakeSembast.isNewUserFlag = true;
      await fakeSembast.insertUserData(
        authModel.toSessionMap(isNewUser: true),
      );
      AppConstants.setSessionTokens(
        access: authModel.accessToken!,
        refresh: authModel.refreshToken!,
      );

      readNotifier().state = readNotifier().state.copyWith(authModel: authModel);

      await readNotifier().markProfileCompleted();

      expect(fakeSembast.isNewUserFlag, isFalse);
      expect(
        convertToBool(fakeSembast.storedSession?['isNewUser']),
        isFalse,
      );
    });

    test('markProfileCompleted is no-op when isNewUser is false', () async {
      final authModel = AuthModel(
        id: 1,
        name: 'Test User',
        phone: '9876543210',
        email: 'test@example.com',
        accessToken: 'access',
        refreshToken: 'refresh',
      );

      fakeSembast.isNewUserFlag = false;
      await fakeSembast.insertUserData(
        authModel.toSessionMap(isNewUser: false),
      );

      readNotifier().state = readNotifier().state.copyWith(authModel: authModel);

      await readNotifier().markProfileCompleted();

      expect(fakeSembast.isNewUserFlag, isFalse);
    });

    test(
      'markProfileCompleted clears isNewUser when authModel is not in state',
      () async {
        final authModel = AuthModel(
          id: 1,
          name: 'Test User',
          phone: '9876543210',
          email: 'test@example.com',
          accessToken: 'access',
          refreshToken: 'refresh',
        );

        fakeSembast.isNewUserFlag = true;
        await fakeSembast.insertUserData(
          authModel.toSessionMap(isNewUser: true),
        );

        await readNotifier().markProfileCompleted();

        expect(fakeSembast.isNewUserFlag, isFalse);
        expect(
          convertToBool(fakeSembast.storedSession?['isNewUser']),
          isFalse,
        );
      },
    );

    test('new user OTP destination is personal information onboarding', () {
      expect(
        otpDestinationForNewUser(true),
        RouteConstants.routePersonalInformationScreen,
      );
    });

    test('returning user OTP destination is main screen', () {
      expect(otpDestinationForNewUser(false), RouteConstants.mainScreen);
    });
  });
}

String otpDestinationForNewUser(bool isNewUser) => isNewUser
    ? RouteConstants.routePersonalInformationScreen
    : RouteConstants.mainScreen;
