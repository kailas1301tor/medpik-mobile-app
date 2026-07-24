// lib/services/onesignal_service.dart
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/utils/helpers/device_platform_helper.dart';
import 'package:medpik/src/auth/notifier/auth_notifier.dart';
import 'package:medpik/src/main/notifier/main_shell_notifier.dart';
import 'package:medpik/src/root/medpik_app.dart';
import 'package:medpik/utils/helpers/common_functions.dart';
import 'package:medpik/utils/routes/route_constants.dart';

part 'onesignal_service.g.dart';

@Riverpod(keepAlive: true)
OneSignalService oneSignalService(Ref ref) => OneSignalService(ref);

final class OneSignalService {
  OneSignalService(this._ref);

  final Ref _ref;
  bool _isInitialized = false;
  bool _isSdkInitialized = false;
  String? _lastLinkedUserId;
  String? _lastBackendRegistrationKey;
  String? _restoredUserId;

  bool get _isSupportedPlatform =>
      !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  Future<void> initialize({String? restoredUserId}) async {
    if (_isInitialized) return;
    _isInitialized = true;
    _restoredUserId = restoredUserId?.trim();

    if (!_isSupportedPlatform) {
      debugPrint('🟨 ONESIGNAL SKIPPED: unsupported platform.');
      return;
    }

    final String appId = AppConstants.oneSignalAppId.trim();
    if (appId.isEmpty) {
      debugPrint('🟨 ONESIGNAL NOT CONFIGURED: ONESIGNAL_APP_ID is empty.');
      return;
    }

    try {
      debugPrint('🟦 ONESIGNAL INIT: appId=$appId');

      if (kDebugMode) {
        await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      } else {
        await OneSignal.Debug.setLogLevel(OSLogLevel.none);
      }

      await OneSignal.initialize(appId);
      _isSdkInitialized = true;

      OneSignal.User.pushSubscription.addObserver((state) {
        final String? subscriptionId = state.current.id?.trim();
        if (subscriptionId == null || subscriptionId.isEmpty) return;
        debugPrint('🟦 ONESIGNAL SUBSCRIPTION READY: $subscriptionId');
        _linkCurrentUser();
      });

      OneSignal.Notifications.addClickListener(_handleNotificationClick);

      OneSignal.Notifications.addForegroundWillDisplayListener(
        (OSNotificationWillDisplayEvent event) {
          event.notification.display();
        },
      );

      await _requestPermission();
      await refreshDeviceRegistration();
      debugPrint('🟢 ONESIGNAL INITIALIZED');
    } on MissingPluginException catch (e) {
      _isSdkInitialized = false;
      debugPrint(
        '🔴 ONESIGNAL NATIVE PLUGIN MISSING: $e\n'
        'Stop the app, run `cd ios && pod install`, then rebuild with '
        '`flutter run` (hot restart is not enough after adding plugins).',
      );
    } catch (e) {
      _isSdkInitialized = false;
      debugPrint('🔴 ONESIGNAL INIT ERROR: $e');
    }
  }

  Future<void> refreshDeviceRegistration() async {
    await _linkCurrentUser();
  }

  /// Posts the OneSignal subscription to the backend. Call only after fresh login.
  Future<void> registerDeviceWithBackend() async {
    if (!_isSdkInitialized) {
      debugPrint('🟨 DEVICE REGISTER SKIPPED: OneSignal not initialized.');
      return;
    }

    final String? userId = _currentUserId();
    if (userId == null || userId.isEmpty) {
      debugPrint('🟨 DEVICE REGISTER SKIPPED: no authenticated user.');
      return;
    }

    try {
      String? subscriptionId;
      for (int i = 0; i < 10; i++) {
        subscriptionId = OneSignal.User.pushSubscription.id?.trim();
        if (subscriptionId != null && subscriptionId.isNotEmpty) break;
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }

      if (subscriptionId == null || subscriptionId.isEmpty) {
        debugPrint('🟨 DEVICE REGISTER SKIPPED: subscription id pending.');
        return;
      }

      await _registerDeviceWithBackend(
        userId: userId,
        subscriptionId: subscriptionId,
      );
    } catch (e) {
      debugPrint('🔴 DEVICE REGISTER ERROR: $e');
    }
  }

  Future<void> clearIdentity() async {
    if (!_isSdkInitialized) return;
    try {
      await OneSignal.logout();
      _lastLinkedUserId = null;
      _lastBackendRegistrationKey = null;
      debugPrint('🟢 ONESIGNAL LOGOUT');
    } catch (e) {
      debugPrint('🟨 ONESIGNAL LOGOUT FAILED: $e');
    }
  }

