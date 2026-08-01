// lib/services/razorpay_payment_service.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

part 'razorpay_payment_service.g.dart';

enum RazorpayCheckoutStatus { success, cancelled, error }

class RazorpayCheckoutResult {
  const RazorpayCheckoutResult({
    required this.status,
    this.paymentId = '',
    this.orderId = '',
    this.signature = '',
    this.message = '',
  });

  final RazorpayCheckoutStatus status;
  final String paymentId;
  final String orderId;
  final String signature;
  final String message;

  bool get isSuccess => status == RazorpayCheckoutStatus.success;
  bool get isCancelled => status == RazorpayCheckoutStatus.cancelled;
}

@Riverpod(keepAlive: true)
RazorpayPaymentService razorpayPaymentService(Ref ref) {
  final service = RazorpayPaymentService();
  ref.onDispose(service.dispose);
  return service;
}

class RazorpayPaymentService {
  Razorpay? _razorpay;
  Completer<RazorpayCheckoutResult>? _completer;

  Future<RazorpayCheckoutResult> openCheckout(Map<String, dynamic> options) async {
    if (_completer != null && !_completer!.isCompleted) {
      return Future.error(StateError('Razorpay checkout already in progress'));
    }

    _disposeRazorpay();
    _completer = Completer<RazorpayCheckoutResult>();
    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _onError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);

    _razorpay!.subscribeToAnalyticsEvents(
      const ['payment.success', 'payment.failed', 'checkout.close'],
      _onAnalyticsEvent,
    );

    _razorpay!.open(options);

    final result = await _completer!.future;
    _disposeRazorpay();
    return result;
  }

  void _onSuccess(PaymentSuccessResponse response) {
    debugPrint('🟢 RAZORPAY SUCCESS: ${response.paymentId}');
    _complete(
      RazorpayCheckoutResult(
        status: RazorpayCheckoutStatus.success,
        paymentId: response.paymentId ?? '',
        orderId: response.orderId ?? '',
        signature: response.signature ?? '',
      ),
    );
  }

  void _onError(PaymentFailureResponse response) {
    debugPrint('🔴 RAZORPAY ERROR: ${response.code} ${response.message}');
    final code = response.code;
    final isCancelled = code == Razorpay.PAYMENT_CANCELLED || code == 2;
    _complete(
      RazorpayCheckoutResult(
        status: isCancelled
            ? RazorpayCheckoutStatus.cancelled
            : RazorpayCheckoutStatus.error,
        message: response.message ?? '',
      ),
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    debugPrint('🔵 RAZORPAY EXTERNAL WALLET: ${response.walletName}');
  }

  void _onAnalyticsEvent(String payloadJson) {
    debugPrint('🔵 RAZORPAY ANALYTICS: $payloadJson');
    if (_completer == null || _completer!.isCompleted) return;

    try {
      final payload = convertToMap(jsonDecode(payloadJson));
      final event = convertToString(payload['event']).toLowerCase();
      if (event == 'payment.success') {
        _complete(_parseSuccessPayload(payload));
        return;
      }
      if (event == 'payment.failed') {
        final data = convertToMap(payload['data'] ?? payload);
        _complete(
          RazorpayCheckoutResult(
            status: RazorpayCheckoutStatus.error,
            message: convertToString(data['description'] ?? data['message']),
          ),
        );
      }
    } catch (error) {
      debugPrint('🔴 RAZORPAY ANALYTICS PARSE ERROR: $error');
    }
  }

  RazorpayCheckoutResult _parseSuccessPayload(Map<String, dynamic> payload) {
    final data = convertToMap(payload['data'] ?? payload);
    final paymentEntity = convertToMap(data['payment'] ?? data);
    return RazorpayCheckoutResult(
      status: RazorpayCheckoutStatus.success,
      paymentId: convertToString(
        paymentEntity['id'] ??
            data['razorpay_payment_id'] ??
            data['payment_id'],
      ),
      orderId: convertToString(
        data['razorpay_order_id'] ?? data['order_id'],
      ),
      signature: convertToString(
        data['razorpay_signature'] ?? data['signature'],
      ),
    );
  }

  void _complete(RazorpayCheckoutResult result) {
    final completer = _completer;
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
    _completer = null;
  }

  void _disposeRazorpay() {
    _razorpay?.clear();
    _razorpay = null;
  }

  void dispose() {
    _disposeRazorpay();

    final completer = _completer;
    if (completer != null && !completer.isCompleted) {
      completer.complete(
        const RazorpayCheckoutResult(
          status: RazorpayCheckoutStatus.cancelled,
          message: 'Payment cancelled',
        ),
      );
    }
    _completer = null;
  }
}
