// test/src/auth/notifier/auth_delete_account_notifier_test.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/local/sembast_services.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/auth/model/auth_model.dart';
import 'package:medpik/src/auth/model/verify_otp_response_model.dart';
import 'package:medpik/src/auth/notifier/auth_notifier.dart';
import 'package:medpik/src/auth/repo/auth_repo.dart';
import 'package:medpik/src/root/medpik_app.dart';
import 'package:medpik/utils/routes/route_constants.dart';
import 'package:toastification/toastification.dart';

class FakeDeleteAuthRepo implements AuthRepo {
  String? lastRequestOtpPhone;
  String? lastDeletePhone;
  String? lastDeleteOtp;

  @override
  Future<Either<ResponseError, CommonResponseModel>> requestOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  }) async {
    lastRequestOtpPhone = phone;
    return Right(CommonResponseModel(message: 'OTP sent'));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> resendOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  }) async {
    lastRequestOtpPhone = phone;
    return Right(CommonResponseModel(message: 'OTP resent'));
  }

  @override
  Future<Either<ResponseError, VerifyOtpResponse>> verifyOtp({
    required String phone,
    required String otp,
    String countryCode = AppConstants.defaultCountryCode,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> logout({
    required String refresh,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> deleteAccount({
    required String phone,
    required String otp,
    String countryCode = AppConstants.defaultCountryCode,
  }) async {
    lastDeletePhone = phone;
    lastDeleteOtp = otp;
    return Right(CommonResponseModel(message: 'Account deleted'));
  }
}

class FakeSembastServices extends SembastServices {
  Map<String, dynamic>? storedSession;

  @override
  Future<bool> clearLocalDb() async {
    storedSession = null;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthNotifier delete account flow', () {
    late ProviderContainer container;
    late FakeDeleteAuthRepo fakeRepo;
    late FakeSembastServices fakeSembast;

    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() {
      fakeRepo = FakeDeleteAuthRepo();
      fakeSembast = FakeSembastServices();
      navigatorKey = GlobalKey<NavigatorState>();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
          sembastServicesProvider.overrideWithValue(fakeSembast),
          navigatorKeyProvider.overrideWithValue(navigatorKey),
        ],
      );
    });

    tearDown(() => container.dispose());

    AuthNotifier readNotifier() =>
        container.read(authNotifierProvider.notifier);

    Future<void> pumpTestApp(WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (_, __) => ToastificationWrapper(
              child: MaterialApp(
                navigatorKey: navigatorKey,
                routes: {
                  RouteConstants.routeOtpScreen: (_) =>
                      const Scaffold(body: Text('otp')),
                  RouteConstants.routeLoginScreen: (_) =>
                      const Scaffold(body: Text('login')),
                },
                home: Consumer(
                  builder: (context, ref, _) {
                    ref.watch(authNotifierProvider);
                    return const Scaffold(body: Text('home'));
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    Future<void> flushToastTimers(WidgetTester tester) async {
      await tester.pump(const Duration(seconds: 4));
    }

    test('resetOtpFlow clears delete flow state', () {
      final notifier = readNotifier();
      notifier.state = notifier.state.copyWith(
        otpFlow: AuthOtpFlow.deleteAccount,
        otpPhone: '9539886342',
        resendCountdown: 30,
      );

      notifier.resetOtpFlow();

      final state = container.read(authNotifierProvider);
      expect(state.otpFlow, AuthOtpFlow.login);
      expect(state.otpPhone, isNull);
      expect(state.resendCountdown, 0);
    });

    testWidgets('startDeleteAccountOtpFlow requests OTP for session phone',
        (tester) async {
      await pumpTestApp(tester);
      final notifier = readNotifier();
      notifier.state = notifier.state.copyWith(
        authModel: const AuthModel(
          id: 1,
          name: 'Test User',
          phone: '9539886342',
          email: 'test@medpik.com',
          countryCode: '+91',
        ),
      );

      final started = await notifier.startDeleteAccountOtpFlow(
        tester.element(find.text('home')),
      );
      await tester.pump();
      await tester.pump();

      expect(started, isTrue);
      expect(fakeRepo.lastRequestOtpPhone, '9539886342');
      expect(notifier.state.otpFlow, AuthOtpFlow.deleteAccount);
      expect(notifier.state.otpPhone, '9539886342');
      expect(find.text('otp'), findsOneWidget);

      notifier.resetOtpFlow();
      await flushToastTimers(tester);
    });

    testWidgets('startDeleteAccountOtpFlow uses phoneOverride when session phone is empty',
        (tester) async {
      await pumpTestApp(tester);
      final notifier = readNotifier();
      notifier.state = notifier.state.copyWith(
        authModel: const AuthModel(
          id: 1,
          name: 'John K',
          phone: '',
          email: 'test@medpik.com',
        ),
      );

      final started = await notifier.startDeleteAccountOtpFlow(
        tester.element(find.text('home')),
        phoneOverride: '8943936486',
      );
      await tester.pump();
      await tester.pump();

      expect(started, isTrue);
      expect(fakeRepo.lastRequestOtpPhone, '8943936486');
      expect(notifier.state.otpPhone, '8943936486');

      notifier.resetOtpFlow();
      await flushToastTimers(tester);
    });

    testWidgets('verifyOtp in delete flow calls deleteAccount with OTP',
        (tester) async {
      await pumpTestApp(tester);
      final notifier = readNotifier();
      notifier.state = notifier.state.copyWith(
        authModel: const AuthModel(
          id: 1,
          name: 'Test User',
          phone: '9539886342',
          email: 'test@medpik.com',
          countryCode: '+91',
        ),
        otpFlow: AuthOtpFlow.deleteAccount,
        otpPhone: '9539886342',
        isOtpValid: true,
      );
      notifier.otpController.text = '123456';

      await notifier.verifyOtp(tester.element(find.text('home')));
      await tester.pump();
      await flushToastTimers(tester);

      expect(fakeRepo.lastDeletePhone, '9539886342');
      expect(fakeRepo.lastDeleteOtp, '123456');
      expect(container.read(authNotifierProvider).authModel, isNull);
      expect(find.text('login'), findsOneWidget);
    });

    testWidgets(
      'resendOtp in delete flow uses otpPhone instead of phone controller',
      (tester) async {
        await pumpTestApp(tester);
        final notifier = readNotifier();
        notifier.state = notifier.state.copyWith(
          otpFlow: AuthOtpFlow.deleteAccount,
          otpPhone: '9539886342',
          resendCountdown: 0,
        );
        notifier.phoneController.text = '';

        await notifier.resendOtp();
        expect(fakeRepo.lastRequestOtpPhone, '9539886342');
        notifier.resetOtpFlow();
        await flushToastTimers(tester);
      },
    );
  });
}