  Future<void> _requestPermission() async {
    if (!_isSdkInitialized) return;

    try {
      await OneSignal.Notifications.requestPermission(false);
    } catch (e) {
      debugPrint('🟨 ONESIGNAL PERMISSION REQUEST FAILED: $e');
    }
  }

  Future<void> _linkCurrentUser() async {
    if (!_isSdkInitialized) return;

    final String? userId = _currentUserId();
    if (userId == null || userId.isEmpty) {
      debugPrint('🟨 ONESIGNAL LINK SKIPPED: no authenticated user.');
      return;
    }

    if (_lastLinkedUserId == userId) return;

    try {
      await OneSignal.login(userId);
      _lastLinkedUserId = userId;
      final String? subscriptionId =
          OneSignal.User.pushSubscription.id?.trim();
      debugPrint(
        '🟢 ONESIGNAL USER LINKED: userId=$userId '
        'subscriptionId=${subscriptionId ?? 'pending'}',
      );
    } catch (e) {
      debugPrint('🔴 ONESIGNAL USER LINK ERROR: $e');
    }
  }

  Future<void> _registerDeviceWithBackend({
    required String userId,
    required String subscriptionId,
  }) async {
    if (!AppConstants.hasSession) {
      debugPrint('🟨 DEVICE REGISTER SKIPPED: no active session.');
      return;
    }

    final String? platform = resolveDevicePlatform();
    if (platform == null) {
      debugPrint('🟨 DEVICE REGISTER SKIPPED: unsupported platform.');
      return;
    }

    final String registrationKey = '$userId:$subscriptionId';
    if (_lastBackendRegistrationKey == registrationKey) return;

    return await _ref
        .read(deviceRepositoryProvider)
        .registerDevice(
          subscriptionId: subscriptionId,
          platform: platform,
        )
        .fold(
          (left) {
            debugPrint('🔴 DEVICE REGISTER API ERROR: ${left.message}');
          },
          (right) {
            _lastBackendRegistrationKey = registrationKey;
            debugPrint('🟢 DEVICE REGISTER API SUCCESS: ${right.message}');
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED DEVICE REGISTER ERROR: $error');
        });
  }

  String? _currentUserId() {
    final authModel = _ref.read(
      authNotifierProvider.select((state) => state.authModel),
    );
    if (authModel != null && authModel.id > 0) {
      return authModel.id.toString();
    }

    final restoredId = _restoredUserId?.trim();
    if (restoredId != null && restoredId.isNotEmpty) {
      return restoredId;
    }

    if (!AppConstants.hasSession) return null;

    return null;
  }

  void _handleNotificationClick(OSNotificationClickEvent event) {
    try {
      final Map<String, dynamic> data =
          (event.notification.additionalData ?? <String, dynamic>{})
              .cast<String, dynamic>();
      final String route = (data['route'] ?? '').toString().trim();
      final String orderId = (data['orderId'] ?? data['order_id'] ?? '')
          .toString()
          .trim();

      final navigator = _ref.read(navigatorKeyProvider).currentState;
      if (navigator == null) {
        debugPrint('🟨 ONESIGNAL CLICK: navigator unavailable.');
        return;
      }

      executeAfterFrame(() {
        navigator.pushNamedAndRemoveUntil(
          RouteConstants.mainScreen,
          (_) => false,
        );

        switch (route) {
          case 'order_detail':
            if (orderId.isNotEmpty) {
              navigator.pushNamed(
                RouteConstants.routeOrderDetailScreen,
                arguments: orderId,
              );
            }
          case 'order_tracking':
            if (orderId.isNotEmpty) {
              navigator.pushNamed(
                RouteConstants.routeTrackingScreen,
                arguments: orderId,
              );
            }
          case 'order_review_bill':
            if (orderId.isNotEmpty) {
              navigator.pushNamed(
                RouteConstants.routeOrderReviewBillScreen,
                arguments: orderId,
              );
            }
          case 'order_review_pay':
            if (orderId.isNotEmpty) {
              navigator.pushNamed(
                RouteConstants.routeOrderReviewPayScreen,
                arguments: orderId,
              );
            }
          case 'notifications':
            navigator.pushNamed(RouteConstants.routeNotificationsScreen);
          case 'orders':
            _ref.read(mainShellNotifierProvider.notifier).setTab(1);
          default:
            if (orderId.isNotEmpty) {
              _ref.read(mainShellNotifierProvider.notifier).setTab(1);
              navigator.pushNamed(
                RouteConstants.routeOrderDetailScreen,
                arguments: orderId,
              );
            } else {
              navigator.pushNamed(RouteConstants.routeNotificationsScreen);
            }
        }
      });
    } catch (e) {
      debugPrint('🟨 ONESIGNAL CLICK HANDLER ERROR: $e');
    }
  }
}
