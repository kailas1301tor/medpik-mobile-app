// lib/services/razorpay_payment_service.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  Future<RazorpayCheckoutResult> openCheckout(Map<String, dynamic> options) {
    _ensureInitialized();

    if (_completer != null && !_completer!.isCompleted) {
      return Future.error(StateError('Razorpay checkout already in progress'));
    }

    _completer = Completer<RazorpayCheckoutResult>();
    _razorpay!.open(options);
    return _completer!.future;
  }

  void _ensureInitialized() {
    if (_razorpay != null) return;

    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _onError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
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

  void _complete(RazorpayCheckoutResult result) {
    final completer = _completer;
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
    _completer = null;
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;

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
