// lib/services/razorpay_payment_service.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/string_constants.dart';
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

  Future<RazorpayCheckoutResult> openCheckout(
    Map<String, dynamic> options,
  ) async {
    if (_completer != null && !_completer!.isCompleted) {
      return const RazorpayCheckoutResult(
        status: RazorpayCheckoutStatus.error,
        message: Strings.paymentAlreadyInProgress,
      );
    }

    _disposeRazorpay();
    _completer = Completer<RazorpayCheckoutResult>();
    try {
      _razorpay = Razorpay()
        ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess)
        ..on(Razorpay.EVENT_PAYMENT_ERROR, _onError)
        ..on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);

      // Listen for close only — never complete success from analytics
      // (that can race ahead of EVENT_PAYMENT_SUCCESS without a signature).
      _razorpay!.subscribeToAnalyticsEvents(
        const ['checkout.close'],
        _onAnalyticsEvent,
      );

      _razorpay!.open(options);

      final result = await _completer!.future;
      return result;
    } catch (error, stack) {
      debugPrint('🔴 RAZORPAY OPEN ERROR: $error');
      debugPrint('$stack');
      final fallback = RazorpayCheckoutResult(
        status: RazorpayCheckoutStatus.error,
        message: error.toString().trim().isNotEmpty
            ? error.toString()
            : Strings.paymentFailed,
      );
      _complete(fallback);
      return fallback;
    } finally {
      _disposeRazorpay();
    }
  }

  void _onSuccess(PaymentSuccessResponse response) {
    final paymentId = (response.paymentId ?? '').trim();
    final orderId = (response.orderId ?? '').trim();
    final signature = (response.signature ?? '').trim();
    debugPrint('🟢 RAZORPAY SUCCESS: $paymentId');

    if (paymentId.isEmpty || signature.isEmpty) {
      _complete(
        const RazorpayCheckoutResult(
          status: RazorpayCheckoutStatus.error,
          message: Strings.paymentFailed,
        ),
      );
      return;
    }

    _complete(
      RazorpayCheckoutResult(
        status: RazorpayCheckoutStatus.success,
        paymentId: paymentId,
        orderId: orderId,
        signature: signature,
      ),
    );
  }

  void _onError(PaymentFailureResponse response) {
    debugPrint('🔴 RAZORPAY ERROR: ${response.code} ${response.message}');
    final code = response.code;
    final isCancelled = code == Razorpay.PAYMENT_CANCELLED || code == 2;
    final message = (response.message ?? '').trim();
    _complete(
      RazorpayCheckoutResult(
        status: isCancelled
            ? RazorpayCheckoutStatus.cancelled
            : RazorpayCheckoutStatus.error,
        message: message.isNotEmpty
            ? message
            : (isCancelled ? Strings.paymentCancelled : Strings.paymentFailed),
      ),
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    final wallet = (response.walletName ?? '').trim();
    debugPrint(
      '🔵 RAZORPAY EXTERNAL WALLET: ${wallet.isEmpty ? 'unknown' : wallet}. '
      'Waiting for success/error/close. ${Strings.paymentExternalWalletPrompt}',
    );
    // Stay in-progress — wallet flows usually continue to success/error/close.
    // checkout.close is what unblocks the loader if the user abandons.
  }

  void _onAnalyticsEvent(String payloadJson) {
    debugPrint('🔵 RAZORPAY ANALYTICS: $payloadJson');
    if (_completer == null || _completer!.isCompleted) return;

    try {
      final payload = convertToMap(jsonDecode(payloadJson));
      final event = convertToString(payload['event']).toLowerCase();
      if (event == 'checkout.close') {
        _complete(
          const RazorpayCheckoutResult(
            status: RazorpayCheckoutStatus.cancelled,
            message: Strings.paymentCancelled,
          ),
        );
      }
    } catch (error) {
      debugPrint('🔴 RAZORPAY ANALYTICS PARSE ERROR: $error');
    }
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
          message: Strings.paymentCancelled,
        ),
      );
    }
    _completer = null;
  }
}
